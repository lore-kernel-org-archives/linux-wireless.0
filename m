Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45913 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab0I2TGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 15:06:04 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211:  Don't go off-channel in work_work unless needed.
Date: Wed, 29 Sep 2010 12:05:59 -0700
Message-Id: <1285787159-9207-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If the work to be done is on the current active channel, then
do not call the offchannel and return-to-channel logic.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v1 -> v2:  Remove went_off_channel logic, and don't set
   tmp_channel if we're not going offchannel.

:100644 100644 ae344d1... 8a2ff479.. M	net/mac80211/work.c
 net/mac80211/work.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ae344d1..8a2ff479 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -910,12 +910,17 @@ static void ieee80211_work_work(struct work_struct *work)
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
+			}
 			started = true;
 			wk->timeout = jiffies;
 		}
-- 
1.7.2.2

