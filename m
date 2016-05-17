Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36598 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbcEQMp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 08:45:27 -0400
Received: by mail-lb0-f178.google.com with SMTP id h1so5441798lbj.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 05:45:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org, leroi.lists@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT] ath10k: disable wake_tx_queue for older devices
Date: Tue, 17 May 2016 14:47:01 +0200
Message-Id: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com> (sfid-20160517_144532_380303_16BB8FAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some setups suffer performance regressions with
current wake_tx_queue implementation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Hi Roman,

Can you give this patch a try and see if it helps
with your performance problems, please?


 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 24 ++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1379054000f9..44e7c2cd2e9b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -657,6 +657,7 @@ struct ath10k_fw_components {
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
+	struct ieee80211_ops *ops;
 	struct device *dev;
 	u8 mac_addr[ETH_ALEN];
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0e24f9ee8bff..5fa3888afa41 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7396,21 +7396,32 @@ static const struct ieee80211_channel ath10k_5ghz_channels[] = {
 struct ath10k *ath10k_mac_create(size_t priv_size)
 {
 	struct ieee80211_hw *hw;
+	struct ieee80211_ops *ops;
 	struct ath10k *ar;
 
-	hw = ieee80211_alloc_hw(sizeof(struct ath10k) + priv_size, &ath10k_ops);
-	if (!hw)
+	ops = kmemdup(&ath10k_ops, sizeof(ath10k_ops), GFP_KERNEL);
+	if (!ops)
 		return NULL;
 
+	hw = ieee80211_alloc_hw(sizeof(struct ath10k) + priv_size, ops);
+	if (!hw) {
+		kfree(ops);
+		return NULL;
+	}
+
 	ar = hw->priv;
 	ar->hw = hw;
+	ar->ops = ops;
 
 	return ar;
 }
 
 void ath10k_mac_destroy(struct ath10k *ar)
 {
+	struct ieee80211_ops *ops = ar->ops;
+
 	ieee80211_free_hw(ar->hw);
+	kfree(ops);
 }
 
 static const struct ieee80211_iface_limit ath10k_if_limits[] = {
@@ -7838,6 +7849,15 @@ int ath10k_mac_register(struct ath10k *ar)
 			ath10k_warn(ar, "failed to initialise DFS pattern detector\n");
 	}
 
+	/* Current wake_tx_queue implementation imposes a significant
+	 * performance penalty in some setups. The tx scheduling code needs
+	 * more work anyway so disable the wake_tx_queue unless firmware
+	 * supports the pull-push mechanism.
+	 */
+	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
+		      ar->running_fw->fw_file.fw_features))
+		ar->ops->wake_tx_queue = NULL;
+
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
-- 
2.1.4

