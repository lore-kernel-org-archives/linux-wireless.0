Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZGWW64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 18:58:56 -0400
Subject: Re: [PATCH] mac80211: do not trigger beacon loss work if scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rossi.f@inwind.it
In-Reply-To: <1248389377-30379-1-git-send-email-lrodriguez@atheros.com>
References: <1248389377-30379-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qQMHsrXNcR68phvsPkDn"
Date: Fri, 24 Jul 2009 00:58:24 +0200
Message-Id: <1248389904.10342.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qQMHsrXNcR68phvsPkDn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 15:49 -0700, Luis R. Rodriguez wrote:
> We were issues probe requests to the associated AP on the wrong
> band by having our beacon timer loss trigger while we are scanning.
> When we would scan the timer could hit and force us to send a
> probe request to the AP but with a chance we'd be on the wrong band.
>=20
> This leads to finding no usable bitrate but we should not get so
> far on the xmit path. We should not be trying to send these probe
> request frames so prevent the timer from stuffing beacon loss work
> on the mac80211 workqueue when scanning.
>=20
> Tested-by: Fabio Rossi <rossi.f@inwind.it>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/mac80211/mlme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 523c0d9..e90992e 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2187,7 +2187,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned lo=
ng data)
>  		(struct ieee80211_sub_if_data *) data;
>  	struct ieee80211_local *local =3D sdata->local;
> =20
> -	if (local->quiescing)
> +	if (local->quiescing || local->sw_scanning || local->hw_scanning)

I'd rather have  that check in ieee80211_mgd_probe_ap itself, so it's
much closer to the source of the problem.

johannes

--=-qQMHsrXNcR68phvsPkDn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaOsKAAoJEODzc/N7+QmajS8P/0I2mM3yHP+urW9N36m5a5Iq
wyujl9i5da5WKYQAK04ifs1Wj7lrG7V9XlaCm9YhCynNPNPZDgwBCCxhgEc3qab5
3TG6pa9oFLxSY/iaTL5Gthu+DqUCxx0nkyI2UyATihToZcK6D8xL4hSx1y8XJ5O6
IWBc68xCdQU5XHTZRC8z1DJcs3L2XTzz7+VhDHRnk4zL7r+W2Zx4kL8MV4KoK9bq
+9iwb+JAVV18MpmRw8GkavJ+9LHg5OjR6E7IptibKc4RAOG1REYHncZxYhPjgxFh
6CXj7x7I0Vcj0unsDNOTqmO58S+GjbPa3O6YLSsqWqNiZDdCBZ2Za+ZOjRnGB7Yb
8p5zuA7qBZ2TRKrETysyT1MA21ddMRNo2mi1Y58ImuZK0YgVAuntr8/iw2VJcT15
GbYULXm4oabl3hbYslSkwygmYui2DLDPDF9rpsUrojeT3uwNlG9/A3FzHAoQ7svl
5MGODqB/QBIyF95Wlu/knKAwli+DsWECR+npwUmRWeMMBRgyhZ6kUxv8iryPrcAP
B8S0mxjjykm1B+OuIJNJByXnwehTQPNSMw8ptvGwnn1PQy0IqshP5P44RqJAU4Pl
QhqQw28qDR2v34L5Wj1+Qj8W/KfPnw0kDHmLMoCgS1DYXFSU2viDVWEhOAU1lyZK
5b72lPAYw7qHGYXsxMZk
=pRBi
-----END PGP SIGNATURE-----

--=-qQMHsrXNcR68phvsPkDn--

