Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63036 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DERmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:42:17 -0400
Received: by qwk3 with SMTP id 3so379539qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 10:42:16 -0700 (PDT)
Message-ID: <4D9B5473.6040003@lwfinger.net>
Date: Tue, 05 Apr 2011 12:42:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gottfried Haider <gottfried.haider@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce: odd ping behavior
References: <BANLkTimnXJGy07-8gt=O7ruH-Hyt=NqtuQ@mail.gmail.com>
In-Reply-To: <BANLkTimnXJGy07-8gt=O7ruH-Hyt=NqtuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2011 09:33 AM, Gottfried Haider wrote:
> Dear linux-wireless,
>
> I am running 2.6.39-rc1 on a Lenovo Thinkpad x120e, which has a
> Realtek b/g/n wireless adapter (PCI ID 10ec:8176).
>
>> From what I see through network-manager, the connection to my
> (802.11g-type) access point/router is very stable, but I noticed that
> browsing the web is a lot less smooth compared to my previous machine
> with a b43 adapter (especially resolving hostnames and/or the initial
> connection seems to take ages or entirely fails).
>
> I know that the rtl8192ce driver is pretty new, but I thought that I'd
> point this out:
>
> When I am cloning a kernel git tree, the round-trip time I get for
> pinging my router periodically goes up to 12 seconds, before briefly
> jumping down to about 1.5 seconds and rising again:
>
> 64 bytes from 192.168.1.1: icmp_req=199 ttl=64 time=921 ms
> 64 bytes from 192.168.1.1: icmp_req=200 ttl=64 time=651 ms
> 64 bytes from 192.168.1.1: icmp_req=201 ttl=64 time=936 ms
> 64 bytes from 192.168.1.1: icmp_req=202 ttl=64 time=862 ms
> 64 bytes from 192.168.1.1: icmp_req=203 ttl=64 time=833 ms
> 64 bytes from 192.168.1.1: icmp_req=204 ttl=64 time=945 ms
> 64 bytes from 192.168.1.1: icmp_req=205 ttl=64 time=1003 ms
> 64 bytes from 192.168.1.1: icmp_req=206 ttl=64 time=1058 ms
> 64 bytes from 192.168.1.1: icmp_req=207 ttl=64 time=955 ms
> 64 bytes from 192.168.1.1: icmp_req=208 ttl=64 time=1080 ms
> 64 bytes from 192.168.1.1: icmp_req=209 ttl=64 time=1422 ms
> 64 bytes from 192.168.1.1: icmp_req=210 ttl=64 time=1428 ms
> 64 bytes from 192.168.1.1: icmp_req=211 ttl=64 time=1797 ms
> 64 bytes from 192.168.1.1: icmp_req=212 ttl=64 time=2060 ms
> 64 bytes from 192.168.1.1: icmp_req=213 ttl=64 time=2303 ms
> 64 bytes from 192.168.1.1: icmp_req=214 ttl=64 time=2608 ms
> 64 bytes from 192.168.1.1: icmp_req=215 ttl=64 time=2865 ms
> 64 bytes from 192.168.1.1: icmp_req=216 ttl=64 time=3041 ms
> 64 bytes from 192.168.1.1: icmp_req=217 ttl=64 time=3508 ms
> 64 bytes from 192.168.1.1: icmp_req=218 ttl=64 time=3355 ms
> 64 bytes from 192.168.1.1: icmp_req=219 ttl=64 time=3780 ms
> 64 bytes from 192.168.1.1: icmp_req=220 ttl=64 time=3914 ms
> 64 bytes from 192.168.1.1: icmp_req=221 ttl=64 time=4270 ms
> 64 bytes from 192.168.1.1: icmp_req=222 ttl=64 time=4446 ms
> 64 bytes from 192.168.1.1: icmp_req=223 ttl=64 time=4911 ms
> 64 bytes from 192.168.1.1: icmp_req=224 ttl=64 time=5020 ms
> 64 bytes from 192.168.1.1: icmp_req=225 ttl=64 time=5396 ms
> 64 bytes from 192.168.1.1: icmp_req=226 ttl=64 time=5485 ms
> 64 bytes from 192.168.1.1: icmp_req=227 ttl=64 time=5937 ms
> 64 bytes from 192.168.1.1: icmp_req=228 ttl=64 time=6125 ms
> 64 bytes from 192.168.1.1: icmp_req=229 ttl=64 time=6486 ms
> 64 bytes from 192.168.1.1: icmp_req=230 ttl=64 time=6656 ms
> 64 bytes from 192.168.1.1: icmp_req=231 ttl=64 time=6893 ms
> 64 bytes from 192.168.1.1: icmp_req=232 ttl=64 time=7182 ms
> 64 bytes from 192.168.1.1: icmp_req=233 ttl=64 time=7366 ms
> 64 bytes from 192.168.1.1: icmp_req=234 ttl=64 time=7623 ms
> 64 bytes from 192.168.1.1: icmp_req=235 ttl=64 time=7922 ms
> 64 bytes from 192.168.1.1: icmp_req=236 ttl=64 time=8183 ms
> 64 bytes from 192.168.1.1: icmp_req=237 ttl=64 time=8445 ms
> 64 bytes from 192.168.1.1: icmp_req=238 ttl=64 time=8667 ms
> 64 bytes from 192.168.1.1: icmp_req=239 ttl=64 time=8980 ms
> 64 bytes from 192.168.1.1: icmp_req=240 ttl=64 time=8828 ms
> 64 bytes from 192.168.1.1: icmp_req=241 ttl=64 time=9171 ms
> 64 bytes from 192.168.1.1: icmp_req=242 ttl=64 time=9605 ms
> 64 bytes from 192.168.1.1: icmp_req=243 ttl=64 time=9736 ms
> 64 bytes from 192.168.1.1: icmp_req=244 ttl=64 time=10118 ms
> 64 bytes from 192.168.1.1: icmp_req=245 ttl=64 time=10385 ms
> 64 bytes from 192.168.1.1: icmp_req=246 ttl=64 time=10645 ms
> 64 bytes from 192.168.1.1: icmp_req=248 ttl=64 time=10781 ms
> 64 bytes from 192.168.1.1: icmp_req=249 ttl=64 time=11015 ms
> 64 bytes from 192.168.1.1: icmp_req=250 ttl=64 time=11145 ms
> 64 bytes from 192.168.1.1: icmp_req=252 ttl=64 time=11218 ms
> 64 bytes from 192.168.1.1: icmp_req=253 ttl=64 time=11057 ms
> 64 bytes from 192.168.1.1: icmp_req=254 ttl=64 time=11325 ms
> 64 bytes from 192.168.1.1: icmp_req=255 ttl=64 time=11264 ms
> 64 bytes from 192.168.1.1: icmp_req=256 ttl=64 time=11529 ms
> 64 bytes from 192.168.1.1: icmp_req=257 ttl=64 time=10604 ms
> 64 bytes from 192.168.1.1: icmp_req=258 ttl=64 time=9979 ms
> 64 bytes from 192.168.1.1: icmp_req=259 ttl=64 time=9181 ms
> 64 bytes from 192.168.1.1: icmp_req=260 ttl=64 time=8472 ms
> 64 bytes from 192.168.1.1: icmp_req=261 ttl=64 time=7551 ms
> 64 bytes from 192.168.1.1: icmp_req=262 ttl=64 time=6634 ms
> 64 bytes from 192.168.1.1: icmp_req=263 ttl=64 time=5651 ms
> 64 bytes from 192.168.1.1: icmp_req=264 ttl=64 time=4659 ms
> 64 bytes from 192.168.1.1: icmp_req=265 ttl=64 time=3665 ms
> 64 bytes from 192.168.1.1: icmp_req=267 ttl=64 time=1673 ms
> 64 bytes from 192.168.1.1: icmp_req=268 ttl=64 time=918 ms
> 64 bytes from 192.168.1.1: icmp_req=269 ttl=64 time=969 ms
>
> This is while cloning a git tree with about 135 KiB/s and no other
> network activity. This does not appear to be showing up when I am
> cloning with a higher throughput from git.kernel.org (say: 700 KiB/s)
> - so I don't know whether the effect is caused by the slow speed
> coming from occasional round-robin "outliers" or both the decreased
> throughput and the increase in round-trip time are the result of
> something else.
>
>
> Maybe unreleated: When I enable a bit of debugging I see quite often
> deauthentication/reauthentication messages - sometime as often as
> every 25 seconds, and always with reason 7.
>
> Apart from that there is nothing in dmesg that stands out. If there is
> anything I could help with in getting this device working, please let
> me know.

I repeated your test. My ping results were much better than yours:

1383 packets transmitted, 1367 received, 1% packet loss, time 1384611ms
rtt min/avg/max/mdev = 1.317/3.732/384.371/10.962 ms

I do not see the deauthentication/authentication results that you see. Those 
would definitely cause network delays.

There are one difference in our systems. I have a 10ec:8178 device, but I have 
an 8176 here that I will try now. I have also received a new version of the 
driver from Realtek. If my 8176 has the same problems as yours, perhaps that 
will help.

Larry
