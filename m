Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39665 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3EIRAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 13:00:51 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so3194517wgh.15
        for <linux-wireless@vger.kernel.org>; Thu, 09 May 2013 10:00:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518BD13D.1030504@candelatech.com>
References: <5189DB72.3020809@candelatech.com> <20873.56643.216380.594657@gargle.gargle.HOWL>
 <518A6C21.5070408@candelatech.com> <20875.12412.946993.203664@gargle.gargle.HOWL>
 <518BB62D.9060108@candelatech.com> <CAJu560hVBcdJ67uNprj0TOY6rWNd-iT8f7QNaE64=ENz91yj6w@mail.gmail.com>
 <518BCE45.1060704@candelatech.com> <20875.53161.157603.680374@gargle.gargle.HOWL>
 <518BD13D.1030504@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 9 May 2013 22:30:30 +0530
Message-ID: <CABPxzY+t1bZRtYf26-3yjVqv15m2FjB0eZ29ixniqbVPZ2NoNA@mail.gmail.com> (sfid-20130509_190056_176811_DAAB9B96)
Subject: Re: Fun with QoS in AP mode.
To: Ben Greear <greearb@candelatech.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Cyril Segretain <cyrilseg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 9, 2013 at 10:09 PM, Ben Greear <greearb@candelatech.com> wrote:
>
> On 05/09/2013 09:32 AM, Sujith Manoharan wrote:
>>
>> Ben Greear wrote:
>>>
>>> I suspect we need to set up rules with 'tc' and maybe iptables.
>>>
>>> I'm not having any luck finding any examples out on the web, but
>>> surely the info is somewhere w/out having to fully understand 'tc'.
>>
>>
>> DSCP can be used...
>>
>> Something like "iptables -t mangle -A OUTPUT -p tcp --dport 5005 -j DSCP --set-dscp-class "CS6""
>> (Change the class for other priorities).
>
>
> In my case, I'd like to match on the ToS set in the IP headers.
>
> Basically, just map ToS 192 to VO, for instance.

Talking about rules, Are you able to see the ToS marked in the IP header in
the sniffer and not in the 802.11 header? Then we can concentrate on
marking the packet (or) mapping in the driver?
