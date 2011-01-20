Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1ATUPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:15:32 -0500
Received: by bwz15 with SMTP id 15so894044bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 12:15:30 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active channel.
Date: Thu, 20 Jan 2011 20:14:50 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com> <1295547439.3693.46.camel@jlt3.sipsolutions.net> <4D387D25.7080902@candelatech.com>
In-Reply-To: <4D387D25.7080902@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101202014.51161.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 20. Januar 2011 schrieb Ben Greear:
> On 01/20/2011 10:17 AM, Johannes Berg wrote:
> > Yeah, so maybe it needs some re-work, but I think what you're doing is a
> > pretty strange hack.
> 
> If you have time to write some patches, I'll be happy to test them on
> our ath9k and ath5k systems.

Try this, I only ran a quick test with iwlagn (disable_hw_scan=1), seems to
work fine. However, I did not think much about it yet ;)

Helmut


From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Thu, 20 Jan 2011 20:11:51 +0100
Subject: [PATCH] mac80211: Scan operating channel without enabling PS

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rx.c   |   13 +++++++++----
 net/mac80211/scan.c |   43 ++++++++++++++++++++++++++++---------------
 2 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..d710149 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -388,6 +388,7 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	struct sk_buff *skb = rx->skb;
+	int ret;
 
 	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
 		return RX_CONTINUE;
@@ -396,10 +397,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 		return ieee80211_scan_rx(rx->sdata, skb);
 
 	if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
-		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
+		ret = ieee80211_scan_rx(rx->sdata, skb);
+		/* drop all the other packets while scanning off channel */
+		if (ret != RX_QUEUED &&
+		    test_bit(SCAN_OFF_CHANNEL, &local->scanning)) {
 			dev_kfree_skb(skb);
-		return RX_QUEUED;
+			return RX_QUEUED;
+		}
+		return ret;
 	}
 
 	/* scanning finished during invoking of handlers */
@@ -2730,7 +2735,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		local->dot11ReceivedFragmentCount++;
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
+		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
 		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
 	if (ieee80211_is_mgmt(fc))
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fb274db..bcc8a3e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -486,7 +486,15 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	}
 	mutex_unlock(&local->iflist_mtx);
 
-	if (local->scan_channel) {
+	if (local->scan_channel == local->oper_channel ||
+	    local->scan_channel == NULL) {
+		/*
+		 * we're on the operating channel currently, let's
+		 * leave that channel now to scan another one
+		 */
+		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+	}
+	else {
 		/*
 		 * we're currently scanning a different channel, let's
 		 * see if we can scan another channel without interfering
@@ -520,12 +528,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
 			local->next_scan_state = SCAN_SET_CHANNEL;
-	} else {
-		/*
-		 * we're on the operating channel currently, let's
-		 * leave that channel now to scan another one
-		 */
-		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
 	}
 
 	*next_delay = 0;
@@ -534,6 +536,21 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
 						    unsigned long *next_delay)
 {
+	struct ieee80211_channel *chan;
+	chan = local->scan_req->channels[local->scan_channel_idx];
+
+	/* remember when we left the operating channel */
+	local->leave_oper_channel_time = jiffies;
+
+	/* advance to the next channel to be scanned */
+	local->next_scan_state = SCAN_SET_CHANNEL;
+
+	/* Scanning operating channel, take the shortcut */
+	if (chan == local->oper_channel) {
+		*next_delay = 0;
+		return;
+	}
+
 	ieee80211_offchannel_stop_station(local);
 
 	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
@@ -546,12 +563,6 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
 		*next_delay = 0;
 	else
 		*next_delay = HZ / 10;
-
-	/* remember when we left the operating channel */
-	local->leave_oper_channel_time = jiffies;
-
-	/* advance to the next channel to be scanned */
-	local->next_scan_state = SCAN_SET_CHANNEL;
 }
 
 static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local,
@@ -583,8 +594,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
 	local->scan_channel = chan;
-	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
-		skip = 1;
+
+	if (chan != local->oper_channel)
+		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
+			skip = 1;
 
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
-- 
1.7.1

