Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:34609 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757355Ab0LBNOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 08:14:14 -0500
Message-ID: <400806.62671.qm@web56803.mail.re3.yahoo.com>
Date: Thu, 2 Dec 2010 05:14:12 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] compat: backport LED class software blinking
To: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Cc: lrodriguez@atheros.com
In-Reply-To: <1290945916-95814-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---

> +}
> +EXPORT_SYMBOL(compat_led_brightness_set);
> +
> +void compat_led_classdev_unregister(struct led_classdev
> *led_cdev)
> +{

I think this patch is causing problems in compat-wireless. It compiles fine, but some drivers fail to load:

# modprobe rtl8187 
FATAL: Error inserting rtl8187 (/lib/modules/2.6.35-23-generic/updates/drivers/net/wireless/rtl818x/rtl8187.ko): Unknown symbol in module, or unknown parameter (see dmesg)

dmesg:
[22920.062471] rtl8187: Unknown symbol compat_led_classdev_unregister (err 0)

rt2x00 yields similar result:

WARNING: Error inserting rt2x00usb (/lib/modules/2.6.35-23-generic/updates/drivers/net/wireless/rt2x00/rt2x00usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting crc_ccitt (/lib/modules/2.6.35-23-generic/kernel/lib/crc-ccitt.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2800lib (/lib/modules/2.6.35-23-generic/updates/drivers/net/wireless/rt2x00/rt2800lib.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rt2800usb (/lib/modules/2.6.35-23-generic/updates/drivers/net/wireless/rt2x00/rt2800usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)

dmesg:
[23093.077850] rt2x00lib: Unknown symbol compat_led_classdev_unregister (err 0)

Walter.


      
