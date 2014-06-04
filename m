Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:59016 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaFDN2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:28:11 -0400
Received: by mail-ig0-f169.google.com with SMTP id a13so1862723igq.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 06:28:11 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] mac80211: remove ignore_plink_timer flag
Date: Wed,  4 Jun 2014 09:27:31 -0400
Message-Id: <1401888451-9612-1-git-send-email-me@bobcopeland.com> (sfid-20140604_152815_284891_DB22CE46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh_plink code is doing some interesting things with the
ignore_plink_timer flag.  It seems the original intent was to
handle this race:

cpu 0                           cpu 1
-----                           -----
                                start timer handler for state X
acquire sta_lock
change state from X to Y
mod_timer() / del_timer()
release sta_lock
                                acquire sta_lock
                                execute state Y timer too soon

However, using the mod_timer()/del_timer() return values to
detect these cases is broken.  As a result, timers get ignored
unnecessarily, and stations can get stuck in the peering state
machine.

Instead, we can detect the case by looking at the timer expiration.
In the case of del_timer, just ignore the timers in the following
(LISTEN/ESTAB) states since they won't have timers anyway.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_plink.c | 30 +++++++++++++++++++++++-------
 net/mac80211/sta_info.h   |  2 --
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index e8f60aa..63b8741 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -551,11 +551,30 @@ static void mesh_plink_timer(unsigned long data)
 		return;
 
 	spin_lock_bh(&sta->lock);
-	if (sta->ignore_plink_timer) {
-		sta->ignore_plink_timer = false;
+
+	/* If a timer fires just before a state transition on another CPU,
+	 * we may have already extended the timeout and changed state by the
+	 * time we've acquired the lock and arrived  here.  In that case,
+	 * skip this timer and wait for the new one.
+	 */
+	if (time_before(jiffies, sta->plink_timer.expires)) {
+		mpl_dbg(sta->sdata,
+			"Ignoring timer for %pM in state %s (timer adjusted)",
+			sta->sta.addr, mplstates[sta->plink_state]);
 		spin_unlock_bh(&sta->lock);
 		return;
 	}
+
+	/* del_timer() and handler may race when entering these states */
+	if (sta->plink_state == NL80211_PLINK_LISTEN ||
+	    sta->plink_state == NL80211_PLINK_ESTAB) {
+		mpl_dbg(sta->sdata,
+			"Ignoring timer for %pM in state %s (timer deleted)",
+			sta->sta.addr, mplstates[sta->plink_state]);
+		spin_unlock_bh(&sta->lock);
+		return;
+	}
+
 	mpl_dbg(sta->sdata,
 		"Mesh plink timer for %pM fired on state %s\n",
 		sta->sta.addr, mplstates[sta->plink_state]);
@@ -773,9 +792,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 			break;
 		case CNF_ACPT:
 			sta->plink_state = NL80211_PLINK_CNF_RCVD;
-			if (!mod_plink_timer(sta,
-					     mshcfg->dot11MeshConfirmTimeout))
-				sta->ignore_plink_timer = true;
+			mod_plink_timer(sta, mshcfg->dot11MeshConfirmTimeout);
 			break;
 		default:
 			break;
@@ -834,8 +851,7 @@ static u32 mesh_plink_fsm(struct ieee80211_sub_if_data *sdata,
 	case NL80211_PLINK_HOLDING:
 		switch (event) {
 		case CLS_ACPT:
-			if (del_timer(&sta->plink_timer))
-				sta->ignore_plink_timer = 1;
+			del_timer(&sta->plink_timer);
 			mesh_plink_fsm_restart(sta);
 			break;
 		case OPN_ACPT:
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dee0b64..159cac9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -306,7 +306,6 @@ struct ieee80211_tx_latency_stat {
  * @plid: Peer link ID
  * @reason: Cancel reason on PLINK_HOLDING state
  * @plink_retries: Retries in establishment
- * @ignore_plink_timer: ignore the peer-link timer (used internally)
  * @plink_state: peer link state
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
@@ -421,7 +420,6 @@ struct sta_info {
 	u16 plid;
 	u16 reason;
 	u8 plink_retries;
-	bool ignore_plink_timer;
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
-- 
1.9.2

