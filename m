Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYKJJ2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 04:28:21 -0500
Subject: Re: [RFC 1/2] mac80211: enable IEEE80211_CONF_PS only when
	associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1226245439-30329-2-git-send-email-kalle.valo@nokia.com> (sfid-20081109_164422_067827_8A0241DA)
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <1226245439-30329-2-git-send-email-kalle.valo@nokia.com>
	 (sfid-20081109_164422_067827_8A0241DA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PHMFFX1+RENWA9swcK6W"
Date: Mon, 10 Nov 2008 10:28:21 +0100
Message-Id: <1226309301.4004.8.camel@johannes.berg> (sfid-20081110_102826_942604_C1F11BCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PHMFFX1+RENWA9swcK6W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-09 at 17:43 +0200, Kalle Valo wrote:


> @@ -865,8 +870,14 @@ static void ieee80211_set_disassoc(struct ieee80211_=
sub_if_data *sdata,
>  	sta_info_destroy(sta);
> =20
>  	local->hw.conf.ht.enabled =3D false;
> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
> +	config_changed |=3D IEEE80211_CONF_CHANGE_HT;
> +
> +	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
> +		local->hw.conf.flags &=3D ~IEEE80211_CONF_PS;
> +		config_changed |=3D IEEE80211_CONF_PS;
> +	}

That latter flag should be CONF_CHANGED_PS.

johannes

--=-PHMFFX1+RENWA9swcK6W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJF/6xAAoJEKVg1VMiehFYOp0P/j3Fcr5tGusChgGm9vVthLNM
/TlC1tWSgAyffvtPPX9f0eBF3eW2Hxq/aEyq40Gw3KGDCffLW+ijJTfJsDrkDsT7
tjjtzhybuUmkQ3tLQ+617xaYHJulRIEC1Jk1qljIjpy2ihkHClHaBqbeE8SjuCWt
jvR/4o50sKlWBvgY+/gwhyKtRkZDbJiG2ywu/cjpV/sG9ddE1/Jy+khfFELrZyd8
CcqSygT1bD3v+0/r05CUhO+vi+QZdiWBIk0sNAlwpfhozrHLMniDlcPRjazQYlPe
E0WQigZ+WTNtzBl0jbRVfbqF85Kg7MTqCK8L+K0Dr8FslGkfOVkvXo0JsL7H6wLv
NdjfhPmXZIiWlQEQRXyhMlHUiWzM+uP9PKrobhqIkyoawfMjAHEhTrijVJvJieVl
ZQEVVhHX9R/lqBflbrPQyZp3UIPtTq6Gg7c2DF5epxRYD3zoE6ON05VmDd344Fpk
+RnU+TOIv55qY2oqq1CO0bEx3N67hDJM406G0KqrUQa1GB7xtWyZQXUYTEnYRFVk
jTIfhe6n92ObJGX5SNqePcR8v4YaGg2eWtWaqDxkta6nd4xRNeZwXYsbtqwiSoCI
/HAJmW8nHf5q+V+rdJkaLjq/9Qf/ZyDhgqX8ZgjybIz83VmBwc4fnoRyQLXvRCum
QknXifHm3gDSi5fMoW0n
=FShy
-----END PGP SIGNATURE-----

--=-PHMFFX1+RENWA9swcK6W--

