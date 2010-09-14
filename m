Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0INM5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 08:57:04 -0400
Subject: Re: [virtual-sta 3/3] mac80211:  Allow multiple STA on same BSS.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1284156298-15863-3-git-send-email-greearb@candelatech.com>
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
	 <1284156298-15863-3-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 14:57:02 +0200
Message-ID: <1284469022.3704.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-10 at 15:04 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When adding an STA, the old code checked if there was already
> an STA with the same BSS.  Instead, check to see if there is
> exactly the same STA in order to allow multiple STA to be
> associated with the same AP.


You want this instead:

---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/sta_info.c	2010-09-14 14:53:10.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-09-14 14:55:44.000000000 +0200
@@ -125,7 +125,7 @@ struct sta_info *sta_info_get_bss(struct
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if ((sta->sdata == sdata ||
-		     sta->sdata->bss == sdata->bss) &&
+		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,


johannes

