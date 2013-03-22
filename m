Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:48228 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3CVNa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 09:30:29 -0400
Received: by mail-ea0-f179.google.com with SMTP id f15so1359975eak.38
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2013 06:30:27 -0700 (PDT)
Date: Fri, 22 Mar 2013 14:27:16 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sam Leffler <sleffler@chromium.org>
Subject: Re: Radiotap injected rates
Message-ID: <20130322132716.GB29340@magnum.frso.rivierawaves.com> (sfid-20130322_143040_898852_8E8E392D)
References: <20130317215544.GA7031@gobelin>
 <1363634768.8260.16.camel@jlt4.sipsolutions.net>
 <20130318195406.GB17878@gobelin>
 <1363955094.8238.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363955094.8238.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 22, 2013 at 01:24:54PM +0100, Johannes Berg wrote:
> On Mon, 2013-03-18 at 20:54 +0100, Karl Beldan wrote:
> 
> > > No, older wpa_supplicant/hostapd still use monitor interfaces for
> > > management frame transmissions, and require rate control.
> > > 
> > 
> > Since they require rate control, I guess they don't pass any radiotap
> > IEEE80211_RADIOTAP_{RATE,MCS} ? In that case that wouldn't disturb them.
> 
> Yeah, indeed, I wasn't looking right ...
> 
> > And, oops typo, I meant :
> > 
> > +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[0] != -1))
> > 
1)
> > with info->control.rates[0] properly set in the radiotap header parsing,
> > instead of :
> > 
> > > > +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[i]))
> > 
> > If that changes anything to what you guessed.
> 
> Well actually this won't work anyway because control.rates[] isn't
> initialized to -1.
> 
Of course we would set info->control.rates[0] to -1 by default in
ieee80211_parse_tx_radiotap and set it to something else if we parse a
IEEE80211_RADIOTAP_{RATE,MCS} (i.e what I was referring to in 1b).
 
Karl
