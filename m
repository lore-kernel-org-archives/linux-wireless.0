Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44900 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbaJ2RpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:09 -0400
Received: by mail-wg0-f50.google.com with SMTP id z12so2430112wgg.23
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 13/34] staging: vt6655: mac80211 conversion: device_tx_srv tx and add report rates
Date: Wed, 29 Oct 2014 17:43:48 +0000
Message-Id: <1414604649-9105-14-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184520_649275_328D80AF)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vnt_int_report_rate reports backs tx rate and is replacment for STAvUpdateTDStatCounter
and BSSvUpdateNodeTxCounter.

Replacing existing code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 166 ++++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 69c98c2..a888c26 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1208,19 +1208,84 @@ bool device_alloc_frag_buf(struct vnt_private *pDevice,
 	return true;
 }
 
+static const u8 fallback_rate0[5][5] = {
+	{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
+	{RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
+	{RATE_36M, RATE_36M, RATE_24M, RATE_18M, RATE_18M},
+	{RATE_48M, RATE_48M, RATE_36M, RATE_24M, RATE_24M},
+	{RATE_54M, RATE_54M, RATE_48M, RATE_36M, RATE_36M}
+};
+
+static const u8 fallback_rate1[5][5] = {
+	{RATE_18M, RATE_18M, RATE_12M, RATE_6M, RATE_6M},
+	{RATE_24M, RATE_24M, RATE_18M, RATE_6M, RATE_6M},
+	{RATE_36M, RATE_36M, RATE_24M, RATE_12M, RATE_12M},
+	{RATE_48M, RATE_48M, RATE_24M, RATE_12M, RATE_12M},
+	{RATE_54M, RATE_54M, RATE_36M, RATE_18M, RATE_18M}
+};
+
+static int vnt_int_report_rate(struct vnt_private *priv,
+			       PDEVICE_TD_INFO context, u8 tsr0, u8 tsr1)
+{
+	struct vnt_tx_fifo_head *fifo_head;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_rate *rate;
+	u16 fb_option;
+	u8 tx_retry = (tsr0 & TSR0_NCR);
+	s8 idx;
+
+	if (!context)
+		return -ENOMEM;
+
+	if (!context->skb)
+		return -EINVAL;
+
+	fifo_head = (struct vnt_tx_fifo_head *)context->buf;
+	fb_option = (le16_to_cpu(fifo_head->fifo_ctl) &
+			(FIFOCTL_AUTO_FB_0 | FIFOCTL_AUTO_FB_1));
+
+	info = IEEE80211_SKB_CB(context->skb);
+	idx = info->control.rates[0].idx;
+
+	if (fb_option && !(tsr1 & TSR1_TERR)) {
+		u8 tx_rate;
+		u8 retry = tx_retry;
+
+		rate = ieee80211_get_tx_rate(priv->hw, info);
+		tx_rate = rate->hw_value - RATE_18M;
+
+		if (retry > 4)
+			retry = 4;
+
+		if (fb_option & FIFOCTL_AUTO_FB_0)
+			tx_rate = fallback_rate0[tx_rate][retry];
+		else if (fb_option & FIFOCTL_AUTO_FB_1)
+			tx_rate = fallback_rate1[tx_rate][retry];
+
+		if (info->band == IEEE80211_BAND_5GHZ)
+			idx = tx_rate - RATE_6M;
+		else
+			idx = tx_rate;
+	}
+
+	ieee80211_tx_info_clear_status(info);
+
+	info->status.rates[0].count = tx_retry;
+
+	if (!(tsr1 & TSR1_TERR)) {
+		info->status.rates[0].idx = idx;
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	}
+
+	return 0;
+}
+
 static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 {
 	PSTxDesc                 pTD;
-	bool bFull = false;
 	int                      works = 0;
 	unsigned char byTsr0;
 	unsigned char byTsr1;
-	unsigned int	uFrameSize, uFIFOHeaderSize;
-	PSTxBufHead              pTxBufHead;
-	struct net_device_stats *pStats = &pDevice->dev->stats;
-	struct sk_buff *skb;
-	unsigned int	uNodeIndex;
-	PSMgmtObject             pMgmt = pDevice->pMgmt;
 
 	for (pTD = pDevice->apTailTD[uIdx]; pDevice->iTDUsed[uIdx] > 0; pTD = pTD->next) {
 		if (pTD->m_td0TD0.f1Owner == OWNED_BY_NIC)
@@ -1234,22 +1299,8 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 		//Only the status of first TD in the chain is correct
 		if (pTD->m_td1TD1.byTCR & TCR_STP) {
 			if ((pTD->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB) != 0) {
-				uFIFOHeaderSize = pTD->pTDInfo->dwHeaderLength;
-				uFrameSize = pTD->pTDInfo->dwReqCount - uFIFOHeaderSize;
-				pTxBufHead = (PSTxBufHead) (pTD->pTDInfo->buf);
-				// Update the statistics based on the Transmit status
-				// now, we DONT check TSR0_CDH
-
-				STAvUpdateTDStatCounter(&pDevice->scStatistic,
-							byTsr0, byTsr1,
-							(unsigned char *)(pTD->pTDInfo->buf + uFIFOHeaderSize),
-							uFrameSize, uIdx);
-
-				BSSvUpdateNodeTxCounter(pDevice,
-							byTsr0, byTsr1,
-							(unsigned char *)(pTD->pTDInfo->buf),
-							uFIFOHeaderSize
-					);
+
+				vnt_int_report_rate(pDevice, pTD->pTDInfo, byTsr0, byTsr1);
 
 				if (!(byTsr1 & TSR1_TERR)) {
 					if (byTsr0 != 0) {
@@ -1257,28 +1308,9 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 							 (int)uIdx, byTsr1,
 							 byTsr0);
 					}
-					if ((pTxBufHead->wFragCtl & FRAGCTL_ENDFRAG) != FRAGCTL_NONFRAG)
-						pDevice->s802_11Counter.TransmittedFragmentCount++;
-
-					pStats->tx_packets++;
-					pStats->tx_bytes += pTD->pTDInfo->skb->len;
 				} else {
 					pr_debug(" Tx[%d] dropped & tsr1[%02X] tsr0[%02X]\n",
 						 (int)uIdx, byTsr1, byTsr0);
-					pStats->tx_errors++;
-					pStats->tx_dropped++;
-				}
-			}
-
-			if ((pTD->pTDInfo->byFlags & TD_FLAGS_PRIV_SKB) != 0) {
-				if (pDevice->bEnableHostapd) {
-					pr_debug("tx call back netif..\n");
-					skb = pTD->pTDInfo->skb;
-					skb->dev = pDevice->apdev;
-					skb_reset_mac_header(skb);
-					skb->pkt_type = PACKET_OTHERHOST;
-					memset(skb->cb, 0, sizeof(skb->cb));
-					netif_rx(skb);
 				}
 			}
 
@@ -1287,47 +1319,14 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 					pr_debug(" Tx[%d] fail has error. tsr1[%02X] tsr0[%02X]\n",
 						 (int)uIdx, byTsr1, byTsr0);
 				}
-
-
-				if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) &&
-				    (pTD->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)) {
-					unsigned short wAID;
-					unsigned char byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
-
-					skb = pTD->pTDInfo->skb;
-					if (BSSDBbIsSTAInNodeDB(pMgmt, (unsigned char *)(skb->data), &uNodeIndex)) {
-						if (pMgmt->sNodeDBTable[uNodeIndex].bPSEnable) {
-							skb_queue_tail(&pMgmt->sNodeDBTable[uNodeIndex].sTxPSQueue, skb);
-							pMgmt->sNodeDBTable[uNodeIndex].wEnQueueCnt++;
-							// set tx map
-							wAID = pMgmt->sNodeDBTable[uNodeIndex].wAID;
-							pMgmt->abyPSTxMap[wAID >> 3] |=  byMask[wAID & 7];
-							pTD->pTDInfo->byFlags &= ~(TD_FLAGS_NETIF_SKB);
-							pr_debug("tx_srv:tx fail re-queue sta index= %d, QueCnt= %d\n",
-								 (int)uNodeIndex,
-								 pMgmt->sNodeDBTable[uNodeIndex].wEnQueueCnt);
-							pStats->tx_errors--;
-							pStats->tx_dropped--;
-						}
-					}
-				}
 			}
 			device_free_tx_buf(pDevice, pTD);
 			pDevice->iTDUsed[uIdx]--;
