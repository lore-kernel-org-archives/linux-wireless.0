Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbXC2LHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:07:42 -0400
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and   association
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QILPjwJV1m72N3Yx0EVv"
Date: Wed, 28 Mar 2007 22:03:33 +0200
Message-Id: <1175112213.5151.133.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QILPjwJV1m72N3Yx0EVv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 04:38 -0700, mohamed wrote:

> @@ -96,6 +96,10 @@ struct ieee802_11_elems {
>  	u8 rsn_len;
>  	u8 *erp_info;
>  	u8 erp_info_len;
> +	u8 *ht_cap_param;
> +	u8 ht_cap_param_len;
> +	u8 *ht_extra_param;
> +	u8 ht_extra_param_len;
>  	u8 *ext_supp_rates;
>  	u8 ext_supp_rates_len;
>  	u8 *wmm_info;

Random note not applicable to your patch: This is quite a large struct,
especially on 64-bit. Maybe we should be thinking about making those
pointers there u16 offsets instead. And we *definitely* should change
the order of these fields, having u8 and u8* alternate just sucks.

> +static void ieee80211_sta_ht_params(struct net_device *dev,=20
> +			struct sta_info *sta,
> +			struct ieee80211_ht_additional_info *ht_extra_param,
> +			struct ieee80211_ht_capability *ht_cap_param)
> +{
> +	int rc;
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +
> +	if (local->ops->conf_ht) {
> +		rc =3D local->ops->conf_ht(local_to_hw(local), ht_cap_param,=20
> +					 ht_extra_param);
> +
> +		if (rc)
> +			sta->flags &=3D ~WLAN_STA_HT;
> +	} else=20
> +		sta->flags &=3D ~WLAN_STA_HT;

Shouldn't this also set the STA_HT flag in the case where conf_ht
returns without error?

> +/* Get 11n capabilties from low level driver */
> +static void ieee80211_fill_ht_ie(struct net_device *dev,

[filling in how it looks like after Luis's and my proposed changes]

> +				 struct ieee80211_ht_capability *ht_capab)
> +{
> +       struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +       BUG_ON(!local->ops->get_ht_capab);
> +       memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> +       local->ops->get_ht_capab(local_to_hw(local), ht_capab);

some blank lines would be good ;)

Maybe we should be setting some fields to default values here that
aren't zero? Haven't checked.
=20
> +	/* if low level driver support 11n fill in 11n IE */
> +	if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
> +		pos =3D skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
> +		*pos++ =3D WLAN_EID_HT_CAPABILITY;
> +		*pos++ =3D sizeof(struct ieee80211_ht_capability);
> +		ieee80211_fill_ht_ie(dev,=20
> +				     (struct ieee80211_ht_capability *)pos);

Now that fill_ht_ie is so short maybe it should just be rolled into this
code.

johannes

--=-QILPjwJV1m72N3Yx0EVv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCsoU/ETPhpq3jKURAkw4AJ9uRaYpfVZmXLmNRqoYQTTlmAKeIACgpfHQ
fqLxUa9J3XqIq7xZKSIDFXE=
=UqSH
-----END PGP SIGNATURE-----

--=-QILPjwJV1m72N3Yx0EVv--

