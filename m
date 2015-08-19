Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36692 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbbHSLKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 07:10:17 -0400
Received: by lagz9 with SMTP id z9so685263lag.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 04:10:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix dma_mapping_error() handling
Date: Wed, 19 Aug 2015 13:10:43 +0200
Message-Id: <1439982643-27031-1-git-send-email-michal.kazior@tieto.com> (sfid-20150819_131023_656797_4C85DA31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function returns 1 when DMA mapping fails. The
driver would return bogus values and could
possibly confuse itself if DMA failed.

Fixes: 767d34fc67af ("ath10k: remove DMA mapping wrappers")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c    | 4 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 8 ++++++--
 drivers/net/wireless/ath/ath10k/pci.c    | 8 ++++++--
 drivers/net/wireless/ath/ath10k/wmi.c    | 1 +
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 85bfa2acb801..32d9ff1b19dc 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -145,8 +145,10 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	skb_cb->eid = eid;
 	skb_cb->paddr = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
 	ret = dma_mapping_error(dev, skb_cb->paddr);
-	if (ret)
+	if (ret) {
+		ret = -EIO;
 		goto err_credits;
+	}
 
 	sg_item.transfer_id = ep->eid;
 	sg_item.transfer_context = skb;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 704bb5e07193..43aa5e2d1b87 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -442,8 +442,10 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
 				       DMA_TO_DEVICE);
 	res = dma_mapping_error(dev, skb_cb->paddr);
-	if (res)
+	if (res) {
+		res = -EIO;
 		goto err_free_txdesc;
+	}
 
 	skb_put(txdesc, len);
 	cmd = (struct htt_cmd *)txdesc->data;
@@ -533,8 +535,10 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
 				       DMA_TO_DEVICE);
 	res = dma_mapping_error(dev, skb_cb->paddr);
-	if (res)
+	if (res) {
+		res = -EIO;
 		goto err_free_txbuf;
+	}
 
 	switch (skb_cb->txmode) {
 	case ATH10K_HW_TXRX_RAW:
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f00b251ec9ce..826220f795c7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1667,8 +1667,10 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 
 	req_paddr = dma_map_single(ar->dev, treq, req_len, DMA_TO_DEVICE);
 	ret = dma_mapping_error(ar->dev, req_paddr);
-	if (ret)
+	if (ret) {
+		ret = -EIO;
 		goto err_dma;
+	}
 
 	if (resp && resp_len) {
 		tresp = kzalloc(*resp_len, GFP_KERNEL);
@@ -1680,8 +1682,10 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 		resp_paddr = dma_map_single(ar->dev, tresp, *resp_len,
 					    DMA_FROM_DEVICE);
 		ret = dma_mapping_error(ar->dev, resp_paddr);
-		if (ret)
+		if (ret) {
+			ret = EIO;
 			goto err_req;
+		}
 
 		xfer.wait_for_resp = true;
 		xfer.resp_len = 0;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 42c0aba04fb2..6ac016dc28f8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3238,6 +3238,7 @@ void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 				ath10k_warn(ar, "failed to map beacon: %d\n",
 					    ret);
 				dev_kfree_skb_any(bcn);
+				ret = -EIO;
 				goto skip;
 			}
 
-- 
2.1.4

