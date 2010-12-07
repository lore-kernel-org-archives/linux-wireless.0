Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35270 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab0LGP7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:59:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 07:59:07 -0800
Date: Tue, 7 Dec 2010 07:59:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	"pstew@google.com" <pstew@google.com>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
Message-ID: <20101207155916.GA1855@tux>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
 <1291714709.3607.2.camel@jlt3.sipsolutions.net>
 <AANLkTikrLweKeSR-=XziaJ5rqDRf_Ny=mg1OD=jC4nqA@mail.gmail.com>
 <1291736887.3607.47.camel@jlt3.sipsolutions.net>
 <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
 <1291737298.3607.48.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1291737298.3607.48.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 07:54:58AM -0800, Johannes Berg wrote:
> On Tue, 2010-12-07 at 07:51 -0800, Luis R. Rodriguez wrote:
> 
> > >> >>       drv_stop(local);
> > >> >> +     ieee80211_recalc_idle_force(local);
> 
> > > Because you can't call into drivers after you stop them? Shouldn't this
> > > be obvious?
> > 
> > That makes sense, but mac80211 is the one who tells the driver when
> > its idle or non-idle, if we stop the device do we want it to handle an
> > idle check itself? This change would only force out an idle change
> > notification, nothing else.
> 
> I don't get what you're saying at all. Can you look at the code lines I
> quoted again?

Yes, I did. Anyway here is a v2 with the changes you outlined incorporated.

>From d8983b423b24037e8e847fa45778d9313af3e057 Mon Sep 17 00:00:00 2001
From: Luis R. Rodriguez <lrodriguez@atheros.com>
Date: Mon, 6 Dec 2010 18:04:03 -0800
Subject: [PATCH v2] mac80211: fix issuing idle calls when device open count is 0

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
 net/mac80211/ieee80211_i.h |   16 +++++++++++++++-
 net/mac80211/iface.c       |    4 ++--
 net/mac80211/scan.c        |    2 +-
 net/mac80211/util.c        |    1 +
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae32349..873ec88 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1132,8 +1132,21 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
+
 u32 __ieee80211_recalc_idle(struct ieee80211_local *local);
-void ieee80211_recalc_idle(struct ieee80211_local *local);
+void ieee80211_recalc_idle_check(struct ieee80211_local *local, bool force);
+
+static inline void ieee80211_recalc_idle(struct ieee80211_local *local)
+{
+	ieee80211_recalc_idle_check(local, false);
+}
+
+static inline void ieee80211_recalc_idle_force(struct ieee80211_local *local)
+
+{
+	ieee80211_recalc_idle_check(local, true);
+}
+
 void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 				    const int offset);
 
@@ -1211,6 +1224,7 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
+void ieee80211_recalc_idle_force(struct ieee80211_local *local);
 void ieee80211_stop_device(struct ieee80211_local *local);
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 36b7000..2803a7a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1320,7 +1320,7 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 	return 0;
 }
 
-void ieee80211_recalc_idle(struct ieee80211_local *local)
+void ieee80211_recalc_idle_check(struct ieee80211_local *local, bool force)
 {
 	u32 chg;
 
@@ -1328,7 +1328,7 @@ void ieee80211_recalc_idle(struct ieee80211_local *local)
 	chg = __ieee80211_recalc_idle(local);
 	mutex_unlock(&local->iflist_mtx);
 	if (chg)
-		ieee80211_hw_config(local, chg);
+		__ieee80211_hw_config(local, chg, force);
 }
 
 static int netdev_notify(struct notifier_block *nb,
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
index e497476..a4184eb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1120,6 +1120,7 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 	cancel_work_sync(&local->reconfig_filter);
 
 	flush_workqueue(local->workqueue);
+	ieee80211_recalc_idle_force(local);
 	drv_stop(local);
 }
 
-- 
1.7.3.2.90.gd4c43

