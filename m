Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60553 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaGXJ3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 05:29:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <ath10k@lists.infradead.org>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	<kgiori@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<sven@narfation.org>
Subject: Re: [PATCHv3-ath-resend 2/2] ath10k: add spectral scan feature
References: <87mwc0ro8i.fsf@kamboji.qca.qualcomm.com>
	<1406136773-19957-1-git-send-email-sw@simonwunderlich.de>
Date: Thu, 24 Jul 2014 12:29:07 +0300
In-Reply-To: <1406136773-19957-1-git-send-email-sw@simonwunderlich.de> (Simon
	Wunderlich's message of "Wed, 23 Jul 2014 19:32:53 +0200")
Message-ID: <871ttbrtp8.fsf@kamboji.qca.qualcomm.com> (sfid-20140724_112918_944392_B020E48A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
> configuring a mode through a debugfs control file. Samples can be gathered via
> another relay debugfs file.
>
> Essentially, to try it out:
>
> ip link set dev wlan0 up
> echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> echo trigger > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> iw dev wlan0 scan
> echo disable > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 > samples
>
> This feature is still experimental. Based on the original RFC patch of
> Sven Eckelmann.
>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

[...]

> diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
> index a4179f4..3241ef9 100644
> --- a/drivers/net/wireless/ath/ath10k/Makefile
> +++ b/drivers/net/wireless/ath/ath10k/Makefile
> @@ -10,6 +10,7 @@ ath10k_core-y += mac.o \
>  		 wmi.o \
>  		 bmi.o
>  
> +ath10k_core-$(CPTCFG_ATH10K_DEBUGFS) += spectral.o

This one still uses CPTCFG_ prefix, I'll fix those.

> @@ -800,8 +800,6 @@ int ath10k_core_start(struct ath10k *ar)
>  	else
>  		ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
>  
> -	INIT_LIST_HEAD(&ar->arvifs);
> -
>  	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
>  		ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
>  			    ar->hw_params.name,
> @@ -1084,6 +1082,12 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
>  	INIT_WORK(&ar->register_work, ath10k_core_register_work);
>  	INIT_WORK(&ar->restart_work, ath10k_core_restart);
>  
> +	INIT_LIST_HEAD(&ar->arvifs);

I'm a bit suspicious about this, why is it needed?

-- 
Kalle Valo
