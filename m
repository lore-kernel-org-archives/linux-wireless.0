Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:61648 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761184AbZDABFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 21:05:47 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1206177muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 18:05:44 -0700 (PDT)
Message-ID: <49D2BDE0.5040501@gmail.com> (sfid-20090401_030607_717409_615D95E5)
Date: Tue, 31 Mar 2009 21:05:36 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Implement fullmac-mode support
References: <200904010101.44380.mb@bu3sch.de>
In-Reply-To: <200904010101.44380.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Recent work on the device firmware discovered a completely new hardware
> mode for b43 devices.
>   
I will presume this is limited to the non-open firmware?
> All b43 devices have a bit in the MAC-control register to enable true
> hardware-fullMAC support. In fullmac mode the MAC and PHY is completely serviced
> by the firmware, so no driver support is required anymore.
>
> Full hardware MAC support has advantages and disadvantages:
>
> PRO:
> - The b43 driver does support _all_ devices (also 802.11n) in STA and AP mode.
> - The driver code is a lot simpler for the fullmac case. (It skips all of
>   the software MAC and PHY init).
> - People finally stop poking me to implement the N-PHY and LP-PHY code, yay.
>
> CON:
> - Packet injection is not supported in fullmac mode, yet. It's on
>   the TODO list with deadline 1.4.2010.
>
>   
While I certainly desire the ability for people to easily inject packets 
the benefits outweigh the losses here for 99.9% of users.  I would 
imagine most users are in station mode and those who are working in AP 
mode (or other monitor mode injections) can certainly figure out how to 
add fullmac=0.  I know it needs more testing but 1 vote for more device 
support.  Excellent work btw!
> The feature currently is disabled by default, because it isn't tested enough.
> It can be enabled at modprobe time with the "fullmac=1" module parameter.
>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> ---
>
> John, please queue this patch for 3.6.31.
>
>
>   
or maybe we can squeeze it into 2.6.31

-Rick
> Index: wireless-testing/drivers/net/wireless/b43/b43.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-04-01 00:00:18.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-04-01 00:00:20.000000000 +0200
> @@ -347,6 +347,7 @@ enum {
>  #define B43_MACCTL_ENABLED		0x00000001	/* MAC Enabled */
>  #define B43_MACCTL_PSM_RUN		0x00000002	/* Run Microcode */
>  #define B43_MACCTL_PSM_JMP0		0x00000004	/* Microcode jump to 0 */
> +#define B43_MACCTL_FULLMAC		0x00000008	/* Enable hardware full-MAC support */
>  #define B43_MACCTL_SHM_ENABLED		0x00000100	/* SHM Enabled */
>  #define B43_MACCTL_SHM_UPPER		0x00000200	/* SHM Upper */
>  #define B43_MACCTL_IHR_ENABLED		0x00000400	/* IHR Region Enabled */
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-04-01 00:00:18.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2009-04-01 00:00:20.000000000 +0200
> @@ -63,6 +63,10 @@ MODULE_LICENSE("GPL");
>  MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
>  
>  
> +static int modparam_fullmac;
> +module_param_named(fullmac, modparam_fullmac, int, 0444);
> +MODULE_PARM_DESC(fullmac, "Switch the hardware into fullmac mode");
> +
>  static int modparam_bad_frames_preempt;
>  module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, 0444);
>  MODULE_PARM_DESC(bad_frames_preempt,
> @@ -4113,6 +4117,9 @@ static void b43_wireless_core_exit(struc
>  		return;
>  	b43_set_status(dev, B43_STAT_UNINIT);
>  
> +	if (modparam_fullmac)
> +		goto ssb_disable;
> +
>  	/* Stop the microcode PSM. */
>  	macctl = b43_read32(dev, B43_MMIO_MACCTL);
>  	macctl &= ~B43_MACCTL_PSM_RUN;
> @@ -4132,6 +4139,7 @@ static void b43_wireless_core_exit(struc
>  		dev->wl->current_beacon = NULL;
>  	}
>  
> +ssb_disable:
>  	ssb_device_disable(dev->dev, 0);
>  	ssb_bus_may_powerdown(dev->dev->bus);
>  }
> @@ -4157,6 +4165,14 @@ static int b43_wireless_core_init(struct
>  		b43_wireless_core_reset(dev, tmp);
>  	}
>  
> +	if (modparam_fullmac) {
> +		b43_write32(dev, B43_MMIO_MACCTL,
> +			    b43_read32(dev, B43_MMIO_MACCTL)
> +			    | B43_MACCTL_FULLMAC);
> +		err = 0;
> +		goto out;
> +	}
> +
>  	/* Reset all data structures. */
>  	setup_struct_wldev_for_init(dev);
>  	phy->ops->prepare_structs(dev);
>
>   

