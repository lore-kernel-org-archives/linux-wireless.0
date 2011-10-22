Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39426 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1JVNQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:16:34 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so5989302bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 06:16:33 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wl12xx: configure probe-resp template according to notification
Date: Sat, 22 Oct 2011 15:14:39 +0200
Message-Id: <1319289279-21950-2-git-send-email-guy@wizery.com> (sfid-20111022_151636_476049_70B9E589)
In-Reply-To: <1319289279-21950-1-git-send-email-guy@wizery.com>
References: <1319289279-21950-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP-mode, replace probe-response template when a
notification is recieved from mac80211. We preserve the "legacy" way of
configuring a probe-response according to beacon for IBSS mode and for
versions of hostapd that do not support this feature.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   57 +++++++++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0a7d020..d91842d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3311,11 +3311,33 @@ static void wl12xx_remove_vendor_ie(struct sk_buff *skb,
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
+	if (!ret)
+		set_bit(WL1271_FLAG_PROBE_RESP_SET, &wl->flags);
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
@@ -3428,6 +3450,13 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		wlvif->beacon_int = bss_conf->beacon_int;
 	}
 
+	if ((changed & BSS_CHANGED_AP_PROBE_RESP) && is_ap) {
+		ret = wl1271_ap_set_probe_resp_tmpl(wl,
+			wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set));
+		if (ret < 0)
+			goto out;
+	}
+
 	if ((changed & BSS_CHANGED_BEACON)) {
 		struct ieee80211_hdr *hdr;
 		u32 min_rate;
@@ -3436,8 +3465,10 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
 		u16 tmpl_id;
 
-		if (!beacon)
+		if (!beacon) {
+			ret = -EINVAL;
 			goto out;
+		}
 
 		wl1271_debug(DEBUG_MASTER, "beacon updated");
 
@@ -3458,6 +3489,13 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 			goto out;
 		}
 
+		/*
+		 * In case we already have a probe-resp beacon set explicitly
+		 * by usermode, don't use the beacon data.
+		 */
+		if (test_bit(WL1271_FLAG_PROBE_RESP_SET, &wl->flags))
+			goto end_bcn;
+
 		/* remove TIM ie from probe response */
 		wl12xx_remove_ie(beacon, WLAN_EID_TIM, ieoffset);
 
@@ -3476,7 +3514,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_PROBE_RESP);
 		if (is_ap)
-			ret = wl1271_ap_set_probe_resp_tmpl(wl, vif,
+			ret = wl1271_ap_set_probe_resp_tmpl_legacy(wl, vif,
 						beacon->data,
 						beacon->len,
 						min_rate);
@@ -3486,12 +3524,15 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
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
 
@@ -3548,6 +3589,8 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 					goto out;
 
 				clear_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags);
+				clear_bit(WL1271_FLAG_PROBE_RESP_SET,
+					    &wl->flags);
 				wl1271_debug(DEBUG_AP, "stopped AP");
 			}
 		}
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b7036df..a117c9d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -255,6 +255,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_PENDING_WORK,
 	WL1271_FLAG_SOFT_GEMINI,
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
+	WL1271_FLAG_PROBE_RESP_SET,
 };
 
 enum wl12xx_vif_flags {
-- 
1.7.4.1

