Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYJ0QER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 12:04:17 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Sujith <m.sujith@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <1ba2fa240810270856g7f585ddcvb1d0ef49aa31af45@mail.gmail.com> (sfid-20081027_165713_138785_17D0B5E6)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	 <1224669827.28639.54.camel@johannes.berg>
	 <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	 <1224696170.30459.12.camel@johannes.berg>
	 <18688.15460.336059.400706@gargle.gargle.HOWL>
	 <1224773201.6002.35.camel@johannes.berg>
	 <18693.53054.116942.355275@localhost.localdomain>
	 <1225119894.3796.0.camel@johannes.berg>
	 <1ba2fa240810270856g7f585ddcvb1d0ef49aa31af45@mail.gmail.com>
	 (sfid-20081027_165713_138785_17D0B5E6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aKmfQxY6QZj9Bdmh+tLP"
Date: Mon, 27 Oct 2008 17:04:09 +0100
Message-Id: <1225123449.3796.24.camel@johannes.berg> (sfid-20081027_170436_780937_30EDF578)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aKmfQxY6QZj9Bdmh+tLP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 17:56 +0200, Tomas Winkler wrote:

> In addition iwlwifi HW release TX packets in order to mac80211 i.e. no
> need to maintain the transition window
> so simple flag maybe shell revert the flow into regular tx response
> flow in mac80211.
> Only rate scaling is aware that the packets were transmitted
> aggregated, we did some hacking there around this it should be cleaned
> up.

I wonder how we're going to pass them down to the driver anyway. And how
about rate control, is that really done per sub-frame? Does that make
any sense? I'm thinking that if we pass a fraglist down for the ampdu,
then we should have the fraglist in tx status too, in one go... If rate
control is per subframe maybe it just needs to be made aware to walk the
fraglist?

johannes

--=-aKmfQxY6QZj9Bdmh+tLP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBeZ1AAoJEKVg1VMiehFYMP0P/Ang/mseecbeFy9X8zhgJLHQ
mbBdMYC+j58pcgsNiVWnK9g0x9AgOEWD5H/vFViFJ+dmGEksqRIbfL31qTffgS/x
Sfl6w4xKm5fcUCZIs2vCY1kwWBYuOxrPUWJJvPtjgxl5cxFyFydADyVaGEccnM4e
PCAFzu11zODlmDC27AsVCSaVgXm4Epe4mnAntMTncsqGm7MB+3kraBfzC2YXwkB3
A0RPlaC90X+KFIzHBHSAeS6k3jKuIalpWmgWt2YK1UACb9FEEwmwfFBctCtuyvwX
8rrPUTp0azipw8/CcxzZdH9pJHO4SyD8NEu5yHe53H51hXkebESC01rUCZz4ifX7
LexBbhhksRJJpD6UFXBcqDUDuGSFo29aRJieidElUDJfXhmXqeyggb5QAAQVdIkh
G+2BWyz+vcQnEjMdVBYd0dNTusFv57PW9nvT5tRatHVJbZ4SG9gnmpaCk4jOOvt+
erQMg6TOk7gIT7FRjUFjafeN80uucSFWagaF3Mjt9RtcWE/R5iaOH6N+enIwRIfz
J7SBPBk0KfXsAnfe+859duZEQDOqANsHdgc0IuvS3utAaVUqS6jJg1Oj5+a/Rn+l
cK5MZ3pVv1R8r6dXk8wPV1x+qxN2y+T2ZVwSrurYU554J27C6AMFqBiYKOLQ5bvG
YD9vF5cWi8UHuYLZzCIF
=cHda
-----END PGP SIGNATURE-----

--=-aKmfQxY6QZj9Bdmh+tLP--

