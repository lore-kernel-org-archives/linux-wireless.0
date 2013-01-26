Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f182.google.com ([209.85.213.182]:60007 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3AZRpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 12:45:50 -0500
Received: by mail-ye0-f182.google.com with SMTP id q5so221717yen.27
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 09:45:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130126171350.GB5834@localhost.localdomain>
References: <20130124205931.GB16252@localhost.localdomain>
	<20130124210028.GA22800@localhost.localdomain>
	<20130126171350.GB5834@localhost.localdomain>
Date: Sat, 26 Jan 2013 18:14:53 +0100
Message-ID: <CAOZOX0WXX__Sz7rxDMYiQm__YxPbKUbw5=Cpz_StVZP618+LGg@mail.gmail.com> (sfid-20130126_184554_129913_EFB3824A)
Subject: Re: [PATCH 2/4 v2] rt2x00: remove NOTICE
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 26, 2013 at 6:13 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> We use this macro only on 3 places - remove it and replace by other
> appropriate macros for printing messages.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> v1 -> v2 : replace NOTICE by WARNING for unknown RF chipset message.
>
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00.h    |    2 --
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++--
>  3 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index a1de95e..1791260 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -80,7 +80,7 @@ static inline bool rt2800_is_305x_soc(struct rt2x00_dev *rt2x00dev)
>             rt2x00_rf(rt2x00dev, RF3022))
>                 return true;
>
> -       NOTICE(rt2x00dev, "Unknown RF chipset on rt305x\n");
> +       WARNING(rt2x00dev, "Unknown RF chipset on rt305x\n");
>         return false;
>  }
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 8ef11b6..ad73942 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -89,8 +89,6 @@
>         DEBUG_PRINTK_PROBE(KERN_ERR, "Error", __msg, ##__args)
>  #define WARNING(__dev, __msg, __args...) \
>         DEBUG_PRINTK_MSG(__dev, KERN_WARNING, "Warning", __msg, ##__args)
> -#define NOTICE(__dev, __msg, __args...) \
> -       DEBUG_PRINTK_MSG(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
>  #define INFO(__dev, __msg, __args...) \
>         DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
>  #define DEBUG(__dev, __msg, __args...) \
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 96fffe8..07a9e10 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1440,7 +1440,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
>  #ifdef CONFIG_PM
>  int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
>  {
> -       NOTICE(rt2x00dev, "Going to sleep.\n");
> +       DEBUG(rt2x00dev, "Going to sleep.\n");
>
>         /*
>          * Prevent mac80211 from accessing driver while suspended.
> @@ -1480,7 +1480,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_suspend);
>
>  int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
>  {
> -       NOTICE(rt2x00dev, "Waking up.\n");
> +       DEBUG(rt2x00dev, "Waking up.\n");
>
>         /*
>          * Restore/enable extra components.
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
