Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0AEJOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:14:51 -0500
Subject: Re: [PATCH v2 1/5] mac80211: fix race with suspend and
 dynamic_ps_disable_work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
In-Reply-To: <1261686369-12362-1-git-send-email-lrodriguez@atheros.com>
References: <1261686369-12362-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qtnO3ym0ZBj364AOFuOu"
Date: Tue, 05 Jan 2010 10:14:43 +0100
Message-ID: <1262682883.20098.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qtnO3ym0ZBj364AOFuOu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-24 at 15:26 -0500, Luis R. Rodriguez wrote:
> When mac80211 suspends it calls a driver's suspend callback
> as a last step and after that the driver assumes no calls will
> be made to it until we resume and its start callback is kicked.
> If such calls are made, however, suspend can end up throwing
> hardware in an unexpected state and making the device unusable
> upon resume.
>=20
> Fix this by preventing mac80211 to schedule dynamic_ps_disable_work
> by checking for when mac80211 starts to suspend and starts
> quiescing. Frames should be allowed to go through though as
> that is part of the quiescing steps and we do not flush the
> mac80211 workqueue since it was already done towards the
> beginning of suspend cycle.
>=20
> The other mac80211 issue will be hanled in the next patch.
>=20
> For further details see refer to the thread:
>=20
> http://marc.info/?t=3D126144866100001&r=3D1&w=3D2
>=20
> Cc: stable@kernel.org
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Looks fine to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/tx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index ac48c86..42bfd97 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1418,6 +1418,10 @@ static bool need_dynamic_ps(struct
> ieee80211_local *local)
>  	if (!local->ps_sdata)
>  		return false;
> =20
> +	/* No point if we're going to suspend */
> +	if (local->quiescing)
> +		return false;
> +
>  	return true;
>  }
> =20


--=-qtnO3ym0ZBj364AOFuOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwL9AAoJEODzc/N7+QmaE0cQAMeEhrzwMAL+poBNVzDAmcRT
PGCxH8tkG0DKJv5jUHsJZbDOsP6jxWNXP1nGCUSPek3Jr0z+gwOG5VKpNVX/35PM
1ADURi0Gse6CXZR1CoPa0hLAdBxniGSRP4NbK+IYxP4fTkfQbOAqlMJcpl4/Zxt0
Goo1smKArfXqA3WBc2KEEDv/obruVjbNKk8hp3uH7k90/JdOoTS7vJsD4ErcbIr+
nr4PqXYxZhPgi03aeuXlgOFVCNU7FVeHeG9vUuq5Ny7t84NfBpOZbYZ8zOrETHWK
ADS50k+ddE5IO2605Q2IcojGc8HWov+uv2UuiZcXjt1wM/Cd4jU7mhvJ5Ynlwn+w
+6tjZneAtTCoWBa4+NuP+SJKs/Ffm+SRVjom/5VtHy1GMQANBIJh1GlF2rbOR0Kj
sgrC2+QvwmFHvu8WRou7p6TWlwJbZg5kMmPbFQqgB+yirbIUplmYiHJbG038Id8A
y1DViRvj3PTThFWhOhSHQ24KT8I53ZieJ4pIhP4/r7d5z58Kde5Du5d4gIvpJXgC
5dOFEkHaEtPgbC8f5IaLdwiVPT8PNt+H9niguJGdqTc4fThuSvwVTlWh0NCaMgU0
h1fEa4FD58puc16770c3qI4vycl4JmvfBbK2zZSlWLh8JXveTUOWLikc66MQuJ9Q
LIFBphDsEdcvDGikwPHF
=XT3F
-----END PGP SIGNATURE-----

--=-qtnO3ym0ZBj364AOFuOu--

