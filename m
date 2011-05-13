Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2952 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758852Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 24/32] staging: brcm80211: Fixed ibss join/leave
 functionality in brcmfmac driver
Date: Fri, 13 May 2011 11:59:44 +0200
Message-ID: <1305280792-9475-24-git-send-email-arend@broadcom.com> (sfid-20110513_120044_526958_2E5A0E86)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

IBSS functionality is broken in fullmac driver, which is fixed with this patch

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  279 ++++++++++++++++------
 1 files changed, 206 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 3587210..27baf56 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -598,10 +598,10 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct wireless_dev *wdev;
 	s32 infra = 0;
-	s32 ap = 0;
 	s32 err = 0;
 
 	CHECK_SYS_UP();
+
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
@@ -610,32 +610,32 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
 		wl->conf->mode = WL_MODE_IBSS;
+		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
 		wl->conf->mode = WL_MODE_BSS;
 		infra = 1;
 		break;
 	default:
-		return -EINVAL;
+		err = -EINVAL;
+		goto done;
 	}
+
 	infra = cpu_to_le32(infra);
-	ap = cpu_to_le32(ap);
-	wdev = ndev->ieee80211_ptr;
-	wdev->iftype = type;
-	WL_DBG("%s : ap (%d), infra (%d)\n", ndev->name, ap, infra);
 	err = wl_dev_ioctl(ndev, WLC_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
-		return err;
-	}
-	err = wl_dev_ioctl(ndev, WLC_SET_AP, &ap, sizeof(ap));
-	if (unlikely(err)) {
-		WL_ERR("WLC_SET_AP error (%d)\n", err);
-		return err;
+		err = -EAGAIN;
+	} else {
+		wdev = ndev->ieee80211_ptr;
+		wdev->iftype = type;
 	}
 
-	/* -EINPROGRESS: Call commit handler */
-	return -EINPROGRESS;
+	WL_INFO("IF Type = %s\n",
+		(wl->conf->mode == WL_MODE_IBSS) ? "Adhoc" : "Infra");
+
+done:
+	return err;
 }
 
 static void wl_iscan_prep(struct wl_scan_params *params, struct wlc_ssid *ssid)
@@ -983,68 +983,137 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct cfg80211_bss *bss;
-	struct ieee80211_channel *chan;
 	struct wl_join_params join_params;
-	struct cfg80211_ssid ssid;
-	s32 scan_retry = 0;
+	size_t join_params_size = 0;
 	s32 err = 0;
+	s32 wsec = 0;
+	s32 bcnprd;
 
 	CHECK_SYS_UP();
