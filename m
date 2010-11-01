Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:46404 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab0KAQjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 12:39:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 09:38:58 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: "tom.leiming@gmail.com" <tom.leiming@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Mon, 1 Nov 2010 22:09:05 +0530
Subject: RE: [PATCH] ath9k-htc: fix probe failure
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C8@CHEXMB-01.global.atheros.com>
References: <1288621950-13918-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1288621950-13918-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

Obviously, we should set the transfer type consitent with
endpoint descriptor type to urb, this patch fixes the probe
failure below:

[    8.018768] PM: Removing info for No Bus:1-2.2
[    8.019470] usb 1-2.2: BOGUS urb xfer, pipe 3 != type 1
[    8.031707] usb 1-2.2: ath9k_htc: Unable to allocate URBs
[    8.037506] ath9k_hif_usb: probe of 1-2.2:1.0 failed with error -22
[    8.044250] usbcore: registered new interface driver ath9k_hif_usb

NACK. To optimize CPU consumption and scan duration,  HTC device firmwares
were patched to change descriptor types of EP3 and EP4 from Interrupt to Bulk.
After firmware download in initialization, endpoint descriptors got changed. 
Please use the latest firmwares from linux-firmware git tree.

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary

- Rajkumar