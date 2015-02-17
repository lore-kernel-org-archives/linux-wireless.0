Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64804 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbBQQnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 11:43:33 -0500
Received: by mail-ob0-f171.google.com with SMTP id gq1so55169100obb.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 08:43:32 -0800 (PST)
Message-ID: <54E36FB2.1050000@lwfinger.net> (sfid-20150217_174336_782728_571E70F9)
Date: Tue, 17 Feb 2015 10:43:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alan Fisher <acf@unixcube.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: PROBLEM: rtlwifi drops most IPv6 packets
References: <54E19DD6.9050704@unixcube.org> <54E23664.70509@lwfinger.net> <54E2FBCD.7070707@unixcube.org>
In-Reply-To: <54E2FBCD.7070707@unixcube.org>
Content-Type: multipart/mixed;
 boundary="------------050101060109010609050703"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050101060109010609050703
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/17/2015 02:29 AM, Alan Fisher wrote:
> Larry,
>
>> I am guessing that you have an RTL8188CE, which uses rtl8192ce.
>
> Yep, my wireless card is an RTL8188CE
>
>> The purpose of rtl_is_special_data() is to ensure that management packets have
>> the highest probability of being successfully transmitted by sending them at a
>> low rate.
> ...
>> It also occurs to me that mac80211 probably handles this function, and that it
>> may be possible to remove this routine, which is essentially what your
>> workaround does.
> I couldn't find any information on mac80211 treating certain packets (ARP, DHCP,
> etc...) as special. It does seem to handle automatic rate selection, though. I
> would think that would be enough to handle packet loss reasonably well. I
> believe the protocols tested for here all have mechanisms for handling lost
> packets. I also can't find any other 802.11 drivers which try to handle DHCP
> packets in a special way. I think it would be safe to remove this routine. I
> have a patch to do that, if you're okay with that change.

The story is a bit more complicated. These drivers use firmware rate selection, 
not the ones in mac80211. At this point, I would not be comfortable with 
removing the entire routine.
>
> Regarding the patch, this change:
>
> -    } else if (0x86DD == ether_type) {
> -        return true;
>       }
>
> successfully prevents IPv6 packets from being treated as special (and thus
> dropped).
>
> However, this:
> +    if (ETH_P_IP == ether_type || ETH_P_IPV6 == ether_type) {
>           ip = (struct iphdr *)((u8 *)skb->data + offset +
>
> seems to be reading an IPv4 header (struct iphdr) from an IPv6 packet. I believe
> a struct ipv6hdr should be used here.

You are correct. My patch was prepared too hastily.

> If we are to continue handling certain types of packets differently, IPv6
> neighbor solicitation messages (like ARP in IPv4) and IPv6 router discovery
> messages (stateless IPv6 autoconfig, similar to DHCP in IPv4 networks) should
> probably be added to the list to maintain consistency with what is being handled
> for IPv4. These are both variants of ICMPv6 packets, although generally
> transmitting all ICMPv6 packets at the lowest rate is probably a bad idea, as
> ICMP echo is commonly used to measure network performance and should be treated
> the same as normal traffic.

For the moment, I think we need to return false, not true, for all IPv6 packets 
until a more complete solution is found. Does the attached patch fix the problem 
you are seeing? I do not have an IPv6 compliant ISP, thus I cannot do much testing.

Larry



--------------050101060109010609050703
Content-Type: text/plain; charset=UTF-8;
 name="modify_is_special_data"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="modify_is_special_data"

SW5kZXg6IHdpcmVsZXNzLWRyaXZlcnMtbmV4dC9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL2Jhc2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB3aXJlbGVzcy1kcml2ZXJzLW5leHQub3Jp
Zy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYworKysgd2lyZWxlc3MtZHJp
dmVycy1uZXh0L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFzZS5jCkBAIC0xMzg2
LDggKzEzODYsMTEgQEAgdTggcnRsX2lzX3NwZWNpYWxfZGF0YShzdHJ1Y3QgaWVlZTgwMjEx
XwogCQl9CiAKIAkJcmV0dXJuIHRydWU7Ci0JfSBlbHNlIGlmICgweDg2REQgPT0gZXRoZXJf
dHlwZSkgewotCQlyZXR1cm4gdHJ1ZTsKKwl9IGVsc2UgaWYgKEVUSF9QX0lQVjYgPT0gZXRo
ZXJfdHlwZSkgeworCQkvKiBUT0RPOiBIYW5kbGUgYW55IElQdjYgY2FzZXMgdGhhdCBuZWVk
IHNwZWNpYWwgaGFuZGxpbmcuCisJCSAqIEZvciBub3csIGFsd2F5cyByZXR1cm4gZmFsc2UK
KwkJICovCisJCWdvdG8gZW5kOwogCX0KIAogZW5kOgo=
--------------050101060109010609050703--
