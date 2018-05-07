Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:8846 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbeEGFzd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 01:55:33 -0400
Date: Mon, 7 May 2018 11:25:27 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Nathan Chancellor <natechancellor@gmail.com>
CC: <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: Re: [PATCH 3/3] staging: wilc1000: Remove unnecessary array index
 check
Message-ID: <20180507112527.0037a95e@ajaysk-VirtualBox> (sfid-20180507_075547_341489_1AAF597E)
In-Reply-To: <20180506073333.3770-3-natechancellor@gmail.com>
References: <20180506073333.3770-1-natechancellor@gmail.com>
        <20180506073333.3770-3-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 May 2018 00:33:33 -0700
Nathan Chancellor <natechancellor@gmail.com> wrote:

> This statment triggers GCC's -Wtype-limit since key_index is an
> unsigned integer so it cannot be less than zero.
> 
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>

> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c index
> b499fb987395..e0015ca6c21a 100644 ---
> a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c +++
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c @@ -1054,7
> +1054,7 @@ static int del_key(struct wiphy *wiphy, struct net_device
> *netdev, } }
>  
> -	if (key_index >= 0 && key_index <= 3 &&
> priv->wep_key_len[key_index]) {
> +	if (key_index <= 3 && priv->wep_key_len[key_index]) {
>  		memset(priv->wep_key[key_index], 0,
>  		       priv->wep_key_len[key_index]);
>  		priv->wep_key_len[key_index] = 0;
