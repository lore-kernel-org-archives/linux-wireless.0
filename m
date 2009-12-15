Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:40430 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZLOU4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 15:56:51 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Tue, 15 Dec 2009 21:56:42 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <1260899813-17585-2-git-send-email-8an@praha12.net> <20091215190051.GC2123@tux>
In-Reply-To: <20091215190051.GC2123@tux>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1742598.U2q9SdBkK0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912152156.48074.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1742598.U2q9SdBkK0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 15.12.2009 20:00 you wrote:
> Does setting the coverage class make sense for all modes of operation?
> If not it'd be good to catch those early and avoid setting them and also
> properly document them.
The coverage class is a physical device parameter, not interface parameter,=
 so=20
it's independent on whether the interface is AP or STA, there could even be=
=20
multiple interfaces on one physical device. It's the same as RTS threshold,=
=20
for example. And it has to be a physical device parameter, because in the e=
nd=20
it just sets some hardware registers.

> The AP seems to pass the coverage class on country IE, so I guess
> this means we can support this for AP mode and IBSS and only through the
> country IE for STA. Mind you that would mean hostapd would need to kick
> the coverage class as well and some new code on cfg80211 reg.c
> country_ie_2_rd() to parse it.
This part is not implemented yet, I wanted to do the low level setting firs=
t,=20
as the regulatory stuff is quite complex. It's still usable for long distan=
ce=20
point-to-point links (that are now impossible with in-kernel drivers).=20
Hostapd would then use the same API.

Lukas Turek

--nextPart1742598.U2q9SdBkK0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLJ/gQAAoJEEBjvk/UOfYwv+IQAJt5a03frZelA+7VBVQ26oJI
zsmZJFXn49jla/9xLX0pYDuOfFotG8syZSRPRlfSf9/6d+hATG6kOQIeg2GGiHfM
KI/TyuvnLC3DnQ+2mgnOepZVL2EFzOo6bkhOYOcWl5f+CXDs56cR2dZYNf7IIFMJ
3VPiy1ViFryhsSc20/K+1DqM8kzSATDNIARp1wQcBB62Idqtl/AGw9uFKr4T81C1
71PPrz+cKJQxJFq4KC10OqEPiA2kzmrGlDb+PTPXqrVNyZBe86I0Ype9oavJXAnV
62YlqqLbKNkD+87w1WKnkVp1+Zb7wrVU3+t0/kzHlvbFSruFF6Bb+WLk5a0ionOm
XtK2uz2Y1UD2CgrTbc6MOJnTTgjDftKUudBCU+ietvPPgOxLoO1H57wVY4FOdRZ0
odDvm8TRBns39LFi71PFwws50HQBRFHupXM2PIv68OMAT7HuNNSHDutBqplzNVqu
EX6qT4nam2B1/9DpvpWU5m3nA89IiuRChEXtnOt2+4Y3F4NSvokmCsaGfwFdMCIr
B7kp5hcGNhYTZ0QXLjZBQUvbL+BwOJ8DqYszySUvwKthuWyNdc29IlRm60I49cuQ
zozXonwC9qMaWPpxBF8LJMFv9ZmfIWnw6BSOq8HXLBQW2OnVxSzA12TEs3+n9JSV
kDraMlfo+Tz19aLrnSaA
=Lkcg
-----END PGP SIGNATURE-----

--nextPart1742598.U2q9SdBkK0--
