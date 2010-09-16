Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39461 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0IPALN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 20:11:13 -0400
Message-ID: <4C91609B.5090501@candelatech.com>
Date: Wed, 15 Sep 2010 17:11:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC: mac80211/ath9k: allow scanning single channel if other VIF
 is associated.
References: <4C8EB03D.7070808@candelatech.com> <20100915030316.GB30253@jm.kir.nu> <4C9059DC.7060009@candelatech.com> <20100915203133.GA14541@jm.kir.nu> <AANLkTik=47CCXUz9NdDYXKzzgtfqPHFDGkUid0+6y7kw@mail.gmail.com>
In-Reply-To: <AANLkTik=47CCXUz9NdDYXKzzgtfqPHFDGkUid0+6y7kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2010 02:04 PM, Luis R. Rodriguez wrote:
> On Wed, Sep 15, 2010 at 1:31 PM, Jouni Malinen<j@w1.fi>  wrote:
>> On Tue, Sep 14, 2010 at 10:30:04PM -0700, Ben Greear wrote:
>>> I think for the multi-VIF scenario, it should scan the single associated
>>> channel by default, but it would be nice to allow full scans on demand.
>>> (I would very much like to work with standard wpa_supplicant, but if hacking it
>>> is the only way, then I can attempt that.)
>>
>> "Standard wpa_supplicant" needs to become more aware of multiple users
>> of the same radio, so it is certainly fine to add changes there. For
>> example, a mechanism for noticing that interfaces are sharing a radio
>> would be useful. With that, it should also be possible to share the BSS
>> table and scan results (and requests!) within wpa_supplicant.
>
> Depending on how this is implementing, sharing of the physical radio
> may require some kernel synchronization between the different
> interfaces using the same radio. It may also be possible to share the
> same radio between an 802.11 device and a wimax device, for example.
> Long ago we thought up of a frequency broker [1] but never really
> wrote it as we have had no usage case for it yet. If we implement the
> frequency broker we could also technically add a scheduler to sharing
> the same radio between separate interfaces / technologies, this could
> just be done in userspace as well, although I am not sure if the
> timing considerations for doing it in userspace would suffice.

At least for my use, I hope to be able to fully utilize the bandwidth for
a particular channel, and emulate as close as possible a bunch of wireless
devices sharing an AP or set of APs.  So, I don't want to be switching off the main
channel for any significant amount of time.  I think as long as you stick
to the main channel, there are no significant scheduling issues with
the hardware, but I could be wrong about that.

Also, I want to be able to run one supplicant per interface, so while
wpa_supplicant could become clever if it manages multiple devices, I
want them to be able to run independently as well.

As for figuring out what hardware a VIF belongs to, you can deduce this
by following links in sysfs to find it's phyX device.  It is a pain
when the phyX changes name due to module reload or something, but it can still
be dealt with.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
