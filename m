Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:55487 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZKIVKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 16:10:47 -0500
Message-ID: <4AF88505.2060802@web.de>
Date: Mon, 09 Nov 2009 22:09:25 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Kalle Valo <kalle.valo@iki.fi>,
	Holger Schurig <holgerschurig@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar9170 in AP mode
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi> <4AF6CC02.8080204@web.de> <m3639k9kq4.wl%holgerschurig@gmail.com> <87ocncdrfz.fsf@purkki.valot.fi> <20091109141458.GA2805@tuxdriver.com>
In-Reply-To: <20091109141458.GA2805@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD8BF44595FE2552726CE7905"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD8BF44595FE2552726CE7905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

John W. Linville wrote:
> On Mon, Nov 09, 2009 at 10:37:36AM +0200, Kalle Valo wrote:
>> Holger Schurig <holgerschurig@googlemail.com> writes:
>=20
>>> So, I personally prefer to have "Do an AP right" or "Don't do it at
>>> all". But please no general enablement.
>>>
>>> But, for example, having some CONFIG_AR9K_AP_MODE depending on
>>> CONFIG_EXPERIMENTAL and a bit fat warning would do for me. Hopefully
>>> this would scara away distros, so that they don't turn this on for
>>> there standard kernel :-)
>> I think EXPERIMENTAL is not enough, I would prefer that the user needs=

>> to patch the driver to enable it. Or if that's not good enough, then
>> maybe depend on BROKEN.
>=20
> Here we go again... :-)
>=20
> So I definitely agree that it should be off by default.  I also agree
> that it should be difficult to turn it on accidentally.  We don't
> need any extra wierd bug reports.
>=20
> OTOH, I think we can all acknowledge that many people have reasonable
> use cases with their fleet of equipment.  I wonder if a sysctl would
> be enough of a deterrent?  They are fairly simple to turn-on, but
> you do have to know about them to do so...

/me would be happy about such thing as a short-term workaround if a true
fix is more complicated. So far I'm lacking a feeling for the complexity
- low-level 802.11 is unexplored terrain for me.

Could someone briefly explain how the firmware is supposed to handle
this case? By scanning outgoing frames for multicast addresses? Should
the DTIM condition be detected and reported (via beacon) only by the
firmware, or would the driver be involved to some degree? If we handle
this transparently in the firmware, I guess that it would have to buffer
not only a single multicast frame, right? Do we have enough memory for
this on the chip?

Jan


--------------enigD8BF44595FE2552726CE7905
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkr4hQoACgkQitSsb3rl5xRNNQCdHuF7s1zI56nymoc5XPdcIvpL
/WMAn2udDkYJ7opFndM51eRvh1Bv2+zh
=l3X6
-----END PGP SIGNATURE-----

--------------enigD8BF44595FE2552726CE7905--
