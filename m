Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17673 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab0LGCtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:49:13 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 18:48:58 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<amod.bodas@atheros.com>, <pstew@google.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/5] mac80211: fix issuing idle calls when device open count is 0
Date: Mon, 6 Dec 2010 18:48:55 -0800
Message-ID: <1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a few places where mac80211 may issue a hw config
but the hw config will be ignored and got into a black hole if
the device count is already 0. Further hw config calls will also
be discarded as the device is already marked as idle, in these
cases mac80211 assumes the radio is idle but the driver never
really got the notification. We need to ensure that places that
will call a hw reconfig with open_count set to 0 will send the
notification to the driver. This forces these checks in a few
other key missing places.

Without this suspend and resume is broken on devices which require
notifying the driver to become idle once the open_count already
has reached 0. This fixes suspend/resume when using new DBus APIs
are used which idle the device in places which had not yet gotten
widely tested.

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |   16 ++++++++++++++--
 net/mac80211/pm.c          |    2 ++
 net/mac80211/scan.c        |    2 +-
 net/mac80211/util.c        |    1 +
 5 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae32349..78ab6ff 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1211,6 +1211,7 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
+void ieee80211_recalc_idle_force(struct ieee80211_local *local);
 void ieee80211_stop_device(struct ieee80211_local *local);
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 36b7000..a590bae 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1320,7 +1320,8 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 	return 0;
 }
 
-void ieee80211_recalc_idle(struct ieee80211_local *local)
+static void ieee80211_recalc_idle_check(struct ieee80211_local *local,
+					bool force)
 {
 	u32 chg;
 
@@ -1328,7 +1329,18 @@ void ieee80211_recalc_idle(struct ieee80211_local *local)
 	chg = __ieee80211_recalc_idle(local);
 	mutex_unlock(&local->iflist_mtx);
 	if (chg)
-		ieee80211_hw_config(local, chg);
+		__ieee80211_hw_config(local, chg, force);
+}
+
+void ieee80211_recalc_idle(struct ieee80211_local *local)
+{
+	ieee80211_recalc_idle_check(local, false);
+}
+
+void ieee80211_recalc_idle_force(struct ieee80211_local *local)
+
+{
+	ieee80211_recalc_idle_check(local, true);
 }
 
 static int netdev_notify(struct notifier_block *nb,
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index e373551..fc65b8d 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -98,6 +98,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	if (local->open_count)
 		ieee80211_stop_device(local);
 
+	ieee80211_recalc_idle_force(local);
+
 	local->suspended = true;
 	/* need suspended to be visible before quiescing is false */
 	barrier();
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fb274db..30cd2a0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -301,7 +301,7 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
 	}
 
 	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(local);
+	ieee80211_recalc_idle_force(local);
 	mutex_unlock(&local->mtx);
 
 	ieee80211_mlme_notify_scan_completed(local);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e497476..e5fb03e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1121,6 +1121,7 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 
 	flush_workqueue(local->workqueue);
 	drv_stop(local);
+	ieee80211_recalc_idle_force(local);
 }
 
 int ieee80211_reconfig(struct ieee80211_local *local)
-- 
1.7.3.2.90.gd4c43

