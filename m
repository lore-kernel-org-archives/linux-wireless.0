Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab1GAWCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:02:00 -0400
Subject: [PATCH] mac80211: allow driver to impose WoWLAN restrictions
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jul 2011 00:02:01 +0200
Message-ID: <1309557721.3888.3.camel@jlt3.sipsolutions.net> (sfid-20110702_000203_146113_D1B89600)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver can't support WoWLAN in the current
state, this patch allows it to return 1 from the
suspend callback to do the normal deconfiguration
instead of using suspend/resume calls. Note that
if it does this, resume won't be called.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/pm.c      |   16 ++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/net/mac80211.h	2011-07-02 00:00:36.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-02 00:00:37.000000000 +0200
@@ -1628,6 +1628,10 @@ enum ieee80211_ampdu_mlme_action {
  *	ask the device to suspend. This is only invoked when WoWLAN is
  *	configured, otherwise the device is deconfigured completely and
  *	reconfigured at resume time.
+ *	The driver may also impose special conditions under which it
+ *	wants to use the "normal" suspend (deconfigure), say if it only
+ *	supports WoWLAN when the device is associated. In this case, it
+ *	must return 1 from this function.
  *
  * @resume: If WoWLAN was configured, this indicates that mac80211 is
  *	now resuming its operation, after this the device must be fully
--- a/net/mac80211/pm.c	2011-07-02 00:00:36.000000000 +0200
+++ b/net/mac80211/pm.c	2011-07-02 00:00:37.000000000 +0200
@@ -72,15 +72,19 @@ int __ieee80211_suspend(struct ieee80211
 	local->wowlan = wowlan && local->open_count;
 	if (local->wowlan) {
 		int err = drv_suspend(local, wowlan);
-		if (err) {
+		if (err < 0) {
 			local->quiescing = false;
 			return err;
+		} else if (err > 0) {
+			WARN_ON(err != 1);
+			local->wowlan = false;
+		} else {
+			list_for_each_entry(sdata, &local->interfaces, list) {
+				cancel_work_sync(&sdata->work);
+				ieee80211_quiesce(sdata);
+			}
+			goto suspend;
 		}
-		list_for_each_entry(sdata, &local->interfaces, list) {
-			cancel_work_sync(&sdata->work);
-			ieee80211_quiesce(sdata);
-		}
-		goto suspend;
 	}
 
 	/* disable keys */


