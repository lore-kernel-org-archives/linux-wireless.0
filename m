Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64563 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760232Ab2CTOzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:55:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 13:17:20 +0100
Subject: [RFC 10/12] mac80211: rename ieee80211_offchannel_return
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <753ef3c0-9ad4-4340-b763-2b37006a5406@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155528_733022_063F5D48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Semantic rename.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/offchannel.c  |    4 ++--
 net/mac80211/scan.c        |    4 ++--
 net/mac80211/work.c        |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a4307dc..4ceedff 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1282,8 +1282,8 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 /* off-channel helpers */
 void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 				    bool offchannel_ps_enable);
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable);
+void ieee80211_offchannel_return_vifs(struct ieee80211_local *local,
+				      bool offchannel_ps_disable);
 void ieee80211_hw_roc_setup(struct ieee80211_local *local);
 
 /* interface handling */
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f054e94..06a809d 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -138,8 +138,8 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable)
+void ieee80211_offchannel_return_vifs(struct ieee80211_local *local,
+				      bool offchannel_ps_disable)
 {
 	struct ieee80211_sub_if_data *sdata;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5e7a1f8..56a11bc 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -330,7 +330,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return_vifs(local, true);
 	}
 
 	ieee80211_recalc_idle(local);
@@ -636,7 +636,7 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 	 * in off-channel state..will put that back
 	 * on-channel at the end of scanning.
 	 */
-	ieee80211_offchannel_return(local, false);
+	ieee80211_offchannel_return_vifs(local, false);
 
 	*next_delay = HZ / 5;
 	/* afterwards, resume scan & go to next channel */
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 91114db..b0f5071 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -221,7 +221,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		chan_state->tmp_channel = NULL;
 		ieee80211_hw_config(local, 0);
 
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return_vifs(local, true);
 
 		/* give connection some time to breathe */
 		run_again(local, jiffies + HZ/2);
-- 
1.7.0.4

