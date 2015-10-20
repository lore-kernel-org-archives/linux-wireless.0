Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35356 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbJTScn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 14:32:43 -0400
Received: by pagq8 with SMTP id q8so1676250pag.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2015 11:32:43 -0700 (PDT)
From: manikanta.pubbisetty@gmail.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>
Subject: [PATCH] ath10k: consolidate if statements in ath10k_wmi_event_mgmt_rx
Date: Tue, 20 Oct 2015 11:32:46 +0530
Message-Id: <1445320966-17024-1-git-send-email-manikanta.pubbisetty@gmail.com> (sfid-20151020_203246_623734_1DE6854E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>

This patch combines several if statements into a single if condition
in WMI management rx handler. Found during code review.

Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6e7d7a7..a9d42ef 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2200,22 +2200,9 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx status %08x\n", rx_status);
 
-	if (test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags)) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
-
-	if (rx_status & WMI_RX_STATUS_ERR_DECRYPT) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
-
-	if (rx_status & WMI_RX_STATUS_ERR_KEY_CACHE_MISS) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
-
-	if (rx_status & WMI_RX_STATUS_ERR_CRC) {
+	if ((test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags)) ||
+	    (rx_stats & (WMI_RX_STATUS_ERR_DECRYPT |
+	    WMI_RX_STATUS_ERR_KEY_CACHE_MISS | WMI_RX_STATUS_ERR_CRC))) {
 		dev_kfree_skb(skb);
 		return 0;
 	}
-- 
1.9.1

