Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXIUV4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:56:52 -0400
Subject: Re: [PATCH 3/5] Wireless: add IEEE-802.11 regualtory domain module
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <43e72e890709211452j743fedfcyab6b981a0a3fce09@mail.gmail.com>
References: <20070921210437.GG31768@pogo>
	 <1190410242.18521.171.camel@johannes.berg>
	 <43e72e890709211452j743fedfcyab6b981a0a3fce09@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RaCj6gHzExbtksHqEcEr"
Date: Fri, 21 Sep 2007 23:58:10 +0200
Message-Id: <1190411890.18521.179.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RaCj6gHzExbtksHqEcEr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-21 at 17:52 -0400, Luis R. Rodriguez wrote:

> > Then we can use "enum ieee80211_band" below in the structs and get type
> > checking. Generally, no new stuff has anything to do with
> > include/net/ieee80211.h, that's just for the old "stack".
>=20
> Sure, I just wanted to point out the band def existed in another
> header. My hopes is we can address all common header stuff once in for
> all. I guess it'll have to wait a bit more.

Oh ok. But I think we should start using sane values (these bits look
awfully like you could OR them which is totally bogus) and convert the
other stack over.

> > > + * @name: name for this subband.
> >
> > Why does it need a name?
>=20
> Well to distinguish it.

But why do we need to distinguish subbands by name? What do we use them
for anyway?

> > > + * @min_freq: minimum frequency for this subband, in MHz. This repre=
sents the
> > > + *   center of frequency of a channel.
> > > + * @max_freq: maximum frequency for this subband, in MHz. This repre=
sents the
> > > + *   center of frequency of a channel.
> >
> > How can both be center freq?
>=20
> min_freq is the center of frequency for the minimum channel on the
> subband. max_freq is the center of frequency for the max channel on
> the subband. I guess I should clear that up a little more huh.

Uh ok, no, I just need to read better :)

> > > +/**
> > > + * struct ieee80211_regdomain - defines a regulatory domain
> > > + *
> > > + * @regdomain_id: ID of this regulatory domain. Some come from
> > > + *   http://standards.ieee.org/getieee802/download/802.11b-1999_Cor1=
-2001.pdf
> > > + * @regdomain_name: name of this regulatory domain.
> > > + * @list: node, part of band_restrictions_list
> > > + *
> > > + * This structure defines a regulatory domain, which consists of cha=
nnel and
> > > + * power restrictions. Some regulatory domains come from
> > > + * 802.11b-1999_Cor1-2001, the rest are based on Reyk Floeter's ar5k=
. If
> > > + * there is need to add more values here, please add one that is eit=
her
> > > + * defined in a standard or that many hardware devices have adopted.=
 Also
> > > + * note that multiple countries can map to the same @regdomain_id
> >
> > There's no table here where you could add values, is there?.
>=20
> There is a lot of them.. but we can add few to show as an example.

Then again. Why do we have this struct in a header file?

> I should have explained that too. Well, if you may recall in my last
> implementation of this I actually used a linked list. I then decided
> we weren't going to add new 2.4GHz or 5GHz subbands unless a big
> IEEE-802.11 change occurs. That doesn't happen so often to either use
> linked list or a variable length array.

Ok I just don't understand why you have this information in a struct.
Shouldn't all of this information be essentially internal to the
regulatory code, and people who use it simply query it and get back a
pointer to the subband that applies to their query? I don't see why
everybody needs to see this huge array.

johannes

--=-RaCj6gHzExbtksHqEcEr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9D5y/ETPhpq3jKURAn+7AJ9+VXNn2G+JtJemaLxFsE/BWTBv3gCghYd3
INZjpw43wa53VEHekhsPtMI=
=wAlH
-----END PGP SIGNATURE-----

--=-RaCj6gHzExbtksHqEcEr--

