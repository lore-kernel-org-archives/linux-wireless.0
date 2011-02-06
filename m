Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38268 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1BFUMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 15:12:16 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 4/5] mac80211:  Allow scanning on existing channel-type.
Date: Sun,  6 Feb 2011 12:11:57 -0800
Message-Id: <1297023118-24363-4-git-send-email-greearb@candelatech.com>
In-Reply-To: <1297023118-24363-1-git-send-email-greearb@candelatech.com>
References: <1297023118-24363-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Previous code set the channel type to NO_HT, but it
appears that NO_HT packets can be sent on any channel
type, so we do not need to change the channel type
as long as the channel is correct.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c155c0b... 86562ce... M	net/mac80211/main.c
:100644 100644 93da164... 1f277c9... M	net/mac80211/scan.c
 net/mac80211/main.c |   16 ++++++++++++++--
 net/mac80211/scan.c |    6 ++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c155c0b..86562ce 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -112,7 +112,13 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
 	/* This logic needs to match logic in ieee80211_hw_config */
 	if (local->scan_channel) {
 		chan = local->scan_channel;
-		channel_type = NL80211_CHAN_NO_HT;
+		/* If scanning on oper channel, use whatever channel-type
+		 * is currently in use.
+		 */
+		if (chan == local->oper_channel)
+			channel_type = local->_oper_channel_type;
+		else
+			channel_type = NL80211_CHAN_NO_HT;
 	} else if (local->tmp_channel) {
 		chan = scan_chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
@@ -151,7 +157,13 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (scan_chan) {
 		chan = scan_chan;
-		channel_type = NL80211_CHAN_NO_HT;
+		/* If scanning on oper channel, use whatever channel-type
+		 * is currently in use.
+		 */
+		if (chan == local->oper_channel)
+			channel_type = local->_oper_channel_type;
+		else
+			channel_type = NL80211_CHAN_NO_HT;
 	} else if (local->tmp_channel) {
 		chan = scan_chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 93da164..1f277c9 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -574,8 +574,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 
 	if (ieee80211_cfg_on_oper_channel(local)) {
 		/* We're currently on operating channel. */
-		if ((next_chan == local->oper_channel) &&
-		    (local->_oper_channel_type == NL80211_CHAN_NO_HT))
+		if (next_chan == local->oper_channel)
 			/* We don't need to move off of operating channel. */
 			local->next_scan_state = SCAN_SET_CHANNEL;
 		else
@@ -677,8 +676,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	local->scan_channel = chan;
 
 	/* Only call hw-config if we really need to change channels. */
-	if ((chan != local->hw.conf.channel) ||
-	    (local->hw.conf.channel_type != NL80211_CHAN_NO_HT))
+	if (chan != local->hw.conf.channel)
 		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
 			skip = 1;
 
-- 
1.7.2.3

