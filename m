Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762183AbZEGMXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 08:23:08 -0400
Subject: [PATCH] mac80211: fix scan channel race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 07 May 2009 14:23:01 +0200
Message-Id: <1241698981.27208.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a software scan starts, it first sets sw_scanning, but
leaves the scan_channel "unset" (it currently actually gets
initialised to a default). Now, when something else tries
to (re)configure the hardware in the window between these two
events (after sw_scanning = true, but before scan_channel is
set), the current code switches to the (unset!) scan_channel.
This causes trouble, especially when switching bands and
sending frames on the wrong channel.

To work around this, leave scan_channel initialised to NULL
and use it to determine whether or not a switch to a different
channel should occur (and also use the same condition to check
whether to adjust power for scan or not).

Additionally, avoid reconfiguring the hardware completely when
recalculating idle resulted in no changes, this was the problem
that originally led us to discover the race condition in the
first place, which was helpfully bisected by Pavel. This part
of the patch should not be necessary with the other fixes, but
not calling the ieee80211_hw_config function when we know it to
be unnecessary is certainly a correct thing to do.

Unfortunately, this patch cannot and does not fix the race
condition completely, but due to the way the scan code is
structured it makes the particular problem Pavel discovered
(race while changing channel at the same time as transmitting
frames) go away. To fix it completely, more work especially
with locking configuration is needed.

Bisected-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Pavel, I would appreciate if you could give it a quick test run, I don't
seem to have a dual-band card with me right now.

 net/mac80211/iface.c |    3 ++-
 net/mac80211/main.c  |   14 ++++++++------
 net/mac80211/scan.c  |    1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-05-06 22:25:45.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-05-06 22:25:53.000000000 +0200
@@ -964,5 +964,6 @@ void ieee80211_recalc_idle(struct ieee80
 	mutex_lock(&local->iflist_mtx);
 	chg = __ieee80211_recalc_idle(local);
 	mutex_unlock(&local->iflist_mtx);
-	ieee80211_hw_config(local, chg);
+	if (chg)
+		ieee80211_hw_config(local, chg);
 }
--- wireless-testing.orig/net/mac80211/main.c	2009-05-07 09:04:56.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-05-07 14:17:05.000000000 +0200
@@ -154,15 +154,17 @@ static void ieee80211_master_set_multica
 
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
-	struct ieee80211_channel *chan;
+	struct ieee80211_channel *chan, *scan_chan;
 	int ret = 0;
 	int power;
 	enum nl80211_channel_type channel_type;
 
 	might_sleep();
 
-	if (local->sw_scanning) {
-		chan = local->scan_channel;
+	scan_chan = local->scan_channel;
+
+	if (scan_chan) {
+		chan = scan_chan;
 		channel_type = NL80211_CHAN_NO_HT;
 	} else {
 		chan = local->oper_channel;
@@ -176,7 +178,7 @@ int ieee80211_hw_config(struct ieee80211
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
-	if (local->sw_scanning)
+	if (scan_chan)
 		power = chan->max_power;
 	else
 		power = local->power_constr_level ?
@@ -859,8 +861,8 @@ int ieee80211_register_hw(struct ieee802
 		if (!local->oper_channel) {
 			/* init channel we're on */
 			local->hw.conf.channel =
-			local->oper_channel =
-			local->scan_channel = &sband->channels[0];
+			local->oper_channel = &sband->channels[0];
+			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
 		}
 		channels += sband->n_channels;
 
--- wireless-testing.orig/net/mac80211/scan.c	2009-05-07 09:07:44.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-05-07 09:08:52.000000000 +0200
@@ -298,6 +298,7 @@ void ieee80211_scan_completed(struct iee
 	was_hw_scan = local->hw_scanning;
 	local->hw_scanning = false;
 	local->sw_scanning = false;
+	local->scan_channel = NULL;
 
 	/* we only have to protect scan_req and hw/sw scan */
 	mutex_unlock(&local->scan_mtx);


