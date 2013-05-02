Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49661 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3EBUcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 16:32:32 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MGlNX-1UlWhz1ucb-00DYXs for
 <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 22:32:30 +0200
Message-ID: <5182CD59.8060509@rempel-privat.de> (sfid-20130502_223240_175767_182A00FE)
Date: Thu, 02 May 2013 22:32:25 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Adrian Chadd <adrian@freebsd.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> <5182A341.8050704@rempel-privat.de> <5182A9DC.6030203@openwrt.org>
In-Reply-To: <5182A9DC.6030203@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

thank you for your explanation and being pation with me.
I learn it by my self and keywords you gave help me to find needed 
information. So, i continue to digg in to google books and wikis now.

I see now, that my initial assumption that STBC some thing like 
"frequency diversity" is wrong. Well, it say by itself Space and Time, 
no freq :)

Am 02.05.2013 20:01, schrieb Felix Fietkau:
> On 2013-05-02 7:32 PM, Oleksij Rempel wrote:
>> Am 02.05.2013 18:55, schrieb Adrian Chadd:
>>> On 2 May 2013 01:11, Oleksij Rempel <linux@rempel-privat.de> wrote:
>>>
>>>> +#define WLAN_RC_TX_STBC_FLAG 0x20 /* TX STBC */
>>>> +#define WLAN_RC_RX_STBC_FLAG 0xC0 /* RX STBC ,2 bits */
>>>
>>> I thought we covered this; why are you marking two bits here?
>>
>> becouse firmware checks for two bits (and then use it as bool ;)), so i
>> pass what firmware can handle.
>>
>>> Atheros 11n hardware only supports 1-stream STBC RX.
>>
>> Did you got my email with lots of assumptions and questions?
>> What do you mean by 1-stream STBC RX? After i did some home work on STBC
>> i see that it encoded from at least two spatial streams.
>> Is
>> 1-stream STBC RX = 2 spatial streams with mirrored data?
>> and
>> 2-stream STBC RX = 4 spatial streams with mirrored data?
>>
>> or
>>
>> 1-stream STBC RX = compatibility mode for one stream hardware(so only of
>> two streams received)?
> When you're talking about 'streams', please specify where you're talking
> about Spatial Streams (Nss, defined by the MCS), or Space-Time Streams
> (Nsts). STBC is useful whenever the number of possible Space-Time
> streams exceeds the number of Spatial streams, i.e. if the number of tx
> chains is bigger than the number of spatial streams.
> There's an asymmetry between Rx and Tx here. If a receiver has 1 chain
> and the transmitter has 2 chains, tx can use 2 Space-Time streams to
> encode 1 Spatial stream to improve the reliability of the signal.
> The HT STBC capability field indicates the maximum number of Spatial
> Streams, not Space-Time streams. Atheros hardware only supports STBC
> with Nss = 1, so announcing 2-stream STBC is definitely wrong.

Ok, i finally found it on ieee 802.11 specification.
For STBC:
Nsts=2 - Nss=1
Nsts=3 - Nss=2
Nsts=4 - Nss=2
Nsts=4 - Nss=3

>> That would make sense for 1x1:1 hardware, but if you say all atheros N
>> hardware support only 1-stream STBC RX, will mean that STBC is useless
>> on this hardware.
> Only STBC With Nss=1, Nsts=2 is supported, but this does not make it
> useless at all. It helps, even if the receiver only has one antenna.

Found it too.. :)
Thx!

-- 
Regards,
Oleksij
