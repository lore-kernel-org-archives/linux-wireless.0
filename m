Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4919 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749Ab1EMKAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 23/32] staging: brcm80211: Fixed bss
 (re)connect/disconnect issues in brcmfmac driver
Date: Fri, 13 May 2011 11:59:43 +0200
Message-ID: <1305280792-9475-23-git-send-email-arend@broadcom.com> (sfid-20110513_120055_363304_33971EE0)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Broken functionality of bss (re)connect/disconnect in full mac driver
is fixed with this patch.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  381 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    1 -
 2 files changed, 189 insertions(+), 193 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 07a47a9..3587210 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -192,6 +192,7 @@ static s32 wl_set_key_mgmt(struct net_device *dev,
 static s32 wl_set_set_sharedkey(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
 static s32 wl_get_assoc_ies(struct wl_priv *wl);
+static void wl_clear_assoc_ies(struct wl_priv *wl);
 static void wl_ch_to_chanspec(int ch,
 	struct wl_join_params *join_params, size_t *join_params_size);
 
@@ -234,7 +235,6 @@ static void *wl_get_drvdata(struct wl_dev *dev);
 ** ibss mode utilities
 */
 static bool wl_is_ibssmode(struct wl_priv *wl);
-static bool wl_is_ibssstarter(struct wl_priv *wl);
 
 /*
 ** dongle up/down , default configuration utilities
@@ -242,7 +242,6 @@ static bool wl_is_ibssstarter(struct wl_priv *wl);
 static bool wl_is_linkdown(struct wl_priv *wl, const wl_event_msg_t *e);
 static bool wl_is_linkup(struct wl_priv *wl, const wl_event_msg_t *e);
 static bool wl_is_nonetwork(struct wl_priv *wl, const wl_event_msg_t *e);
-static void wl_link_up(struct wl_priv *wl);
 static void wl_link_down(struct wl_priv *wl);
 static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype);
 static s32 __wl_cfg80211_up(struct wl_priv *wl);
@@ -262,7 +261,6 @@ static s32 wl_dongle_glom(struct net_device *ndev, u32 glom,
 			    u32 dongle_align);
 static s32 wl_dongle_roam(struct net_device *ndev, u32 roamvar,
 			    u32 bcn_timeout);
-static s32 wl_dongle_eventmsg(struct net_device *ndev);
 static s32 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 				s32 scan_unassoc_time);
 static s32 wl_dongle_offload(struct net_device *ndev, s32 arpoe,
@@ -271,6 +269,8 @@ static s32 wl_pattern_atoh(s8 *src, s8 *dst);
 static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode);
 static s32 wl_update_wiphybands(struct wl_priv *wl);
 #endif				/* !EMBEDDED_PLATFORM */
+
+static s32 wl_dongle_eventmsg(struct net_device *ndev);
 static s32 wl_config_dongle(struct wl_priv *wl, bool need_lock);
 
 /*
@@ -1327,10 +1327,12 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 	if (chan) {
-		wl->channel = ieee80211_frequency_to_channel(chan->center_freq);
+		wl->channel =
+			ieee80211_frequency_to_channel(chan->center_freq);
 		WL_DBG("channel (%d), center_req (%d)\n",
-		       wl->channel, chan->center_freq);
-	}
+			wl->channel, chan->center_freq);
+	} else
+		wl->channel = 0;
 	WL_DBG("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 	err = wl_set_wpa_version(dev, sme);
 	if (unlikely(err))
@@ -1364,15 +1366,18 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
 	wl_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
-	memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 
-	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
-	WL_DBG("join_param_size %zu\n", join_params_size);
+	if (sme->bssid)
+		memcpy(join_params.params.bssid, sme->bssid, ETH_ALEN);
+	else
+		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 
 	if (join_params.ssid.SSID_len < IEEE80211_MAX_SSID_LEN) {
 		WL_DBG("ssid \"%s\", len (%d)\n",
 		       join_params.ssid.SSID, join_params.ssid.SSID_len);
 	}
+
+	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
 	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params, join_params_size);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -1389,23 +1394,22 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	scb_val_t scbval;
-	bool act = false;
 	s32 err = 0;
 
 	WL_DBG("Reason %d\n", reason_code);
 	CHECK_SYS_UP();
-	act = *(bool *) wl_read_prof(wl, WL_PROF_ACT);
-	if (likely(act)) {
-		scbval.val = reason_code;
-		memcpy(&scbval.ea, &wl->bssid, ETH_ALEN);
-		scbval.val = cpu_to_le32(scbval.val);
-		err = wl_dev_ioctl(dev, WLC_DISASSOC, &scbval,
-				sizeof(scb_val_t));
-		if (unlikely(err)) {
-			WL_ERR("error (%d)\n", err);
-			return err;
-		}
-	}
+
+	clear_bit(WL_STATUS_CONNECTED, &wl->status);
+
+	scbval.val = reason_code;
+	memcpy(&scbval.ea, wl_read_prof(wl, WL_PROF_BSSID), ETH_ALEN);
+	scbval.val = cpu_to_le32(scbval.val);
+	err = wl_dev_ioctl(dev, WLC_DISASSOC, &scbval,
+			sizeof(scb_val_t));
+	if (unlikely(err))
+		WL_ERR("error (%d)\n", err);
+
+	wl->link_up = false;
 
 	return err;
 }
@@ -2366,17 +2370,12 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 static bool wl_is_linkup(struct wl_priv *wl, const wl_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
-	u16 flags = be16_to_cpu(e->flags);
+	u32 status = be32_to_cpu(e->status);
 
-	if (event == WLC_E_LINK) {
-		if (flags & WLC_EVENT_MSG_LINK) {
-			if (wl_is_ibssmode(wl)) {
-				if (wl_is_ibssstarter(wl)) {
-				}
-			} else {
-				return true;
-			}
-		}
+	if (event == WLC_E_SET_SSID && status == WLC_E_STATUS_SUCCESS) {
+		WL_DBG("Processing set ssid\n");
+		wl->link_up = true;
+		return true;
 	}
 
 	return false;
@@ -2387,13 +2386,10 @@ static bool wl_is_linkdown(struct wl_priv *wl, const wl_event_msg_t *e)
 	u32 event = be32_to_cpu(e->event_type);
 	u16 flags = be16_to_cpu(e->flags);
 
-	if (event == WLC_E_DEAUTH_IND || event == WLC_E_DISASSOC_IND) {
+	if (event == WLC_E_LINK && (!(flags & WLC_EVENT_MSG_LINK))) {
+		WL_DBG("Processing link down\n");
 		return true;
-	} else if (event == WLC_E_LINK) {
-		if (!(flags & WLC_EVENT_MSG_LINK))
-			return true;
 	}
-
 	return false;
 }
 
@@ -2401,10 +2397,17 @@ static bool wl_is_nonetwork(struct wl_priv *wl, const wl_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
+	u16 flags = be16_to_cpu(e->flags);
 
-	if (event == WLC_E_SET_SSID || event == WLC_E_LINK) {
-		if (status == WLC_E_STATUS_NO_NETWORKS)
-			return true;
+	if (event == WLC_E_LINK && status == WLC_E_STATUS_NO_NETWORKS) {
+		WL_DBG("Processing Link %s & no network found\n",
+				flags & WLC_EVENT_MSG_LINK ? "up" : "down");
+		return true;
+	}
+
+	if (event == WLC_E_SET_SSID && status != WLC_E_STATUS_SUCCESS) {
+		WL_DBG("Processing connecting & no network found\n");
+		return true;
 	}
 
 	return false;
@@ -2414,30 +2417,38 @@ static s32
 wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 			 const wl_event_msg_t *e, void *data)
 {
-	bool act;
 	s32 err = 0;
 
 	if (wl_is_linkup(wl, e)) {
-		wl_link_up(wl);
+		WL_DBG("Linkup\n");
 		if (wl_is_ibssmode(wl)) {
-			cfg80211_ibss_joined(ndev, (s8 *)&e->addr,
-					     GFP_KERNEL);
-			WL_DBG("joined in IBSS network\n");
-		} else {
+			wl_update_prof(wl, NULL, (void *)e->addr,
+				WL_PROF_BSSID);
+			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
+			clear_bit(WL_STATUS_CONNECTING, &wl->status);
+			set_bit(WL_STATUS_CONNECTED, &wl->status);
+		} else
 			wl_bss_connect_done(wl, ndev, e, data, true);
-			WL_DBG("joined in BSS network \"%s\"\n",
-			       ((struct wlc_ssid *)
-				wl_read_prof(wl, WL_PROF_SSID))->SSID);
-		}
-		act = true;
-		wl_update_prof(wl, e, &act, WL_PROF_ACT);
 	} else if (wl_is_linkdown(wl, e)) {
-		cfg80211_disconnected(ndev, 0, NULL, 0, GFP_KERNEL);
-		clear_bit(WL_STATUS_CONNECTED, &wl->status);
-		wl_link_down(wl);
+		WL_DBG("Linkdown\n");
+		if (wl_is_ibssmode(wl)) {
+			if (test_and_clear_bit(WL_STATUS_CONNECTED,
+				&wl->status))
+				wl_link_down(wl);
+		} else {
+			if (test_and_clear_bit(WL_STATUS_CONNECTED,
+				&wl->status)) {
+				cfg80211_disconnected(ndev, 0, NULL, 0,
+					GFP_KERNEL);
+				wl_link_down(wl);
+			}
+		}
 		wl_init_prof(wl->profile);
 	} else if (wl_is_nonetwork(wl, e)) {
-		wl_bss_connect_done(wl, ndev, e, data, false);
+		if (wl_is_ibssmode(wl))
+			clear_bit(WL_STATUS_CONNECTING, &wl->status);
+		else
+			wl_bss_connect_done(wl, ndev, e, data, false);
 	}
 
 	return err;
@@ -2447,12 +2458,16 @@ static s32
 wl_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
 			 const wl_event_msg_t *e, void *data)
 {
-	bool act;
 	s32 err = 0;
+	u32 event = be32_to_cpu(e->event_type);
+	u32 status = be32_to_cpu(e->status);
 
-	wl_bss_roaming_done(wl, ndev, e, data);
-	act = true;
-	wl_update_prof(wl, e, &act, WL_PROF_ACT);
+	if (event == WLC_E_ROAM && status == WLC_E_STATUS_SUCCESS) {
+		if (test_bit(WL_STATUS_CONNECTED, &wl->status))
+			wl_bss_roaming_done(wl, ndev, e, data);
+		else
+			wl_bss_connect_done(wl, ndev, e, data, true);
+	}
 
 	return err;
 }
@@ -2499,6 +2514,8 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 	u32 resp_len;
 	s32 err = 0;
 
+	wl_clear_assoc_ies(wl);
+
 	err = wl_dev_bufvar_get(ndev, "assoc_info", wl->extra_buf,
 				WL_ASSOC_INFO_MAX);
 	if (unlikely(err)) {
@@ -2542,6 +2559,19 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 	return err;
 }
 
+static void wl_clear_assoc_ies(struct wl_priv *wl)
+{
+	struct wl_connect_info *conn_info = wl_to_conn(wl);
+
+	kfree(conn_info->req_ie);
+	conn_info->req_ie = NULL;
+	conn_info->req_ie_len = 0;
+	kfree(conn_info->resp_ie);
+	conn_info->resp_ie = NULL;
+	conn_info->resp_ie_len = 0;
+}
+
+
 static void wl_ch_to_chanspec(int ch, struct wl_join_params *join_params,
 	size_t *join_params_size)
 {
@@ -2551,7 +2581,7 @@ static void wl_ch_to_chanspec(int ch, struct wl_join_params *join_params,
 		join_params->params.chanspec_num = 1;
 		join_params->params.chanspec_list[0] = ch;
 
-		if (join_params->params.chanspec_list[0])
+		if (join_params->params.chanspec_list[0] <= CH_MAX_2G_CHANNEL)
 			chanspec |= WL_CHANSPEC_BAND_2G;
 		else
 			chanspec |= WL_CHANSPEC_BAND_5G;
@@ -2577,7 +2607,6 @@ static void wl_ch_to_chanspec(int ch, struct wl_join_params *join_params,
 
 static s32 wl_update_bss_info(struct wl_priv *wl)
 {
-	struct cfg80211_bss *bss;
 	struct wl_bss_info *bi;
 	struct wlc_ssid *ssid;
 	struct bcm_tlv *tim;
@@ -2591,63 +2620,46 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 		return err;
 
 	ssid = (struct wlc_ssid *)wl_read_prof(wl, WL_PROF_SSID);
-	bss =
-	    cfg80211_get_bss(wl_to_wiphy(wl), NULL, (s8 *)&wl->bssid,
-			     ssid->SSID, ssid->SSID_len, WLAN_CAPABILITY_ESS,
-			     WLAN_CAPABILITY_ESS);
 
-	rtnl_lock();
-	if (unlikely(!bss)) {
-		WL_DBG("Could not find the AP\n");
-		*(u32 *) wl->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-		err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_BSS_INFO,
-				wl->extra_buf, WL_EXTRA_BUF_MAX);
-		if (unlikely(err)) {
-			WL_ERR("Could not get bss info %d\n", err);
-			goto update_bss_info_out;
-		}
-		bi = (struct wl_bss_info *)(wl->extra_buf + 4);
-		if (unlikely(memcmp(&bi->BSSID, &wl->bssid, ETH_ALEN))) {
-			err = -EIO;
-			goto update_bss_info_out;
-		}
-		err = wl_inform_single_bss(wl, bi);
-		if (unlikely(err))
-			goto update_bss_info_out;
-
-		ie = ((u8 *)bi) + bi->ie_offset;
-		ie_len = bi->ie_length;
-		beacon_interval = cpu_to_le16(bi->beacon_period);
-	} else {
-		WL_DBG("Found the AP in the list - BSSID %pM\n", bss->bssid);
-		ie = bss->information_elements;
-		ie_len = bss->len_information_elements;
-		beacon_interval = bss->beacon_interval;
-		cfg80211_put_bss(bss);
+	*(u32 *)wl->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
+	err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_BSS_INFO,
+			wl->extra_buf, WL_EXTRA_BUF_MAX);
+	if (unlikely(err)) {
+		WL_ERR("Could not get bss info %d\n", err);
+		goto update_bss_info_out;
 	}
 
+	bi = (struct wl_bss_info *)(wl->extra_buf + 4);
+	err = wl_inform_single_bss(wl, bi);
+	if (unlikely(err))
+		goto update_bss_info_out;
+
+	ie = ((u8 *)bi) + bi->ie_offset;
+	ie_len = bi->ie_length;
+	beacon_interval = cpu_to_le16(bi->beacon_period);
+
 	tim = bcm_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
-	if (tim) {
+	if (tim)
 		dtim_period = tim->data[1];
-	} else {
+	else {
 		/*
 		* active scan was done so we could not get dtim
 		* information out of probe response.
 		* so we speficially query dtim information to dongle.
 		*/
-		err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_DTIMPRD,
-			&dtim_period, sizeof(dtim_period));
+		u32 var;
+		err = wl_dev_intvar_get(wl_to_ndev(wl), "dtim_assoc", &var);
 		if (unlikely(err)) {
-			WL_ERR("WLC_GET_DTIMPRD error (%d)\n", err);
+			WL_ERR("wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
 		}
+		dtim_period = (u8)var;
 	}
 
 	wl_update_prof(wl, NULL, &beacon_interval, WL_PROF_BEACONINT);
 	wl_update_prof(wl, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
 
 update_bss_info_out:
-	rtnl_unlock();
 	return err;
 }
 
@@ -2659,10 +2671,11 @@ wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 	s32 err = 0;
 
 	wl_get_assoc_ies(wl);
-	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
+	wl_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
 	wl_update_bss_info(wl);
+
 	cfg80211_roamed(ndev,
-			(u8 *)&wl->bssid,
+			(u8 *)wl_read_prof(wl, WL_PROF_BSSID),
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_DBG("Report roaming result\n");
@@ -2679,30 +2692,26 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
 	s32 err = 0;
 
-	wl_get_assoc_ies(wl);
-	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
-	wl_update_bss_info(wl);
+
 	if (test_and_clear_bit(WL_STATUS_CONNECTING, &wl->status)) {
+		if (completed) {
+			wl_get_assoc_ies(wl);
+			wl_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
+			wl_update_bss_info(wl);
+		}
 		cfg80211_connect_result(ndev,
-					(u8 *)&wl->bssid,
+					(u8 *)wl_read_prof(wl, WL_PROF_BSSID),
 					conn_info->req_ie,
 					conn_info->req_ie_len,
 					conn_info->resp_ie,
 					conn_info->resp_ie_len,
 					completed ? WLAN_STATUS_SUCCESS : WLAN_STATUS_AUTH_TIMEOUT,
 					GFP_KERNEL);
+		if (completed)
+			set_bit(WL_STATUS_CONNECTED, &wl->status);
 		WL_DBG("Report connect result - connection %s\n",
-		       completed ? "succeeded" : "failed");
-	} else {
-		cfg80211_roamed(ndev,
-				(u8 *)&wl->bssid,
-				conn_info->req_ie, conn_info->req_ie_len,
-				conn_info->resp_ie, conn_info->resp_ie_len,
-				GFP_KERNEL);
-		WL_DBG("Report roaming result\n");
+				completed ? "succeeded" : "failed");
 	}
-	set_bit(WL_STATUS_CONNECTED, &wl->status);
-
 	return err;
 }
 
