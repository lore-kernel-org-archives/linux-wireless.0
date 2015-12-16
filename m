Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35322 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbbLPNNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:13:43 -0500
Message-ID: <56716386.4070107@candelatech.com> (sfid-20151216_141347_143613_3C5314F9)
Date: Wed, 16 Dec 2015 05:13:42 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com>	 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>
In-Reply-To: <1450257464.3159.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 01:17 AM, Johannes Berg wrote:
> On Tue, 2015-12-15 at 19:29 -0800, Ben Greear wrote:
>> This patch below was added to the kernel around 2/24/2015
>>
>> I am curious mostly about the first change:  I thought the
>> transmitter-addr relates to the radio device, not the vdev (sta, ap,
>> etc).
>
> It doesn't, even on real hardware.

No, I mean that the HWSIM_ATTR_ADDR_TRANSMITTER should relate to the
radio, and not the vdev, see the mac80211_hwsim.h:

  * @HWSIM_ATTR_ADDR_TRANSMITTER: MAC address of the radio device that
  *	the frame was broadcasted from

>
>> But, wouldn't using data from the header break that assumption?
>>
>>
>> Is there any actual advantage to having more than one address per
>> hwsim radio?  It seems it complicates things for no particular
>> reason as far as I can tell?
>>
>
> ??
> You can do this with any regular hardware that supports multiple
> virtual interfaces - each one of them gets its own address.
>
> I think you might be confused by how ath*k implements the address
> matching - as I understand it there it's a common address (which may or
> may not match the programmed hardware address) along with a mask.
> That's not true in general though.

Since we are asking user-space to provide HWSIM_ATTR_ADDR_TRANSMITTER,
then we can use that to find the radio device.  Then, normal mac80211
logic can handle finding the vdevs (just as it does for ath9k).

And in this case, there is no reason to have more than one address
associated with the hwsim radio device.  We could add a pretty simple
hash to keep the lookup near constant time instead of linear search
as the current behaviour is...

> The hwsim commit here just makes wmediumd able to behave properly when
> the user changed the vif interface address.

I think that wmediumd should keep it's own mapping of what radio
a vdev is on and use the proper hwsim radio addr for the HWSIM_ATTR_ADDR_TRANSMITTER
attribute.

Thanks,
Ben

>
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

