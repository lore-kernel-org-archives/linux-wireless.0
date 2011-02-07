Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42489 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1BGVot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 16:44:49 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 5/7] mac80211:  Allow work items to use existing channel type.
Date: Mon,  7 Feb 2011 13:44:36 -0800
Message-Id: <1297115078-27773-5-git-send-email-greearb@candelatech.com>
In-Reply-To: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Narrow channel types can function within larger channel types.
So, use existing channel type for work items when possible.
This decreases hardware channel changes significantly when
using non NO_HT channel types on the operating channel.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 6bf787a... 64f2b28... M	net/mac80211/work.c
 net/mac80211/work.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 6bf787a..64f2b28 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -874,6 +874,44 @@ static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
 	kfree_skb(skb);
 }
 
+static bool ieee80211_work_ct_coexists(enum nl80211_channel_type wk_ct,
+				       enum nl80211_channel_type oper_ct)
+{
+	switch (wk_ct) {
+	case NL80211_CHAN_NO_HT:
+		return true;
+	case NL80211_CHAN_HT20:
+		if (oper_ct != NL80211_CHAN_NO_HT)
+			return true;
+		return false;
+	case NL80211_CHAN_HT40MINUS:
+	case NL80211_CHAN_HT40PLUS:
+		return (wk_ct == oper_ct);
+	}
+	WARN_ON(1); /* shouldn't get here */
+	return false;
+}
+
+static enum nl80211_channel_type
+ieee80211_calc_ct(enum nl80211_channel_type wk_ct,
+		  enum nl80211_channel_type oper_ct)
+{
+	switch (wk_ct) {
+	case NL80211_CHAN_NO_HT:
+		return oper_ct;
+	case NL80211_CHAN_HT20:
+		if (oper_ct != NL80211_CHAN_NO_HT)
+			return oper_ct;
+		return wk_ct;
+	case NL80211_CHAN_HT40MINUS:
+	case NL80211_CHAN_HT40PLUS:
+		return wk_ct;
+	}
+	WARN_ON(1); /* shouldn't get here */
+	return wk_ct;
+}
+
+
 static void ieee80211_work_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
@@ -927,14 +965,22 @@ static void ieee80211_work_work(struct work_struct *work)
 			bool on_oper_chan;
 			bool tmp_chan_changed = false;
 			bool on_oper_chan2;
+			enum nl80211_channel_type wk_ct;
 			on_oper_chan = ieee80211_cfg_on_oper_channel(local);
+
+			/* Work with existing channel type if possible. */
+			wk_ct = wk->chan_type;
+			if (wk->chan == local->hw.conf.channel)
+				wk_ct = ieee80211_calc_ct(wk->chan_type,
+						local->hw.conf.channel_type);
+
 			if (local->tmp_channel)
 				if ((local->tmp_channel != wk->chan) ||
-				    (local->tmp_channel_type != wk->chan_type))
+				    (local->tmp_channel_type != wk_ct))
 					tmp_chan_changed = true;
 
 			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk->chan_type;
+			local->tmp_channel_type = wk_ct;
 			/*
 			 * Leave the station vifs in awake mode if they
 			 * happen to be on the same channel as
@@ -1031,7 +1077,8 @@ static void ieee80211_work_work(struct work_struct *work)
 			continue;
 		if (wk->chan != local->tmp_channel)
 			continue;
-		if (wk->chan_type != local->tmp_channel_type)
+		if (ieee80211_work_ct_coexists(wk->chan_type,
+					       local->tmp_channel_type))
 			continue;
 		remain_off_channel = true;
 	}
-- 
1.7.2.3

