Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:60238 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750915AbYAPXpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 18:45:55 -0500
Date: Thu, 17 Jan 2008 00:38:29 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: rc80211-pid: fix last_sample initialization
Message-ID: <20080117003829.6d1c15cc@morte> (sfid-20080116_234603_943915_85DD4A0B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix last_sample initialization. kzalloc'ing the per-STA data wasn't enough,
as jiffies can assume negative values as well. This fixes a bug which
prevented correct PID operation for a while after booting.

Thanks to Michael Buesch for reporting this.

Reported-and-tested-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -496,6 +496,8 @@ static void *rate_control_pid_alloc_sta(
 	if (spinfo == NULL)
 		return NULL;
 
+	spinfo->last_sample = jiffies;
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	spin_lock_init(&spinfo->events.lock);
 	init_waitqueue_head(&spinfo->events.waitqueue);


-- 
Ciao
Stefano
