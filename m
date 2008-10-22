Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:41122 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbYJVXSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 19:18:41 -0400
Message-ID: <48FFB4CF.5090704@lwfinger.net> (sfid-20081023_011845_417271_B710BAD3)
Date: Wed, 22 Oct 2008 16:18:39 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix warning in minstrel rate control
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When compiling the minstrel rate-control code on x86_64 architecture, the
following warning is issued:

  CC [M]  net/mac80211/rc80211_minstrel_debugfs.o
net/mac80211/rc80211_minstrel_debugfs.c:145: warning: initialization from
incompatible pointer type

The fix requires changing the type of minstrel_stats_read().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This warning also prints in mainline - this belongs in 2.6.28.

Larry
---

Index: linux-2.6/net/mac80211/rc80211_minstrel_debugfs.c
===================================================================
--- linux-2.6.orig/net/mac80211/rc80211_minstrel_debugfs.c
+++ linux-2.6/net/mac80211/rc80211_minstrel_debugfs.c
@@ -106,7 +106,7 @@ minstrel_stats_open(struct inode *inode,
 	return 0;
 }

-static int
+static ssize_t
 minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *o)
 {
 	struct minstrel_stats_info *ms;



