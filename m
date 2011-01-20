Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36114 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1ATU3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:29:10 -0500
Received: by fxm20 with SMTP id 20so1004801fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 12:29:09 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/3] wl12xx: AP mode - support hidden SSID
Date: Thu, 20 Jan 2011 22:28:26 +0200
Message-Id: <1295555306-20005-3-git-send-email-arik@wizery.com>
In-Reply-To: <1295555306-20005-1-git-send-email-arik@wizery.com>
References: <1295555306-20005-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Detect whether our SSID is hidden by comparing beacon data with
the SSID in bss_conf.

If a hidden SSID is requested, generate a probe response tamplate
containing the real SSID.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |   23 ++++------
 drivers/net/wireless/wl12xx/main.c |   81 ++++++++++++++++++++++++++++++++----
 2 files changed, 83 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index e28d9ca..7a6f39e 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -966,16 +966,6 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_CMD, "cmd start bss");
 
-	/*
-	 * FIXME: We currently do not support hidden SSID. The real SSID
-	 * should be fetched from mac80211 first.
-	 */
-	if (wl->ssid_len == 0) {
-		wl1271_warning("Hidden SSID currently not supported for AP");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
@@ -993,9 +983,16 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 	cmd->dtim_interval = bss_conf->dtim_period;
 	cmd->beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
 	cmd->channel = wl->channel;
-	cmd->ssid_len = wl->ssid_len;
-	cmd->ssid_type = SSID_TYPE_PUBLIC;
-	memcpy(cmd->ssid, wl->ssid, wl->ssid_len);
+
+	/* We use a visible SSID if the beacon SSID matches bss_conf */
+	if (wl->ssid_len > 0 && wl->ssid_len == bss_conf->ssid_len &&
+	    !memcmp(wl->ssid, bss_conf->ssid, wl->ssid_len))
+		cmd->ssid_type = SSID_TYPE_PUBLIC;
+	else
+		cmd->ssid_type = SSID_TYPE_HIDDEN;
+
+	cmd->ssid_len = bss_conf->ssid_len;
+	memcpy(cmd->ssid, bss_conf->ssid, bss_conf->ssid_len);
 
 	switch (wl->band) {
 	case IEEE80211_BAND_2GHZ:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9076555..b73d750 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2041,6 +2041,66 @@ static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 	return -ENOENT;
 }
 
+static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl,
+					 u8 *probe_rsp_data,
+					 size_t probe_rsp_len,
+					 u32 rates)
+{
+	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	u8 probe_rsp_templ[WL1271_CMD_TEMPL_MAX_SIZE];
+	int ssid_ie_offset, ie_offset, templ_len;
+	u8 *ptr;
+
+	/* no need to change probe response if the SSID is set correctly */
+	if (wl->ssid_len > 0 && wl->ssid_len == bss_conf->ssid_len &&
+	    !memcmp(wl->ssid, bss_conf->ssid, wl->ssid_len))
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
+	ptr = probe_rsp_data + ie_offset;
+
+	while (ptr < probe_rsp_data + probe_rsp_len) {
+		if (ptr[0] == WLAN_EID_SSID)
+			break;
+		ptr += (ptr[1] + 2);
+	}
+
+	if (ptr == probe_rsp_data + probe_rsp_len)
+		return -EINVAL;
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
@@ -2126,20 +2186,25 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
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
 	}
 
 out:
+	if (ret != 0)
+		wl1271_error("beacon info change failed: %d", ret);
 	return ret;
 }
 
-- 
1.7.1

