Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:37736 "HELO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751201Ab2DQEhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 00:37:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: code cleanup in BSS handling
Date: Mon, 16 Apr 2012 21:36:51 -0700
Message-Id: <1334637412-4786-1-git-send-email-bzhao@marvell.com> (sfid-20120417_063750_583140_C748CC6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Rearrange some code to save extra parameters to the functions.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h      |    7 +---
 drivers/net/wireless/mwifiex/scan.c      |   41 ++++++-------------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |   47 ++++++++++++------------------
 3 files changed, 31 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 46c298e..fa8af58 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -953,13 +953,10 @@ int mwifiex_bss_set_channel(struct mwifiex_private *,
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
-			      u8 *bssid, s32 rssi, u8 *ie_buf,
-			      size_t ie_len, u16 beacon_period,
-			      u16 cap_info_bitmap, u8 band,
+			      struct cfg80211_bss *bss,
 			      struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
-				struct mwifiex_bssdescriptor *bss_entry,
-				u8 *ie_buf, u32 ie_len);
+				    struct mwifiex_bssdescriptor *bss_entry);
 int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 					struct mwifiex_bssdescriptor *bss_desc);
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ef84a1a..f6bec2f 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1048,10 +1048,8 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
  * This function parses provided beacon buffer and updates
  * respective fields in bss descriptor structure.
  */
-int
-mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
-				struct mwifiex_bssdescriptor *bss_entry,
-				u8 *ie_buf, u32 ie_len)
+int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
+				    struct mwifiex_bssdescriptor *bss_entry)
 {
 	int ret = 0;
 	u8 element_id;
@@ -1073,10 +1071,8 @@ mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 	found_data_rate_ie = false;
 	rate_size = 0;
-	current_ptr = ie_buf;
-	bytes_left = ie_len;
-	bss_entry->beacon_buf = ie_buf;
-	bss_entry->beacon_buf_size = ie_len;
+	current_ptr = bss_entry->beacon_buf;
+	bytes_left = bss_entry->beacon_buf_size;
 
 	/* Process variable IE */
 	while (bytes_left >= 2) {
@@ -1447,15 +1443,12 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 	return ret;
 }
 
-static int
-mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
-			       s32 rssi, const u8 *ie_buf, size_t ie_len,
-			       u16 beacon_period, u16 cap_info_bitmap, u8 band)
+static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
+					  struct cfg80211_bss *bss)
 {
 	struct mwifiex_bssdescriptor *bss_desc;
 	int ret;
 	unsigned long flags;
-	u8 *beacon_ie;
 
 	/* Allocate and fill new bss descriptor */
 	bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),
@@ -1465,16 +1458,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
 		return -ENOMEM;
 	}
 
-	beacon_ie = kmemdup(ie_buf, ie_len, GFP_KERNEL);
-	if (!beacon_ie) {
-		kfree(bss_desc);
-		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
-		return -ENOMEM;
-	}
-
-	ret = mwifiex_fill_new_bss_desc(priv, bssid, rssi, beacon_ie,
-					ie_len, beacon_period,
-					cap_info_bitmap, band, bss_desc);
+	ret = mwifiex_fill_new_bss_desc(priv, bss, bss_desc);
 	if (ret)
 		goto done;
 
@@ -1514,7 +1498,6 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
 
 done:
 	kfree(bss_desc);
-	kfree(beacon_ie);
 	return 0;
 }
 
@@ -1744,17 +1727,13 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					      cap_info_bitmap, beacon_period,
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
 				*(u8 *)bss->priv = band;
-				cfg80211_put_bss(bss);
-
 				if (priv->media_connected &&
 				    !memcmp(bssid,
 					    priv->curr_bss_params.bss_descriptor
 					    .mac_address, ETH_ALEN))
-					mwifiex_update_curr_bss_params
-							(priv, bssid, rssi,
-							 ie_buf, ie_len,
-							 beacon_period,
-							 cap_info_bitmap, band);
+					mwifiex_update_curr_bss_params(priv,
+								       bss);
+				cfg80211_put_bss(bss);
 			}
 		} else {
 			dev_dbg(adapter->dev, "missing BSS channel IE\n");
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index d12ed13..f80622b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -155,20 +155,26 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
  * information.
  */
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
-			      u8 *bssid, s32 rssi, u8 *ie_buf,
-			      size_t ie_len, u16 beacon_period,
-			      u16 cap_info_bitmap, u8 band,
+			      struct cfg80211_bss *bss,
 			      struct mwifiex_bssdescriptor *bss_desc)
 {
 	int ret;
+	u8 *beacon_ie;
 
-	memcpy(bss_desc->mac_address, bssid, ETH_ALEN);
-	bss_desc->rssi = rssi;
-	bss_desc->beacon_buf = ie_buf;
-	bss_desc->beacon_buf_size = ie_len;
-	bss_desc->beacon_period = beacon_period;
-	bss_desc->cap_info_bitmap = cap_info_bitmap;
-	bss_desc->bss_band = band;
+	beacon_ie = kmemdup(bss->information_elements, bss->len_beacon_ies,
+			    GFP_KERNEL);
+	if (!beacon_ie) {
+		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
+		return -ENOMEM;
+	}
+
+	memcpy(bss_desc->mac_address, bss->bssid, ETH_ALEN);
+	bss_desc->rssi = bss->signal;
+	bss_desc->beacon_buf = beacon_ie;
+	bss_desc->beacon_buf_size = bss->len_beacon_ies;
+	bss_desc->beacon_period = bss->beacon_interval;
+	bss_desc->cap_info_bitmap = bss->capability;
+	bss_desc->bss_band = *(u8 *)bss->priv;
 	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
 		dev_dbg(priv->adapter->dev, "info: InterpretIE: AP WEP enabled\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
@@ -180,9 +186,9 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	else
 		bss_desc->bss_mode = NL80211_IFTYPE_STATION;
 
-	ret = mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc,
-					      ie_buf, ie_len);
+	ret = mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
 
+	kfree(beacon_ie);
 	return ret;
 }
 
@@ -197,7 +203,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *bss_desc = NULL;
-	u8 *beacon_ie = NULL;
 
 	priv->scan_block = false;
 
@@ -210,19 +215,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 			return -ENOMEM;
 		}
 
-		beacon_ie = kmemdup(bss->information_elements,
-					bss->len_beacon_ies, GFP_KERNEL);
-		if (!beacon_ie) {
-			kfree(bss_desc);
-			dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
-			return -ENOMEM;
-		}
-
-		ret = mwifiex_fill_new_bss_desc(priv, bss->bssid, bss->signal,
-						beacon_ie, bss->len_beacon_ies,
-						bss->beacon_interval,
-						bss->capability,
-						*(u8 *)bss->priv, bss_desc);
+		ret = mwifiex_fill_new_bss_desc(priv, bss, bss_desc);
 		if (ret)
 			goto done;
 	}
@@ -269,7 +262,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		    (!mwifiex_ssid_cmp(&priv->curr_bss_params.bss_descriptor.
 				       ssid, &bss_desc->ssid))) {
 			kfree(bss_desc);
-			kfree(beacon_ie);
 			return 0;
 		}
 
@@ -304,7 +296,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 done:
 	kfree(bss_desc);
-	kfree(beacon_ie);
 	return ret;
 }
 
-- 
1.7.0.2

