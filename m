Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:22183 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752436Ab2LJKun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 05:50:43 -0500
Date: Mon, 10 Dec 2012 11:49:37 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: in AD-HOC mode wait for the AUTH response
Message-ID: <20121210104937.GA26638@open-mesh.com> (sfid-20121210_115046_417144_7109E07B)
References: <1355134917-17705-1-git-send-email-antonio@open-mesh.com>
 <1355134917-17705-2-git-send-email-antonio@open-mesh.com>
 <50C5BCC3.8090809@lri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
In-Reply-To: <50C5BCC3.8090809@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2012 at 11:43:15 +0100, Nicolas Cavallari wrote:
> > -	if (auth && !sdata->u.ibss.auth_frame_registrations) {
> > +	if (!sdata->u.ibss.auth_frame_registrations) {
> >  		ibss_dbg(sdata,
> >  			 "TX Auth SA=3D%pM DA=3D%pM BSSID=3D%pM (auth_transaction=3D1)\n",
> >  			 sdata->vif.addr, addr, sdata->u.ibss.bssid);
>=20
> If userspace registered for auth frames, then we shouldn't wait for auth =
responses,
> as this code will never see them.
>=20

Correct. I think in this case the station should immediately be authenticat=
ed in
this point using an else branch.

> I'm also curious about compatibility with the current wpa_supplicant whic=
h does not know
> about that new event.

Yeah. A patch has already been prepared, I'll send it once this patchset ge=
ts
accepted.

Thank you for reviewing!
Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxb5BAAoJEADl0hg6qKeORwcQAK1fXuU0DyWK11ph8v43y1Fd
Z/zlfSwVsm0O5YKzX9yX2sL2fNiZLHstPKcn6ZAWLICJLAPtLpvGSi+TZNAC+rw7
QSI8vwF6q5GVqflnXQ59XumHQ2mwYYGAoe9Ut54vtPkTz/DCuBQhsPzQKY/VRj/t
YSsb/Ii6Az2AngmAMzzXc2suwPCDqVqdekFOZ3Vv3MfQdhDhMX0wvfREzg0sYbYp
PuNfY82uKHoWtHK0fhDJM7OyJgWPyCHy2GcweuYV7ERT4/yWSLCkKC0Gx4EOB6D4
th4rNCPs3EskPNlKAWeEYEEepMIuEyVvNUO8ytHdKlENOtBrwi1HWm7O1oCreEqR
wVda9XjawvOvDywL907IzOJkYtfTawHgO0Tyz1oPucOes3HEBWxpy/kth+8c+z6u
0p672MeGQjL5nbG6WcJZfN5F2aTorwCR303ESapX+whS73ZWXmsWhCouCY3dOVof
UO1gNIaX7uAJFBicvon3YxngXuDuF/JNhD7VHv60B2Ik2MFPTlBMd0vqEI+04ean
RdiMqoSIaaT+1KjNVAW8EAIaKh5Px2SeVXS/SP6GIXu4f6k2tj7brJQenjR6d7eI
W2W2K6Xbd4VRE7H5A6bkuMDX0xjdjA6gpXKeqZ+cVkNYFRON/cRKRH+609LJzvDA
pLCQIW5MMY1tQy5EgUbw
=JvOB
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
