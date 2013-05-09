Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37620 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3EISuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:50:52 -0400
Message-ID: <518BF007.9010501@candelatech.com> (sfid-20130509_205056_228104_48096274)
Date: Thu, 09 May 2013 11:50:47 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	Cyril Segretain <cyrilseg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
References: <5189DB72.3020809@candelatech.com> <20873.56643.216380.594657@gargle.gargle.HOWL> <518A6C21.5070408@candelatech.com> <20875.12412.946993.203664@gargle.gargle.HOWL> <518BB62D.9060108@candelatech.com> <CAJu560hVBcdJ67uNprj0TOY6rWNd-iT8f7QNaE64=ENz91yj6w@mail.gmail.com> <518BCE45.1060704@candelatech.com> <20875.53161.157603.680374@gargle.gargle.HOWL> <518BD13D.1030504@candelatech.com> <CABPxzY+t1bZRtYf26-3yjVqv15m2FjB0eZ29ixniqbVPZ2NoNA@mail.gmail.com>
In-Reply-To: <CABPxzY+t1bZRtYf26-3yjVqv15m2FjB0eZ29ixniqbVPZ2NoNA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2013 10:00 AM, Krishna Chaitanya wrote:
> On Thu, May 9, 2013 at 10:09 PM, Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 05/09/2013 09:32 AM, Sujith Manoharan wrote:
>>>
>>> Ben Greear wrote:
>>>>
>>>> I suspect we need to set up rules with 'tc' and maybe iptables.
>>>>
>>>> I'm not having any luck finding any examples out on the web, but
>>>> surely the info is somewhere w/out having to fully understand 'tc'.
>>>
>>>
>>> DSCP can be used...
>>>
>>> Something like "iptables -t mangle -A OUTPUT -p tcp --dport 5005 -j DSCP --set-dscp-class "CS6""
>>> (Change the class for other priorities).
>>
>>
>> In my case, I'd like to match on the ToS set in the IP headers.
>>
>> Basically, just map ToS 192 to VO, for instance.
>
> Talking about rules, Are you able to see the ToS marked in the IP header in
> the sniffer and not in the 802.11 header? Then we can concentrate on
> marking the packet (or) mapping in the driver?
>

Ahh, in my case, I introduced the bug in my code trying to fix a kernel
splat when using pktgen to drive packets against wifi interfaces.

When I remove that, then the AP uses queues as expected.  I'm going to
have to make the pktgen hack a bit better it seems.

With this in mind, other folks that want QoS working on their APs
probably just needs to somehow mangle the ToS on their packets
to get it automatically working.  Hopefully no 'tc' or similar commands
would be needed.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

