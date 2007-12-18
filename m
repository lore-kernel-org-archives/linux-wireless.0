Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbXLRNx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:53:27 -0500
Subject: Re: [PATCH 6/8] mac80211: A-MPDU Rx adding BAR handling capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712180545u46dc0a21obdc6d7b6c095b797@mail.gmail.com> (sfid-20071218_134627_418190_29EDCA18)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070783125-git-send-email-ron.rindjunsky@intel.com>
	 <1197915884.4885.93.camel@johannes.berg>
	 <c85cb4470712180545u46dc0a21obdc6d7b6c095b797@mail.gmail.com>
	 (sfid-20071218_134627_418190_29EDCA18)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dJHCvPH566lYD0fDyE6y"
Date: Tue, 18 Dec 2007 14:53:21 +0100
Message-Id: <1197986001.4885.144.camel@johannes.berg> (sfid-20071218_135332_726534_5F8F5470)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dJHCvPH566lYD0fDyE6y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> (lets put aside the AP that bombed me with 749 BARs over 30
> seconds ;-) i really think it was a buggy functionality of the AP
> there)

Heh. Fun.

> > > +             else if ((fc & IEEE80211_FCTL_STYPE) =3D=3D
> > > +                                             IEEE80211_STYPE_BACK_RE=
Q) {
> > > +                     switch (type) {
> > > +                     case IEEE80211_IF_TYPE_STA:
> > > +                             return hdr->addr2;
> > > +                     case IEEE80211_IF_TYPE_AP:
> > > +                             return hdr->addr1;
> > > +                     }
> >
> > Doesn't that result in a compiler warning? And what does happen if we
> > receive a BACK_REQ when we're an IBSS/MESH?

I was obviously wrong here, it doesn't result in a compiler warning
since you didn't use the enum type. It will once you use the enum type.

> IBSS is not supporting 802.11n currently (spec decision)

Ok.

> MESH i am not familier enough yet to answer. are you sure it supports 11n=
?

I guess we should just return NULL in all other cases here. But please
enumerate the cases explicitly so that people who add new interface
types get warnings, i.e. don't use a default: statement in a switch
(interface type)

johannes

--=-dJHCvPH566lYD0fDyE6y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fQ0KVg1VMiehFYAQJFihAAkyXToZq1A4N1p+VrRxzlig8q+VFrLqcz
s/ngB9OSIczpCXLVr6JHqSlSIh647VwqCY9N6uMpsQddLRmUtBt8wJWGn+Q4zMYb
oijzX87FuEL85j6A9G40bFbb7Bf9Evxj5r5R0+VjOdUAx25hTfg7PtK0jZpxkTPP
t+6+S1Nmp8DLhJSyQVjUX2l4OWeFIn+8tv6NcsLnmo/LsnpvIDkfPzDAYPrCaL/f
BKziHmeq7eADAottBXS6wdpaLg1J/HOVUrFiXjxE8GEaT1XcbThyLvBJfkJMQG+p
/m77tEnuorvf3SvSi3KbmR8wRJeXp6Gk+QSG2lNP3b+8qu3II7uSphFqOlLUhOdW
JURX7oxDKYUHSY0uhvsIkOg4Z7wIJqDUABG9F/AbPC3+PqUf2TVz+UUAACrLK960
jkVZRW16T8vIyiAoZRBwSC49gjJtuFEc2YQRmRY/SYqA0E2icC+6G6Mfb9BJuVXJ
jF21B1ZczRSK0AWjm01YlO80rRB7qVFFF/B9w/U6wsG8dAwIWiSRqo9+1LLJtqrn
I45ZaWQb7qJEHDMS5Fo3mZTyaCf0iV8QlTg51o6osbNU9Q0cKtYcRRJsEHLYK+I0
nXH9qm93lEWIykSq7QOjUK6IWEwe4shYa0zvVdHOqRhOXjLy28ncJS1aHNZuWP6F
plTb+QhXqFE=
=mqGQ
-----END PGP SIGNATURE-----

--=-dJHCvPH566lYD0fDyE6y--

