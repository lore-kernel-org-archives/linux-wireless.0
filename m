Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58932 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbbGWVGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 17:06:43 -0400
Message-ID: <55B1575F.40403@rempel-privat.de> (sfid-20150723_230646_904240_2454F2FB)
Date: Thu, 23 Jul 2015 23:06:39 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: wim torfs <wtorfs@gmail.com>
CC: rolf.anderegg@weiss.ch,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
References: <559D41B3.4050604@weiss.ch> <559F9AF8.5000208@rempel-privat.de> <55A3A672.1060502@weiss.ch> <55A79B5C.7010501@rempel-privat.de> <55AFC6E1.7060706@weiss.ch> <55AFCFDE.7060902@rempel-privat.de> <55B0A0E1.9090300@gmail.com>
In-Reply-To: <55B0A0E1.9090300@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0dDGEX2vqGTmRRufPSjMFtHJdosuR0EmB"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0dDGEX2vqGTmRRufPSjMFtHJdosuR0EmB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 23.07.2015 um 10:08 schrieb wim torfs:
>=20
>=20
> On 07/22/2015 07:16 PM, Oleksij Rempel wrote:
>> Am 22.07.2015 um 18:37 schrieb Rolf Anderegg:
>>>
>>> On 16/07/15 13:54, Oleksij Rempel wrote:
>>>> Am 13.07.2015 um 13:52 schrieb Rolf Anderegg:
>>>>>
>>>>> I suspect that there are bandwidth/speed issues when dealing with U=
SB
>>>>> adapters, but that does not inherently mean that the connection is
>>>>> prone
>>>>> to drop, right? Doesn't that mean that I am leaking packages somewh=
ere
>>>>> along the way? What else could I be looking for?
>>>>
>>>> The packages can drop if you will do channel scan. STA mode need som=
e
>>>> seconds to complete channel scan. It means AP will be all the time
>>>> unavailable.
>>>
>>> Ok, that may be. Then again why am I not experiencing the same
>>> connection drop on my ath5k setup? Because the channel scan is more
>>> likely to be completed in due time?
>>
>> Yes, channel scantime on usb device is match longer then on pci.
>>
>=20
> May I ask for the reason it takes a longer time to complete the scannin=
g
> on a USB device compared to a PCI device? I assume the internals of an
> ath9k PCI device is similar as that of an ath9k_htc USB device, so is i=
t
> purely the bus speed that affects this time? Or is the USB device a
> smaller version of the chipset on the PCI device and therefore with a
> lower speed due to power concerns?
>=20
> If it is due to the bus speed, would it be possible to decouple the
> scanning process from the bus, that is, I assume that the hardware
> performs all the necessary channel switching and channel sensing, so wh=
y
> not allow the hardware to gather such information and transfer the
> results in a single burst to the host over the USB bus? Or is the
> channel switching controlled by the host and it takes a lot of time due=

> to the duration of transmitting the channel switching commands to the
> USB device?

Well, it is about development time vs scan time: do as match as possible
with one code base or develop two different code bases.

--=20
Regards,
Oleksij


--0dDGEX2vqGTmRRufPSjMFtHJdosuR0EmB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlWxV2AACgkQHwImuRkmbWkkQwD/V5wkG2RTc0bqUwociLz/g6Cu
KwRxzYG8q87p7hEM/VIA/j71tmSEvCaM5VZPk1p80hJmecHnwpSl1yUnFMYHu+kn
=tQMM
-----END PGP SIGNATURE-----

--0dDGEX2vqGTmRRufPSjMFtHJdosuR0EmB--
