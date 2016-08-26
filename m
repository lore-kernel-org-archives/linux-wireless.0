Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65287 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbcHZIMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:12:10 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH v5] ath10k: Fix broken NULL func data frame status for 10.4
Date: Fri, 26 Aug 2016 13:42:20 +0530
Message-ID: <1472199140-8404-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160826_101217_066429_1E5800C4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Older firmware with HTT delivers incorrect tx status for null func
frames to driver, but this fixed in 10.2 and 10.4 firmware versions.
Also this workaround results in reporting of incorrect null func status
for 10.4. Fix this is by introducing a firmware feature flag for 10.4
so that this workaround is skipped and proper tx status for null func
frames are reported

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[v5 based on the review comments from Michal]

 drivers/net/wireless/ath/ath10k/core.c |    1 +
 drivers/net/wireless/ath/ath10k/core.h |    7 +++++++
 drivers/net/wireless/ath/ath10k/mac.c  |    2 ++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e889829..798b3f8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -304,6 +304,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_MFP_SUPPORT] = "mfp",
 	[ATH10K_FW_FEATURE_PEER_FLOW_CONTROL] = "peer-flow-ctrl",
 	[ATH10K_FW_FEATURE_BTCOEX_PARAM] = "btcoex-param",
+	[ATH10K_FW_FEATURE_SKIP_NULL_FUNC_WAR] = "skip-null-func-war",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 30ae5bf..54e40f3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -551,6 +551,13 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_BTCOEX_PARAM = 14,
 
+	/* Older firmware with HTT delivers incorrect tx status for null func
+	 * frames to driver, but this fixed in 10.2 and 10.4 firmware versions.
+	 * Also this workaround results in reporting of incorrect null func
+	 * status for 10.4. This flag is used to skip the workaround.
+	 */
+	ATH10K_FW_FEATURE_SKIP_NULL_FUNC_WAR = 15,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fb8e38d..7508ef8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3255,6 +3255,8 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 	if (ar->htt.target_version_major < 3 &&
 	    (ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
 	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
+		      ar->running_fw->fw_file.fw_features) &&
+	    !test_bit(ATH10K_FW_FEATURE_SKIP_NULL_FUNC_WAR,
 		      ar->running_fw->fw_file.fw_features))
 		return ATH10K_HW_TXRX_MGMT;
 
-- 
1.7.9.5
