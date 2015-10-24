Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([37.72.148.22]:59774 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbbJXWLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 18:11:44 -0400
Subject: Re: [PATCH] mac80211: fix crash on mesh local link ID generation with
 VIFs
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <410200d1bd404c5c3acf66b8cabaae2860df2241.1445714370.git.mschiffer@universe-factory.net>
From: Matthias Schiffer <mschiffer@universe-factory.net>
Message-ID: <562C021D.5020404@universe-factory.net> (sfid-20151025_001147_723794_A11668D0)
Date: Sun, 25 Oct 2015 00:11:41 +0200
MIME-Version: 1.0
In-Reply-To: <410200d1bd404c5c3acf66b8cabaae2860df2241.1445714370.git.mschiffer@universe-factory.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="jOqgPV9POABcAimlnFBwBkGVHhqjR31jI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jOqgPV9POABcAimlnFBwBkGVHhqjR31jI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/24/2015 09:25 PM, Matthias Schiffer wrote:
> llid_in_use needs to be limited to stations of the same VIF, otherwise =
it
> will cause a NULL deref as the sta_info of non-mesh-VIFs don't have
> sta->mesh set.
>=20
> Steps to reproduce:
>=20
>    modprobe mac80211_hwsim channels=3D2
>    iw phy phy0 interface add ibss0 type ibss
>    iw phy phy0 interface add mesh0 type mp
>    iw phy phy1 interface add ibss1 type ibss
>    iw phy phy1 interface add mesh1 type mp
>    ip link set ibss0 up
>    ip link set mesh0 up
>    ip link set ibss1 up
>    ip link set mesh1 up
>    iw dev ibss0 ibss join foo 2412
>    iw dev ibss1 ibss join foo 2412
>    # Ensure that ibss0 and ibss1 are actually associated; I often need =
to
>    # leave and join the cell on ibss1 a second time.
>    iw dev mesh0 mesh join bar
>    iw dev mesh1 mesh join bar # crash
>=20
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> ---
> Should probably be queued for stable, at least for all kernels containi=
ng
> "mac80211: move mesh related station fields to own struct" (the bug was=

> there before, but it didn't crash without that commit).
Forget the queuing for stable, I just noticed that the patch didn't hit
Linus' tree before the 4.3 merge window.

>=20
>=20
>  net/mac80211/mesh_plink.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index 5838464..d1224d3 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -677,6 +677,9 @@ static bool llid_in_use(struct ieee80211_sub_if_dat=
a *sdata,
> =20
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +		if (sdata !=3D sta->sdata)
> +			continue;
> +
>  		if (!memcmp(&sta->mesh->llid, &llid, sizeof(llid))) {
>  			in_use =3D true;
>  			break;
>=20



--jOqgPV9POABcAimlnFBwBkGVHhqjR31jI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJWLAIeAAoJEBbvP2TLIB2cHPUP/Raxxr1B1iJqpuM6X5y0S2JK
k9kPIKs0ZSC57OCUIyUd4baqZtgc8MEPvESmcXsauWMazfqyUK7tK9tgoKgSKrng
J6LUkd+PxVGHHJtK3UrNZlsM/pgTte/LGB50vfHYncn7itPLzTeapEVRTBXdLqeJ
UPpUX09FaU4SkKzXwzF76buhgGzU7uPvtgX+RfcPqTmMYGS1keBctOvymdVeOuL0
Ro53a77/DHwAjNNFDQBtjBtAuPar72wDbIqa5gQsm9DwZ6aIVtvEolWTUSSHe93o
cQ5rs0V9MSsO4L18qQXT0M+EnWwY16CKJqfADhIS0prhjeogcgjXAp5YjnHPTKDG
v/vqHsnjxWZylTwCZm4JEYRwaVm4nMQOh3IZwrXpiPlM68OMVny2ZvjgTpsPLC5n
9U2Qn3P1Q3GS7bogAu71yah6hLpUSsYPYapDZZNiXEzh56yBDDU0OghKnKZ54O5I
Xj8JAW6PqNoNcpbgDG+tHOPXjwY++YdLB4OrQRt7jAAKzkYaaliw9Xej2RiOBwc0
f+wzQKfMKZCk2t7xLI9mR/aCEsCxSoLgrWv09mkncGnND8fCa1+tsIdLdT9Dz3Xw
s7A6vx/KVOD2m4ux+f7LSj7Pcfl/WkVAVO2Tf/AKkmoPAPy5pfNfXb9J6uDWxko+
8SabwRC3SPhmL7GEfIAy
=U6SB
-----END PGP SIGNATURE-----

--jOqgPV9POABcAimlnFBwBkGVHhqjR31jI--
