Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3LDI1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 03:27:20 -0500
Message-ID: <1386145635.4284.10.camel@jlt4.sipsolutions.net> (sfid-20131204_092723_545492_F7EE7A15)
Subject: Re: [PATCH 4/4] nl80211: add VHT support for set_bitrate_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Wed, 04 Dec 2013 09:27:15 +0100
In-Reply-To: <CALhHN=q63LmZb7CvO=4sDWf70-O7_vc7T6jhU7gFQNtsH7PuDQ@mail.gmail.com> (sfid-20131203_172122_770299_EE929FB5)
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1386060648-6020-4-git-send-email-janusz.dziedzic@tieto.com>
	 <1386080659.4393.29.camel@jlt4.sipsolutions.net>
	 <CALhHN=q63LmZb7CvO=4sDWf70-O7_vc7T6jhU7gFQNtsH7PuDQ@mail.gmail.com>
	 (sfid-20131203_172122_770299_EE929FB5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 17:21 +0100, Janusz Dziedzic wrote:

> We need this for test purpose. Need to test different MCS/NSS
> configurations using our HW (mainly for VHT).
> Our HW supports setting TX fixed_rate for legacy/HT/VHT.
> So, we decided to use set_tx_bitrate_mask() as the best interface for
> that in nl80211.
> And after that we realize VHT implementation/change will be needed in
> nl80211/iw also.
> Because of that I send this VHT patch.
> So, we need this :)

Fair enough - please add a line or two to the commit log.

> >> +#define NL80211_MAX_SUPP_VHT_RATES           80
> >
> > Where does 80 come from? That seems odd?
> >
> NSS_MAX (8) * MCS_MAX (10)
> 
> Eg.
> 9 - NSS=1, MCS=9
> 10 - NSS=2, MCS=0
> 11 - NSS=2, MCS=1
> ...

Can we please find a better way to encode this?

> >> + * @NL80211_TXRATE_VHT_MCS: VHT (MCS) rates allowed for TX rate selection
> >> + *   in an array of MCS numbers.
> >
> > VHT has no "MCS numbers", so this doesn't make much sense?
> >
> You mean description only or mcs mask for vht (like above)?

Well, for VHT, there's no single "MCS" identifier for a rate, rates are
identified using MCS (0-9) and NSS (1-8). In mac80211, we do some bit
tricks to fit them into a single byte, but I see no reason to do this in
the nl80211 API and would rather have an API that makes this obvious.
The easiest would be using a struct, but then you don't need 80 bytes,
only 8 bitmaps (one for each NSS), for example.

johannes

