Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56103 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1H2HtY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 03:49:24 -0400
Message-ID: <4E5B447E.8040101@openwrt.org> (sfid-20110829_094927_366350_73780CEE)
Date: Mon, 29 Aug 2011 09:49:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v2 4/4] ath9k: implement .get_antenna and .set_antenna
References: <1314597262-49427-1-git-send-email-nbd@openwrt.org> <1314597262-49427-2-git-send-email-nbd@openwrt.org> <1314597262-49427-3-git-send-email-nbd@openwrt.org> <1314597262-49427-4-git-send-email-nbd@openwrt.org> <20110829074154.GA29926@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110829074154.GA29926@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-29 9:41 AM, Rajkumar Manoharan wrote:
> On Mon, Aug 29, 2011 at 07:54:22AM +0200, Felix Fietkau wrote:
>>  On MIMO chips this can be used to enable/disable hardware chains, ensuring
>>  that the MCS information is updated accordingly.
>>  On non-MIMO chips with rx diversity (e.g. 9285), this configures the rx
>>  input antenna.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>   drivers/net/wireless/ath/ath9k/ath9k.h |    2 +
>>   drivers/net/wireless/ath/ath9k/init.c  |   33 ++++++++++++---
>>   drivers/net/wireless/ath/ath9k/main.c  |   71 ++++++++++++++++++++++++++++++++
>>   drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
>>   4 files changed, 100 insertions(+), 8 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
>>  index 5d9a9aa..6c7b27c 100644
>>  --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>>  +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>>  @@ -647,6 +647,7 @@ struct ath_softc {
>>   	struct ath_descdma txsdma;
>>
>>   	struct ath_ant_comb ant_comb;
>>  +	u32 ant_tx, ant_rx;
> u8 is sufficient.
>>   };
>>
>>   void ath9k_tasklet(unsigned long data);
>>  @@ -668,6 +669,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
>>   		const struct ath_bus_ops *bus_ops);
>>   void ath9k_deinit_device(struct ath_softc *sc);
>>   void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
>>  +void ath9k_reload_chainmask_settings(struct ath_softc *sc);
>>
>>   void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
>>   bool ath9k_uses_beacons(int type);
>>  diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>>  index 31ef501..263bbe2 100644
>>  --- a/drivers/net/wireless/ath/ath9k/init.c
>>  +++ b/drivers/net/wireless/ath/ath9k/init.c
>>  @@ -652,9 +652,22 @@ static void ath9k_init_txpower_limits(struct ath_softc *sc)
>>   	ah->curchan = curchan;
>>   }
>>
>>  +void ath9k_reload_chainmask_settings(struct ath_softc *sc)
>>  +{
>>  +	if (!(sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_HT))
>>  +		return;
>>  +
>>  +	if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_2GHZ)
>>  +		setup_ht_cap(sc,&sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
>>  +	if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_5GHZ)
>>  +		setup_ht_cap(sc,&sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
>>  +}
>>  +
>>  +
>>   void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>>   {
>>  -	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>>  +	struct ath_hw *ah = sc->sc_ah;
>>  +	struct ath_common *common = ath9k_hw_common(ah);
>>
>>   	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
>>   		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>>  @@ -692,6 +705,17 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>>   	hw->sta_data_size = sizeof(struct ath_node);
>>   	hw->vif_data_size = sizeof(struct ath_vif);
>>
>>  +	hw->wiphy->available_antennas_rx = BIT(ah->caps.max_rxchains) - 1;
>>  +	hw->wiphy->available_antennas_tx = BIT(ah->caps.max_txchains) - 1;
>>  +
> Why dont you use caps.tx/rx_chainmask instead?
Because rx/tx chainmask can contain odd values such as 0x5, which is 
exposed to the user as 0x3 instead.

>>  +	/* single chain devices with rx diversity */
>>  +	if (ah->caps.max_rxchains == 1&&
>>  +	    ath9k_hw_ops(ah)->antdiv_comb_conf_get)
>>  +		hw->wiphy->available_antennas_rx = 3;
>>  +
> Use hw caps to determine ant_divsersity.
Sure.

> use hex instead of decimal for available_antennas, ant_rx/tx
I think I'll use BIT(0)|BIT(1) instead, as hex values don't really 
clarify things either.

>>  +	sc->ant_rx = hw->wiphy->available_antennas_rx;
>>  +	sc->ant_tx = hw->wiphy->available_antennas_tx;
>>  +
>>   #ifdef CONFIG_ATH9K_RATE_CONTROL
>>   	hw->rate_control_algorithm = "ath9k_rate_control";
>>   #endif
>>  @@ -703,12 +727,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>>   		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
>>   			&sc->sbands[IEEE80211_BAND_5GHZ];
>>
>>  -	if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_HT) {
>>  -		if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_2GHZ)
>>  -			setup_ht_cap(sc,&sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
>>  -		if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_5GHZ)
>>  -			setup_ht_cap(sc,&sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
>>  -	}
>>  +	ath9k_reload_chainmask_settings(sc);
>>
>>   	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
>>   }
>>  diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>  index 4b1fe7c..1cbbaea 100644
>>  --- a/drivers/net/wireless/ath/ath9k/main.c
>>  +++ b/drivers/net/wireless/ath/ath9k/main.c
>>  @@ -262,6 +262,22 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
>>   			ath_start_ani(common);
>>   	}
>>
>>  +	if (ath9k_hw_ops(ah)->antdiv_comb_conf_get&&  sc->ant_rx != 3) {
>>  +		struct ath_hw_antcomb_conf div_ant_conf;
>>  +		u8 lna_conf;
>>  +
>>  +		ath9k_hw_antdiv_comb_conf_get(ah,&div_ant_conf);
>>  +
>>  +		if (sc->ant_rx == 1)
>>  +			lna_conf = ATH_ANT_DIV_COMB_LNA1;
>>  +		else
>>  +			lna_conf = ATH_ANT_DIV_COMB_LNA2;
>>  +		div_ant_conf.main_lna_conf = lna_conf;
>>  +		div_ant_conf.alt_lna_conf = lna_conf;
>>  +
>>  +		ath9k_hw_antdiv_comb_conf_set(ah,&div_ant_conf);
> Adjust the fast_div_bias based on main and alt lna conf.
The fast_div_bias should be irrelevant if there's only one active LNA path.

>>  +	}
>>  +
>>   	ieee80211_wake_queues(sc->hw);
>>
>>   	return true;
>>  @@ -2358,6 +2374,59 @@ static int ath9k_get_stats(struct ieee80211_hw *hw,
>>   	return 0;
>>   }
>>
>>  +static u32 fill_chainmask(u32 cap, u32 new)
>>  +{
>>  +	u32 filled = 0;
>>  +	int i;
>>  +
>>  +	for (i = 0; cap&&  new; i++, cap>>= 1) {
>>  +		if (!(cap&  BIT(0)))
>>  +			continue;
>>  +
>>  +		if (new&  BIT(0))
>>  +			filled |= BIT(i);
>>  +
>>  +		new>>= 1;
>>  +	}
>>  +
>>  +	return filled;
>>  +}
>>  +
>>  +static int ath9k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
>>  +{
>>  +	struct ath_softc *sc = hw->priv;
>>  +	struct ath_hw *ah = sc->sc_ah;
>>  +
>>  +	if (!rx_ant || !tx_ant)
>>  +		return -EINVAL;
>>  +
>>  +	sc->ant_rx = rx_ant;
>>  +	sc->ant_tx = tx_ant;
>>  +
>>  +	if (ah->caps.rx_chainmask == 1)
>>  +		return 0;
>>  +
>>  +	/* AR9100 runs into calibration issues if not all rx chains are enabled */
>>  +	if (AR_SREV_9100(ah))
>>  +		ah->rxchainmask = 0x7;
>>  +	else
>>  +		ah->rxchainmask = fill_chainmask(ah->caps.rx_chainmask, rx_ant);
>>  +
>>  +	ah->txchainmask = fill_chainmask(ah->caps.tx_chainmask, tx_ant);
>>  +	ath9k_reload_chainmask_settings(sc);
> Setting chainmask alone is not sufficient. dont you have to complete rx and
> calibration before setting antenna?
The antenna is only configured while the interface is down. The main 
chipset that has issues with rx chainmask and calibration is AR9100 and 
that part is taken care of above.

>>  +
>>  +	return 0;
>>  +}
>>  +
>>  +static int ath9k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
>>  +{
>>  +	struct ath_softc *sc = hw->priv;
>>  +
>>  +	*tx_ant = sc->ant_tx;
>>  +	*rx_ant = sc->ant_rx;
>>  +	return 0;
>>  +}
>>  +
>>   struct ieee80211_ops ath9k_ops = {
>>   	.tx 		    = ath9k_tx,
>>   	.start 		    = ath9k_start,
>>  @@ -2384,4 +2453,6 @@ struct ieee80211_ops ath9k_ops = {
>>   	.tx_frames_pending  = ath9k_tx_frames_pending,
>>   	.tx_last_beacon     = ath9k_tx_last_beacon,
>>   	.get_stats	    = ath9k_get_stats,
>>  +	.set_antenna	    = ath9k_set_antenna,
>>  +	.get_antenna	    = ath9k_get_antenna,
>>   };
>>  diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>>  index ad5f9bd..7e1265c 100644
>>  --- a/drivers/net/wireless/ath/ath9k/recv.c
>>  +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>  @@ -1956,7 +1956,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>   			ath_rx_ps(sc, skb);
>>   		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>>
>>  -		if (ah->caps.hw_caps&  ATH9K_HW_CAP_ANT_DIV_COMB)
>>  +		if ((ah->caps.hw_caps&  ATH9K_HW_CAP_ANT_DIV_COMB)&&  sc->ant_rx == 3)
>>   			ath_ant_comb_scan(sc,&rs);
> What about already received packets using combined antennas?
What do you mean? sc->ant_rx does not change while the interface is up.

- Felix
