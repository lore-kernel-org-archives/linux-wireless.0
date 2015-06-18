Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33148 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbbFRPeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 11:34:15 -0400
Received: by wgez8 with SMTP id z8so67094791wge.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2015 08:34:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNy009MVbOpHOWVZMuDAaJzmLed+nhBwgybgSS+hbjU=tQ@mail.gmail.com>
References: <1434446492-4127-1-git-send-email-zefir.kurtisi@neratec.com>
	<CAFtRNNxvBC8SD3P5u=bEZPofA-A8YfHYuZnfA4Y07W7Wx4keAQ@mail.gmail.com>
	<55829F18.9050807@neratec.com>
	<CAFtRNNy009MVbOpHOWVZMuDAaJzmLed+nhBwgybgSS+hbjU=tQ@mail.gmail.com>
Date: Thu, 18 Jun 2015 17:34:13 +0200
Message-ID: <CAFtRNNxnwTGXa8FS2n_chRZPrRffPtGrpZ96t7zFCDo2C7b8sw@mail.gmail.com> (sfid-20150618_173424_098926_A812965F)
Subject: Re: [PATCH] ath9k: spectral - simplify max_index calculation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-18 16:13 GMT+02:00 Nick Kossifidis <mickflemm@gmail.com>:
> 2015-06-18 12:36 GMT+02:00 Zefir Kurtisi <zefir.kurtisi@neratec.com>:
>> On 06/18/2015 10:43 AM, Nick Kossifidis wrote:
>>> max_index is a 6bit signed integer in both cases (sorry for the 5bit
>>> typo in the comments), so the current function handles it correctly
>>> for both HT20 and dynamic HT20/40 modes (I've tested it extensively).
>>> Also you don't handle the negative indices we get from the hardware
>>> (you just remove the sign). Have you tested this and if you did on
>>> which hardware did you do the test ?
>>>
>>> 2015-06-16 11:21 GMT+02:00 Zefir Kurtisi <zefir.kurtisi@neratec.com>:
>>>> [...]
>>>> +/* return the max magnitude from the all/upper/lower bins
>>>> + *
>>>> + * in HT20: 6-bit signed number of range -28 to +27
>>>> + * in HT40: 6-bit unsigned number of range 0 to +63
>>>> + *          (upper sub-channel index 0 is DC)
>>>> + *
>>>> + * Correct interpretation of the value has to be done at caller
>>>> + */
>>
>> The comment above is taken from developer NDA documents and should be correct.
>> With that, in HT40 mode the max_index value has to be taken as is, while in HT20
>> it needs to be shifted to the unsigned range.
>>
>
> I have NDA documents as well stating that the indices are from -64 to
> 63 (-64 to -1, 1 to 63 and 0 is DC), you can check out for yourself
> that we get 128bins on dynamic HT20/40, see the header files too:
>
> #define SPECTRAL_HT20_40_NUM_BINS               128
>
> and/or the received packet length. Maybe you are talking about
> "static" HT40 (I don't see anything about that on the documents I
> have) or something else.
>

To clarify this a bit: It's 0 - 63 for lower bins and 0 - 64 (not 63)
for upper bins and since we want an array index of 0 - 128 we add the
index of 0 to the upper max_idx (on the caller). You are right that
the current comment there is wrong (it even mentions 5bit ints) so
feel free to fix that but the code works as expected and it's much
more readable than doing "^ 0x20 - 4" on the caller (plus it handles
both signed and unsigned cases so no problem there).

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

A bit more infos here:

On AR9280 there are various issues (check out spectral.c to get an
idea) but I guess they got fixed on later chips so you probably won't
see "shifted" indices etc on AR9590. However both the spectral scan
and your work on chirp detection should work on earlier chips too.
Unfortunately I can't test AR9280's radar detection code because I
have a USB card (so it's ath9k_htc) and there is no DFS support there
yet, but I suggest you test it on an older card to verify that you
won't get any corruption. The good thing is that because you get only
one report (if I remember correctly) in case of radar detection (so
not software triggered spectral scan) you can easily fix that in your
case by checking the packet's length (check out spectral.c  for
ath_cmn_copy_fft_frame). Since the format is pretty much the same
(only the magnitude calculation is different), maybe we could handle
the two cases with common code instead (and fix any corruption there).


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
