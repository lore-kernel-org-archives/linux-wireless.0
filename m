Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYKCIbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 03:31:04 -0500
Subject: Re: wireless-testing commit
	eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811030026t319c551cp91807318f9a6b838@mail.gmail.com> (sfid-20081103_092605_445439_93229141)
References: <4908B754.1050400@tpi.com> <20081102184146.GA6065@hash.localnet>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 <1225698867.3619.31.camel@johannes.berg>
	 <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com>
	 <1225699482.3619.34.camel@johannes.berg>
	 <43e72e890811030026t319c551cp91807318f9a6b838@mail.gmail.com>
	 (sfid-20081103_092605_445439_93229141)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GIGf7VzyWJy+zcqK2fgX"
Date: Mon, 03 Nov 2008 09:30:24 +0100
Message-Id: <1225701024.3619.37.camel@johannes.berg> (sfid-20081103_093109_689664_A7E60AF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GIGf7VzyWJy+zcqK2fgX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-03 at 00:26 -0800, Luis R. Rodriguez wrote:

> >> What should we do with these rare failures then?
> >
> > print an error message? ignore them? try again?
>=20
> I'd prefer a simple error print than a WARN_ON().

Just so you don't get blamed on kerneloops.org? :)

> >> > hw borked is one obvious case, but it shouldn't happen enough
> >> > for this to be a problem yet.
> >>
> >> This I agree with. It is rare, its just possible, right now mac80211
> >> assumes it never will.
> >
> > It's _always_ assumed that by ignoring the return value, now it's just
> > noisy about it because clearly it doesn't like when the driver fails to
> > do what it wants since then the hw and sw states get out of sync. I
> > really don't see what to do other than retry maybe, but that might well
> > be done in the driver instead.
>=20
> As can be seen from the patch suggested what some drivers will end up
> doing is just ignoring failures but I guess that can be up to the
> drivers to deal with as you are suggesting. I'd be inclined to try to
> disable the device in case of a few failed resets to be specific with
> ath5k. Would mac80211 want to be informed of that through the return
> value? Is the WARN still appropriate?

I think the warning is appropriate, yes, since mac80211 has no concept
of failing hardware configuration. You're free to add such a concept,
but I really don't know what mac80211 would be supposed to do when
things fail, just try to stop/start? panic()? Instruct the user to
reboot? to swap hardware? See?

johannes

--=-GIGf7VzyWJy+zcqK2fgX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDracAAoJEKVg1VMiehFYwPcQAI5CGFu2ufGr8rBRnGKXz8fO
sB8ZOJvJsYYvxO4LVMZ3uLrTeyK4p5JDCEW57r7Au27iFV2RRXQYxqreB5zlsIUR
txp38k+H0khBhx/g6ztJD5Q2E1CN4M14SplYegmvhMXj2TEpuobRkwUkLaKTV2r6
yKTYYLIq237t+RqbCHXiFeE2za8L1Z5wQa5SZoABvTW65KeKQTzdk7jbn1vVQiM+
03Ag35R9SmJLZB6feNdbzB6S2Fn46+XNvnOsEY6w4ixRsnBPg3zvBoEW4aVars6O
JcRa/xAIVif12EwvdPCzIYPZtQnx3ryf2XPsI35XT9rW6uYJptzzc43wq/AaMLL6
YSdRI0J8xiLXQ/PX8wrCsRMYx+OEPtgg63cVL5HLS1DxhpENoWJ1gGlUuYX1FlPt
kMBqKvySbGumr/cLaV0EHaVNcUuVRInTvtTEP51EHNLKEnNYxTv8WBTcOSXaRNi2
pU3bkXXTWgobuUXNrZBVp7QBy/QPUeeP6xmsTQwU4lyMfYDjcYYgL40rsj0p/pbh
dmLQe6o2DZVC0UyVToJHgc0K69mAexyFTB6KN+1lNw9xWCXBhCT8v1dM6nROC1y/
YTfz7mgPZEf3VhDe7NR8Q0nr61WlDwXZu3HG2kPLwJKat6XMXtkkkNrkaEdAsRcO
p2U5+g3f7vFmck7nbJa8
=88CD
-----END PGP SIGNATURE-----

--=-GIGf7VzyWJy+zcqK2fgX--

