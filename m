Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61491 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaGPI4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 04:56:23 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so880132wiv.13
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 01:56:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201407161038.10130.sw@simonwunderlich.de>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
	<CA+BoTQmNJuwYpSiXqF8OUuXQULLSdUW+PO4Sz5oNKyaduHMKPg@mail.gmail.com>
	<4111404.UJkIUxkzQm@bentobox>
	<201407161038.10130.sw@simonwunderlich.de>
Date: Wed, 16 Jul 2014 10:56:16 +0200
Message-ID: <CA+BoTQm_pbtiT+ujRypZ6DuoqfFkYM-OfzvtaC+q9qurnMwpaA@mail.gmail.com> (sfid-20140716_105643_829035_F958E1A9)
Subject: Re: [RFC 0/2] ath10k spectral scan support
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Sven Eckelmann <sven@narfation.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 July 2014 10:38, Simon Wunderlich <sw@simonwunderlich.de> wrote:
>
>> On Wednesday 16 July 2014 08:24:58 Michal Kazior wrote:
>> > >  * So far, we always get 64 bins of fft data in the samples, even if we
>> > >
>> > >    are in HT40 or VHT80 mode. That doesn't seem right, as there should
>> > >    be more bins for wider channels (e.g. 128 or 256 bins). Is there any
>> > >    parameter to change in the configuration to get the output from
>> > >    multiple channels / higher bandwidth?
>> >
>> > Hmm.. I suspect this may be because you use scan command. Scanning
>> > uses channel list which is programmed with legacy modes a and g
>> > (implying 20Mhz). Perhaps that's the limiting factor now. Using other
>> > (wider) modes breaks scan from what I remember but it might be worth
>> > checking out if it impacts fft bin sizes.
>>
>> I did the HT80 and HT40 stuff on a single channel in the spectral
>> "background" mode. They reports from the firmware (10.1) still only had 64
>> bins. The HT80 stuff wasn't tested with the "main" firmware because it
>> refused to switch to HT80 mode as AP/Sta.
>
> Just to clarify this a little more, we tried AP (running hostapd) as well a
> STA in 40 and 80 MHz modes. We always got 64 bins returned.

It seems the number of bins is 2^ (fft_size - bin_scale) = 2^(7-1) =
64. Changing fft_size to 9 yields 256 bins.

Perhaps fft reports are (implicitly) relative to the mode the hw is in
at a given time and if you want a reasonable bin resolution for, e.g.
VHT80 you need to increase fft_size?


Michał
