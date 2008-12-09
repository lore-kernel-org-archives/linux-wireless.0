Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:2357 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYLITuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:50:35 -0500
Received: by ug-out-1314.google.com with SMTP id 39so49306ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 11:50:33 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station info
Date: Tue, 9 Dec 2008 20:50:23 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812071917.07075.hrogge@googlemail.com> <1228765415.22164.107.camel@johannes.berg>
In-Reply-To: <1228765415.22164.107.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1412988.qTTqmlNGib";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812092050.29545.hrogge@googlemail.com> (sfid-20081209_205041_828645_7C95CD85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1412988.qTTqmlNGib
Content-Type: multipart/mixed;
  boundary="Boundary-01=_AwsPJ1vbYUXviS0"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_AwsPJ1vbYUXviS0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 08 December 2008 20:43:35 you wrote:
> And on your second patch:
> > +static u16 nl80211_calculate_bitrate(struct rate_info *rate)
> > +{
> > +       int modulation, streams, bitrate;
> > +
> > +       if (!(rate->flags & RATE_INFO_FLAGS_MCS))
> > +               return rate->legacy;
> > +
> > +       modulation =3D rate->mcs & 7;
> > +       streams =3D rate->mcs >> 3;

> I don't think this gives correct results for MCS rates 32 through 76,
> does it? It should at least not calculate anything then. If we did it in
> userspace then programs could also actually calculate the correct rate
> as a float, rather than this approximation. Not that it'll matter, I
> guess. Doesn't anybody know how to do the actual calculation?
It had a small type (corrected in the new patches), but I think the values =
are=20
good. I have attached a test programm to this mail that outputs the bandwit=
h=20
values calculated by the function.

Henning


--Boundary-01=_AwsPJ1vbYUXviS0
Content-Type: text/x-csrc;
  charset="ISO-8859-15";
  name="calctest.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="calctest.c"

#include <stdio.h>

#define RATE_INFO_FLAGS_MCS 1
#define RATE_INFO_FLAGS_40_MHZ_WIDTH 2
#define RATE_INFO_FLAGS_SHORT_GI 4

struct rate_info {
	int flags, mcs, legacy;
};

int nl80211_calculate_bitrate(struct rate_info *rate)
{
	int modulation, streams, bitrate;

	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
		return rate->legacy;

	modulation =3D rate->mcs & 7;
	streams =3D (rate->mcs >> 3) + 1;

	bitrate =3D (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
			13500000 : 6500000;

	if (modulation < 4)
		bitrate *=3D (modulation + 1);
	else if (modulation =3D=3D 4)
		bitrate *=3D (modulation + 2);
	else
		bitrate *=3D (modulation + 3);

	bitrate *=3D streams;

	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
		bitrate =3D (bitrate / 9) * 10;

	/* do NOT round down here */
	return (bitrate + 50000) / 100000;
}

int main(int argc, char **argv) {
	struct rate_info ri;
	int mcs;

	printf("20 Mhz wide channels\n");
	for (mcs =3D 0; mcs < 72; mcs++) {
		int r1, r2;
	=09
		ri.mcs =3D mcs;
	=09
		ri.flags =3D RATE_INFO_FLAGS_MCS;
		r1 =3D nl80211_calculate_bitrate(&ri);

		ri.flags =3D RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_SHORT_GI;
		r2 =3D nl80211_calculate_bitrate(&ri);

		printf("mcs %d:    long gi %4d / short gi %4d\n", mcs, r1, r2);
	}
=09
	printf("\n");
	printf("40 Mhz wide channels\n");

	for (mcs =3D 0; mcs < 72; mcs++) {
		int r1, r2;

		ri.mcs =3D mcs;
	=09
		ri.flags =3D RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_40_MHZ_WIDTH;
		r1 =3D nl80211_calculate_bitrate(&ri);

		ri.flags =3D RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_SHORT_GI | RATE_INFO_F=
LAGS_40_MHZ_WIDTH;
		r2 =3D nl80211_calculate_bitrate(&ri);

		printf("mcs %d:    long gi %4d / short gi %4d\n", mcs, r1, r2);
	}
=09
}

--Boundary-01=_AwsPJ1vbYUXviS0--

--nextPart1412988.qTTqmlNGib
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk+zAUACgkQcenvcwAcHWfcpQCcCOc96sNeUoXuW7NxQATk8EsG
FvUAnjOwYSx2Ix4HvoZsyfp+vA4oIT4b
=mHVS
-----END PGP SIGNATURE-----

--nextPart1412988.qTTqmlNGib--