@@ -2804,12 +2813,7 @@ static void wl_init_eloop_handler(struct wl_event_loop *el)
 {
 	memset(el, 0, sizeof(*el));
 	el->handler[WLC_E_SCAN_COMPLETE] = wl_notify_scan_status;
-	el->handler[WLC_E_JOIN] = wl_notify_connect_status;
 	el->handler[WLC_E_LINK] = wl_notify_connect_status;
-	el->handler[WLC_E_DEAUTH_IND] = wl_notify_connect_status;
-	el->handler[WLC_E_DISASSOC_IND] = wl_notify_connect_status;
-	el->handler[WLC_E_ASSOC_IND] = wl_notify_connect_status;
-	el->handler[WLC_E_REASSOC_IND] = wl_notify_connect_status;
 	el->handler[WLC_E_ROAM] = wl_notify_roaming_status;
 	el->handler[WLC_E_MIC_ERROR] = wl_notify_mic_status;
 	el->handler[WLC_E_SET_SSID] = wl_notify_connect_status;
@@ -3525,55 +3529,6 @@ dongle_rom_out:
 	return err;
 }
 
-static s32 wl_dongle_eventmsg(struct net_device *ndev)
-{
-
-	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
-						 '\0' + bitvec  */
-	s8 eventmask[WL_EVENTING_MASK_LEN];
-	s32 err = 0;
-
-	/* Setup event_msgs */
-	bcm_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
-		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
-		WL_ERR("Get event_msgs error (%d)\n", err);
-		goto dongle_eventmsg_out;
-	}
-	memcpy(eventmask, iovbuf, WL_EVENTING_MASK_LEN);
-
-	setbit(eventmask, WLC_E_SET_SSID);
-	setbit(eventmask, WLC_E_PRUNE);
-	setbit(eventmask, WLC_E_AUTH);
-	setbit(eventmask, WLC_E_REASSOC);
-	setbit(eventmask, WLC_E_REASSOC_IND);
-	setbit(eventmask, WLC_E_DEAUTH_IND);
-	setbit(eventmask, WLC_E_DISASSOC_IND);
-	setbit(eventmask, WLC_E_DISASSOC);
-	setbit(eventmask, WLC_E_JOIN);
-	setbit(eventmask, WLC_E_ASSOC_IND);
-	setbit(eventmask, WLC_E_PSK_SUP);
-	setbit(eventmask, WLC_E_LINK);
-	setbit(eventmask, WLC_E_NDIS_LINK);
-	setbit(eventmask, WLC_E_MIC_ERROR);
-	setbit(eventmask, WLC_E_PMKID_CACHE);
-	setbit(eventmask, WLC_E_TXFAIL);
-	setbit(eventmask, WLC_E_JOIN_START);
-	setbit(eventmask, WLC_E_SCAN_COMPLETE);
-
-	bcm_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
-		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
-		WL_ERR("Set event_msgs error (%d)\n", err);
-		goto dongle_eventmsg_out;
-	}
-
-dongle_eventmsg_out:
-	return err;
-}
-
 static s32
 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		   s32 scan_unassoc_time)
