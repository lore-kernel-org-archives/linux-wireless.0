Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 63.mail-out.ovh.net ([91.121.185.56]:49494 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752432Ab0F2VXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 17:23:53 -0400
Message-ID: <4C2A6463.6060103@free.fr>
Date: Tue, 29 Jun 2010 23:23:47 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: ap tsf seems random and only uses lower
 24	bits or so
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com> <4C29284C.5050707@openwrt.org> <4C298DD2.8010704@free.fr> <4C29DCC1.2060707@openwrt.org>
In-Reply-To: <4C29DCC1.2060707@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 29/06/2010 13:45, Felix Fietkau a écrit :
> On 2010-06-29 8:08 AM, Benoit Papillault wrote:
>> Le 29/06/2010 00:55, Felix Fietkau a écrit :
>>> On 2010-06-29 12:31 AM, Björn Smedman wrote:
>>>> Hi all,
>>>>
>>>> I'm getting weird values from the debugfs file ieee80211/phy0/tsf: the
>>>> value goes up and down rather randomly and only the lower 24 bits or
>>>> so seem to ever be used (see below for details).
>>>>
>>>> The only thing running on phy0 is a single ap interface (and the
>>>> monitor companion that hostapd sets up). I was expecting tsf to
>>>> increase monotonically until all 64 bits had been used.
>>>>
>>>> For a moment I thought it might be the kernel snprintf (on mips)
>>>> playing a trick on me so I tried the following patch. But the result
>>>> is the same.
>>> IMHO the most likely problem source is stuck beacons. Please compile the
>>> driver with the debug option enabled and load it with
>>> insmod ath9k debug=0x00000100
>>>
>>> - Felix
>>
>> Humm... I observed a similar behavior a while ago because only the 15
>> lower bits of rstamp were used when being extended (but rstamp is 32
>> bits in fact). If so, it has been fixed by Felix in the following commit :
> Nope, different issue. The TSF extending applies only to rx timestamps,
> however Björn has been observing weird TSF values from the hw register.
> The Rx TSF timestamp is pretty much irrelevant in AP mode.
>
> - Felix
>

Ah, right and.. right! :-)
Sorry for the noise.

Regards,
Benoit

