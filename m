Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57232 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1ICRWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 13:22:10 -0400
Received: by wyh22 with SMTP id 22so2663692wyh.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 10:22:09 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: AP mode - support hidden SSID
Date: Sat,  3 Sep 2011 20:22:03 +0300
Message-Id: <1315070523-31102-1-git-send-email-arik@wizery.com> (sfid-20110903_192213_192454_13DA8C27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a hidden SSID is requested, generate a probe response template
containing the real SSID.

Depends on the patch "mac80211: add ssid config to bss information
in AP-mode".

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |   24 +++++++----
 drivers/net/wireless/wl12xx/main.c |   75 ++++++++++++++++++++++++++++++++----
 2 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 817bc18..ac6c7b7 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -661,12 +661,9 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_CMD, "cmd role start ap %d", wl->role_id);
 
-	/*
-	 * We currently do not support hidden SSID. The real SSID
-	 * should be fetched from mac80211 first.
-	 */
-	if (wl->ssid_len == 0) {
-		wl1271_warning("Hidden SSID currently not supported for AP");
+	/* trying to use hidden SSID with an old hostapd version */
+	if (wl->ssid_len == 0 && !bss_conf->hidden_ssid) {
+		wl1271_error("got a null SSID from beacon/bss");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -695,9 +692,18 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl)
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
 	cmd->channel = wl->channel;
-	cmd->ap.ssid_len = wl->ssid_len;
-	cmd->ap.ssid_type = WL12XX_SSID_TYPE_PUBLIC;
-	memcpy(cmd->ap.ssid, wl->ssid, wl->ssid_len);
+
+	if (!bss_conf->hidden_ssid) {
+		/* take the SSID from the beacon for backward compatibility */
+		cmd->ap.ssid_type = WL12XX_SSID_TYPE_PUBLIC;
+		cmd->ap.ssid_len = wl->ssid_len;
+		memcpy(cmd->ap.ssid, wl->ssid, wl->ssid_len);
+	} else {
+		cmd->ap.ssid_type = WL12XX_SSID_TYPE_HIDDEN;
+		cmd->ap.ssid_len = bss_conf->ssid_len;
+		memcpy(cmd->ap.ssid, bss_conf->ssid, bss_conf->ssid_len);
+	}
+
 	cmd->ap.local_rates = cpu_to_le32(0xffffffff);
 
 	switch (wl->band) {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bde8402..32b0ab8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3032,6 +3032,62 @@ static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 	return 0;
 }
 
+static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl,
+					 u8 *probe_rsp_data,
+					 size_t probe_rsp_len,
+					 u32 rates)
+{
+	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	u8 probe_rsp_templ[WL1271_CMD_TEMPL_MAX_SIZE];
+	int ssid_ie_offset, ie_offset, templ_len;
+	const u8 *ptr;
+
+	/* no need to change probe response if the SSID is set correctly */
+	if (wl->ssid_len > 0)
+		return wl1271_cmd_template_set(wl,
+					       CMD_TEMPL_AP_PROBE_RESPONSE,
+					       probe_rsp_data,
+					       probe_rsp_len, 0,
+					       rates);
+
+	if (probe_rsp_len + bss_conf->ssid_len > WL1271_CMD_TEMPL_MAX_SIZE) {
+		wl1271_error("probe_rsp template too big");
+		return -EINVAL;
+	}
+
+	/* start searching from IE offset */
+	ie_offset = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+
+	ptr = cfg80211_find_ie(WLAN_EID_SSID, probe_rsp_data + ie_offset,
+			       probe_rsp_len - ie_offset);
+	if (!ptr) {
+		wl1271_error("No SSID in beacon!");
+		return -EINVAL;
+	}
+
+	ssid_ie_offset = ptr - probe_rsp_data;
+	ptr += (ptr[1] + 2);
+
+	memcpy(probe_rsp_templ, probe_rsp_data, ssid_ie_offset);
+
+	/* insert SSID from bss_conf */
+	probe_rsp_templ[ssid_ie_offset] = WLAN_EID_SSID;
+	probe_rsp_templ[ssid_ie_offset + 1] = bss_conf->ssid_len;
+	memcpy(probe_rsp_templ + ssid_ie_offset + 2,
+	       bss_conf->ssid, bss_conf->ssid_len);
+	templ_len = ssid_ie_offset + 2 + bss_conf->ssid_len;
+
+	memcpy(probe_rsp_templ + ssid_ie_offset + 2 + bss_conf->ssid_len,
+	       ptr, probe_rsp_len - (ptr - probe_rsp_data));
+	templ_len += probe_rsp_len - (ptr - probe_rsp_data);
+
+	return wl1271_cmd_template_set(wl,
+				       CMD_TEMPL_AP_PROBE_RESPONSE,
+				       probe_rsp_templ,
+				       templ_len, 0,
+				       rates);
+}
+
 static int wl1271_bss_erp_info_changed(struct wl1271 *wl,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
@@ -3117,14 +3173,17 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		hdr = (struct ieee80211_hdr *) beacon->data;
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_PROBE_RESP);
-
-		tmpl_id = is_ap ? CMD_TEMPL_AP_PROBE_RESPONSE :
-				  CMD_TEMPL_PROBE_RESPONSE;
-		ret = wl1271_cmd_template_set(wl,
-					      tmpl_id,
-					      beacon->data,
-					      beacon->len, 0,
-					      wl1271_tx_min_rate_get(wl));
+		if (is_ap)
+			ret = wl1271_ap_set_probe_resp_tmpl(wl,
+						beacon->data,
+						beacon->len,
+						wl1271_tx_min_rate_get(wl));
+		else
+			ret = wl1271_cmd_template_set(wl,
+						CMD_TEMPL_PROBE_RESPONSE,
+						beacon->data,
+						beacon->len, 0,
+						wl1271_tx_min_rate_get(wl));
 		dev_kfree_skb(beacon);
 		if (ret < 0)
 			goto out;
-- 
1.7.4.1

