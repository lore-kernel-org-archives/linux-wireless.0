Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1JROUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 10:20:11 -0400
Date: Tue, 18 Oct 2011 16:19:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [RFC] mac80211: properly go back to operational channel?
Message-ID: <20111018141922.GA6204@redhat.com> (sfid-20111018_162015_236369_F8599FC4)
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>
 <1317123289.4082.12.camel@jlt3.sipsolutions.net>
 <20110929150018.GA4554@redhat.com>
 <1317740824.6741.22.camel@jlt3.sipsolutions.net>
 <20111005111507.GA2184@redhat.com>
 <1317813762.4839.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1317813762.4839.7.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For local->tmp_channel == NULL and local->scan_channel == NULL
ieee80211_cfg_on_oper_channel() will return false if
local->oper_channel != local->hw.conf.channel,
hece we do not properly go back to oper_channel from tmp_channel.

Does patch have sense? Could it fixes problems we are talking
in this thread?

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index af374fa..98bf1fa 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1101,7 +1101,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		 * we still need to do a hardware config.  Currently,
 		 * we cannot be here while scanning, however.
 		 */
-		if (ieee80211_cfg_on_oper_channel(local) && !on_oper_chan)
+		if (!on_oper_chan)
 			ieee80211_hw_config(local, 0);
 
 		/* At the least, we need to disable offchannel_ps,
