Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45618 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0CCXax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 18:30:53 -0500
Received: by gyd8 with SMTP id 8so54639gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 15:30:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
References: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
Date: Wed, 3 Mar 2010 18:30:53 -0500
Message-ID: <b6c5339f1003031530l2a89c265t98a8560bdbf9c758@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fixing retries in ath5k_hw_setup_4word_tx_desc
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Blaich <ablaich@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 10:30 AM, Andrew Blaich <ablaich@gmail.com> wrote:
> This Patch:
>
> The rate control algorithm, default is Minstrel for ath5k, determines
> the number of retries to use for each rate.  However, there exists in
> ath5k_hw_setup_4word_tx_desc (which is called for AR5212 like devices)
> a set number of retries defined by AR5K_TUNE_HWTXTRIES.  The set
> number of tries is added to the tx_tries0 variable setup by the rate
> control algorithm.  This changes the number of retries the rate
> control algorithm considers necessary.  By removing the
> AR5K_TUNE_HWTXTRIES from the retry calculation the rate control
> algorithm is given control over the number of retries.
>
>
> Signed-off-by:: Andrew Blaich <ablaich@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/desc.c
> b/drivers/net/wireless/ath/ath5k/desc.c
> index dc30a2b..c18d8d4 100644
> --- a/drivers/net/wireless/ath/ath5k/desc.c
> +++ b/drivers/net/wireless/ath/ath5k/desc.c
> @@ -229,7 +229,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>                AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
>        tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
>                                        AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
> -       tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
> +       tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0,

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com
