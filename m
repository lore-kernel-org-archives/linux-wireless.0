Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37312 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752604AbdBJUXT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 15:23:19 -0500
Received: by mail-wm0-f47.google.com with SMTP id v77so57929762wmv.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2017 12:23:18 -0800 (PST)
Subject: Re: [PATCH] staging: wilc1000: remove unnecessary local array
To: Franck Demathieu <fdemathieu@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
References: <20170210150625.23343-1-fdemathieu@gmail.com>
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <df1bba65-ef3c-fdbc-eaa4-48287b161d5d@broadcom.com> (sfid-20170210_212323_260956_F67E17EA)
Date: Fri, 10 Feb 2017 21:23:14 +0100
MIME-Version: 1.0
In-Reply-To: <20170210150625.23343-1-fdemathieu@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-2-2017 16:06, Franck Demathieu wrote:
> It fixes the following warning reported by sparse:
> 
>   drivers/staging/wilc1000/linux_wlan.c:67:33: warning: too long initializer-string for array of char(no space for nul char)

As this was already submitted this should probably say [PATCH V2] in the
subject.
> Signed-off-by: Franck Demathieu <fdemathieu@gmail.com>
> ---

And put a change log here, ie.:

V2:
 - add devel@driverdev.osuosl.org
---
>  drivers/staging/wilc1000/linux_wlan.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 2eebc62..fc61f4e 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -64,7 +64,6 @@ static int dev_state_ev_handler(struct notifier_block *this,
>  	u8 *ip_addr_buf;
>  	struct wilc_vif *vif;
>  	u8 null_ip[4] = {0};
> -	char wlan_dev_name[5] = "wlan0";

You could have changed it to 'const char dev_name[] = "wlan0";'.

>  	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
>  		return NOTIFY_DONE;
> @@ -113,7 +112,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
>  			wilc_optaining_ip = false;
>  		}
>  
> -		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
> +		if (memcmp(dev_iface->ifa_label, "wlan0", 5) == 0)

First of all. Why using a memcmp here? dev_iface->ifa_label could be
shorter. Also using the value '5' here is tricky. So it would be better
to say:

		if (strlen(dev_iface->ifa_label) == strlen(dev_name) &&
		    memcmp(dev_iface->ifa_label,
			   dev_name, strlen(dev_name)) == 0)
>  			wilc_set_power_mgmt(vif, 0, 0);

However, it does not make sense at all to compare with wlan0 in the
first place. The net_device is registered in wilc_netdev_init() with
"wlan%d" as it should so there is no guarantee it is wlan0.

Regards,
Arend
