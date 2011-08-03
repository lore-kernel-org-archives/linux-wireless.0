Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53687 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1HCQhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 12:37:45 -0400
Message-ID: <4E397956.4070300@candelatech.com> (sfid-20110803_184109_456461_1A4FE45E)
Date: Wed, 03 Aug 2011 09:37:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bridging wired to STA interfaces.
References: <4E38DDB3.1030801@candelatech.com> <CAJ-Vmon2Xwv3VqDhH9EouGiYgr0wfoEh3_41D4EscmForRDgaA@mail.gmail.com>
In-Reply-To: <CAJ-Vmon2Xwv3VqDhH9EouGiYgr0wfoEh3_41D4EscmForRDgaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/03/2011 02:16 AM, Adrian Chadd wrote:
> How do you propose handling the case where people will hook up>1 device?
> Print out a very loud warning? :-)

I think you'd end up mapping the MAC of the PC to the STA, 1-to-1 mapping,
and possibly re-writing the src MAC when coming from the PC to the STA,
and dest MAC when coming from STA to PC.

Users wanting more than one PC could use a different virtual STA.

> I did something like this a while ago for a company and their first
> request was exactly that - "Customer X now wants two devices in a
> vehicle hooked up to the wireless, it doesn't work, what do we do?"

Did it at least work for 1-to-1 mapping OK?  Did you re-write MACs?

Thanks,
Ben

>
>
> Adrian
>
>
> On 3 August 2011 13:33, Ben Greear<greearb@candelatech.com>  wrote:
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
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear<greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
