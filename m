Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34630 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3DKKqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 06:46:18 -0400
Received: by mail-wg0-f44.google.com with SMTP id z11so1447163wgg.23
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 03:46:16 -0700 (PDT)
Date: Thu, 11 Apr 2013 12:42:19 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: always pick a basic rate to tx RTS/CTS for
 pre-HT rates
Message-ID: <20130411104219.GA27458@magnum.frso.rivierawaves.com> (sfid-20130411_124622_419026_2633002E)
References: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com>
 <1365674551.8272.39.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1365674551.8272.39.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 11, 2013 at 12:02:31PM +0200, Johannes Berg wrote:
> On Fri, 2013-04-05 at 12:06 +0200, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > When the 1st rate control entry is a pre-HT rate we want to set
> > rts_cts_rate_idx "as the fastest basic rate that is not faster than the
> > data rate"(code comments).
> > But in case some bss allowed rate indexes are lower than the lowest bss
> > basic rate, if the rate control selects a rate among the formers for its
> > 1st rate control entry, rts_cts_rate_idx remains 0 and is not a basic
> > rate index.
> > This commit sets rts_cts_rate_idx to the lowest bss basic rate index in
> > this situation.
> 
> Ok after reviewing this again I applied it.
> 
> 
> >  	if (!(info->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
> > -		s8 baserate = 0;
> > +		u32 basic_rates = tx->sdata->vif.bss_conf.basic_rates;
> > +		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
> 
> Note that this also assumes that rate 0 is a mandatory rate, which
> presumably will always be true.
> 
basic_rates == 0 should not happen so it's more a defensive fallback
in case there are no basic rates programmed (which should not happen) to
prevent out of bonds accesses via rts_cts_rate_idx.



 
Karl
