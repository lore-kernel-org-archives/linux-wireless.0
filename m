Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1COSwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:52:54 -0400
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikieuk6CoRPzQGSMMggMc=wPEXHY5B5H2N_CB5a@mail.gmail.com>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
	 <1299831238.5082.185.camel@wwguy-huron>
	 <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
	 <1300063647.24333.7.camel@wwguy-ubuntu>
	 <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
	 <1300189917.5596.10.camel@jlt3.sipsolutions.net>
	 <1300193550.5596.16.camel@jlt3.sipsolutions.net>
	 <AANLkTinfEU2HNAg7aTmMgSrR6vVyVwLbFmpcP9TL4GyK@mail.gmail.com>
	 <1300214486.4139.6.camel@jlt3.sipsolutions.net>
	 <AANLkTikieuk6CoRPzQGSMMggMc=wPEXHY5B5H2N_CB5a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 19:52:46 +0100
Message-ID: <1300215166.4139.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-15 at 11:47 -0700, Daniel Halperin wrote:

> >> [341398.950019] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra =
> >> 00:16:ea:c3:b3:8e tid = 0
> >> [341401.790964] New seq exceeds buffering window: 2335, 2304
> >
> > So the delta is always 31, it seems? Is iwlwifi consistently sending
> > batches of 32 instead of the advertised 31?
> 
> I don't think that's the case, in fact I've never seen the hardware
> send a larger batch than frame limit.

Ok.

> I think it's from a missed
> frame early in one batch being pushed out by a late frame in the next
> batch.

Ok, yeah, that'd have the same effect.

>  I know how to get the logs to find out. I have a bunch of
> meetings soon, but I'll dig into this more later.

Thanks.

> > Also -- don't get confused, the tx_agg_start is on its own TX agg
> > session, but the new seq stuff is on its RX agg session.
> 
> You're absolutely true; but both sides pretty much start and stop
> aggregation in sync, they both have the same timeouts and I'm only
> using tcp traffic which is bidirectional.  They're running the same
> software on the same hardware, modulo one being an AP and one a
> client.

Right, if you have bidi traffic like TCP iwlwifi's way of
starting/stopping aggregation will be in sync.

> [Yes, I know that AP mode is broken on the iwl5300 but I disable power
> save, etc., and it seems to work well enough ...  Actually, does AP
> (not P2P) mode work properly on the P2P-supporting 6300?  I could
> switch to using those.]

Yeah, but I wouldn't worry about it in your case right now -- the only
broken thing that I know of is all about powersave.

johannes

