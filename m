Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58324 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab0KLUHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:07:13 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
Date: Fri, 12 Nov 2010 12:07:06 -0800
Message-Id: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

We cannot call flush_work here because we are holding
RTNL and the worker thread(s) that will be called upon to
do the flushing might already be running a piece of work
that is blocking on RTNL.  That leads to deadlock and/or
OOM.

The ieee80211_iface_work method does nothing when sdata
is stopped (as it would be when the flush_work was called)
so it shouldn't be any big change to just cancel the work
entirely.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 7aa8559... 073b42a... M	net/mac80211/iface.c
 net/mac80211/iface.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7aa8559..073b42a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -516,7 +516,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		}
 		/* fall through */
 	default:
-		flush_work(&sdata->work);
+		/* Cannot call flush_work here because we are holding
+		 * RTNL and the worker thread(s) that will be called upon to
+		 * do the flushing might already be running a piece of work
+		 * that is blocking on RTNL.  That leads to deadlock and/or
+		 * OOM.
+		 */
+		cancel_work_sync(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
-- 
1.7.2.3

