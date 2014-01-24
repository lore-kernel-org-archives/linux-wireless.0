Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:34902 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaAXKIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 05:08:09 -0500
Received: by mail-la0-f41.google.com with SMTP id mc6so2441798lab.28
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 02:08:08 -0800 (PST)
Received: from [10.97.97.3] ([80.89.196.154])
        by mx.google.com with ESMTPSA id np10sm508319lbb.7.2014.01.24.02.08.06
        for <linux-wireless@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Fri, 24 Jan 2014 02:08:06 -0800 (PST)
Message-ID: <1390558084.5524.9.camel@mesosphere.localdomain> (sfid-20140124_110821_318546_8D12F1B7)
Subject: Re: [PATCH] rt2x00: rt2800usb: mark D-Link DWA-137 as supported
From: Roman Dubtsov <dubtsov@gmail.com>
To: linux-wireless@vger.kernel.org
Date: Fri, 24 Jan 2014 17:08:04 +0700
In-Reply-To: <1390290558-6265-1-git-send-email-dubtsov@gmail.com>
References: <1390290558-6265-1-git-send-email-dubtsov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-21 at 14:49 +0700, dubtsov@gmail.com wrote:
> From: Roman Dubtsov <dubtsov@gmail.com>
> 
> Signed-off-by: Roman Dubtsov <dubtsov@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index a81ceb6..ea619c2 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -992,6 +992,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x07d1, 0x3c15) },
>  	{ USB_DEVICE(0x07d1, 0x3c16) },
>  	{ USB_DEVICE(0x07d1, 0x3c17) },
> +	{ USB_DEVICE(0x2001, 0x3317) },
>  	{ USB_DEVICE(0x2001, 0x3c1b) },
>  	/* Draytek */
>  	{ USB_DEVICE(0x07fa, 0x7712) },

Does this patch make sense? Probably I should provide some additional
information. DWA-137 [1] is and wifi dongle which seems to only be sold
in Russia (hence the link below is in Russian). I'd be happy to provide
any additional data / run additional tests. For now I know that AP mode
works as well as 802.11n.

$ iwconfig wlp0s26f7u1
wlp0s26f7u1  IEEE 802.11bgn  ESSID:"hm"
          Mode:Managed  Frequency:2.462 GHz  Access Point: XX:XX:XX:XX:XX:XX
          Bit Rate=117 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
          Link Quality=53/70  Signal level=-57 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:62  Invalid misc:189   Missed beacon:0


$ dmesg | grep 'usb 1-1'
[    0.831010] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.964482] usb 1-1: New USB device found, idVendor=2001, idProduct=3317
[    0.964486] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    0.964489] usb 1-1: Product: 802.11 n WLAN
[    0.964492] usb 1-1: Manufacturer: Ralink
[    0.964494] usb 1-1: SerialNumber: 1.0

[1] http://www.dlink.ru/ru/products/150/1864.html

