Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34676 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3JURXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:09 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so6867525wgh.17
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:23:08 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 11/14] ti: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:35 +0200
Message-Id: <1382376158-25586-12-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_193807_321189_C0536B83)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ti/wl12xx/scan.c | 2 +-
 drivers/net/wireless/ti/wlcore/cmd.c  | 2 +-
 drivers/net/wireless/ti/wlcore/main.c | 3 +--
 drivers/net/wireless/ti/wlcore/scan.c | 8 ++++----
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
index 4a0bbb1..7541bd1 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.c
+++ b/drivers/net/wireless/ti/wl12xx/scan.c
@@ -47,7 +47,7 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 		     * In active scans, we only scan channels not
 		     * marked as passive.
 		     */
-		    (passive || !(flags & IEEE80211_CHAN_PASSIVE_SCAN))) {
+		    (passive || !(flags & IEEE80211_CHAN_NO_IR))) {
 			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
 				     req->channels[i]->band,
 				     req->channels[i]->center_freq);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 9e5416f8..fccd8a0 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1686,7 +1686,7 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 
 			if (channel->flags & (IEEE80211_CHAN_DISABLED |
 					      IEEE80211_CHAN_RADAR |
-					      IEEE80211_CHAN_PASSIVE_SCAN))
+					      IEEE80211_CHAN_NO_IR))
 				continue;
 
 			ch_bit_idx = wlcore_get_reg_conf_ch_idx(b, ch);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index bbdd106..72ddc08 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -90,8 +90,7 @@ static void wl1271_reg_notify(struct wiphy *wiphy,
 			continue;
 
 		if (ch->flags & IEEE80211_CHAN_RADAR)
-			ch->flags |= IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_PASSIVE_SCAN;
+			ch->flags |= IEEE80211_CHAN_NO_IR;
 
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 13e743d..e4e8978 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -166,14 +166,14 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 		flags = req_channels[i]->flags;
 
 		if (force_passive)
-			flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+			flags |= IEEE80211_CHAN_NO_IR;
 
 		if ((req_channels[i]->band == band) &&
 		    !(flags & IEEE80211_CHAN_DISABLED) &&
 		    (!!(flags & IEEE80211_CHAN_RADAR) == radar) &&
 		    /* if radar is set, we ignore the passive flag */
 		    (radar ||
-		     !!(flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive)) {
+		     !!(flags & IEEE80211_CHAN_NO_IR) == passive)) {
 
 
 			if (flags & IEEE80211_CHAN_RADAR) {
@@ -198,7 +198,7 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 			    (band == IEEE80211_BAND_2GHZ) &&
 			    (channels[j].channel >= 12) &&
 			    (channels[j].channel <= 14) &&
-			    (flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
+			    (flags & IEEE80211_CHAN_NO_IR) &&
 			    !force_passive) {
 				/* pactive channels treated as DFS */
 				channels[j].flags = SCAN_CHANNEL_FLAGS_DFS;
@@ -221,7 +221,7 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 				     max_dwell_time_active,
 				     flags & IEEE80211_CHAN_RADAR ?
 					", DFS" : "",
-				     flags & IEEE80211_CHAN_PASSIVE_SCAN ?
+				     flags & IEEE80211_CHAN_NO_IR?
 					", PASSIVE" : "");
 			j++;
 		}
-- 
1.8.4.rc3

