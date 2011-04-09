Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42226 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1DIFme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 01:42:34 -0400
Received: by iwn34 with SMTP id 34so4026778iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 22:42:33 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19871.62035.829719.402615@gargle.gargle.HOWL>
Date: Sat, 9 Apr 2011 11:14:51 +0530
To: Richard Farina <sidhayn@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: ath9k_htc oddity
In-Reply-To: <4D9FCC70.1020805@gmail.com>
References: <4D9FCC70.1020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> I've been using the ethool -i output a lot recently and have been very 
> much enjoying it, however I've noticed some oddity.  My ath9k_htc card, 
> Ubiquiti Wifistation-EXT, doesn't have good output while using 
> compat-wireless stable 2.6.39-rc1.
> 
> flea scripts # ethtool -i wlan15
> driver: usb
> version: 2.6.37-pentoo-r6-grsec
> firmware-version: N/A
> bus-info: 2-5
> 
> 
> Not only is the driver listed incorrectly, but the firmware-version is 
> not listed at all. Is it just me?

The driver name/bus-info is wrong because the wrong device pointer is used
when registering the wireless device.

The firmware version is N/A because, well, the FW has no version. :)

I have a patch queued up and ethtool show this now:
(This requires a FW update ...)

sujith@atheros-dev ~  $ ethtool -i wlan0
driver: ath9k_htc
version: 2.6.39-rc2-wl
firmware-version: 1.0
bus-info: 1-3:1.0

commit d3ce084bd9ce550d80fc0e92dd91393ca02d3429
Author: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Date:   Wed Apr 6 09:23:50 2011 +0530

    ath9k_htc: Add a WMI command to get the firmware version
    
    Also, update the wiphy information and use the correct
    device pointer when registering. This would fix ethtool.
    
    Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 23094b7..c81b2da 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1035,7 +1035,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	}
 
 	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
-				&hif_dev->udev->dev, hif_dev->device_id,
+				&interface->dev, hif_dev->device_id,
 				hif_dev->udev->product, id->driver_info);
 	if (ret) {
 		ret = -EINVAL;
@@ -1153,7 +1153,7 @@ fail_resume:
 #endif
 
 static struct usb_driver ath9k_hif_usb_driver = {
-	.name = "ath9k_hif_usb",
+	.name = KBUILD_MODNAME,
 	.probe = ath9k_hif_usb_probe,
 	.disconnect = ath9k_hif_usb_disconnect,
 #ifdef CONFIG_PM
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


