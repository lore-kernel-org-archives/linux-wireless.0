Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4529 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZHVMr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 08:47:28 -0400
Date: Sat, 22 Aug 2009 08:47:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292
Message-ID: <20090822124709.GA6762@hash.localnet>
References: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com> <b6c5339f0908191442j6b5733f3rb28967060abdbace@mail.gmail.com> <b6c5339f0908210719o2323d590w4a9f6a01d5ecb2d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0908210719o2323d590w4a9f6a01d5ecb2d6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 10:19:33AM -0400, Bob Copeland wrote:
> Okay, I think I see what is going on here.

Well I can't quite convince myself of what exactly is requeing
sta work; we do cancel everything already as far as I can tell, but
something is rearming, I just can't tell which.

Fabio, can you please apply this patch against wireless-testing (not
compat-wireless) and report all the warnings produced when doing a
suspend/resume?  This should tell us the code paths that are queuing
work too late.

>From 6eb7d5c3ae8f2f42b164491acd02631858515876 Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Sat, 22 Aug 2009 08:40:53 -0400
Subject: [PATCH] mac80211: set suspended before final flush_workqueue

Just a temporary debugging aid.
---
 net/mac80211/pm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index a5d2f1f..231c8be 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -117,13 +117,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	 * shouldn't be doing (or cancel everything in the
 	 * stop callback) that but better safe than sorry.
 	 */
-	flush_workqueue(local->workqueue);
-
 	local->suspended = true;
 	/* need suspended to be visible before quiescing is false */
 	barrier();
 	local->quiescing = false;
 
+	flush_workqueue(local->workqueue);
+
 	return 0;
 }
 
-- 
1.6.2.5


-- 
Bob Copeland %% www.bobcopeland.com

