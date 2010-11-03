Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54499 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab0KCONU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 10:13:20 -0400
Received: by wwe15 with SMTP id 15so726549wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 07:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C8@CHEXMB-01.global.atheros.com>
References: <1288621950-13918-1-git-send-email-tom.leiming@gmail.com>
	<44EE5C37ADC36343B0625A05DD408C4850DAB4D6C8@CHEXMB-01.global.atheros.com>
Date: Wed, 3 Nov 2010 22:13:19 +0800
Message-ID: <AANLkTikkFOer0VWDjb0PrfeP-dB+tMiY4eTTxv_FNjSp@mail.gmail.com>
Subject: Re: [PATCH] ath9k-htc: fix probe failure
From: Ming Lei <tom.leiming@gmail.com>
To: Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>:
> From: Ming Lei <tom.leiming@gmail.com>
>
> Obviously, we should set the transfer type consitent with
> endpoint descriptor type to urb, this patch fixes the probe
> failure below:
>
> [    8.018768] PM: Removing info for No Bus:1-2.2
> [    8.019470] usb 1-2.2: BOGUS urb xfer, pipe 3 != type 1
> [    8.031707] usb 1-2.2: ath9k_htc: Unable to allocate URBs
> [    8.037506] ath9k_hif_usb: probe of 1-2.2:1.0 failed with error -22
> [    8.044250] usbcore: registered new interface driver ath9k_hif_usb
>
> NACK. To optimize CPU consumption and scan duration,  HTC device firmwares
> were patched to change descriptor types of EP3 and EP4 from Interrupt to Bulk.
> After firmware download in initialization, endpoint descriptors got changed.
> Please use the latest firmwares from linux-firmware git tree.
>
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary

My card is UB91, so you means I should update to this one(ar9271.fw) blew:

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=ar9271.fw;h=0ec953b404c1912dc64fa3b0171cffae82b0f375;hb=8f919160792e4702c6b7a67a243cea4f757407e4

This one still can't prevent the probe failure...

Any suggestions?

thanks,
-- 
Lei Ming
