Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43945 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab2CLWgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 18:36:50 -0400
Message-ID: <4F5E7A81.8090605@candelatech.com> (sfid-20120312_233654_329992_743B8CF0)
Date: Mon, 12 Mar 2012 15:36:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
References: <4F5E7031.4000401@candelatech.com> <201203122332.16325.chunkeey@googlemail.com>
In-Reply-To: <201203122332.16325.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2012 03:32 PM, Christian Lamparter wrote:
> On Monday, March 12, 2012 10:52:49 PM Ben Greear wrote:
>> It seems we bought a Lenovo laptop that has a BIOS lock where it will only
>> support certain wifi NICs based on the pci-id.  It came with an Intel
>> NIC, so at least that ID must work...
>>
>> One way around this might be to over-write the pci-id of an Atheros NIC
>> in it's non-volatile storage to make it look like an Intel, at least until
>> the kernel boots.
>>
>> Then maybe add some sort of ugly code to force the Atheros driver
>> to manage this Intel pci-id (and probably disable the same pci-id in
>> the Intel driver).
>>
>> Has anyone tried doing anything like this?  Any suggestions for a cleaner
>> way to go about this?
> Been down this road before. First an old X41 Tablet and more recently a HP
> dv6 laptop.
>
> I think if you manage to reprogram the cards pciids then you are more than
> halfway there. Because theoretically, you can get away with adding the fake
> intel id to ath9k through sysfs:
>
> echo "8086 dead">  /sys/bus/pci/drivers/ath9k/new_id
> [for more information, take a look at the new_id sysfs interface]
> (Of course, you'll have to get rid of the intel driver first)
>
> That said, in both cases I risked flashing a modded bios. So whitelists are
> no longer a problem.
>
> PS: AFAIK [Maybe some QCA dev can verify this]: all AR9300+ have OTP ROMs
> for the pciids. So you might want to get an older AR9280 for your laptop.


We're hoping to use the WPEA-127N.

Thanks for all the info!

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

