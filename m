Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42139 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2LQJlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 04:41:01 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so6715511vby.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 01:41:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355737393-8143-1-git-send-email-machen@suse.com>
References: <1355737393-8143-1-git-send-email-machen@suse.com>
Date: Mon, 17 Dec 2012 10:41:00 +0100
Message-ID: <CAOZOX0VGuDecDuVXZZcTucPLJ6Pkm-EPZacLA4quCxvt4CwZMA@mail.gmail.com> (sfid-20121217_104106_041964_8B665125)
Subject: Re: [rt2x00-users] [PATCH] rt2800lib : Add a patch to disable/enable
 power save mode.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 17, 2012 at 10:43 AM, Chen, Chien-Chia <machen@suse.com> wrote:
> This patch is to enable/disable power save mode. rt2800lib
> disables PCI WLAN module power save mode default. It allows
> to enable the power save mode.

And what is wrong by doing this using the 'iwconfig'/'iw' tools?

> Sign-off-by: Chen, Chien-Chia <matt680209@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 197b446..8ddbf83 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -44,6 +44,13 @@
>  #include "rt2800.h"
>
>  /*
> + * Allow power save mode to be disabled.
> + */
> +static bool power_save_disabled = true;
> +module_param(power_save_disabled, bool, 0444);
> +MODULE_PARM_DESC(power_save_disabled, " Disable power save. (default: disable. 1=disable, 0=enable.)");
> +
> +/*
>   * Register access.
>   * All access to the CSR registers will go through the methods
>   * rt2800_register_read and rt2800_register_write.
> @@ -5079,7 +5086,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>         /*
>          * Disable powersaving as default on PCI devices.
>          */
> -       if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
> +       if ((rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) &&
> +           power_save_disabled)
>                 rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>
>         /*
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
