Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:19733 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbbFRPLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 11:11:50 -0400
Message-ID: <5582DFB2.7060308@neratec.com> (sfid-20150618_171154_384514_EC388632)
Date: Thu, 18 Jun 2015 17:11:46 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: spectral - simplify max_index calculation
References: <1434446492-4127-1-git-send-email-zefir.kurtisi@neratec.com>	<CAFtRNNxvBC8SD3P5u=bEZPofA-A8YfHYuZnfA4Y07W7Wx4keAQ@mail.gmail.com>	<55829F18.9050807@neratec.com> <CAFtRNNy009MVbOpHOWVZMuDAaJzmLed+nhBwgybgSS+hbjU=tQ@mail.gmail.com>
In-Reply-To: <CAFtRNNy009MVbOpHOWVZMuDAaJzmLed+nhBwgybgSS+hbjU=tQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2015 04:13 PM, Nick Kossifidis wrote:
> [...]
> I have NDA documents as well stating that the indices are from -64 to
> 63 (-64 to -1, 1 to 63 and 0 is DC), you can check out for yourself
> that we get 128bins on dynamic HT20/40, see the header files too:
> 
> #define SPECTRAL_HT20_40_NUM_BINS               128
> 
Right, there are 128 in total, combined from 2 individual 64-bin sets. That's why
you need to swap upper and lower when operating in HT40MINUS, since chip always
puts primary channel to lower bin set.

> and/or the received packet length. Maybe you are talking about
> "static" HT40 (I don't see anything about that on the documents I
> have) or something else.
> 
Yes, maybe different documents. Mine says that interpretation of upper/lower bin
values (max_magnitude, bitmap_weight, max_index) is the same in static and dynamic
modes - only the bin values differ.

>> I used the proposed method with the chirp detector for FFTs provided for long
>> radar pulses on an AR9590 (patch posted the same day). Max bin index is used there
>> the same way as with spectral, but now I realize my mistake: for chirp detection,
>> the relative max_index is sufficient, while for spectral the absolute value is needed.
>>
>> Toggling the MSB in HT20 shifts the signed values by 32 and leaves the index with
>> an offset of 4, therefore the correct operation should be:
>> ht20_max_index_absolute = (ht20_max_index ^ 0x20) - 4
>>
> 
> Have in mind that on earlier chips (I did the testing on an AR9820) we
> get corrupted frames sometimes so we also need the sanity check I put
> there or else we can end up reading data out of bounds which is pretty
> dangerous so please leave the current implementation there as is.
> 
> 
The sanity checks / fixes are done before you look at the bin attributes and,
which therefore is not relevant for interpreting them.

But never mind - as said before, I proposed this to use the 3 functions for DFS
chirp detection. I'm fine not touching the running system and instead keep a local
copy of those.


Thanks,
Zefir
