Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbYJVTaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:30:25 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
In-Reply-To: <20081022122148.GF6190@tesla>
References: <1224585110.5521.8.camel@johannes.berg>
	 <20081022122148.GF6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2H/hDXAApOCYiyoJMQTV"
Date: Wed, 22 Oct 2008 21:30:14 +0200
Message-Id: <1224703815.30459.61.camel@johannes.berg> (sfid-20081022_213032_412665_9703B512)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2H/hDXAApOCYiyoJMQTV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> For our purposes though this is OK though, just wanted to make that
> note, so we keep in mind this *can* potentially be used by other
> wireless foo.

True, but that hopefully won't even try to use this hint :)

> > +/* This has the logic which determines when a new request
> > + * should be ignored. */
> > +static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
> > +                         const char *alpha2)
> > +{
> > +}
>=20
> I take it reg_is_valid_request() was just shifted, no changes were made t=
o it
> here?

Actually, I think I made a small change within, replacing a sequence of
if (...) with a switch().

> > +void regulatory_struct_hint(struct ieee80211_regdomain *rd, u32 bands)
>=20
> I see you changed the return value to void for both routines the driver
> or a subsystem can use, can you elaborate on the kdoc why this is the
> case?

Well, I don't think I should explain in kdoc why there is no return
value, but I think that the return value is pointless on a _hint_, as
we've seen in earlier discussions everybody seems to be confused by it.
Can you cite a use case? When would you ever care what the system did
with your hint?

> > +       /*
> > +        * ignore hint if anything else set it or if the given
> > +        * bands overlap already defined bands
>=20
> Is the assumption all along here that this is for hardware which register=
s
> only the channels its hardware is legally capable of? If so can the
> documentation clarify that?
>=20
> Otherwise it would seem to me if USER already set it we should get the
> intersection. For example when a user plugs in a USB wireless
> card it would not have gotten the chance to have regulatory_hint'd
> first so the user may have already set it and if the driver
> didn't have a reg_notifier() and simply registered all the channels
> upon mac80211 register then the channels the user set will be
> allowed. Also what about when the COUNTRY_IE had set it (remember the
> result of such country IE request may be in an intersection with the
> first driver too, but its ok, we always can trust the result of the
> structure of the last set regdomain)? Again, disregard this comment
> if the answer to the above paragraph is yes.

I'm not sure I understand your concern. The point here is to allow a
driver to tell the core what it thinks the current operating domain is.
How do you define "[what] hardware is legally capable of"? The
assumption is that a driver will use this hint function if it thinks it
knows what the current operating domain is, in terms of frequency ranges
etc. I don't think there's any other assumption here.

> > +       new->alpha2[0] =3D '9';
> > +       new->alpha2[1] =3D '9';
>=20
> What about cases where the alpha2 can be determined? I know we have no
> such hardware yet and doubt we will though. Or are we just going to
> point those to use the alpha2 call instead?

Yeah, why would hardware tell us what the regdom is if it has alpha2?
This hypothetical hw could also do both, first hint the structs and then
the alpha2, and if crda is installed the alpha2 hint will call out and
update.

> > +       new->n_reg_rules =3D origrules + rd->n_reg_rules;
> > +       /* original rules still intact */
> > +       memcpy(&new->reg_rules[origrules],
> > +              rd->reg_rules,
> > +              sizeof(struct ieee80211_reg_rule) * rd->n_reg_rules);
>=20
> So did this work ? :) Zhu Yi, did you get to test?

No idea :)

> >  static void print_rd_rules(const struct ieee80211_regdomain *rd)
> >  {
> > @@ -710,7 +780,6 @@ static int __set_regdom(const struct iee
> >=20
> >         /* Tada! */
> >         cfg80211_regdomain =3D rd;
> > -       last_request->granted =3D 1;
>=20
> What's wrong with this?

Uh, I just removed the whole granted flag since it wasn't ever tested.
Side cleanup.

johannes

--=-2H/hDXAApOCYiyoJMQTV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/39DAAoJEKVg1VMiehFYP/oQAIficPxuE7cWPlx7EpcBgV30
Zr+a11iE7OPpNn7+wCCJtUukHpkY//Y9U2hzGXwpqt8lT66rDWBFHxULflMZYEAS
3vAxs7yKSQgUN/4vANZAVLdUqo9DQbdLlrD1KeXuKxU100ur8qGxQwE9tGZPtfot
LOprCGqQMg1G1XqIfWMvkUe1STWAvZGxZi1uXr6uLID0DxqQItWlsy9PhIVe0gTM
gVBlQ0M3nqj5c/91SJvQjc8+LUVWAGL5+uRHvIaDp9PXu1tdsOHZnTy+avoDueyk
9/+mPXjLV7OeEgMBUUOHQy3KR8jl/PH6I0phnLas44HATPV4O3wvlF5vAv6QVRqg
MWdlC1Z6j8HLmkRXiieT79XV0eyO2o5uP4uKHNboO/NP24qqgL/uKfy/q3oUpSXD
vqw9LMwYJP/YgWNS3FstqXntGwjObYHmFs30oUBpIIIDQ8AjzyHO2hmTnH2Z3ln9
Za+up8ViFJktPmdkiV3EFWNFMQlWz1GXC3O8yjs9BpY97pdsdYhA+kaY9ASbeutq
ta681OASjirqNOdaNrPBIeRT6Rk1lD1L7oUO5yvnkp42PJ7061RrgesbArs6LneP
EEoblKnlcPqFqUFbzwcSRrG/1RnGKFFcghQMeExQxfSIzoFFN7U+oJ2I1WLX8zc3
k5pfJy1kUTTsdr52buPP
=39zf
-----END PGP SIGNATURE-----

--=-2H/hDXAApOCYiyoJMQTV--

