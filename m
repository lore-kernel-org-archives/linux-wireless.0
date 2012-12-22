Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:51180 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LVUF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 15:05:26 -0500
Received: by mail-la0-f48.google.com with SMTP id m13so6958059lah.35
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 12:05:25 -0800 (PST)
Message-ID: <50D61117.8020009@gmail.com> (sfid-20121222_210543_433320_EC91C234)
Date: Sat, 22 Dec 2012 20:59:19 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Solomon Peachy <pizza@shaftnet.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/17] cw1200:  Mini-AP implementation
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org> <1356191120-5280-7-git-send-email-pizza@shaftnet.org>
In-Reply-To: <1356191120-5280-7-git-send-email-pizza@shaftnet.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-12-22 16:45, Solomon Peachy wrote:
> The cw1200 is a thick-ish MAC that manages many aspects of AP operation
> in the firmware.  As such, it only supports a limited number of clients.

[...]
> +#if defined(CONFIG_CW1200_STA_DEBUG)
> +#define ap_printk(...) printk(__VA_ARGS__)
> +#else
> +#define ap_printk(...)
> +#endif
Please kill CONFIG_CW1200_*_DEBUG  and use pr_debug or other dyndbg 
interface instead. Goes for all files.

[...]

+#if defined(CONFIG_CW1200_USE_STE_EXTENSIONS)

Please get rid of CONFIG_CW1200_USE_STE_EXTENSIONS. The "extensions" is standard stuff anyway.

+			priv->cqm_beacon_loss_count =
+					info->cqm_beacon_miss_thold;
+			priv->cqm_tx_failure_thold =
+					info->cqm_tx_fail_thold;
+			priv->cqm_tx_failure_count = 0;

I remember fixing a tricky bug here. When loosing BSS the driver can in 
some case leave
priv->bss_loss_status to > CW1200_BSS_LOSS_NONE.
This blocks further processing of the BSS_LOST events from firmware 
causing link loss detection to fail.

The fix was to clean up bss_lost_status here before canceling 
bss_loss_work and connection_loss_work:

priv->delayed_link_loss = 0;
spin_lock(&priv->bss_loss_lock);
priv->bss_loss_status = CW1200_BSS_LOSS_NONE;
spin_unlock(&priv->bss_loss_lock);

> +			cancel_delayed_work_sync(&priv->bss_loss_work);
> +			cancel_delayed_work_sync(&priv->connection_loss_work);
> +#endif /* CONFIG_CW1200_USE_STE_EXTENSIONS */

//Pontus
