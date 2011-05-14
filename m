Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1ENJEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 05:04:53 -0400
Subject: [PATCH] mac80211: add missing rcu_barrier
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 11:04:51 +0200
Message-ID: <1305363891.3437.9.camel@jlt3.sipsolutions.net> (sfid-20110514_110456_752907_0913B779)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 uses call_rcu() with functions that are
defined in the module, so it must use rcu_barrier()
at module exit time.

Luckily, this seems to not be a problem in practice
as module unload and unregistration takes a long
time and probably does multiple synchronize_rcu().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Might want to apply this before the mesh patch that uses call_rcu I just
sent a few minutes ago.

 net/mac80211/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/main.c	2011-05-14 11:01:03.000000000 +0200
+++ b/net/mac80211/main.c	2011-05-14 11:01:42.000000000 +0200
@@ -1090,6 +1090,8 @@ static void __exit ieee80211_exit(void)
 		ieee80211s_stop();
 
 	ieee80211_iface_exit();
+
+	rcu_barrier();
 }
 
 


