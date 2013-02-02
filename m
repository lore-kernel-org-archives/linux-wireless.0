Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f173.google.com ([209.85.161.173]:62744 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3BBX41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 18:56:27 -0500
Received: by mail-gg0-f173.google.com with SMTP id b6so115911ggm.32
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2013 15:56:26 -0800 (PST)
Message-ID: <510DA640.6000405@gmail.com> (sfid-20130203_005629_903527_1EA318D5)
Date: Sun, 03 Feb 2013 00:50:24 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/4] rt2x00: print warning, notice and info as default
References: <20130124205931.GB16252@localhost.localdomain>
In-Reply-To: <20130124205931.GB16252@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2013 09:59 PM, Stanislaw Gruszka wrote:

> Some messages provide useful information, but are disabled without
> CONFIG_RT2X00_DEBUG=y, so enable them by default
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> ---
>  drivers/net/wireless/rt2x00/rt2x00.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 3e37c19..8ef11b6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -88,11 +88,11 @@
>  #define ERROR_PROBE(__msg, __args...) \
>  	DEBUG_PRINTK_PROBE(KERN_ERR, "Error", __msg, ##__args)
>  #define WARNING(__dev, __msg, __args...) \
> -	DEBUG_PRINTK(__dev, KERN_WARNING, "Warning", __msg, ##__args)
> +	DEBUG_PRINTK_MSG(__dev, KERN_WARNING, "Warning", __msg, ##__args)
>  #define NOTICE(__dev, __msg, __args...) \
> -	DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
> +	DEBUG_PRINTK_MSG(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
>  #define INFO(__dev, __msg, __args...) \
> -	DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
> +	DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
>  #define DEBUG(__dev, __msg, __args...) \
>  	DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
>  #define EEPROM(__dev, __msg, __args...) \

This patch was applied twice. The old one and this version.
See:
28f2bce9f8bbf704c86f8c684337f82c51592c81
def64521572d8330bfa6d855e278507100fdf180
