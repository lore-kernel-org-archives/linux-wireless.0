Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48635 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3IMRV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 13:21:57 -0400
Message-ID: <523349B1.8010306@candelatech.com> (sfid-20130913_192203_945554_623FB6BF)
Date: Fri, 13 Sep 2013 10:21:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Albert Lo <alo@airpatrolcorp.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: problems setting the channel
References: <bd4dc3b2edbb45789121bddb33960aa2@CO1PR05MB345.namprd05.prod.outlook.com>
In-Reply-To: <bd4dc3b2edbb45789121bddb33960aa2@CO1PR05MB345.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2013 10:11 AM, Albert Lo wrote:
>
> Hello,
>
> Forgive the newbie question, but I'm having a hard time setting the channel.  Here is my output:
>
> ======================================
> root@OpenWrt:~# iw dev wlan0 info
> Interface wlan0
>      ifindex 7
>      wdev 0x2
>      addr 04:f0:21:01:1b:91
>      type AP
>      wiphy 0
>      channel 11 (2462 MHz) NO HT
> root@OpenWrt:~# iw reg get
> country US:
>      (2402 - 2472 @ 40), (3, 27)
>      (5170 - 5250 @ 40), (3, 17)
>      (5250 - 5330 @ 40), (3, 20), DFS
>      (5490 - 5600 @ 40), (3, 20), DFS
>      (5650 - 5710 @ 40), (3, 20), DFS
>      (5735 - 5835 @ 40), (3, 30)
> root@OpenWrt:/# iw dev wlan0 set channel 10
> root@OpenWrt:/# iw dev wlan0 set channel 19
> command failed: Invalid argument (-22)
> ==================================================
>
>
> Any ideas why setting channel to 10 is ok, but setting channel to 19 fails?
> I do notice that my phy is split into two parts, Band1 and Band2.

There is no channel 19.  Band2 starts at channel 36.

> 		Frequencies:
> 			* 5180 MHz [36] (17.0 dBm)
> 			* 5200 MHz [40] (17.0 dBm)
> 			* 5220 MHz [44] (17.0 dBm)
> 			* 5240 MHz [48] (17.0 dBm)
> 			* 5260 MHz [52] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5280 MHz [56] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5300 MHz [60] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5320 MHz [64] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5500 MHz [100] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5520 MHz [104] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5540 MHz [108] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5560 MHz [112] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5580 MHz [116] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5600 MHz [120] (disabled)
> 			* 5620 MHz [124] (disabled)
> 			* 5640 MHz [128] (disabled)
> 			* 5660 MHz [132] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5680 MHz [136] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5700 MHz [140] (20.0 dBm) (passive scanning, no IBSS, radar detection)
> 			* 5745 MHz [149] (30.0 dBm)
> 			* 5765 MHz [153] (30.0 dBm)
> 			* 5785 MHz [157] (30.0 dBm)
> 			* 5805 MHz [161] (30.0 dBm)
> 			* 5825 MHz [165] (30.0 dBm)


For normal use, you usually don't need to specify the channel anyway, by the way.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

