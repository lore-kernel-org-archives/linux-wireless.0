Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f199.google.com ([209.85.223.199]:50371 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0DSMWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 08:22:05 -0400
Received: by iwn37 with SMTP id 37so393961iwn.15
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 05:22:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271602602-8538-8-git-send-email-nbd@openwrt.org>
References: <1271602602-8538-1-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-2-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-3-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-4-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-5-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-6-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-7-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-8-git-send-email-nbd@openwrt.org>
Date: Mon, 19 Apr 2010 14:22:03 +0200
Message-ID: <g2i133e8d7e1004190522n7dff80c3v1238a9f72cff734f@mail.gmail.com>
Subject: Re: [PATCH 8/9] ath9k: add support for Tx and Rx STBC
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Is STBC not supported on any chipsets other than AR_SREV_9280_10_OR_LATER(ah)?

/Björn

On Sun, Apr 18, 2010 at 4:56 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Supported only for single stream rates by the hardware
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/init.c |    6 ++++++
>  drivers/net/wireless/ath/ath9k/mac.h  |    8 +++++++-
>  drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
>  3 files changed, 15 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 2c0630e..8c79548 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -216,6 +216,12 @@ static void setup_ht_cap(struct ath_softc *sc,
>        else
>                max_streams = 2;
>
> +       if (AR_SREV_9280_10_OR_LATER(ah)) {
> +               if (max_streams >= 2)
> +                       ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
> +               ht_info->cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
> +       }
> +
>        /* set up supported mcs set */
>        memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
>        tx_streams = count_streams(common->tx_chainmask, max_streams);
> diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
> index 66d0d5e..00f3e0c 100644
> --- a/drivers/net/wireless/ath/ath9k/mac.h
> +++ b/drivers/net/wireless/ath/ath9k/mac.h
> @@ -37,6 +37,8 @@
>          AR_2040_##_index : 0)                                         \
>         |((_series)[_index].RateFlags & ATH9K_RATESERIES_HALFGI ?      \
>           AR_GI##_index : 0)                                           \
> +        |((_series)[_index].RateFlags & ATH9K_RATESERIES_STBC ?        \
> +          AR_STBC##_index : 0)                                         \
>         |SM((_series)[_index].ChSel, AR_ChainSel##_index))
>
>  #define CCK_SIFS_TIME        10
> @@ -434,7 +436,10 @@ struct ar5416_desc {
>  #define AR_ChainSel3_S      17
>  #define AR_RTSCTSRate       0x0ff00000
>  #define AR_RTSCTSRate_S     20
> -#define AR_TxCtlRsvd70      0xf0000000
> +#define AR_STBC0            0x10000000
> +#define AR_STBC1            0x20000000
> +#define AR_STBC2            0x40000000
> +#define AR_STBC3            0x80000000
>
>  #define AR_TxRSSIAnt00      0x000000ff
>  #define AR_TxRSSIAnt00_S    0
> @@ -647,6 +652,7 @@ enum ath9k_rx_filter {
>  #define ATH9K_RATESERIES_RTS_CTS  0x0001
>  #define ATH9K_RATESERIES_2040     0x0002
>  #define ATH9K_RATESERIES_HALFGI   0x0004
> +#define ATH9K_RATESERIES_STBC     0x0008
>
>  struct ath9k_11n_rate_series {
>        u32 Tries;
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 2237658..b0d345a 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1607,6 +1607,8 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
>                        series[i].Rate = rix | 0x80;
>                        series[i].PktDuration = ath_pkt_duration(sc, rix, bf,
>                                 is_40, is_sgi, is_sp);
> +                       if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
> +                               series[i].RateFlags |= ATH9K_RATESERIES_STBC;
>                        continue;
>                }
>
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Venatech AB
Ideon Innovation
Ole Römers väg 12
SE-22370 LUND
Sweden

+46 (0) 46 286 86 20
info@venatech.se
http://www.venatech.se
