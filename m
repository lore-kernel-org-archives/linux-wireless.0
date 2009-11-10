Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42020 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbZKJJU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 04:20:57 -0500
Subject: Re: [RFT 6/6] rtl8187se: Modify Kconfig and Makefile
From: Marcel Holtmann <marcel@holtmann.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4af8a64a.OAu73X3xIXLBXo18%Larry.Finger@lwfinger.net>
References: <4af8a64a.OAu73X3xIXLBXo18%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 10:20:55 +0100
Message-ID: <1257844855.26914.1.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> Modify configuration and builod system for rtl8187se.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing/drivers/net/wireless/Kconfig
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/Kconfig
> +++ wireless-testing/drivers/net/wireless/Kconfig
> @@ -294,6 +294,16 @@ config RTL8187_LEDS
>  	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
>  	default y
>  
> +config RTL8187SE
> +	tristate "Realtek 8187SE PCI support"
> +	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
> +	select EEPROM_93CX6
> +	---help---
> +	  This is a driver for RTL8187SE PCI-based cards. If built as a
> +	  module, it will be named rtl8187se.
> +
> +	  Thanks to Realtek for their support!

does this really belong into the help text. Having it in the copyright
header seems enough. Especially since this help text is not offering any
additional advice or information for the user.

Regards

Marcel


