Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZFCSXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:23:46 -0400
Subject: Re: [PATCH] mac80211: check for existance sta before adding it
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090603180830.GA13156@tesla>
References: <1243974603-15058-1-git-send-email-lrodriguez@atheros.com>
	 <1243974947.7176.9.camel@johannes.local>
	 <43e72e890906021401r2200bad9n1ffbe2c56c3a2c22@mail.gmail.com>
	 <1244012450.7176.15.camel@johannes.local>  <20090603180830.GA13156@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nY7XCtWm6I4cqqiOQlDJ"
Date: Wed, 03 Jun 2009 20:23:43 +0200
Message-Id: <1244053423.22576.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nY7XCtWm6I4cqqiOQlDJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 11:08 -0700, Luis R. Rodriguez wrote:
> On Wed, Jun 03, 2009 at 12:00:50AM -0700, Johannes Berg wrote:
> > On Tue, 2009-06-02 at 14:01 -0700, Luis R. Rodriguez wrote:
> >=20
> > > Thanks, yeah I see where I was making an incorrect assumption here.
> > >=20
> > > There still is a case here where userpsace can try to add a sta twice
> > > and the second parameters passed would be ignored.
> >=20
> > Don't we show that -EEXIST to userspace then? I thought we did.
>=20
> We do, but why don't we *first* try to check for its existence?

Because that's racy -- after the check completes and before we go try to
insert a station might have come to life. Well, it might actually be ok
due to external factors (AP mode _only_ gets stations from userspace)
but it seems better to not rely on that.

What problem were you trying to solve btw?

johannes

--=-nY7XCtWm6I4cqqiOQlDJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJr+pAAoJEODzc/N7+Qma0ogP/jD0qtTr5fTsxc44oDVGKdso
lo5QzK3cg3+Ow8I5qtARzX8z71Ggtuux7JtOdma7nKadqnydZhNUjjeHJ9mcadUj
9oAo6OnFJbHKicBlCK6N/0JeeeyNaGqNoHfDgzrmhUQWHeSUWX4rAy7C5XJ5NXl+
7aI3tyxnngDeJ0anBNsBJQPf9zRznQ+dSs7aloR/BZ7Bf6IrQsDI4FvabzMQOCqc
ZSFuhI4fdbv11j1e3BCHsm9LOazoswNKOQM1lYyEaChAI7B8PaEmy7HGM4U9Kbrv
TyF7rnKXaDqHzrporTqbrkq0VRoDcGmuYi+/74uS9kMJ2uaBucLX2nJ8OTQew9sX
Ud/fiK/eG9gHxSkCVDzQACKGXxQg6xQfpiSavidvoCxxqjMQ+fcWsgkwIjzkTRMR
OJ6ksapbgO1UTlvg4uZTsN1MNkiIT8i0OxtwFSvnVM/ikmWT6e6M1pPpc6yW2cQj
8Fb2wE1H5Pp1qeU5nnVlbIcqqGxQCjnYjhMsc8EAUkn59XEA3mmRM4DHoVAC/Fo4
wP8DFnJ0a2neoplwsg2XqmJJObIclK1Wu/ah9E5zyLKQfwaP4Axd5HcvneLK4Xa3
lSnEymLazAFWwQa5q24eTge0bBXt3JfcRdssPeBNZ3Zgxj3u+t8gVDSKBC0FeGvF
wLV9Dl8Y3sWnZ8LGmOYl
=4n4y
-----END PGP SIGNATURE-----

--=-nY7XCtWm6I4cqqiOQlDJ--

