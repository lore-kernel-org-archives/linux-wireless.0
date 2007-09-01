Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33417 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXIAJF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:05:29 -0400
Subject: Re: radiotap injection bugs & extending it
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <46D92A1C.4050308@warmcat.com>
References: <1188609135.7585.105.camel@johannes.berg>
	 <46D92A1C.4050308@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sPtlScz7ETwJSXWI7RAR"
Date: Sat, 01 Sep 2007 11:06:55 +0200
Message-Id: <1188637615.7585.118.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sPtlScz7ETwJSXWI7RAR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-01 at 10:00 +0100, Andy Green wrote:

> Yes it's wrong, hdr is also dereferenced once more while the radiotap
> header is still in place.  I made a little patch I will send in a
> moment, if you already did it then ignore the patch.

No, sent the mail just before going to sleep :) I'll review your patch
and adopt it. Guess I get to rebase my ~70ish patches to after it
then ;)

> > Also, after doing more work on mac80211 I now again have hostapd runnin=
g
> > via monitor interfaces. However, there's a bit of a problem there.
>=20
> You are definitely on fire at the moment Johannes.

Heh, yeah, got a bit of time on my hands right now.

> > Of these, check_assoc should be skipped unconditionally for injected
> > packets. sequence should be done, ps_buf I'm not sure about though I
> > suppose that if the STA really goes into powersave very quickly then
> > hostapd would need ps_buf.
> >=20
> > Then we have select_key (and mic adding/encrypt depends on it) which
> > should IMHO depend on IEEE80211_RADIOTAP_F_WEP; fragment could depend o=
n
> > IEEE80211_RADIOTAP_F_FRAG. rate_ctrl should depend on the presence of
> > the IEEE80211_RADIOTAP_RATE field, if it was present then rate_ctrl is
> > skipped. This addresses this TODO item:
> >            * TODO: auto-select when the rate field is not present!
> >=20
> > misc does a few things:
> > retry should be taken from IEEE80211_RADIOTAP_DATA_RETRIES if present o=
r
> > otherwise automatically assigned, cts/rts should be taken from the
> > radiotap TX flags IEEE80211_RADIOTAP_F_TX_CTS and
> > IEEE80211_RADIOTAP_F_TX_RTS or automatically determined.
>=20
> Sounds great to me.  I guess you are up for doing this?

Yeah, I can do that. Not sure about PS mode though. I suppose your use
case won't suffer if I simply do it unconditionally since you're always
sending multicast frames anyhow.

> > This is basically it, except for short preamble setting. That is a bit
> > of a problem, however, because it's not a tristate in radiotap and we
> > want a tristate (long/short/automatic). Ideas on this item?
>=20
> No idea about it here.

I could propose adding a new radiotap TX flag, I suppose...

johannes

--=-sPtlScz7ETwJSXWI7RAR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2Suv/ETPhpq3jKURAgXHAKC6voPJx21jnJb+AoXXKb1sN1QzMQCdGm5Q
ADB3aIozSqGdu40UVflI+Tg=
=NEa+
-----END PGP SIGNATURE-----

--=-sPtlScz7ETwJSXWI7RAR--

