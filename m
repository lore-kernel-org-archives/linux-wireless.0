Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:61680 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbbFRQkr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 12:40:47 -0400
Message-ID: <5582F48C.4000502@neratec.com> (sfid-20150618_184051_512783_C527799E)
Date: Thu, 18 Jun 2015 18:40:44 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: spectral - simplify max_index calculation
References: <1434446492-4127-1-git-send-email-zefir.kurtisi@neratec.com>	<CAFtRNNxvBC8SD3P5u=bEZPofA-A8YfHYuZnfA4Y07W7Wx4keAQ@mail.gmail.com>	<55829F18.9050807@neratec.com>	<CAFtRNNy009MVbOpHOWVZMuDAaJzmLed+nhBwgybgSS+hbjU=tQ@mail.gmail.com>	<CAFtRNNxnwTGXa8FS2n_chRZPrRffPtGrpZ96t7zFCDo2C7b8sw@mail.gmail.com> <CAFtRNNzzmPGr8UBzULvvgcGFrUqY8nvi1sBAQx8zkfo2tuLg=Q@mail.gmail.com>
In-Reply-To: <CAFtRNNzzmPGr8UBzULvvgcGFrUqY8nvi1sBAQx8zkfo2tuLg=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2015 05:46 PM, Nick Kossifidis wrote:
> 2015-06-18 17:34 GMT+02:00 Nick Kossifidis <mickflemm@gmail.com>:
>> To clarify this a bit: It's 0 - 63 for lower bins and 0 - 64 (not 63)
>> for upper bins and since we want an array index of 0 - 128 we add the
>> index of 0 to the upper max_idx (on the caller). You are right that
>> the current comment there is wrong (it even mentions 5bit ints) so
>> feel free to fix that but the code works as expected and it's much
>> more readable than doing "^ 0x20 - 4" on the caller (plus it handles
>> both signed and unsigned cases so no problem there).
>>
> 
> Arghh, I need to sleep asap :P
> 
> 0 - 64 for lower bins and 0 - 63 for upper bins...
> 

You sure? This would make 129 bins, no ;)


As for your other point:
> A bit more infos here:
> 
> On AR9280 there are various issues (check out spectral.c to get an
> idea) but I guess they got fixed on later chips so you probably won't
> see "shifted" indices etc on AR9590. However both the spectral scan
> and your work on chirp detection should work on earlier chips too.
> Unfortunately I can't test AR9280's radar detection code because I
> have a USB card (so it's ath9k_htc) and there is no DFS support there
> yet, but I suggest you test it on an older card to verify that you
> won't get any corruption. The good thing is that because you get only
> one report (if I remember correctly) in case of radar detection (so
> not software triggered spectral scan) you can easily fix that in your
> case by checking the packet's length (check out spectral.c  for
> ath_cmn_copy_fft_frame). Since the format is pretty much the same
> (only the magnitude calculation is different), maybe we could handle
> the two cases with common code instead (and fix any corruption there).

There is an important difference between the FFT data provided for spectral and
that for long radar pulses: with the former you always get complete samples, while
the latter can be truncated if the pulse goes away before the analysis is done.
With that, the corrective measures you can perform on spectral data based on the
expected data length and the known bugs causing an invalid length of {-1, +2,
combination thereof} can not be applied for the radar FFT data.

In the patch I posted there is a correction for cases when chip adds 2 extra bytes
before the FFT data (which we observed rarely on AR9590), but I might consider
removing it since it collides with cases where 2 bytes are appended to the data as
part of incomplete sample.


If there is enough interest and people able to test, I agree it would make sense
to generalize and share the code.


Good Night

