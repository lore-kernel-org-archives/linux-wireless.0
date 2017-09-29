Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30056 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752131AbdI2Qq3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:29 -0400
Subject: [PATCH] ath10k: check power save support in STA mode through FW IE
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 29 Sep 2017 19:46:18 +0300
Message-ID: <150670357817.24239.7065449335785410650.stgit@potku.adurom.net> (sfid-20170929_200836_396075_4626C0DE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>

Currently ath10k host enables power save support in station mode by
default for all firmwares but Power save for station mode still not supported
in some of the firmware versions. Which results in firmware crash while
issueing multiple scan commands.

Fix this problem by introducing new FW feature flag to check power save
support in firmware and then the firmware image can tell to ath10k that power
save mode is not supported in station mode.

Signed-off-by: Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    1 +
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 drivers/net/wireless/ath/ath10k/mac.c  |    9 +++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a4f635820f35..7cc426c41817 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -377,6 +377,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_BTCOEX_PARAM] = "btcoex-param",
 	[ATH10K_FW_FEATURE_SKIP_NULL_FUNC_WAR] = "skip-null-func-war",
 	[ATH10K_FW_FEATURE_ALLOWS_MESH_BCAST] = "allows-mesh-bcast",
+	[ATH10K_FW_FEATURE_NO_PS] = "no-ps",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 949ebb3e967b..643041ef3271 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -612,6 +612,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_ALLOWS_MESH_BCAST = 16,
 
+	/* Firmware does not support power save in station mode. */
+	ATH10K_FW_FEATURE_NO_PS = 17,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5683f1a5330e..10fb83784832 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8146,8 +8146,13 @@ int ath10k_mac_register(struct ath10k *ar)
 			BIT(NL80211_IFTYPE_P2P_GO);
 
 	ieee80211_hw_set(ar->hw, SIGNAL_DBM);
-	ieee80211_hw_set(ar->hw, SUPPORTS_PS);
-	ieee80211_hw_set(ar->hw, SUPPORTS_DYNAMIC_PS);
+
+	if (!test_bit(ATH10K_FW_FEATURE_NO_PS,
+		      ar->running_fw->fw_file.fw_features)) {
+		ieee80211_hw_set(ar->hw, SUPPORTS_PS);
+		ieee80211_hw_set(ar->hw, SUPPORTS_DYNAMIC_PS);
+	}
+
 	ieee80211_hw_set(ar->hw, MFP_CAPABLE);
 	ieee80211_hw_set(ar->hw, REPORTS_TX_ACK_STATUS);
 	ieee80211_hw_set(ar->hw, HAS_RATE_CONTROL);
