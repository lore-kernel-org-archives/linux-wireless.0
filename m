Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33576 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2GIQGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:06:25 -0400
Date: Mon, 9 Jul 2012 11:56:43 -0400
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Quartulli <ordex@autistici.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl/cfg/mac80211: use BIT(x) instead of (1 << x)
Message-ID: <20120709115643.19699ca0@mj> (sfid-20120709_180628_895538_071D80BC)
In-Reply-To: <1341825724.4455.16.camel@jlt3.sipsolutions.net>
References: <1341763805-7386-1-git-send-email-ordex@autistici.org>
	<1341825724.4455.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 09 Jul 2012 11:22:04 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> 
> > --- a/net/mac80211/iface.c
> > +++ b/net/mac80211/iface.c
> > @@ -1432,7 +1432,7 @@ int ieee80211_if_add(struct ieee80211_local
> > *local, const char *name, struct ieee80211_supported_band *sband;
> >  		sband = local->hw.wiphy->bands[i];
> >  		sdata->rc_rateidx_mask[i] =
> > -			sband ? (1 << sband->n_bitrates) - 1 : 0;
> > +			sband ? BIT(sband->n_bitrates) - 1 : 0;
> 
> I don't like the BIT()-1 pattern, "(1 << x) - 1" seems like a more
> regular pattern. Arguably, there should be a define for it, but I
> can't seem to come up with a good name.

>From drivers/mfd/dbx500-prcmu-regs.h:

#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))

So it would be

BITS(0, sband->n_bitrates - 1)

Perhaps BITS could be made safer and more generic when moved to a
common header.

-- 
Regards,
Pavel Roskin
