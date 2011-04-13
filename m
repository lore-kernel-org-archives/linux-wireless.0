Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46358 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1DMEXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 00:23:41 -0400
Received: by qyg14 with SMTP id 14so142080qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 21:23:40 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1302646041-3917-1-git-send-email-nbd@openwrt.org>
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
	<1302646041-3917-1-git-send-email-nbd@openwrt.org>
Date: Wed, 13 Apr 2011 06:23:40 +0200
Message-ID: <BANLkTingC8r-obXeYxjbHVr2G80MCbhyMQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] ath5k: optimize tx descriptor setup
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 13, 2011 at 12:07 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Use local variables to reduce the number of load/store operations on uncached
> memory.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath5k/desc.c |   45 +++++++++++++++++++--------------
>  1 files changed, 26 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
> index 16b44ff..6996d55 100644
> --- a/drivers/net/wireless/ath/ath5k/desc.c
> +++ b/drivers/net/wireless/ath/ath5k/desc.c
> @@ -185,6 +185,12 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>        struct ath5k_hw_4w_tx_ctl *tx_ctl;
>        unsigned int frame_len;
>
> +       /*
> +        * Use local variables for these to reduce load/store access on
> +        * uncached memory
> +        */
> +       u32 txctl0 = 0, txctl1 = 0, txctl2 = 0, txctl3 = 0;
> +
>        tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
>
>        /*
> @@ -208,8 +214,9 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>        if (tx_power > AR5K_TUNE_MAX_TXPOWER)
>                tx_power = AR5K_TUNE_MAX_TXPOWER;
>
> -       /* Clear descriptor */
> -       memset(&desc->ud.ds_tx5212, 0, sizeof(struct ath5k_hw_5212_tx_desc));
> +       /* Clear descriptor status area */
> +       memset(&desc->ud.ds_tx5212.tx_stat, 0,
> +              sizeof(desc->ud.ds_tx5212.tx_stat));
>
>        /* Setup control descriptor */
>
> @@ -221,7 +228,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>        if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
>                return -EINVAL;
>
> -       tx_ctl->tx_control_0 = frame_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
> +       txctl0 = frame_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
>
>        /* Verify and set buffer length */
>
> @@ -232,21 +239,17 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>        if (pkt_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
>                return -EINVAL;
>
> -       tx_ctl->tx_control_1 = pkt_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
> +       txctl1 = pkt_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
>
> -       tx_ctl->tx_control_0 |=
> -               AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
> -               AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
> -       tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
> -                                       AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
> -       tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0,
> -                                       AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
> -       tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
> +       txctl0 |= AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
> +                 AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
> +       txctl1 |= AR5K_REG_SM(type, AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
> +       txctl2 = AR5K_REG_SM(tx_tries0, AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
> +       txctl3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
>
>  #define _TX_FLAGS(_c, _flag)                                   \
>        if (flags & AR5K_TXDESC_##_flag) {                      \
> -               tx_ctl->tx_control_##_c |=                      \
> -                       AR5K_4W_TX_DESC_CTL##_c##_##_flag;      \
> +               txctl##_c |= AR5K_4W_TX_DESC_CTL##_c##_##_flag; \
>        }
>
>        _TX_FLAGS(0, CLRDMASK);
> @@ -262,8 +265,8 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>         * WEP crap
>         */
>        if (key_index != AR5K_TXKEYIX_INVALID) {
> -               tx_ctl->tx_control_0 |= AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
> -               tx_ctl->tx_control_1 |= AR5K_REG_SM(key_index,
> +               txctl0 |= AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
> +               txctl1 |= AR5K_REG_SM(key_index,
>                                AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_IDX);
>        }
>
> @@ -274,12 +277,16 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>                if ((flags & AR5K_TXDESC_RTSENA) &&
>                                (flags & AR5K_TXDESC_CTSENA))
>                        return -EINVAL;
> -               tx_ctl->tx_control_2 |= rtscts_duration &
> -                               AR5K_4W_TX_DESC_CTL2_RTS_DURATION;
> -               tx_ctl->tx_control_3 |= AR5K_REG_SM(rtscts_rate,
> +               txctl2 |= rtscts_duration & AR5K_4W_TX_DESC_CTL2_RTS_DURATION;
> +               txctl3 |= AR5K_REG_SM(rtscts_rate,
>                                AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE);
>        }
>
> +       tx_ctl->tx_control_0 = txctl0;
> +       tx_ctl->tx_control_1 = txctl1;
> +       tx_ctl->tx_control_2 = txctl2;
> +       tx_ctl->tx_control_3 = txctl3;
> +
>        return 0;
>  }
>
> --
> 1.7.3.2
>

Looks like this v2 did not found its way to wireless-next [1].

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=c5e0a88aa2e0f42cdb4c79c977c52f6bc38ec160
