Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYJTKQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 06:16:04 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18684.22627.103501.578126@gargle.gargle.HOWL>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <43e72e890810200214g16f847caqa6cbf724b7b7b625@mail.gmail.com>
	 <1224494669.18024.51.camel@johannes.berg>
	 <18684.22627.103501.578126@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ufYpTJjXH8jR15oawBuB"
Date: Mon, 20 Oct 2008 12:15:58 +0200
Message-Id: <1224497758.27899.3.camel@johannes.berg> (sfid-20081020_121614_789837_B531E9A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ufYpTJjXH8jR15oawBuB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 15:37 +0530, Sujith wrote:
> Johannes Berg wrote:
> > On Mon, 2008-10-20 at 02:14 -0700, Luis R. Rodriguez wrote:
> >=20
> > > Indeed I agree with this. I think we can do this in three steps:
> > >=20
> > > 1. resolve aggregation for now for ath9k
> >=20
> > That's what Sujith's patch does, basically. It just leaves the Intel
> > hooks in place.
> >=20
> > > 2. resolve aggregation for amdpu_queue case. My suggestion here is to
> > > use skb_buf_head (after Jouni's suggestion for our driver in fact),
> > > and do not make use of a qdisc at all for this
> >=20
> > I agree on both, but this is more of an implementation detail than an
> > API description, which we really want to have first.
>=20
>=20
> Would be nice if an interim fix is accepted temporarily,
> until the architectural details of proper mac80211 aggregation
> support for the 2 classes of HW are defined, and implemented.

Yeah I think that if you clean up this patch a bit wrt. that flag and
double-check it won't cause problems on hardware that cannot do
aggregation at all I'd be ok with it. Like I said, a later patch can
remove all the if (ampdu_queues) stuff

johannes

--=-ufYpTJjXH8jR15oawBuB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/FpaAAoJEKVg1VMiehFYKEQQAJURnqUYA/AQOyXQPDZoCaHp
VZHXzrbNOlDVkNEqEOuzh73vWA1l5GpoXOhvjsmBvKjSjUo7XvnQaMXlMQfNUGSq
fCPpReszlTKHVOAnZwXQ0RPyjgiMXJJJSU0p3BTLltbawmIMkdWlI7ASmiz1zCdT
gv0kGpiTANANFDDqC4QC4PaBen1IK5FBR45pS9ZQtlbLI0/7almo/v3d9wGB2DOL
WXNGVQHYC7p0iFjJSZV/2/+R9OACeUrPCJBjvSSbgSCj4oouUYz5MIfcyNVu6Zke
JLmXScIJJ8OdnHrsw20qk25Ygp28PMVDoPwd1DNyyibp/NXRGVhal2McykJCPphx
YcH0S3AMnWALFWQFBhwpJHMFvHUX9CaWHJ8QmMG+7Q9mtOoSaEXO2nv6+ZzRtKHQ
NoX0Ac4Ff/t7/wQxObYNoxsIVHxWLfGd6wVMpgchIwx6Gt2Oh1DmroQ2ysJw7Wed
lh4SO1m4YAngj/yxFbDwQ2k/nhXXiijJZv6JcKeKON63IWt6xyfpPmxu55kbQZmc
SxJruoMTyRHA/dkVCq94Gk2x8eVe8j7tbiC3XRyJuTb6cNZW2ChgnAk/GKSCZX97
DRBRNA8uqg7ppwPHmaAOXIQcas9iigQnr3EOIfAOx575jN3MVpSnMS8Rg6qjkcuK
IjcjtVSgymlbmfy0skoL
=+l7w
-----END PGP SIGNATURE-----

--=-ufYpTJjXH8jR15oawBuB--

