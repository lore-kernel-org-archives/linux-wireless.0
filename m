Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49320 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab1HDAoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 20:44:06 -0400
Message-ID: <4E39EB52.1090401@candelatech.com> (sfid-20110804_024410_060046_A41400F5)
Date: Wed, 03 Aug 2011 17:44:02 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sam Leffler <sleffler@google.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bridging wired to STA interfaces.
References: <4E38DDB3.1030801@candelatech.com> <CA+yqC4YvAMLaao4dy2aXM7H5zPXySk4eAUZ2KSM4QnP+kQqF-A@mail.gmail.com>
In-Reply-To: <CA+yqC4YvAMLaao4dy2aXM7H5zPXySk4eAUZ2KSM4QnP+kQqF-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/03/2011 03:37 PM, Sam Leffler wrote:
> On Tue, Aug 2, 2011 at 10:33 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> We have some interest in being able to bridge wired systems to
>> (virtual) STA interfaces, primarily for using third-party
>> traffic generation tools over virtual stations.
>>
>> I was thinking of writing a sta-bridge module that mapped
>> incoming packets on a wired interface to a STA with MAC
>> that matched the source MAC of the packet.  All packets
>> received on the STA would be forwarded un-modified out
>> the wired port.
>>
>> I think this would allow someone to create a STA interface
>> with MAC matching a PC connected to the wired port and effectively
>> have it be a transparent bridge between STA and PC.
>>
>> Has anyone attempted something like this before?
>>
>> Any interest in having this feature in the upstream kernel?
>
> You've just described what's done in several products and it is indeed
> useful.  The main issue is supporting it can incur overhead so you may
> want to make it a compile-time option.

I got some basic functionality working today with some
user-space bridging code I've already written for other purposes...

Can you think of any reason (beyond a bit of performance) that
this should be in the kernel?

My target hardware is fast enough that copying through user-space
at moderate (ie, fast as STA can go) speeds isn't too big of a deal, but
if someone wanted to run this on weak hardware, that might be reason
enough...  It might also make it easier to filter our management frames
(EAPOL, etc), but we should be able to do that easily enough in user-space
with a small bit of work.

Thanks,
Ben

>
> -Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
