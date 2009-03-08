Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54008 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbZCHORX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 10:17:23 -0400
Date: Sun, 8 Mar 2009 16:17:03 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix WMM ACM parsing and AC downgrade
	operation
Message-ID: <20090308141703.GA10782@jm.kir.nu> (sfid-20090308_151732_168574_74BD8C83)
References: <20090305152346.GA30029@jm.kir.nu> <1236515287.4205.11.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236515287.4205.11.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 08, 2009 at 01:28:07PM +0100, Johannes Berg wrote:
> On Thu, 2009-03-05 at 17:23 +0200, Jouni Malinen wrote:
> 
> > @@ -99,10 +99,13 @@ static u16 classify80211(struct ieee8021
> >  	/* in case we are a client verify acm is not set for this ac */
> >  	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
> >  		if (wme_downgrade_ac(skb)) {
> > -			/* The old code would drop the packet in this
> > -			 * case.
> > +			/*
> > +			 * This should not really happen. The AP has marked all
> > +			 * lower ACs to require admission control which is not
> > +			 * a reasonable configuration. Allow the frame to be
> > +			 * transmitted using AC_BK as a workaround.
> >  			 */
> > -			return 0;
> > +			break;
> 
> It seems to me that return 0 here was incorrect, or wme_downgrade_ac
> needs changes?

Yes, this return 0 was incorrect and that's why I'm fixing it to not
return 0 in this patch.. ;-) In theory, the correct behavior would be to
drop the frame if the AP is using mandatory admission control for all
ACs, but in practice, it is probably better not to break the connection
completely if the AP is misconfigured. The behavior after this patch is
to downgrade the AC until one is found without ACM and if no such AC
exists, use the lowest priority (AC_BK).

-- 
Jouni Malinen                                            PGP id EFC895FA
