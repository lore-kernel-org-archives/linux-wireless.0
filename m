Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab1DESHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 14:07:14 -0400
Received: by iwn34 with SMTP id 34so621768iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 11:07:14 -0700 (PDT)
Date: Tue, 5 Apr 2011 23:37:00 +0530
From: Senthil Balasubramanian <senthil.lnx@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/3] ath9k: fix signal strength of received packets
Message-ID: <20110405180700.GA2430@ath9k-test>
References: <1301708388-8416-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1301708388-8416-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 02, 2011 at 03:39:46AM +0200, Felix Fietkau wrote:
> The reported RSSI values are relative to the calibrated noise floor, not
> relative to a hardcoded value of -95.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index a9c3f46..87d96c5 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -959,6 +959,9 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
>  				   struct ieee80211_rx_status *rx_status,
>  				   bool *decrypt_error)
>  {
> +	struct ath_hw *ah = common->ah;
> +	int noise;
> +
>  	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
>  
>  	/*
> @@ -979,7 +982,13 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
>  
>  	rx_status->band = hw->conf.channel->band;
>  	rx_status->freq = hw->conf.channel->center_freq;
> -	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
In some cases noisefloor values were not reliable and so using
default works for most of the cases. Please refer to our earlier
commit a59b5a5e684652eec035c869ab8911a1689c8f53. Let me see if i
can get more information.
> +
> +	if (ah->curchan)
> +		noise = ah->curchan->noisefloor;
Even otherwise, noisefloor can be zero sometimes and so it can
return incorrect signal strengths.. Please refer to some samples.

BSS 00:10:18:90:3a:9e (on wlan56)
        TSF: 110532917222 usec (1d, 06:42:12)
        freq: 2462
        beacon interval: 100
        capability: ESS (0x0001)
        signal: 50.00 dBm
        last seen: 20 ms ago
        SSID: Broadcom
        Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0
        DS Parameter set: channel 11
        ERP: NonERP_Present Use_Protection Barker_Preamble_Mode
        Extended supported rates: 6.0 9.0 12.0 48.0
        HT capabilities:

SS 00:03:7f:0b:a6:1b (on wlan56)
        TSF: 4376472960 usec (0d, 01:12:56)
        freq: 2462
        beacon interval: 100
        capability: ESS Privacy ShortPreamble (0x0031)
        signal: 60.00 dBm
        last seen: 8 ms ago
        SSID: STRESS-HB125

> +	else
> +		noise = ATH_DEFAULT_NOISE_FLOOR;
> +
> +	rx_status->signal = noise + rx_stats->rs_rssi;
>  	rx_status->antenna = rx_stats->rs_antenna;
>  	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
>  
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
