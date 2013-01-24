Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39215 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3AXVGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 16:06:12 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so4777317eek.5
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2013 13:06:11 -0800 (PST)
References: <20130124205931.GB16252@localhost.localdomain>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130124205931.GB16252@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <EDAA1034-ABF9-4CC2-9055-2340462443AE@gmail.com> (sfid-20130124_220616_595840_C50F5664)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/4] rt2x00: print warning, notice and info as default
Date: Thu, 24 Jan 2013 22:06:07 +0100
To: Stanislaw Gruszka <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 24 jan. 2013, at 21:59, Stanislaw Gruszka <stf_xl@wp.pl> wrote:

> Some messages provide useful information, but are disabled without
> CONFIG_RT2X00_DEBUG=y, so enable them by default
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Thanks for respinning.

> ---
> drivers/net/wireless/rt2x00/rt2x00.h |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 3e37c19..8ef11b6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -88,11 +88,11 @@
> #define ERROR_PROBE(__msg, __args...) \
>    DEBUG_PRINTK_PROBE(KERN_ERR, "Error", __msg, ##__args)
> #define WARNING(__dev, __msg, __args...) \
> -    DEBUG_PRINTK(__dev, KERN_WARNING, "Warning", __msg, ##__args)
> +    DEBUG_PRINTK_MSG(__dev, KERN_WARNING, "Warning", __msg, ##__args)
> #define NOTICE(__dev, __msg, __args...) \
> -    DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
> +    DEBUG_PRINTK_MSG(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
> #define INFO(__dev, __msg, __args...) \
> -    DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
> +    DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
> #define DEBUG(__dev, __msg, __args...) \
>    DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
> #define EEPROM(__dev, __msg, __args...) \
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