-	if (params->bssid) {
-		WL_ERR("Invalid bssid\n");
+
+	if (params->ssid)
+		WL_DBG("SSID: %s\n", params->ssid);
+	else {
+		WL_DBG("SSID: NULL, Not supported\n");
 		return -EOPNOTSUPP;
 	}
-	bss = cfg80211_get_ibss(wiphy, NULL, params->ssid, params->ssid_len);
-	if (!bss) {
-		memcpy(ssid.ssid, params->ssid, params->ssid_len);
-		ssid.ssid_len = params->ssid_len;
-		do {
-			if (unlikely
-			    (__wl_cfg80211_scan(wiphy, dev, NULL, &ssid) ==
-			     -EBUSY)) {
-				wl_delay(150);
-			} else {
-				break;
-			}
-		} while (++scan_retry < WL_SCAN_RETRY_MAX);
-		rtnl_unlock();	/* to allow scan_inform to paropagate
-					 to cfg80211 plane */
-		schedule_timeout_interruptible(4 * HZ);	/* wait 4 secons
-						 till scan done.... */
-		rtnl_lock();
-		bss = cfg80211_get_ibss(wiphy, NULL,
-					params->ssid, params->ssid_len);
+
+	if (params->bssid)
+		WL_DBG("BSSID: %02X %02X %02X %02X %02X %02X\n",
+		params->bssid[0], params->bssid[1], params->bssid[2],
+		params->bssid[3], params->bssid[4], params->bssid[5]);
+	else
+		WL_DBG("No BSSID specified\n");
+
+	if (params->channel)
+		WL_DBG("channel: %d\n", params->channel->center_freq);
+	else
+		WL_DBG("no channel specified\n");
+
+	if (params->channel_fixed)
+		WL_DBG("fixed channel required\n");
+	else
+		WL_DBG("no fixed channel required\n");
+
+	if (params->ie && params->ie_len)
+		WL_DBG("ie len: %d\n", params->ie_len);
+	else
+		WL_DBG("no ie specified\n");
+
+	if (params->beacon_interval)
+		WL_DBG("beacon interval: %d\n", params->beacon_interval);
+	else
+		WL_DBG("no beacon interval specified\n");
+
+	if (params->basic_rates)
+		WL_DBG("basic rates: %08X\n", params->basic_rates);
+	else
+		WL_DBG("no basic rates specified\n");
+
+	if (params->privacy)
+		WL_DBG("privacy required\n");
+	else
+		WL_DBG("no privacy required\n");
+
+	/* Configure Privacy for starter */
+	if (params->privacy)
+		wsec |= WEP_ENABLED;
+
+	err = wl_dev_intvar_set(dev, "wsec", wsec);
+	if (unlikely(err)) {
+		WL_ERR("wsec failed (%d)\n", err);
+		goto done;
+	}
+
+	/* Configure Beacon Interval for starter */
+	if (params->beacon_interval)
+		bcnprd = cpu_to_le32(params->beacon_interval);
+	else
+		bcnprd = cpu_to_le32(100);
+
+	err = wl_dev_ioctl(dev, WLC_SET_BCNPRD, &bcnprd, sizeof(bcnprd));
+	if (unlikely(err)) {
+		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
+		goto done;
 	}
-	if (bss) {
-		wl->ibss_starter = false;
-		WL_DBG("Found IBSS\n");
+
+	/* Configure required join parameter */
+	memset(&join_params, 0, sizeof(wl_join_params_t));
+
+	/* SSID */
+	join_params.ssid.SSID_len =
+			(params->ssid_len > 32) ? 32 : params->ssid_len;
+	memcpy(join_params.ssid.SSID, params->ssid, join_params.ssid.SSID_len);
+	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
+	join_params_size = sizeof(join_params.ssid);
+	wl_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
+
+	/* BSSID */
+	if (params->bssid) {
+		memcpy(join_params.params.bssid, params->bssid, ETH_ALEN);
+		join_params_size =
+			sizeof(join_params.ssid) + WL_ASSOC_PARAMS_FIXED_SIZE;
 	} else {
-		wl->ibss_starter = true;
+		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 	}
-	chan = params->channel;
-	if (chan)
-		wl->channel = ieee80211_frequency_to_channel(chan->center_freq);
-	/*
-	 ** Join with specific BSSID and cached SSID
-	 ** If SSID is zero join based on BSSID only
-	 */
-	memset(&join_params, 0, sizeof(join_params));
-	memcpy((void *)join_params.ssid.SSID, (void *)params->ssid,
-	       params->ssid_len);
-	join_params.ssid.SSID_len = cpu_to_le32(params->ssid_len);
-	if (params->bssid)
-		memcpy(&join_params.params.bssid, params->bssid,
-		       ETH_ALEN);
-	else
-		memset(&join_params.params.bssid, 0, ETH_ALEN);
+	wl_update_prof(wl, NULL, &join_params.params.bssid, WL_PROF_BSSID);
+
+	/* Channel */
+	if (params->channel) {
+		u32 target_channel;
+
+		wl->channel =
+			ieee80211_frequency_to_channel(
+				params->channel->center_freq);
+		if (params->channel_fixed) {
+			/* adding chanspec */
+			wl_ch_to_chanspec(wl->channel,
+				&join_params, &join_params_size);
+		}
 
-	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params,
-			sizeof(join_params));
+		/* set channel for starter */
+		target_channel = cpu_to_le32(wl->channel);
+		err = wl_dev_ioctl(dev, WLC_SET_CHANNEL,
+			&target_channel, sizeof(target_channel));
+		if (unlikely(err)) {
+			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
+			goto done;
+		}
+	} else
+		wl->channel = 0;
+
+	wl->ibss_starter = false;
+
+
+	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params, join_params_size);
 	if (unlikely(err)) {
-		WL_ERR("Error (%d)\n", err);
-		return err;
+		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
+		goto done;
 	}
+
+	set_bit(WL_STATUS_CONNECTING, &wl->status);
+
+done:
 	return err;
 }
 
