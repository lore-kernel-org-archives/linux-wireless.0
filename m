Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:33246 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbZDABhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 21:37:00 -0400
Received: by ewy9 with SMTP id 9so2858412ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 18:36:57 -0700 (PDT)
Message-ID: <49D2C52D.5030207@gmail.com> (sfid-20090401_033716_796267_604F03ED)
Date: Tue, 31 Mar 2009 21:36:45 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Implement fullmac-mode support
References: <200904010101.44380.mb@bu3sch.de>
In-Reply-To: <200904010101.44380.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Recent work on the device firmware discovered a completely new hardware
> mode for b43 devices.
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
Michael Buesch wrote:
> Recent work on the device firmware discovered a completely new hardware
> mode for b43 devices.
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
Enabling the fullmac option causes the following oops while trying to 
bring up the interface as an AP using hostapd. This oops does not occur 
if the fullmac option is not set. The stack trace is as follows:

kernel: [  546.416409] Oops: 0000 [#1]
kernel: [  546.416493] last sysfs file: 
/sys/devices/virtual/input/input4/capabilities/sw
kernel: [  546.420045] Process phy1 (pid: 3581, ti=cdb62000 
task=cc5da810 task.ti=cdb62000)
kernel: [  546.420045] Stack:
kernel: [  546.420045]  cf44a00a cd135000 cf446fa9 cd135274 ccd3c720 
cf446ec3 00000000 c0127664
kernel: [  546.420045]  ccd3c720 c0127a29 ccd3c728 c0127ad6 00000000 
cc5da810 c012a29a cdb63fc4
kernel: [  546.420045] Call Trace:
kernel: [  546.420045]  [<cf444ab8>] b43_mac_suspend+0x1e/0xbf [b43]
kernel: [  546.420045]  [<cf44a00a>] b43_gphy_op_pwork_15sec+0xf/0x17 [b43]
kernel: [  546.420045]  [<cf446fa9>] 
b43_periodic_work_handler+0xe6/0x13c [b43]
kernel: [  546.420045]  [<cf446ec3>] b43_periodic_work_handler+0x0/0x13c 
[b43]
kernel: [  546.420045]  [<c0127664>] run_workqueue+0x74/0xec
kernel: [  546.420045]  [<c0127a29>] worker_thread+0x0/0xb8
kernel: [  546.420045]  [<c0127ad6>] worker_thread+0xad/0xb8
kernel: [  546.420045]  [<c012a29a>] autoremove_wake_function+0x0/0x2d
kernel: [  546.420045]  [<c0127a29>] worker_thread+0x0/0xb8
kernel: [  546.420045]  [<c0129eb7>] kthread+0x36/0x5a
kernel: [  546.420045]  [<c0129e81>] kthread+0x0/0x5a
kernel: [  546.420045]  [<c01038e7>] kernel_thread_helper+0x7/0x10
kernel: [  546.420045] Code: 89 1c 24 74 20 39 5f 58 0f 89 73 01 00 00 
89 f0 e8 c8 e9 ff ff 89 f0 31 d2 83 c4 10 5b 5e 5f 5d e9 4c fe ff ff 8b 
47 50 8d 58 f4 <8b> 43 0c c6 44 24 0f 00 83 e8 0c 89 44 24 08 8d 47 50 
89 44 24
kernel: [  546.420045] EIP: [<cf450872>] 
b43_lo_g_maintanance_work+0x55/0x1b3 [b43] SS:ESP 0068:cdb63f68

Relevant dmesg device info is as follows:
[    7.361106] b43-pci-bridge 0000:00:0f.0: enabling device (0000 -> 0002)
[    7.384831] b43-pci-bridge 0000:00:0f.0: PCI INT A -> Link[LNKC] -> 
GSI 10 (level, low) -> IRQ 10
[    9.697536] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
[    9.744147] b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
[    9.744183] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, 
Revision 8
[   60.181642] input: b43-phy0 as /devices/virtual/input/input4
[   60.224169] b43 ssb0:0: firmware: requesting b43/ucode5.fw
[   60.309769] b43 ssb0:0: firmware: requesting b43/pcm5.fw
[   60.347726] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
[   60.377113] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
[   60.520049] b43-phy0: Loading firmware version 410.2160 (2007-05-26 
15:32:10)

Regards,

David Ellingsworth
