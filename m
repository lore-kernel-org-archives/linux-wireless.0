Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2544 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab3BYKLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 05:11:46 -0500
Message-ID: <512B38D3.7000401@broadcom.com> (sfid-20130225_111149_558005_73D88A75)
Date: Mon, 25 Feb 2013 11:11:31 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Felix Fietkau" <nbd@openwrt.org>
cc: "Adrian Chadd" <adrian@freebsd.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
 <1361564916.3420.11.camel@jlt4.sipsolutions.net>
 <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
 <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
 <1361726886.8129.9.camel@jlt4.sipsolutions.net>
 <CAJ-Vmo=z+zbCfjMPXT4edyrB9Ukz0-ChE_Q1sqU_=6m_btx_Hg@mail.gmail.com>
 <512AFC80.9030808@openwrt.org>
In-Reply-To: <512AFC80.9030808@openwrt.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/13 06:54, Felix Fietkau wrote:
> On 2013-02-25 6:08 AM, Adrian Chadd wrote:
>> On 24 February 2013 09:28, Johannes Berg<johannes@sipsolutions.net>  wrote:
>>
>>>> In the driver we could inspect each sk_buff and boost priority of any
>>>> BOOTP packets so that it will end up in the AC_VO fifo and have
>>>> hardware coexistence handle it further. I consider that more a
>>>> pragmatic fix, which is not always the worst thing to go for.
>>>
>>> Well, I don't really think that's the best idea. Sniffing the protocol
>>> is clumsy at best.
>>
>> Sure, but it's the kind of thing that commercial devices do in order
>> to work around real world issues.
> Just because commercial devices do this crap to weasel out of fixing
> things properly doesn't mean we have to do the same.
>
>> So it'd be nice to have a programmatic way to detect things (eg bootp
>> packets going out) and signal the driver via some side channel to do
>> things like btcoex weight changing.
> I disagree, that approach clumsy and fragile and it's trying to address
> the issue in the wrong place.
>
> Most devices have some kind of connection manager that has a high-level
> perspective of when it's fully connected (which includes DHCP/bootp).

Hi Felix,

I agree with you here. I think the responsibility is indeed to be placed 
at a higher level.

> Why not just let that connection manager set a sane maximum network
> latency value via pm_qos network_latency and derive btcoex weight
> changing and multi-channel settings from that?

Now you are loosing me, but that can be helped. Could you educate me 
here a bit or some pointers to reading material? If there is a proper 
means already in place to communicate the information we might as well 
use it.

> - Felix
>

Regards,
Arend

