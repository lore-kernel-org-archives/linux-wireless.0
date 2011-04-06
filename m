Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp30.kymp.net ([80.248.96.181]:1834 "EHLO smtp.kymp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab1DFPgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 11:36:23 -0400
Message-ID: <4D9C8826.6070302@saunalahti.fi>
Date: Wed, 06 Apr 2011 18:35:02 +0300
From: Kimmo Huoso <kimmo.huoso@saunalahti.fi>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB Adapter(rev.A)
 [Atheros AR9001U-(2)NG] Invalid misc and Tx excessive retries
References: <4D9B077E.3090106@saunalahti.fi> <201104061438.43678.chunkeey@googlemail.com> <4D9C764E.2040107@saunalahti.fi> <201104061716.43553.chunkeey@googlemail.com>
In-Reply-To: <201104061716.43553.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yep. Thats the reason im in concern, and for a note i did disable the ht 
by adding this noht=1 to module and problem seems to still persist. My 
router is running currently openrwrt Backfire (10.03.1-rc4, r24045) 
which is in dir-825 hardware. There are no problems with router that i 
have noticed. So only solution for me for now is to wait that someone 
adds better code for QoS. Right? At the moment im sticking with 
lts-kernel and ar9170usb.

06.04.2011 18:16, Christian Lamparter kirjoitti:
> On Wednesday 06 April 2011 16:18:54 Kimmo Huoso wrote:
>> And for third even the softmac numbers/statistics might be
>> bogus, im still having problems with the driver while trying to run
>> programs that are strict for smooth connection like online games.
> ah, that's why you are so concerned about excessive tx retries&  invalid
> misc numbers. Well, one of the worst enemy of programs that rely on low latency,
> time-critical connection is "bufferbloat". However, by design 11n aggregation
> needs to do a fair amount of additional caching&  reordering so it's not
> really suited for rt data anyway... Given that you have already ruled out your
> router/AP and your environment, etc.. as a culprit, the good news is that
> someone has already thought about this [QoS + the fact that aggregation is
> not enabled for AC_VO]. The bad news is that ar9170's QoS [note: I'm talking
> about the device and not the driver] does not work every well unless 11n is
> completely disabled [module parameter noht=1 does that].
>
> Regards,
> 	Chr
>

