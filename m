Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45218 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1DMFu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:50:27 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so275635iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:50:27 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.14899.114710.799408@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:22:51 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 03/40] ath9k_htc: Add a WMI command to get the firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
 version

Also, update the wiphy information and use the correct
device pointer when registering. This would fix ethtool.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    3 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   32 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/wmi.c          |    2 +
 drivers/net/wireless/ath/ath9k/wmi.h          |    6 ++++
 4 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ec47be9..9544cd7 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -388,6 +388,9 @@ struct ath9k_htc_priv {
 	struct htc_target *htc;
 	struct wmi *wmi;
 
+	u16 fw_version_major;
+	u16 fw_version_minor;
+
 	enum htc_endpoint_id wmi_cmd_ep;
 	enum htc_endpoint_id beacon_ep;
 	enum htc_endpoint_id cab_ep;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8303b34..6bbfca5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -782,6 +782,32 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 }
 
+static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
+{
+	struct ieee80211_hw *hw = priv->hw;
+	struct wmi_fw_version cmd_rsp;
+	int ret;
+
+	memset(&cmd_rsp, 0, sizeof(cmd_rsp));
+
+	WMI_CMD(WMI_GET_FW_VERSION);
+	if (ret)
+		return -EINVAL;
+
+	priv->fw_version_major = be16_to_cpu(cmd_rsp.major);
+	priv->fw_version_minor = be16_to_cpu(cmd_rsp.minor);
+
+	snprintf(hw->wiphy->fw_version, ETHTOOL_BUSINFO_LEN, "%d.%d",
+		 priv->fw_version_major,
+		 priv->fw_version_minor);
+
+	dev_info(priv->dev, "ath9k_htc: FW Version: %d.%d\n",
+		 priv->fw_version_major,
+		 priv->fw_version_minor);
+
+	return 0;
+}
+
 static int ath9k_init_device(struct ath9k_htc_priv *priv,
 			     u16 devid, char *product, u32 drv_info)
 {
@@ -801,6 +827,10 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	common = ath9k_hw_common(ah);
 	ath9k_set_hw_capab(priv, hw);
 
+	error = ath9k_init_firmware_version(priv);
+	if (error != 0)
+		goto err_fw;
+
 	/* Initialize regulatory */
 	error = ath_regd_init(&common->regulatory, priv->hw->wiphy,
 			      ath9k_reg_notifier);
@@ -861,6 +891,8 @@ err_rx:
 err_tx:
 	/* Nothing */
 err_regd:
+	/* Nothing */
+err_fw:
 	ath9k_deinit_priv(priv);
 err_init:
 	return error;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index d3d2490..267a98f 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -23,6 +23,8 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_ECHO_CMDID";
 	case WMI_ACCESS_MEMORY_CMDID:
 		return "WMI_ACCESS_MEMORY_CMDID";
+	case WMI_GET_FW_VERSION:
+		return "WMI_GET_FW_VERSION";
 	case WMI_DISABLE_INTR_CMDID:
 		return "WMI_DISABLE_INTR_CMDID";
 	case WMI_ENABLE_INTR_CMDID:
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 4208427..6a36572 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -31,11 +31,17 @@ struct wmi_cmd_hdr {
 	__be16 seq_no;
 } __packed;
 
+struct wmi_fw_version {
+	__be16 major;
+	__be16 minor;
+
+} __packed;
 enum wmi_cmd_id {
 	WMI_ECHO_CMDID = 0x0001,
 	WMI_ACCESS_MEMORY_CMDID,
 
 	/* Commands to Target */
+	WMI_GET_FW_VERSION,
 	WMI_DISABLE_INTR_CMDID,
 	WMI_ENABLE_INTR_CMDID,
 	WMI_RX_LINK_CMDID,
-- 
1.7.4.4

