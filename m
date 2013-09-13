Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:4092
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3IMR3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 13:29:38 -0400
From: Albert Lo <alo@airpatrolcorp.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: problems setting the channel
Date: Fri, 13 Sep 2013 17:29:32 +0000
Message-ID: <acb122e1d82d410f87d38b5216fb0e64@CO1PR05MB345.namprd05.prod.outlook.com> (sfid-20130913_192947_854891_3A80C76E)
References: <bd4dc3b2edbb45789121bddb33960aa2@CO1PR05MB345.namprd05.prod.outlook.com>,<523349F2.2000702@lwfinger.net>
In-Reply-To: <523349F2.2000702@lwfinger.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Thanks for the info. I tried setting the channel to one that is listed in the link you provided, and even to one that is listed in phy info.  ch=36 is nice and safe.
however when I type:
> iw dev wlan0 info

It is still reporting it's on the old channel (11).
Any ideas why it is reporting the old channel?


Thx.
Cheers,
Albert
________________________________________
From: Larry Finger <larry.finger@gmail.com> on behalf of Larry Finger <Larry.Finger@lwfinger.net>
Sent: Friday, September 13, 2013 10:22 AM
To: Albert Lo
Cc: linux-wireless@vger.kernel.org
Subject: Re: problems setting the channel

On 09/13/2013 12:11 PM, Albert Lo wrote:
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

--snip--

> Any ideas as to how I can set wlan0 to the channels in  Band2?

There is no channel 19 in wifi! That is the reason you cannot select it.

To select Band 2, you would need a dual-band Access Point. Do you have one?

Clearly, you have little knowledge of wifi. I suggest you read
http://en.wikipedia.org/wiki/List_of_WLAN_channels.

Larry

