Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:11268 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934724AbeEINn0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:43:26 -0400
Subject: Re: [PATCH 13/30] staging: wilc1000: rename clear_duringIP() to avoid
 camelCase issue
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-14-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <aaf50a9f-f632-fd63-5363-15eebc3b60bd@microchip.com> (sfid-20180509_154348_327050_3189014E)
Date: Wed, 9 May 2018 16:43:22 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-14-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Rename clear_duringIP() function to avoid camelCase issue reported by
> checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index d0fb31a..f1ebaea 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -269,7 +269,7 @@ static void remove_network_from_shadow(struct timer_list *unused)
>  		mod_timer(&aging_timer, jiffies + msecs_to_jiffies(AGING_TIME));
>  }
>  
> -static void clear_duringIP(struct timer_list *unused)
> +static void clear_duringip(struct timer_list *unused)

Maybe add an '_' for better understanding: like clear_during_ip() ?

>  {
>  	wilc_optaining_ip = false;
>  }
> @@ -2272,7 +2272,7 @@ int wilc_init_host_int(struct net_device *net)
>  	priv = wdev_priv(net->ieee80211_ptr);
>  	if (op_ifcs == 0) {
>  		timer_setup(&aging_timer, remove_network_from_shadow, 0);
> -		timer_setup(&wilc_during_ip_timer, clear_duringIP, 0);
> +		timer_setup(&wilc_during_ip_timer, clear_duringip, 0);
>  	}
>  	op_ifcs++;
>  
> 
