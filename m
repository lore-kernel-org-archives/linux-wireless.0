Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:21339 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1GEWWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:22:19 -0400
Date: Wed, 6 Jul 2011 00:22:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ipw2100: Fix command list for debugging
Message-ID: <20110706002206.299e8b89@endymion.delvare> (sfid-20110706_002222_495605_0154CA3F)
In-Reply-To: <20110705180832.GA7540@tuxdriver.com>
References: <20110704145346.384a462a@endymion.delvare>
	<20110705180832.GA7540@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 5 Jul 2011 14:08:32 -0400, John W. Linville wrote:
> On Mon, Jul 04, 2011 at 02:53:46PM +0200, Jean Delvare wrote:
> > A missing comma in the array causes an off-by-one for later commands.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: "John W. Linville" <linville@tuxdriver.com>
> > ---
> > Note: I don't have the documentation and I don't have the hardware, so
> > an expert should double-check this one.
> > 
> >  drivers/net/wireless/ipw2x00/ipw2100.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > --- linux-3.0-rc5.orig/drivers/net/wireless/ipw2x00/ipw2100.c	2011-05-20 10:42:41.000000000 +0200
> > +++ linux-3.0-rc5/drivers/net/wireless/ipw2x00/ipw2100.c	2011-07-04 14:44:22.000000000 +0200
> > @@ -287,7 +287,8 @@ static const char *command_types[] = {
> >  	"unused",		/* HOST_INTERRUPT_COALESCING */
> >  	"undefined",
> >  	"CARD_DISABLE_PHY_OFF",
> > -	"MSDU_TX_RATES" "undefined",
> > +	"MSDU_TX_RATES",
> > +	"undefined",
> >  	"undefined",
> >  	"SET_STATION_STAT_BITS",
> >  	"CLEAR_STATIONS_STAT_BITS",
> 
> This code dates from 2005:
> 
> commit ee8e365aa6395e721399127ccf3d28d269136f0e
> Author: James Ketrenos <jketreno@linux.intel.com>
> Date:   Wed Sep 14 09:47:29 2005 -0500
> 
>     Ran scripts/Lindent on drivers/net/wireless/ipw2{1,2}00.{c,h}
>     
>     No other changes.
>     
>     Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
> 

Yes, I found that commit too, and it explains why the two strings are
on the same line. As a side note, I don't think Lindent should do this,
but that's a different story.

> Prior to that, those two strings were on two different lines but with
> no comma betwen them -- so effectively the same as now. Changing it
> as you suggest would change the offsets in the array of the following
> string pointers, which I suspect will break the debugging code that
> uses it.

My own suspicion was that the current code was broken and my patch
would fix it. But a comparison with the defines in ipw2100.h suggests
that I was wrong and your analysis is correct:

#define MSDU_TX_RATES          62
#define SET_STATION_STAT_BITS      64

So there should be a single "undefined" between both.

> I would rather not take this change.  OTOH, perhaps you could submit a
> patch that simply remove the second quoted string from the single line?

Yes, I'll do this, thanks.

-- 
Jean Delvare
