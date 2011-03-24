Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63377 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1CXJju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 05:39:50 -0400
Received: by iwn34 with SMTP id 34so9480277iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 02:39:50 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19851.4373.967588.536327@gargle.gargle.HOWL>
Date: Thu, 24 Mar 2011 15:08:29 +0530
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH] ath9k: cleanup few redundant macros
In-Reply-To: <1300957576-2734-1-git-send-email-mshajakhan@atheros.com>
References: <1300957576-2734-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h  |    4 ----
>  drivers/net/wireless/ath/ath9k/common.c |    2 +-
>  drivers/net/wireless/ath/ath9k/mac.c    |    2 --
>  3 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 099bd41..24b747c 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -120,13 +120,11 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
>  /* RX / TX */
>  /***********/
>  
> -#define ATH_MAX_ANTENNA         3
>  #define ATH_RXBUF               512
>  #define ATH_TXBUF               512
>  #define ATH_TXBUF_RESERVE       5
>  #define ATH_MAX_QDEPTH          (ATH_TXBUF / 4 - ATH_TXBUF_RESERVE)
>  #define ATH_TXMAXTRY            13
> -#define ATH_MGT_TXMAXTRY        4
>  
>  #define TID_TO_WME_AC(_tid)				\
>  	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
> @@ -688,8 +686,6 @@ void ath9k_ps_restore(struct ath_softc *sc);
>  
>  u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
>  
> -void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
> -
>  void ath_start_rfkill_poll(struct ath_softc *sc);
>  extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
>  void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
> diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
> index 615e682..16ba8c6 100644
> --- a/drivers/net/wireless/ath/ath9k/common.c
> +++ b/drivers/net/wireless/ath/ath9k/common.c
> @@ -116,7 +116,7 @@ void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
>  
>  	if (chan->band == IEEE80211_BAND_2GHZ) {
>  		ichan->chanmode = CHANNEL_G;
> -		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
> +		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM;

There's a reason for this: 8813262ea79acf9daa0e03901bdfe93db4dc4ca5
If channel handling has been cleaned up since then, this can be removed.

Sujith
