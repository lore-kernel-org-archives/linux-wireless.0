Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYA2RqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 12:46:08 -0500
Subject: Re: [PATCH 1/1] mac80211: set assoc flag to bss_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <12014435022755-git-send-email-tomas.winkler@intel.com> (sfid-20080127_141938_114099_DB9B65D9)
References: <12014435022755-git-send-email-tomas.winkler@intel.com>
	 (sfid-20080127_141938_114099_DB9B65D9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/L8qeJriFjnfJejx4bt/"
Date: Tue, 29 Jan 2008 17:14:45 +0100
Message-Id: <1201623285.4394.37.camel@johannes.berg> (sfid-20080129_174612_442991_2AA15762)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/L8qeJriFjnfJejx4bt/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-01-27 at 16:18 +0200, Tomas Winkler wrote:
> Only BSS_CHANGED_ASSOC was set in the 'changed' bitmask. Assignment  to
> bss_conf.assoc was absent.
> This patch assign value to  bss_conf.assoc according the association stat=
e.

Yup, looks like I missed that, thanks.

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_sta.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index d252d09..2c4692b 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -492,6 +492,7 @@ static void ieee80211_set_associated(struct net_devic=
e *dev,
>  	ifsta->last_probe =3D jiffies;
>  	ieee80211_led_assoc(local, assoc);
> =20
> +	sdata->bss_conf.assoc =3D assoc;
>  	ieee80211_bss_info_change_notify(sdata, changed);
>  }
> =20

--=-/L8qeJriFjnfJejx4bt/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR59Q9KVg1VMiehFYAQJr9w//RPDUveEYeF+tNpNPupOXnfUJcXxFCD/z
fLyqdh31BLzYgAdha5Z03sqQqfX0HCVRjwHeVm18PKsLVZv7QE+uceOtNdaBQ9ke
qTYiz3P2nZlg5geWwcXfVOXGEr8hrv+m+nFaMJKNO14ScZ2GF54T50zi3mFB3My1
u/lBPAI2wQEzZmjOC4CB4wNjw76sKm1TxctJ2RqxnpXZpU1BpZlhqs9JIoPbxfNN
IKRWsrNBwJJXwZJcsu6gKCYLwn/WSeeP1Nww+PkX+oS+EedtgcwGeSllujuSQIfk
0N08kRYQ0Ghrgu7FlMQsTLN44v+lZi2/OaTKNjmAlszuTLMOlmLYdTnC8LZ6C5I/
xYjUFCwRurCOgH4TplyxfXkJekkyndrihj54nELEWk2V16rEnShjLMD98qjzGAYV
mOD89cf1yVezfTLni5oDcGiCQGTW7jyD61Q5x6QUic/vnjOBeRNCy5X5l2hSIhzB
2jbHCchkyGkhyHEzFTAfBXLD4RupRtyGssFzfy38jgyUBpf5YiXMjvpkDk/IlkCF
IW/Hk+fvE5LSL5E0QqBl1V+U4sqUQmlH+ZOA4HOFyqGVeaKHFFI45dmIFxPNTEs0
xhgZo1ds/HmC9v0OA12/NDpuCyKoBeHE0EPo05Rdefsxlhrh7DYq1h071leAG2HU
6SCQ9UzKqhQ=
=fjdX
-----END PGP SIGNATURE-----

--=-/L8qeJriFjnfJejx4bt/--

