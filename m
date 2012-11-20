Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38401 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2KTJEM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:04:12 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id qAK94B3s027315
	for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:04:11 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qAK94B3b030617
	for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:04:11 -0600
From: Luciano Coelho <coelho@ti.com>
To: <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wlcore: avoid using goto in normal code flow
Date: Tue, 20 Nov 2012 11:03:31 +0200
Message-ID: <1353402212-20439-2-git-send-email-coelho@ti.com> (sfid-20121120_100424_197558_D6FABB6F)
In-Reply-To: <1353402212-20439-1-git-send-email-coelho@ti.com>
References: <1353402212-20439-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove goto and label in the code where a simple if can be used.  If
nothing else, this is at least confusing git diff, which shows the
label name as the name of the function.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0eb739b..c056bb3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3884,19 +3884,20 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_HT)) {
 		rcu_read_lock();
 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
-		if (!sta)
-			goto sta_not_found;
-
-		/* save the supp_rates of the ap */
-		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
-		if (sta->ht_cap.ht_supported)
-			sta_rate_set |=
-			  (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET) |
-			  (sta->ht_cap.mcs.rx_mask[1] << HW_MIMO_RATES_OFFSET);
-		sta_ht_cap = sta->ht_cap;
-		sta_exists = true;
-
-sta_not_found:
+		if (sta) {
+			u8 *rx_mask = sta->ht_cap.mcs.rx_mask;
+
+			/* save the supp_rates of the ap */
+			sta_rate_set =
+				sta->supp_rates[wl->hw->conf.channel->band];
+			if (sta->ht_cap.ht_supported)
+				sta_rate_set |=
+					(rx_mask[0] << HW_HT_RATES_OFFSET) |
+					(rx_mask[1] << HW_MIMO_RATES_OFFSET);
+			sta_ht_cap = sta->ht_cap;
+			sta_exists = true;
+		}
+
 		rcu_read_unlock();
 	}
 
-- 
1.7.10.4