@@ -2367,6 +2436,76 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 	return err;
 }
 
+static s32
+wl_inform_ibss(struct wl_priv *wl, struct net_device *dev, const u8 *bssid)
+{
+	struct wiphy *wiphy = wl_to_wiphy(wl);
+	struct ieee80211_channel *notify_channel;
+	struct wl_bss_info *bi = NULL;
+	struct ieee80211_supported_band *band;
+	u8 *buf = NULL;
+	s32 err = 0;
+	u16 channel;
+	u32 freq;
+	u64 notify_timestamp;
+	u16 notify_capability;
+	u16 notify_interval;
+	u8 *notify_ie;
+	size_t notify_ielen;
+	s32 notify_signal;
+
+	buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
+	if (buf == NULL) {
+		WL_ERR("kzalloc() failed\n");
+		err = -ENOMEM;
+		goto CleanUp;
+	}
+
+	*(u32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
+
+	err = wl_dev_ioctl(dev, WLC_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	if (unlikely(err)) {
+		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
+		goto CleanUp;
+	}
+
+	bi = (wl_bss_info_t *)(buf + 4);
+
+	channel = bi->ctl_ch ? bi->ctl_ch :
+				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+
+	if (channel <= CH_MAX_2G_CHANNEL)
+		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+	else
+		band = wiphy->bands[IEEE80211_BAND_5GHZ];
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
+	WL_DBG("channel: %d(%d)\n", channel, freq);
+	WL_DBG("capability: %X\n", notify_capability);
+	WL_DBG("beacon interval: %d\n", notify_interval);
+	WL_DBG("signal: %d\n", notify_signal);
+	WL_DBG("notify_timestamp: %#018llx\n", notify_timestamp);
+
+	cfg80211_inform_bss(wiphy, notify_channel, bssid,
+		notify_timestamp, notify_capability, notify_interval,
+		notify_ie, notify_ielen, notify_signal, GFP_KERNEL);
+
+CleanUp:
+
+	kfree(buf);
+
+	return err;
+}
+
 static bool wl_is_linkup(struct wl_priv *wl, const wl_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
@@ -2424,6 +2563,7 @@ wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 		if (wl_is_ibssmode(wl)) {
 			wl_update_prof(wl, NULL, (void *)e->addr,
 				WL_PROF_BSSID);
+			wl_inform_ibss(wl, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
 			clear_bit(WL_STATUS_CONNECTING, &wl->status);
 			set_bit(WL_STATUS_CONNECTED, &wl->status);
@@ -3405,7 +3545,6 @@ struct sdio_func *wl_cfg80211_get_sdio_func(void)
 static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 {
 	s32 infra = 0;
-	s32 ap = 0;
 	s32 err = 0;
 
 	switch (iftype) {
@@ -3416,6 +3555,7 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 		err = -EINVAL;
 		return err;
 	case NL80211_IFTYPE_ADHOC:
+		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
 		infra = 1;
@@ -3426,20 +3566,13 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 		return err;
 	}
 	infra = cpu_to_le32(infra);
-	ap = cpu_to_le32(ap);
-	WL_DBG("%s ap (%d), infra (%d)\n", ndev->name, ap, infra);
 	err = wl_dev_ioctl(ndev, WLC_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
 	}
-	err = wl_dev_ioctl(ndev, WLC_SET_AP, &ap, sizeof(ap));
-	if (unlikely(err)) {
-		WL_ERR("WLC_SET_AP error (%d)\n", err);
-		return err;
-	}
 
-	return -EINPROGRESS;
+	return 0;
 }
 
 #ifndef EMBEDDED_PLATFORM
-- 
1.7.4.1


