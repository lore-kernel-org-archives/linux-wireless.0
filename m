Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53712 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaJ2Roy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:44:54 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so5279060wib.13
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:44:53 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 04/34] staging: vt6655: mac80211 conversion: s_cbFillTxBufHead
Date: Wed, 29 Oct 2014 17:43:39 +0000
Message-Id: <1414604649-9105-5-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184505_627636_B9A0B89B)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Covert to handle mac80211 sk_buff data removing fragmentation processing
via s_vFillFragParameter and calls to vGenerateMACHeader and s_vSWencryption

fragmentation is now handled by mac80211.

There is still more todos with this function when legacy net device code
have been remove from driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 583 ++++--------------------------------------
 1 file changed, 46 insertions(+), 537 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 99ce5a3..b114a60 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -144,7 +144,7 @@ s_vGenerateTxParameter(
 	unsigned int	cbFrameSize,
 	bool bNeedACK,
 	unsigned int	uDMAIdx,
-	PSEthernetHeader psEthHeader,
+	void *psEthHeader,
 	unsigned short wCurrentRate
 );
 
@@ -1176,7 +1176,7 @@ s_vGenerateTxParameter(
 	unsigned int cbFrameSize,
 	bool bNeedACK,
 	unsigned int uDMAIdx,
-	PSEthernetHeader psEthHeader,
+	void *psEthHeader,
 	unsigned short wCurrentRate
 )
 {
@@ -1301,46 +1301,26 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
 		  PSEthernetHeader psEthHeader, unsigned char *pPacket,
 		  bool bNeedEncrypt, PSKeyItem pTransmitKey,
-		  unsigned int uNodeIndex, unsigned int *puMACfragNum)
+		  unsigned int is_pspoll, unsigned int *puMACfragNum)
 {
-	unsigned int cbMACHdLen;
+	PDEVICE_TD_INFO td_info = pHeadTD->pTDInfo;
+	struct sk_buff *skb = td_info->skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct vnt_tx_fifo_head *tx_buffer_head =
+			(struct vnt_tx_fifo_head *)td_info->buf;
+	u16 fifo_ctl = le16_to_cpu(tx_buffer_head->fifo_ctl);
 	unsigned int cbFrameSize;
-	unsigned int cbFragmentSize; //Hdr+(IV)+payoad+(MIC)+(ICV)+FCS
-	unsigned int cbFragPayloadSize;
-	unsigned int cbLastFragmentSize; //Hdr+(IV)+payoad+(MIC)+(ICV)+FCS
-	unsigned int cbLastFragPayloadSize;
-	unsigned int uFragIdx;
-	unsigned char *pbyPayloadHead;
-	unsigned char *pbyIVHead;
-	unsigned char *pbyMacHdr;
-	unsigned short wFragType; //00:Non-Frag, 01:Start, 10:Mid, 11:Last
 	__le16 uDuration;
 	unsigned char *pbyBuffer;
-	unsigned int cbIVlen = 0;
-	unsigned int cbICVlen = 0;
-	unsigned int cbMIClen = 0;
-	unsigned int cbFCSlen = 4;
-	unsigned int cb802_1_H_len = 0;
 	unsigned int uLength = 0;
-	unsigned int uTmpLen = 0;
 	unsigned int cbMICHDR = 0;
-	u32 dwMICKey0, dwMICKey1;
-	u32 dwMIC_Priority;
-	u32 *pdwMIC_L;
-	u32 *pdwMIC_R;
-	u32 dwSafeMIC_L, dwSafeMIC_R; /* Fix "Last Frag Size" < "MIC length". */
-	bool bMIC2Frag = false;
-	unsigned int uMICFragLen = 0;
 	unsigned int uMACfragNum = 1;
 	unsigned int uPadding = 0;
 	unsigned int cbReqCount = 0;
-
-	bool bNeedACK;
-	bool bRTS;
-	bool bIsAdhoc;
-	unsigned char *pbyType;
+	bool bNeedACK = (bool)(fifo_ctl & FIFOCTL_NEEDACK);
+	bool bRTS = (bool)(fifo_ctl & FIFOCTL_RTS);
 	PSTxDesc       ptdCurr;
-	PSTxBufHead    psTxBufHd = (PSTxBufHead) pbyTxBufferAddr;
 	unsigned int cbHeaderLength = 0;
 	void *pvRrvTime;
 	struct vnt_mic_hdr *pMICHDR;
@@ -1348,72 +1328,35 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	void *pvCTS;
 	void *pvTxDataHd;
 	unsigned short wTxBufSize;   // FFinfo size
-	unsigned int uTotalCopyLength = 0;
 	unsigned char byFBOption = AUTO_FB_NONE;
-	bool bIsWEP256 = false;
-	PSMgmtObject    pMgmt = pDevice->pMgmt;
 
 	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 
-	if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
-	    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
-		if (is_multicast_ether_addr(&(psEthHeader->abyDstAddr[0])))
-			bNeedACK = false;
-		else
-			bNeedACK = true;
-		bIsAdhoc = true;
-	} else {
-		// MSDUs in Infra mode always need ACK
-		bNeedACK = true;
-		bIsAdhoc = false;
-	}
-
-	if (pDevice->bLongHeader)
-		cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
-	else
-		cbMACHdLen = WLAN_HDR_ADDR3_LEN;
+	cbFrameSize = skb->len + 4;
 
