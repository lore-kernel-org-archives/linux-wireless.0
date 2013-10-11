Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gecko.sbs.de ([194.138.37.40]:34895 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758549Ab3JKPs1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 11:48:27 -0400
Message-ID: <1381506302.3711.10.camel@djensen-laptop> (sfid-20131011_174857_400503_E05B8310)
Subject: Re: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz
 range
From: Dennis H Jensen <dennis.h.jensen@siemens.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 11 Oct 2013 17:45:02 +0200
In-Reply-To: <1381499778.14293.21.camel@jlt4.sipsolutions.net>
References: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
	 <1381499778.14293.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 15:56 +0200, Johannes Berg wrote:
> On Fri, 2013-10-11 at 13:59 +0200, Dennis H Jensen wrote:
> > Currently the frequencies (5910 - 5980) cannot be used because they
> > are mapped into the 4.9GHz channels; this patch closes that hole.
> 
> > @@ -79,6 +79,8 @@ int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
> >  	case IEEE80211_BAND_5GHZ:
> >  		if (chan >= 182 && chan <= 196)
> >  			return 4000 + chan * 5;
> > +		else if (chan > 196)
> > +			return 5000 + (chan - 15) * 5;
> 
> Where does the +/- 15 come from? I can't find any evidence for this in
> Annex E.

I didn't double check Annex E. I just wanted to recover the lost
frequencies that the 15 channels (182 - 196), map into 4.9 GHz.


//Dennis



