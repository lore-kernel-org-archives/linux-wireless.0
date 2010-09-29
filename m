Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43747 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0I2SDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 14:03:12 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] mac80211:  Don't go off-channel in work_work unless needed.
Date: Wed, 29 Sep 2010 11:03:03 -0700
Message-Id: <1285783383-20822-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
References: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If the work to be done is on the current active channel, then
do not call the offchannel and return-to-channel logic.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 ae344d1... 1f2673d... M	net/mac80211/work.c
 net/mac80211/work.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ae344d1..1f2673d 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -873,6 +873,7 @@ static void ieee80211_work_work(struct work_struct *work)
 	LIST_HEAD(free_work);
 	enum work_action rma;
 	bool remain_off_channel = false;
+	bool went_off_channel = false;
 
 	if (local->scanning)
 		return;
@@ -910,12 +911,21 @@ static void ieee80211_work_work(struct work_struct *work)
 			 *	 happen to be on the same channel as
 			 *	 the requested channel
 			 */
-			ieee80211_offchannel_stop_beaconing(local);
-			ieee80211_offchannel_stop_station(local);
-
-			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk->chan_type;
-			ieee80211_hw_config(local, 0);
+			WARN_ON(local->scan_channel != NULL);
+			if (wk->chan != local->oper_channel ||
+			    wk->chan_type != local->_oper_channel_type) {
+				/* Only change channels if we need to */
+				ieee80211_offchannel_stop_beaconing(local);
+				ieee80211_offchannel_stop_station(local);
+
+				local->tmp_channel = wk->chan;
+				local->tmp_channel_type = wk->chan_type;
+				ieee80211_hw_config(local, 0);
+				went_off_channel = true;
+			} else {
+				local->tmp_channel = wk->chan;
+				local->tmp_channel_type = wk->chan_type;
+			}
 			started = true;
 			wk->timeout = jiffies;
 		}
@@ -989,8 +999,10 @@ static void ieee80211_work_work(struct work_struct *work)
 
 	if (!remain_off_channel && local->tmp_channel) {
 		local->tmp_channel = NULL;
-		ieee80211_hw_config(local, 0);
-		ieee80211_offchannel_return(local, true);
+		if (went_off_channel) {
+			ieee80211_hw_config(local, 0);
+			ieee80211_offchannel_return(local, true);
+		}
 		/* give connection some time to breathe */
 		run_again(local, jiffies + HZ/2);
 	}
-- 
1.7.2.2

