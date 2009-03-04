Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51616 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZCDEfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 23:35:00 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2009 20:34:59 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18862.1025.217829.656599@gargle.gargle.HOWL> (sfid-20090304_053502_466784_63BA16D1)
Date: Wed, 4 Mar 2009 10:00:57 +0530
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC] ath9k: use correct init values for ar9100 devices
In-Reply-To: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> 1. In some cases the ethernet interface goes down for a short time
> after'ifconfig wlan0 up'.
> 2. Sometimes the device simply reboots itself after 'ifconfig wlan0 up'.
> 
> After I have added some printk statements into the code, I noticed that the
> ar5416 and ar9100 devices use the same initval arrays currently. I assume
> that they requires different initialization, because we have different
> arrays for them.
> 

Yep, this is a bug, and AR_SREV_9100_OR_LATER is probably wrong.

> Although I have no detailed knowledge about the evolution of the ath9k devices,
> but the version checking macros for ther AR5416 cards seemed weird enough, so I
> have replaced them. Unfortunately, this leaded to very bad performance with the
> ar5416 cards I have, but the driver was working on the ar913x boards.
> 
> After some digging, I have found an interesting ifdef statement in Sam's current
> HAL. In his ar5416Common initval array, this ifdef conditionally selects the
> right RTC register offsets for the ar5416/ar9100 devices. The strange thing,
> that in the ath9k driver the ar5416 specific RTC register offsets are used in
> the ar5416Common_ar9100 array, while the ar9100 specific offsets are used in the
> ar5416Common.
> 

I'll check the initval arrays and update.

> +#define AR_SREV_5416(_ah) \
> +       (((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) || \
> +       ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI))
> +#define AR_SREV_5416_V20_OR_LATER(_ah) \
> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE) || \
> +       ((AR_SREV_5416(_ah)) && \
> +       ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)))
> +#define AR_SREV_5416_V22_OR_LATER(_ah) \
> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE) || \
> +       ((AR_SREV_5416(_ah)) && \
> +       ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)))
> +

Hm, the 5416_V1, 5416_V2 macros have to check 3 different HW (5416, 9100, 9160).

> +#define AR_SREV_9100(ah) \
> +       ((ah->hw_version.macVersion) == AR_SREV_VERSION_9100)
>  #define AR_SREV_9100_OR_LATER(_ah) \
> -       (((_ah)->hw_version.macVersion >= AR_SREV_VERSION_5416_PCIE))
> -#define AR_SREV_5416_20_OR_LATER(_ah) \
> -       (((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160) || \
> -               ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20))
> -#define AR_SREV_5416_22_OR_LATER(_ah) \
> -       (((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160) || \
> -               ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22))
> +       ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100)
> +
>  #define AR_SREV_9160(_ah) \
>         (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9160))
>  #define AR_SREV_9160_10_OR_LATER(_ah) \
> --
> 1.5.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
