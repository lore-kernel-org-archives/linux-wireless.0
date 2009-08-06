Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZHFHrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 03:47:23 -0400
Subject: Re: [RFC 1/4] orinoco: add cfg80211 connect and disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1249504372-17063-2-git-send-email-kilroyd@googlemail.com>
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
	 <1249504372-17063-2-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-onDI+BgGMAMz/5KXJR85"
Date: Thu, 06 Aug 2009 09:47:21 +0200
Message-Id: <1249544841.4470.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-onDI+BgGMAMz/5KXJR85
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 21:32 +0100, David Kilroy wrote:

> +static int __orinoco_connect(struct wiphy *wiphy,
> +			     struct ieee80211_channel *channel,
> +			     const u8 *bssid, const u8 *ssid,
> +			     u8 ssid_len)
> +{
> +	struct orinoco_private *priv =3D wiphy_priv(wiphy);
> +

> +		/* Intersil firmware hangs if you try to roam manually
> +		 * without an ESSID set. */
> +		if ((priv->firmware_type =3D=3D FIRMWARE_TYPE_INTERSIL) &&
> +		    (priv->desired_essid[0] =3D=3D 0)) {

This is a wrong way to check for an empty SSID, since \0 is a valid byte
in the SSID. You should check for ssid_len =3D=3D 0 instead.

However, it's also not necessary, cfg80211 will never call this function
without an SSID. So you can even just BUG_ON(!ssid_len); or something :)

> +	switch (sme->auth_type) {
> +	case NL80211_AUTHTYPE_OPEN_SYSTEM:
> +		priv->wep_restrict =3D 0;
> +		break;
> +	case NL80211_AUTHTYPE_SHARED_KEY:
> +		priv->wep_restrict =3D 1;
> +		break;
> +	/* Ignore all other settings */
> +	default:
> +		break;

I think you should return -EINVAL for other values.

> +	}
> +
> +	switch (sme->crypto.cipher_group) {
> +	case WLAN_CIPHER_SUITE_TKIP:
> +		encode_alg =3D ORINOCO_ALG_TKIP;
> +		break;
> +
> +	case WLAN_CIPHER_SUITE_WEP40:
> +	case WLAN_CIPHER_SUITE_WEP104:
> +		encode_alg =3D ORINOCO_ALG_WEP;
> +		break;
> +
> +	default:
> +		encode_alg =3D ORINOCO_ALG_NONE;
> +	}

Same here, I guess, although that can't really happen since you only
advertised these ones.

Other than that, as noted in my reply to 0/5, this won't work properly
since you don't ever call cfg80211_connect_result().

johannes

--=-onDI+BgGMAMz/5KXJR85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeoqFAAoJEODzc/N7+Qmad6sQAMJqQU5F923vb+G6ZnOJLeaR
+ROElcVN5tRlyxcQC8TTtu5MZiHyPM54D6L+5nxbOkJVz78Mh5vlcepjqfpAcEa5
2vIl/lhuYVmLCH52uXhKGrfgmtzqG2Rcxcr7EXeyHYEqGP4rFmZMbLJ4dtCza48Y
ajLD9Z3YXnAfedFMu8h2S9hnibHTTt2hIY387Q+EcjLQKa+tSO0un1GQVqSZ5iBV
IB1yLEGNgFgn0Np/8rUQ5Zt/i7H9egpr3ndlUmyDOnd4jT+5SKItAEw55B2EwDNd
axuqeLaUR4mmJ6RuJk53GahBKCX+EbBQkaxlTUoIzaip+URZfaDvW1zH+GkUcGsI
I46+ySwggLT6U1XCV3PZQWmb9bFICvBugoLMJ9ZJS8e3+4LkKKmg8aF26bKaK3+R
3G5X9My+QxFs0uKzfAVJ4fJD4D8IcQTdJ0JTd/CVoi19rUlXL4rIW5KXQuQ23QX9
qN9IYmioNxaZ8s8oHOZncFmw3CHtg4YuRuMT+pJxm3M1X5V8w7PUpG61Ly2WQlv7
gm7KD4facPoXtrMfDvFWpj8E9baFo0+1CBleh0uxSmvtJKzl5FCmbj2c76TTJOpH
30GfkyFheqDCV/tyOU4f5PLXz3yiZz4LcXs4hk1cwD1fYAES161UyrG+AfWxOu1q
DScCCGJ9dS3nzqvMQYRt
=WQaO
-----END PGP SIGNATURE-----

--=-onDI+BgGMAMz/5KXJR85--

