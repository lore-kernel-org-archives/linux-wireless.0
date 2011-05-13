Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4917 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738Ab1EMKAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 22/32] staging: brcm80211: Optimized
 wl_inform_single_bss function in brcmfmac driver
Date: Fri, 13 May 2011 11:59:42 +0200
Message-ID: <1305280792-9475-22-git-send-email-arend@broadcom.com> (sfid-20110513_120109_485153_1E9B9F07)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Earlier verion of wl_inform_single_bss function is using
'cfg80211_inform_bss_frame' API for sending bss info to cfg80211.
With this patch same will be done through a more optimal
'cfg80211_inform_bss' API.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  176 ++++++----------------
 1 files changed, 50 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 2d67048..07a47a9 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -182,15 +182,15 @@ static void wl_init_prof(struct wl_profile *prof);
 ** cfg80211 connect utilites
 */
 static s32 wl_set_wpa_version(struct net_device *dev,
-				struct cfg80211_connect_params *sme);
+			struct cfg80211_connect_params *sme);
 static s32 wl_set_auth_type(struct net_device *dev,
-			      struct cfg80211_connect_params *sme);
+			struct cfg80211_connect_params *sme);
 static s32 wl_set_set_cipher(struct net_device *dev,
-			       struct cfg80211_connect_params *sme);
+			struct cfg80211_connect_params *sme);
 static s32 wl_set_key_mgmt(struct net_device *dev,
-			     struct cfg80211_connect_params *sme);
+			struct cfg80211_connect_params *sme);
 static s32 wl_set_set_sharedkey(struct net_device *dev,
-				  struct cfg80211_connect_params *sme);
+			struct cfg80211_connect_params *sme);
 static s32 wl_get_assoc_ies(struct wl_priv *wl);
 static void wl_ch_to_chanspec(int ch,
 	struct wl_join_params *join_params, size_t *join_params_size);
@@ -198,25 +198,17 @@ static void wl_ch_to_chanspec(int ch,
 /*
 ** information element utilities
 */
-static void wl_rst_ie(struct wl_priv *wl);
 static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v);
-static s32 wl_mrg_ie(struct wl_priv *wl, u8 *ie_stream, u16 ie_size);
-static s32 wl_cp_ie(struct wl_priv *wl, u8 *dst, u16 dst_size);
-static u32 wl_get_ielen(struct wl_priv *wl);
-
 static s32 wl_mode_to_nl80211_iftype(s32 mode);
-
 static struct wireless_dev *wl_alloc_wdev(s32 sizeof_iface,
-					  struct device *dev);
+			struct device *dev);
 static void wl_free_wdev(struct wl_priv *wl);
-
 static s32 wl_inform_bss(struct wl_priv *wl);
 static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi);
 static s32 wl_update_bss_info(struct wl_priv *wl);
-
 static s32 wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
