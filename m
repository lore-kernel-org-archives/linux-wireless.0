Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbZFJNQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 09:16:53 -0400
Subject: [PATCH 1/18 v3] mac80211: disable moving between PS modes during
 scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, j@w1.fi, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1244638468-28662-1-git-send-email-lrodriguez@atheros.com>
References: <1244638468-28662-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 15:16:15 +0200
Message-Id: <1244639775.18481.60.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <lrodriguez@atheros.com>

We don't want to trigger moving between PS mode during scan,
because then we will sometimes end up sending nullfunc frames
during scan. We're supposed to only send one prior to scan
and after scan.

This fixes an oops which occured due to an assert in ath9k:

http://marc.info/?l=linux-wireless&m=124277331319024

The assert was happening because the rate control algorithm
figures it should find at least one valid dual stream or
single stream rate. Since we allow mac80211 to send nullfunc
frames during scan and dynamic PS was enabled at times we ended
up trying to send nullfunc frames for the target sta on the
wrong band for which we have no valid rate to communicate with
it. This breaks the assumptions in rate control.

We determine we also need to disable moving between PS modes
when not associated so lets just add that now as well, and we
should not have a ps_sdata when that interface cannot actually
go into PS because it's not associated.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---

While testing when I was sleep walking I noticed I couldn't switch
to a different AP. The new changes here fixed that.

I'm not seeing any more strange deadbeef stuff with this series now.

 net/mac80211/mlme.c |    6 ++----
 net/mac80211/tx.c   |    3 ++-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-06-09 23:13:34.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-06-10 14:58:32.000000000 +0200
@@ -1415,7 +1415,8 @@ int ieee80211_master_start_xmit(struct s
 	}
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    local->hw.conf.dynamic_ps_timeout > 0) {
+	    local->hw.conf.dynamic_ps_timeout > 0 &&
+	    !local->sw_scanning && !local->hw_scanning && local->ps_sdata) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-10 14:58:36.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-10 15:15:41.000000000 +0200
@@ -621,9 +621,6 @@ static void ieee80211_change_ps(struct i
 	struct ieee80211_conf *conf = &local->hw.conf;
 
 	if (local->ps_sdata) {
-		if (!(local->ps_sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED))
-			return;
-
 		ieee80211_enable_ps(local, local->ps_sdata);
 	} else if (conf->flags & IEEE80211_CONF_PS) {
 		conf->flags &= ~IEEE80211_CONF_PS;
@@ -653,7 +650,8 @@ void ieee80211_recalc_ps(struct ieee8021
 		count++;
 	}
 
-	if (count == 1 && found->u.mgd.powersave) {
+	if (count == 1 && found->u.mgd.powersave &&
+	    (found->u.mgd.flags & IEEE80211_STA_ASSOCIATED)) {
 		s32 beaconint_us;
 
 		if (latency < 0)


