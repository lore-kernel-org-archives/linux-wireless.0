Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53764 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab0LCGfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 01:35:07 -0500
Received: by qwb7 with SMTP id 7so9253838qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 22:35:06 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101203040713.GC2988@makis.mantri>
References: <20101203040713.GC2988@makis.mantri>
Date: Fri, 3 Dec 2010 07:35:06 +0100
Message-ID: <AANLkTikG=uHQ5gNnKgar80Ssc6UTiqAnZhuHXHaBGFWM@mail.gmail.com>
Subject: Re: [PATCH 3/6] ath5k: Disable ANI during reset
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

On Fri, Dec 3, 2010 at 5:07 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * Stop ANI durring reset to prevent false PHY error reports
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 047b2a0..6edfa9f 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2504,7 +2504,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
>                                                        bool skip_pcu)
>  {
>        struct ath5k_hw *ah = sc->ah;
> -       int ret;
> +       int ret, ani_mode;
>
>        ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
>
> @@ -2512,6 +2512,12 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
>        synchronize_irq(sc->pdev->irq);
>        stop_tasklets(sc);
>
> +       /* Save ani mode and disable ANI durring
> +        * reset. If we don't we might get false
> +        * PHY error interrupts. */
> +       ani_mode = ah->ah_sc->ani_state.ani_mode;
> +       ath5k_ani_init(ah, ATH5K_ANI_MODE_OFF);
> +
>        /* We are going to empty hw queues
>         * so we should also free any remaining
>         * tx buffers */
> @@ -2533,7 +2539,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
>                goto err;
>        }
>
> -       ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
> +       ath5k_ani_init(ah, ani_mode);
>
>        ah->ah_cal_next_full = jiffies;
>        ah->ah_cal_next_ani = jiffies;
>
