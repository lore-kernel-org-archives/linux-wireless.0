Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57837 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab0KDCvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 22:51:15 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 19:51:03 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: Ming Lei <tom.leiming@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Thu, 4 Nov 2010 08:21:11 +0530
Subject: RE: [PATCH] ath9k-htc: fix probe failure
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6CA@CHEXMB-01.global.atheros.com>
References: <1288621950-13918-1-git-send-email-tom.leiming@gmail.com>
	<44EE5C37ADC36343B0625A05DD408C4850DAB4D6C8@CHEXMB-01.global.atheros.com>
	<AANLkTikkFOer0VWDjb0PrfeP-dB+tMiY4eTTxv_FNjSp@mail.gmail.com>
	<44EE5C37ADC36343B0625A05DD408C4850DAB4D6C9@CHEXMB-01.global.atheros.com>,<AANLkTinOT1C6pXfiDLC_RQe0xyeQKRWPYj9vp_uBbfpt@mail.gmail.com>
In-Reply-To: <AANLkTinOT1C6pXfiDLC_RQe0xyeQKRWPYj9vp_uBbfpt@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>2010/11/4 Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>:
>>>2010/11/2 Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>:
>>>> From: Ming Lei <tom.leiming@gmail.com>
>>>>
>>>> Obviously, we should set the transfer type consitent with
>>>> endpoint descriptor type to urb, this patch fixes the probe
>>>> failure below:
>>>>
>>>>[    8.018768] PM: Removing info for No Bus:1-2.2
>>>> [    8.019470] usb 1-2.2: BOGUS urb xfer, pipe 3 != type 1
>>>> [    8.031707] usb 1-2.2: ath9k_htc: Unable to allocate URBs
>>>> [    8.037506] ath9k_hif_usb: probe of 1-2.2:1.0 failed with error -22
>>>> [    8.044250] usbcore: registered new interface driver ath9k_hif_usb
>>>>
>>>> NACK. To optimize CPU consumption and scan duration,  HTC device firmwares
>>>> were patched to change descriptor types of EP3 and EP4 from Interrupt to Bulk.
>>>> After firmware download in initialization, endpoint descriptors got changed.
>>>> Please use the latest firmwares from linux-firmware git tree.
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary
>>>
>>>My card is UB91, so you means I should update to this one(ar9271.fw) blew:
>>>
>>>http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux->>firmware.git;a=blob;f=ar9271.fw;h=0ec953b404c1912dc64fa3b0171cffae82b0f375;hb=8f919160792e4702c6b7a67a243cea4f757407e4
>>>
>>>This one still can't prevent the probe failure...
>>
>>>Any suggestions?
>>
>> Could you please try it without CONFIG_USB_DEBUG option.
>
>I don't think disabling CONFIG_USB_DEBUG can prevent the .probe failure,
>which only don't print some messages.
>
>So this patch does make sense, doesn't it?

The recent commit "check the endpoint type against the pipe type" in usb under DEBUG is causing probe failure,
It's conditional on CONFIG_USB_DEBUG, so it won't affect normal users. But this probe failure under DEBUG
needs to be addressed without causing any IOT issue.

Thanks,
Rajkumar