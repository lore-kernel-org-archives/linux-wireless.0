Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbYJ3PIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:08:46 -0400
Subject: Re: [PATCHv2 5/5] mac80211_hwsim: Make sure beacon_timer gets
	deleted
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081030150254.961883544@localhost>
References: <20081030145920.233178987@localhost>
	 <20081030150254.961883544@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PazSVFG2Fw71IUZpuENO"
Date: Thu, 30 Oct 2008 16:08:40 +0100
Message-Id: <1225379320.3690.58.camel@johannes.berg> (sfid-20081030_160849_037954_A53D6618)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PazSVFG2Fw71IUZpuENO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 16:59 +0200, Jouni Malinen wrote:
> plain text document attachment (hwsim_del_timer.patch)
> It was possible to trigger a kernel panic because beacon_timer may not
> have been deleted in all cases when the kernel module was removed while
> hostapd was still running.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>=20
> Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2008-10-3=
0 16:11:33.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 16:=
26:49.000000000 +0200
> @@ -290,6 +290,7 @@
>  {
>  	struct mac80211_hwsim_data *data =3D hw->priv;
>  	data->started =3D 0;
> +	del_timer(&data->beacon_timer);

should that be del_timer_sync, just in case? Not sure how that works
with the rearming thing, I never really understood rearming timers.

johannes

--=-PazSVFG2Fw71IUZpuENO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCc30AAoJEKVg1VMiehFYkBIQAK71/U3Z3/EHI1BPqz7Tpbry
F0cdR5j0ipjdl8eySuuzfzYdoAA1yGRfQvVUmaGJEz52+7GATnmjbNXHiR+Vj8iN
OcJig/GeHbKJPY7fEpQ01UXoQHT/EDBXtyBnv3z9TIfjudXKT9KBsB1I3agHKXcF
AUTNBnk9zipBA8aHHEU14iJM4CVBvGA++2E2CdEFHcnlFUS5Av941tH8hjtu99SK
EstRt/bQY6eAbwOYItF6qsIRWjygJsUkYyl0iHMIb/RDNo8nFcWKy0LpuFoUcxNm
HTdw1+76AmUSG0UNgzG1BCXOL0ShFumVrdi41YbG6ZNFCCvIbw/MCzcSBczMEjYQ
iy1M/YKKI/rw3JbsH6eqju3ZbywmxgoxW7BP1DlURuve+78aBzsW356+ZORSXnFo
uVF334H/9x6mKbY9t5I2ilvYriHr7qiEp9n43c8qcS04TJbFm4nGB5ZwUHK4CWVu
SVqIshkSM8UJe9K6oYKE2oMsFr4MC9YQzm2WJYbqvPLHT192uljcwZCZNoYfhiLP
JG2VdfdQUbBjk5WNGvmT8dSmHtxx6O/NG1h/DIekUMU6H+R8C+Tp2zR+2A72DV5+
QvlDVe/8M3KcDZ7scmZMck10wCQtnN+kwXiNUgqB916t6Wzh36ZZbaDTQ+E4thlj
bur0escBhPNtEhe8dl2i
=+bSX
-----END PGP SIGNATURE-----

--=-PazSVFG2Fw71IUZpuENO--

