Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39996 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbZAIIGX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 03:06:23 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 00:06:23 -0800
Date: Fri, 9 Jan 2009 13:36:07 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Message-ID: <20090109080607.GB22554@vasanth-laptop> (sfid-20090109_090627_180374_AB7C129D)
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 02, 2009 at 03:35:46PM +0530, Vasanth Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath9k/ath9k.h |    5 +++++
>  drivers/net/wireless/ath9k/hw.c    |   33 +++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath9k/main.c  |    9 +++++++--
>  drivers/net/wireless/ath9k/reg.h   |   10 ++++++++++
>  4 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
> index 10c61ed..493351f 100644
> --- a/drivers/net/wireless/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath9k/ath9k.h
> @@ -198,6 +198,7 @@ enum ath9k_hw_caps {
>         ATH9K_HW_CAP_AUTOSLEEP                  = BIT(19),
>         ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(20),
>         ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT     = BIT(21),
> +       ATH9K_HW_CAP_BT_COEX                    = BIT(22)
>  };
> 
>  enum ath9k_capability_type {
> @@ -752,6 +753,7 @@ struct ath9k_node_stats {
>  #define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
>  #define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
>  #define AR_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED     2
> +#define AR_GPIO_OUTPUT_MUX_AS_TX_FRAME           3
>  #define AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED    5
>  #define AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED      6
> 
> @@ -801,6 +803,8 @@ struct ath_hal {
>         u16 ah_rfsilent;
>         u32 ah_rfkill_gpio;
>         u32 ah_rfkill_polarity;
> +       u32 ah_btactive_gpio;
> +       u32 ah_wlanactive_gpio;
> 
>  #ifndef ATH_NF_PER_CHAN
>         struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
> @@ -1048,5 +1052,6 @@ void ath9k_hw_rxena(struct ath_hal *ah);
>  void ath9k_hw_startpcureceive(struct ath_hal *ah);
>  void ath9k_hw_stoppcurecv(struct ath_hal *ah);
>  bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
> +void ath9k_hw_btcoex_enable(struct ath_hal *ah);
> 
>  #endif
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
> index 75ab052..62243ab 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -3308,6 +3308,12 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
>         pCap->num_antcfg_2ghz =
>                 ath9k_hw_get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
> 
> +       if (AR_SREV_9280_10_OR_LATER(ah)) {
> +               pCap->hw_caps |= ATH9K_HW_CAP_BT_COEX;
> +               ah->ah_btactive_gpio = 6;
> +               ah->ah_wlanactive_gpio = 5;
> +       }
> +
>         return true;
>  }
> 
> @@ -3802,3 +3808,30 @@ void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode)
> 
>         REG_WRITE(ah, AR_2040_MODE, macmode);
>  }
> +
> +/***************************/
> +/*  Bluetooth Coexistence  */
> +/***************************/
> +
> +void ath9k_hw_btcoex_enable(struct ath_hal *ah)
> +{
> +       /* connect bt_active to baseband */
> +       REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
> +                       (AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
> +                        AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
> +
> +       REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
> +                       AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
> +
> +       /* Set input mux for bt_active to gpio pin */
> +       REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
> +                       AR_GPIO_INPUT_MUX1_BT_ACTIVE,
> +                       ah->ah_btactive_gpio);
> +
> +       /* Configure the desired gpio port for input */
> +       ath9k_hw_cfg_gpio_input(ah, ah->ah_btactive_gpio);
> +
> +       /* Configure the desired GPIO port for TX_FRAME output */
> +       ath9k_hw_cfg_output(ah, ah->ah_wlanactive_gpio,
> +                           AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
> +}
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index 1d916db..44ec2ce 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -438,12 +438,14 @@ static void ath_ani_calibrate(unsigned long data)
>  /*
>   * Update tx/rx chainmask. For legacy association,
>   * hard code chainmask to 1x1, for 11n association, use
> - * the chainmask configuration.
> + * the chainmask configuration, for bt coexistence, use
> + * the chainmask configuration even in legacy mode.
>   */
>  static void ath_update_chainmask(struct ath_softc *sc, int is_ht)
>  {
>         sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
> -       if (is_ht) {
> +       if (is_ht ||
> +           (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_BT_COEX)) {
>                 sc->sc_tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
>                 sc->sc_rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
>         } else {
> @@ -1510,6 +1512,9 @@ static int ath_init(u16 devid, struct ath_softc *sc)
>                 sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
>         }
> 
> +       if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_BT_COEX)
> +               ath9k_hw_btcoex_enable(sc->sc_ah);
> +
>         return 0;
>  bad2:
>         /* cleanup tx queues */
> diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
> index 9fedb49..eb493c9 100644
> --- a/drivers/net/wireless/ath9k/reg.h
> +++ b/drivers/net/wireless/ath9k/reg.h
> @@ -894,14 +894,24 @@ enum {
>  #define AR_GPIO_INTR_POL_VAL_S                   0
> 
>  #define AR_GPIO_INPUT_EN_VAL                     0x4054
> +#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF     0x00000004
> +#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_S       2
> +#define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF    0x00000008
> +#define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_S      3
> +#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_DEF       0x00000010
> +#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_S         4
>  #define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF        0x00000080
>  #define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF_S      7
> +#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB        0x00001000
> +#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB_S      12
>  #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB         0x00008000
>  #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB_S       15
>  #define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
>  #define AR_GPIO_JTAG_DISABLE                     0x00020000
> 
>  #define AR_GPIO_INPUT_MUX1                       0x4058
> +#define AR_GPIO_INPUT_MUX1_BT_ACTIVE             0x000f0000
> +#define AR_GPIO_INPUT_MUX1_BT_ACTIVE_S           16
> 
>  #define AR_GPIO_INPUT_MUX2                       0x405c
>  #define AR_GPIO_INPUT_MUX2_CLK25                 0x0000000f
> --
> 1.5.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Please hold this one as this introduces some regression on few
platforms.

Thanks,

Vasanth