@@ -3753,6 +3708,55 @@ dongle_filter_out:
 }
 #endif				/* !EMBEDDED_PLATFORM */
 
+static s32 wl_dongle_eventmsg(struct net_device *ndev)
+{
+	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
+						 '\0' + bitvec  */
+	s8 eventmask[WL_EVENTING_MASK_LEN];
+	s32 err = 0;
+
+	/* Setup event_msgs */
+	bcm_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
+		    sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
+	if (unlikely(err)) {
+		WL_ERR("Get event_msgs error (%d)\n", err);
+		goto dongle_eventmsg_out;
+	}
+	memcpy(eventmask, iovbuf, WL_EVENTING_MASK_LEN);
+
+	setbit(eventmask, WLC_E_SET_SSID);
+	setbit(eventmask, WLC_E_ROAM);
+	setbit(eventmask, WLC_E_PRUNE);
+	setbit(eventmask, WLC_E_AUTH);
+	setbit(eventmask, WLC_E_REASSOC);
+	setbit(eventmask, WLC_E_REASSOC_IND);
+	setbit(eventmask, WLC_E_DEAUTH_IND);
+	setbit(eventmask, WLC_E_DISASSOC_IND);
+	setbit(eventmask, WLC_E_DISASSOC);
+	setbit(eventmask, WLC_E_JOIN);
+	setbit(eventmask, WLC_E_ASSOC_IND);
+	setbit(eventmask, WLC_E_PSK_SUP);
+	setbit(eventmask, WLC_E_LINK);
+	setbit(eventmask, WLC_E_NDIS_LINK);
+	setbit(eventmask, WLC_E_MIC_ERROR);
+	setbit(eventmask, WLC_E_PMKID_CACHE);
+	setbit(eventmask, WLC_E_TXFAIL);
+	setbit(eventmask, WLC_E_JOIN_START);
+	setbit(eventmask, WLC_E_SCAN_COMPLETE);
+
+	bcm_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
+		    sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	if (unlikely(err)) {
+		WL_ERR("Set event_msgs error (%d)\n", err);
+		goto dongle_eventmsg_out;
+	}
+
+dongle_eventmsg_out:
+	return err;
+}
+
 s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 {
 #ifndef DHD_SDALIGN
@@ -3786,15 +3790,14 @@ s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 	err = wl_dongle_roam(ndev, (wl->roam_on ? 0 : 1), 3);
 	if (unlikely(err))
 		goto default_conf_out;
-	err = wl_dongle_eventmsg(ndev);
-	if (unlikely(err))
-		goto default_conf_out;
-
 	wl_dongle_scantime(ndev, 40, 80);
 	wl_dongle_offload(ndev, 1, 0xf);
 	wl_dongle_filter(ndev, 1);
 #endif				/* !EMBEDDED_PLATFORM */
 
+	err = wl_dongle_eventmsg(ndev);
+	if (unlikely(err))
+		goto default_conf_out;
 	err = wl_dongle_mode(ndev, wdev->iftype);
 	if (unlikely(err && err != -EINPROGRESS))
 		goto default_conf_out;
@@ -3997,11 +4000,6 @@ static bool wl_is_ibssmode(struct wl_priv *wl)
 	return wl->conf->mode == WL_MODE_IBSS;
 }
 
