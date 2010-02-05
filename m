Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0BEKpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 05:45:11 -0500
Subject: [PATCH] mac80211: fix bss_conf.dtim_period
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 11:45:06 +0100
Message-ID: <1265366706.3613.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode, the only mode where the parameter
is supposed to be valid, we never assign it!
Fix that to allow drivers to avoid parsing
the TIM IE for the value.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-02-05 11:42:12.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-02-05 11:42:27.000000000 +0100
@@ -515,6 +515,8 @@ static int ieee80211_config_beacon(struc
 		if (old)
 			memcpy(new->tail, old->tail, new_tail_len);
 
+	sdata->vif.bss_conf.dtim_period = new->dtim_period;
+
 	rcu_assign_pointer(sdata->u.ap.beacon, new);
 
 	synchronize_rcu();


