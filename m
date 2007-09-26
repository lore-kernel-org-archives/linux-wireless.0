Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXIZMg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 08:36:26 -0400
Subject: Re: A-MSDU deaggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240709260532i17d25d78u63e0829f3002f6c1@mail.gmail.com>
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
	 <1190747966.18521.320.camel@johannes.berg>
	 <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com>
	 <1190792394.18521.354.camel@johannes.berg>
	 <1ba2fa240709260446u2facb62fw1a17af1665b25d03@mail.gmail.com>
	 <1190809015.4204.1.camel@johannes.berg>
	 <1ba2fa240709260532i17d25d78u63e0829f3002f6c1@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KQR0rzDtzmP8kPmu0RCW"
Date: Wed, 26 Sep 2007 14:37:39 +0200
Message-Id: <1190810259.4204.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KQR0rzDtzmP8kPmu0RCW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-26 at 14:32 +0200, Tomas Winkler wrote:

> > > I wonder of port control is done for ethernet. 1X is not WLAN inventi=
on.
> > > I'll try to dig it.
> >
> > I haven't ever seen it, but I'm not sure.

> I'm sure.

Oh, I know about 802.1X, sorry, meant that I haven't seen port control
done in Linux.

> > Ok, let me know what you plan to do. John has pushed the deagg patch
> > into the "dungeon" branch so it's still there for reference.
>=20
> Oh... another victim.  Getting lost in current patch movement... Looks
> like most of the decision are happening somewhere else...

That particular patch definitely had problems like the missing
skb_reserve. Right now I'm thinking we should do PAE stuff after
converting to 802.3 and do deaggregation at the same time as converting
to 802.3 because that's basically what it is. But if you want to look at
it I'll go back to making hostapd work.

johannes

--=-KQR0rzDtzmP8kPmu0RCW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+lKT/ETPhpq3jKURAm8fAJ9qshz5hr+yyU9hSfui0irii3BMLQCfZGa3
x57fzUGNTmsMU4zpn7VD3pA=
=zPpD
-----END PGP SIGNATURE-----

--=-KQR0rzDtzmP8kPmu0RCW--

