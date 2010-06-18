Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:47971 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266Ab0FRIU3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 04:20:29 -0400
Message-ID: <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
Date: Fri, 18 Jun 2010 11:20:26 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"Bob Copeland" <bcopeland@gmail.com>
Subject: Re: [PATCH] ath5k: disable ASPM
References: <20100528100901.14580.1322.stgit@fate.lan>
	<1276806785.20754.8.camel@maxim-laptop>
In-Reply-To: <1276806785.20754.8.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Maxim Levitsky" <maximlevitsky@gmail.com>:

> On Fri, 2010-05-28 at 13:09 +0300, Jussi Kivilinna wrote:
>> Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
>> Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
>> enabled. With ASPM ath5k will eventually stall on heavy traffic with often
>> 'unsupported jumbo' warnings appearing. Disabling ASPM L0s/L1 in ath5k fixes
>> these problems.
>>
>> Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
>> both ends (usually stalls within seconds).
>
> This fixes the same nasty problem on my AR2425.
>
> My AR2425 will stall if it transmits for about 1~2 minutes.
>
> It sends storm of RXORN interrupts although it only transmits.
>
> I see that now lspci calls it AR5001.
>
> Jussi Kivilinna, million thanks to you. I would never think of going
> this direction.
>
> Luis, so I was right after all, wasn't I?
> It is a hardware bug that is worked around in windows driver by
> disabling PCIE ASPM L0S.

I noticed this L0s disabling in windows driver too. I cannot test this  
anymore, since I don't have ath5k hw installed anymore (I switched to  
b43).

(ok, I might switch back ath5k to work on this, but opening AAO is  
pain.. on the other hand, I'm just user in this case and pretty  
unwilling to work with dual-license)

I did test device with L0s+L1 enabled (aspm=force), on this setup  
device fails within seconds. I tested patch with disabling L1 but not  
L0s, still fails but after longer time. I did _not_ test with L0s off  
but L1 enabled. So maybe it would be worth to test this patch with  
just disabling L0s.

AAO150 seems to enable L0s from BIOS, so this happens without  
aspm=force or CONFIG_.._ASPM at all.

  -Jussi

