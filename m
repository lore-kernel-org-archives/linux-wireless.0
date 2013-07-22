Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55472 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3GVWEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 18:04:51 -0400
Received: by mail-lb0-f175.google.com with SMTP id r10so5692978lbi.20
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jul 2013 15:04:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6X0vJ4Ts6p8M3i9GyZPCY6Gf6ztCdWvhdsVySO+4CL7pg@mail.gmail.com>
References: <CAB=NE6X0vJ4Ts6p8M3i9GyZPCY6Gf6ztCdWvhdsVySO+4CL7pg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 22 Jul 2013 15:04:29 -0700
Message-ID: <CAB=NE6W=RZFNJnLSZZXn4dAeutuMFjMMzfqLd3-=QgeJwaqYaA@mail.gmail.com> (sfid-20130723_000455_308448_15C289B9)
Subject: Re: IEEE VHT80 802.11 channels
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Felix Bitterli <ic.felix@gmail.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 3, 2013 at 12:05 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> We reviewed a while ago how we'd enable VHT80 channels and decided to
> go with a scaping of the regulatory data even though IEEE defined very
> specific channels. I hadn't seen a list with these center of freq IEEE
> channels so I figured I'd post them. As far as I can tell I see these
> defined. Whether or not you can use them will vary depending on your
> country's regulatory rules.
>
> 5210, 5290, 5530, 5610, 5610, 5690, 5775

The below extended map may help and could also be used to help
understand the corner case of VHT80 support on VHT80 center of freq
5690 MHz.

IEEE VHT80 center of freqs possible:

Center                  20 MHz channels                    ath10k capable
        __________  __________  __________  __________
       /          \/          \/          \/          \
5210     5180 (36)   5200 (40)   5220 (44)   5240 (48)           OK
5290     5260 (52)   5280 (56)   5300 (60)   5320 (64)           OK
5530     5500 (100)  5520 (104)  5540 (108)  5560 (112)          OK
5610     5580 (116)  5600 (120)  5620 (124)  5640 (128)          OK
5690     5660 (132)  5680 (136)  5700 (140)  5720 (144)*        Nope
5775     5745 (149)  5765 (153)  5785 (157)  5805 (161)          OK

Other vendor should consider reviewing their own implementation /
support / regulatory considerations / preferences for collateral of
not having a 20 MHz IEEE channel at center of freq 5720 (144) before.
I'll be pushing out how we address this next.

  Luis
