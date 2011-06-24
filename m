Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15265 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1FXMFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 08:05:08 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath9k: Fix locking issue during tx completion
Date: Fri, 24 Jun 2011 12:05:07 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC88012D5B7E@nasanexd02b.na.qualcomm.com> (sfid-20110624_140514_836095_2CCDF9A5)
References: <1308915145-6282-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1308915145-6282-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> index 0b6e3b6..9c085d1 100644
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -385,7 +385,9 @@ void ath_beacon_tasklet(unsigned long data)
>                         ath_dbg(common, ATH_DBG_BSTUCK,
>                                 "beacon is officially stuck\n");
>                         sc->sc_flags |= SC_OP_TSF_RESET;
> +                       spin_lock_bh(&sc->sc_pcu_lock);
>                         ath_reset(sc, true);
> +                       spin_unlock_bh(&sc->sc_pcu_lock);
>                 }
> 
> @@ -674,7 +679,9 @@ void ath9k_tasklet(unsigned long data)
> 
>         if ((status & ATH9K_INT_FATAL) ||
>             (status & ATH9K_INT_BB_WATCHDOG)) {
> +               spin_lock_bh(&sc->sc_pcu_lock);
>                 ath_reset(sc, true);
> +               spin_unlock_bh(&sc->sc_pcu_lock);
>                 return;
>         }

spin_lock_bh is not required in bh contexts. will send v2 patch.

--
Rajkumar