Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbZEYBaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 21:30:04 -0400
Subject: Re: [RFT 5/4] iwm: port to new cfg80211 rfkill
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <1243068775.4606.56.camel@johannes.local>
References: <20090521215940.344214804@sipsolutions.net>
	 <1243068775.4606.56.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 25 May 2009 09:22:17 +0800
Message-Id: <1243214537.24825.703.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-05-23 at 16:52 +0800, Johannes Berg wrote:
> Which means removing all rfkill code since it only does
> soft-kill which cfg80211 will now handle in exactly the
> same way the driver did.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Looks good to me. I think we can remove the "select RFKILL" in Kconfig
also.

Thanks,
-yi
> ---
>  drivers/net/wireless/iwmc3200wifi/Makefile |    2 
>  drivers/net/wireless/iwmc3200wifi/iwm.h    |    4 -
>  drivers/net/wireless/iwmc3200wifi/netdev.c |   10 ---
>  drivers/net/wireless/iwmc3200wifi/rfkill.c |   83 -----------------------------
>  4 files changed, 1 insertion(+), 98 deletions(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/Makefile	2009-05-23 10:48:02.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwmc3200wifi/Makefile	2009-05-23 10:49:23.000000000 +0200
> @@ -1,5 +1,5 @@
>  obj-$(CONFIG_IWM) := iwmc3200wifi.o
>  iwmc3200wifi-objs += main.o netdev.o rx.o tx.o sdio.o hal.o fw.o
> -iwmc3200wifi-objs += commands.o wext.o cfg80211.o eeprom.o rfkill.o
> +iwmc3200wifi-objs += commands.o wext.o cfg80211.o eeprom.o
>  
>  iwmc3200wifi-$(CONFIG_IWM_DEBUG) += debugfs.o
> --- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/rfkill.c	2009-05-23 10:48:02.000000000 +0200
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,83 +0,0 @@
> -/*
> - * Intel Wireless Multicomm 3200 WiFi driver
> - *
> - * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
> - * Samuel Ortiz <samuel.ortiz@intel.com>
> - * Zhu Yi <yi.zhu@intel.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License version
> - * 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> - * 02110-1301, USA.
> - *
> - */
> -
> -#include <linux/rfkill.h>
> -
> -#include "iwm.h"
> -
> -static int iwm_rfkill_set_block(void *data, bool blocked)
> -{
> -	struct iwm_priv *iwm = data;
> -
> -	if (!blocked) {
> -		if (test_bit(IWM_RADIO_RFKILL_HW, &iwm->radio))
> -			return -EBUSY;
> -
> -		if (test_and_clear_bit(IWM_RADIO_RFKILL_SW, &iwm->radio) &&
> -		    (iwm_to_ndev(iwm)->flags & IFF_UP))
> -			return iwm_up(iwm);
> -	} else {
> -		if (!test_and_set_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
> -			return iwm_down(iwm);
> -	}
> -
> -	return 0;
> -}
> -
> -static const struct rfkill_ops iwm_rfkill_ops = {
> -	.set_block = iwm_rfkill_set_block,
> -};
> -
> -int iwm_rfkill_init(struct iwm_priv *iwm)
> -{
> -	int ret;
> -
> -	iwm->rfkill = rfkill_alloc(KBUILD_MODNAME,
> -				   iwm_to_dev(iwm),
> -				   RFKILL_TYPE_WLAN,
> -				   &iwm_rfkill_ops, iwm);
> -	if (!iwm->rfkill) {
> -		IWM_ERR(iwm, "Unable to allocate rfkill device\n");
> -		return -ENOMEM;
> -	}
> -
> -	ret = rfkill_register(iwm->rfkill);
> -	if (ret) {
> -		IWM_ERR(iwm, "Failed to register rfkill device\n");
> -		goto fail;
> -	}
> -
> -	return 0;
> - fail:
> -	rfkill_destroy(iwm->rfkill);
> -	return ret;
> -}
> -
> -void iwm_rfkill_exit(struct iwm_priv *iwm)
> -{
> -	if (iwm->rfkill) {
> -		rfkill_unregister(iwm->rfkill);
> -		rfkill_destroy(iwm->rfkill);
> -	}
> -	iwm->rfkill = NULL;
> -}
> --- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/iwm.h	2009-05-23 10:51:09.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwmc3200wifi/iwm.h	2009-05-23 10:51:12.000000000 +0200
> @@ -343,8 +343,4 @@ int iwm_rx_handle_resp(struct iwm_priv *
>  		       struct iwm_wifi_cmd *cmd);
>  void iwm_rx_free(struct iwm_priv *iwm);
>  
> -/* RF Kill API */
> -int iwm_rfkill_init(struct iwm_priv *iwm);
> -void iwm_rfkill_exit(struct iwm_priv *iwm);
> -
>  #endif
> --- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-05-23 10:51:18.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-05-23 10:51:29.000000000 +0200
> @@ -136,17 +136,8 @@ void *iwm_if_alloc(int sizeof_bus, struc
>  
>  	wdev->netdev = ndev;
>  
> -	ret = iwm_rfkill_init(iwm);
> -	if (ret) {
> -		dev_err(dev, "Failed to init rfkill\n");
> -		goto out_rfkill;
> -	}
> -
>  	return iwm;
>  
> - out_rfkill:
> -	unregister_netdev(ndev);
> -
>   out_ndev:
>  	free_netdev(ndev);
>  
> @@ -162,7 +153,6 @@ void iwm_if_free(struct iwm_priv *iwm)
>  	if (!iwm_to_ndev(iwm))
>  		return;
>  
> -	iwm_rfkill_exit(iwm);
>  	unregister_netdev(iwm_to_ndev(iwm));
>  	free_netdev(iwm_to_ndev(iwm));
>  	iwm_wdev_free(iwm);
> 
> 

