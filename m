Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:54942 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbXKWL14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 06:27:56 -0500
Received: by an-out-0708.google.com with SMTP id d31so641618and
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 03:27:55 -0800 (PST)
Message-ID: <40f31dec0711230327w6e929b1ay7769af8553e713b0@mail.gmail.com> (sfid-20071123_112758_230260_0295C47B)
Date: Fri, 23 Nov 2007 13:27:55 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 3/3] ath5k: export signal quality values
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
In-Reply-To: <1195815123-22375-4-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-2-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-3-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-4-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/23, Bruno Randolf <bruno@thinktube.com>:
> store the last noise floor in ath5k_hw and report signal, noise and link
> quality values to mac80211, which in turn makes them show up in iwconfig.
>
> ath5k.h, phy.c:
> Changes-licensed-under: ISC
>
> base.c:
> Changes-licensed-under: 3-clause-BSD
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>  drivers/net/wireless/ath5k/ath5k.h |    3 +++
>  drivers/net/wireless/ath5k/base.c  |   22 ++++++++++++++++++++--
>  drivers/net/wireless/ath5k/phy.c   |    2 ++
>  3 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> index 5bcbbf9..2e13d79 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -1003,6 +1003,9 @@ struct ath5k_hw {
>                 struct ieee80211_channel r_last_channel;
>         } ah_radar;
>
> +       /* noise floor from last periodic calibration */
> +       s32                     ah_noise_floor;
> +
>         /*
>          * Function pointers
>          */
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 444e4a7..f288858 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -435,7 +435,10 @@ ath5k_pci_probe(struct pci_dev *pdev,
>         hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
>         hw->extra_tx_headroom = 2;
>         hw->channel_change_time = 5000;
> -       hw->max_rssi = 127; /* FIXME: get a real value for this. */
> +       /* these names are misleading */
> +       hw->max_rssi = -110; /* signal in dBm */
> +       hw->max_noise = -110; /* noise in dBm */
> +       hw->max_signal = 100; /* we will provide a percentage based on rssi */
>         sc = hw->priv;
>         sc->hw = hw;
>         sc->pdev = pdev;
> @@ -1721,7 +1724,22 @@ accept:
>                 rxs.freq = sc->curchan->freq;
>                 rxs.channel = sc->curchan->chan;
>                 rxs.phymode = sc->curmode;
> -               rxs.ssi = ds->ds_rxstat.rs_rssi;
> +
> +               /*
> +                * signal quality:
> +                * the names here are misleading and the usage of these
> +                * values by iwconfig makes it even worse
> +                */
> +               /* noise floor in dBm, from the last noise calibration */
> +               rxs.noise = sc->ah->ah_noise_floor;
> +               /* signal level in dBm */
> +               rxs.ssi = rxs.noise + ds->ds_rxstat.rs_rssi;
> +               /*
> +                * "signal" is actually displayed as Link Quality by iwconfig
> +                * we provide a percentage based on rssi (assuming max rssi 64)
> +                */
> +               rxs.signal = ds->ds_rxstat.rs_rssi * 100 / 64;
> +
>                 rxs.antenna = ds->ds_rxstat.rs_antenna;
>                 rxs.rate = ds->ds_rxstat.rs_rate;
>                 rxs.flag |= ath5k_rx_decrypted(sc, ds, skb);
> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> index f250c2e..52caf8e 100644
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -1562,6 +1562,8 @@ ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
>                 return -EIO;
>         }
>
> +       ah->ah_noise_floor = noise_floor;
> +
>         return 0;
>  }
>
> --
> 1.5.3.4
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
