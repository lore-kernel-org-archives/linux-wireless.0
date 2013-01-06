Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48700 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3AFMM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2013 07:12:57 -0500
Received: by mail-ea0-f177.google.com with SMTP id c10so7265092eaa.36
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2013 04:12:56 -0800 (PST)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: [patch net-next] net: use ETHTOOL_FWVERS_LEN instead of ETHTOOL_BUSINFO_LEN for fw_ver strings
Date: Sun,  6 Jan 2013 13:12:51 +0100
Message-Id: <1357474371-30887-1-git-send-email-jiri@resnulli.us> (sfid-20130106_131301_846341_75699536)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h         | 2 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h     | 4 ++--
 include/net/cfg80211.h                        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 05d5ba6..b2f85cb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -783,7 +783,7 @@ static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
 	priv->fw_version_major = be16_to_cpu(cmd_rsp.major);
 	priv->fw_version_minor = be16_to_cpu(cmd_rsp.minor);
 
-	snprintf(hw->wiphy->fw_version, ETHTOOL_BUSINFO_LEN, "%d.%d",
+	snprintf(hw->wiphy->fw_version, sizeof(hw->wiphy->fw_version), "%d.%d",
 		 priv->fw_version_major,
 		 priv->fw_version_minor);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index d1a86b6..715291e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -157,7 +157,7 @@ struct fw_img {
 struct iwl_fw {
 	u32 ucode_ver;
 
-	char fw_version[ETHTOOL_BUSINFO_LEN];
+	char fw_version[ETHTOOL_FWVERS_LEN];
 
 	/* ucode images */
 	struct fw_img img[IWL_UCODE_TYPE_MAX];
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 6678d4b..5ce26cf 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -122,9 +122,9 @@ enum {
 
 struct wl1271_chip {
 	u32 id;
-	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
+	char fw_ver_str[ETHTOOL_FWVERS_LEN];
 	unsigned int fw_ver[NUM_FW_VER];
-	char phy_fw_ver_str[ETHTOOL_BUSINFO_LEN];
+	char phy_fw_ver_str[ETHTOOL_FWVERS_LEN];
 };
 
 #define NUM_TX_QUEUES              4
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8e6a6b7..f78fa19 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2333,7 +2333,7 @@ struct wiphy {
 	u32 rts_threshold;
 	u8 coverage_class;
 
-	char fw_version[ETHTOOL_BUSINFO_LEN];
+	char fw_version[ETHTOOL_FWVERS_LEN];
 	u32 hw_version;
 
 #ifdef CONFIG_PM
-- 
1.8.1

