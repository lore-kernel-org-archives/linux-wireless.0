Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:35134 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0CIMRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:17:12 -0500
Received: by ey-out-2122.google.com with SMTP id 25so939165eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:17:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075533.30616.26457.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075533.30616.26457.stgit@void>
Date: Tue, 9 Mar 2010 14:17:10 +0200
Message-ID: <40f31dec1003090417l4d61ff9apf9aa921901a30d85@mail.gmail.com>
Subject: Re: [PATCH 04/13] ath5k: fix TSF reset
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> to reset the TSF, AR5K_BEACON_RESET_TSF has to be 1, not 0. also we have a
> function for that so use it.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/reset.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index a35a7db..c780b55 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -1379,11 +1379,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>                ath5k_hw_set_sleep_clock(ah, true);
>
>        /*
> -        * Disable beacons and reset the register
> +        * Disable beacons and reset the TSF
>         */
> -       AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE |
> -                       AR5K_BEACON_RESET_TSF);
> -
> +       AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
> +       ath5k_hw_reset_tsf(ah);
>        return 0;
>  }
>
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
