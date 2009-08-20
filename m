Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33662 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZHTUpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 16:45:43 -0400
Message-ID: <4A8DB5F4.8060809@openwrt.org>
Date: Thu, 20 Aug 2009 22:45:40 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Minstrel's definition of best throughput
References: <4A8D5A48.5070809@nets.rwth-aachen.de>
In-Reply-To: <4A8D5A48.5070809@nets.rwth-aachen.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Hannemann wrote:
> Hi,
> 
> while watching the rc_stats of minstrel, I noticed
> that minstrel does not choose the rate with best throughput.
> For example, I often see something like this:
> 
> rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
>      1         0.8       89.1      100.0          0(  0)       1490        2257
>      2         1.8       95.3      100.0          0(  0)         13          15
>      5.5       4.8       95.5      100.0          0(  0)         17          22
>   P 11         9.4       98.5      100.0          0(  0)       1532        2195
>      6         5.4       95.6      100.0          0(  0)         28          88
>      9         8.1       96.2      100.0          0(  0)        143         431
>     12         8.7       78.8      100.0          0(  0)        209         814
>     18        12.3       75.8      100.0          0(  0)        302        2416
>     24        18.3       86.2      100.0          0(  0)       5765        9196
>     36         2.6       85.2      100.0          0(  0)     736813      886517
> T   48        14.7       97.4      100.0          2(  2)    3433862     4411674
>  t  54         8.5       73.3      100.0          0(  0)    1488241     2180261
> 
> 
> Why did minstrel chose the 48M rate, and not 24M for the best throughput rate?
The table looks weird. Maybe there's a race between the update of the
table and the display through debugfs. Either way, 48M is definitely the
best throughput rate based on the ewma prob, but the calculated
throughput value looks a bit off.

> Also "this prob" seems fishy to me, its always 100...
"this prob" refers to the current interval, not the value after EWMA, so
it's always calculated from this succ/attempt and 100.0 makes sense here.

> Another thing: I noticed that the througput field in minstrel_rate is never used?
> Should I send a patch, removing it? Or does anyone remember why it was there
> in the first place?
I think you can remove it. I think initially I planned on calculating
both the EWMA throughput and the one from the measurement interval, but
didn't do that, because it's not displayed anywhere and would serve no
other purpose.

- Felix
