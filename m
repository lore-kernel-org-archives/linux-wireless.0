Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZCaIQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:16:45 -0400
Subject: Re: [PATCH] cfg80211: send regulatory beacon hint events to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903310110l49b8a6b8hfe42202d5da0304@mail.gmail.com> (sfid-20090331_101045_449530_E3541CBE)
References: <1238471826-3980-1-git-send-email-lrodriguez@atheros.com>
	 <1238485738.5970.64.camel@johannes.local>
	 <43e72e890903310110l49b8a6b8hfe42202d5da0304@mail.gmail.com>
	 (sfid-20090331_101045_449530_E3541CBE)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3BBJyj9389Pmp8v/16hc"
Date: Tue, 31 Mar 2009 10:16:05 +0200
Message-Id: <1238487365.5970.78.camel@johannes.local> (sfid-20090331_101650_565668_8AE77AC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3BBJyj9389Pmp8v/16hc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 01:10 -0700, Luis R. Rodriguez wrote:

> >> +     /* Unforunately this is needed */
> >> +     nl_bands =3D nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
> >> +     if (!nl_bands)
> >> +             goto nla_put_failure;
> >> +     nl_band =3D nla_nest_start(msg, band);
> >> +     if (!nl_band)
> >> +             goto nla_put_failure;
> >> +
> >> +     /*
> >> +      * Our hack is to piggy back the channel prior to beacon hint
> >> +      * and after the beacon hint so userspace can analyze the
> >> +      * differences. Right now only no-ibss and passive-scan flags
> >> +      * can change as that's the only thing we expect to learn out
> >> +      * of a beacon for now. By re-using these attributes we can
> >> +      * avoid introducing new structs.
> >> +      */
> >> +     nl_freqs =3D nla_nest_start(msg, NL80211_BAND_ATTR_FREQS);
> >> +     if (!nl_freqs)
> >> +             goto nla_put_failure;
> >> +
> >> +     for (i =3D 0; i <=3D 1; i++) {
> >> +             nl_freq =3D nla_nest_start(msg, i);
> >> +             if (!nl_freq)
> >> +                     goto nla_put_failure;
> >> +
> >> +             chan =3D (i =3D=3D 0) ? channel_before : channel_after;
> >> +
> >> +             NLA_PUT_U32(mNo, that's not exclusive...sg, NL80211_FREQ=
UENCY_ATTR_FREQ,
> >> +                         chan->center_freq);
> >> +
> >> +             if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
> >> +                     NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE=
_SCAN);
> >> +             if (chan->flags & IEEE80211_CHAN_NO_IBSS)
> >> +                     NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS=
);
> >> +
> >> +             nla_nest_end(msg, nl_freq);
> >> +     }
> >
> > I don't think I like this -- it's confusing to userspace code that want=
s
> > to use a unified message parser.
>=20
> I know the feeling, more on this below.
>=20
> > Do we really need that before/after thing anyway? I think if we really
> > need this then we should add new attributes.
>=20
> Well we can definitely add new attributes, but remember we still have
> to pass the center of freq. The cleanest solution is to define an
> attribute with a center-freq, if-passive-lifted, if-beaconing-enabled
> flags. But that ends up adding all that for something we already have
> attributes for. I chose to use what we have.

No, we don't have to do that. All we'd need to do is add a new attribute
NL80211_ATTR_FREQ_CHANGE, which we document to
 1) contain an array
 2) in that array, contain nesting
 3) in that nesting contain NL80211_FREQUENCY_ATTR

That means you'd only need to remove the bands nesting and replace the
BAND_ATTR_FREQS nesting by ATTR_FREQ_CHANGE nesting. Only one new
attribute needed in total, and you can keep almost all the code too. The
array nesting is a little ugly, but that's not a big concern.

johanes

--=-3BBJyj9389Pmp8v/16hc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0dFCAAoJEKVg1VMiehFYHU0QAJvooPqWiKSr8m0lymdffYXn
/ZACUc0bkRqUFed78xoFIHCSpeEyFYw9vCwiLQiAAhOqDHN/9CLO62BeWljx9HxS
lAXOI6kY7LG/uDOY7NNsPa/pB4Hm2CD/wzkj3bBJ9NeS3SF3hOEMG8w1rDQ5Ue6b
eEfY6v9SE3U52PlhVI4IxTRAP2AuWICidTzqzHG7gy2DFqGdc4tjS3Ccrpzox/q/
W+OFxdv0De0xAeH4UM58x2fKODERQPAYyoDTNiiBe0NW5xu9TWoLyZmGRAfE+CGV
jM64J/Z74xVAtlprHhwQFqgTyd+Dr032Wb5kqEH2N585gefgD7TxIlaZ+4e3qI0n
y1uHTlxujt0DY28xt6leUtD5gv8AQBbB3JQbAnSH1fHzgPc0kFyqBKbicYcG54yg
cBTlQHoPcWdmKRY3l1H2cJ4/1dhnQ1cgNITebtr2C1vfgCcZRCCF5ERUw8ADLOd1
IRArUldx8g8PqBMXbsC9xWxUP3gpc4FNinilMvtpJL9Mw5a9iJPYCl9a54X5esS4
fe37OOzZI9euld8adnvjvkycuc1696gVpM6JwLKF4WFZM3bUy1ZriIAUXcmlyQDt
HU0P6igG62G+6YkG9oKk7fPkSWTVqjwWUUMeAndO3P7CcTME/VT3xKO4saPQdT6S
LAXhS7xIOkuWzoZHE32D
=RU8j
-----END PGP SIGNATURE-----

--=-3BBJyj9389Pmp8v/16hc--

