Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38969 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab2CMA6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 20:58:38 -0400
Message-ID: <4F5E9BAD.6040505@candelatech.com> (sfid-20120313_015844_853413_332E27B4)
Date: Mon, 12 Mar 2012 17:58:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: David Woodhouse <dwmw2@infradead.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
References: <4F5E7031.4000401@candelatech.com> <201203122332.16325.chunkeey@googlemail.com> <4F5E7A81.8090605@candelatech.com> <CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
In-Reply-To: <CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2012 05:53 PM, Luis R. Rodriguez wrote:
> On Mon, Mar 12, 2012 at 3:36 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 03/12/2012 03:32 PM, Christian Lamparter wrote:
>>>
>>> On Monday, March 12, 2012 10:52:49 PM Ben Greear wrote:
>>>>
>>>> It seems we bought a Lenovo laptop that has a BIOS lock where it will
>>>> only
>>>> support certain wifi NICs based on the pci-id.  It came with an Intel
>>>> NIC, so at least that ID must work...
>>>>
>>>> One way around this might be to over-write the pci-id of an Atheros NIC
>>>> in it's non-volatile storage to make it look like an Intel, at least
>>>> until
>>>> the kernel boots.
>>>>
>>>> Then maybe add some sort of ugly code to force the Atheros driver
>>>> to manage this Intel pci-id (and probably disable the same pci-id in
>>>> the Intel driver).
>>>>
>>>> Has anyone tried doing anything like this?  Any suggestions for a cleaner
>>>> way to go about this?
>>>
>>> Been down this road before. First an old X41 Tablet and more recently a HP
>>> dv6 laptop.
>>>
>>> I think if you manage to reprogram the cards pciids then you are more than
>>> halfway there. Because theoretically, you can get away with adding the
>>> fake
>>> intel id to ath9k through sysfs:
>>>
>>> echo "8086 dead">    /sys/bus/pci/drivers/ath9k/new_id
>>> [for more information, take a look at the new_id sysfs interface]
>>> (Of course, you'll have to get rid of the intel driver first)
>>>
>>> That said, in both cases I risked flashing a modded bios. So whitelists
>>> are
>>> no longer a problem.
>>>
>>> PS: AFAIK [Maybe some QCA dev can verify this]: all AR9300+ have OTP ROMs
>>> for the pciids. So you might want to get an older AR9280 for your laptop.
>>
>>
>>
>> We're hoping to use the WPEA-127N.
>
> I might as well chime in to explain the long story. If we figure out a
> way to ensure we can always get the antenna gain uniformly across
> different systems and expose this to the OS I suspect we can convince
> some OEMs this would be a better solution than simply restricting
> devices. I looked a the newer generation of dmidecode (its not called
> DMI, its something else now) thingy but saw no one yet had added
> 802.11 specifically, perhaps it may be good to consider it in the
> future for this. that's as far as I got from trying to kill this
> concern.

Seems like laptop vendors are just being lame.  Why can normal PCs
get away with no restrictions but somehow laptop makers have to do this??

Seems ethtool cannot dump eeprom from the atheros NICs I have
(including the WPEA-127N).  Any idea if it's possible to add
the ability to dump (and eventually write) to the WPA-127N
(and possibly others)?

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

