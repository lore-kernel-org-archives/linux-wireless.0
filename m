Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54808 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1ASTZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 14:25:16 -0500
Received: by iwn9 with SMTP id 9so1189908iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 11:25:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295452063-13828-2-git-send-email-rmanoharan@atheros.com>
References: <1295452063-13828-1-git-send-email-rmanoharan@atheros.com> <1295452063-13828-2-git-send-email-rmanoharan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 Jan 2011 11:24:56 -0800
Message-ID: <AANLkTimSBJxY0f6G6BLcLbsDySvn6KZQu=Vdj134yZLD@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: Fix power save usage count imbalance on deinit
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 7:47 AM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> Upon unloading the driver, the ps_usecount is incremented
> before configuring gpio registers in deinit_device.
> But it is failed to restore the ps_usecount after that.
> The problem is that the chip is moved to FULL SLEEP
> by radio_disable when mac80211 is reporting as idle
> though ps_usecount is not zero.
>
> This patch retores ps_usecount properly and ensures that
> the chip is always moved to full sleep only if ps usage
> counte is zero which helps in debugging. And also fixes
> the following warning.
>
> ath: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
> ath: Could not stop RX, we could be confusing the DMA engine when we
> start RX up
> ------------[ cut here ]------------
> WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
> ath_stoprecv+0xf4/0x100 [ath9k]()
>
> Cc: stable@kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c |    2 ++
>  drivers/net/wireless/ath/ath9k/main.c |    2 --
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 767d8b8..b38c874 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -824,6 +824,8 @@ void ath9k_deinit_device(struct ath_softc *sc)
>        wiphy_rfkill_stop_polling(sc->hw->wiphy);
>        ath_deinit_leds(sc);
>
> +       ath9k_ps_restore(sc);
> +
>        for (i = 0; i < sc->num_sec_wiphy; i++) {
>                struct ath_wiphy *aphy = sc->sec_wiphy[i];
>                if (aphy == NULL)
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index c03184e..aff1c72 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -966,8 +966,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
>
>        spin_unlock_bh(&sc->sc_pcu_lock);
>        ath9k_ps_restore(sc);
> -
> -       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);

Are you sure this hunk does not regress the suspend/resume case when
using the new dbus API?

  Luis
