Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0INTeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 15:34:21 -0400
Subject: [PATCH] mac80211: match only assigned bss in sta_info_get_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 21:34:14 +0200
Message-ID: <1284492854.3703.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

sta_info_get_bss() is used to match STA pointers
for VLAN/AP interfaces, but if the same station
is also added to multiple other interfaces it
will erroneously match because both pointers are
NULL, fix this by ignoring NULL pointers here.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/sta_info.c	2010-09-14 21:31:06.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-09-14 21:31:24.000000000 +0200
@@ -125,7 +125,7 @@ struct sta_info *sta_info_get_bss(struct
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if ((sta->sdata == sdata ||
-		     sta->sdata->bss == sdata->bss) &&
+		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,


