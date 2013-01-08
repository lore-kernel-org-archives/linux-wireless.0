Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab3AHSK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 13:10:56 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 3/3] mac80211: Disable off-channel powersave when software scans are suspended
Date: Tue,  8 Jan 2013 12:10:45 -0600
Message-Id: <1357668645-5101-4-git-send-email-seth.forshee@canonical.com> (sfid-20130108_191058_720741_DC08EF27)
In-Reply-To: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Leaving powersave enabled while the scan is suspended requires the use
of PS-Poll to retrieve frames buffered at the AP. PS-Poll isn't a very
efficient means of data transfer and may not even work with drivers not
supporting powersave. These problems can largely be avoided by simply
disabling off-channel powersave when the scan is suspended and enabling
it again when returning to off-channel operation.

The results of this change are fantastic. Previously when using iperf I
would see greatly decreased throughput (often dropping to 0 bits/sec for
several seconds) and very high packet loss during software scans. This
patch completely eliminates the packet loss and reduces the loss in
throughput to very reasonable levels.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a875f74..f982dda 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -699,11 +699,11 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	/*
-	 * Re-enable vifs and beaconing.  Leave PS
-	 * in off-channel state..will put that back
-	 * on-channel at the end of scanning.
+	 * Re-enable vifs and beaconing.  Disable PS
+	 * while the scan is suspended for more
+	 * efficient frame rx than with PS-Poll.
 	 */
-	ieee80211_offchannel_return(local, false);
+	ieee80211_offchannel_return(local, true);
 
 	*next_delay = HZ / 5;
 	/* afterwards, resume scan & go to next channel */
@@ -713,8 +713,8 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
-	/* PS already is in off-channel mode */
-	ieee80211_offchannel_stop_vifs(local, false);
+	/* Put PS back in off-channel mode */
+	ieee80211_offchannel_stop_vifs(local, true);
 
 	if (local->ops->flush) {
 		drv_flush(local, false);
-- 
1.7.9.5

