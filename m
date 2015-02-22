Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from unixcube.org ([174.136.111.132]:42298 "EHLO unixcube.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbBVWtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 17:49:20 -0500
Message-ID: <54EA5CED.2040201@unixcube.org> (sfid-20150222_234925_407059_604B761F)
Date: Sun, 22 Feb 2015 14:49:17 -0800
From: Alan Fisher <acf@unixcube.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: PROBLEM: rtlwifi drops most IPv6 packets
References: <54E19DD6.9050704@unixcube.org> <54E23664.70509@lwfinger.net> <54E2FBCD.7070707@unixcube.org> <54E36FB2.1050000@lwfinger.net>
In-Reply-To: <54E36FB2.1050000@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/17/2015 08:43 AM, Larry Finger wrote:
> On 02/17/2015 02:29 AM, Alan Fisher wrote:
>> Larry,
>>
>>> I am guessing that you have an RTL8188CE, which uses rtl8192ce.
>>
>> Yep, my wireless card is an RTL8188CE
>>
>>> The purpose of rtl_is_special_data() is to ensure that management 
>>> packets have
>>> the highest probability of being successfully transmitted by sending 
>>> them at a
>>> low rate.
>> ...
>>> It also occurs to me that mac80211 probably handles this function, 
>>> and that it
>>> may be possible to remove this routine, which is essentially what your
>>> workaround does.
>> I couldn't find any information on mac80211 treating certain packets 
>> (ARP, DHCP,
>> etc...) as special. It does seem to handle automatic rate selection, 
>> though. I
>> would think that would be enough to handle packet loss reasonably 
>> well. I
>> believe the protocols tested for here all have mechanisms for 
>> handling lost
>> packets. I also can't find any other 802.11 drivers which try to 
>> handle DHCP
>> packets in a special way. I think it would be safe to remove this 
>> routine. I
>> have a patch to do that, if you're okay with that change.
>
> The story is a bit more complicated. These drivers use firmware rate 
> selection, not the ones in mac80211. At this point, I would not be 
> comfortable with removing the entire routine.
Ok, makes sense.

>> Regarding the patch, this change:
>>
>> -    } else if (0x86DD == ether_type) {
>> -        return true;
>>       }
>>
>> successfully prevents IPv6 packets from being treated as special (and 
>> thus
>> dropped).
>>
>> However, this:
>> +    if (ETH_P_IP == ether_type || ETH_P_IPV6 == ether_type) {
>>           ip = (struct iphdr *)((u8 *)skb->data + offset +
>>
>> seems to be reading an IPv4 header (struct iphdr) from an IPv6 
>> packet. I believe
>> a struct ipv6hdr should be used here.
>
> You are correct. My patch was prepared too hastily.
>
>> If we are to continue handling certain types of packets differently, 
>> IPv6
>> neighbor solicitation messages (like ARP in IPv4) and IPv6 router 
>> discovery
>> messages (stateless IPv6 autoconfig, similar to DHCP in IPv4 
>> networks) should
>> probably be added to the list to maintain consistency with what is 
>> being handled
>> for IPv4. These are both variants of ICMPv6 packets, although generally
>> transmitting all ICMPv6 packets at the lowest rate is probably a bad 
>> idea, as
>> ICMP echo is commonly used to measure network performance and should 
>> be treated
>> the same as normal traffic.
>
> For the moment, I think we need to return false, not true, for all 
> IPv6 packets until a more complete solution is found. Does the 
> attached patch fix the problem you are seeing? I do not have an IPv6 
> compliant ISP, thus I cannot do much testing.
Yes, IPv6 appears to work normally with that patch applied. I recently 
spoke with someone who uses RTL8188 under Linux 3.18, and doesn't see 
any packet loss with special packets. I would guess this is because he 
has a slightly different hardware configuration (different processor, 
etc..).

>
> Larry
>

Thanks,
Alan
