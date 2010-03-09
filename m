Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:45747 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab0CIMTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:19:01 -0500
Received: by mail-ew0-f216.google.com with SMTP id 8so654430ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:19:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075554.30616.12221.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075554.30616.12221.stgit@void>
Date: Tue, 9 Mar 2010 14:19:00 +0200
Message-ID: <40f31dec1003090419m38145df9u46c48b7cc37fd3ec@mail.gmail.com>
Subject: Re: [PATCH 08/13] ath5k: remove ah_gpio_npins
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> it's never used and we have a newer implementation in gpio.c.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h |    2 --
>  drivers/net/wireless/ath/ath5k/caps.c  |    3 ---
>  2 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index 54f35ae..7721d7d 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1068,8 +1068,6 @@ struct ath5k_hw {
>        u8                      ah_def_ant;
>        bool                    ah_software_retry;
>
> -       int                     ah_gpio_npins;
> -
>        struct ath5k_capabilities ah_capabilities;
>
>        struct ath5k_txq_info   ah_txq[AR5K_NUM_TX_QUEUES];
> diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
> index 367a6c7..e618e71 100644
> --- a/drivers/net/wireless/ath/ath5k/caps.c
> +++ b/drivers/net/wireless/ath/ath5k/caps.c
> @@ -102,9 +102,6 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
>                }
>        }
>
> -       /* GPIO */
> -       ah->ah_gpio_npins = AR5K_NUM_GPIO;
> -
>        /* Set number of supported TX queues */
>        if (ah->ah_version == AR5K_AR5210)
>                ah->ah_capabilities.cap_queues.q_tx_num =
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
