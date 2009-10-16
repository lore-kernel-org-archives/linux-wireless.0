Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947AbZJPLja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:39:30 -0400
Subject: Re: BUG: can bring wpa_supplicant/mac80211 into a stuck state at
 will
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1253776815.3868.10.camel@johannes.local>
References: <200909211259.45431.hs4233@mail.mn-solutions.de>
	 <200909211722.33577.hs4233@mail.mn-solutions.de>
	 <1253776815.3868.10.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Tfo9rts0QD3F3ZqbEFLQ"
Date: Fri, 16 Oct 2009 19:11:07 +0900
Message-Id: <1255687867.4095.334.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Tfo9rts0QD3F3ZqbEFLQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 09:20 +0200, Johannes Berg wrote:
> On Mon, 2009-09-21 at 17:22 +0200, Holger Schurig wrote:
>=20
> > iw eth1 link
> > Connected to 00:1b:53:11:dc:40 (on eth1)
> >         SSID: MNFUNK
> >         freq: 2412
> > Authenticated with 00:13:19:80:da:30 (on eth1)
> >         RX: 78173 bytes (722 packets)
> >         TX: 144 bytes (4 packets)
> >         signal: -67 dBm
> >         tx bitrate: 11.0 MBit/s
>=20
> This is very odd, I'll look into it.

Actually, it's not odd. It looks like wpa_supplicant never
deauthenticated, since :30 was the AP you connected to _first_.

I suspect it'll all work better if you make wpa_supplicant deauth
instead of disassoc.

johannes

--=-Tfo9rts0QD3F3ZqbEFLQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2Ea4AAoJEODzc/N7+QmaK8sQAJboUiXYPlc71Xm4bMLszU7J
ivHK+dAaLS5Z25pEyjB7LeO/ON/4Jx/gdbf6JZVa9Tnplglk85YSxIvkyU9dlaaI
OkahM/NcriDPx67H4FGSDk3cDPhNjszUv7bm9X0CWocYIfEgVLEhPTVJ8SJ1Krth
ju+ZnKrDclBZWjsUp5L5Gl9euoRGf4/2ppg5ml4SqBT+olyR/d0u1u8j4GdsQ1By
UpHpduwOmp+ct52Nfq9UoEza0MFkGPiODCVfThL8SMnl0KNQdw20tjCldCKxBxSW
lS9hPEIJRdGB2NHxyAy9eEp6ZKBDKJ+RZPvDrpDDAd7+vtkOblMsZBNhkVZ1dw/L
twHnU/1AlLyZzRo9ri4CGaALdT2gPq4Dkk2+6MIXMGGXZDnvSqMmzBqpWveVcTVL
h4bFdYU/4n4jS+FAoQdsy9M4U8R5r8Lo4LYSq/YN+Dnzc3rjsca9PyAkDfww5J2T
FjrF3dZqtX44drWuHX/bh31ID2jrDw96Of7AqdIYo5oO/+vUT/vM6G2VZkYWkYlV
NfZfeJtukeYnCYYLEc6+ApnmOLEl0LC6fGW/JUz0X01BC760/oQB26Ur9/eig1R6
JdjqcBEtbTa2NNgqw9HdW8RXhT251UYHAiNgm5Ksi2IHsC9bLtdRmA89xjDo0Rtw
0957dWD7b5gvRX3d3RD9
=IjIH
-----END PGP SIGNATURE-----

--=-Tfo9rts0QD3F3ZqbEFLQ--

