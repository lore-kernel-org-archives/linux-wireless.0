Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45864 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZJZEJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 00:09:24 -0400
Message-ID: <4AE520F1.2070704@openwrt.org>
Date: Mon, 26 Oct 2009 05:09:21 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Rate-setting problem with Broadcom 4315
References: <4AE49F0F.1060901@lwfinger.net>
In-Reply-To: <4AE49F0F.1060901@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> When my BCM4312 (ID 4315) runs in auto rate mode, the rate stays at
> 1Mb/s. If I manually set the rate, I see a tcpperf throughput ~1/2 the
> rate that I set through a rate of 12 Mb/s. At 36 Mb/s, the rate is
> best at 15.7 Mb/s. Why does mistrel not increase the rate?
> 
> The output of /sys/..../rc_stats is:
> 
> finger@larrylap:~> cat
> /sys/kernel/debug/ieee80211/phy0/stations/00:14:bf:85:49:fa/rc_stats
> rate     throughput  ewma prob   this prob  this succ/attempt
> success    attempts
>      1         0.9       99.1      100.0          0(  0)       3244
>      3282
>      2         1.8       95.7      100.0          0(  0)         12
>        12
>      5.5       4.8       95.7      100.0          0(  0)         12
>        12
>     11         9.2       96.8      100.0          0(  0)         12
>        12
>   P  6         5.6       99.9      100.0          0(  0)         58
>        58
>      9         8.0       95.7      100.0          0(  0)         11
>        11
>     12        10.6       95.7      100.0          0(  0)         12
>        12
>     18        15.7       96.6      100.0          0(  0)         14
>        15
>     24        20.3       95.7      100.0          0(  0)         11
>        11
>     36        29.0       95.4       94.5          0(  0)       1602
>      1670
> T   48        38.7       99.2      100.0          1(  1)      32147
>     37752
>  t  54        32.9       75.9      100.0          0(  0)       8775
>     12788
> 
> Total packet count::    ideal 2570      lookaround 135
Was this dump made after you played with manual rate settings? If so,
please make a new one that only contains stats of what it tried with
automatic rate setting enabled.

- Felix
