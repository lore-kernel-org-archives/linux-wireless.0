Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59074 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab1BCS6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 13:58:25 -0500
Message-ID: <4D4AFACC.3080603@candelatech.com>
Date: Thu, 03 Feb 2011 10:58:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rfkill API
References: <4D48DF01.1010401@candelatech.com>	 <4D48E2C8.5010300@candelatech.com> <1296758576.3668.89.camel@dcbw.foobar.com>
In-Reply-To: <1296758576.3668.89.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2011 10:42 AM, Dan Williams wrote:
> On Tue, 2011-02-01 at 20:51 -0800, Ben Greear wrote:
>> On 02/01/2011 08:35 PM, Ben Greear wrote:
>>> Hello!
>>>
>>> I was looking at using one rfkill socket in wpa_supplicant, instead
>>> of one per vif.
>>>
>>> Current wpa_supplicant code seems to treat the API as if there is only
>>> as single rfkill object for the entire kernel. I would assume that
>>> instead different NICs could have different rfkill status.
>>>
>>> Is there any way to coorelate a netdevice (or devices)
>>> to the rfkill->idx in the
>>>
>>> struct rfkill_event {
>>> u32 idx;
>>> u8 type;
>>> u8 op;
>>> u8 soft;
>>> u8 hard;
>>> } STRUCT_PACKED;
>>>
>>>
>>> ?
>>>
>>> Thanks,
>>> Ben
>>>
>>
>> Err, nevermind..looks like you can grub around in sysfs and find the phy,
>> and from there, find the devices....
>
> Remember about platform devices.  An rfkill device is not always
> associated with a netdevice, and sometimes platform rfkill devices can
> block the netdevice rfkill.
>
> So, if you have a laptop with a BIOS rfkill switch, setting that rfkill
> switch "softblocked" will hardblock the netdevice rfkill device.  Thus
> you cannot unblock the netdevice rfkill until you unblock the
> platform/BIOS device rfkill.
>
> Yes, this sucks.

I tried to make my patch treat anything that wasn't specifically a phy
as 'all'..but likely it could still use some work.  I'll send it to the
list for review/suggestions..in case you have the time.

Is there any specific way to tell if an rfkill device is a platform
device?

For the platform rfkill blocking the netdevice rfkill:  Is this something
that must be done in software (ie, supplicant), or is that already handled
by the kernel/drivers/hardware?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