-	if ((bNeedEncrypt == true) && (pTransmitKey != NULL)) {
-		if (pTransmitKey->byCipherSuite == KEY_CTL_WEP) {
-			cbIVlen = 4;
-			cbICVlen = 4;
-			if (pTransmitKey->uKeyLength == WLAN_WEP232_KEYLEN)
-				bIsWEP256 = true;
-		}
-		if (pTransmitKey->byCipherSuite == KEY_CTL_TKIP) {
-			cbIVlen = 8;//IV+ExtIV
-			cbMIClen = 8;
-			cbICVlen = 4;
-		}
-		if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
-			cbIVlen = 8;//RSN Header
-			cbICVlen = 8;//MIC
+	if (info->control.hw_key) {
+		switch (info->control.hw_key->cipher) {
+		case WLAN_CIPHER_SUITE_CCMP:
 			cbMICHDR = sizeof(struct vnt_mic_hdr);
+		default:
+			break;
 		}
+
+		cbFrameSize += info->control.hw_key->icv_len;
+
 		if (pDevice->byLocalID > REV_ID_VT3253_A1) {
 			//MAC Header should be padding 0 to DW alignment.
-			uPadding = 4 - (cbMACHdLen%4);
+			uPadding = 4 - (ieee80211_get_hdrlen_from_skb(skb) % 4);
 			uPadding %= 4;
 		}
 	}
 
-	cbFrameSize = cbMACHdLen + cbIVlen + (cbFrameBodySize + cbMIClen) + cbICVlen + cbFCSlen;
-
-	if ((bNeedACK == false) ||
-	    (cbFrameSize < pDevice->wRTSThreshold) ||
-	    ((cbFrameSize >= pDevice->wFragmentationThreshold) && (pDevice->wFragmentationThreshold <= pDevice->wRTSThreshold))
-) {
-		bRTS = false;
-	} else {
-		bRTS = true;
-		psTxBufHd->wFIFOCtl |= (FIFOCTL_RTS | FIFOCTL_LRETRY);
-	}
 	//
 	// Use for AUTO FALL BACK
 	//
-	if (psTxBufHd->wFIFOCtl & FIFOCTL_AUTO_FB_0)
+	if (fifo_ctl & FIFOCTL_AUTO_FB_0)
 		byFBOption = AUTO_FB_0;
-	else if (psTxBufHd->wFIFOCtl & FIFOCTL_AUTO_FB_1)
+	else if (fifo_ctl & FIFOCTL_AUTO_FB_1)
 		byFBOption = AUTO_FB_1;
 
 	//////////////////////////////////////////////////////
@@ -1507,471 +1450,37 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 			}
 		} // Auto Fall Back
 	}
