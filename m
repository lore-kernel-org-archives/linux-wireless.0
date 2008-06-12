Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbYFLUJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 16:09:13 -0400
Subject: Re: [PATCH 1/1] mac80211: fix beacon interval value
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806121305h721c6bd2x8073660d41653b92@mail.gmail.com> (sfid-20080612_220541_540944_8C5D557C)
References: <1213299517-24042-1-git-send-email-tomas.winkler@intel.com>
	 <1213299706.3730.39.camel@johannes.berg>
	 <1ba2fa240806121305h721c6bd2x8073660d41653b92@mail.gmail.com>
	 (sfid-20080612_220541_540944_8C5D557C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZjBnH1LONgHxNSzJX+qu"
Date: Thu, 12 Jun 2008 22:08:33 +0200
Message-Id: <1213301313.3730.47.camel@johannes.berg> (sfid-20080612_220916_833920_CA111E5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZjBnH1LONgHxNSzJX+qu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-12 at 23:05 +0300, Tomas Winkler wrote:
> On Thu, Jun 12, 2008 at 10:41 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> 1. in register_hw it honors value requested by the driver
> >
> > I don't think the driver should be able to "request" a value.
>=20
> Yes and no.
> The problem is that we don't have user space interface to tune this
> for IBSS so in this circumstances
> driver can choose what value is best for it.

I don't see how the beacon interval has any relation to "what is best
for the hardware/driver". And doing this just creates hard to debug
differences between drivers. All differences between different drivers
are causing problems at some point.

Wrt. configurability, yes, we should maybe allow this. Although it's
only used for IBSS (in BSS it is configurable already) so I'm not
entirely sure... users are probably not able to make an informed
decision anyway.

> >> 2. It uses default 100 instead of 1000 or 10000. Scanning for beacon
> >> interval ~1sec and above is not sane
> >
> > Yeah, 10000 seems a bit excessive.
>=20
> Actually this never took affect as there is no way that 0 is assigned
> to hw->conf.beacon_int but even 1000 is edgy and not suitable for a
> default value.

Sure, I'm fine with changing both values to 100.

johannes

--=-ZjBnH1LONgHxNSzJX+qu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUYI9AAoJEKVg1VMiehFYGMMP/2TdAhBDIh55E//1/49y1pON
7GwwGiJC360LHowAwhXtKAQcM72ZiojbdNUFdAuPCmr5Qj/4oJ5jcfd9z68KB74J
esWNgLw1rLOml4FPiyU58wq99IYoCDLEdLy2ZKAleL0mkgQZjJgUnfuAtiAwqSgV
L/i/P1n7354yZ+DlgljKvneSEzX7VR1zSFUVo3UrgkJ88HTeiwv7r8lg6Z5bA8Tl
J+03bd8I1cXMd0bVgRFy4RadNyVr++gB9X1TkmR4MSG2OnXGBOkd5yuNmgotQhTH
4OG4HqgTiXCtSuJFNWKVLdMRyyxMKO6mcuxOISLBY454qoZYIwhhJh5x1Lvx0PbR
hzrz9TUpdlurj2bobjtenQsJ6Jp/fUpx3LVOOFQLt0zr9pVDqssxt+t/q6oqIoeo
sXeNHmOXbSjBorBg5w+g7gBgPJO6IPHxEZZAJQ8bwzlLTvHyx0kj5ZW2WY4STh13
LMxXzYgf5ILybl2SrEJjUCjrDD30j1c25B4VnTlE08enxMn80PbzTPAj3joM2fp3
NvIPgB0v7Z1+IBE4tmxrvgMyG+kLVVrWoVgk87emwO9H9qp9Ep5xNE2arD80iT1y
Xi/Y0VD4L3WaYRJMsegHy/jS3tAIV9hr63Q4fu/HX1C1jmIdf3UNsguY1uUTHGg8
WZaNfycHks3hafi1VNQU
=iiee
-----END PGP SIGNATURE-----

--=-ZjBnH1LONgHxNSzJX+qu--

