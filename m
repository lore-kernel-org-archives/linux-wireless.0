Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZGPKRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 06:17:07 -0400
Subject: Re: [RFC/RFT 5/5] mac80211: implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200907161150.54237.helmut.schaa@gmail.com>
References: <200907161104.41975.helmut.schaa@gmail.com>
	 <200907161109.40471.helmut.schaa@gmail.com>
	 <1247736318.24433.10.camel@johannes.local>
	 <200907161150.54237.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9Sr16x6M9ARhL+goMrUe"
Date: Thu, 16 Jul 2009 12:16:34 +0200
Message-Id: <1247739394.29762.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9Sr16x6M9ARhL+goMrUe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 11:50 +0200, Helmut Schaa wrote:

> > Based on your initial description I thought it was going to be
> > 	scanning =3D=3D SW_SCANNING
> > or
> > 	scanning =3D=3D SW_SCANNING | BG_SCANNING
>=20
> It's exactly the other way round :)
>=20
> It is either BG_SCANNING or SW_SCANNING | BG_SCANNING.
>=20
> I already thought that this might cause confusion but I think
> BG_SCANNING better reflects that we are currently running a scan
> (independant of the current scan state) whereas SW_SCANNING better
> reflects that we are on a different channel for scanning.
>=20
> Maybe I should use other terms. Ideas?

Ah, ok. Since your patch 4/5 changes sw_scanning to SW_SCANNING, I think
at least change it to BG_SCANNING there already. OTOH, I think people
are used to sw_scanning so it would be better to keep it. Maybe do
	SW_SCANNING
and
	SW_SCANNING | OFF_CHANNEL

or maybe
	SW_SCANNING | PROBING
or something like that?

> > Anyway looks pretty good to me! How does it fare during ping -f or
> > something?
>=20
> I compared it to the hw_scan implementation of iwlwifi. We loose a few
> more frames (I guess due to not flushing the queues before channel switch=
)
> but it's not really much, it was <1% for ping -f).

Yeah, we still need to add a queue flush callback for the hardware, but
that can wait some more.

> I didn't do much performance testing, just a single wget and the performa=
nce
> dropped to about 50%. I still have to run some iperf tests (both RX and T=
X) to
> see how it behaves.

I'd be more interested in the rtt stats that ping -f prints after you
abort it:

rtt min/avg/max/mdev =3D 0.021/0.028/1.726/0.051 ms

(this was on 127.0.0.1)

johannes

--=-9Sr16x6M9ARhL+goMrUe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXv3/AAoJEODzc/N7+QmaQzcQANAVn9Hm524jcHeZ/wIrRd4j
iUmB5SafIRGU99kQ68+we/3DPL8Ee+NvvdFAVxHpJJzIZV4bRp+l4BYSrjxX26SO
+Y6ydNeIPQ3zSzHNlQV+taqBLwhaG4oug+JdroLYKYQRCz+8VkdjaZ3jEV9KvAkv
cIoQJaRMOO/IyOCMXCZAP4EB5CLW3h4CX9XzPCfyEF7k5asFQYH2Q/yLCX6Eu5vN
nYL7m/3I39y01lyeQQAzbGRtMvbyGEKRYLb7HO0mPBG3VjRati4jxg7HeMxOL/95
FVXhjLVKTmwnfE9g1Ryy68SOZTlkcjwsSf5uBt/yQa5vv9VpZHH+hyIhAuSxO5lN
k2407XDYLVRmOEX9mOCTUi3phZamQjq0DiJjf4DjapzLEtOPxtL1uQOqsqOCfw1L
0TMAfoikKsuGElNACvhl5rUwxOBu239GRuGcZNdf+2fEaEPWfAn2oScf8CYYkLBT
KdUMicTMdIM2j3NFhe2998qcjopFlmfp68XohRZ208RTu7/Bby4v7gyeZvJhugFG
gA7LJqHMPqqbfIYjlvw1TpUS/6PvKqXtZ8N6tWC9ilFOw5td3wny1/gJz9cP4mlU
5RtzNhRbgW/fpRMlLBIScuv1tEeu5YNEMPomE7IxNOV4yPSDGGnCDEeP7EIQYzyO
GhLrMB+s+ueYvX0PzIli
=r/UX
-----END PGP SIGNATURE-----

--=-9Sr16x6M9ARhL+goMrUe--

