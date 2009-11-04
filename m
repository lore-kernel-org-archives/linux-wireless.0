Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:18793 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826AbZKDVxv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 16:53:51 -0500
Message-ID: <4AF1F7F2.1020806@irobot.com>
Date: Wed, 04 Nov 2009 13:53:54 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com> 	<alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz> 	<200911042242.48991.chunkeey@googlemail.com> <4AF1F653.4000905@irobot.com> <43e72e890911041350i75108dc3g454ab8577d8abacd@mail.gmail.com>
In-Reply-To: <43e72e890911041350i75108dc3g454ab8577d8abacd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My guess from this is that I'm using the single stage:

# dmesg | grep ar9170
[  273.608189] usb 2-1: firmware: requesting ar9170.fw
[  274.019650] Registered led device: ar9170-phy1::tx
[  274.019698] Registered led device: ar9170-phy1::assoc
[  274.019751] usbcore: registered new interface driver ar9170usb


Luis R. Rodriguez wrote:
> On Wed, Nov 4, 2009 at 1:46 PM, Adam Wozniak <awozniak@irobot.com> wrote:
>   
>> $ ls -la /lib/firmware/ar9170*
>> -rw-r--r-- 1 root root 83968 2009-10-17 15:55 /lib/firmware/ar9170-1.fw
>> -rw-r--r-- 1 root root  3508 2009-10-17 15:55 /lib/firmware/ar9170-2.fw
>> -rw-r--r-- 1 root root 15960 2009-10-17 15:55 /lib/firmware/ar9170.fw
>>
>> It is unclear to me which are actually used.
>>     
>
> By default the ar9170.fw is tried first, if that fails then the others
> are tried. The 2-stage firmware will not be tried if your device
> cannot handle it but right now only the AVM Fritz devices can't handle
> the 2-stage firmware.
>
> Christian should we just remove 2-stage fw support?
>
>   Luis
>   

