Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36096 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZGWKOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:14:15 -0400
Received: by fxm18 with SMTP id 18so715440fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:14:13 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 6/7] mac80211: rename scan_state to next_scan_state
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jul 2009 12:14:20 +0200
Message-ID: <20090723101420.5147.71489.stgit@localhost.localdomain>
In-Reply-To: <20090723100732.5147.73989.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename scan_state to next_scan_state to better reflect
what it is used for.
    
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/scan.c        |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index efda19e..c6b25cb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -715,7 +715,7 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 
-	enum mac80211_scan_state scan_state;
+	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	enum nl80211_channel_type oper_channel_type;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d56b9da..b376775 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -374,7 +374,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->iflist_mtx);
 
-	local->scan_state = SCAN_DECISION;
+	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
 	spin_lock_bh(&local->filter_lock);
@@ -505,15 +505,15 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 		 * next channel
 		 */
 		if (associated)
-			local->scan_state = SCAN_ENTER_OPER_CHANNEL;
+			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
-			local->scan_state = SCAN_SET_CHANNEL;
+			local->next_scan_state = SCAN_SET_CHANNEL;
 	} else {
 		/*
 		 * we're on the operating channel currently, let's
 		 * leave that channel now to scan another one
 		 */
-		local->scan_state = SCAN_LEAVE_OPER_CHANNEL;
+		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
 	}
 
 	*next_delay = 0;
@@ -545,7 +545,7 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
 
 	/* advance to the next channel to be scanned */
 	*next_delay = HZ / 10;
-	local->scan_state = SCAN_SET_CHANNEL;
+	local->next_scan_state = SCAN_SET_CHANNEL;
 }
 
 static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local,
@@ -577,7 +577,7 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
 	*next_delay = HZ / 5;
-	local->scan_state = SCAN_DECISION;
+	local->next_scan_state = SCAN_DECISION;
 }
 
 static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
@@ -621,13 +621,13 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    !local->scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-		local->scan_state = SCAN_DECISION;
+		local->next_scan_state = SCAN_DECISION;
 		return;
 	}
 
 	/* active scan, send probes */
 	*next_delay = IEEE80211_PROBE_DELAY;
-	local->scan_state = SCAN_SEND_PROBE;
+	local->next_scan_state = SCAN_SEND_PROBE;
 }
 
 static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
@@ -648,7 +648,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 	 * on the channel.
 	 */
 	*next_delay = IEEE80211_CHANNEL_TIME;
-	local->scan_state = SCAN_DECISION;
+	local->next_scan_state = SCAN_DECISION;
 }
 
 void ieee80211_scan_work(struct work_struct *work)
@@ -693,7 +693,7 @@ void ieee80211_scan_work(struct work_struct *work)
 	 * without scheduling a new work
 	 */
 	do {
-		switch (local->scan_state) {
+		switch (local->next_scan_state) {
 		case SCAN_DECISION:
 			if (ieee80211_scan_state_decision(local, &next_delay))
 				return;

