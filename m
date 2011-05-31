Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47622 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328Ab1EaDUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 23:20:23 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Mike McCormack <mikem@ring3k.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4DE45D54.9050301@lwfinger.net>
References: <1306791271.4277.39.camel@localhost>
	 <4DE45D54.9050301@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-C3PE5kUxDoZV6mTQC4CJ"
Date: Tue, 31 May 2011 04:20:13 +0100
Message-ID: <1306812013.4277.89.camel@localhost> (sfid-20110531_052026_798707_C08C83BF)
Mime-Version: 1.0
Subject: Re: rtl8192se replacing rtl8192e?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C3PE5kUxDoZV6mTQC4CJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-05-30 at 22:15 -0500, Larry Finger wrote:
> On 05/30/2011 04:34 PM, Ben Hutchings wrote:
> > I'm happy to see rtl8192se in Linux 3.0-rc1.  I noticed that it claims
> > PCI device ID 10ec:8192, which is already claimed by staging driver
> > rtl8192e.  Is it intended to replace that driver, or are there two
> > different devices with that ID which they will distinguish in their
> > probe functions?
> >
> > If is intended to replace rtl8192e, shouldn't it also claim these devic=
e
> > IDs?
> >
> > 	/* Corega */
> > 	{ PCI_DEVICE(0x07aa, 0x0044) },
> > 	{ PCI_DEVICE(0x07aa, 0x0047) },
>=20
> The RTL8192E is a different device than the RTL8192SE, thus rtl8192se wil=
l not=20
> replace rtl8192e. The way to tell them apart is the PCIe revision id. At=
=20
> present, I don't have a method to use that info to load the correct drive=
r, but=20
> I will be working on it.

It doesn't matter too much if both drivers get loaded, so long as their
respective probe() functions fail cleanly and return -ENODEV when called
for the wrong device.

> In addition, I need to acquire an RTL8192E.
>=20
> No, rtl8192se should not claim those Corega devices.

Thanks.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-C3PE5kUxDoZV6mTQC4CJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATeRebee/yOyVhhEJAQpQSQ/8CxLbr47Yq3SUA212n3JXKeXEjmZMCYb1
ZH1IRc3t/WX7XLmPwqrZFJainbuRGtloO7KzC23Oh2ZJfbez2lm7ZLjC8Qgjjz0N
adPR7E3crISYg7HIUCZxsSgzqa36KB2e4x75JszIeEtjigKQ6CJD+D6oOdT6CmE3
5bymu2WqWW0CR4RukeJcvc0az0kho1m7HU8vCLiz6LAALpnQEKRT2GDtZaMpP6Y6
NFI1xqKaFp9Hrr/UGSMZuCkCKxZGazBJ4MToiL5bThhsMXUuxt+FBGfqyMneTjaP
dH0cF6vGEmw+52NW7zClHDh9rpcsAL2rfw36KlTkRDxnUfo7xEtH2Rf9kP7/DBQM
f1JfDHbqZYEH1BtOFMm0x0Q4gnVPJManiVY2RACh0gY16fqphpBzWEWZ3+fB+Enr
lzM5he3O+4RF2sydIWNcoHhR47UQyNAfOKrrh8fd8wjnckU5NTf/+xlSvHGiJj8D
dBWMeqdQzhuQDbs5L3NuT3UkSswF87Etbx24rg9KXIUpJEoWMwj3Mm3UeDtAguJ4
8xZGsoOe16/55Q787ZamjJytFyemrjt+yV2WgVplP9sBcYrtXRuceAkiyRe7jR/Y
QB0bvHyKMxVLb3xD42VzBqQIbJJ7DlmByRxGSvPEMsvx1PV9xPW8Xo18wHLnYVTx
mv/c8mvDkb4=
=1DWd
-----END PGP SIGNATURE-----

--=-C3PE5kUxDoZV6mTQC4CJ--
