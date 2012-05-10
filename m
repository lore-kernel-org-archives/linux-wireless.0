Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574Ab2EJJQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:40 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:40 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 59/78] wlcore: update beacon and probe_resp templates when rates change
Date: Thu, 10 May 2012 12:14:04 +0300
Message-Id: <1336641263-5761-60-git-send-email-arik@wizery.com> (sfid-20120510_111833_085303_149947FA)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

When the data rates change, we get BSS_CHANGED_BASIC_RATES.  At this
point, we should update all the templates to match the new rates.  We
were changing some of the templates, but the beacon and the probe
response templates were missing.

[Remove redundant min_rate variable - Arik]

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |  173 +++++++++++++++++++--------------
 1 file changed, 100 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9b8f6a2..f952098 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3276,8 +3276,15 @@ static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates,
 				      skb->data,
 				      skb->len, 0,
 				      rates);
-
 	dev_kfree_skb(skb);
+
+	if (ret < 0)
+		goto out;
+
+	wl1271_debug(DEBUG_AP, "probe response updated");
+	set_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags);
+
+out:
 	return ret;
 }
 
@@ -3382,6 +3389,87 @@ out:
 	return ret;
 }
 
+static int wlcore_set_beacon_template(struct wl1271 *wl,
+				      struct ieee80211_vif *vif,
+				      bool is_ap)
+{
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct ieee80211_hdr *hdr;
+	u32 min_rate;
+	int ret;
+	int ieoffset = offsetof(struct ieee80211_mgmt,
+				u.beacon.variable);
+	struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
+	u16 tmpl_id;
+
+	if (!beacon) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_MASTER, "beacon updated");
+
+	ret = wl1271_ssid_set(vif, beacon, ieoffset);
+	if (ret < 0) {
+		dev_kfree_skb(beacon);
+		goto out;
+	}
+	min_rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
+	tmpl_id = is_ap ? CMD_TEMPL_AP_BEACON :
+		CMD_TEMPL_BEACON;
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id, tmpl_id,
+				      beacon->data,
+				      beacon->len, 0,
+				      min_rate);
+	if (ret < 0) {
+		dev_kfree_skb(beacon);
+		goto out;
+	}
+
+	/*
+	 * In case we already have a probe-resp beacon set explicitly
+	 * by usermode, don't use the beacon data.
+	 */
+	if (test_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags))
+		goto end_bcn;
+
+	/* remove TIM ie from probe response */
+	wl12xx_remove_ie(beacon, WLAN_EID_TIM, ieoffset);
+
+	/*
+	 * remove p2p ie from probe response.
+	 * the fw reponds to probe requests that don't include
+	 * the p2p ie. probe requests with p2p ie will be passed,
+	 * and will be responded by the supplicant (the spec
+	 * forbids including the p2p ie when responding to probe
+	 * requests that didn't include it).
+	 */
+	wl12xx_remove_vendor_ie(beacon, WLAN_OUI_WFA,
+				WLAN_OUI_TYPE_WFA_P2P, ieoffset);
+
+	hdr = (struct ieee80211_hdr *) beacon->data;
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					 IEEE80211_STYPE_PROBE_RESP);
+	if (is_ap)
+		ret = wl1271_ap_set_probe_resp_tmpl_legacy(wl, vif,
+							   beacon->data,
+							   beacon->len,
+							   min_rate);
+	else
+		ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+					      CMD_TEMPL_PROBE_RESPONSE,
+					      beacon->data,
+					      beacon->len, 0,
+					      min_rate);
+end_bcn:
+	dev_kfree_skb(beacon);
+	if (ret < 0)
+		goto out;
+
+out:
+	return ret;
+}
+
 static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 					  struct ieee80211_vif *vif,
 					  struct ieee80211_bss_conf *bss_conf,
@@ -3400,81 +3488,12 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 
 	if ((changed & BSS_CHANGED_AP_PROBE_RESP) && is_ap) {
 		u32 rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
-		if (!wl1271_ap_set_probe_resp_tmpl(wl, rate, vif)) {
-			wl1271_debug(DEBUG_AP, "probe response updated");
-			set_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags);
-		}
+
+		wl1271_ap_set_probe_resp_tmpl(wl, rate, vif);
 	}
 
 	if ((changed & BSS_CHANGED_BEACON)) {
-		struct ieee80211_hdr *hdr;
-		u32 min_rate;
-		int ieoffset = offsetof(struct ieee80211_mgmt,
-					u.beacon.variable);
-		struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
-		u16 tmpl_id;
-
-		if (!beacon) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		wl1271_debug(DEBUG_MASTER, "beacon updated");
-
-		ret = wl1271_ssid_set(vif, beacon, ieoffset);
-		if (ret < 0) {
-			dev_kfree_skb(beacon);
-			goto out;
-		}
-		min_rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
-		tmpl_id = is_ap ? CMD_TEMPL_AP_BEACON :
-				  CMD_TEMPL_BEACON;
-		ret = wl1271_cmd_template_set(wl, wlvif->role_id, tmpl_id,
-					      beacon->data,
-					      beacon->len, 0,
-					      min_rate);
-		if (ret < 0) {
-			dev_kfree_skb(beacon);
-			goto out;
-		}
-
-		/*
-		 * In case we already have a probe-resp beacon set explicitly
-		 * by usermode, don't use the beacon data.
-		 */
-		if (test_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags))
-			goto end_bcn;
-
-		/* remove TIM ie from probe response */
-		wl12xx_remove_ie(beacon, WLAN_EID_TIM, ieoffset);
-
-		/*
-		 * remove p2p ie from probe response.
-		 * the fw reponds to probe requests that don't include
-		 * the p2p ie. probe requests with p2p ie will be passed,
-		 * and will be responded by the supplicant (the spec
-		 * forbids including the p2p ie when responding to probe
-		 * requests that didn't include it).
-		 */
-		wl12xx_remove_vendor_ie(beacon, WLAN_OUI_WFA,
-					WLAN_OUI_TYPE_WFA_P2P, ieoffset);
-
-		hdr = (struct ieee80211_hdr *) beacon->data;
-		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						 IEEE80211_STYPE_PROBE_RESP);
-		if (is_ap)
-			ret = wl1271_ap_set_probe_resp_tmpl_legacy(wl, vif,
-						beacon->data,
-						beacon->len,
-						min_rate);
-		else
-			ret = wl1271_cmd_template_set(wl, wlvif->role_id,
-						CMD_TEMPL_PROBE_RESPONSE,
-						beacon->data,
-						beacon->len, 0,
-						min_rate);
-end_bcn:
-		dev_kfree_skb(beacon);
+		ret = wlcore_set_beacon_template(wl, vif, is_ap);
 		if (ret < 0)
 			goto out;
 	}
@@ -3511,6 +3530,14 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 		ret = wl1271_ap_init_templates(wl, vif);
 		if (ret < 0)
 			goto out;
+
+		ret = wl1271_ap_set_probe_resp_tmpl(wl, wlvif->basic_rate, vif);
+		if (ret < 0)
+			goto out;
+
+		ret = wlcore_set_beacon_template(wl, vif, true);
+		if (ret < 0)
+			goto out;
 	}
 
 	ret = wl1271_bss_beacon_info_changed(wl, vif, bss_conf, changed);
-- 
1.7.9.5

