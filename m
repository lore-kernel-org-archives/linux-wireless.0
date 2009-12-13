Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:38841 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753248AbZLMNKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 08:10:33 -0500
Date: Sun, 13 Dec 2009 14:10:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 5/9] drivers/net/wireless: Correct code taking the size
 of a pointer
In-Reply-To: <m2iqcbt4n5.fsf@igel.home>
Message-ID: <Pine.LNX.4.64.0912131409590.24267@ask.diku.dk>
References: <Pine.LNX.4.64.0912131241470.24267@ask.diku.dk> <m2iqcbt4n5.fsf@igel.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 13 Dec 2009, Andreas Schwab wrote:

> Julia Lawall <julia@diku.dk> writes:
> 
> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > index eb1e1d0..1e74732 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -2140,8 +2140,8 @@ static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
> >  	rt2800_register_multiread(rt2x00dev, offset,
> >  				      &iveiv_entry, sizeof(iveiv_entry));
> >  
> > -	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
> > -	memcpy(&iveiv_entry.iv[4], iv32, sizeof(iv32));
> > +	memcpy(&iveiv_entry.iv[0], iv16, sizeof(*iv16));
> > +	memcpy(&iveiv_entry.iv[4], iv32, sizeof(*iv32));
> 
> That still looks pretty bogus, the memcpy calls are overwriting the
> values written by the previous rt2800_register_multiread call.  Most
> likely the first two arguments need to be swapped.

OK, I will look at it and try again.

Thanks,
julia
