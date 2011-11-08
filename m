Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49347 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab1KHOgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:36:17 -0500
Received: by wyh15 with SMTP id 15so536453wyh.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:36:16 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 1/2] wl12xx: configure probe-resp template according to notification
Date: Tue,  8 Nov 2011 16:36:09 +0200
Message-Id: <1320762970-6860-1-git-send-email-arik@wizery.com> (sfid-20111108_153620_505329_E022BD77)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP-mode, replace our probe-response template when a
notification is recieved from mac80211. We preserve the "legacy" way of
configuring a probe-response according to beacon for IBSS mode and for
versions of hostapd that do not support this feature.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->3:
re-factor the code a bit and turn the PROBE_RESP_SET flag into a per-vif
flag.

drivers/net/wireless/wl12xx/main.c   |   57 +++++++++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dbb088e..3750a6e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3299,11 +3299,30 @@ static void wl12xx_remove_vendor_ie(struct sk_buff *skb,
 	skb_trim(skb, skb->len - len);
 }
 
-static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl,
-					 struct ieee80211_vif *vif,
-					 u8 *probe_rsp_data,
-					 size_t probe_rsp_len,
-					 u32 rates)
+static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	skb = ieee80211_proberesp_get(wl->hw, wl->vif);
+	if (!skb)
+		return -EINVAL;
+
+	ret = wl1271_cmd_template_set(wl,
+				      CMD_TEMPL_AP_PROBE_RESPONSE,
+				      skb->data,
+				      skb->len, 0,
+				      rates);
+
+	dev_kfree_skb(skb);
+	return ret;
+}
+
+static int wl1271_ap_set_probe_resp_tmpl_legacy(struct wl1271 *wl,
+					     struct ieee80211_vif *vif,
+					     u8 *probe_rsp_data,
+					     size_t probe_rsp_len,
+					     u32 rates)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
@@ -3416,6 +3435,16 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		wlvif->beacon_int = bss_conf->beacon_int;
 	}
 
+	if ((changed & BSS_CHANGED_AP_PROBE_RESP) && is_ap) {
+		u32 rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
+		ret = wl1271_ap_set_probe_resp_tmpl(wl, rate);
+		if (ret < 0)
+			goto out;
+
+		wl1271_debug(DEBUG_AP, "probe response updated");
+		set_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags);
+	}
+
 	if ((changed & BSS_CHANGED_BEACON)) {
 		struct ieee80211_hdr *hdr;
 		u32 min_rate;
@@ -3424,8 +3453,10 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
 		u16 tmpl_id;
 
-		if (!beacon)
+		if (!beacon) {
+			ret = -EINVAL;
 			goto out;
+		}
 
 		wl1271_debug(DEBUG_MASTER, "beacon updated");
 
@@ -3446,6 +3477,13 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 			goto out;
 		}
 
+		/*
+		 * In case we already have a probe-resp beacon set explicitly
+		 * by usermode, don't use the beacon data.
+		 */
+		if (test_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags))
+			goto end_bcn;
+
 		/* remove TIM ie from probe response */
 		wl12xx_remove_ie(beacon, WLAN_EID_TIM, ieoffset);
 
@@ -3464,7 +3502,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_PROBE_RESP);
 		if (is_ap)
-			ret = wl1271_ap_set_probe_resp_tmpl(wl, vif,
+			ret = wl1271_ap_set_probe_resp_tmpl_legacy(wl, vif,
 						beacon->data,
 						beacon->len,
 						min_rate);
@@ -3474,12 +3512,15 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 						beacon->data,
 						beacon->len, 0,
 						min_rate);
+end_bcn:
 		dev_kfree_skb(beacon);
 		if (ret < 0)
 			goto out;
 	}
 
 out:
+	if (ret != 0)
+		wl1271_error("beacon info change failed: %d", ret);
 	return ret;
 }
 
@@ -3536,6 +3577,8 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 					goto out;
 
 				clear_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags);
+				clear_bit(WLVIF_FLAG_AP_PROBE_RESP_SET,
+					  &wlvif->flags);
 				wl1271_debug(DEBUG_AP, "stopped AP");
 			}
 		}
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index e58e801..f1c9117 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -268,6 +268,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_RX_STREAMING_STARTED,
 	WLVIF_FLAG_PSPOLL_FAILURE,
 	WLVIF_FLAG_CS_PROGRESS,
+	WLVIF_FLAG_AP_PROBE_RESP_SET,
 };
 
 struct wl1271_link {
-- 
1.7.5.4

