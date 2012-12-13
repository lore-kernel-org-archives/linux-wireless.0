Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2LMWq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:46:59 -0500
Message-ID: <1355438841.9463.33.camel@jlt4.sipsolutions.net> (sfid-20121213_234706_731846_552C1DE1)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 23:47:21 +0100
In-Reply-To: <CAB=NE6W=BAOwcQ_XjbDiySx7xvAFoutv96Kcc9ULujUAWDHMGA@mail.gmail.com> (sfid-20121213_233853_278211_D6D16284)
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
	 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6W=BAOwcQ_XjbDiySx7xvAFoutv96Kcc9ULujUAWDHMGA@mail.gmail.com>
	 (sfid-20121213_233853_278211_D6D16284)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:38 -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 6, 2012 at 8:53 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > -       /* TODO: missing regulatory check on 80/160 bandwidth */
> > +       /*
> > +        * TODO: What if there are only certain 80/160/80+80 MHz channels
> > +        *       allowed by the driver, or only certain combinations?
> > +        *       For 40 MHz the driver can set the NO_HT40 flags, but for
> > +        *       80/160 MHz and in particular 80+80 MHz this isn't really
> > +        *       feasible -- should we ask the driver here?
> > +        */
> 
> It'd be real odd if a card could only do certain settings but at least
> from what I was told the spec did limit the required combinations to a
> smaller set so technically I could see the firmware having the checks
> to only allow those settings. I don't think it makes sense to add this
> as a limitation that gets annotated by a flag on the driver though. I
> suspect we can assume a driver that supports VHT80 will support those
> combos defined on the spec and so will a card that can support VHT160
> and the only restriction really should be regulatory.

Ok so mostly I'm thinking 80+80 limitations. I could imagine, for
example, that a card doesn't want to do 80+80 if they're adjacent (do
160 instead), but I have no idea what 80+80 cards are like...

johannes

