Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZBPIuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 03:50:16 -0500
Subject: Re: [PATCH 05/10] cfg80211: add regulatory_hint_core() to separate
	 the core reg hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902160014k11ba609lbe1340750771b6c0@mail.gmail.com> (sfid-20090216_091419_672080_37A82B02)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-6-git-send-email-lrodriguez@atheros.com>
	 <1234695593.4219.47.camel@johannes.local>
	 <43e72e890902160014k11ba609lbe1340750771b6c0@mail.gmail.com>
	 (sfid-20090216_091419_672080_37A82B02)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jYnKuCr5XUvZ51BsDxar"
Date: Mon, 16 Feb 2009 09:50:11 +0100
Message-Id: <1234774211.4219.102.camel@johannes.local> (sfid-20090216_095027_760461_DD2BCF3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jYnKuCr5XUvZ51BsDxar
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 00:14 -0800, Luis R. Rodriguez wrote:
> On Sun, Feb 15, 2009 at 2:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
> >> This will allow us to clean up and make distinctions of who
> >> needs locking or not.
> >>
> >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >> ---
> >>  net/wireless/reg.c |   36 +++++++++++++++++++++++++++---------
> >>  1 files changed, 27 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> >> index ba82312..679fded 100644
> >> --- a/net/wireless/reg.c
> >> +++ b/net/wireless/reg.c
> >> @@ -1050,11 +1050,7 @@ static int ignore_request(struct wiphy *wiphy, =
enum reg_set_by set_by,
> >>       case REGDOM_SET_BY_INIT:
> >>               return -EINVAL;
> >>       case REGDOM_SET_BY_CORE:
> >> -             /*
> >> -              * Always respect new wireless core hints, should only h=
appen
> >> -              * when updating the world regulatory domain at init.
> >> -              */
> >> -             return 0;
> >> +             return -EINVAL;
> >>       case REGDOM_SET_BY_COUNTRY_IE:
> >>               if (unlikely(!is_an_alpha2(alpha2)))
> >>                       return -EINVAL;
> >> @@ -1183,6 +1179,26 @@ new_request:
> >>       return call_crda(alpha2);
> >>  }
> >>
> >> +static int regulatory_hint_core(const char *alpha2)
> >> +{
> >> +     struct regulatory_request *request;
> >> +
> >> +     BUG_ON(last_request);
> >> +
> >> +     request =3D kzalloc(sizeof(struct regulatory_request),
> >> +                       GFP_KERNEL);
> >> +     if (!request)
> >> +             return -ENOMEM;
> >> +
> >> +     request->alpha2[0] =3D alpha2[0];
> >> +     request->alpha2[1] =3D alpha2[1];
> >> +     request->initiator =3D REGDOM_SET_BY_CORE;
> >> +
> >> +     last_request =3D request;
> >
> > So before you documented that cfg80211_mutex is used to protect this
> > variable, but it's not used here.
>=20
> This is only used during initialization, have any better ideas?

If regulatory is initialised before netlink that is probably fine, is
it?

johannes

--=-jYnKuCr5XUvZ51BsDxar
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmSjBAAoJEKVg1VMiehFYvuUQAIER81uaKo+2MkmPc1AUODrG
c0ZuP8RbMsyxn1BVY270qC1vNIH45Wwr30eNqUgulRL9Id5O8f40M06ZbIuryBgP
O0wZO/hSdL9ZX+ygVIsGjvZucUoTDY1ScpDzKkQTzfNzVvwrq8l/VhcubhSQko/W
OoBQYcSqlmrW5x2Qys+w1bY8vUn/yrK5jFIMc/elrK5gtdkehie7Wsp4mw2CN+2R
xop+6hupTdQQ/vrYFMZAXiO8V9UD4Cmuc9x3FiAqt8umbGwNtc/O+yRYdaejunhd
CbMYR0kCx4tjdYghPBB+Xd4OnQM5o9JNmblhW8DcliCbIE2werJe6w0TTI/bgO4N
wOfeyT5j1wxGTlGLBDtPIDdwQZiZexlICAtKdggLoRUWGR3AOJJPcs1Ni+niROxn
ne7xx/501KhG6gfABbBawFQg5juHRw8CMhc62LMKGbWvLS8/qziXffs6G08/uadx
6qiIet0YTlLzWS7Fp1TPueoDm2wFE8pBVnAgCiY/9pKvH80DnSWgxZ4lZ2LPA3Ca
1EEacbncYPUkBhLh0JWPPFojfa7pd/J7qFMtHT66dwX/n9K8t17EFAAw2xsChmkB
609s6/msPBSS5ccCOFkaMBQUJYpGGMvojbYrvnSU2fi22XG63x++PsgC03WDskTw
Lo/Ewhf20U23JIRrlhCf
=g/Tq
-----END PGP SIGNATURE-----

--=-jYnKuCr5XUvZ51BsDxar--

