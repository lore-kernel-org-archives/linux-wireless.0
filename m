Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:65006 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbZCBRnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 12:43:06 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2887592tib.23
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 09:43:03 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18860.6782.4168.588808@gargle.gargle.HOWL> (sfid-20090302_184311_107465_23216F73)
Date: Mon, 2 Mar 2009 23:12:22 +0530
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Handle power modes in isr for power save.
In-Reply-To: <20090302145514.GB4660@myhost.users.atheros.com>
References: <20090302145514.GB4660@myhost.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> Restore network sleep mode in isr if power save is enabled.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath9k/ath9k.h |    3 ++-
>  drivers/net/wireless/ath9k/main.c  |    2 ++
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
> index 6481ea4..69292f3 100644
> --- a/drivers/net/wireless/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath9k/ath9k.h
> @@ -677,7 +677,8 @@ static inline void ath9k_ps_wakeup(struct ath_softc *sc)
>  static inline void ath9k_ps_restore(struct ath_softc *sc)
>  {
>  	if (atomic_dec_and_test(&sc->ps_usecount))
> -		if (sc->hw->conf.flags & IEEE80211_CONF_PS)
> +		if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
> +		    !(sc->sc_flags & SC_OP_WAIT_FOR_BEACON))
>  			ath9k_hw_setpower(sc->sc_ah,
>  					  sc->sc_ah->restore_mode);
>  }
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index fd6cc73..96194ef 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -516,6 +516,7 @@ irqreturn_t ath_isr(int irq, void *dev)
>  			return IRQ_NONE;
>  
>  		sc->intrstatus = status;
> +		ath9k_ps_wakeup(sc);
>  
>  		if (status & ATH9K_INT_FATAL) {
>  			/* need a chip reset */
> @@ -581,6 +582,7 @@ irqreturn_t ath_isr(int irq, void *dev)
>  				sched = true;
>  			}
>  		}
> +		ath9k_ps_restore(sc);
>  	} while (0);
>  

This needs proper locking.

Sujith