-static bool wl_is_ibssstarter(struct wl_priv *wl)
-{
-	return wl->ibss_starter;
-}
-
 static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 {
 	struct wl_ie *ie = wl_to_ie(wl);
@@ -4020,22 +4018,21 @@ static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 }
 
 
-static void wl_link_up(struct wl_priv *wl)
-{
-	wl->link_up = true;
-}
-
 static void wl_link_down(struct wl_priv *wl)
 {
-	struct wl_connect_info *conn_info = wl_to_conn(wl);
+	struct net_device *dev = NULL;
+	s32 err = 0;
 
-	wl->link_up = false;
-	kfree(conn_info->req_ie);
-	conn_info->req_ie = NULL;
-	conn_info->req_ie_len = 0;
-	kfree(conn_info->resp_ie);
-	conn_info->resp_ie = NULL;
-	conn_info->resp_ie_len = 0;
+	clear_bit(WL_STATUS_CONNECTED, &wl->status);
+
+	if (wl->link_up) {
+		dev = wl_to_ndev(wl);
+		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
+		err = wl_dev_ioctl(dev, WLC_DISASSOC, NULL, 0);
+		if (unlikely(err))
+			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
+		wl->link_up = false;
+	}
 }
 
 static void wl_lock_eq(struct wl_priv *wl)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 3c8b902..6b61010 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -298,7 +298,6 @@ struct wl_priv {
 						 cfg80211 layer */
 	struct wl_ie ie;	/* information element object for
 					 internal purpose */
-	u8 bssid[ETH_ALEN];	/* bssid of currently engaged network */
 	struct semaphore event_sync;	/* for synchronization of main event
 					 thread */
 	struct wl_profile *profile;	/* holding dongle profile */
-- 
1.7.4.1


