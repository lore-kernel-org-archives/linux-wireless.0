Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47995 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3EIQj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 12:39:28 -0400
Message-ID: <518BD13D.1030504@candelatech.com> (sfid-20130509_183946_146844_7DC67C73)
Date: Thu, 09 May 2013 09:39:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Cyril Segretain <cyrilseg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
References: <5189DB72.3020809@candelatech.com> <20873.56643.216380.594657@gargle.gargle.HOWL> <518A6C21.5070408@candelatech.com> <20875.12412.946993.203664@gargle.gargle.HOWL> <518BB62D.9060108@candelatech.com> <CAJu560hVBcdJ67uNprj0TOY6rWNd-iT8f7QNaE64=ENz91yj6w@mail.gmail.com> <518BCE45.1060704@candelatech.com> <20875.53161.157603.680374@gargle.gargle.HOWL>
In-Reply-To: <20875.53161.157603.680374@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2013 09:32 AM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> I suspect we need to set up rules with 'tc' and maybe iptables.
>>
>> I'm not having any luck finding any examples out on the web, but
>> surely the info is somewhere w/out having to fully understand 'tc'.
>
> DSCP can be used...
>
> Something like "iptables -t mangle -A OUTPUT -p tcp --dport 5005 -j DSCP --set-dscp-class "CS6""
> (Change the class for other priorities).

In my case, I'd like to match on the ToS set in the IP headers.

Basically, just map ToS 192 to VO, for instance.

Thanks,
Ben

>
> Sujith
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

