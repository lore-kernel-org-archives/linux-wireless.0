Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34510 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1LJLp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 06:45:28 -0500
Received: by wgbds13 with SMTP id ds13so4927007wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 03:45:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323385619-7454-6-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
	<1323385619-7454-6-git-send-email-frankyl@broadcom.com>
Date: Sat, 10 Dec 2011 12:45:26 +0100
Message-ID: <CACna6rwVVEYf0F6HZoMKrJg2NT3c4SPb6OH34LsTm8NR+BtsRA@mail.gmail.com> (sfid-20111210_124531_742806_642535D4)
Subject: Re: [PATCH 05/23] bcma: add set/mask macros for 16-bit register access
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/9 Franky Lin <frankyl@broadcom.com>:
> From: Arend van Spriel <arend@broadcom.com>
>
> The BCMA header only had definitions for 32-bit register access. Used
> those as a template for the 16-bit flavour. Also changed them to inline
> functions to be on the safe side. As offset parameter is used twice there
> would be a problem when used like this: bcma_set32(core, offset++, val);
>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Alwin Beukers <alwin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> ---
>  include/linux/bcma/bcma.h |   32 ++++++++++++++++++++++++++------
>  1 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index 4d4b59d..de6057f 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -254,12 +254,32 @@ void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
>        core->bus->ops->awrite32(core, offset, value);
>  }
>
> -#define bcma_mask32(cc, offset, mask) \
> -       bcma_write32(cc, offset, bcma_read32(cc, offset) & (mask))
> -#define bcma_set32(cc, offset, set) \
> -       bcma_write32(cc, offset, bcma_read32(cc, offset) | (set))
> -#define bcma_maskset32(cc, offset, mask, set) \
> -       bcma_write32(cc, offset, (bcma_read32(cc, offset) & (mask)) | (set))
> +static inline void bcma_mask32(struct bcma_device *cc, u16 offset, u32 mask)
> +{
> +       bcma_write32(cc, offset, bcma_read32(cc, offset) & mask);
> +}
> +static inline void bcma_set32(struct bcma_device *cc, u16 offset, u32 set)
> +{
> +       bcma_write32(cc, offset, bcma_read32(cc, offset) | set);
> +}
> +static inline void bcma_maskset32(struct bcma_device *cc,
> +                                 u16 offset, u32 mask, u32 set)
> +{
> +       bcma_write32(cc, offset, (bcma_read32(cc, offset) & mask) | set);
> +}

What is an advantage of static inline over define?

-- 
Rafał
