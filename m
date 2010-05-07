Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:17754 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0EGIjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 04:39:35 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 3/5] wl1271: Fix to join and channel number handling
Date: Fri,  7 May 2010 11:39:00 +0300
Message-Id: <1273221542-14283-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
References: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch changes the way JOIN's are performed, and channel numbers updated.
The reason for this is that the firmware JOIN command clears WPA(2) key
material, and if done while associated to a WPA(2) secured AP, will render
the data-path unusable.

While the channel is not usually changed while associated (and currently we
could not even support something like that), after performing a scan operation
while associated, mac80211 will re-set the current channel to the driver. This
caused our problem.

Also, the mac80211 is assuming that the driver channel configuration remains
persistent over periods of IDLE. Therefore remove channel resetting to zero
from the unjoin function.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 5ad94fc..360daf8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1140,10 +1140,25 @@ out:
 	return ret;
 }
 
-static int wl1271_join(struct wl1271 *wl)
+static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 {
 	int ret;
 
+	/*
+	 * One of the side effects of the JOIN command is that is clears
+	 * WPA/WPA2 keys from the chipset. Performing a JOIN while associated
+	 * to a WPA/WPA2 access point will therefore kill the data-path.
+	 * Currently there is no supported scenario for JOIN during
+	 * association - if it becomes a supported scenario, the WPA/WPA2 keys
+	 * must be handled somehow.
+	 *
+	 */
+	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		wl1271_info("JOIN while associated.");
+
+	if (set_assoc)
+		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
+
 	ret = wl1271_cmd_join(wl, wl->set_bss_type);
 	if (ret < 0)
 		goto out;
@@ -1190,7 +1205,6 @@ static int wl1271_unjoin(struct wl1271 *wl)
 		goto out;
 
 	clear_bit(WL1271_FLAG_JOINED, &wl->flags);
-	wl->channel = 0;
 	memset(wl->bssid, 0, ETH_ALEN);
 
 	/* stop filterting packets based on bssid */
@@ -1250,7 +1264,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 
 	/* if the channel changes while joined, join again */
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
+	    ((wl->band != conf->channel->band) ||
+	     (wl->channel != channel))) {
 		wl->band = conf->channel->band;
 		wl->channel = channel;
 
@@ -1270,7 +1286,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 				       "failed %d", ret);
 
 		if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
-			ret = wl1271_join(wl);
+			ret = wl1271_join(wl, false);
 			if (ret < 0)
 				wl1271_warning("cmd join to update channel "
 					       "failed %d", ret);
@@ -1652,6 +1668,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
 	bool do_join = false;
+	bool set_assoc = false;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
@@ -1761,7 +1778,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (bss_conf->assoc) {
 			u32 rates;
 			wl->aid = bss_conf->aid;
-			set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
+			set_assoc = true;
 
 			/*
 			 * use basic rates from AP, and determine lowest rate
@@ -1861,7 +1878,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (do_join) {
-		ret = wl1271_join(wl);
+		ret = wl1271_join(wl, set_assoc);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out_sleep;
-- 
1.6.3.3

