Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44046 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab1GDK13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 06:27:29 -0400
Received: by yia27 with SMTP id 27so1897799yia.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 03:27:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309758467-1712-3-git-send-email-nbd@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
Date: Mon, 4 Jul 2011 13:27:28 +0300
Message-ID: <CAFtRNNystdzv4MXCA-i6VPks9Fy5ToHX7k+PmjYfPJhxS0fRWA@mail.gmail.com> (sfid-20110704_122732_669043_EF5ACAAA)
Subject: Re: [PATCH 3/8] ath5k: fix reference clock frequency for spur
 mitigation on AR2413
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Felix Fietkau <nbd@openwrt.org>:
> AR2413 uses the same reference clock as AR5413
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index f66124a..c65c33a 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -105,6 +105,7 @@ bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
>
>        if ((ah->ah_radio == AR5K_RF5112) ||
>        (ah->ah_radio == AR5K_RF5413) ||
> +       (ah->ah_radio == AR5K_RF2413) ||
>        (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
>                refclk_freq = 40;
>        else
> --
> 1.7.3.2
>

If that's true we should also change it on set_sleep_clock (patch 6 on
your series).



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
