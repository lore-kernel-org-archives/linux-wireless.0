Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41737 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1ALUO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 15:14:26 -0500
Message-ID: <4D2E0B97.7000001@candelatech.com>
Date: Wed, 12 Jan 2011 12:14:15 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath9k: Handle interface changes properly
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com> <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com> <4D2E0653.7040606@openwrt.org>
In-Reply-To: <4D2E0653.7040606@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2011 11:51 AM, Felix Fietkau wrote:
> On 2011-01-12 10:06 AM, Björn Smedman wrote:
>> On Wed, Jan 12, 2011 at 3:30 PM, Rajkumar Manoharan
>> <rmanoharan@atheros.com> wrote:
>>> The commit ""ath9k: Add change_interface callback" was failed
>>> to update of hw opmode, ani and interrupt mask. This leads
>>> to break p2p functionality on ath9k. And the existing add and
>>> remove interface functions are not handling hw opmode and
>>> ANI properly.
>>>
>>> This patch combines the common code in interface callbacks
>>> and also takes care of multi-vif cases.
>>
>> How does your patch handle the race condition between the interface
>> change done in process context and the beacon tasklet triggered by
>> SWBA?
>>
>> Also, perhaps more applicable to the commit log than the patch, how
>> can opmode be properly handled in multi-vif cases? I mean let's say I
>> have two AP vifs and then change one into STA, is the opmode then STA?
>> Compare that to the case where I have two STA vifs and change one into
>> AP; so again I have one AP and one STA vif but this time opmode is AP,
>> right? I can see how I can be wrong about these examples but I can't
>> really see how the opmode concept can be properly handled in multi-vif
>> cases.
> I think opmode should be handled as follows:
> If there is at least one AP interface, opmode should be AP, regardless of what the other interfaces are set to.
> If there is no AP vif, opmode can be set to the primary vif type.

This seems right...I think this is what we did in ath5k.

Just FYI:  With current ath9k code, I get almost zero packet throughput to the
IP of the VAP device (ie, if it's serving DHCP) if I have a few STAs also
created & associated with some other AP.  Removing the STA interfaces makes the VAP work fine.
With or without the STAs on the VAP machine, vif to vif on vifs associated with the VAP work
fine, so it's some sort of issue with passing the pkts up the stack.

I haven't debugged this further.  I think ath5k doesn't have this problem,
but I haven't tested that scenario recently.

Thanks,
Ben

>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
