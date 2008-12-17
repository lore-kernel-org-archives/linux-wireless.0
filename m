Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:26802 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYLQK4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 05:56:52 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1524309yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 02:56:51 -0800 (PST)
Message-ID: <e27b78a40812170256o6949875dq9849f1a838f68ce2@mail.gmail.com> (sfid-20081217_115655_709344_750DA92E)
Date: Wed, 17 Dec 2008 10:56:50 +0000
From: Keir <keirlawson@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: sbrown@cortland.com, linux-wireless@vger.kernel.org,
	javier@cozybit.com
In-Reply-To: <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <4947ABAF.9060205@cortland.com>
	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hu Andrey,

I'm using Netgear WG311TGE PCI cards, lspci says:

Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband
processor (rev 01)

There is only one bit to plug in an antenna, so I've only had one
plugged in, there isnt a place to plug in a second.  After the commit
in question I get no beaconing, before I get beaconing, but the PLINK
state keeps flipping between OPEN_SNT and LISTEN, implying that for
some reason it isnt receiving any PLINK packets.

That said, I havent tried directly after the PCU commit, so I will try
that now... but as I dont have an aux connector surely it shouldnt
effect me?

Cheers

Keir

2008/12/16 Andrey Yurovsky <andrey@cozybit.com>:
> Hi Keir.  What type of Atheros-based card are you using?  How many
> antennas do you have connected?  If I understand things correctly, the
> PCU code regression (with respect to mesh and maybe AP and IBSS) has
> to do with having one antenna hooked up when your hardware also has an
> AUX antenna connector.  If you have only one antenna, can you please
> plug in a second one and try again (before and after the commit in
> question)?  I will try to do the same test here.  More details from
> Nick were posted here:
> http://marc.info/?l=linux-wireless&m=122771338021489&w=2
>
> On Tue, Dec 16, 2008 at 8:07 AM, Keir <keirlawson@gmail.com> wrote:
>> I've been working on the commit previous to the PCU code breakage
>> (8485b7f773a8e9883e0165273940f16a086eba2b), but I'm still having
>> problems (beaconing is working, but links are rarely established, most
>> of the time to packets get through).
>>
>> Cheers
>>
>> Keir
>>
>> 2008/12/16 Steve Brown <sbrown@cortland.com>:
>>> Keir wrote:
>>>>
>>>> Having has no luck with an old rc6 version (basically all plink
>>>> packets were getting lost), I upgraded to the newest git (rc8) however
>>>> now when I run iw dev mesh0 station sump I don't see a single other
>>>> mesh point.  This would imply that presumably beaconing is broken?
>>>>
>>>> Does anyone know a revision for which ath5k is properly working? I am
>>>> yet to find one that works on my system.
>>>>
>>>> Cheers
>>>>
>>>> Keir
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>> Beaconing seems broken by Update PCU code
>>> dd1c9abd167de9bb9457a57694a1ab5e5801a0c1. After this patch, beacon debug
>>> says beacons sent, but sniffer sees none.
>>>
>>> A snapshot of ath5k prior to this and git 12/10
>>> (b6d06c9669f27db31a0317fc98fedc8ff1ba4822) works for me with hostapd/wpa.
>>> It's been running for the past few days.
>>>
>>> Mesh beaconing also works. I didn't test two nodes; I only sniffed the
>>> beacons.
>>>
>>> I had to comment out 5GHz in caps.c because of too many channels. It's a
>>> nl80211 buffer size problem that's been discussed.
>>>
>>> Steve
>>>
>>>
>>>
>>
>
>
>
> --
> Andrey Yurovsky
> cozybit Inc.
>
