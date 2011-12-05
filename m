Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40638 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab1LET70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 14:59:26 -0500
Received: by ggnr5 with SMTP id r5so5400698ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 11:59:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322923766-14379-2-git-send-email-hauke@hauke-m.de>
References: <1322923766-14379-1-git-send-email-hauke@hauke-m.de> <1322923766-14379-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 5 Dec 2011 11:59:05 -0800
Message-ID: <CAB=NE6XHuopzh9FU018N_dSAU7Fd4TvnRqeq8gdXqDagdQEH1Q@mail.gmail.com> (sfid-20111205_205930_193668_425D9044)
Subject: Re: [PATCH 2/2] compat: add module_usb_driver and module_platform_driver
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied and pushed all of these and the compat ones, thanks sooo much!!!~

  Luis

On Sat, Dec 3, 2011 at 9:49 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-3.2.h |    9 +++++++++
>  include/linux/compat-3.3.h |   35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
> index db0f648..fb9ef68 100644
> --- a/include/linux/compat-3.2.h
> +++ b/include/linux/compat-3.2.h
> @@ -55,6 +55,15 @@ static inline char *hex_byte_pack(char *buf, u8 byte)
>        return buf;
>  }
>
> +/* module_platform_driver() - Helper macro for drivers that don't do
> + * anything special in module init/exit.  This eliminates a lot of
> + * boilerplate.  Each module may only use this macro once, and
> + * calling it replaces module_init() and module_exit()
> + */
> +#define module_platform_driver(__platform_driver) \
> +        module_driver(__platform_driver, platform_driver_register, \
> +                        platform_driver_unregister)
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
>
>  #endif /* LINUX_3_2_COMPAT_H */
> diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
> index 9383a6e..821333c 100644
> --- a/include/linux/compat-3.3.h
> +++ b/include/linux/compat-3.3.h
> @@ -33,6 +33,41 @@ static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
>
>  typedef u32 netdev_features_t;
>
> +/* source include/linux/device.h */
> +/**
> + * module_driver() - Helper macro for drivers that don't do anything
> + * special in module init/exit. This eliminates a lot of boilerplate.
> + * Each module may only use this macro once, and calling it replaces
> + * module_init() and module_exit().
> + *
> + * Use this macro to construct bus specific macros for registering
> + * drivers, and do not use it on its own.
> + */
> +#define module_driver(__driver, __register, __unregister) \
> +static int __init __driver##_init(void) \
> +{ \
> +       return __register(&(__driver)); \
> +} \
> +module_init(__driver##_init); \
> +static void __exit __driver##_exit(void) \
> +{ \
> +       __unregister(&(__driver)); \
> +} \
> +module_exit(__driver##_exit);
> +
> +/* source include/linux/usb.h */
> +/**
> + * module_usb_driver() - Helper macro for registering a USB driver
> + * @__usb_driver: usb_driver struct
> + *
> + * Helper macro for USB drivers which do not do anything special in module
> + * init/exit. This eliminates a lot of boilerplate. Each module may only
> + * use this macro once, and calling it replaces module_init() and module_exit()
> + */
> +#define module_usb_driver(__usb_driver) \
> +       module_driver(__usb_driver, usb_register, \
> +                      usb_deregister)
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
>
>  #endif /* LINUX_3_3_COMPAT_H */
> --
> 1.7.5.4
>