-	memset((void *)(pbyTxBufferAddr + wTxBufSize), 0, (cbHeaderLength - wTxBufSize));
-
-//////////////////////////////////////////////////////////////////
-	if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-		if (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
-			dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[16]);
-			dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[20]);
-		} else if ((pTransmitKey->dwKeyIndex & AUTHENTICATOR_KEY) != 0) {
-			dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[16]);
-			dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[20]);
-		} else {
-			dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[24]);
-			dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[28]);
-		}
-		// DO Software Michael
-		MIC_vInit(dwMICKey0, dwMICKey1);
-		MIC_vAppend((unsigned char *)&(psEthHeader->abyDstAddr[0]), 12);
-		dwMIC_Priority = 0;
-		MIC_vAppend((unsigned char *)&dwMIC_Priority, 4);
-		pr_debug("MIC KEY: %X, %X\n", dwMICKey0, dwMICKey1);
-	}
-
-///////////////////////////////////////////////////////////////////
-
-	pbyMacHdr = (unsigned char *)(pbyTxBufferAddr + cbHeaderLength);
-	pbyPayloadHead = (unsigned char *)(pbyMacHdr + cbMACHdLen + uPadding + cbIVlen);
-	pbyIVHead = (unsigned char *)(pbyMacHdr + cbMACHdLen + uPadding);
-
-	if ((cbFrameSize > pDevice->wFragmentationThreshold) && (bNeedACK == true) && (bIsWEP256 == false)) {
-		// Fragmentation
-		// FragThreshold = Fragment size(Hdr+(IV)+fragment payload+(MIC)+(ICV)+FCS)
-		cbFragmentSize = pDevice->wFragmentationThreshold;
-		cbFragPayloadSize = cbFragmentSize - cbMACHdLen - cbIVlen - cbICVlen - cbFCSlen;
-		//FragNum = (FrameSize-(Hdr+FCS))/(Fragment Size -(Hrd+FCS)))
-		uMACfragNum = (unsigned short) ((cbFrameBodySize + cbMIClen) / cbFragPayloadSize);
-		cbLastFragPayloadSize = (cbFrameBodySize + cbMIClen) % cbFragPayloadSize;
-		if (cbLastFragPayloadSize == 0)
-			cbLastFragPayloadSize = cbFragPayloadSize;
-		else
-			uMACfragNum++;
-
-		//[Hdr+(IV)+last fragment payload+(MIC)+(ICV)+FCS]
-		cbLastFragmentSize = cbMACHdLen + cbLastFragPayloadSize + cbIVlen + cbICVlen + cbFCSlen;
-
-		for (uFragIdx = 0; uFragIdx < uMACfragNum; uFragIdx++) {
-			if (uFragIdx == 0) {
-				//=========================
-				//    Start Fragmentation
-				//=========================
-				pr_debug("Start Fragmentation...\n");
-				wFragType = FRAGCTL_STAFRAG;
-
-				//Fill FIFO,RrvTime,RTS,and CTS
-				s_vGenerateTxParameter(pDevice, byPktType, (void *)psTxBufHd, pvRrvTime, pvRTS, pvCTS,
-						       cbFragmentSize, bNeedACK, uDMAIdx, psEthHeader, pDevice->wCurrentRate);
-				//Fill DataHead
-				uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFragmentSize, uDMAIdx, bNeedACK,
-							    uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption, pDevice->wCurrentRate);
-				// Generate TX MAC Header
-				vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
-						   wFragType, uDMAIdx, uFragIdx);
-
-				if (bNeedEncrypt == true) {
-					//Fill TXKEY
-					s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adwTxKey), pbyIVHead, pTransmitKey,
-						     pbyMacHdr, (unsigned short)cbFragPayloadSize, (unsigned char *)pMICHDR);
-					//Fill IV(ExtIV,RSNHDR)
-					if (pDevice->bEnableHostWEP) {
-						pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
-						pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0 = pTransmitKey->wTSC15_0;
-					}
-				}
-
-				// 802.1H
-				if (ntohs(psEthHeader->wType) > ETH_DATA_LEN) {
-					if ((psEthHeader->wType == TYPE_PKT_IPX) ||
-					    (psEthHeader->wType == cpu_to_le16(0xF380))) {
-						memcpy((unsigned char *)(pbyPayloadHead), &pDevice->abySNAP_Bridgetunnel[0], 6);
-					} else {
-						memcpy((unsigned char *)(pbyPayloadHead), &pDevice->abySNAP_RFC1042[0], 6);
-					}
-					pbyType = (unsigned char *)(pbyPayloadHead + 6);
-					memcpy(pbyType, &(psEthHeader->wType), sizeof(unsigned short));
-					cb802_1_H_len = 8;
-				}
 
-				cbReqCount = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen + cbFragPayloadSize;
-				//---------------------------
-				// S/W or H/W Encryption
-				//---------------------------
-				pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
+	td_info->mic_hdr = pMICHDR;
 
