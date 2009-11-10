Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbZKJKR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 05:17:56 -0500
Subject: Re: [RFC] cfg80211: survey report capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <m3tyx2u2we.wl%holgerschurig@gmail.com>
References: <m3tyx2u2we.wl%holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PvnOBv97Bhtfw57wBVSo"
Date: Tue, 10 Nov 2009 11:17:29 +0100
Message-ID: <1257848249.7037.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PvnOBv97Bhtfw57wBVSo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 10:48 +0100, Holger Schurig wrote:

> +/** enum survey_info_flags - survey information flags

Nit: missing newline

> + *
> + * Used by the driver to indicate which info in &struct survey_info
> + * it has filled in during the get_survey().
> + */
> +enum survey_info_flags {
> +	SURVEY_INFO_CHANNEL =3D 1<<0,
> +	SURVEY_INFO_NOISE =3D 1<<1,

A response w/o a channel seems entirely useless, shouldn't we just
require a channel?

> + * @filled: bitflag of flags from &enum survey_info_flags
> + * @noise: channel noise in mBm
> + * @channel: the channel this survey record reports
> + *
> + * This structure can later be expanded with things like
> + * channel duty cycles etc.
> + */
> +struct survey_info {
> +	u32 filled;
> +	struct ieee80211_channel *channel;
> +	s8 noise;

For mBm, an s8 won't be enough I think? -90 dBm =3D=3D -9000 mBm?

> +static void get_survey_callback(void *c, struct survey_info *params)
> +{
> +	struct get_survey_cookie *cookie =3D c;
> +
> +	if (params->filled & SURVEY_INFO_CHANNEL)
> +		if (nl80211_msg_put_channel(cookie->msg, params->channel))
> +			goto nla_put_failure;
> +
> +	if (params->filled & SURVEY_INFO_NOISE)
> +		NLA_PUT_U32(cookie->msg, NL80211_ATTR_NOISE,
> +			params->noise);
> +
> + nla_put_failure:
> +	cookie->error =3D 1;
> +}

You need to construct a nested attribute here and put the values into it
so that the callback can be invoked multiple times, once for each
channel. OTOH, when there are many many channels that will overrun the
message size at some point and we'll pull our hair (like we're doing now
with the channel list in phy info) ... so I'd prefer you move this to a
dump-style model like dump_stations has.

Right now you're retrieving a single channel but can't even control
which one. Maybe that's useful functionality in addition to dump when
you _can_ ask for information on a specific channel, but that'd have to
pass in the frequency from userspace.

Retrieving all data like you've implemented (though I guess you forgot
the multiple channels case) should be a dump. Maybe that's sufficient
since there won't be huge amounts of data and userspace can just pick
out what it needs from the dump.

johannes

--=-PvnOBv97Bhtfw57wBVSo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+T20AAoJEODzc/N7+QmaX3MQAL1th7bDx+fx4VQY72bV+Bn1
nVMpVYIrF1HXJAH/kOHydZ1mNmvzd9TKN6R4poA3jkYddwOo2nuXOGMrpptctyBr
u0bQ1PmsqPansQwtkmElN2jTrfmH4yUjXNKmbC+ArZrmad8SYgQgJ4jpoVphp63K
r6Q3IugnQZWL+9cySPLas+4eL60IMkCqZIj8gg2JO8Gma9BbkK2oKxv9md8eaANE
2G5n6zBwaaUHf7QDS4+QrtYXu9i3ZKUJwx6e9S9Q3Ox1S0El2M3ZwEV+M16KUiLb
Ny+iYZKMUvu8lHhEVVgWZ390zX7HJRsjo9MIoxpbzLBXT02HdRIsLmEL0czJEhke
QCaTYT6dStHq/+VgO2Jot3DY046Fb6Fo9cIBwD2D7qOpIh3bDn0gHeTavssnqRHF
RLAy9AwpIEf5BggzLbZgNcS76g3JPvnuBI8dJrP5nyiQGtr9QXU25CDKNPNQfCcg
HsQ0EYAFXh5MMiCPHEi8sz4gEjpi43X42SVkFIpdTnAiNwlq6ybWUe+m1Z531mrr
qnyWLMgWta17EeTqNYqP0dlTa6dp6fL1B00dOE1dRMmZD/lzP05Zp9qEpzcRkDaB
tp0wbd9DZyZJPr3aP17eYxyoniB/o57whsc5CL+TGmBkm+dIUxKPvG3JjKgeU7tQ
wlxOmhUDrv3NWC2HFi3B
=M9xN
-----END PGP SIGNATURE-----

--=-PvnOBv97Bhtfw57wBVSo--

