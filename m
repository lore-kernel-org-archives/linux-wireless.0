Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62399 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab0HJQ6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 12:58:53 -0400
Received: by gyg10 with SMTP id 10so3820151gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 09:58:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinXjYAwJqui41MFzPebUMkvQdO3UsfQcD7se158@mail.gmail.com>
References: <201008082124.33033.d.haid@gogi.tv> <AANLkTinXjYAwJqui41MFzPebUMkvQdO3UsfQcD7se158@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Aug 2010 09:58:32 -0700
Message-ID: <AANLkTi=DJ8heGhCKC+eLzzMHcuzV8dzRFkED_UnLHwZG@mail.gmail.com>
Subject: Re: Setting MCS rate on injected packets does not work properly (with
	patches)
To: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjorn.smedman@venatech.se>
Cc: Daniel Haid <d.haid@gogi.tv>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/9 Björn Smedman <bjorn.smedman@venatech.se>:
> On Sun, Aug 8, 2010 at 9:24 PM, Daniel Haid <d.haid@gogi.tv> wrote:
>> Hello,
>
>> When I use hostapd on one station and enable HT I get
>> rates of about 60MBit/s.
>>
>> But when I inject packets manually and I set the MCS index
>> the MCS index gets reported properly at the other station.
>> However no matter what index I choose, I never get rates
>> higher than 10MBit/s  (I wrote a program that reads monitor
>> mode packets with libpcap and sends them to a tun device
>> and everything that comes from the tun device is injected
>> with libpcap - then I measured the rate for UDP packets sent
>> trough this connection).
>
> One reason for this is aggregation: injected packets are not
> aggregated. Depending on your setup that could be the whole
> explanation.

You don't need to use aggregation for all frames, aggregation is just
one technique that you can use for 802.11n, ath9k is an example driver
that chooses to always use aggregation though.

> Also, a single fixed MCS index in the first slot of the tx control
> rates array will not perform as well as e.g. minstrel_ht, especially
> not if your radio environment is noisy.

You might want to look at how the passed rate gets mapped to a
hardware rate on the driver you are using.

  Luis
