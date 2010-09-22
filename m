Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61302 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0IVQz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 12:55:28 -0400
Received: by fxm12 with SMTP id 12so157838fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 09:55:27 -0700 (PDT)
Message-ID: <4C9A34FB.5020809@gmail.com>
Date: Wed, 22 Sep 2010 18:55:23 +0200
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 3/4] compat: move pmcia backport code into compat-2.6.36.h
References: <1284918131-32065-1-git-send-email-hauke@hauke-m.de> <1284918131-32065-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284918131-32065-3-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

As on 2010-09-19 19:42, Hauke Mehrtens did write:
> We have all out backport headers in include/linux/compat-2.6.XX.h also the pcmcia
> part there.

I'm not sure if this won't make all the compat-wireless modules depend
on pcmcia.ko for kernels < 2.6.36 where
pcmcia_access_configuation_register() is exported. Even if someone is
only building selected drivers like iwlwifi or ath.


> 
> CC: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-2.6.36.h |   29 +++++++++++++++++++++++++++++
>  include/pcmcia/ds.h           |   36 ------------------------------------
>  2 files changed, 29 insertions(+), 36 deletions(-)
>  delete mode 100644 include/pcmcia/ds.h
> 
> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
> index 2df34d6..1d929d7 100644
> --- a/include/linux/compat-2.6.36.h
> +++ b/include/linux/compat-2.6.36.h
> @@ -6,6 +6,8 @@
>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
>  
>  #include <linux/usb.h>
> +#include <pcmcia/cistpl.h>
> +#include <pcmcia/ds.h>
>  
>  #define kparam_block_sysfs_write(a)
>  #define kparam_unblock_sysfs_write(a)
> @@ -27,6 +29,33 @@ extern struct urb *compat_usb_get_from_anchor(struct usb_anchor *anchor);
>  extern void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
>  #endif
>  
> +/**
> + * pcmcia_read_config_byte() - read a byte from a card configuration register
> + *
> + * pcmcia_read_config_byte() reads a byte from a configuration register in
> + * attribute memory.
> + */
> +static inline int pcmcia_read_config_byte(struct pcmcia_device *p_dev, off_t where, u8 *val)
> +{
> +        int ret;
> +        conf_reg_t reg = { 0, CS_READ, where, 0 };
> +        ret = pcmcia_access_configuration_register(p_dev, &reg);
> +        *val = reg.Value;
> +        return ret;
> +}
> +
> +/**
> + * pcmcia_write_config_byte() - write a byte to a card configuration register
> + *
> + * pcmcia_write_config_byte() writes a byte to a configuration register in
> + * attribute memory.
> + */
> +static inline int pcmcia_write_config_byte(struct pcmcia_device *p_dev, off_t where, u8 val)
> +{
> +	conf_reg_t reg = { 0, CS_WRITE, where, val };
> +	return pcmcia_access_configuration_register(p_dev, &reg);
> +}
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
>  
>  #endif /* LINUX_26_36_COMPAT_H */
> diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
> deleted file mode 100644
> index fc43703..0000000
> --- a/include/pcmcia/ds.h
> +++ /dev/null
> @@ -1,36 +0,0 @@
> -#ifndef _COMPAT_PCMCIA_DS_H
> -#define _COMPAT_PCMCIA_DS_H
> -#include <linux/version.h>
> -
> -#include_next <pcmcia/ds.h>
> -
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
> -/**
> - * pcmcia_read_config_byte() - read a byte from a card configuration register
> - *
> - * pcmcia_read_config_byte() reads a byte from a configuration register in
> - * attribute memory.
> - */
> -static inline int pcmcia_read_config_byte(struct pcmcia_device *p_dev, off_t where, u8 *val)
> -{
> -        int ret;
> -        conf_reg_t reg = { 0, CS_READ, where, 0 };
> -        ret = pcmcia_access_configuration_register(p_dev, &reg);
> -        *val = reg.Value;
> -        return ret;
> -}
> -
> -/**
> - * pcmcia_write_config_byte() - write a byte to a card configuration register
> - *
> - * pcmcia_write_config_byte() writes a byte to a configuration register in
> - * attribute memory.
> - */
> -static inline int pcmcia_write_config_byte(struct pcmcia_device *p_dev, off_t where, u8 val)
> -{
> -	conf_reg_t reg = { 0, CS_WRITE, where, val };
> -	return pcmcia_access_configuration_register(p_dev, &reg);
> -}
> -#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36) */
> -
> -#endif

-- 
Kshitij Kulshreshtha

Institut für Mathematik,
Universität Paderborn,
Warburger Straße 100,
33098 Paderborn.

Büro: A3.235

Privatanschrift:
Arnikaweg 62
33100 Paderborn.
