Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61836 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab3EBRc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 13:32:58 -0400
Received: from mailout-de.gmx.net ([10.1.76.33]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MUzZb-1V6OPd1hef-00YUDy for
 <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:32:56 +0200
Message-ID: <5182A341.8050704@rempel-privat.de> (sfid-20130502_193302_645844_C81ADC0F)
Date: Thu, 02 May 2013 19:32:49 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 02.05.2013 18:55, schrieb Adrian Chadd:
> On 2 May 2013 01:11, Oleksij Rempel <linux@rempel-privat.de> wrote:
>
>> +#define WLAN_RC_TX_STBC_FLAG 0x20 /* TX STBC */
>> +#define WLAN_RC_RX_STBC_FLAG 0xC0 /* RX STBC ,2 bits */
>
> I thought we covered this; why are you marking two bits here?

becouse firmware checks for two bits (and then use it as bool ;)), so i 
pass what firmware can handle.

> Atheros 11n hardware only supports 1-stream STBC RX.

Did you got my email with lots of assumptions and questions?
What do you mean by 1-stream STBC RX? After i did some home work on STBC 
i see that it encoded from at least two spatial streams.
Is
1-stream STBC RX = 2 spatial streams with mirrored data?
and
2-stream STBC RX = 4 spatial streams with mirrored data?

or

1-stream STBC RX = compatibility mode for one stream hardware(so only of 
two streams received)?
That would make sense for 1x1:1 hardware, but if you say all atheros N 
hardware support only 1-stream STBC RX, will mean that STBC is useless 
on this hardware.

> Have you verified that we're actually negotiating 1-stream STBC RX
> with a peer? (Ie, by looking at packet captures?)

Yes, i wrote this too :) I verified it, we negotiate only 1-stream STBC RX.

-- 
Regards,
Oleksij
