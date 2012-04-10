Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:41667 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758467Ab2DJDHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 23:07:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/5] mwifiex: add support for WPS2.0
Date: Mon,  9 Apr 2012 20:06:56 -0700
Message-Id: <1334027217-23724-5-git-send-email-bzhao@marvell.com> (sfid-20120410_050733_892227_0D3CF49C)
In-Reply-To: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
References: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patches enables setting association request and probe request
IE for station interface. WPS exchange between WPS2.0 AP and mwifiex
STA Enrollee/External Registrar completes successfully.

Tested with wpa_supplicant 1.0 and 2.0 devel.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   21 ++++++++++++++
 drivers/net/wireless/mwifiex/fw.h        |    1 +
 drivers/net/wireless/mwifiex/init.c      |    2 +
 drivers/net/wireless/mwifiex/ioctl.h     |    1 +
 drivers/net/wireless/mwifiex/join.c      |   44 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h      |    2 +
 drivers/net/wireless/mwifiex/sta_ioctl.c |   34 +++++++++++++++++++++++
 7 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index bd07030..01d4d17 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1162,6 +1162,17 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 	priv->user_scan_cfg->num_ssids = request->n_ssids;
 	priv->user_scan_cfg->ssid_list = request->ssids;
 
+	if (request->ie && request->ie_len) {
+		for (i = 0; i < MWIFIEX_MAX_VSIE_NUM; i++) {
+			if (priv->vs_ie[i].mask != MWIFIEX_VSIE_MASK_CLEAR)
+				continue;
+			priv->vs_ie[i].mask = MWIFIEX_VSIE_MASK_SCAN;
+			memcpy(&priv->vs_ie[i].ie, request->ie,
+			       request->ie_len);
+			break;
+		}
+	}
+
 	for (i = 0; i < request->n_channels; i++) {
 		chan = request->channels[i];
 		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
@@ -1179,6 +1190,15 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 	if (mwifiex_set_user_scan_ioctl(priv, priv->user_scan_cfg))
 		return -EFAULT;
 
+	if (request->ie && request->ie_len) {
+		for (i = 0; i < MWIFIEX_MAX_VSIE_NUM; i++) {
+			if (priv->vs_ie[i].mask == MWIFIEX_VSIE_MASK_SCAN) {
+				priv->vs_ie[i].mask = MWIFIEX_VSIE_MASK_CLEAR;
+				memset(&priv->vs_ie[i].ie, 0,
+				       MWIFIEX_MAX_VSIE_LEN);
+			}
+		}
+	}
 	return 0;
 }
 
@@ -1439,6 +1459,7 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 	}
 	wdev->iftype = NL80211_IFTYPE_STATION;
 	wdev->wiphy->max_scan_ssids = 10;
+	wdev->wiphy->max_scan_ie_len = MWIFIEX_MAX_VSIE_LEN;
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				       BIT(NL80211_IFTYPE_ADHOC);
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index bb26114..342f799 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -104,6 +104,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
 #define TLV_TYPE_POWER_GROUP        (PROPRIETARY_TLV_BASE_ID + 84)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
+#define TLV_TYPE_MGMT_IE            (PROPRIETARY_TLV_BASE_ID + 105)
 #define TLV_TYPE_AUTO_DS_PARAM      (PROPRIETARY_TLV_BASE_ID + 113)
 #define TLV_TYPE_PS_PARAM           (PROPRIETARY_TLV_BASE_ID + 114)
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 54bb483..0d55c5b 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -131,6 +131,8 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->wmm_qosinfo = 0;
 	priv->curr_bcn_buf = NULL;
 	priv->curr_bcn_size = 0;
