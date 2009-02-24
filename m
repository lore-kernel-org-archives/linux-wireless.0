Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZBXC0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:26:00 -0500
Subject: Re: [PATCH v2 3/5] cfg80211: Add AP beacon regulatory hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1235193641-17993-4-git-send-email-lrodriguez@atheros.com>
References: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
	 <1235193641-17993-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y4jegACWykfF93CCnppq"
Date: Mon, 23 Feb 2009 17:58:50 -0800
Message-Id: <1235440730.4455.51.camel@johannes.local> (sfid-20090224_032605_125032_61C94183)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y4jegACWykfF93CCnppq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-21 at 00:20 -0500, Luis R. Rodriguez wrote:

> +static bool freq_is_chan_12_13_14(u16 freq)
> +{
> +	if (freq =3D=3D ieee80211_channel_to_frequency(12) ||
> +	    freq =3D=3D ieee80211_channel_to_frequency(13) ||
> +	    freq =3D=3D ieee80211_channel_to_frequency(14))
> +		return true;
> +	return false;
> +}
> +
> +int regulatory_hint_found_beacon(struct wiphy *wiphy,
> +				 struct ieee80211_channel *beacon_chan,
> +				 gfp_t gfp)
> +{
> +	struct reg_beacon *reg_beacon;
> +
> +	if (likely((beacon_chan->beacon_found ||
> +	    (beacon_chan->flags & IEEE80211_CHAN_RADAR) ||
> +	    (beacon_chan->band =3D=3D IEEE80211_BAND_2GHZ &&
> +	     !freq_is_chan_12_13_14(beacon_chan->center_freq)))))
> +		return 0;

This doesn't seem right, shouldn't it use the world regulatory domain to
check against rather than hardcoding it?

johannes

--=-Y4jegACWykfF93CCnppq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1RYAAoJEKVg1VMiehFYBKAQAJd5bxE8N5+uJHlROYt63WWe
oG2Uu/6TDw/NOxlP23ZpuEt8sBoXZ1WWkK1ULQ3pCc6aJ2Px4BlloUN8hItRVIi4
I5xnnoT1nOYUS9TrAgG4rI9VOFQpDG3PIDwB2qrCD5VjwIR5BI6DF5BfiYEu0X+T
TiBeuG2eP4fAwyo9asSyGSPHWB4jK9fLPvJkiLKgJNmsrX+gPX0W7Unubw1GWzqW
J7sg45Lxfkgi2Svot1Wt8vm8cOvK/AXXOFZiZ+pwY3croutuRVajc+Csy9C3aEAQ
G9TgoHuG+cm2dMcFmQeLMK+nttd0NXgbONQA74o7OTNuOy5vn2sWNv30s6yULREa
eqs2fO5+FiBDKfA+X39h7pANOdNrsvxD4L4CIVE4e2/XtojfkkCMfzIIhMYwdnrW
RN3TkyNXiT8inzl33wA3QcUFL4wkb44ByEYZBO8hOLAhuj5V6b9ySLUI//mygGj7
bW5vYU4xiozSyWGy7vj1PWiucIIRpC3PtN5kc49qGy2dvESGnjcMA242aYS8mwBd
zWECZd5GH9ggg3VuNc1wKbCiLeVbZRe+fgq6ua8SGplV00JSIB7vLPdXp+6EnaCB
1dfppoM4LURrDPngDvYF2NuA5CaH1yIfb/sxsGDVZKUC1fVZccgIb2MCrG/L+rUL
FTmvyvW1JyL5PkQcIRtK
=9hL3
-----END PGP SIGNATURE-----

--=-Y4jegACWykfF93CCnppq--

