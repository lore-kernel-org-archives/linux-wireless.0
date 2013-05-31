Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35741 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3EaRVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 13:21:37 -0400
Message-ID: <51A8DC1C.1040908@candelatech.com> (sfid-20130531_192143_291284_FB196B0A)
Date: Fri, 31 May 2013 10:21:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: Another try at getting pktgen to work with wifi.
References: <51A79E4A.7000609@candelatech.com> <51A7B049.9090201@openwrt.org> <51A7BA63.4080403@candelatech.com> <51A857BF.7070008@openwrt.org>
In-Reply-To: <51A857BF.7070008@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2013 12:56 AM, Felix Fietkau wrote:
> On 2013-05-30 10:45 PM, Ben Greear wrote:
>> On 05/30/2013 01:02 PM, Felix Fietkau wrote:
>>> On 2013-05-30 8:45 PM, Ben Greear wrote:
>>>> I'm trying to come up with a more acceptable patch to the problem discussed a few years
>>>> ago:
>>>>
>>>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/64582/focus=64626
>>>>
>>>> The patch below appears to work as expected.  In pktgen, you just have to set
>>>> the QoS to whatever value matches the queue you need.
>>>>
>>>> This seem reasonable?
>>> Why do you adjust the queue mapping instead of the skb priority? In that
>>> other thread you mentioned that pktgen should be able to control the
>>> queue, yet here you're taking queue control away from it for tx on mac80211.
>>
>> I was having trouble getting it to work, but I was trying it at
>> a different place in the code when I was hacking on it...
>>
>> Do you think I'd just need to adjust skb->priority in the
>> same spot in the code, or is there more to it?
> I think that could work.

[added netdev to CC list]

Before I go work on this, does anyone have any preference over
whether pktgen packets should obey the QoS or the xmit-queue?

Currently, the kernel is effectively broken, and has been for years,
so probably no one has ever used pktgen with wifi devices.

As it turns out, mapping QoS appears to work best for my own needs,
but I can also try using the skb->priority as Felix suggests.

If no one cares, then I'd prefer to stick with the QoS method I posted
recently, and ignore the xmit-queue that pktgen might select.

Thanks,
Ben

>
> - Felix
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

