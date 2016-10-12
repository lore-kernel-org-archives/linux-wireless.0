Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13590 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbcJLH3U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 03:29:20 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix failure to send NULL func frame for 10.4
Date: Wed, 12 Oct 2016 12:59:02 +0530
Message-ID: <1476257342-3241-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161012_092943_702754_0D851692)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

This partially reverts 'commit 2cdce425aa33
("ath10k: Fix broken NULL func data frame status for 10.4")'
Unfortunately this breaks sending NULL func and the existing
issue of obtaining proper tx status for NULL function will be
fixed. Also update the comments for feature flag added to be
useless and not working

Fixes: 2cdce425aa33 "ath10k: Fix broken NULL func data frame status for
10.4"
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 6 ++----
 drivers/net/wireless/ath/ath10k/mac.c  | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b367e9c..42c3f1b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -552,10 +552,8 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_BTCOEX_PARAM = 14,
 
-	/* Older firmware with HTT delivers incorrect tx status for null func
-	 * frames to driver, but this fixed in 10.2 and 10.4 firmware versions.
-	 * Also this workaround results in reporting of incorrect null func
-	 * status for 10.4. This flag is used to skip the workaround.
+	/* Unused flag and proven to be not working, enable this if you want
+	 * to experiment sending NULL func data frames in HTT TX
 	 */
 	ATH10K_FW_FEATURE_SKIP_NULL_FUNC_WAR = 15,
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4565321..86a6610 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3255,8 +3255,6 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 	if (ar->htt.target_version_major < 3 &&
 	    (ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
 	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
-		      ar->running_fw->fw_file.fw_features) &&
-	    !test_bit(ATH10K_FW_FEATURE_SKIP_NULL_FUNC_WAR,
 		      ar->running_fw->fw_file.fw_features))
 		return ATH10K_HW_TXRX_MGMT;
 
-- 
1.9.1
