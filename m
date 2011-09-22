Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:47168 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751026Ab1IVEnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 00:43:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: update bss band information
Date: Wed, 21 Sep 2011 21:43:23 -0700
Message-Id: <1316666605-30954-2-git-send-email-bzhao@marvell.com> (sfid-20110922_064313_315413_AFC275A3)
In-Reply-To: <1316666605-30954-1-git-send-email-bzhao@marvell.com>
References: <1316666605-30954-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In recent commit "mwifiex: use cfg80211 dynamic scan..."
(7c6fa2a843..) scan table handling in driver is removed to
make use of cfg80211 dynamic scan table. Now driver sends
beacon buffers found in scanning directly to stack and parse
the buffer for requested BSS only during association.

Beacon buffer doesn't contain bss band information. Driver
gets it from firmware in separate tlv (chan_band_tlv).
Currently since we don't inform stack about bss bandinfo,
there is an issue with 5GHz association.

Use "priv" field of struct cfg80211_bss to store bandinfo.
This fixes 5GHz association issue.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    3 +++
 drivers/net/wireless/mwifiex/main.h      |    2 +-
 drivers/net/wireless/mwifiex/scan.c      |   26 +++++++++++++++++---------
 drivers/net/wireless/mwifiex/sta_ioctl.c |    6 ++++--
 4 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6fd53e4..62932c2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1219,6 +1219,9 @@ int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	/* We are using custom domains */
 	wdev->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 
+	/* Reserve space for bss band information */
+	wdev->wiphy->bss_priv_size = sizeof(u8);
+
 	wdev->wiphy->reg_notifier = mwifiex_reg_notifier;
 
 	/* Set struct mwifiex_private pointer in wiphy_priv */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e6b6c0c..1e80132 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -958,7 +958,7 @@ int mwifiex_get_bss_info(struct mwifiex_private *,
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 			      u8 *bssid, s32 rssi, u8 *ie_buf,
 			      size_t ie_len, u16 beacon_period,
-			      u16 cap_info_bitmap,
+			      u16 cap_info_bitmap, u8 band,
 			      struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				struct mwifiex_bssdescriptor *bss_entry,
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ecebff6..ca37619 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1464,9 +1464,9 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 }
 
 static int
-mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
-			u8 *bssid, s32 rssi, const u8 *ie_buf,
-			size_t ie_len, u16 beacon_period, u16 cap_info_bitmap)
+mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
+			       s32 rssi, const u8 *ie_buf, size_t ie_len,
+			       u16 beacon_period, u16 cap_info_bitmap, u8 band)
 {
 	struct mwifiex_bssdescriptor *bss_desc = NULL;
 	int ret;
@@ -1489,7 +1489,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 
 	ret = mwifiex_fill_new_bss_desc(priv, bssid, rssi, beacon_ie,
 					ie_len, beacon_period,
-					cap_info_bitmap, bss_desc);
+					cap_info_bitmap, band, bss_desc);
 	if (ret)
 		goto done;
 
@@ -1533,6 +1533,11 @@ done:
 	return 0;
 }
 
+static void mwifiex_free_bss_priv(struct cfg80211_bss *bss)
+{
+	kfree(bss->priv);
+}
+
 /*
  * This function handles the command response of scan.
  *
@@ -1571,6 +1576,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	struct chan_band_param_set *chan_band;
 	u8 is_bgscan_resp;
 	unsigned long flags;
+	struct cfg80211_bss *bss;
 
 	is_bgscan_resp = (le16_to_cpu(resp->command)
 		== HostCmd_CMD_802_11_BG_SCAN_QUERY);
@@ -1752,10 +1758,12 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			chan = ieee80211_get_channel(priv->wdev->wiphy, freq);
 
 			if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
-				cfg80211_inform_bss(priv->wdev->wiphy, chan,
-					bssid, network_tsf, cap_info_bitmap,
-					beacon_period, ie_buf, ie_len, rssi,
-					GFP_KERNEL);
+				bss = cfg80211_inform_bss(priv->wdev->wiphy,
+					      chan, bssid, network_tsf,
+					      cap_info_bitmap, beacon_period,
+					      ie_buf, ie_len, rssi, GFP_KERNEL);
+				*(u8 *)bss->priv = band;
+				bss->free_priv = mwifiex_free_bss_priv;
 
 				if (priv->media_connected && !memcmp(bssid,
 					priv->curr_bss_params.bss_descriptor
@@ -1763,7 +1771,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					mwifiex_update_curr_bss_params(priv,
 							bssid, rssi, ie_buf,
 							ie_len, beacon_period,
-							cap_info_bitmap);
+							cap_info_bitmap, band);
 			}
 		} else {
 			dev_dbg(adapter->dev, "missing BSS channel IE\n");
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 1df5ef6..157d312 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -148,7 +148,7 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 			      u8 *bssid, s32 rssi, u8 *ie_buf,
 			      size_t ie_len, u16 beacon_period,
-			      u16 cap_info_bitmap,
+			      u16 cap_info_bitmap, u8 band,
 			      struct mwifiex_bssdescriptor *bss_desc)
 {
 	int ret;
@@ -159,6 +159,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	bss_desc->beacon_buf_size = ie_len;
 	bss_desc->beacon_period = beacon_period;
 	bss_desc->cap_info_bitmap = cap_info_bitmap;
+	bss_desc->bss_band = band;
 	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
 		dev_dbg(priv->adapter->dev, "info: InterpretIE: AP WEP enabled\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
@@ -211,7 +212,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		ret = mwifiex_fill_new_bss_desc(priv, bss->bssid, bss->signal,
 						beacon_ie, bss->len_beacon_ies,
 						bss->beacon_interval,
-						bss->capability, bss_desc);
+						bss->capability,
+						*(u8 *)bss->priv, bss_desc);
 		if (ret)
 			goto done;
 	}
-- 
1.7.0.2

