Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:10703 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750801Ab0JRBZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Oct 2010 21:25:00 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0995525095
	for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 10:24:58 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 4/6] ath9k: optimize/fix ANI RSSI processing
Date: Mon, 18 Oct 2010 10:24:55 +0900
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org> <1287165813-94331-3-git-send-email-nbd@openwrt.org> <1287165813-94331-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287165813-94331-4-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201010181024.55475.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat October 16 2010 03:03:31 Felix Fietkau wrote:
> ANI needs the RSSI average only in station mode, and only for tracking
> the signal strength of beacons of the AP that it is connected to.
> Adjust the code to track on the beacon RSSI, and store the average of that
> in the ath_wiphy struct.
> With these changes, we can get rid of this extra station lookup in the
> rx path, which saves precious CPU cycles.

wouldn't it make sense to have per-station RSSI in IBSS mode?

bruno

> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h   |    2 +-
>  drivers/net/wireless/ath/ath9k/init.c    |    2 +
>  drivers/net/wireless/ath/ath9k/main.c    |    6 +++-
>  drivers/net/wireless/ath/ath9k/recv.c    |   38
> +++++++++-------------------- drivers/net/wireless/ath/ath9k/virtual.c |  
>  1 +
>  5 files changed, 20 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h
> b/drivers/net/wireless/ath/ath9k/ath9k.h index e435c1d..8f5d4c4 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -271,7 +271,6 @@ struct ath_node {
>  	struct ath_atx_ac ac[WME_NUM_AC];
>  	u16 maxampdu;
>  	u8 mpdudensity;
> -	int last_rssi;
>  };
> 
>  #define AGGR_CLEANUP         BIT(1)
> @@ -663,6 +662,7 @@ struct ath_wiphy {
>  	bool idle;
>  	int chan_idx;
>  	int chan_is_ht;
> +	int last_rssi;
>  };
> 
>  void ath9k_tasklet(unsigned long data);
> diff --git a/drivers/net/wireless/ath/ath9k/init.c
> b/drivers/net/wireless/ath/ath9k/init.c index bc6c4df..5ebe53d 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -702,6 +702,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
> u16 subsysid, const struct ath_bus_ops *bus_ops)
>  {
>  	struct ieee80211_hw *hw = sc->hw;
> +	struct ath_wiphy *aphy = hw->priv;
>  	struct ath_common *common;
>  	struct ath_hw *ah;
>  	int error = 0;
> @@ -751,6 +752,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
> u16 subsysid, INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
>  	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
>  	sc->wiphy_scheduler_int = msecs_to_jiffies(500);
> +	aphy->last_rssi = ATH_RSSI_DUMMY_MARKER;
> 
>  	ath_init_leds(sc);
>  	ath_start_rfkill_poll(sc);
> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> b/drivers/net/wireless/ath/ath9k/main.c index 029c6d2..e70dc383 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -535,7 +535,6 @@ static void ath_node_attach(struct ath_softc *sc,
> struct ieee80211_sta *sta) an->maxampdu = 1 <<
> (IEEE80211_HT_MAX_AMPDU_FACTOR +
>  				     sta->ht_cap.ampdu_factor);
>  		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
> -		an->last_rssi = ATH_RSSI_DUMMY_MARKER;
>  	}
>  }
> 
> @@ -804,9 +803,11 @@ static u32 ath_get_extchanmode(struct ath_softc *sc,
>  }
> 
>  static void ath9k_bss_assoc_info(struct ath_softc *sc,
> +				 struct ieee80211_hw *hw,
>  				 struct ieee80211_vif *vif,
>  				 struct ieee80211_bss_conf *bss_conf)
>  {
> +	struct ath_wiphy *aphy = hw->priv;
>  	struct ath_hw *ah = sc->sc_ah;
>  	struct ath_common *common = ath9k_hw_common(ah);
> 
> @@ -830,6 +831,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
>  		ath_beacon_config(sc, vif);
> 
>  		/* Reset rssi stats */
> +		aphy->last_rssi = ATH_RSSI_DUMMY_MARKER;
>  		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
> 
>  		sc->sc_flags |= SC_OP_ANI_RUN;
> @@ -1951,7 +1953,7 @@ static void ath9k_bss_info_changed(struct
> ieee80211_hw *hw, if (changed & BSS_CHANGED_ASSOC) {
>  		ath_print(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
>  			bss_conf->assoc);
> -		ath9k_bss_assoc_info(sc, vif, bss_conf);
> +		ath9k_bss_assoc_info(sc, hw, vif, bss_conf);
>  	}
> 
>  	mutex_unlock(&sc->mutex);
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c
> b/drivers/net/wireless/ath/ath9k/recv.c index 7c90eaf..925b327 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -960,36 +960,23 @@ static void ath9k_process_rssi(struct ath_common
> *common, struct ieee80211_hdr *hdr,
>  			       struct ath_rx_status *rx_stats)
>  {
> +	struct ath_wiphy *aphy = hw->priv;
>  	struct ath_hw *ah = common->ah;
> -	struct ieee80211_sta *sta;
> -	struct ath_node *an;
> -	int last_rssi = ATH_RSSI_DUMMY_MARKER;
> +	int last_rssi;
>  	__le16 fc;
> 
> +	if (ah->opmode != NL80211_IFTYPE_STATION)
> +		return;
> +
>  	fc = hdr->frame_control;
> +	if (!ieee80211_is_beacon(fc) ||
> +	    compare_ether_addr(hdr->addr3, common->curbssid))
> +		return;
> 
> -	rcu_read_lock();
> -	/*
> -	 * XXX: use ieee80211_find_sta! This requires quite a bit of work
> -	 * under the current ath9k virtual wiphy implementation as we have
> -	 * no way of tying a vif to wiphy. Typically vifs are attached to
> -	 * at least one sdata of a wiphy on mac80211 but with ath9k virtual
> -	 * wiphy you'd have to iterate over every wiphy and each sdata.
> -	 */
> -	if (is_multicast_ether_addr(hdr->addr1))
> -		sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr2, NULL);
> -	else
> -		sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr2, hdr->addr1);
> -
> -	if (sta) {
> -		an = (struct ath_node *) sta->drv_priv;
> -		if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
> -		   !rx_stats->rs_moreaggr)
> -			ATH_RSSI_LPF(an->last_rssi, rx_stats->rs_rssi);
> -		last_rssi = an->last_rssi;
> -	}
> -	rcu_read_unlock();
> +	if (rx_stats->rs_rssi != ATH9K_RSSI_BAD && !rx_stats->rs_moreaggr)
> +		ATH_RSSI_LPF(aphy->last_rssi, rx_stats->rs_rssi);
> 
> +	last_rssi = aphy->last_rssi;
>  	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
>  		rx_stats->rs_rssi = ATH_EP_RND(last_rssi,
>  					      ATH_RSSI_EP_MULTIPLIER);
> @@ -997,8 +984,7 @@ static void ath9k_process_rssi(struct ath_common
> *common, rx_stats->rs_rssi = 0;
> 
>  	/* Update Beacon RSSI, this is used by ANI. */
> -	if (ieee80211_is_beacon(fc))
> -		ah->stats.avgbrssi = rx_stats->rs_rssi;
> +	ah->stats.avgbrssi = rx_stats->rs_rssi;
>  }
> 
>  /*
> diff --git a/drivers/net/wireless/ath/ath9k/virtual.c
> b/drivers/net/wireless/ath/ath9k/virtual.c index ec7cf5e..cb6c48b 100644
> --- a/drivers/net/wireless/ath/ath9k/virtual.c
> +++ b/drivers/net/wireless/ath/ath9k/virtual.c
> @@ -107,6 +107,7 @@ int ath9k_wiphy_add(struct ath_softc *sc)
>  	aphy->sc = sc;
>  	aphy->hw = hw;
>  	sc->sec_wiphy[i] = aphy;
> +	aphy->last_rssi = ATH_RSSI_DUMMY_MARKER;
>  	spin_unlock_bh(&sc->wiphy_lock);
> 
>  	memcpy(addr, common->macaddr, ETH_ALEN);
