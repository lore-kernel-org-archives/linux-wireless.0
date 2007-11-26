Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXKZQgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:36:14 -0500
Subject: Re: [PATCH 07/15] mac80211: adding 802.11n configuration flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11960864912718-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <11960864912718-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EdAcatgR+OpEf/caglOY"
Date: Mon, 26 Nov 2007 17:36:07 +0100
Message-Id: <1196094968.4149.305.camel@johannes.berg> (sfid-20071126_163616_625418_89EB4E68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EdAcatgR+OpEf/caglOY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> This patch configures the 802.11n mode of operation
> internally in ieee80211_conf structure and in the low-level
> driver as well (through op conf_ht).
> It does not include AP configuration flows.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

I look forward to seeing your bss config patches again :)

> ---
>  include/net/mac80211.h       |    3 ++
>  net/mac80211/ieee80211.c     |   51 ++++++++++++++++++++++++++++++++++++=
++++++
>  net/mac80211/ieee80211_i.h   |    3 ++
>  net/mac80211/ieee80211_sta.c |   32 ++++++++++++++++++++++++++
>  4 files changed, 89 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 862431a..2fcf9f3 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1040,6 +1040,8 @@ enum ieee80211_erp_change_flags {
>   * @tx_last_beacon: Determine whether the last IBSS beacon was sent by u=
s.
>   *	This is needed only for IBSS mode and the result of this function is
>   *	used to determine whether to reply to Probe Requests.
> + *
> + * @conf_ht: Configures low level driver with 802.11n HT data. Must be a=
tomic.
>   */
>  struct ieee80211_ops {
>  	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
> @@ -1085,6 +1087,7 @@ struct ieee80211_ops {
>  			     struct sk_buff *skb,
>  			     struct ieee80211_tx_control *control);
>  	int (*tx_last_beacon)(struct ieee80211_hw *hw);
> +	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
>  };
> =20
>  /**
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 59350b8..6495148 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -34,6 +34,8 @@
>  #include "debugfs.h"
>  #include "debugfs_netdev.h"
> =20
> +#define SUPP_MCS_SET_LEN 16
> +
>  /*
>   * For seeing transmitted packets on monitor interfaces
>   * we have a radiotap header too.
> @@ -557,6 +559,55 @@ int ieee80211_hw_config(struct ieee80211_local *loca=
l)
>  	return ret;
>  }
> =20
> +/**
> + * ieee80211_hw_config_ht should be used only after legacy configuration
> + * has been determined, as ht configuration depends upon the hardware's
> + * HT abilities for a _specific_ band.
> + */
> +int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
> +			   struct ieee80211_ht_info *req_ht_cap,
> +			   struct ieee80211_ht_bss_info *req_bss_cap)
> +{
> +	struct ieee80211_conf *conf =3D &local->hw.conf;
> +	struct ieee80211_hw_mode *mode =3D conf->mode;
> +	int i;
> +
> +	/* HT is not supported */
> +	if (!mode->ht_info.ht_supported) {
> +		conf->flags &=3D ~IEEE80211_CONF_SUPPORT_HT_MODE;
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/* disable HT */
> +	if (!enable_ht) {
> +		conf->flags &=3D ~IEEE80211_CONF_SUPPORT_HT_MODE;
> +	} else {
> +		conf->flags |=3D IEEE80211_CONF_SUPPORT_HT_MODE;
> +		conf->ht_conf.cap =3D req_ht_cap->cap & mode->ht_info.cap;
> +		conf->ht_conf.cap &=3D ~(IEEE80211_HT_CAP_MIMO_PS);
> +		conf->ht_conf.cap |=3D
> +			mode->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
> +		conf->ht_bss_conf.primary_channel =3D
> +			req_bss_cap->primary_channel;
> +		conf->ht_bss_conf.bss_cap =3D req_bss_cap->bss_cap;
> +		conf->ht_bss_conf.bss_op_mode =3D req_bss_cap->bss_op_mode;
> +		for (i =3D 0; i < SUPP_MCS_SET_LEN; i++)
> +			conf->ht_conf.supp_mcs_set[i] =3D
> +				mode->ht_info.supp_mcs_set[i] &
> +				  req_ht_cap->supp_mcs_set[i];
> +
> +		/* In STA mode, this gives us indication
> +		 * to the AP's mode of operation */
> +		conf->ht_conf.ht_supported =3D 1;
> +		conf->ht_conf.ampdu_factor =3D req_ht_cap->ampdu_factor;
> +		conf->ht_conf.ampdu_density =3D req_ht_cap->ampdu_density;
> +	}
> +
> +	local->ops->conf_ht(local_to_hw(local), &local->hw.conf);
> +
> +	return 0;
> +}
> +
>  void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes=
)
>  {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 247af42..399cc2d 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -711,6 +711,9 @@ int ieee80211_if_update_wds(struct net_device *dev, u=
8 *remote_addr);
>  void ieee80211_if_setup(struct net_device *dev);
>  struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
>  					  int phymode, int hwrate);
> +int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
> +			   struct ieee80211_ht_info *req_ht_cap,
> +			   struct ieee80211_ht_bss_info *req_bss_cap);
> =20
>  /* ieee80211_ioctl.c */
>  extern const struct iw_handler_def ieee80211_iw_handler_def;
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 0f133e3..0eaa6a8 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1441,6 +1441,19 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ne=
t_device *dev,
>  	}
>  	sta->supp_rates =3D rates;
> =20
> +	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
> +	    local->ops->conf_ht) {
> +		struct ieee80211_ht_bss_info bss_info;
> +
> +		ieee80211_ht_cap_ie_to_ht_info(
> +				(struct ieee80211_ht_cap *)
> +				elems.ht_cap_elem, &sta->ht_info);
> +		ieee80211_ht_addt_info_ie_to_ht_bss_info(
> +				(struct ieee80211_ht_addt_info *)
> +				elems.ht_info_elem, &bss_info);
> +		ieee80211_hw_config_ht(local, 1, &sta->ht_info, &bss_info);
> +	}
> +
>  	rate_control_rate_init(sta, local);
> =20
>  	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
> @@ -1853,6 +1866,8 @@ static void ieee80211_rx_mgmt_beacon(struct net_dev=
ice *dev,
>  	struct ieee80211_if_sta *ifsta;
>  	size_t baselen;
>  	struct ieee802_11_elems elems;
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_conf *conf =3D &local->hw.conf;
> =20
>  	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 1);
> =20
> @@ -1875,6 +1890,23 @@ static void ieee80211_rx_mgmt_beacon(struct net_de=
vice *dev,
>  	if (elems.erp_info && elems.erp_info_len >=3D 1)
>  		ieee80211_handle_erp_ie(dev, elems.erp_info[0]);
> =20
> +	if (elems.ht_cap_elem && elems.ht_info_elem &&
> +	    elems.wmm_param && local->ops->conf_ht &&
> +	    conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
> +		struct ieee80211_ht_bss_info bss_info;
> +
> +		ieee80211_ht_addt_info_ie_to_ht_bss_info(
> +				(struct ieee80211_ht_addt_info *)
> +				elems.ht_info_elem, &bss_info);
> +		/* check if AP changed bss inforamation */
> +		if ((conf->ht_bss_conf.primary_channel !=3D
> +		     bss_info.primary_channel) ||
> +		    (conf->ht_bss_conf.bss_cap !=3D bss_info.bss_cap) ||
> +		    (conf->ht_bss_conf.bss_op_mode !=3D bss_info.bss_op_mode))
> +			ieee80211_hw_config_ht(local, 1, &conf->ht_conf,
> +						&bss_info);
> +	}
> +
>  	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
>  		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
>  					 elems.wmm_param_len);

