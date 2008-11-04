Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42927 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYKDH2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 02:28:01 -0500
To: "Benoit PAPILLAULT" <benoit.papillault@free.fr>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k : Display MAC/BB and RF version at startup
References: <490F63B6.8080600@free.fr>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 04 Nov 2008 09:27:37 +0200
In-Reply-To: <490F63B6.8080600@free.fr> (ext Benoit PAPILLAULT's message of "Mon\, 03 Nov 2008 21\:48\:54 +0100")
Message-ID: <878ws0ar2u.fsf@nokia.com> (sfid-20081104_082807_780329_AD7E6F21)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Benoit PAPILLAULT" <benoit.papillault@free.fr> writes:

> This patch decodes the MAC/BB version (for instance: AR5416) and the RF
> part version (for instance: AR5133). It has been tested on AR5416/AR5133
> which is a 2.4/5GHz 3x3 11n device. It also makes the differences
> between AR5416 (PCI) and AR5418 (PCI Express). Both are named AR5416 in
> the register definitions.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

[...]

> -	printk(KERN_INFO "%s: %s: mem=0x%lx, irq=%d\n",
> +	ah = sc->sc_ah;
> +	macVersion = ah->ah_macVersion;
> +	rfVersion  = (ah->ah_analog5GhzRev & AR_RADIO_SREV_MAJOR);
> +	printk(KERN_INFO
> +	       "%s: Atheros AR%s%s%s%s%s%s MAC/BB Rev:%x "
> +	       "AR%s%s%s%s%s RF Rev:%x: mem=0x%lx, irq=%d\n",
>  	       wiphy_name(hw->wiphy),
> -	       athname ? athname : "Atheros ???",
> +	       macVersion == AR_SREV_VERSION_5416_PCI  ? "5416" : "",
> +	       macVersion == AR_SREV_VERSION_5416_PCIE ? "5418" : "",
> +	       macVersion == AR_SREV_VERSION_9100      ? "9100" : "",
> +	       macVersion == AR_SREV_VERSION_9160      ? "9160" : "",
> +	       macVersion == AR_SREV_VERSION_9280      ? "9280" : "",
> +	       macVersion == AR_SREV_VERSION_9285      ? "9285" : "",
> +	       ah->ah_macRev,
> +	       rfVersion  == 0                         ? "5133" : "",
> +	       rfVersion  == AR_RAD5133_SREV_MAJOR     ? "5133" : "",
> +	       rfVersion  == AR_RAD5122_SREV_MAJOR     ? "5122" : "",
> +	       rfVersion  == AR_RAD2133_SREV_MAJOR     ? "2133" : "",
> +	       rfVersion  == AR_RAD2122_SREV_MAJOR     ? "2122" : "",
> +	       ah->ah_phyRev,

I recommend adding a separate function returning the string instead of
this ugly "%s%s%s%s" trick. Much cleaner that way.

-- 
Kalle Valo
