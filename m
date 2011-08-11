Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33115 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1HKHPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 03:15:06 -0400
Message-ID: <4E43816D.6080005@candelatech.com> (sfid-20110811_091510_515293_921D1FDD)
Date: Thu, 11 Aug 2011 00:14:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sam Leffler <sleffler@google.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bridging wired to STA interfaces.
References: <4E38DDB3.1030801@candelatech.com> <CA+yqC4YvAMLaao4dy2aXM7H5zPXySk4eAUZ2KSM4QnP+kQqF-A@mail.gmail.com> <4E39EB52.1090401@candelatech.com> <CA+yqC4a1xCPM4WN5U5Oth9PUqGSg+h6qZ4u2sV80h3zcEtzazg@mail.gmail.com>
In-Reply-To: <CA+yqC4a1xCPM4WN5U5Oth9PUqGSg+h6qZ4u2sV80h3zcEtzazg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2011 11:11 AM, Sam Leffler wrote:
> On Wed, Aug 3, 2011 at 5:44 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 08/03/2011 03:37 PM, Sam Leffler wrote:
>>>
>>> On Tue, Aug 2, 2011 at 10:33 PM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>
>>>> We have some interest in being able to bridge wired systems to
>>>> (virtual) STA interfaces, primarily for using third-party
>>>> traffic generation tools over virtual stations.
>>>>
>>>> I was thinking of writing a sta-bridge module that mapped
>>>> incoming packets on a wired interface to a STA with MAC
>>>> that matched the source MAC of the packet.  All packets
>>>> received on the STA would be forwarded un-modified out
>>>> the wired port.
>>>>
>>>> I think this would allow someone to create a STA interface
>>>> with MAC matching a PC connected to the wired port and effectively
>>>> have it be a transparent bridge between STA and PC.
>>>>
>>>> Has anyone attempted something like this before?
>>>>
>>>> Any interest in having this feature in the upstream kernel?
>>>
>>> You've just described what's done in several products and it is indeed
>>> useful.  The main issue is supporting it can incur overhead so you may
>>> want to make it a compile-time option.
>>
>> I got some basic functionality working today with some
>> user-space bridging code I've already written for other purposes...
>>
>> Can you think of any reason (beyond a bit of performance) that
>> this should be in the kernel?
>
> Doing it in user space seems fine to start.  All the examples I can
> think of are on minimal embedded platforms where taking the user-space
> hit is infeasible.  All the wireless devices that are interesting can
> do this in h/w w/ only minimal kernel support (except for the vif
> setup).
>
> FWIW the overhead I was referring to is in the kernel.  A many-to-1
> mapping of STA<->AP can be more expensive to support than 1-1.  But
> since you already support multi-sta you're already paying the price.
>
>>
>> My target hardware is fast enough that copying through user-space
>> at moderate (ie, fast as STA can go) speeds isn't too big of a deal, but
>> if someone wanted to run this on weak hardware, that might be reason
>> enough...  It might also make it easier to filter our management frames
>> (EAPOL, etc), but we should be able to do that easily enough in user-space
>> with a small bit of work.
>
> Setting up and tearing down the sta's in response to wired traffic was
> always the fun part.  Everything else was straightforward from what I
> can recall.

I think I'll just force user to create an STA with matching MAC (for the
MAC of the PC/whatever to be bridged).  Ath9k and ath5k can support at
least 128 stations, so that will be plenty for our uses...

We saw some problems changing MAC on STA after they were created, but
it seems to be ok if we just create it with correct STA the first time,
and we'll try to figure out why changing MAC was acting weird as well.

Thanks,
Ben

>
> -Sam


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
