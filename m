Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:63362 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184AbZKXQLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 11:11:33 -0500
Received: by iwn1 with SMTP id 1so576672iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 08:11:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19150.47688.575023.623047@gargle.gargle.HOWL>
References: <19150.47688.575023.623047@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 24 Nov 2009 08:11:19 -0800
Message-ID: <43e72e890911240811t2e2a70a3k98ca2516ca5dc4b6@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix TX hang poll routine
To: Sujith <Sujith.Manoharan@atheros.com>, Greg KH <greg@kroah.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 8, 2009 at 8:21 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> When TX is hung, the chip is reset. Ensure that
> the chip is awake by using the PS wrappers.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index a8620b1..2a4efcb 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -2079,7 +2079,9 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
>        if (needreset) {
>                ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
>                          "tx hung, resetting the chip\n");
> +               ath9k_ps_wakeup(sc);
>                ath_reset(sc, false);
> +               ath9k_ps_restore(sc);
>        }
>
>        ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
> --

John this should be pulled to 2.6.32 if possible. It would do the
actual reset and fix TX properly if we are asleep.

  Luis