-		}
-	}
-
-	if (uIdx == TYPE_AC0DMA) {
-		// RESERV_AC0DMA reserved for relay
 
-		if (AVAIL_TD(pDevice, uIdx) < RESERV_AC0DMA) {
-			bFull = true;
-			pr_debug(" AC0DMA is Full = %d\n",
-				 pDevice->iTDUsed[uIdx]);
+			/* Make sure queue is available */
+			if (AVAIL_TD(pDevice, uIdx))
+				ieee80211_wake_queues(pDevice->hw);
 		}
-		if (netif_queue_stopped(pDevice->dev) && !bFull)
-			netif_wake_queue(pDevice->dev);
-
 	}
 
 	pDevice->apTailTD[uIdx] = pTD;
@@ -1360,7 +1359,9 @@ static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
 				 PCI_DMA_TODEVICE);
 	}
 
-	if ((pTDInfo->byFlags & TD_FLAGS_NETIF_SKB) != 0)
+	if (pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)
+		ieee80211_tx_status_irqsafe(pDevice->hw, skb);
+	else
 		dev_kfree_skb_irq(skb);
 
 	pTDInfo->skb_dma = 0;
@@ -2065,8 +2066,11 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 		}
 
 		if (pDevice->dwIsr & ISR_TBTT) {
-			if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
-				if ((pDevice->bUpdateBBVGA) && pDevice->bLinkPass && (pDevice->uCurrRSSI != 0)) {
+			if (pDevice->vif &&
+			    pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
+				if (pDevice->bUpdateBBVGA &&
+				    pDevice->vif->bss_conf.assoc &&
+				    pDevice->uCurrRSSI) {
 					long            ldBm;
 
 					RFvRSSITodBm(pDevice, (unsigned char) pDevice->uCurrRSSI, &ldBm);
-- 
2.1.0

