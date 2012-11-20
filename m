Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2KTLU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:27 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:26 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 09/11] wlcore: reconfigure rate policy on association
Date: Tue, 20 Nov 2012 13:20:09 +0200
Message-Id: <1353410411-18833-10-git-send-email-eliad@wizery.com> (sfid-20121120_124526_537536_6AC22159)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When first configuring the rate policy, before auth,
we still don't have the correct rates that were
agreed during association.

Reconfigure the rate policy on association in order
to update them.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6170e9e..ade206a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2553,7 +2553,8 @@ static int wlcore_set_ssid(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 }
 
 static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			    struct ieee80211_bss_conf *bss_conf)
+			    struct ieee80211_bss_conf *bss_conf,
+			    u32 sta_rate_set)
 {
 	int ieoffset;
 	int ret;
@@ -2619,6 +2620,18 @@ static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	 * setting is off (ACTIVE), so sync the fw with the correct value.
 	 */
 	ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE);
+	if (ret < 0)
+		return ret;
+
+	if (sta_rate_set) {
+		wlvif->rate_set =
+			wl1271_tx_enabled_rates_get(wl,
+						    sta_rate_set,
+						    wlvif->band);
+		ret = wl1271_acx_sta_rate_policies(wl, wlvif);
+		if (ret < 0)
+			return ret;
+	}
 
 	return ret;
 }
@@ -3912,7 +3925,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		wlvif->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if (changed & (BSS_CHANGED_BSSID | BSS_CHANGED_HT)) {
+	if (changed & (BSS_CHANGED_BSSID | BSS_CHANGED_HT |
+		       BSS_CHANGED_ASSOC)) {
 		rcu_read_lock();
 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
 		if (!sta)
@@ -3982,7 +3996,8 @@ sta_not_found:
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			ret = wlcore_set_assoc(wl, wlvif, bss_conf);
+			ret = wlcore_set_assoc(wl, wlvif, bss_conf,
+					       sta_rate_set);
 			if (ret < 0)
 				goto out;
 
-- 
1.7.6.401.g6a319

