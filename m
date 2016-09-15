Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exsmtp01.microchip.com ([198.175.253.37]:58217 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756934AbcIOHAO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 03:00:14 -0400
From: <Aditya.Shankar@microchip.com>
To: <josh@awful.name>, <linux-wireless@vger.kernel.org>
CC: <Ganesh.Krishna@microchip.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers: wilc1000: remove references to semaphores
Date: Thu, 15 Sep 2016 06:55:00 +0000
Message-ID: <1FA4CE79C3B5BA4CB1930722261ABC02CAF81E56@CHN-SV-EXMX03.mchp-main.com> (sfid-20160915_090255_724343_179AA1F7)
References: <4195523.kKD5sp4Uk6@arch>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 August 2016 12:04 AM, Joshua Houghton wrote:
> * Update the comments that refer to semaphores
> * Remove redundant includes to semphore.h
> 
> Signed-off-by: Joshua Houghton <josh@awful.name>
> ---
>  drivers/staging/wilc1000/TODO                 | 1 -
>  drivers/staging/wilc1000/linux_wlan.c         | 1 -
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
>  drivers/staging/wilc1000/wilc_wlan.h          | 2 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h       | 1 -
>  5 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
> index ec93b2e..ae61b55 100644
> --- a/drivers/staging/wilc1000/TODO
> +++ b/drivers/staging/wilc1000/TODO
> @@ -3,7 +3,6 @@ TODO:
>  - remove OS wrapper functions
>  - remove custom debug and tracing functions
>  - rework comments and function headers(also coding style)
> -- replace all semaphores with mutexes or completions
>  - Move handling for each individual members of 'union message_body' out
>    into a separate 'struct work_struct' and completely remove the multiplexer
>    that is currently part of host_if_work(), allowing movement of the
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 3a66255..315ed2e 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -21,7 +21,6 @@
>  #include <linux/kernel.h>
>  #include <linux/skbuff.h>
>  #include <linux/mutex.h>
> -#include <linux/semaphore.h>
>  #include <linux/completion.h>
>  
>  static int dev_state_ev_handler(struct notifier_block *this,
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index 5cc6a82..ec6b167 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -131,7 +131,7 @@ struct wilc_priv {
>  	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
>  	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
>  	u8 wilc_groupkey;
> -	/* semaphores */
> +	/* mutexes */
>  	struct mutex scan_req_lock;
>  	/*  */
>  	bool gbAutoRateAdjusted;
> diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
> index 30e5312..739900e 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.h
> +++ b/drivers/staging/wilc1000/wilc_wlan.h
> @@ -192,7 +192,7 @@
>  
>  #define ENABLE_RX_VMM		(SEL_VMM_TBL1 | EN_VMM)
>  #define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
> -/*time for expiring the semaphores of cfg packets*/
> +/*time for expiring the completion of cfg packets*/
>  #define CFG_PKTS_TIMEOUT	2000
>  /********************************************
>   *
> diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
> index 410bfc0..439ac6f 100644
> --- a/drivers/staging/wilc1000/wilc_wlan_if.h
> +++ b/drivers/staging/wilc1000/wilc_wlan_if.h
> @@ -10,7 +10,6 @@
>  #ifndef WILC_WLAN_IF_H
>  #define WILC_WLAN_IF_H
>  
> -#include <linux/semaphore.h>
>  #include <linux/netdevice.h>
>  
>  /********************************************
> 

Removed the non existing email addresses from this list and copy current maintainer

Acked-by: Aditya Shankar <aditya.shankar@microchip.com>

Thanks!
