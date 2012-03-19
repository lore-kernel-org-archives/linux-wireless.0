Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2CSKNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:13:04 -0400
Subject: Re: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20327.1467.708015.943566@gargle.gargle.HOWL>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	 <1331902885.6753.10.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	 <1332065984.3609.5.camel@jlt3.sipsolutions.net>
	 <CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com>
	 <20326.44233.811876.892785@gargle.gargle.HOWL>
	 <1332145593.3359.6.camel@jlt3.sipsolutions.net>
	 <20327.1467.708015.943566@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 11:13:00 +0100
Message-ID: <1332151980.3359.21.camel@jlt3.sipsolutions.net> (sfid-20120319_111309_304911_CC1BF16A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 15:38 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > > As far as ath9k/ath9k_htc is concerned, I think we have to reset/reconfigure the HW
> > > when a channel switch happens, since we reprogram various MAC/PHY registers based on
> > > the HT bandwidth. Both ath9k and ath9k_htc update their rate control modules
> > > correctly - ath9k via the rate_update() callback and ath9k_htc using BSS_CHANGED_HT
> > > in bss_info_changed().
> > 
> > I'm not sure ath9k_htc is behaving correctly. Ok I should say that
> > differently -- it's probably behaving "correctly" wrt. whatever mac80211
> > did before, but we're changing the way mac80211 behaves and I believe
> > that to be (more) correct, see my other email.
> 
> Well, we do a bunch of HW configuration based on the channel bandwidth, like
> TX power, program MAC/PHY registers, various calibration routines at the baseband level.
> So when the bandwidth changes, doing a full HW reset is required, I think.

I guess I'm arguing that the channel bandwidth never changed, only the
inputs to rate control changed in a way that means you'll now transmit
only 20 MHz frames on that 40 MHz channel. After all, at least in AP
mode you have to deal with that anyway if a station joins that can't
receive 40 MHz for some reason, unless you want to penalise all others
as well?

johannes

