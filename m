Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58966 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbZCHR7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 13:59:33 -0400
Date: Sun, 8 Mar 2009 19:59:14 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix WMM ACM parsing and AC downgrade
	operation
Message-ID: <20090308175914.GA18800@jm.kir.nu> (sfid-20090308_185941_879061_F32BFAB3)
References: <20090305152346.GA30029@jm.kir.nu> <1236515287.4205.11.camel@johannes.local> <20090308141703.GA10782@jm.kir.nu> <1236522333.4205.37.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236522333.4205.37.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 08, 2009 at 03:25:33PM +0100, Johannes Berg wrote:
> On Sun, 2009-03-08 at 16:17 +0200, Jouni Malinen wrote:
> > On Sun, Mar 08, 2009 at 01:28:07PM +0100, Johannes Berg wrote:
> > > On Thu, 2009-03-05 at 17:23 +0200, Jouni Malinen wrote:
> > > > @@ -99,10 +99,13 @@ static u16 classify80211(struct ieee8021
> > > >  	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
> > > >  		if (wme_downgrade_ac(skb)) {

> > > > -			return 0;
> > > > +			break;

> > > It seems to me that return 0 here was incorrect, or wme_downgrade_ac
> > > needs changes?

> > Yes, this return 0 was incorrect and that's why I'm fixing it to not
> > return 0 in this patch.. ;-) 

> Sorry, I meant correct. Why is it not correct? wme_downgrade_ac doesn't
> modify the skb when it returns an error.

Ah, okay, that's a more sensible comment and I can even try to provide a
more useful reply after having understood your point ;-). The failed
call to wme_downgrade_ac() does not modify the skb, but the previous
call(s) did (if there was one and there likely was). In other words, the
loop of calling wme_downgrade_ac() will end up downgrading the skb all
the way to using skb->priority = 2 which maps to AC_BK.

classify80211() returns the queue number based on the 802.1d tag (= UP)
and the old code was returning 0 in the error case (could not
downgrade). If you take a look at the ieee802_1d_to_ac[] array in the
beginning of wme.c you can see that the value 0 is used for UP values 6
and 7, i.e., something that maps to AC_VO, while we really should return
ieee802_1d_to_ac[2] = 3 (AC_BK) here. Breaking the loop on error makes
the classify80211() look up the proper queue number from
ieee802_1d_to_ac[] based on the downgraded skb->priority, not by using a
hardcoded value here, and ends up returning the desired value here
(lowest priority queue, not highest as the current code does).

-- 
Jouni Malinen                                            PGP id EFC895FA
