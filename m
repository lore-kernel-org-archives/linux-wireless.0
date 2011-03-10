Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43298 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1CJVzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 16:55:22 -0500
Received: by fxm17 with SMTP id 17so438347fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 13:55:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299764499-76251-3-git-send-email-nbd@openwrt.org>
References: <1299764499-76251-1-git-send-email-nbd@openwrt.org>
	<1299764499-76251-2-git-send-email-nbd@openwrt.org>
	<1299764499-76251-3-git-send-email-nbd@openwrt.org>
Date: Thu, 10 Mar 2011 16:55:21 -0500
Message-ID: <AANLkTim69R72cvpd=ACxfP8+xGNZoXRJa43=RAPzxiBv@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ath9k: fix the .flush driver op implementation
From: Mark Mentovai <mark@moxienet.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, vasanth@atheros.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
[...]
>  static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
>  {
>        struct ath_softc *sc = hw->priv;
> +       int timeout = 200; /* ms */
> +       int i, j;
>
> +       ath9k_ps_wakeup(sc);
>        mutex_lock(&sc->mutex);
>
>        cancel_delayed_work_sync(&sc->tx_complete_work);
>
> +       if (drop)
> +               timeout = 1;
>
> +       for (j = 0; j < timeout; j++) {
> +               int npend = 0;
> +               for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
> +                       if (!ATH_TXQ_SETUP(sc, i))
> +                               continue;
>
> +                       npend += ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
>                }
> +
> +               if (!npend)
> +                   goto out;
> +
> +               usleep_range(1000, 2000);
>        }
>
> +       if (!ath_drain_all_txq(sc, false))
>                ath_reset(sc, false);
>
> +out:
>        ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
>        mutex_unlock(&sc->mutex);
> +       ath9k_ps_restore(sc);
>  }

My only comment here is that you still hit the sleep even on the last
pass through the loop when it isn’t strictly necessary. Practically,
the only place this would be realized is the case where |drop| is set.
In this scenario, the code formerly didn’t sleep at all, but now can
sleep for 1-2ms. I couldn’t find any calls to drv_flush with |drop|
set, though, so it might just be an academic concern.

The delay loops in v2 patches 2/4 and 4/4 also share this
characteristic (although with shorter timeouts, and delays instead of
sleeps). Have you considered restructuring these loops to avoid the
final waits?

This is admittedly a pretty minor thing.
