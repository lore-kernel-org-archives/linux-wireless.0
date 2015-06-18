Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35576 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbbFRONU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 10:13:20 -0400
Received: by wgbhy7 with SMTP id hy7so65024802wgb.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2015 07:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55829F18.9050807@neratec.com>
References: <1434446492-4127-1-git-send-email-zefir.kurtisi@neratec.com>
	<CAFtRNNxvBC8SD3P5u=bEZPofA-A8YfHYuZnfA4Y07W7Wx4keAQ@mail.gmail.com>
	<55829F18.9050807@neratec.com>
Date: Thu, 18 Jun 2015 16:13:18 +0200
Message-ID: <CAFtRNNy009MVbOpHOWVZMuDAaJzmLed+nhBwgybgSS+hbjU=tQ@mail.gmail.com> (sfid-20150618_161329_626749_10B6E7D5)
Subject: Re: [PATCH] ath9k: spectral - simplify max_index calculation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-18 12:36 GMT+02:00 Zefir Kurtisi <zefir.kurtisi@neratec.com>:
> On 06/18/2015 10:43 AM, Nick Kossifidis wrote:
>> max_index is a 6bit signed integer in both cases (sorry for the 5bit
>> typo in the comments), so the current function handles it correctly
>> for both HT20 and dynamic HT20/40 modes (I've tested it extensively).
>> Also you don't handle the negative indices we get from the hardware
>> (you just remove the sign). Have you tested this and if you did on
>> which hardware did you do the test ?
>>
>> 2015-06-16 11:21 GMT+02:00 Zefir Kurtisi <zefir.kurtisi@neratec.com>:
>>> [...]
>>> +/* return the max magnitude from the all/upper/lower bins
>>> + *
>>> + * in HT20: 6-bit signed number of range -28 to +27
>>> + * in HT40: 6-bit unsigned number of range 0 to +63
>>> + *          (upper sub-channel index 0 is DC)
>>> + *
>>> + * Correct interpretation of the value has to be done at caller
>>> + */
>
> The comment above is taken from developer NDA documents and should be correct.
> With that, in HT40 mode the max_index value has to be taken as is, while in HT20
> it needs to be shifted to the unsigned range.
>

I have NDA documents as well stating that the indices are from -64 to
63 (-64 to -1, 1 to 63 and 0 is DC), you can check out for yourself
that we get 128bins on dynamic HT20/40, see the header files too:

#define SPECTRAL_HT20_40_NUM_BINS               128

and/or the received packet length. Maybe you are talking about
"static" HT40 (I don't see anything about that on the documents I
have) or something else.

> I used the proposed method with the chirp detector for FFTs provided for long
> radar pulses on an AR9590 (patch posted the same day). Max bin index is used there
> the same way as with spectral, but now I realize my mistake: for chirp detection,
> the relative max_index is sufficient, while for spectral the absolute value is needed.
>
> Toggling the MSB in HT20 shifts the signed values by 32 and leaves the index with
> an offset of 4, therefore the correct operation should be:
> ht20_max_index_absolute = (ht20_max_index ^ 0x20) - 4
>

Have in mind that on earlier chips (I did the testing on an AR9820) we
get corrupted frames sometimes so we also need the sanity check I put
there or else we can end up reading data out of bounds which is pretty
dangerous so please leave the current implementation there as is.


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
