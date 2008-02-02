Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:31231 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763928AbYBBXYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 18:24:24 -0500
Received: by py-out-1112.google.com with SMTP id u52so2414163pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 15:24:23 -0800 (PST)
Message-ID: <43e72e890802021524w65b7d7cdu63743083b31bd4f2@mail.gmail.com> (sfid-20080202_232429_811001_CE45535F)
Date: Sat, 2 Feb 2008 18:24:22 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com, "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <40f31dec0802021507n55c51867s977a1461839d6b9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 <1201869970.4188.24.camel@johannes.berg>
	 <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com>
	 <40f31dec0802011047r6f90b714x8626f9158b963e6d@mail.gmail.com>
	 <43e72e890802011345l47dd4234t2515c5be4c5a8580@mail.gmail.com>
	 <43e72e890802021419w2460ea3ay5ea74be45697d322@mail.gmail.com>
	 <40f31dec0802021507n55c51867s977a1461839d6b9c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 2, 2008 6:07 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>
> > I'm just going to resend all pending patches. For this stuff I've
> > shifted a bit like this:
> >
> >         /*
> >          * Check bounds supported by the PHY (we don't care about regultory
> >          * restrictions at this point). Note: hw_value already has the band
> >          * (CHANNEL_2GHZ, or CHANNEL_5GHZ) so we inform ath5k_channel_ok()
> >          * of the band by that */
> >         if (!ath5k_channel_ok(ah, channel->center_freq, channel->hw_value)) {
> >                 char bname[5];
> >                 switch (channel->band) {
> >                 case IEEE80211_BAND_2GHZ:
> >                         strcpy(bname, "2 GHz");
> >                         break;
> >                 case IEEE80211_BAND_5GHZ:
> >                         strcpy(bname, "5 GHz");
> >                         break;
> >                 default:
> >                         BUG_ON(1);
> >                         return -EINVAL;
> >                 }
> >                 ATH5K_ERR(ah->ah_sc,
> >                         "channel frequency (%u MHz) out of supported "
> >                         "%s band range (%u - %u MHz)\n",
> >                         channel->center_freq,
> >                         bname,
> >                         ah->ah_capabilities.cap_range.range_2ghz_min,
> >                         ah->ah_capabilities.cap_range.range_2ghz_max);
> >                         return -EINVAL;
> >         }
> >
>
> We really don't need all this IMHO, ath5k_channel_ok is a simple
> working function that's supposed to do all needed checks and print any
> error msg, if you want to modify something modify ath5k_channel_ok,
> don't add more stuff on the caller. Also why use strings for the band
> ??? You can have an int and set it 2 or 5 if you want (i realy think
> strcpy is baaad).

OK fine, I'll edit ath5k_channel_ok in a later patch, for now I'll
just keep the code to match what was there to finish the cleanup.

  Luis
