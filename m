Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39727 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab0HIQJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 12:09:18 -0400
Received: by yxg6 with SMTP id 6so3456176yxg.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Aug 2010 09:09:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008082124.33033.d.haid@gogi.tv>
References: <201008082124.33033.d.haid@gogi.tv>
Date: Mon, 9 Aug 2010 18:09:16 +0200
Message-ID: <AANLkTinXjYAwJqui41MFzPebUMkvQdO3UsfQcD7se158@mail.gmail.com>
Subject: Re: Setting MCS rate on injected packets does not work properly (with
	patches)
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 8, 2010 at 9:24 PM, Daniel Haid <d.haid@gogi.tv> wrote:
> Hello,

> When I use hostapd on one station and enable HT I get
> rates of about 60MBit/s.
>
> But when I inject packets manually and I set the MCS index
> the MCS index gets reported properly at the other station.
> However no matter what index I choose, I never get rates
> higher than 10MBit/s  (I wrote a program that reads monitor
> mode packets with libpcap and sends them to a tun device
> and everything that comes from the tun device is injected
> with libpcap - then I measured the rate for UDP packets sent
> trough this connection).

One reason for this is aggregation: injected packets are not
aggregated. Depending on your setup that could be the whole
explanation.

Also, a single fixed MCS index in the first slot of the tx control
rates array will not perform as well as e.g. minstrel_ht, especially
not if your radio environment is noisy.

10 Mbit/s sounds a bit slow though if you say you can get 60 in ap -
sta mode. Perhaps you are cpu limited?

/Björn
