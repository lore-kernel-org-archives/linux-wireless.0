Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:40318 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751894AbdIHJkn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:40:43 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] wireless: return correct mandatory rates
Date: Fri, 08 Sep 2017 11:33:32 +0200
Message-ID: <5435234.Pp2Z8V5qmG@prime> (sfid-20170908_114046_778491_3C0F0D92)
In-Reply-To: <1f7e466e-2a68-b97a-ee2e-21c3e74a9fc5@uni-koblenz.de>
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de> <5aed0ea0-f127-bd1e-ca06-db7edbf56680@uni-koblenz.de> <1f7e466e-2a68-b97a-ee2e-21c3e74a9fc5@uni-koblenz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2510620.iiW7xgGRZZ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2510620.iiW7xgGRZZ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

On Friday, September 8, 2017 10:53:37 AM CEST Richard Sch=FCtz wrote:
> Am 08.09.2017 um 10:43 schrieb Richard Sch=FCtz:
> > Am 08.09.2017 um 08:55 schrieb Johannes Berg:
> >> On Thu, 2017-09-07 at 17:47 +0200, Richard Sch=FCtz wrote:
> >>> Use IEEE80211_RATE_MANDATORY_G instead of IEEE80211_RATE_MANDATORY_B
> >>> for comparison to get all mandatory rates in 2.4 GHz band. It is safe
> >>> to do so because ERP mandatory rates are a superset of HR/DSSS
> >>> mandatory rates.
> >>=20
> >> This I don't understand - what "comparison" are you talking about?
> >=20
> > Sorry, I meant the condition that checks for the presence of
> > mandatory_flag at the bottom of the function.
> >=20
> >>> Also force IEEE80211_RATE_MANDATORY_A for 10 MHz and 5 MHz channels
> >>> as they use "half-clocked" respectively "quarter-clocked" operation
> >>> of the OFDM rates (IEEE Std 802.11-2016, 17.1.1).
> >>=20
> >> I don't think this is correct - the way the flags are used, anything on
> >> 2.4 GHz would never bother to check the MANDATORY_A flag.
> >=20
> > Do we actually allow 10 MHz and 5 MHz operation in the 2.4 GHz band? As
> > far as I can tell that has only been specified for OFDM PHYs, which use
> > the 5 GHz band and are covered by IEEE80211_RATE_MANDATORY_A, but I am
> > not a hundred per cent sure about that. Cc'ing Simon Wunderlich who
> > originally implemented checking of scan_width here.
>=20
> Looks like the old address is invalid now. New try.
>=20

Yeah, officially only OFDM has the half/quarter clock stuff defined, not ER=
P (2.4=20
GHz 11g) or DSSS, and also not HT.

However, technically, the Qualcomm/Atheros hardware (ath9k and ath5k) suppo=
rts=20
DSSS or HT on quarter and half rates just fine, also on 2.4 GHz.

I believe we currently support the 5/10 MHz on 2.4 GHz, although we shouldn=
't=20
when we follow the standard strictly. The question is if we should follow t=
he=20
standard strictly - this feature is already quite limited, and people tend =
to=20
use the ath9k/ath5k chanbw patch from OpenWRT/LEDE.

Cheers,
      Simon
--nextPart2510620.iiW7xgGRZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlmyY+wACgkQoSvjmEKS
nqG3FQ/8ClTTizM/A9dc76I2rZWSazS5W1otAZWPFPhk+cIqx3cj7M9PbzoWevhv
H43jz+jOOS7JBu7RQNs9PhpRu04z7UXskFISZwH2/tqPFkmosfFrwTIIv3S32H5E
MdPxCVCT//60vWQhsIbAnZg5uzdkgqTQJmAcL07lA9KzJszLAe6b+HzRkEZNW2DN
jicz3pW0YEm0ER0yOoUIauLdkRVn2vQ36vGae/V8Erfydr1V7zEyhjFBGKrv3b0c
XKWuxDL48ajUV6nhRAVDZilm3Rsr8MvsbBSvF5hyTZfP2+3xlhAi/7op28HOozs8
Mktiy97SLMfQWRjkAxW6xY0ad+2uk+sPCuzgLoEEp/8YQGPeprIhjGMJQ8TNpnWG
fniv+prnanMmnUzbtqtqynX1F35lM8LxrHUOsdEwpMGkx6J+bO9EY07mB40Vh8GA
q3L9xlmV9kiXbaK6NdvfpvUQh4pI0cIuwhyryImbLmjMJY5/mM+cYRL3jb7ZL+9Q
k/tBgRa+vjvvQlIFwPx0d9D1uwer4VATZMS44m4lKhUwBG6u4BESbq4xGbUUqvsj
B64KruXB6vyHLSL5PzOjLirtGBJ6OmJop5l/QDOT8xKgsy2bJrDal7sExC/2TpwN
Ax+U2vnBYL8ZevGLEerRw36fBrRBGgCG/0EG3uaxnYfWwyYLvEw=
=gGT+
-----END PGP SIGNATURE-----

--nextPart2510620.iiW7xgGRZZ--
