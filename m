Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from unixcube.org ([174.136.111.132]:40783 "EHLO unixcube.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbbBQI3G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 03:29:06 -0500
Message-ID: <54E2FBCD.7070707@unixcube.org> (sfid-20150217_092913_224982_E8F6173F)
Date: Tue, 17 Feb 2015 00:29:01 -0800
From: Alan Fisher <acf@unixcube.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: PROBLEM: rtlwifi drops most IPv6 packets
References: <54E19DD6.9050704@unixcube.org> <54E23664.70509@lwfinger.net>
In-Reply-To: <54E23664.70509@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

> I am guessing that you have an RTL8188CE, which uses rtl8192ce.

Yep, my wireless card is an RTL8188CE

> The purpose of rtl_is_special_data() is to ensure that management packets have the highest probability of being successfully transmitted by sending them at a low rate.
...
> It also occurs to me that mac80211 probably handles this function, and that it may be possible to remove this routine, which is essentially what your workaround does.
I couldn't find any information on mac80211 treating certain packets (ARP, DHCP, etc...) as special. It does seem to handle automatic rate selection, though. I would think that would be enough to handle packet loss reasonably well. I believe the protocols tested for here all have mechanisms for handling lost packets. I also can't find any other 802.11 drivers which try to handle DHCP packets in a special way. I think it would be safe to remove this routine. I have a patch to do that, if you're okay with that change.

Regarding the patch, this change:

-	} else if (0x86DD == ether_type) {
-		return true;
  	}

successfully prevents IPv6 packets from being treated as special (and thus dropped).

However, this:
+	if (ETH_P_IP == ether_type || ETH_P_IPV6 == ether_type) {
  		ip = (struct iphdr *)((u8 *)skb->data + offset +

seems to be reading an IPv4 header (struct iphdr) from an IPv6 packet. I believe a struct ipv6hdr should be used here.

If we are to continue handling certain types of packets differently, IPv6 neighbor solicitation messages (like ARP in IPv4) and IPv6 router discovery messages (stateless IPv6 autoconfig, similar to DHCP in IPv4 networks) should probably be added to the list to maintain consistency with what is being handled for IPv4. These are both variants of ICMPv6 packets, although generally transmitting all ICMPv6 packets at the lowest rate is probably a bad idea, as ICMP echo is commonly used to measure network performance and should be treated the same as normal traffic.

Thanks,
Alan

On 02/16/2015 10:26 AM, Larry Finger wrote:
> On 02/16/2015 01:35 AM, Alan Fisher wrote:
>
> Alan,
>
> I looked at the routine, and it is returning true for all IPv6 packets.
>
> Does the attached patch for 3.18 or 3.19 help?
>
> Larry
>

