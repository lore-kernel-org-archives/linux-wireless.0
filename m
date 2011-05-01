Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:42986 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1EAG2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 02:28:50 -0400
Received: by pxi16 with SMTP id 16so1572013pxi.4
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 23:28:49 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19900.65080.732917.964759@gargle.gargle.HOWL> (sfid-20110501_082906_157925_9D78599B)
Date: Sun, 1 May 2011 12:01:20 +0530
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org, Steven <srumney@sbcglobal.net>,
	Mark Davis <marked86@gmail.com>
Subject: error initializing AR7010+AR9280 Xbox 802.11n adapter
In-Reply-To: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
References: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

George Nychis wrote:
> Hi all,
> 
> A while back, I posted to the list looking for an AR7010+AR9280 USB
> 802.11n device that I could hopefully use with ath9k:
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/67252
> 
> One adapter that came up was the Xbox 360 802.11n adapter, which has
> this chipset solution:
> http://www.wikidevi.com/wiki/Microsoft_Xbox_360_Wireless_N_Networking_Adapter
> 
> I purchased one of the Xbox 360 802.11n adapters, and would now like
> to get it working with ath9k_htc, but having some issues.
> 
> First, I added support for the USB device. I edited
> ./drivers/net/wireless/ath/ath9k/hif_usb.c ... and added this to
> static struct usb_device_id ath9k_hif_usb_ids[]:
> 
>  { USB_DEVICE(0x045e, 0x02a8),
>    .driver_info = AR9280_USB }, /* Microsoft Wireless N */
> 
> After that, I rebuilt and got the module up and running.  However,
> when I plug in the device, I get the following errors:
> After installing the new driver and plugging in the device, this is
> the error I get:
> [ 4599.236871] usb 1-1: ath9k_htc: Transferred FW: htc_7010.fw, size: 72996
> [ 4600.237494] ath9k_htc 1-1:1.0: ath9k_htc: Target is unresponsive
> [ 4600.237494] Failed to initialize the device
> [ 4600.240386] ath9k_htc: probe of 1-1:1.0 failed with error -22
> [ 4600.248782] usbcore: registered new interface driver ath9k_htc
> 
> The light on the Xbox adapter goes solid, which makes me believe part
> of the firmware was written to the device.
> 
> Has anyone had any experience with getting the Xbox 802.11n adapter to
> work with compat-wireless?  If not, does anyone have any suggestions
> or direction I should go in?

Bad luck. :(

AR9280+AR7010 USB dongles are based on UB94, the Xbox adapter is not, it's
based on a different reference design, so it is not surprising that ath9k_htc
fails to bring up the card.

Looks like a different firmware is required for the Xbox 360 adapter.
I am not sure how different the fw is from htc_7010, so it is hard to say
how much work has to be done to port the required changes to htc_7010.fw.

I don't have the adapter with me, so any fw change has to be tested by you. :)

Sujith
