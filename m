Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35466 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933906AbbLPN1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:27:46 -0500
Message-ID: <567166D0.5090000@candelatech.com> (sfid-20151216_142755_032476_E0024BE0)
Date: Wed, 16 Dec 2015 05:27:44 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com> <20151216132113.GA4073@localhost>
In-Reply-To: <20151216132113.GA4073@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 05:21 AM, me@bobcopeland.com >> Bob Copeland wrote:
> On Tue, Dec 15, 2015 at 07:29:30PM -0800, Ben Greear wrote:
>> This patch below was added to the kernel around 2/24/2015
>>
>> I am curious mostly about the first change:  I thought the transmitter-addr
>> relates to the radio device, not the vdev (sta, ap, etc).
>>
>> But, wouldn't using data from the header break that assumption?
>
> I'm not sure this assumption is correct.  I have a hard time
> seeing the value in basing the transmitter addr attribute on some
> hardware address that may not even be used.

Imagine you have 20 virtual radios, and you want to send a beacon (or
other broadcast) to just one radio.

You can use the radio transmitter-addr to let the kernel know which
virtual radio receives the packet.

>
>> Is there any actual advantage to having more than one address per
>> hwsim radio?  It seems it complicates things for no particular
>> reason as far as I can tell?
>
> As a practical matter: the radios already have two "hardware"
> addresses, and as reported in the commit log, only one of them
> worked with the netlink interface, and it wasn't even the default
> address.
>
> I suppose there's no real benefit to multi-vif on hwsim vs multiple
> phys, other than testing multi-vif support in the stack, but why not?
> I think this patch actually simplifies things.

As long as you do a mapping in wmediumd, there should be no problem
at all with multiple vifs on a radio.  The HWSIM_ATTR_ADDR_TRANSMITTER
is just a key to let us know which radio we are talking about.  It
never needs to be 'on the air'.

>
> Does this patch cause problems for your userspace implementation?

Yes, because I coded with the assumptions that the radio addr had nothing
to do with the vif addr.

Thanks,
Ben

>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

