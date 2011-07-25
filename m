Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44936 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYP31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 11:29:27 -0400
Received: by wyg8 with SMTP id 8so2829435wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 08:29:26 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 2/2] mac80211: config hw when going back on-channel
Date: Mon, 25 Jul 2011 18:29:23 +0300
Message-Id: <1311607763-12603-3-git-send-email-eliad@wizery.com> (sfid-20110725_172930_747108_ADB5E9E8)
In-Reply-To: <1311607763-12603-1-git-send-email-eliad@wizery.com>
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hw is currently not configured when going
back on-channel.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/work.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 3291958..e6abb15 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1075,7 +1075,6 @@ static void ieee80211_work_work(struct work_struct *work)
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
-		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local);
 		local->tmp_channel = NULL;
 		/* If tmp_channel wasn't operating channel, then
 		 * we need to go back on-channel.
@@ -1085,7 +1084,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		 * we still need to do a hardware config.  Currently,
 		 * we cannot be here while scanning, however.
 		 */
-		if (ieee80211_cfg_on_oper_channel(local) && !on_oper_chan)
+		if (!ieee80211_cfg_on_oper_channel(local))
 			ieee80211_hw_config(local, 0);
 
 		/* At the least, we need to disable offchannel_ps,
-- 
1.7.0.4

