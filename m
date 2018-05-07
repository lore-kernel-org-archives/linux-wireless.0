Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:32076 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbeEGFy6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 01:54:58 -0400
Date: Mon, 7 May 2018 11:24:51 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Nathan Chancellor <natechancellor@gmail.com>
CC: <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: Re: [PATCH 2/3] staging: wilc1000: Remove useless function
Message-ID: <20180507112451.574f72ac@ajaysk-VirtualBox> (sfid-20180507_075502_448263_DC38DCC3)
In-Reply-To: <20180506073333.3770-2-natechancellor@gmail.com>
References: <20180506073333.3770-1-natechancellor@gmail.com>
        <20180506073333.3770-2-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 May 2018 00:33:32 -0700
Nathan Chancellor <natechancellor@gmail.com> wrote:

> GCC warns that 'wid' is unused in wilc_remove_key and it's correct;
> the variable is only local. Get rid of the function (since it just
> returns zero) and shuffle the remaining code into one if statement.
> 
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>

> ---
>  drivers/staging/wilc1000/host_interface.c         | 12 ------------
>  drivers/staging/wilc1000/host_interface.h         |  1 -
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++---------
>  3 files changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c
> b/drivers/staging/wilc1000/host_interface.c index
> 3fd4c8e62da6..b5f3829e9903 100644 ---
> a/drivers/staging/wilc1000/host_interface.c +++
> b/drivers/staging/wilc1000/host_interface.c @@ -2606,18 +2606,6 @@
> static void timer_connect_cb(struct timer_list *t)
> wilc_enqueue_cmd(&msg); }
>  
> -s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *sta_addr)
> -{
> -	struct wid wid;
> -
> -	wid.id = (u16)WID_REMOVE_KEY;
> -	wid.type = WID_STR;
> -	wid.val = (s8 *)sta_addr;
> -	wid.size = 6;
> -
> -	return 0;
> -}
> -
>  int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
>  {
>  	int result = 0;
> diff --git a/drivers/staging/wilc1000/host_interface.h
> b/drivers/staging/wilc1000/host_interface.h index
> 7a26f341e0ba..08b3ba7df8b4 100644 ---
> a/drivers/staging/wilc1000/host_interface.h +++
> b/drivers/staging/wilc1000/host_interface.h @@ -303,7 +303,6 @@
> struct add_sta_param { };
>  
>  struct wilc_vif;
> -s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *sta_addr);
>  int wilc_remove_wep_key(struct wilc_vif *vif, u8 index);
>  int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index);
>  int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8
> len, diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c index
> 76b4afaef423..b499fb987395 100644 ---
> a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c +++
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c @@ -1054,15
> +1054,11 @@ static int del_key(struct wiphy *wiphy, struct net_device
> *netdev, } }
>  
> -	if (key_index >= 0 && key_index <= 3) {
> -		if (priv->wep_key_len[key_index]) {
> -			memset(priv->wep_key[key_index], 0,
> -			       priv->wep_key_len[key_index]);
> -			priv->wep_key_len[key_index] = 0;
> -			wilc_remove_wep_key(vif, key_index);
> -		}
> -	} else {
> -		wilc_remove_key(priv->hif_drv, mac_addr);
> +	if (key_index >= 0 && key_index <= 3 &&
> priv->wep_key_len[key_index]) {
> +		memset(priv->wep_key[key_index], 0,
> +		       priv->wep_key_len[key_index]);
> +		priv->wep_key_len[key_index] = 0;
> +		wilc_remove_wep_key(vif, key_index);
>  	}
>  
>  	return 0;
