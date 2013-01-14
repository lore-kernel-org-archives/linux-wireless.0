Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45816 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab3ANWyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 17:54:17 -0500
Received: by mail-ie0-f172.google.com with SMTP id c13so6157938ieb.31
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2013 14:54:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358179006-72370-1-git-send-email-nbd@openwrt.org>
References: <1358179006-72370-1-git-send-email-nbd@openwrt.org>
From: Robert Shade <robert.shade@gmail.com>
Date: Mon, 14 Jan 2013 17:53:54 -0500
Message-ID: <CAMgrJ3bVzSP7CYpaG7m42nyE-jTR_eQ2z4TT6RjDQojBv2M5Ug@mail.gmail.com> (sfid-20130114_235421_585322_5675920B)
Subject: Re: [PATCH 3.8] ath9k: disable the tasklet before taking the PCU lock
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the quick turnaround.  I've been testing it for 6+ hrs now
with no issue.

On Mon, Jan 14, 2013 at 10:56 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Fixes a reported CPU soft lockup where the tasklet tries to acquire the
> lock and blocks while ath_prepare_reset (holding the lock) waits for it
> to complete.
>
> Cc: stable@vger.kernel.org
> Reported-by: Robert Shade <robert.shade@gmail.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 17a5eec..0fb53d6 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -196,16 +196,12 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
>         ath9k_debug_samp_bb_mac(sc);
>         ath9k_hw_disable_interrupts(ah);
>
> -       tasklet_disable(&sc->intr_tq);
> -
>         if (!ath_stoprecv(sc))
>                 ret = false;
>
>         if (!ath_drain_all_txq(sc, retry_tx))
>                 ret = false;
>
> -       tasklet_enable(&sc->intr_tq);
> -
>         return ret;
>  }
>
> @@ -262,6 +258,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>
>         __ath_cancel_work(sc);
>
> +       tasklet_disable(&sc->intr_tq);
>         spin_lock_bh(&sc->sc_pcu_lock);
>
>         if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
> @@ -296,6 +293,8 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>
>  out:
>         spin_unlock_bh(&sc->sc_pcu_lock);
> +       tasklet_enable(&sc->intr_tq);
> +
>         return r;
>  }
>
> --
> 1.8.0.2
>
