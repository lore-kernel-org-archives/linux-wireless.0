Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21261 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1AUGbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 01:31:45 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 22:31:27 -0800
Date: Fri, 21 Jan 2011 12:01:00 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/WIP 30/33] ath9k_htc: Fix host RX initialization
Message-ID: <20110121063059.GA20058@vasanth-laptop>
References: <19768.63373.791952.897019@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19768.63373.791952.897019@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 21, 2011 at 08:33:41AM +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> There is no need to set the BSSID mask or opmode when
> initializing RX, they would be set correctly in the HW reset
> routine.
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> index 9913ef0..458164f 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -451,20 +451,12 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
>  static void ath9k_htc_opmode_init(struct ath9k_htc_priv *priv)
>  {
>  	struct ath_hw *ah = priv->ah;
> -	struct ath_common *common = ath9k_hw_common(ah);
> -
>  	u32 rfilt, mfilt[2];
>  
>  	/* configure rx filter */
>  	rfilt = ath9k_htc_calcrxfilter(priv);
>  	ath9k_hw_setrxfilter(ah, rfilt);
>  
> -	/* configure bssid mask */
> -	ath_hw_setbssidmask(common);
> -
> -	/* configure operational mode */
> -	ath9k_hw_setopmode(ah);

I think we need to take care a bug in reg AR_STA_ID1 configuration.
During hw reset, operating mode is set in AR_STA_ID1 but right after
it's overwritten. See the following code segment in
ath9k_hw_reset().

 ath9k_hw_set_operating_mode(ah, ah->opmode);

 ENABLE_REGWRITE_BUFFER(ah);

 REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
 REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
                  | macStaId1
                  | AR_STA_ID1_RTS_USE_DEF
                  | (ah->config.
                     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
                  | ah->sta_id1_defaults);


Existing code works because we configure the opmode again through
ath9k_htc_opmode_init() after reset. 

Vasanth
