Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761562AbZAPUfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:35:11 -0500
Subject: Re: [PATCH 07/13] cfg80211: only export disable flag on channel
	disablement
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116163245.GF29609@tesla>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232097827.3854.25.camel@johannes>  <20090116163245.GF29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7vxWWcMwbinm0or8YcEr"
Date: Fri, 16 Jan 2009 21:35:01 +0100
Message-Id: <1232138101.3745.7.camel@johannes> (sfid-20090116_213515_807982_7FDBAB92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7vxWWcMwbinm0or8YcEr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 08:32 -0800, Luis R. Rodriguez wrote:

> > > -	chan->flags =3D flags | map_regdom_flags(reg_rule->flags);
> > > +	rule_flags =3D map_regdom_flags(reg_rule->flags);
> > > +	if (flags & IEEE80211_CHAN_DISABLED)
> > > +		chan->flags =3D IEEE80211_CHAN_DISABLED;
> > > +	else
> > > +		chan->flags =3D flags | rule_flags;
> >=20
> > but why bother with more complicated code when adding a few more flags
> > doesn't hurt?
>=20
> I don't see these few lines as complicated really, but if you don't like =
them
> that's fine. We can also fix this in userspace so that disable|radar|no-i=
bss
> doesn't show up. I frankly think its pointless to keep them though.

It's not exactly complicated, but I bet at some point we'll scratch our
heads why we did it ;)

johannes

--=-7vxWWcMwbinm0or8YcEr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcO9yAAoJEKVg1VMiehFY/5wQAIXILF1BpoGNxO2P48/X2gSJ
MQ/25LxxwMyLCeJ5cGcBR+hBZfBsK3vqNWdEw9p3Oh/0O/3qQ7+zmf9tzzOsezw/
Ouw/bi7r4KcEqXnGgjOkz2HsipeCad/DpYWTsfn870e7WoUh9I9imV5BM8UX8YBq
X1mRCBzZB0QG7EasIIZij/N/eJL/NvpTWMau95PG+nUNTak/7RIW6evmQfSIZkVM
itiYdgFP4SifG3P0BqpyUGjrVYEt69STl+a3reqcwYuCp/sXldQeSOjBTnGSl4MA
Iecy+f57yaKz6GVP5yLTChN1GUT3QKLmMpkfge/KaIAGanu616S8lQzJ99IvCGOX
jhQWQiJcrl3GpjKQdfR61pxpx+Ip0WoGFeXoNk30M+0kA5eoHOdoUktGnSJjHrob
KZtbFQ8RLciWDHRsAWB5i9JL49VzknrDd81ZN1vynBqiDAhJeEZPEISUsHw3y4W0
eBPhQOLJumn7SWoyqN2t856Qf+ghyfRKktAG701ZoJwHQCpORFU3E8aCmSCU7rje
X1Ci/0ENJjf6j1aGvo+POE+SqrDYGiarxul00aSNpX6vZeu6SnG1sid2VaobQ83Q
S+KCkx8j3aOTs0qZ4Y/kOu0x4oT33TlytpyrLGc0kxTTKzqinzn1IUaBjf5s6OdC
0uD14U5m8HAbWLcYiQyu
=RLDR
-----END PGP SIGNATURE-----

--=-7vxWWcMwbinm0or8YcEr--

