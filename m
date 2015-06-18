Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36637 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbbFRP7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 11:59:19 -0400
Received: by wgzl5 with SMTP id l5so67801898wgz.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2015 08:59:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5582DFB2.7060308@neratec.com>
References: <1434446492-4127-1-git-send-email-zefir.kurtisi@neratec.com>
	<CAFtRNNxvBC8SD3P5u=bEZPofA-A8YfHYuZnfA4Y07W7Wx4keAQ@mail.gmail.com>
	<55829F18.9050807@neratec.com>
	<CAFtRNNy009MVbOpHOWVZMuDAaJzmLed+nhBwgybgSS+hbjU=tQ@mail.gmail.com>
	<5582DFB2.7060308@neratec.com>
Date: Thu, 18 Jun 2015 17:59:18 +0200
Message-ID: <CAFtRNNyP+q=J7N6Z9hKT0yHTZq_rMWdJLtxuqB82h9Qvavw_RA@mail.gmail.com> (sfid-20150618_175922_278632_8B6D5494)
Subject: Re: [PATCH] ath9k: spectral - simplify max_index calculation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-18 17:11 GMT+02:00 Zefir Kurtisi <zefir.kurtisi@neratec.com>:
> On 06/18/2015 04:13 PM, Nick Kossifidis wrote:
>> [...]
>> I have NDA documents as well stating that the indices are from -64 to
>> 63 (-64 to -1, 1 to 63 and 0 is DC), you can check out for yourself
>> that we get 128bins on dynamic HT20/40, see the header files too:
>>
>> #define SPECTRAL_HT20_40_NUM_BINS               128
>>
> Right, there are 128 in total, combined from 2 individual 64-bin sets. That's why
> you need to swap upper and lower when operating in HT40MINUS, since chip always
> puts primary channel to lower bin set.
>
>> and/or the received packet length. Maybe you are talking about
>> "static" HT40 (I don't see anything about that on the documents I
>> have) or something else.
>>
> Yes, maybe different documents. Mine says that interpretation of upper/lower bin
> values (max_magnitude, bitmap_weight, max_index) is the same in static and dynamic
> modes - only the bin values differ.
>
>>> I used the proposed method with the chirp detector for FFTs provided for long
>>> radar pulses on an AR9590 (patch posted the same day). Max bin index is used there
>>> the same way as with spectral, but now I realize my mistake: for chirp detection,
>>> the relative max_index is sufficient, while for spectral the absolute value is needed.
>>>
>>> Toggling the MSB in HT20 shifts the signed values by 32 and leaves the index with
>>> an offset of 4, therefore the correct operation should be:
>>> ht20_max_index_absolute = (ht20_max_index ^ 0x20) - 4
>>>
>>
>> Have in mind that on earlier chips (I did the testing on an AR9820) we
>> get corrupted frames sometimes so we also need the sanity check I put
>> there or else we can end up reading data out of bounds which is pretty
>> dangerous so please leave the current implementation there as is.
>>
>>
> The sanity checks / fixes are done before you look at the bin attributes and,
> which therefore is not relevant for interpreting them.
>

Only the lower boundary is checked (in case we are missing a byte -and
we assume it's the first sample-), if we get a corrupted max_idx
that's higher than 64 or 128 and we don't do the check on
spectral_max_index, we 'll have issues when accessing the samples
array to do the magnitude verification.




-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
