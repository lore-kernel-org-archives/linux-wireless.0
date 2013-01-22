Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61056 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3AVTGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 14:06:48 -0500
Received: by mail-ea0-f181.google.com with SMTP id i13so2086245eaa.26
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 11:06:47 -0800 (PST)
References: <20130122164914.GB25134@localhost.localdomain>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130122164914.GB25134@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <2BB3EFC8-0B36-47DA-9FE2-13159E367F85@gmail.com> (sfid-20130122_200651_034817_E1EF7BBE)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: print chip and firmware version by default
Date: Tue, 22 Jan 2013 19:58:58 +0100
To: Stanislaw Gruszka <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Sent from my iPad

On 22 jan. 2013, at 17:49, Stanislaw Gruszka <stf_xl@wp.pl> wrote:

> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
> drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
> 2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 3e37c19..bef449c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -92,7 +92,7 @@
> #define NOTICE(__dev, __msg, __args...) \
>    DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
> #define INFO(__dev, __msg, __args...) \
> -    DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
> +    DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
> #define DEBUG(__dev, __msg, __args...) \
>    DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
> #define EEPROM(__dev, __msg, __args...) \

I think this change is good, but we should also change WARNING and NOTICE. Otherwise they won't be displayed if CONFIG_RT2X00_DEBUG is disabled, but INFO will, which would be strange.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index ed7a1bb..20c6ecc 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -731,9 +731,9 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
>    queue->aifs = params->aifs;
>    queue->txop = params->txop;
> 
> -    INFO(rt2x00dev,
> -         "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
> -         queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
> +    DEBUG(rt2x00dev,
> +          "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
> +          queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
> 
>    return 0;
> }
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
