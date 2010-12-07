Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49831 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0LGT1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 14:27:09 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211: Show max number of probe tries in debug message.
Date: Tue,  7 Dec 2010 11:27:01 -0800
Message-Id: <1291750021-6347-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2b5c3f2... de43753... M	net/mac80211/work.c
 net/mac80211/work.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 2b5c3f2..de43753 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -458,8 +458,9 @@ ieee80211_direct_probe(struct ieee80211_work *wk)
 		return WORK_ACT_TIMEOUT;
 	}
 
-	printk(KERN_DEBUG "%s: direct probe to %pM (try %d)\n",
-			sdata->name, wk->filter_ta, wk->probe_auth.tries);
+	printk(KERN_DEBUG "%s: direct probe to %pM (try %d/%i)\n",
+	       sdata->name, wk->filter_ta, wk->probe_auth.tries,
+	       IEEE80211_AUTH_MAX_TRIES);
 
 	/*
 	 * Direct probe is sent to broadcast address as some APs
-- 
1.7.2.3