-			   u8 key_idx, const u8 *mac_addr,
-			   struct key_params *params);
+			u8 key_idx, const u8 *mac_addr,
+			struct key_params *params);
 
 /*
 ** key indianess swap utilities
@@ -2310,89 +2302,63 @@ static s32 wl_inform_bss(struct wl_priv *wl)
 	return err;
 }
 
+
 static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 {
 	struct wiphy *wiphy = wl_to_wiphy(wl);
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_channel *channel;
+	struct ieee80211_channel *notify_channel;
+	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
-	struct wl_cfg80211_bss_info *notif_bss_info;
-	struct wl_scan_req *sr = wl_to_sr(wl);
-	struct beacon_proberesp *beacon_proberesp;
-	s32 mgmt_type;
-	u32 signal;
-	u32 freq;
 	s32 err = 0;
+	u16 channel;
+	u32 freq;
+	u64 notify_timestamp;
+	u16 notify_capability;
+	u16 notify_interval;
+	u8 *notify_ie;
+	size_t notify_ielen;
+	s32 notify_signal;
 
 	if (unlikely(le32_to_cpu(bi->length) > WL_BSS_INFO_MAX)) {
-		WL_DBG("Beacon is larger than buffer. Discarding\n");
-		return err;
-	}
-	notif_bss_info =
-	    kzalloc(sizeof(*notif_bss_info) + sizeof(*mgmt) - sizeof(u8) +
-		    WL_BSS_INFO_MAX, GFP_KERNEL);
-	if (unlikely(!notif_bss_info)) {
-		WL_ERR("notif_bss_info alloc failed\n");
-		return -ENOMEM;
+		WL_ERR("Bss info is larger than buffer. Discarding\n");
+		return 0;
 	}
-	mgmt = (struct ieee80211_mgmt *)notif_bss_info->frame_buf;
-	notif_bss_info->channel =
-		bi->ctl_ch ? bi->ctl_ch : CHSPEC_CHANNEL(bi->chanspec);
 
-	if (notif_bss_info->channel <= CH_MAX_2G_CHANNEL)
+	channel = bi->ctl_ch ? bi->ctl_ch :
+				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+
+	if (channel <= CH_MAX_2G_CHANNEL)
 		band = wiphy->bands[IEEE80211_BAND_2GHZ];
 	else
 		band = wiphy->bands[IEEE80211_BAND_5GHZ];
-	notif_bss_info->rssi = bi->RSSI;
-	memcpy(mgmt->bssid, &bi->BSSID, ETH_ALEN);
-	mgmt_type = wl->active_scan ?
-		IEEE80211_STYPE_PROBE_RESP : IEEE80211_STYPE_BEACON;
-	if (!memcmp(bi->SSID, sr->ssid.SSID, bi->SSID_len)) {
-		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-							mgmt_type);
-	}
-	beacon_proberesp = wl->active_scan ?
-		(struct beacon_proberesp *)&mgmt->u.probe_resp :
-		(struct beacon_proberesp *)&mgmt->u.beacon;
-	beacon_proberesp->timestamp = 0;
-	beacon_proberesp->beacon_int = cpu_to_le16(bi->beacon_period);
-	beacon_proberesp->capab_info = cpu_to_le16(bi->capability);
-	wl_rst_ie(wl);
-	/*
-	* wl_add_ie is not necessary because it can only add duplicated
-	* SSID, rate information to frame_buf
-	*/
-	/*
-	* wl_add_ie(wl, WLAN_EID_SSID, bi->SSID_len, bi->SSID);
-	* wl_add_ie(wl, WLAN_EID_SUPP_RATES, bi->rateset.count,
-	* bi->rateset.rates);
-	*/
-	wl_mrg_ie(wl, ((u8 *) bi) + bi->ie_offset, bi->ie_length);
-	wl_cp_ie(wl, beacon_proberesp->variable, WL_BSS_INFO_MAX -
-		 offsetof(struct wl_cfg80211_bss_info, frame_buf));
-	notif_bss_info->frame_len =
-	    offsetof(struct ieee80211_mgmt,
-		     u.beacon.variable) + wl_get_ielen(wl);
-	freq = ieee80211_channel_to_frequency(notif_bss_info->channel,
-					      band->band);
-
-	channel = ieee80211_get_channel(wiphy, freq);
-
-	WL_DBG("SSID : \"%s\", rssi %d, channel %d, capability : 0x04%x, bssid %pM\n",
-	       bi->SSID,
-	       notif_bss_info->rssi, notif_bss_info->channel,
-	       mgmt->u.beacon.capab_info, &bi->BSSID);
-
-	signal = notif_bss_info->rssi * 100;
-	if (unlikely(!cfg80211_inform_bss_frame(wiphy, channel, mgmt,
-						le16_to_cpu
-						(notif_bss_info->frame_len),
-						signal, GFP_KERNEL))) {
+
+	freq = ieee80211_channel_to_frequency(channel, band->band);
+	notify_channel = ieee80211_get_channel(wiphy, freq);
+
+	notify_timestamp = jiffies_to_msecs(jiffies)*1000; /* uSec */
+	notify_capability = le16_to_cpu(bi->capability);
+	notify_interval = le16_to_cpu(bi->beacon_period);
+	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
+	notify_ielen = le16_to_cpu(bi->ie_length);
+	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
+
+	WL_DBG("bssid: %2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
+			bi->BSSID[0], bi->BSSID[1], bi->BSSID[2],
+			bi->BSSID[3], bi->BSSID[4], bi->BSSID[5]);
+	WL_DBG("Channel: %d(%d)\n", channel, freq);
+	WL_DBG("Capability: %X\n", notify_capability);
+	WL_DBG("Beacon interval: %d\n", notify_interval);
+	WL_DBG("Signal: %d\n", notify_signal);
+	WL_DBG("notify_timestamp: %#018llx\n", notify_timestamp);
+
+	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
+		notify_timestamp, notify_capability, notify_interval, notify_ie,
+		notify_ielen, notify_signal, GFP_KERNEL);
+
+	if (unlikely(!bss)) {
 		WL_ERR("cfg80211_inform_bss_frame error\n");
-		kfree(notif_bss_info);
 		return -EINVAL;
 	}
-	kfree(notif_bss_info);
 
 	return err;
 }
@@ -4036,13 +4002,6 @@ static bool wl_is_ibssstarter(struct wl_priv *wl)
 	return wl->ibss_starter;
 }
 
-static void wl_rst_ie(struct wl_priv *wl)
-{
-	struct wl_ie *ie = wl_to_ie(wl);
-
-	ie->offset = 0;
-}
-
 static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 {
 	struct wl_ie *ie = wl_to_ie(wl);
@@ -4060,41 +4019,6 @@ static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 	return err;
 }
 
-static s32 wl_mrg_ie(struct wl_priv *wl, u8 *ie_stream, u16 ie_size)
-{
-	struct wl_ie *ie = wl_to_ie(wl);
-	s32 err = 0;
-
-	if (unlikely(ie->offset + ie_size > WL_TLV_INFO_MAX)) {
-		WL_ERR("ei_stream crosses buffer boundary\n");
-		return -ENOSPC;
-	}
-	memcpy(&ie->buf[ie->offset], ie_stream, ie_size);
-	ie->offset += ie_size;
-
-	return err;
-}
-
-static s32 wl_cp_ie(struct wl_priv *wl, u8 *dst, u16 dst_size)
-{
-	struct wl_ie *ie = wl_to_ie(wl);
-	s32 err = 0;
-
-	if (unlikely(ie->offset > dst_size)) {
-		WL_ERR("dst_size is not enough\n");
-		return -ENOSPC;
-	}
-	memcpy(dst, &ie->buf[0], ie->offset);
-
-	return err;
-}
-
-static u32 wl_get_ielen(struct wl_priv *wl)
-{
-	struct wl_ie *ie = wl_to_ie(wl);
-
-	return ie->offset;
-}
 
 static void wl_link_up(struct wl_priv *wl)
 {
-- 
1.7.4.1


