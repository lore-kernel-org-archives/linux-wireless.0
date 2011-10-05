Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57591 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241Ab1JEJ4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:01 -0400
Received: by wwf22 with SMTP id 22so2263866wwf.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/29] wl12xx: move ssid and ssid_len into wlvif
Date: Wed,  5 Oct 2011 11:55:48 +0200
Message-Id: <1317808566-18857-12-git-send-email-eliad@wizery.com> (sfid-20111005_115606_950376_7F512B88)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move ssid and ssid_len into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   14 +++++++-------
 drivers/net/wireless/wl12xx/main.c   |   21 +++++++++++----------
 drivers/net/wireless/wl12xx/wl12xx.h |    5 +++--
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index a0a5051..d81c550 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -576,8 +576,8 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->sta.beacon_interval = cpu_to_le16(wl->beacon_int);
 	cmd->sta.ssid_type = WL12XX_SSID_TYPE_ANY;
-	cmd->sta.ssid_len = wl->ssid_len;
-	memcpy(cmd->sta.ssid, wl->ssid, wl->ssid_len);
+	cmd->sta.ssid_len = wlvif->ssid_len;
+	memcpy(cmd->sta.ssid, wlvif->ssid, wlvif->ssid_len);
 	memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
@@ -659,7 +659,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl1271_debug(DEBUG_CMD, "cmd role start ap %d", wl->role_id);
 
 	/* trying to use hidden SSID with an old hostapd version */
-	if (wl->ssid_len == 0 && !bss_conf->hidden_ssid) {
+	if (wlvif->ssid_len == 0 && !bss_conf->hidden_ssid) {
 		wl1271_error("got a null SSID from beacon/bss");
 		ret = -EINVAL;
 		goto out;
@@ -693,8 +693,8 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (!bss_conf->hidden_ssid) {
 		/* take the SSID from the beacon for backward compatibility */
 		cmd->ap.ssid_type = WL12XX_SSID_TYPE_PUBLIC;
-		cmd->ap.ssid_len = wl->ssid_len;
-		memcpy(cmd->ap.ssid, wl->ssid, wl->ssid_len);
+		cmd->ap.ssid_len = wlvif->ssid_len;
+		memcpy(cmd->ap.ssid, wlvif->ssid, wlvif->ssid_len);
 	} else {
 		cmd->ap.ssid_type = WL12XX_SSID_TYPE_HIDDEN;
 		cmd->ap.ssid_len = bss_conf->ssid_len;
@@ -791,8 +791,8 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ibss.beacon_interval = cpu_to_le16(wl->beacon_int);
 	cmd->ibss.dtim_interval = bss_conf->dtim_period;
 	cmd->ibss.ssid_type = WL12XX_SSID_TYPE_ANY;
-	cmd->ibss.ssid_len = wl->ssid_len;
-	memcpy(cmd->ibss.ssid, wl->ssid, wl->ssid_len);
+	cmd->ibss.ssid_len = wlvif->ssid_len;
+	memcpy(cmd->ibss.ssid, wlvif->ssid, wlvif->ssid_len);
 	memcpy(cmd->ibss.bssid, vif->bss_conf.bssid, ETH_ALEN);
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 28e53a9..c8acd33 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2103,8 +2103,6 @@ deinit:
 	wl1271_tx_reset(wl, reset_tx_queues);
 	wl1271_power_off(wl);
 
-	memset(wl->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
-	wl->ssid_len = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
@@ -3073,9 +3071,10 @@ out:
 	return ret;
 }
 
-static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
+static int wl1271_ssid_set(struct ieee80211_vif *vif, struct sk_buff *skb,
 			    int offset)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	u8 ssid_len;
 	const u8 *ptr = cfg80211_find_ie(WLAN_EID_SSID, skb->data + offset,
 					 skb->len - offset);
@@ -3091,8 +3090,8 @@ static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	wl->ssid_len = ssid_len;
-	memcpy(wl->ssid, ptr+2, ssid_len);
+	wlvif->ssid_len = ssid_len;
+	memcpy(wlvif->ssid, ptr+2, ssid_len);
 	return 0;
 }
 
@@ -3128,17 +3127,19 @@ static void wl12xx_remove_vendor_ie(struct sk_buff *skb,
 }
 
 static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl,
+					 struct ieee80211_vif *vif,
 					 u8 *probe_rsp_data,
 					 size_t probe_rsp_len,
 					 u32 rates)
 {
-	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	u8 probe_rsp_templ[WL1271_CMD_TEMPL_MAX_SIZE];
 	int ssid_ie_offset, ie_offset, templ_len;
 	const u8 *ptr;
 
 	/* no need to change probe response if the SSID is set correctly */
-	if (wl->ssid_len > 0)
+	if (wlvif->ssid_len > 0)
 		return wl1271_cmd_template_set(wl,
 					       CMD_TEMPL_AP_PROBE_RESPONSE,
 					       probe_rsp_data,
@@ -3251,7 +3252,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 
 		wl1271_debug(DEBUG_MASTER, "beacon updated");
 
-		ret = wl1271_ssid_set(wl, beacon, ieoffset);
+		ret = wl1271_ssid_set(vif, beacon, ieoffset);
 		if (ret < 0) {
 			dev_kfree_skb(beacon);
 			goto out;
@@ -3286,7 +3287,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_PROBE_RESP);
 		if (is_ap)
-			ret = wl1271_ap_set_probe_resp_tmpl(wl,
+			ret = wl1271_ap_set_probe_resp_tmpl(wl, vif,
 						beacon->data,
 						beacon->len,
 						min_rate);
@@ -3523,7 +3524,7 @@ sta_not_found:
 			wl->probereq = wl1271_cmd_build_ap_probe_req(wl, NULL);
 			ieoffset = offsetof(struct ieee80211_mgmt,
 					    u.probe_req.variable);
-			wl1271_ssid_set(wl, wl->probereq, ieoffset);
+			wl1271_ssid_set(vif, wl->probereq, ieoffset);
 
 			/* enable the connection monitoring feature */
 			ret = wl1271_acx_conn_monit_params(wl, true);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 61f3658..df24500 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -399,8 +399,6 @@ struct wl1271 {
 	s8 hw_pg_ver;
 
 	u8 mac_addr[ETH_ALEN];
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 ssid_len;
 	int channel;
 	u8 role_id;
 	u8 dev_role_id;
@@ -629,6 +627,9 @@ struct wl12xx_vif {
 	u8 bss_type;
 	u8 p2p; /* we are using p2p role */
 
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
+	u8 ssid_len;
+
 	u32 basic_rate_set;
 
 	/*
-- 
1.7.6.401.g6a319

