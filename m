Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64765 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1KVRxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 12:53:07 -0500
Received: by fagn18 with SMTP id n18so694450fag.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 09:53:06 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: avoid bail out when probe-resp is not set by mac80211
Date: Tue, 22 Nov 2011 19:52:59 +0200
Message-Id: <1321984379-1565-1-git-send-email-arik@wizery.com> (sfid-20111122_185311_477216_CC9418CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During reconfig we can get the BSS_CHANGED_AP_PROBE_RESP indication
even if a probe-resp has not been set in the first place. Therefore
ignore the error when not getting a probe-resp from mac80211. Resort to
the legacy probe-resp in this case.

Also take this opportunity to add a vif argument to the set_probe_resp
function.

Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 08b06ee..8c58001 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3299,14 +3299,15 @@ static void wl12xx_remove_vendor_ie(struct sk_buff *skb,
 	skb_trim(skb, skb->len - len);
 }
 
-static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates)
+static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates,
+					 struct ieee80211_vif *vif)
 {
 	struct sk_buff *skb;
 	int ret;
 
-	skb = ieee80211_proberesp_get(wl->hw, wl->vif);
+	skb = ieee80211_proberesp_get(wl->hw, vif);
 	if (!skb)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	ret = wl1271_cmd_template_set(wl,
 				      CMD_TEMPL_AP_PROBE_RESPONSE,
@@ -3437,12 +3438,10 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 
 	if ((changed & BSS_CHANGED_AP_PROBE_RESP) && is_ap) {
 		u32 rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
-		ret = wl1271_ap_set_probe_resp_tmpl(wl, rate);
-		if (ret < 0)
-			goto out;
-
-		wl1271_debug(DEBUG_AP, "probe response updated");
-		set_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags);
+		if (!wl1271_ap_set_probe_resp_tmpl(wl, rate, vif)) {
+			wl1271_debug(DEBUG_AP, "probe response updated");
+			set_bit(WLVIF_FLAG_AP_PROBE_RESP_SET, &wlvif->flags);
+		}
 	}
 
 	if ((changed & BSS_CHANGED_BEACON)) {
-- 
1.7.5.4

