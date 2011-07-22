Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28154 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1GVFnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 18/31] ath6kl: Move block_sz and block_mask from ath6kl_device to htc_target
Date: Fri, 22 Jul 2011 08:41:51 +0300
Message-ID: <1311313324-6766-20-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074324_263312_644817BF)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c     |   14 +++++++-------
 drivers/net/wireless/ath/ath6kl/htc.h     |    3 +++
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    8 ++++----
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    2 --
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 1964059..ce5c082 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -181,7 +181,7 @@ static int htc_issue_send(struct htc_target *target, struct htc_packet *packet)
 	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "%s: transmit len : %d (%s)\n",
 		   __func__, send_len, sync ? "sync" : "async");
 
-	padded_len = CALC_TXRX_PADDED_LEN(target->dev, send_len);
+	padded_len = CALC_TXRX_PADDED_LEN(target, send_len);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC_SEND,
 		"DevSendPacket, padded len: %d mbox:0x%X (mode:%s)\n",
@@ -287,7 +287,7 @@ static void htc_tx_pkts_get(struct htc_target *target,
 			"got head pkt:0x%p , queue depth: %d\n",
 			packet, get_queue_depth(&endpoint->txq));
 
-		len = CALC_TXRX_PADDED_LEN(target->dev,
+		len = CALC_TXRX_PADDED_LEN(target,
 					   packet->act_len + HTC_HDR_LENGTH);
 
 		if (htc_check_credits(target, endpoint, &flags,
@@ -365,7 +365,7 @@ static int htc_setup_send_scat_list(struct htc_target *target,
 			break;
 
 		packet = list_first_entry(queue, struct htc_packet, list);
-		len = CALC_TXRX_PADDED_LEN(target->dev,
+		len = CALC_TXRX_PADDED_LEN(target,
 					   packet->act_len + HTC_HDR_LENGTH);
 
 		cred_pad = htc_get_credit_padding(target->tgt_cred_sz,
@@ -904,7 +904,7 @@ static int dev_rx_pkt(struct htc_target *target, struct htc_packet *packet,
 	u32 padded_len;
 	int status;
 
-	padded_len = CALC_TXRX_PADDED_LEN(dev, rx_len);
+	padded_len = CALC_TXRX_PADDED_LEN(target, rx_len);
 
 	if (padded_len > packet->buf_len) {
 		ath6kl_err("not enough receive space for packet - padlen:%d recvlen:%d bufferlen:%d\n",
@@ -972,7 +972,7 @@ static int htc_setup_rxpkts(struct htc_target *target, struct htc_endpoint *ep,
 	int status = 0, j, full_len;
 	bool no_recycle;
 
-	full_len = CALC_TXRX_PADDED_LEN(target->dev,
+	full_len = CALC_TXRX_PADDED_LEN(target,
 					le16_to_cpu(htc_hdr->payld_len) +
 					sizeof(*htc_hdr));
 
@@ -1571,7 +1571,7 @@ static int htc_issue_rxpkt_bundle(struct htc_target *target,
 		packet = list_first_entry(rxq, struct htc_packet, list);
 		list_del(&packet->list);
 
-		pad_len = CALC_TXRX_PADDED_LEN(target->dev,
+		pad_len = CALC_TXRX_PADDED_LEN(target,
 						   packet->act_len);
 
 		if ((rem_space - pad_len) < 0) {
@@ -2202,7 +2202,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	if (target->max_rx_bndl_sz)
 		target->rx_bndl_enable = true;
 
-	if ((target->tgt_cred_sz % target->dev->block_sz) != 0) {
+	if ((target->tgt_cred_sz % target->block_sz) != 0) {
 		ath6kl_warn("credit size: %d is not block aligned! Disabling send bundling\n",
 			    target->tgt_cred_sz);
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index a8a76a9..26e6b93 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -530,6 +530,9 @@ struct htc_target {
 	int rx_bndl_enable;
 	int max_rx_bndl_sz;
 	int max_tx_bndl_sz;
+
+	u32 block_sz;
+	u32 block_mask;
 };
 
 void *htc_create(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 386bc28..9904bee 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -615,19 +615,19 @@ int ath6kldev_setup(struct ath6kl_device *dev)
 	 * for SDIO the block size on mailbox 0 is artificially set to 1.
 	 * So we use the block size that is set for the other 3 mailboxes.
 	 */
-	dev->block_sz = dev->ar->mbox_info.block_size;
+	dev->htc_cnxt->block_sz = dev->ar->mbox_info.block_size;
 
 	/* must be a power of 2 */
-	if ((dev->block_sz & (dev->block_sz - 1)) != 0) {
+	if ((dev->htc_cnxt->block_sz & (dev->htc_cnxt->block_sz - 1)) != 0) {
 		WARN_ON(1);
 		goto fail_setup;
 	}
 
 	/* assemble mask, used for padding to a block */
-	dev->block_mask = dev->block_sz - 1;
+	dev->htc_cnxt->block_mask = dev->htc_cnxt->block_sz - 1;
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "block size: %d, mbox addr:0x%X\n",
-		   dev->block_sz, dev->ar->mbox_info.htc_addr);
+		   dev->htc_cnxt->block_sz, dev->ar->mbox_info.htc_addr);
 
 	ath6kl_dbg(ATH6KL_DBG_TRC,
 		   "hif interrupt processing is sync only\n");
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 024f2b6..cf5bee0 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -79,8 +79,6 @@ struct ath6kl_device {
 	u8 pad2[A_CACHE_LINE_PAD];
 	struct ath6kl_irq_enable_reg irq_en_reg;
 	u8 pad3[A_CACHE_LINE_PAD];
-	u32 block_sz;
-	u32 block_mask;
 	struct htc_target *htc_cnxt;
 	struct hif_dev_scat_sup_info hif_scat_info;
 	int chk_irq_status_cnt;
-- 
1.7.1

