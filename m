Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549AbYFLN6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 09:58:38 -0400
Subject: Re: [RFC] First CRDA integration work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080612134615.GB28315@tesla>
References: <20080611040402.GE17936@ruslug.rutgers.edu>
	 <1213260106.19369.15.camel@johannes.berg> <20080612131154.GA28315@tesla>
	 <1213276778.3936.10.camel@johannes.berg>  <20080612134615.GB28315@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-skpmLxnCaDoh2FXBXmlT"
Date: Thu, 12 Jun 2008 15:57:49 +0200
Message-Id: <1213279069.3936.19.camel@johannes.berg> (sfid-20080612_155843_868863_C0206650)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-skpmLxnCaDoh2FXBXmlT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Well I think that some userspace programs like network manager want to
> > get a notification when for whatever reason the regdomain changes, and
> > they want to be able to query which one is currently set, and things
> > should be changeable. So you need at least three messages, NEW, GET,
> > SET, no?
>=20
> Then I see us requiring:
>=20
> SET and GET, but not NEW. If only need to "set" "one" regulatory domain,
> not create one and then set one. What do you think?

Which message are you going to use to notify userspace that it changed?
I'd say "NEW".

> > > This is in case we wanted to support letting userspace query the kern=
el
> > > what alpha2 it has set. I'm OK with not supporting this though but it
> > > seemed it may have come in handy, hopefully not for abuse for other
> > > things.
> >=20
> > Yeah true, we may want to be able to force a certain regdomain.
>=20
> Huh? I was talking about querying from userspace to the kernel for the
> currently set alpha2, in case userspace may want to know what the kernel
> last used to ask CRDA for a regdomain.
>=20
> How did this change to being able to fore a certain regdomain?

Never mind.

> Anyway, the only valid case where I see us needing to set a regdomain
> manaullay is if an access point doesn't have an 802.11d country
> information element. Which BTW -- soon we'll have to decide how we want
> to implement, as we could either respect the IE with the channels passed
> or just ask CRDA for the alpha2 given.

Yeah, I dunno, either option seems possible. Maybe both? That is, ask
the crda and then restrict to what the AP said (since that'll only be
useful anyway) but then.. Hmm could get into trouble that way if AP is
then on an unsupported channel ;)

johannes

--=-skpmLxnCaDoh2FXBXmlT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUStZAAoJEKVg1VMiehFYoqkP/0f1Y85GAl4oKpDPQVPd9aN7
gcSFvwxfWa9flcmux5S1awjaSfHXnVqqXNRHZNe5FKA2dIKwyaq+LxPScb/m+YRw
9jhsxcrY5yLBysEfn66Bu0jsLoq9vKNGnLPwhReGeYES21n/XHPSVKeQ0sPav8qk
Jb6NVcUWpCNm8zUkDB5OZyAIpgehsrNiT4lekMxrW6py7NNTT1uwhdm3wbrCUtRi
gM22bhpRSddMSIFdSn3b91CnmXN4FFCqFIBA1hhN1Olpmifg41PJd+lXUY7QtzVe
elO8CFDLCKMGQKwKwaM6va0NpdGvvx8YuwX9PxPqIqRpHDsduWhe4TUGOjsVEIHi
bApsXGJSuviAi+KH8WXBojRi6sULxr65GMFmDT4b3u7yUn3spWdnc4Nwwn7K0pyQ
XKZZr7oVal6R6koR5Zihi9FVjSafUVj4S1TRwlxadAXxpwSJUVWcxp/LsWmAP9nb
vDwB07hRvW3+tmUVbbq7JFp5iyGCZLI09ppOzwr69VUT5E86Cgp6ERnGTO8i//GG
WI80J362BWX8iDvpEomLRaHO1eGjD8cv2pX7GOCd0l38cC9d8P0MkRU+QjAbjIpp
cQd0j7gUzuYVYkmU9nVAHuazDomKT77Dya4RYJYFqjeicGxHtN4bdqhf1KSnPE9f
iGRCn4xlSBBeAikUyiF8
=Y4uz
-----END PGP SIGNATURE-----

--=-skpmLxnCaDoh2FXBXmlT--

