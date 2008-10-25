Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail13.tpgi.com.au ([203.12.160.181]:33246 "EHLO
	mail13.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYJYPN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 11:13:26 -0400
Message-ID: <49033782.5040701@hotmail.com> (sfid-20081025_171336_384024_14B1CEEF)
Date: Sun, 26 Oct 2008 02:13:06 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com> <20081025112147.GA12252@Chamillionaire.breakpoint.cc> <200810251325.07916.mb@bu3sch.de> <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
In-Reply-To: <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sebastian,

Sebastian Andrzej Siewior wrote:
> * Michael Buesch | 2008-10-25 13:25:07 [+0200]:
> 
>> On Saturday 25 October 2008 13:21:47 Sebastian Andrzej Siewior wrote:
>>> -	fc = *(__le16 *)buffer;
>>> +	fc = get_unaligned_le32(buffer);
>> I'd say this semantically changes the code.
> argh,
> sorry,
> 
> Subject: [PATCH] wireless/zd1211rw: use  get_unaligned_le16 helper (v2)
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

After applying this patch, things seem better. I can associate to an 
open access point, get an IP address and even ping.

However on association, I am still seeing:


[  179.249516] zd1211rw 4-3:1.0: zd_usb_rfwrite() value 0x01e6666 bits 24
[  179.254524] wlan0: Initial auth_alg=0
[  179.254549] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
[  179.256215] Kernel unaligned access at TPC[10129b94] 
zd_mac_rx+0x174/0x320 [zd1211rw]
[  179.349135] Kernel unaligned access at TPC[10129b9c] 
zd_mac_rx+0x17c/0x320 [zd1211rw]
[  179.442852] Kernel unaligned access at TPC[10129ba0] 
zd_mac_rx+0x180/0x320 [zd1211rw]
[  179.536579] Kernel unaligned access at TPC[10129ba4] 
zd_mac_rx+0x184/0x320 [zd1211rw]
[  179.630306] Kernel unaligned access at TPC[10129ba8] 
zd_mac_rx+0x188/0x320 [zd1211rw]
[  179.727277] wlan0: RX authentication from XX:XX:XX:XX:XX:XX (alg=0 
transaction=2 status=0)
[  179.727302] wlan0: authenticated
[  179.727318] wlan0: associate with AP XX:XX:XX:XX:XX:XX
[  179.727440] wlan0: associate with AP XX:XX:XX:XX:XX:XX
[  179.736350] wlan0: RX AssocResp from XX:XX:XX:XX:XX:XX (capab=0x421 
status=0 aid=12)
[  179.736380] wlan0: associated
[  179.736421] wlan0: CTS protection enabled (BSSID=XX:XX:XX:XX:XX:XX)
[  179.736440] wlan0: switched to short barker preamble 
(BSSID=XX:XX:XX:XX:XX:XX)
[  179.736521] zd1211rw 4-3:1.0: zd_op_bss_info_changed() changes: 7
[  179.736666] wlan0: association frame received from XX:XX:XX:XX:XX:XX, 
but not in associate state - ignored
[  179.737404] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  179.807280] zd1211rw 4-3:1.0: zd_chip_set_rts_cts_rate_locked() 
preamble=1

and when I start pinging the AP, this starts chiming in:

[  240.139093] Kernel unaligned access at TPC[100f7f44] 
sta_info_get+0x24/0x68 [mac80211]
[  240.233255] Kernel unaligned access at TPC[100f7f48] 
sta_info_get+0x28/0x68 [mac80211]
[  240.328015] Kernel unaligned access at TPC[100f7f50] 
sta_info_get+0x30/0x68 [mac80211]
[  240.422771] Kernel unaligned access at TPC[100f7f44] 
sta_info_get+0x24/0x68 [mac80211]
[  240.517554] Kernel unaligned access at TPC[100f7f48] 
sta_info_get+0x28/0x68 [mac80211]

I also cannot get a full scan with:

iwlist wlan0 scanning

I get about 4 APs (I know there's more) then a bus error. This may be 
related to a similar problem that I was assisted with in my first round 
of posts last year, with regards to the wireless-tools. Perhaps the 
patches still haven't made it downstream?

Thanking you for help,
Shaddy

