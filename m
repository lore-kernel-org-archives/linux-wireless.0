Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:50679 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933042Ab0JFTMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 15:12:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 12:12:08 -0700
Date: Wed, 6 Oct 2010 12:12:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@Atheros.com>,
	Matt Smith <Matt.Smith@Atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Deny new BA agreements from being started
 during offchannel operation
Message-ID: <20101006191215.GM7070@tux>
References: <20101006185000.GJ7070@tux>
 <1286391301.3655.403.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286391301.3655.403.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 06, 2010 at 11:55:01AM -0700, Johannes Berg wrote:
> On Wed, 2010-10-06 at 11:50 -0700, Luis R. Rodriguez wrote:
> > It only makes sense to allow BA agreements when we are going to
> > spend some time on the operating channel. This blocks all new
> > incoming ADDBA requests while we go offchannel, but keeps
> > existing BA agreements alive.
> 
> I just hope the different uses of this bit won't ever collide ... can we
> suspend while being offchannel? ;-)

Good question, will ieee80211_offchannel_ps_disable() possibly be
called during suspend? I can imagine its possible. So how about we
check for local->quiescing prior to lifting the flag only:

>From 374cbccafadc22ba261dd3bc5f68758106872448 Mon Sep 17 00:00:00 2001
From: Luis R. Rodriguez <lrodriguez@atheros.com>
Date: Tue, 21 Sep 2010 15:27:02 -0400
Subject: [PATCH v3] mac80211: Deny new BA agreements from being started during offchannel operation

It only makes sense to allow BA agreements when we are going to
spend some time on the operating channel. This blocks all new
incoming ADDBA requests while we go offchannel, but keeps
existing BA agreements alive.

Cc: srinivasa.duvvuri@atheros.com
Cc: matt.smith@atheros.com
Cc: bennyam.malavazi@atheros.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/agg-rx.c     |    8 ++++++--
 net/mac80211/offchannel.c |   17 +++++++++++++++++
 net/mac80211/sta_info.h   |    3 ++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 720b7a8..a21d120 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -209,8 +209,12 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Suspend in progress. "
-		       "Denying ADDBA request\n");
+		if (local->quiescing)
+			printk(KERN_DEBUG "Suspend in progress. "
+			      "Denying ADDBA request\n");
+		else
+			printk(KERN_DEBUG "Offchannel operation in progress, "
+			      "Denying ADDBA request\n");
 #endif
 		goto end_no_lock;
 	}
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 4b56409..86e9b8d 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -34,6 +34,14 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
+	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		struct sta_info *sta;
+		mutex_lock(&local->sta_mtx);
+		list_for_each_entry(sta, &local->sta_list, list)
+			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
+		mutex_unlock(&local->sta_mtx);
+	}
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->offchannel_ps_enabled = true;
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
@@ -92,6 +100,15 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_sta_reset_conn_monitor(sdata);
+
+	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION &&
+	    !local->quiescing) {
+		struct sta_info *sta;
+		mutex_lock(&local->sta_mtx);
+		list_for_each_entry(sta, &local->sta_list, list)
+			clear_sta_flags(sta, WLAN_STA_BLOCK_BA);
+		mutex_unlock(&local->sta_mtx);
+	}
 }
 
 void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index cf21a2e..2439156 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -36,7 +36,8 @@
  *	frame to this station is transmitted.
  * @WLAN_STA_MFP: Management frame protection is used with this STA.
  * @WLAN_STA_BLOCK_BA: Used to deny ADDBA requests (both TX and RX)
- *	during suspend/resume and station removal.
+ *	during suspend/resume, station removal, and when we go offchannel
+ *	when associated.
  * @WLAN_STA_PS_DRIVER: driver requires keeping this station in
  *	power-save mode logically to flush frames that might still
  *	be in the queues
-- 
1.7.0.4

