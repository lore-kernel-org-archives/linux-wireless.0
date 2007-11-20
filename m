Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXKTNuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 08:50:09 -0500
Subject: Re: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <11955417361539-git-send-email-yi.zhu@intel.com>
References: <11955417361539-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x5R/PZWP76VUVLJIFc7Q"
Date: Tue, 20 Nov 2007 14:37:56 +0100
Message-Id: <1195565876.10920.29.camel@johannes.berg> (sfid-20071120_135040_987968_98B17B7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x5R/PZWP76VUVLJIFc7Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-20 at 14:55 +0800, Zhu Yi wrote:
> I'm not sure if this is best choice, someone might have better
> solutions. But this patch fixed the connection problem when switching
> from a WPA enabled AP (using wpa_supplicant) to an open AP (using
> iwconfig). The root cause is when we connect to a WPA enabled AP,
> wpa_supplicant sets the ifsta->extra_ie thru SIOCSIWGENIE. But if we
> stop wpa_supplicant and connect to an open AP with iwconfig, there is
> no way to clear the extra_ie so that mac80211 keeps connecting with that.

Fun.

> Someone could argue wpa_supplicant should clear the extra_ie during
> its shutdown. But mac80211 should also handle the unexpected shutdown
> case (ie. killall -9 wpa_supplicant).

Yes. But if you do that, the interface won't be down either. Maybe this
should also be done when removing keys?

johannes

--=-x5R/PZWP76VUVLJIFc7Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0LjMqVg1VMiehFYAQIyEA//dMYSNIICQfmXcoTExX2XJSp3MlcIY+ue
RuHdWXZJhpFMiRkuPKDt/SDjisdtcmRkJf3+uVVV1OpweEr8qh+X3bk/aecc0uT2
izKoVOnYzdcSyDaLUZ4vy5Zga3prqUWO66G1vs44XBeJyQC3M3VZ9ncYS2/aSFm8
I3I0cr7/tqQVhRhfR1gjzAMMe/9OwwPQen6DU8BYAjv0Ff6CiPyq5DgD/hDg9g59
WZVmUc5mw2VoNdFrCr90InF6nSBm7GG5SbPvxoNj9UiJVugqac+xwlBPVWKDg7Z/
ixP8mjrbJnR/pY8CuZF5jpFFTtIYlQhM8XLomxVtRkNpyRyZd2TLkflXWzxlYH4l
N2r0iRouxJk21afbGEckdrSHZRgGI5+s/rX+6/CVFzWUraW3UEnyWLZeCzjz8MRH
ppvjDNdMcdS+xqer9u5ifR32ZhKKHgAdNJUCorI5gbTUxh1toUZqLF0ln5DZChvL
wWvHq70Npst6S6awyW/bxVrT9NBA0Lprhi6eOhCIhPbpEvY21uKZqEs2+IVNtD4K
3WM6BEDASDd7YaKfiYkQ1rahO/QRiVGt0SdUVz6PrdsE2lhS9uRz9Zugk1O43rbs
fZW1KfR9w2sDRPmLcKa2mv+AGj64wuwS+H5a87XDE2ZhanHSci9hDKEINbzaAEXO
WuK2dmZVGL0=
=mcR9
-----END PGP SIGNATURE-----

--=-x5R/PZWP76VUVLJIFc7Q--

