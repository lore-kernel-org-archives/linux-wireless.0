Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3CVMZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 08:25:00 -0400
Message-ID: <1363955094.8238.32.camel@jlt4.sipsolutions.net> (sfid-20130322_132507_628642_07E47472)
Subject: Re: Radiotap injected rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sam Leffler <sleffler@chromium.org>
Date: Fri, 22 Mar 2013 13:24:54 +0100
In-Reply-To: <20130318195406.GB17878@gobelin> (sfid-20130318_205432_783925_0898DAE7)
References: <20130317215544.GA7031@gobelin>
	 <1363634768.8260.16.camel@jlt4.sipsolutions.net>
	 <20130318195406.GB17878@gobelin> (sfid-20130318_205432_783925_0898DAE7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-18 at 20:54 +0100, Karl Beldan wrote:

> > No, older wpa_supplicant/hostapd still use monitor interfaces for
> > management frame transmissions, and require rate control.
> > 
> 
> Since they require rate control, I guess they don't pass any radiotap
> IEEE80211_RADIOTAP_{RATE,MCS} ? In that case that wouldn't disturb them.

Yeah, indeed, I wasn't looking right ...

> And, oops typo, I meant :
> 
> +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[0] != -1))
> 
> with info->control.rates[0] properly set in the radiotap header parsing,
> instead of :
> 
> > > +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[i]))
> 
> If that changes anything to what you guessed.

Well actually this won't work anyway because control.rates[] isn't
initialized to -1.

johannes

