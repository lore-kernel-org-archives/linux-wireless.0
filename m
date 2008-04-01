Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYDBJFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 05:05:55 -0400
Subject: Re: FW: [ipw3945-devel] iwl3945: disassociation from AP (reason=4)
	andtimeout, a solution
From: Johannes Berg <johannes@sipsolutions.net>
To: Andres Bertens <abertensu@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <47F23C6B.6060205@yahoo.com> (sfid-20080401_144755_080818_247DF100)
References: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com>
	 <1206999696.20744.2.camel@localhost.localdomain>
	 <1207051434.5143.58.camel@johannes.berg>  <47F23C6B.6060205@yahoo.com>
	 (sfid-20080401_144755_080818_247DF100)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m0nkBp8m3GCoc6WQu7U+"
Date: Tue, 01 Apr 2008 18:42:33 +0200
Message-Id: <1207068153.5143.137.camel@johannes.berg> (sfid-20080402_100602_408770_F07D9641)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m0nkBp8m3GCoc6WQu7U+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Reason=3D4 is in fact "Inactivity timer expired and station was=20
> disassociated". According to my router log:
> "Tuesday April 01, 2008 09:08:54 Disassociated: 00-19-D2-4F-22-4D=20
> because idle 300 seconds"
>=20
> Indeed, the default behaviour goes for a reassocation=20

Right, I just checked, we try to reassociate after one second.

> but my hw/sw=20
> combination (intel3945/dlink/wep) fails with a status=3D17 (AP unable to=20
> handle new status).

17 actually is WLAN_REASON_IE_DIFFERENT, i.e. the WPA/RSN IE we send is
no longer appropriate, something for wpa_supplicant to handle then. Are
you using encryption?

> After 3 tries, it dies with an AP association=20
> timeout. From there is no recovery till I set the interface down and up.
>=20
> That's why I solved it (perhaps not in the best way) ignoring the=20
> disassociation. Now it works.

Your AP is broken. After it disassociates you and you ignore this
status, it complains that it deauthenticated (!) you and then
deauthenticates you again (with reason=3D6 meaning that you weren't
authenticated.)=20

The thing is, it's disassociating you and thinks it actually
deauthenticated you since when you ignore the disassociation and
continue sending it frames it starts complaining that you weren't
authenticated (reason=3D6.)

Your fix is obviously wrong, and only fixes the problem for you because
it works around your broken AP that needs a re-authentication after it
disassociated you.

I'm not sure what we can do about that. Assuming we're deauthenticated
seems completely wrong, and I fear that if we assume deauthentication if
the association times out then we may easily end up in a loop there.

johannes

--=-m0nkBp8m3GCoc6WQu7U+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Jl+KVg1VMiehFYAQLjiQ/+ITZERXYPDLV7NaRs6iJ7sYRLzLE2627+
a6ie3QVvX27BcTM2L8OCt9l2IwDWRBKh5GFgePRyGbYYg5L+YFpqwCocjZrifsx2
eBLcY3zHC1bR5W4rHEx2sczW6A1dhv6p9A4QeuzihkGukLjvsYM4T0GPYku0nh8u
m+riVw2RHjKet7DdrssAOeieeOBmgsoNUL04iovHtYpC4pRyvdSYVaWflPy5rFH9
BR2WTl7EHH3syiPZjYdvFpUF/ctVlvIU2x8X1OFjfOETnBFwU+pQ+7xEpsmQPZ0R
NNONdeFziGukXozDdoC/mUPssEIvuiUW3T7IOP22BswMRlG+yQM3bNRDUM/MmLPl
4CnKvEB07kW35t9PiX0Fj6LfTKJ6r/4lQI39UEGwMtlCnRE2c2/GCIFxSS1hC5O/
5Fc7/YqEsqxOLKQW+L0Z3dgEx66wIk7fBTycLkcg860sI1p6svyRomCCUF4F8OxE
7Jisa1GdvSUIWjDD8Sedf31r/7pViHb9td7+ap8W4l+vW8Q1bUfpxsXuquK39gaz
CTdAbhLi8GUmmSyI6wHXYsqqtMzNmX2Qh68h0M5IOSaLJQ0Aq1shGk6O5EOC3F4A
8cwZCP7TY+Gjo0ltNzg9NNjipR0/Ep8tx8cdC2JySANRYoqA0+Kg8IZeeBtUkjYJ
PkV0Fd+Byz8=
=+WGW
-----END PGP SIGNATURE-----

--=-m0nkBp8m3GCoc6WQu7U+--

