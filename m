Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39663 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab1JTRFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 13:05:51 -0400
Received: by ggnb1 with SMTP id b1so3000882ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 10:05:50 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: fix remain_off_channel regression
Date: Thu, 20 Oct 2011 19:05:49 +0200
Message-Id: <1319130350-15514-1-git-send-email-eliad@wizery.com> (sfid-20111020_190557_144989_4E1A9E32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The offchannel code is currently broken - we should
remain_off_channel if the work was started, and
the work's channel and channel_type are the same
as local->tmp_channel and local->tmp_channel_type.

However, if wk->chan_type and local->tmp_channel_type
coexist (e.g. have the same channel type), we won't
remain_off_channel.

This behavior was introduced by commit da2fd1f
("mac80211: Allow work items to use existing
channel type.")

Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/work.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index af374fa..b4de5dc 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1084,8 +1084,8 @@ static void ieee80211_work_work(struct work_struct *work)
 			continue;
 		if (wk->chan != local->tmp_channel)
 			continue;
-		if (ieee80211_work_ct_coexists(wk->chan_type,
-					       local->tmp_channel_type))
+		if (!ieee80211_work_ct_coexists(wk->chan_type,
+						local->tmp_channel_type))
 			continue;
 		remain_off_channel = true;
 	}
-- 
1.7.6.401.g6a319