-				uLength = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen + cb802_1_H_len;
-				//copy TxBufferHeader + MacHeader to desc
-				memcpy(pbyBuffer, (void *)psTxBufHd, uLength);
-
-				// Copy the Packet into a tx Buffer
-				memcpy((pbyBuffer + uLength), (pPacket + 14), (cbFragPayloadSize - cb802_1_H_len));
-
-				uTotalCopyLength += cbFragPayloadSize - cb802_1_H_len;
-
-				if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-					pr_debug("Start MIC: %d\n",
-						 cbFragPayloadSize);
-					MIC_vAppend((pbyBuffer + uLength - cb802_1_H_len), cbFragPayloadSize);
-
-				}
-
-				//---------------------------
-				// S/W Encryption
-				//---------------------------
-				if ((pDevice->byLocalID <= REV_ID_VT3253_A1)) {
-					if (bNeedEncrypt) {
-						s_vSWencryption(pDevice, pTransmitKey, (pbyBuffer + uLength - cb802_1_H_len), (unsigned short)cbFragPayloadSize);
-						cbReqCount += cbICVlen;
-					}
-				}
-
-				ptdCurr = (PSTxDesc)pHeadTD;
-				//--------------------
-				//1.Set TSR1 & ReqCount in TxDescHead
-				//2.Set FragCtl in TxBufferHead
-				//3.Set Frame Control
-				//4.Set Sequence Control
-				//5.Get S/W generate FCS
-				//--------------------
-				s_vFillFragParameter(pDevice, pbyBuffer, uDMAIdx, (void *)ptdCurr, wFragType, cbReqCount);
-
-				ptdCurr->pTDInfo->dwReqCount = cbReqCount - uPadding;
-				ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
-				ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
-				ptdCurr->buff_addr = cpu_to_le32(ptdCurr->pTDInfo->skb_dma);
-				pDevice->iTDUsed[uDMAIdx]++;
-				pHeadTD = ptdCurr->next;
-			} else if (uFragIdx == (uMACfragNum-1)) {
-				//=========================
-				//    Last Fragmentation
-				//=========================
-				pr_debug("Last Fragmentation...\n");
-
-				wFragType = FRAGCTL_ENDFRAG;
-
-				//Fill FIFO,RrvTime,RTS,and CTS
-				s_vGenerateTxParameter(pDevice, byPktType, (void *)psTxBufHd, pvRrvTime, pvRTS, pvCTS,
-						       cbLastFragmentSize, bNeedACK, uDMAIdx, psEthHeader, pDevice->wCurrentRate);
-				//Fill DataHead
-				uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbLastFragmentSize, uDMAIdx, bNeedACK,
-							    uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption, pDevice->wCurrentRate);
-
-				// Generate TX MAC Header
-				vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
-						   wFragType, uDMAIdx, uFragIdx);
-
-				if (bNeedEncrypt == true) {
-					//Fill TXKEY
-					s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adwTxKey), pbyIVHead, pTransmitKey,
-						     pbyMacHdr, (unsigned short)cbLastFragPayloadSize, (unsigned char *)pMICHDR);
-
-					if (pDevice->bEnableHostWEP) {
-						pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
-						pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0 = pTransmitKey->wTSC15_0;
-					}
-
-				}
-
-				cbReqCount = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen + cbLastFragPayloadSize;
-				//---------------------------
-				// S/W or H/W Encryption
-				//---------------------------
-
-				pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
-
-				uLength = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen;
-
-				//copy TxBufferHeader + MacHeader to desc
-				memcpy(pbyBuffer, (void *)psTxBufHd, uLength);
-
-				// Copy the Packet into a tx Buffer
-				if (bMIC2Frag == false) {
-					memcpy((pbyBuffer + uLength),
-					       (pPacket + 14 + uTotalCopyLength),
-					       (cbLastFragPayloadSize - cbMIClen)
-);
-					//TODO check uTmpLen !
-					uTmpLen = cbLastFragPayloadSize - cbMIClen;
-
-				}
-				if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-					pr_debug("LAST: uMICFragLen:%d, cbLastFragPayloadSize:%d, uTmpLen:%d\n",
-						 uMICFragLen,
-						 cbLastFragPayloadSize,
-						 uTmpLen);
-
-					if (bMIC2Frag == false) {
-						if (uTmpLen != 0)
-							MIC_vAppend((pbyBuffer + uLength), uTmpLen);
-						pdwMIC_L = (u32 *)(pbyBuffer + uLength + uTmpLen);
-						pdwMIC_R = (u32 *)(pbyBuffer + uLength + uTmpLen + 4);
-						MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
-						pr_debug("Last MIC:%X, %X\n",
-							 *pdwMIC_L, *pdwMIC_R);
-					} else {
-						if (uMICFragLen >= 4) {
-							memcpy((pbyBuffer + uLength), ((unsigned char *)&dwSafeMIC_R + (uMICFragLen - 4)),
-							       (cbMIClen - uMICFragLen));
-							pr_debug("LAST: uMICFragLen >= 4: %X, %d\n",
-								 *(unsigned char *)((unsigned char *)&dwSafeMIC_R + (uMICFragLen - 4)),
-								 (cbMIClen - uMICFragLen));
-
-						} else {
-							memcpy((pbyBuffer + uLength), ((unsigned char *)&dwSafeMIC_L + uMICFragLen),
-							       (4 - uMICFragLen));
-							memcpy((pbyBuffer + uLength + (4 - uMICFragLen)), &dwSafeMIC_R, 4);
-							pr_debug("LAST: uMICFragLen < 4: %X, %d\n",
-								 *(unsigned char *)((unsigned char *)&dwSafeMIC_R + uMICFragLen - 4),
-								 (cbMIClen - uMICFragLen));
-						}
-					}
-					MIC_vUnInit();
-				} else {
-					ASSERT(uTmpLen == (cbLastFragPayloadSize - cbMIClen));
-				}
-
-				//---------------------------
-				// S/W Encryption
-				//---------------------------
-				if ((pDevice->byLocalID <= REV_ID_VT3253_A1)) {
-					if (bNeedEncrypt) {
-						s_vSWencryption(pDevice, pTransmitKey, (pbyBuffer + uLength), (unsigned short)cbLastFragPayloadSize);
-						cbReqCount += cbICVlen;
-					}
-				}
-
-				ptdCurr = (PSTxDesc)pHeadTD;
-
-				//--------------------
-				//1.Set TSR1 & ReqCount in TxDescHead
-				//2.Set FragCtl in TxBufferHead
-				//3.Set Frame Control
-				//4.Set Sequence Control
-				//5.Get S/W generate FCS
-				//--------------------
-
-				s_vFillFragParameter(pDevice, pbyBuffer, uDMAIdx, (void *)ptdCurr, wFragType, cbReqCount);
-
-				ptdCurr->pTDInfo->dwReqCount = cbReqCount - uPadding;
-				ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
-				ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
-				ptdCurr->buff_addr = cpu_to_le32(ptdCurr->pTDInfo->skb_dma);
-				pDevice->iTDUsed[uDMAIdx]++;
-				pHeadTD = ptdCurr->next;
-
-			} else {
-				//=========================
-				//    Middle Fragmentation
-				//=========================
-				pr_debug("Middle Fragmentation...\n");
-
-				wFragType = FRAGCTL_MIDFRAG;
-
-				//Fill FIFO,RrvTime,RTS,and CTS
-				s_vGenerateTxParameter(pDevice, byPktType, (void *)psTxBufHd, pvRrvTime, pvRTS, pvCTS,
-						       cbFragmentSize, bNeedACK, uDMAIdx, psEthHeader, pDevice->wCurrentRate);
-				//Fill DataHead
-				uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFragmentSize, uDMAIdx, bNeedACK,
-							    uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption, pDevice->wCurrentRate);
-
-				// Generate TX MAC Header
-				vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
-						   wFragType, uDMAIdx, uFragIdx);
-
-				if (bNeedEncrypt == true) {
-					//Fill TXKEY
-					s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adwTxKey), pbyIVHead, pTransmitKey,
-						     pbyMacHdr, (unsigned short)cbFragPayloadSize, (unsigned char *)pMICHDR);
-
-					if (pDevice->bEnableHostWEP) {
-						pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
-						pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0 = pTransmitKey->wTSC15_0;
-					}
-				}
-
-				cbReqCount = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen + cbFragPayloadSize;
-				//---------------------------
-				// S/W or H/W Encryption
-				//---------------------------
-
-				pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
-				uLength = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen;
-
-				//copy TxBufferHeader + MacHeader to desc
-				memcpy(pbyBuffer, (void *)psTxBufHd, uLength);
-
-				// Copy the Packet into a tx Buffer
-				memcpy((pbyBuffer + uLength),
-				       (pPacket + 14 + uTotalCopyLength),
-				       cbFragPayloadSize
-);
-				uTmpLen = cbFragPayloadSize;
-
-				uTotalCopyLength += uTmpLen;
-
-				if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-					MIC_vAppend((pbyBuffer + uLength), uTmpLen);
-
-					if (uTmpLen < cbFragPayloadSize) {
-						bMIC2Frag = true;
-						uMICFragLen = cbFragPayloadSize - uTmpLen;
-						ASSERT(uMICFragLen < cbMIClen);
-
-						pdwMIC_L = (u32 *)(pbyBuffer + uLength + uTmpLen);
-						pdwMIC_R = (u32 *)(pbyBuffer + uLength + uTmpLen + 4);
-						MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
-						dwSafeMIC_L = *pdwMIC_L;
-						dwSafeMIC_R = *pdwMIC_R;
-
-						pr_debug("MIDDLE: uMICFragLen:%d, cbFragPayloadSize:%d, uTmpLen:%d\n",
-							 uMICFragLen,
-							 cbFragPayloadSize,
-							 uTmpLen);
-						pr_debug("Fill MIC in Middle frag [%d]\n",
-							 uMICFragLen);
-						pr_debug("Get MIC:%X, %X\n",
-							 *pdwMIC_L, *pdwMIC_R);
-					}
-					pr_debug("Middle frag len: %d\n",
-						 uTmpLen);
-
-				} else {
-					ASSERT(uTmpLen == (cbFragPayloadSize));
-				}
-
-				if ((pDevice->byLocalID <= REV_ID_VT3253_A1)) {
-					if (bNeedEncrypt) {
-						s_vSWencryption(pDevice, pTransmitKey, (pbyBuffer + uLength), (unsigned short)cbFragPayloadSize);
-						cbReqCount += cbICVlen;
-					}
-				}
-
-				ptdCurr = (PSTxDesc)pHeadTD;
-
-				//--------------------
-				//1.Set TSR1 & ReqCount in TxDescHead
-				//2.Set FragCtl in TxBufferHead
-				//3.Set Frame Control
-				//4.Set Sequence Control
-				//5.Get S/W generate FCS
-				//--------------------
-
-				s_vFillFragParameter(pDevice, pbyBuffer, uDMAIdx, (void *)ptdCurr, wFragType, cbReqCount);
-
-				ptdCurr->pTDInfo->dwReqCount = cbReqCount - uPadding;
-				ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
-				ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
-				ptdCurr->buff_addr = cpu_to_le32(ptdCurr->pTDInfo->skb_dma);
-				pDevice->iTDUsed[uDMAIdx]++;
-				pHeadTD = ptdCurr->next;
-			}
-		}  // for (uMACfragNum)
-	} else {
-		//=========================
-		//    No Fragmentation
-		//=========================
-		wFragType = FRAGCTL_NONFRAG;
-
-		//Set FragCtl in TxBufferHead
-		psTxBufHd->wFragCtl |= (unsigned short)wFragType;
-
-		//Fill FIFO,RrvTime,RTS,and CTS
-		s_vGenerateTxParameter(pDevice, byPktType, (void *)psTxBufHd, pvRrvTime, pvRTS, pvCTS,
-				       cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, pDevice->wCurrentRate);
-		//Fill DataHead
-		uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
-					    0, 0, uMACfragNum, byFBOption, pDevice->wCurrentRate);
-
-		// Generate TX MAC Header
-		vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
-				   wFragType, uDMAIdx, 0);
-
-		if (bNeedEncrypt == true) {
-			//Fill TXKEY
-			s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adwTxKey), pbyIVHead, pTransmitKey,
-				     pbyMacHdr, (unsigned short)cbFrameBodySize, (unsigned char *)pMICHDR);
-
-			if (pDevice->bEnableHostWEP) {
-				pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
-				pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0 = pTransmitKey->wTSC15_0;
-			}
-		}
-
-		// 802.1H
-		if (ntohs(psEthHeader->wType) > ETH_DATA_LEN) {
-			if ((psEthHeader->wType == TYPE_PKT_IPX) ||
-			    (psEthHeader->wType == cpu_to_le16(0xF380))) {
-				memcpy((unsigned char *)(pbyPayloadHead), &pDevice->abySNAP_Bridgetunnel[0], 6);
-			} else {
-				memcpy((unsigned char *)(pbyPayloadHead), &pDevice->abySNAP_RFC1042[0], 6);
-			}
-			pbyType = (unsigned char *)(pbyPayloadHead + 6);
-			memcpy(pbyType, &(psEthHeader->wType), sizeof(unsigned short));
-			cb802_1_H_len = 8;
-		}
-
-		cbReqCount = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen + (cbFrameBodySize + cbMIClen);
-		//---------------------------
-		// S/W or H/W Encryption
-		//---------------------------
-		pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
-		uLength = cbHeaderLength + cbMACHdLen + uPadding + cbIVlen + cb802_1_H_len;
-
-		//copy TxBufferHeader + MacHeader to desc
-		memcpy(pbyBuffer, (void *)psTxBufHd, uLength);
-
-		// Copy the Packet into a tx Buffer
-		memcpy((pbyBuffer + uLength),
-		       (pPacket + 14),
-		       cbFrameBodySize - cb802_1_H_len
-);
-
-		if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-			pr_debug("Length:%d, %d\n",
-				 cbFrameBodySize - cb802_1_H_len, uLength);
-
-			MIC_vAppend((pbyBuffer + uLength - cb802_1_H_len), cbFrameBodySize);
-
-			pdwMIC_L = (u32 *)(pbyBuffer + uLength - cb802_1_H_len + cbFrameBodySize);
-			pdwMIC_R = (u32 *)(pbyBuffer + uLength - cb802_1_H_len + cbFrameBodySize + 4);
-
-			MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
-			MIC_vUnInit();
-
-			if (pDevice->bTxMICFail == true) {
-				*pdwMIC_L = 0;
-				*pdwMIC_R = 0;
-				pDevice->bTxMICFail = false;
-			}
+	memset((void *)(pbyTxBufferAddr + wTxBufSize), 0, (cbHeaderLength - wTxBufSize));
 
