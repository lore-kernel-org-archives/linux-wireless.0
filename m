Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZJaFxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 01:53:30 -0400
Subject: Re: [PATCH 14/15] iwlwifi: add SM PS support for 6x50 series
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
In-Reply-To: <1256938578-9638-15-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-15-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f9t6rhTgkg3MQ/Fu6Rhm"
Date: Sat, 31 Oct 2009 06:53:31 +0100
Message-ID: <1256968411.3555.77.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f9t6rhTgkg3MQ/Fu6Rhm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

> @@ -3012,6 +3012,10 @@ static int iwl_init_drv(struct iwl_priv *priv)
>  	priv->band =3D IEEE80211_BAND_2GHZ;
> =20
>  	priv->iw_mode =3D NL80211_IFTYPE_STATION;
> +	if (priv->cfg->support_sm_ps)
> +		priv->current_ht_config.sm_ps =3D WLAN_HT_CAP_SM_PS_DYNAMIC;
> +	else
> +		priv->current_ht_config.sm_ps =3D WLAN_HT_CAP_SM_PS_DISABLED;

Why bother with current_ht_config.sm_ps when ...

>  	ht_info->cap |=3D IEEE80211_HT_CAP_SGI_20;
> -	ht_info->cap |=3D (IEEE80211_HT_CAP_SM_PS &
> -			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
> +	if (priv->cfg->support_sm_ps)
> +		ht_info->cap |=3D (IEEE80211_HT_CAP_SM_PS &
> +				     (WLAN_HT_CAP_SM_PS_DYNAMIC << 2));
> +	else
> +		ht_info->cap |=3D (IEEE80211_HT_CAP_SM_PS &
> +				     (WLAN_HT_CAP_SM_PS_DISABLED << 2));

here we always and unconditionally advertise dynamic SM-PS mode?
=20
> +	if (priv->cfg->support_sm_ps) {
> +		/* # Rx chains when idling and maybe trying to save power */
> +		switch (priv->current_ht_config.sm_ps) {
> +		case WLAN_HT_CAP_SM_PS_STATIC:
> +		case WLAN_HT_CAP_SM_PS_DYNAMIC:
> +			idle_cnt =3D (is_cam) ? IWL_NUM_IDLE_CHAINS_DUAL :
> +				IWL_NUM_IDLE_CHAINS_SINGLE;
> +			break;
> +		case WLAN_HT_CAP_SM_PS_DISABLED:
> +			idle_cnt =3D (is_cam) ? active_cnt :
> +				IWL_NUM_IDLE_CHAINS_SINGLE;
> +			break;
> +		case WLAN_HT_CAP_SM_PS_INVALID:
> +		default:
> +			IWL_ERR(priv, "invalid sm_ps mode %d\n",
> +				priv->current_ht_config.sm_ps);
> +			WARN_ON(1);
> +			break;
> +		}
> +	}

This _should_ always hit the dynamic case since we've always advertised
that, were it not for a bug below. And even when powersave is turned off
the AP will have to do CTS/RTS handshake so we do not gain anything by
turning on all chains in that case.

I think the whole ht_config.sm_ps should be removed, and here we should
always and unconditionally use _SINGLE as that matches what we've
advertised to the AP via the HT capabilities.

>  /* up to 4 chains */
> @@ -2258,6 +2280,12 @@ static void iwl_ht_conf(struct iwl_priv *priv,
>  					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
>  			maxstreams +=3D 1;
> =20
> +			ht_conf->sm_ps =3D
> +				(u8)((ht_cap->cap & IEEE80211_HT_CAP_SM_PS)
> +				>> 2);
> +			IWL_DEBUG_MAC80211(priv, "sm_ps: 0x%x\n",
> +				ht_conf->sm_ps);
> +

This is wrong; we cannot use the peer's SM_PS setting for our own SM_PS
setting, we've advertised dynamic SM PS so we better stick with it. The
peer's setting has no value for us, it means whether the peer will turn
off _its_ chains or not.

johannes

--=-f9t6rhTgkg3MQ/Fu6Rhm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK69DYAAoJEODzc/N7+QmaPcYQAJ1i2CM7zZQzU0rPVca3nU8I
21HyMc9Im6jv9rkW0yr0baoPuLal3PkjPWHA6m2tiggkdsNKiFimLVZK4DS68QPS
v6lE1IvkiL5tBIOef1VaJGTDWteFoa60TpkZbnNT6b97w0/z+PdD40fwUY5edbHg
IBEskwBT61HDWUooKNcd95yDdrE5SBOo4oSUytPvWxgeBD5O5814iQME9+B+jmgy
Ln3itFcJ/IbHFEbNVoQ8nl1qDwTnszIA9gvzIeBwBifrUKVHf1pcm4IKD5noLPU9
jtyXHdmLlQKfQXpQVfcUhD7LRx04WOimZsdrYBHeO+FdaSCNXHd6RyckBHxYLOld
1xxXXj5ca17KAXikmDOA/simMWHVZluLL28+fUhcFOdzZXDU2emoAgbxUbhsdvWU
AylTNlLD6eDOEVt/dtQbw48w+QXQndgSgN8yI1gvyuVKoUN8lNh6M7XDnbugq/SQ
871LiDJB1BBURXYtjy1MqnM9Fp7kDcXnty/83QcxktAVIlQhU149pqUmAnEsT0P/
ZPV/T9W8M2BWpxuVvZuQ3UsXn8oRUAe1jluIdWMnxsn0IDyNTmWZEfR3UsIi1hXq
glODsFn8Rt6Y81q+pHHj7+s9YvUEhuzaA/aRSkj4E1xIlJ7QsWSrdAbuIh3fiOWB
C85x/X0PQzzSu08t/pjQ
=b8Y5
-----END PGP SIGNATURE-----

--=-f9t6rhTgkg3MQ/Fu6Rhm--