--=-EdAcatgR+OpEf/caglOY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0r19qVg1VMiehFYAQIWWxAAhwm6HetnDtuFIr0yCoCQorJOzBhLOGWi
1sVUAO4zCOhy/GD8I8ImK6VrMlEfCdhjCHulL6Bme32Hz82MxvMBxkRXP8SfyHiD
PfAOhp6ZkmOf8hDt8XaeQir9ZLLBIwITp8rxlqNDQVqirV3+aXs/LH3iS15HU4ue
0Z3LsizlatPjq8eQt+ogZ1C357hclvZ14yqbXBttFzxIkUfbSz2fDeKZVpH9eXJv
anDFasvMFCKP4kA8Jr5Qlf/VdRLBt0gBDnFTkuM2CiVN6JKewW3cLjtTZD5IHmp9
gFWMGoG6NZ1b78iFuOOLV/lQ+pFOGOma701B1HFFfT2qLhOJ8kNmLrj47IZyBwnU
dTGe70KCu+yS055vWxOvOQV4XbSwwN4F3O5UdS6uBwBkOvJ2qpPNwQtFIsYCSRJM
zAULsN/5FT+32ZAbcwzL2+VhVm00TFCkazNeIK/oVJAOeAyg3rDrPK2yWcNNwohA
GiBD6YHQNVW9Pdd7FE76uqOyOhR//OF2kfaE+WbSG9X+f3HgN+I8RpcVwK94CMGR
trZAdNKj1kYJMjKhG9z0pcAy6i8veu7+sL7EpXmLLGvfAnb6W0fF2wr+Vbn222Zp
bUIDtt1M1M/5B7AqVic7armeqb5OQctjGY/ok/3l7oxubLSlM/rvdD2IEnEHyn9k
3J8cTPg5p+I=
=zF7U
-----END PGP SIGNATURE-----

--=-EdAcatgR+OpEf/caglOY--

