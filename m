Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36473 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbcKEM5A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Nov 2016 08:57:00 -0400
Received: by mail-wm0-f65.google.com with SMTP id c17so8051932wmc.3
        for <linux-wireless@vger.kernel.org>; Sat, 05 Nov 2016 05:57:00 -0700 (PDT)
Subject: Re: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <ebc4779b-a68b-f3b3-c8fc-87db9401a603@kresin.me> (sfid-20161105_135705_130921_4F4901C6)
Date: Sat, 5 Nov 2016 13:56:58 +0100
MIME-Version: 1.0
In-Reply-To: <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

02.11.2016 15:11, Stanislaw Gruszka:
> We can calculate BA window size (max number of pending frames not
> yet block acked) of remote station using Maximum A-MPDU length factor
> for that station.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> index 68b620b..9da89e3 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> @@ -305,14 +305,19 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
>  	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>  	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> -	struct rt2x00_sta *sta_priv = NULL;
> +	u8 ba_size = 0;
>
>  	if (sta) {
> -		txdesc->u.ht.mpdu_density =
> -		    sta->ht_cap.ampdu_density;
> +		struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
>
> -		sta_priv = sta_to_rt2x00_sta(sta);
> +		txdesc->u.ht.mpdu_density = sta->ht_cap.ampdu_density;
>  		txdesc->u.ht.wcid = sta_priv->wcid;
> +
> +		if (!(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
> +			ba_size = IEEE80211_MIN_AMPDU_BUF;
> +			ba_size <<= sta->ht_cap.ampdu_factor;
> +			ba_size = min_t(int, 63, ba_size - 1);
> +		}
>  	}
>
>  	/*
> @@ -345,7 +350,7 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
>  		return;
>  	}
>
> -	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
> +	txdesc->u.ht.ba_size = ba_size;
>
>  	/*
>  	 * Only one STBC stream is supported for now.
>

Having this patch applied, the throughput on a vgv7510kw22 (RT3062F) in 
AP mode using LEDE head is decreased by somewhat around 10 Mbits/sec. 
I'm using iperf3 for throughput tests and having this patch reverted the 
throughout is back to 80 Mbits/sec.

When bringing down the wifi interface the following messages are logged 
with the patch applied:

[  281.738373] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 
2 failed to flush
[  281.906380] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 
2 failed to flush

Mathias
