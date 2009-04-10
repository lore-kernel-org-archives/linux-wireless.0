Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48693 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764553AbZDJSL6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 14:11:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2009 11:11:58 -0700
Date: Fri, 10 Apr 2009 11:11:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] BUG in wiphy_update_regulatory when loading
	ath5k (on latest git)
Message-ID: <20090410181157.GC5750@tesla> (sfid-20090410_201203_034484_04EC63C4)
References: <49DF6216.8040303@tuffmail.co.uk> <49DF714F.9070600@tuffmail.co.uk> <1239385533.24621.11.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1239385533.24621.11.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 10, 2009 at 10:45:33AM -0700, Pavel Roskin wrote:
> On Fri, 2009-04-10 at 17:18 +0100, Alan Jenkins wrote:
> 
> > [   65.062652] BUG: unable to handle kernel NULL pointer dereference at
> > 00000004
> ...
> > [   65.063330] Code: b8 da 17 e0 83 c0 04 e8 92 f9 ff ff 84 c0 75 2a 8b
> > 55 d4 8b 42 28 85 c0 74 0c 83 c0 04 e8 7c f9 ff ff 84 c0 75 14 a1 bc da
> > 17 e0 <83> 78 04 03 74 66 8b 4d d4 80 79 08 00 74 5d a1 e0 d2 17 e0 48
> 
> "<83> 78 04 03" is "cmpl   $0x3,0x4(%rax)", which I can find in
> disassemly of reg_is_world_roaming(), which was inlined into
> wiphy_update_regulatory().
> 
> 0x3 is almost certainly NL80211_REGDOM_SET_BY_COUNTRY_IE in
> reg_is_world_roaming().  %rax must be 0, so we have a read at address
> 0x4.
> 
> last_request must be NULL.  The "initiator" field is at offset 4, which
> is consistent with the assembly.
> 
> Thus, wiphy_update_regulatory() is called before last_request was
> assigned a value.
> 
> last_request only seems to get a value in __regulatory_hint(), which is
> ultimately called by reg_todo(), a work handler.

Thanks pavel, please try this patch:

>From 94505af850bd0961a86e2786238ac0bbe0c44615 Mon Sep 17 00:00:00 2001
From: Luis R. Rodriguez <lrodriguez@atheros.com>
Date: Fri, 10 Apr 2009 11:07:43 -0700
Subject: [PATCH] cfg80211: fix bug while trying to process obeacon hints on init

During initialization we would not have received any beacons
so skip processing reg beacon hints, also adds a check to
reg_is_world_roaming() for last_request before accessing its
fields.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6f25ef4..8935122 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1155,7 +1155,8 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
 	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
 		return true;
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	if (last_request &&
+	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    wiphy->custom_regulatory)
 		return true;
 	return false;
@@ -1164,6 +1165,12 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 /* Reap the advantages of previously found beacons */
 static void reg_process_beacons(struct wiphy *wiphy)
 {
+	/*
+	 * Means we are just firing up cfg80211, so no beacons would
+	 * have been processed yet.
+	 */
+	if (!last_request)
+		return;
 	if (!reg_is_world_roaming(wiphy))
 		return;
 	wiphy_update_beacon_reg(wiphy);
-- 
1.6.2.2.446.gfbdc0

