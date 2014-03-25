Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42565 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624AbaCYINb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:13:31 -0400
Message-ID: <1395735204.28231.64.camel@dubbel> (sfid-20140325_091336_348574_1B69988C)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Tue, 25 Mar 2014 10:13:24 +0200
In-Reply-To: <1395734367.28231.57.camel@dubbel>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-4-git-send-email-michal.kazior@tieto.com>
	 <1395734367.28231.57.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 03/13] mac80211: prevent chanctx overcommit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-25 at 09:59 +0200, Luca Coelho wrote:
> On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
> > @@ -745,13 +764,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
> >  			 * context, reserve our current context
> >  			 */
> >  			new_ctx = curr_ctx;
> > -		} else {
> > +		} else if (ieee80211_can_create_new_chanctx(local)) {
> >  			/* create a new context and reserve it */
> >  			new_ctx = ieee80211_new_chanctx(local, chandef, mode);
> >  			if (IS_ERR(new_ctx)) {
> >  				ret = PTR_ERR(new_ctx);
> >  				goto out;
> >  			}
> > +		} else {
> > +			ret = -EBUSY;
> > +			goto out;
> 
> I'm not sure about this whole allowed channels counting thing.  Does it
> really matter what is the total number of allowed channels? I think the
> actual combinations is what should be checked here.
> 
> Let's say the driver supports these combinations:
> 
> 1. num_different_channels = 2; limits max 2 APs;
> 2. num_different_channels = 1; limits 1 AP, 1 STA;
> 
> Then you're running on a single-channel with 1 AP and 1 STA.  The STA
> gets a CSA to move to a new channel.  If you only consider the
> max_num_channels you calculated, you will think that it is okay to
> switch, but it is not, because you cannot have 1 AP and 1 STA on
> different channels.
> 
> Or am I missing something?

Hmmm... okay, I guess this is a typical case of "move-or-die" for the
AP.  Basically what we're saying here is that if the driver supports 2
channels in any combination, we can always have 2 channel contexts as
long as one of them is empty.

I'm still not sure this would be valid, for instance, if the driver has
problems with having one STA in a channel and an empty context in
another channel, because we actually try to create that context in the
driver before it's actually used...

--
Luca.

