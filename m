Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63143 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYP30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 11:29:26 -0400
Received: by wyg8 with SMTP id 8so2829416wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 08:29:24 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 1/2] mac80211: fix remain_off_channel regression
Date: Mon, 25 Jul 2011 18:29:22 +0300
Message-Id: <1311607763-12603-2-git-send-email-eliad@wizery.com> (sfid-20110725_172929_044119_6DA979B4)
In-Reply-To: <1311607763-12603-1-git-send-email-eliad@wizery.com>
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i'm not familiar enough with the off_channel flow,
but this one looks completely broken - we should
remain_off_channel if the work was started, and
the work's channel and channel_type are the same
as local->tmp_channel and local->tmp_channel_type.

however, if wk->chan_type and local->tmp_channel_type
coexist (e.g. have the same channel type), we won't
remain_off_channel.

this behavior was introduced by commit da2fd1f
("mac80211: Allow work items to use existing
channel type.")

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/work.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index a94b312..3291958 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1068,8 +1068,8 @@ static void ieee80211_work_work(struct work_struct *work)
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
1.7.0.4

