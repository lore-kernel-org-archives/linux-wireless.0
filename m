Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:4010 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbbAPII0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 03:08:26 -0500
Date: Fri, 16 Jan 2015 09:00:26 +0100 (CET)
From: Rico Derrer <rico.derrer@neratec.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Message-ID: <377854068.83121.1421395226029.JavaMail.zimbra@neratec.com> (sfid-20150116_090832_865795_8690E511)
In-Reply-To: <1459283661.83111.1421395216463.JavaMail.zimbra@neratec.com>
References: <1421241456-29085-1-git-send-email-nbd@openwrt.org>
Subject: Re: [PATCH 3.19] ath9k: fix race condition in irq processing during
 hardware reset
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix

Felix Fietkau wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> b/drivers/net/wireless/ath/ath9k/main.c
> index 9a72640..62b0bf4 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -285,6 +285,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct
> ath9k_channel *hchan)
> 
> __ath_cancel_work(sc);
> 
> + disable_irq(sc->irq);
> tasklet_disable(&sc->intr_tq);
> tasklet_disable(&sc->bcon_tasklet);
> spin_lock_bh(&sc->sc_pcu_lock);
> @@ -331,6 +332,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct
> ath9k_channel *hchan)
> r = -EIO;
> 
> out:
> + enable_irq(sc->irq);
> spin_unlock_bh(&sc->sc_pcu_lock);
> tasklet_enable(&sc->bcon_tasklet);
> tasklet_enable(&sc->intr_tq);

This part completely blocks the system on a AR9350. Loading the module works but configuring it hangs the system until watchdog restarts it.

Regards
Rico