-			pr_debug("uLength: %d, %d\n", uLength, cbFrameBodySize);
-			pr_debug("cbReqCount:%d, %d, %d, %d\n",
-				 cbReqCount, cbHeaderLength, uPadding, cbIVlen);
-			pr_debug("MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
+	/* Fill FIFO,RrvTime,RTS,and CTS */
+	s_vGenerateTxParameter(pDevice, byPktType, tx_buffer_head, pvRrvTime, pvRTS, pvCTS,
+			       cbFrameSize, bNeedACK, uDMAIdx, hdr, pDevice->wCurrentRate);
+	/* Fill DataHead */
+	uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
+				    0, 0, uMACfragNum, byFBOption, pDevice->wCurrentRate);
 
-		}
+	hdr->duration_id = uDuration;
 
-		if ((pDevice->byLocalID <= REV_ID_VT3253_A1)) {
-			if (bNeedEncrypt) {
-				s_vSWencryption(pDevice, pTransmitKey, (pbyBuffer + uLength - cb802_1_H_len),
-						(unsigned short)(cbFrameBodySize + cbMIClen));
-				cbReqCount += cbICVlen;
-			}
-		}
+	cbReqCount = cbHeaderLength + uPadding + cbFrameBodySize;
+	pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
+	uLength = cbHeaderLength + uPadding;
 
-		ptdCurr = (PSTxDesc)pHeadTD;
+	/* Copy the Packet into a tx Buffer */
+	memcpy((pbyBuffer + uLength), pPacket, cbFrameBodySize);
 
-		ptdCurr->pTDInfo->dwReqCount = cbReqCount - uPadding;
-		ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
-		ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
-		ptdCurr->buff_addr = cpu_to_le32(ptdCurr->pTDInfo->skb_dma);
-		//Set TSR1 & ReqCount in TxDescHead
-		ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
-		ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
+	ptdCurr = (PSTxDesc)pHeadTD;
 
-		pDevice->iTDUsed[uDMAIdx]++;
+	ptdCurr->pTDInfo->dwReqCount = cbReqCount - uPadding;
+	ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
+	ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
+	ptdCurr->buff_addr = cpu_to_le32(ptdCurr->pTDInfo->skb_dma);
+	/* Set TSR1 & ReqCount in TxDescHead */
+	ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
+	ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
 
-	}
 	*puMACfragNum = uMACfragNum;
 
 	return cbHeaderLength;
-- 
2.1.0

