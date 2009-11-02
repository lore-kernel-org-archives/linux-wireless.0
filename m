Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZKBIoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 03:44:55 -0500
Subject: Re: [PATCH] mac80211: Fix IBSS merge
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19182.33851.980271.360757@gargle.gargle.HOWL>
References: <19182.33851.980271.360757@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rDh4v1eaF8ZI2LURabsM"
Date: Mon, 02 Nov 2009 09:44:46 +0100
Message-ID: <1257151486.3555.161.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rDh4v1eaF8ZI2LURabsM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-02 at 12:33 +0530, Sujith wrote:
> Currently, in IBSS mode, a single creator would go into
> a loop trying to merge/scan. This happens because the IBSS timer is
> rearmed on finishing a scan and the subsequent
> timer invocation requests another scan immediately.
>=20
> This patch fixes this issue by checking if we have just completed
> a scan run trying to merge with other IBSS networks.

Heh, how many people do we need to fix IBSS? :)

Looks sane to me.

johannes

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  net/mac80211/ibss.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index f1362f3..fbffce9 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -455,6 +455,10 @@ static void ieee80211_sta_merge_ibss(struct ieee8021=
1_sub_if_data *sdata)
> =20
>  	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
> =20
> +	if (time_before(jiffies, ifibss->last_scan_completed +
> +		       IEEE80211_IBSS_MERGE_INTERVAL))
> +		return;
> +
>  	if (ieee80211_sta_active_ibss(sdata))
>  		return;
> =20


--=-rDh4v1eaF8ZI2LURabsM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7pvuAAoJEODzc/N7+QmaDbsP/0Q5VTrqNdCGWVNlDkAhXKxI
kCxWcd+fxqZi+pSB1IJbcQHF91ZJ7t7Q9MVQQtd1ZnrwFxUbH6LSqTqV0xFzr6Yw
2ttRdKhFlZF0x5MFRrlGZ9TkPlLwzDiT4nSACPEHTYxXKUXkFxP1TuF2mC1GhuRs
EPEa3g0UC9ZmS8iihBgyKoYpFiGau2YtiFBawnTDTd6QyW42ssk4KO2Q5bz3RVGh
IjFFrz2fCkzP2Cch6AH6vsEs3yWoPp5c00PNLHMxU0ibxv0X37F5XfiqVFEPn8li
CcFJcS/GMFqStZWLiMhVvWLk+BtN2KW+m4D5jKsUbQ+Aj355OMLB57XUZZsIMBOB
OaFyexapFVCEqw3/1qQpGF4rTlGUYPQ+vWKwQDb6Foh33NJ+TLyUE5aIImoDbN7h
6p7dQ0KRMn5dUBHaeiqRVubYS/oilbCNxx3V8aw0zSfgYa5QHaMXLL9i31W9zFAU
eBw04sstsZNIEEJtur1RV2pjUjVNYfuK27YDEIoMFXfzgVynNGtda59CBc6K+TNt
AoI1mdL/Sd0J3KNUWHbakqrwopo3c3wN0wGjtzeejomJ1jgZwOEFoh0Wf1EnrkY9
oeWZ7NhadtiHh3S11/ibTZTEJvG60FJ477S4WycXdBJiBYuMLg28t+zlU/GVWv0N
bZ0q/8UpBG/0mEXEz0px
=729y
-----END PGP SIGNATURE-----

--=-rDh4v1eaF8ZI2LURabsM--

