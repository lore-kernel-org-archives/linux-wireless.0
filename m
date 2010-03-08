Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:49457 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0CHFlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 00:41:45 -0500
Received: by pzk32 with SMTP id 32so2465401pzk.4
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 21:41:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <70f6a1ed1003072120w37fa176ya2c3a8af742dfd97@mail.gmail.com>
References: <4B93F42F.7030306@openwrt.org>
	 <70f6a1ed1003072120w37fa176ya2c3a8af742dfd97@mail.gmail.com>
Date: Sun, 7 Mar 2010 21:36:27 -0800
Message-ID: <70f6a1ed1003072136r6f78a969k8847736e210ba7f7@mail.gmail.com>
Subject: Re: [RFC v3] minstrel_ht: new rate control module for 802.11n
From: Duy Nguyen <dnlove@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	=?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After many more runs on scenario 2, it is on par with atheros default.
 Sorry for the earlier hasty reporting.

scenario 2: node 1 to node 2

802.11n Felix's Minstrel    Avg Transfer= 95.5  Avg Bandwidth=80.11
802.11n Atheros Default    Avg Transfer= 95.2  Avg Bandwidth=79.8

On Sun, Mar 7, 2010 at 9:20 PM, Duy Nguyen <dnlove@gmail.com> wrote:
> Hi Felix, thanks for the awesome patch and great progress on the
> 802.11n!  I just tried out your patch version 3, and got the following
> results.
>
> The results are an average of 10 different iperf runs, Throughputs are
> in Mbits/sec
> AP: dir-615 (settings: 802.11n mode only, Auto 20/40 Mhz).  This AP
> does not seem to allow me to set 40Mhz only
> Node interfaces:  D-Link DWA-556 Xtreme N PC
>
>
> scenario 1: node 1 to node 2
>
> node1-----wireless_link-----AP-----wireless_link-----node2
>
> 802.11n Felix's Minstrel    Avg Transfer= 38.6  Avg Bandwidth=32.3
> 802.11n Atheros Default    Avg Transfer= 36.6  Avg Bandwidth=30.6
>
> scenario 2: node 1 to node 2
>
> node1-----wireless_link-----AP-----wired_link-----node2
>
> 802.11n Felix's Minstrel    Avg Transfer= 83.4  Avg Bandwidth=69.8
> 802.11n Atheros Default    Avg Transfer= 95.2  Avg Bandwidth=79.8
>
> Overall, the results look pretty good.  I am much more interested in
> results in scenario 1 but I am going to take a look at scenario 2
> again.  Let me know if I can help you test any other scenarios.
>
> Duy
>
>
> On Sun, Mar 7, 2010 at 10:45 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Here's v3 of minstrel_ht.
>>
>> Changelog:
>>
>> v3:
>> - Add two fixes by Christian Lamparter (division by zero, debugfs mcs
>>  rate display)
>> - Improve throughput a bit more by spreading out slow rate sampling
>>  attempts over multiple sampling intervals
>>
>> v2:
>> - Use accurate A-MPDU statistics from tx feedback
>> - Rewrite the sampling algorithm to optimize for good A-MPDU lengths
>>  and faster throughput recovery
>> - Implement .rate_update to handle changes in HT capabilities or
>>  channel bandwidth
>> - Remove the private tx flags hack
>
