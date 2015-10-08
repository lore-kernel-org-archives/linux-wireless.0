Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62357 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbbJHQQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 12:16:11 -0400
From: Jeff Johnson <jjohnson@qca.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Jeff Johnson <jjohnson@qca.qualcomm.com>
Subject: [PATCH] ath10k: Cleanup ath10k_mac_register() error handling
Date: Thu,  8 Oct 2015 09:15:53 -0700
Message-Id: <1444320953-2154-1-git-send-email-jjohnson@qca.qualcomm.com> (sfid-20151008_181614_592846_AD7E9CE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The logic in the error-handling path of ath10k_mac_register() is
divergent from the logic in ath10k_mac_unregister().  Update the
ath10k_mac_register() error handling logic to align with the
ath10k_mac_unregister() logic.

Signed-off-by: Jeff Johnson <jjohnson@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 79490ad..a37aad3c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7301,7 +7301,7 @@ int ath10k_mac_register(struct ath10k *ar)
 			    ath10k_reg_notifier);
 	if (ret) {
 		ath10k_err(ar, "failed to initialise regulatory: %i\n", ret);
-		goto err_free;
+		goto err_dfs_detector_exit;
 	}
 
 	ar->hw->wiphy->cipher_suites = cipher_suites;
@@ -7310,7 +7310,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath10k_err(ar, "failed to register ieee80211: %d\n", ret);
-		goto err_free;
+		goto err_dfs_detector_exit;
 	}
 
 	if (!ath_is_world_regd(&ar->ath_common.regulatory)) {
@@ -7324,10 +7324,16 @@ int ath10k_mac_register(struct ath10k *ar)
 
 err_unregister:
 	ieee80211_unregister_hw(ar->hw);
+
+err_dfs_detector_exit:
+	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector)
+		ar->dfs_detector->exit(ar->dfs_detector);
+
 err_free:
 	kfree(ar->mac.sbands[IEEE80211_BAND_2GHZ].channels);
 	kfree(ar->mac.sbands[IEEE80211_BAND_5GHZ].channels);
 
+	SET_IEEE80211_DEV(ar->hw, NULL);
 	return ret;
 }
 
-- 
1.8.5.2

