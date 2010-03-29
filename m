Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42581 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0C2O3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 10:29:13 -0400
Received: by bwz1 with SMTP id 1so3605308bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 07:29:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 7/7] ath9k_htc: Fix TKIP encryption
Date: Mon, 29 Mar 2010 16:29:02 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <19376.33506.672695.950934@gargle.gargle.HOWL>
In-Reply-To: <19376.33506.672695.950934@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003291629.02639.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 March 2010 12:37:22 Sujith wrote:
> The FCS has to be stripped before the packet
> is given to mac80211. Also, remove a redundant
> assignment of skb length and include the FCS_LEN
> when checking padding.
> 
> Fixing this issue makes TKIP work.
> 
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
you don't need to strip the FCS, mac80211 can do that if necessary.
(Or not, if you want to operate a network sniffer)

---
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 10c8760..d5e015e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -509,6 +509,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_HAS_RATE_CONTROL;


>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> index befe574..b171f8e 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -646,7 +649,6 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
>  	spin_lock(&priv->rx.rxbuflock);
>  	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
>  	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
> -	skb->len = rxstatus->rs_datalen;
>  	rxbuf->skb = skb;
>  	rxbuf->in_process = true;
>  	spin_unlock(&priv->rx.rxbuflock);
> 
ok, this one looks odd...

BTW, 
