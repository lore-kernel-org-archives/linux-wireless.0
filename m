Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63057 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2KSQj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:56 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1209547eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:56 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/15] wlcore: reconfigure rate policy on association
Date: Mon, 19 Nov 2012 18:39:28 +0200
Message-Id: <1353343170-26516-14-git-send-email-eliad@wizery.com> (sfid-20121119_174527_961650_3D08F054)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When first configuring the rate policy, before auth,
we still don't have the correct rates that were
agreed during association.

Reconfigure the rate policy on association in order
to update them.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0dd0ec1..a1ad326 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3771,7 +3771,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		wlvif->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if (changed & (BSS_CHANGED_BSSID | BSS_CHANGED_HT)) {
+	if (changed & (BSS_CHANGED_BSSID | BSS_CHANGED_HT |
+		       BSS_CHANGED_ASSOC)) {
 		rcu_read_lock();
 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
 		if (!sta)
@@ -3958,6 +3959,17 @@ sta_not_found:
 		if (ret < 0)
 			goto out;
 
+		if (sta_rate_set) {
+			wlvif->rate_set =
+				wl1271_tx_enabled_rates_get(wl,
+							    sta_rate_set,
+							    wlvif->band);
+
+			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
+			if (ret < 0)
+				goto out;
+		}
+
 		if (test_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags))
 			wl12xx_set_authorized(wl, wlvif);
 	}
-- 
1.7.6.401.g6a319

