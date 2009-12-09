Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34325 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbZLINal (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 08:30:41 -0500
Message-ID: <4B1FA685.4040605@openwrt.org>
Date: Wed, 09 Dec 2009 14:30:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: 8an@praha12.net
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
References: <200912061820.26320.8an@praha12.net> <200912090216.09816.8an@praha12.net> <4B1F01D4.6020803@openwrt.org> <200912091412.47689.8an@praha12.net>
In-Reply-To: <200912091412.47689.8an@praha12.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2009-12-09 2:12 PM, Lukáš Turek wrote:
>> Some hardware internally calculates the ACK timeout based on the
>> configured slot time. Broadcom does it this way.
>> Maybe adjusting the ACK timeout without adjusting the slot time works,
>> but it'll probably interfere with CSMA.
> Ahteros is not Broadcom, it does not have a firmware, I'm writing the ACK 
> timeout directly into a register of the MAC chip. But you're suggesting what 
> I said in previus mail: we have to understand what the hardware does. And as 
> there is no documentation, the only way is experiment. Most of ath5k was 
> developed this way.
> 
>> > 802.11a: 21 µs
>> > 802.11b: 27 µs
>> > 802.11g: 19 µs
>>
>> How did you measure it?
> Just by gradually lowering the value in ACK timeout register (it's accessible 
> via sysctl in FreeBSD) and testing the link using ordinary ping. When the ACK 
> timeout was too low, packetloss grew from 0% to 50% or so.
That's definitely completely inaccurate. Even before you get packet
loss, as you lower the ACK timeout value, you will first start to get an
increase in the number of retransmissions.

>> I'm guessing that most hardware does have some degree of tolerance for
>> timing variation. IMHO, if the standard recommends slightly higher but
>> working values for the same distance, we should use that rather than
>> experimentally determined limits.
> The problem is, it's not slightly higher, it's twice or more higher:
> aSIFSTime + aSlotTime + aPHY-RX-START-Delay is 50 in 802.11a mode, while the 
> default ACK timeout for 802.11a used in ath5k initialisation is 25. And in 
> 802.11b the aPHY-RX-START-Delay alone is defined as 192 µs, while the default 
> used by ath5k is 48.
> 
> I looked into the current Madwifi sources again, and found they use only
> aSIFSTime + aSlotTime as ACK timeout. That's 25 for 11a, 30 for 11b and 19 for 
> 11g, so it's in line with my experimental observations and also the 11a ath5k 
> default. Probably the hardware accounts for aPHY-RX-START-Delay itself (it's 
> PHY value, while ACK timeout is MAC chip register).
Yes, the current formula in Madwifi looks correct. We should use that.

- Felix
