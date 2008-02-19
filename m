Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:4859 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYBSXfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 18:35:30 -0500
Received: by py-out-1112.google.com with SMTP id u52so2864754pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2008 15:35:29 -0800 (PST)
Message-ID: <43e72e890802191535i5bd89432rfed0f4cf3e375c29@mail.gmail.com> (sfid-20080219_233533_968177_158DEFE8)
Date: Tue, 19 Feb 2008 18:35:28 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: Patch for compat-wireless-2.6
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <47B6FD58.5010004@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47B6FD58.5010004@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 16, 2008 10:12 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Hi
>
> This patch fixes some compile errors in the newest version of
> compat-wireless-2.6. I have tested it with kernel 2.6.24 and 2.6.22

Thanks for the patch! Going to paste the patch below as if sent inline
and address some things:

> diff --git a/compat/compat.diff b/compat/compat.diff
> index c857ea2..49325b5 100644
> --- a/compat/compat.diff
> +++ b/compat/compat.diff
> @@ -633,3 +633,34 @@
>   obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
>  -obj-$(CONFIG_INTEL_MENLOW)	+= intel_menlow.o
>  -obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
> +--- a/drivers/net/wireless/zd1211rw/zd_chip.c	2008-02-15 16:29:43.000000000 -0500
> ++++ b/drivers/net/wireless/zd1211rw/zd_chip.c	2008-02-15 16:29:43.000000000 -0500
> +@@ -1280,7 +1280,7 @@ int zd_chip_control_leds(struct zd_chip *chip, enum led_status status)
> + 	other_led = chip->link_led == LED1 ? LED2 : LED1;
> +
> + 	switch (status) {
> +-	case LED_OFF:
> ++	case LED_OFF_ZD:
> + 		ioreqs[0].value = FW_LINK_OFF;
> + 		ioreqs[1].value = v[1] & ~(LED1|LED2);
> + 		break;
> +--- a/drivers/net/wireless/zd1211rw/zd_chip.h	2008-02-15 16:29:43.000000000 -0500
> ++++ b/drivers/net/wireless/zd1211rw/zd_chip.h	2008-02-15 16:29:43.000000000 -0500
> +@@ -890,7 +890,7 @@ int zd_chip_lock_phy_regs(struct zd_chip *chip);
> + int zd_chip_unlock_phy_regs(struct zd_chip *chip);
> +
> + enum led_status {
> +-	LED_OFF = 0,
> ++	LED_OFF_ZD = 0,
> + 	LED_SCANNING = 1,
> + 	LED_ASSOCIATED = 2,
> + };
> +--- a/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-15 16:29:43.000000000 -0500
> ++++ b/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-15 16:29:43.000000000 -0500
> +@@ -965,5 +965,5 @@ static void housekeeping_disable(struct zd_mac *mac)
> + 	dev_dbg_f(zd_mac_dev(mac), "\n");
> + 	cancel_rearming_delayed_workqueue(zd_workqueue,
> + 		&mac->housekeeping.link_led_work);
> +-	zd_chip_control_leds(&mac->chip, LED_OFF);
> ++	zd_chip_control_leds(&mac->chip, LED_OFF_ZD);
> + }

This could possibly go upstream so we don't have to keep an extra
patch around. Up to zd guys though. If not we'll have to keep updating
this hunk as the driver changes. Not a big issue. This is just so we
can keep including from compat.h leds.h which has its own definition
of LEDS_OFF.

> diff --git a/compat/compat.h b/compat/compat.h
> index b438a5a..a25192d 100644
> --- a/compat/compat.h
> +++ b/compat/compat.h
> @@ -10,6 +10,8 @@
>  #include <linux/scatterlist.h>
>  #include <linux/usb.h>
>  #include <linux/compat_autoconf.h>
> +#include <linux/hw_random.h>
> +#include <linux/leds.h>

b43 now can get leds support, will enable that, thanks.

>  /* Compat work for 2.6.22 and 2.6.23 */
>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
> @@ -17,7 +19,7 @@
>  /* From include/linux/mod_devicetable.h */
>
>  /* SSB core, see drivers/ssb/ */
> -#ifndef CONFIG_SSB
> +#ifndef SSB_DEVICE
>  struct ssb_device_id {
>  	__u16   vendor;
>  	__u16   coreid;
> @@ -190,4 +192,20 @@ static inline void set_freezable(void) {}
>  #endif /* CONFIG_PM_SLEEP */
>
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)) */
> +
> +/* Compat work for 2.6.24 */
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
> +
> +static inline void __hwrng_unregister(struct hwrng *rng, bool suspended)
> +{
> +	hwrng_unregister(rng);
> +}
> +
> +static inline void led_classdev_unregister_suspended(struct led_classdev *lcd)
> +{
> +	led_classdev_unregister(lcd);
> +}
> +
> +
> +#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
>  #endif /* LINUX_26_COMPAT_H */
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
> index 5f6e9e1..147a01e 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -18,7 +18,7 @@
>  GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git"
>
>  INCLUDE_LINUX="ieee80211.h nl80211.h wireless.h"
> -INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h bitops.h eeprom_93cx6.h"
> +INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h bitops.h eeprom_93cx6.h pm_qos_params.h"

pm_qos_params.h requires porting (work is in kernel/pm_qos_params.c)
for kernels <= 2.6.24 but I've gone ahead and added this work to
compat.c ontop of your patch.

Changes pushed, and new tarball re-generated. Also minor note, I've
enabled PID rate control algorithm as the default rate control
algorithm as 'simple' is scheduled for removal for 2.6.26. Please let
me know if you have any issues.

  Luis
