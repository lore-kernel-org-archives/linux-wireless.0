Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35565 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761984AbZFMQAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 12:00:42 -0400
Received: by bwz9 with SMTP id 9so2586118bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2009 09:00:44 -0700 (PDT)
To: Pierre Ossman <pierre@ossman.eu>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 13 Jun 2009 19:00:41 +0300
In-Reply-To: <20090613132144.6c7783bc@mjolnir.ossman.eu> (Pierre Ossman's message of "Sat\, 13 Jun 2009 13\:21\:44 +0200")
Message-ID: <87bposnmxi.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pierre Ossman <pierre@ossman.eu> writes:

> On Wed, 10 Jun 2009 22:03:00 -0400
> Bob Copeland <me@bobcopeland.com> wrote:
>
>> This adds the wl12xx_sdio module, enabling the SDIO interface for
>> wl12xx, as used by the Google G1 phone and others.
>> 
>> Signed-off-by: Bob Copeland <me@bobcopeland.com>
>> ---
>
> I think the drivers looks quite ok. There are really just a few things
> I'm concerned about:
>

[...]

> - Why do you have a platform device with the sole purpose of enabling
> power to the SDIO card? Shouldn't this be handled in the arch code?

wl1251 has these lines to the host:

o four lines for SDIO or SPI, configured to SDIO by default
o power line
o interrupt line

When the power line is pulled up, the chip will power on itself.
Whenever the power line goes down, the chip will power off. For example,
the power line can be controlled with a GPIO pin from the host. But how
the power line is really controlled, is board specific and should be
handled in the board file. And here comes the set_power() function to
the picture. The wl1251 driver will call set_power() function every time
user space calls wlan interface up or down.

Pierre, how do you propose we should do this? I understood based on
discussions from linux-omap that this is a common way.

-- 
Kalle Valo
