Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYKESLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 13:11:04 -0500
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d
	support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com> (sfid-20081105_175726_340747_38D6ED36)
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
	 <1225887783.3619.108.camel@johannes.berg>
	 <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com>
	 (sfid-20081105_175726_340747_38D6ED36)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KL5OUabpKm0dVoPaWNOY"
Date: Wed, 05 Nov 2008 19:10:58 +0100
Message-Id: <1225908658.3619.135.camel@johannes.berg> (sfid-20081105_191109_680580_23217E02)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KL5OUabpKm0dVoPaWNOY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 08:57 -0800, Luis R. Rodriguez wrote:

> >> +/*
> >> + * IEEE 802.11-2007 7.3.2.9 Country information element
> >> + *
> >> + * Minimum length is 8 octects, ie len must be evenly
> >> + * divisible by 2
> >> + */
> >
> > That seems odd, I thought there are triplets in there? That mean it
> > should be 2+N*3, no?
>=20
> Forgot the environment 'I', 'O' or ' '.
>=20
> alpha+environment (3) + n * 3

But then it should be evenly divisible by three, not two, right? And 8
doesn't make sense as a minimum length either then.

> >> + */
> >> +#define IEEE80211_COUNTRY_EXTENSION_ID 201
> >
> > Should that be something like EXTENSION_ID_OFFSET? Clearly they must
> > mean to subtract this?
>=20
> Sure but just to determine if it is a new one as they seem to come in
> increasing.

Oh ok, I thought it was ok to have multiple in the same IE or something.

> > Ok this I don't understand. Why the checksum thing? Why pass the
> > regdomain struct in? Can't cfg80211 do the work of parsing the IE and
> > you just parse the IE in, possibly "debouncing" when it hasn't changed
> > (or do the debouncing in cfg80211 too, for the overhead of an extra
> > function call)
>=20
> It seems wrong to offload onto cfg80211 some IE parsing work even if
> its related to regulatory. Are you sure you want that?

Why not? My scanning patch for cfg80211 also offloaded all of the
parsing to it.

> So we want two things:
>=20
> 1. A very quick and efficient way to determine if we can ignore the IE
> processing in case the IE has already been processed
> 2.  A quick way to determine if a new device can ignore IE processing
>=20
> The alpha2 on the registered interface solves the first
> The checksum solves the second

Ok, but why put anything of that outside cfg80211?

> If we leave the checksumming outside we need the helpers to check the
> checksum exported. Otherwise then definitely we can stuff it into
> cfg80211 but that means for a second device you'll pass the IE pointer
> and len as part of the regulatory_hint_ie() and it *can* fail for
> several reasons (-EALREADY, -EINVAL, -ENOMEM).

Except nobody will care about the return value, so you might as well
leave it off, no?

> Another thing we should consider here is the case of an Indoor AP and
> an Outdoor AP. According to Felix this is very possible and he's dealt
> with it. I doubt 11d is being used in those cases but regardless it
> seems we should account for it and deal with it. In that case it seems
> two different registered devices can be using one country but
> different environments. I have kept this in mind but admit not
> thoroughly. I think its good to see now what changes we'll need. Maybe
> we can deal with this later on though.

We may well need different indoor/outdoor settings at some point and a
way to tell the kernel which device is out/indoors, but that seems to
only affect TX power so I wouldn't worry about it too much for now.

> >>       case REGDOM_SET_BY_USER:
> >>               if (last_request->initiator =3D=3D REGDOM_SET_BY_COUNTRY=
_IE)
> >>                       return REG_INTERSECT;
> >> +             /* If the user knows better the user should set the regd=
om
> >> +              * to their country before the IE is picked up */
> >> +             if (last_request->initiator =3D=3D REGDOM_SET_BY_USER &&
> >> +                             last_request->intersect)
> >> +                     return -EOPNOTSUPP;
> >
> > Can you use a more customary indentation of the second if line to just
> > after the parenthesis?
>=20
> Like what
>=20
> if (foo ||
> <TAB><SPACE><SPACE>bar)
> <TAB><TAB>bar;
>=20
> ?

at least that's what I do, yeah, sorry if this seems too trivial, if you
wouldn't have to respin the patch anyway I wouldn't even mention it.

> > When I suggested to use a checksum I was thinking of an easy way to
> > debounce. But a checksum is never perfect. Hence, the WARN_ON you added
> > might trigger despite the debounce checksum. Or we might fail to follow
> > changes.
>=20
> Let me know what you think about the alpha2 + BSSID thing above. I
> guess it should also consider the environment (I, O, ' ') in case the
> AP is reconfigured to be outdoor (without being moved). I don't think
> we should care about supporting these cases on the fly but we should
> ensure the change won't break things.

Well I haven't checked in detail which things you care about in the IE
now, but shouldn't you check if those changed?

johannes

--=-KL5OUabpKm0dVoPaWNOY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEeGuAAoJEKVg1VMiehFYkp8P/Rud1cqbEnCPyDjCckhaP7rp
/74AHhR9zE4yHtrXIsbW65zb4O7oQOFwQsAn2GDvZmIiIlrU5o4oMO9kSfh2a+jJ
Few0msGMX0aveiRqwbVnyIoO6HIQy/OM9lnshs4tGcSgvJWVtsejeO+FD1xyt2CV
+jHIbeLwQBha+6fKkYyAJsUxJgSaxffXDApNAV8x+mX/SW0lKXbKJADb+5AqBbEs
mQd9u+jnnf0U97v4bl+MVSZBiOvjao7uNN2X5Srk4sgiAIv8Tia0JQBelPTRK/Lx
ppTf3ce0TMVLvuQlRy9xvopECZSMLLlNXZkBrBUkus0zybQsYi62ITwYOp344VUd
QXa+XPI6yLQyK59M0UYlO9zS0Th8kSVghhRaWc60Fu97nnnf6tXEPC/JOZ9g8qd1
dPt8b8/EGot0UbFN6AziD7tPxh6BitNi2EQnsIyTKVls2/fNb8RckYw6jmeqyQ4c
anjxWe6pqtoVtWeNbW4rMGv2Q8jBjrjfMp3aj2hEWeBbh27ETYaZcZY4d+kJt1EY
TSBu4qFy6WSTdl2I1d7VwitZlYCsxE2S/TF8YdY3/cBjXoByLdKT2NfA6sVK6my5
25pScoywfI31udRGYj3O72iFRsnI9TQxpYuW76IjVdM7zcybGT70FeadXdJOAm2N
J/u7qAvNLCk5HoFkWtZK
=wZXP
-----END PGP SIGNATURE-----

--=-KL5OUabpKm0dVoPaWNOY--

