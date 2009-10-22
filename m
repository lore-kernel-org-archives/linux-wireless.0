Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZJWNe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 09:34:57 -0400
Subject: Re: [RFC] libertas: monster-patch to make CFG/WEXT configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <200910200835.35747.hs4233@mail.mn-solutions.de>
References: <200910191449.18915.hs4233@mail.mn-solutions.de>
	 <1255998802.4475.2.camel@johannes.local>
	 <200910200835.35747.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pCx6jtGvi6el2W0DZX7e"
Date: Thu, 22 Oct 2009 10:31:31 +0200
Message-Id: <1256200291.12174.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pCx6jtGvi6el2W0DZX7e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 08:35 +0200, Holger Schurig wrote:
> > I really don't understand the point. Can't you just use the
> > cfg80211 hooks and keep both functional at the same time? Just
> > like orinoco does it uses cfg80211 only partially.
>=20
> I think I can't do this in a sane way.

I don't see why not.

> Oh, and please don't compare libertas all the time with orinoco.
> Orinoco is FULLMAC, libertas is HALFMAC.
>=20
> Because libertas firmware doesn't roam, it has to be done in=20
> software. Libertas does this in assoc.c, partly in scan.c, cmd.c=20
> and wext.c and even main.c. For example, libertas keeps its own=20
> list of BSS entries, has code to select the best matching BSS=20
> when it comes to associating ... things like this.

None of this code is relevant to mesh.

> cfg80211 has this code too.

No, it has no roaming etc.

> Having two competing implementations running in one driver is a=20
> way to havoc.

I'm not saying you should keep the old _station_ code, I'm just saying
you should hook it up in a way that doesn't make it exclusive with mesh.

> I can't and won't do the MESH stuff: I don't have a firmware that=20
> does MESH, no knowledge and usage case for MESH. It would,=20
> however, be possible to keep the current mesh code with WEXT and=20
> use cfg80211 for monitor/station mode. However, I dislike this=20
> more than cfg80211/wext configurability.

I'm not saying you should do mesh. I'm saying that instead of ripping
out _all_ wext code you should just redirect/rewrite the wext handlers
and call the cfg80211 ones, so that for _managed_ mode you get the new
stuff, but for _mesh_ mode you keep the old code.

Otherwise you're not doing the driver any good at all, since your patch
then just means that both versions need to be maintained.

johannes

--=-pCx6jtGvi6el2W0DZX7e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4BhfAAoJEODzc/N7+QmaasYP/izJqscrTxdMrvnKOvp/o7jW
5LpjNjpoReo80LPU/6PLljNILPOXfOxIC+eBW1r5v6Wt4My44VZMdobKTJsywsQc
8vu5EYQoEH2TQpYAC8ZcpGikKXE8VMMmEIQNB2s/AGRp1UOjp1Z9FycS3My6h1gk
MzAxhoizKguzA2tSJ8N9njRtLbSKeVb9DlPKs4xvlFxDPq6eM8Bwlvz9Hjcev2S5
NeswTSFlc40Qv8mQfFr5flj2czQNaJqfXcnEPjWteBJ5RBomso2wtGJZRhFDyQXb
PcAyacv7SnB5vYhN0URbIqB6CHatNpzenA4sKFRFR8Ib4l7PpVcRimT9bWgAp/Uq
5NdIZw3JzPUSwLPT3r3P4XNRjWejxZk86YXzuf4OjZeiQ3n3k6xuH7NfvRQEII2e
bRG6QWK6dEekYLdFirFFHRSA8rXc0VQ4M37CPie1HjU/VilcWiAz8zqMqUTmMQgS
ssxCSNUezYveM2jcrHwxZdwNyZwAlNxd55s7oUaJ29sbpF0FrxKU5XaLPWMNL9+I
NavO5eix0spSnqh6xMdx/56nB1XgnJS/WS7hzPx8EXWGWHXlv5PrjPVxvoG0Ih0q
4tyxNHD8duhdBN5AImi4SxV4mXFrQmKQjPbTq8y7WOTeFkX+FCQ8+lT9pYreiI8W
dzfJbfvtlAcnJyMrDPSu
=wSgD
-----END PGP SIGNATURE-----

--=-pCx6jtGvi6el2W0DZX7e--

