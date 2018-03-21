Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51178 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbeCUHtd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 03:49:33 -0400
Date: Wed, 21 Mar 2018 10:49:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 09/11] staging: wilc1000: remove line over 80 char in
 cfg_connect_result()
Message-ID: <20180321074913.ldk2lcie4hsmnic4@mwanda> (sfid-20180321_085003_572078_297C1EDB)
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <1521564944-3565-10-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521564944-3565-10-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 10:25:42PM +0530, Ajay Singh wrote:
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 1b6fe64..af1b8aa 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -460,6 +460,17 @@ static void cfg_scan_result(enum scan_event scan_event,
>  	}
>  }
>  
> +static inline bool wilc_wfi_cfg_scan_time_expired(int i)

"i" is the wrong parameter to pass.  The name is not useful.  Probably
the right parameter is either &last_scanned_shadow[i] or
last_scanned_shadow[i].time_scan_cached.

> +{
> +	unsigned long now = jiffies;
> +
> +	if (time_after(now, last_scanned_shadow[i].time_scan_cached +
> +		       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
> +		return true;
> +	else
> +		return false;

Also I think it you apply this patch and then run checkpatch.pl --strict
against the file it will complain that it should be:

	if (time_after(now, last_scanned_shadow[i].time_scan_cached +
		       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
		return true;
	return false;

> +}
> +
>  int wilc_connecting;
>  
>  static void cfg_connect_result(enum conn_event conn_disconn_evt,
> @@ -505,17 +516,14 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
>  			bool scan_refresh = false;
>  			u32 i;
>  
> -			memcpy(priv->associated_bss, conn_info->bssid, ETH_ALEN);
> +			memcpy(priv->associated_bss, conn_info->bssid,
> +			       ETH_ALEN);
>  

It basically always helps me if the "new function" changes are in a
patch by themselves.  These lines are a pure white space changes and I
have a script that reviews those for me instantly, but when it's mixed
with this patch I have to do it by hand.

regards,
dan carpenter
