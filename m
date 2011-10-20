Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36085 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab1JTRFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 13:05:53 -0400
Received: by bkbzt19 with SMTP id zt19so3778812bkb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 10:05:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: config hw when going back on-channel
Date: Thu, 20 Oct 2011 19:05:50 +0200
Message-Id: <1319130350-15514-2-git-send-email-eliad@wizery.com> (sfid-20111020_190557_741868_5A123F1B)
In-Reply-To: <1319130350-15514-1-git-send-email-eliad@wizery.com>
References: <1319130350-15514-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When going back on-channel, we should reconfigure
the hw iff the hardware is not already configured
to the operational channel.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/work.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index b4de5dc..92ad8d6 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1091,7 +1091,6 @@ static void ieee80211_work_work(struct work_struct *work)
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
-		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local);
 		local->tmp_channel = NULL;
 		/* If tmp_channel wasn't operating channel, then
 		 * we need to go back on-channel.
@@ -1101,7 +1100,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		 * we still need to do a hardware config.  Currently,
 		 * we cannot be here while scanning, however.
 		 */
-		if (ieee80211_cfg_on_oper_channel(local) && !on_oper_chan)
+		if (!ieee80211_cfg_on_oper_channel(local))
 			ieee80211_hw_config(local, 0);
 
 		/* At the least, we need to disable offchannel_ps,
-- 
1.7.6.401.g6a319

