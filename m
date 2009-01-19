Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28497 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZASHjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 02:39:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 23:39:21 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18804.11602.400684.88722@gargle.gargle.HOWL> (sfid-20090119_083932_599848_7920E8B0)
Date: Mon, 19 Jan 2009 13:05:46 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>
Subject: [PATCH] mac80211: Reconfigure beacons after a merge run in IBSS mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On completion of a merge scan run in IBSS mode, beacons have
to be reconfigured in the driver, so that the HW timers are updated
properly when coming back to the home channel. This patch fixes this issue.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/mlme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 81c5cff..2b4ed5f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2295,8 +2295,9 @@ dont_join:
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED &&
 	    !ieee80211_sta_active_ibss(sdata)) {
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
 		mod_timer(&ifsta->timer, jiffies +
-				      IEEE80211_IBSS_MERGE_INTERVAL);
+			  IEEE80211_IBSS_MERGE_INTERVAL);
 	} else if (time_after(jiffies, local->last_scan_completed +
 			      IEEE80211_SCAN_INTERVAL)) {
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
-- 
1.6.1

