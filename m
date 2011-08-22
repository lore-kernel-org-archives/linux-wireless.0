Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1HVPKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 11:10:11 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH 1/3] ath6kl: Remove unused meta_v2 from ath6kl_data_tx()
Date: Mon, 22 Aug 2011 20:40:20 +0530
Message-ID: <1314025822-8004-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110822_171019_577185_B7790E3B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index ba33370..fffd929 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -239,7 +239,6 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	u16 htc_tag = ATH6KL_DATA_PKT_TAG;
 	u8 ac = 99 ; /* initialize to unmapped ac */
 	bool chk_adhoc_ps_mapping = false, more_data = false;
-	struct wmi_tx_meta_v2 meta_v2;
 	int ret;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
@@ -262,8 +261,6 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
-		memset(&meta_v2, 0, sizeof(meta_v2));
-
 		if (skb_headroom(skb) < dev->needed_headroom) {
 			WARN_ON(1);
 			goto fail_tx;
-- 
1.7.0.4

