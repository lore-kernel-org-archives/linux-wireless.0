Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34966 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753301AbcKTLJF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Nov 2016 06:09:05 -0500
Received: by mail-wm0-f42.google.com with SMTP id a197so102878396wmd.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2016 03:09:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161120010740.GB3581@localhost>
References: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com>
 <20161120010740.GB3581@localhost>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Sun, 20 Nov 2016 12:09:03 +0100
Message-ID: <CA+BoTQm9DBc_tkQnXwLVuV6dbsEixn73t_TRk1akktTiwRm_0w@mail.gmail.com> (sfid-20161120_120942_493531_C32332FE)
Subject: Re: ath10k stuck in mesh mode
To: Bob Copeland <me@bobcopeland.com>
Cc: Matteo Grandi <iu5bdp@gmail.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 November 2016 at 02:07, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Nov 18, 2016 at 10:43:06PM +0100, Matteo Grandi wrote:
>> So the question is: who decide if use MIMO and higher MCS hopefully on
>> 80MHz channel or not? Is the firmware? Is there a way to force the
>> interface to use 80MHz and/or MIMO? (iw provide the possibility to
>> choose between [HT20/HT40-/HT40+]).
>
> You can specify the channel width like so:
>
> iw dev wlan0 set freq 5745 80 5775
> iw dev wlan0 mesh join mesh-vht

With recent enough `iw` you can check the operational (max) bandwidth
of the interface with:

  iw dev wlan0 info

I don't know how mesh nodes negotiate their capabilities to each other
though so I don't know how reliable this is.

Actual modulation is picked by rate control in firmware. You can try
to force a fixed rate with[1]:

 iw dev wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:9

It doesn't allow setting fixed bandwidth though so you'll need to
check rx bitrate on the receiving end to verify.

[1]: https://wireless.wiki.kernel.org/en/users/drivers/ath10k/debug?s[]=3Ds=
et&s[]=3Dbitrates#manual_bitrates_configuration


Micha=C5=82