+	priv->wps_ie = NULL;
+	priv->wps_ie_len = 0;
 
 	priv->scan_block = false;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 887a7d9..f0f9552 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -303,6 +303,7 @@ struct mwifiex_ds_misc_subsc_evt {
 
 #define MWIFIEX_MAX_VSIE_LEN       (256)
 #define MWIFIEX_MAX_VSIE_NUM       (8)
+#define MWIFIEX_VSIE_MASK_CLEAR    0x00
 #define MWIFIEX_VSIE_MASK_SCAN     0x01
 #define MWIFIEX_VSIE_MASK_ASSOC    0x02
 #define MWIFIEX_VSIE_MASK_ADHOC    0x04
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index bca8b6d..5189afb 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -225,6 +225,48 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 }
 
 /*
+ * This function appends a WPS IE. It is called from the network join command
+ * preparation routine.
+ *
+ * If the IE buffer has been setup by the application, this routine appends
+ * the buffer as a WPS TLV type to the request.
+ */
+static int
+mwifiex_cmd_append_wps_ie(struct mwifiex_private *priv, u8 **buffer)
+{
+	int retLen = 0;
+	struct mwifiex_ie_types_header ie_header;
+
+	if (!buffer || !*buffer)
+		return 0;
+
+	/*
+	 * If there is a wps ie buffer setup, append it to the return
+	 * parameter buffer pointer.
+	 */
+	if (priv->wps_ie_len) {
+		dev_dbg(priv->adapter->dev, "cmd: append wps ie %d to %p\n",
+			priv->wps_ie_len, *buffer);
+
+		/* Wrap the generic IE buffer with a pass through TLV type */
+		ie_header.type = cpu_to_le16(TLV_TYPE_MGMT_IE);
+		ie_header.len = cpu_to_le16(priv->wps_ie_len);
+		memcpy(*buffer, &ie_header, sizeof(ie_header));
+		*buffer += sizeof(ie_header);
+		retLen += sizeof(ie_header);
+
+		memcpy(*buffer, priv->wps_ie, priv->wps_ie_len);
+		*buffer += priv->wps_ie_len;
+		retLen += priv->wps_ie_len;
+
+	}
+
+	kfree(priv->wps_ie);
+	priv->wps_ie_len = 0;
+	return retLen;
+}
+
+/*
  * This function appends a WAPI IE.
  *
  * This function is called from the network join command preparation routine.
@@ -480,6 +522,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	if (priv->sec_info.wapi_enabled && priv->wapi_ie_len)
 		mwifiex_cmd_append_wapi_ie(priv, &pos);
 
+	if (priv->wps.session_enable && priv->wps_ie_len)
+		mwifiex_cmd_append_wps_ie(priv, &pos);
 
 	mwifiex_cmd_append_generic_ie(priv, &pos);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e601c46..5081da3 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -407,6 +407,8 @@ struct mwifiex_private {
 	struct host_cmd_ds_802_11_key_material aes_key;
 	u8 wapi_ie[256];
 	u8 wapi_ie_len;
+	u8 *wps_ie;
+	u8 wps_ie_len;
 	u8 wmm_required;
 	u8 wmm_enabled;
 	u8 wmm_qosinfo;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 3bdef07..d12ed13 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -997,6 +997,39 @@ static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
 }
 
 /*
+ * IOCTL request handler to set/reset WPS IE.
+ *
+ * The supplied WPS IE is treated as a opaque buffer. Only the first field
+ * is checked to internally enable WPS. If buffer length is zero, the existing
+ * WPS IE is reset.
+ */
+static int mwifiex_set_wps_ie(struct mwifiex_private *priv,
+			       u8 *ie_data_ptr, u16 ie_len)
+{
+	if (ie_len) {
+		priv->wps_ie = kzalloc(MWIFIEX_MAX_VSIE_LEN, GFP_KERNEL);
+		if (!priv->wps_ie)
+			return -ENOMEM;
+		if (ie_len > sizeof(priv->wps_ie)) {
+			dev_dbg(priv->adapter->dev,
+				"info: failed to copy WPS IE, too big\n");
+			kfree(priv->wps_ie);
+			return -1;
+		}
+		memcpy(priv->wps_ie, ie_data_ptr, ie_len);
+		priv->wps_ie_len = ie_len;
+		dev_dbg(priv->adapter->dev, "cmd: Set wps_ie_len=%d IE=%#x\n",
+			priv->wps_ie_len, priv->wps_ie[0]);
+	} else {
+		kfree(priv->wps_ie);
+		priv->wps_ie_len = ie_len;
+		dev_dbg(priv->adapter->dev,
+			"info: Reset wps_ie_len=%d\n", priv->wps_ie_len);
+	}
+	return 0;
+}
+
+/*
  * IOCTL request handler to set WAPI key.
  *
  * This function prepares the correct firmware command and
@@ -1409,6 +1442,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 			priv->wps.session_enable = true;
 			dev_dbg(priv->adapter->dev,
 				"info: WPS Session Enabled.\n");
+			ret = mwifiex_set_wps_ie(priv, ie_data_ptr, ie_len);
 		}
 
 		/* Append the passed data to the end of the
-- 
1.7.0.2

