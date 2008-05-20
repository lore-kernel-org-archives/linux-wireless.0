Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYETNXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:23:55 -0400
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com> (sfid-20080520_151146_082729_EB773CDB)
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1211288251.6252.86.camel@johannes.berg>
	 <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com>
	 (sfid-20080520_151146_082729_EB773CDB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MJt2Uj1Z+NwoLaID1Vxn"
Date: Tue, 20 May 2008 15:22:49 +0200
Message-Id: <1211289769.6252.90.camel@johannes.berg> (sfid-20080520_152502_385858_E4FED770)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MJt2Uj1Z+NwoLaID1Vxn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> I suggest to insert at least some WARN_ON(1) for the else case.
> >
> > Disagree, not until somebody audits the code. We already know it can
> > happen and a WARN() won't help us track it down because it provides no
> > additional information (stack trace is useless)
>=20
> What about printk(KERN_WARN ), The else statement actually means that
> something wrong happened.

Thing is, I'm not totally convinced it is wrong to the code while it may
or may not be wrong... I think this patch should go in first as it
actually fixes the oops, and then we can discuss the merits of adding a
warning there separately. Maybe after we look a bit at the code and try
to figure out whether it can still happen after that patch from
Abhijeet.

johannes

--=-MJt2Uj1Z+NwoLaID1Vxn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDLQqKVg1VMiehFYAQIrYw/9GLmpND61ej8hNLToGRHHJPjBc9A5MuL0
/h7Q75lXXCRzLWuHz+QuHJ1lYQV456P4njTgsC1wdIWm6r6cCMZ48GSzieaJgBGb
sqHME383/2FO3gD5kyPU0slHHikDumXUuF4j3ZC49UQzaGhLvPWnV9symt3hONOK
lHsuuzPWkI7NXjCn3ALNF6QDtF7op1DfJvY+672//lfD5/wIHvmoFklle2tk+b4S
Kh7530m3Q4urX+m3wS0CesfilpnMYLrPeUWvm77wBR6iXyXFYBtHNY5CgEC64L7W
T9ZfEbBA8QxIJlt9AcwVYB5DPPUZ9TPzquKayX3lb7lQo0AXznlgV4FuROF2mF4G
983e5a+ktuawbOIMkXs/28kcshhBmaxTniJArnQOIQdYDPUoDWW7GVnOo6CkFhc6
DKuQRu70oCbFf9auKALv1AQYpI9+3u35bRVWvfuyUDCzVujZnD2LBJRM1AnEiTvG
x/GnfoE1MGYn1zpKPqSxupT1mVBAIavGf76V/wCqsj1XqgO6Y+VOUQubbRQhYmWy
nMevutLnCNaWv2WLB/ishi9hvdxa5ihmVK8a72KbrKLibBK/EtBE5uXkEtOJ+Xfi
6uhHVDti5xKG4lP86k+IsqUC/9soAd7Ozs4ctSEHZgbxikPDxbEqTizZpyhJm2Co
DoKx2Mtz92Y=
=ACc8
-----END PGP SIGNATURE-----

--=-MJt2Uj1Z+NwoLaID1Vxn--

