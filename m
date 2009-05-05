Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbZEEIDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 04:03:11 -0400
Subject: Re: oops during stress test - today's wl
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905042005vb96f57aid70c476e38685dfe@mail.gmail.com>
References: <43e72e890905042005vb96f57aid70c476e38685dfe@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z1zb59w/4W1UKymD55mm"
Date: Tue, 05 May 2009 09:41:46 +0200
Message-Id: <1241509306.25337.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z1zb59w/4W1UKymD55mm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 20:05 -0700, Luis R. Rodriguez wrote:
> mcgrof@pogo ~/wireless-testing (git::master)$ git-describe
> v2.6.30-rc4-22720-gb2382a4
>=20
> While running iperf, after about 1 hour.
>=20
> http://bombadil.infradead.org/~mcgrof/oops-img/09-05/oops-01-v2.6.30-rc4-=
22720-gb2382a4.jpg
>=20
> Image probably doesn't help much.. but its what I got.. I'd look more
> but its getting late here, so I'm out. I'll use netconsole tomorrow.

Yeah, doesn't really help... I would suspect the driver to be honest,
since the scan code is trying to TX a frame and it's already in
ieee80211_tx() (and probably in __ieee80211_tx which gets inlined).

johannes

--=-z1zb59w/4W1UKymD55mm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/+23AAoJEKVg1VMiehFYElEQAJjnjDd2EYZCvyzaJLbLUpxb
ZzdT4ngLVGZfJ+4iM4wfH5OExbfPEx/ve5mWDAN4k8sA/Vi/jHvZBffyznUtE1Oc
21m4wXOnPp8+gRlZHFj+xeU3k938kl4nGdwz1c1dvB26EYEXljxQolONXNKXY5Ho
Nlm6nMV4eN/eZ0COfPMiAt2LALZ6s8uDLsA9H51dMepvD+eU66nAa6wrc7wa4OyG
LiBx66TOFUUewR0dyxqL9tozCihSxe74dZWgpMWDffutwD49ApJVLx3gMXIypn9S
hK4tBUF/Jb8fJ92hMsnlManDqBdeRpZRLimlhFq8Jzo18a6UDmd6E+xaeZMODGsi
OpQjp/SxknSZy93QpgTcf/yiAkirZOFDWvoD6brMihK4nnxdjS6/WsX0zMV5LAec
grsQNznu4TszUuT6tKwleQMBMeeMloZCH3cOUy0IKdkwU27Kz7yyuPBgni7y9glh
UYBDSk1EWcUczBqa6WFUDxDlyLe/xfVBWMvzFETfclIaToq1CyEHj3VrypV2uhEP
yNVFuSApP4r6uOX9WlzkwbqzhhPNOOsOVJMllHw69iuW7jk+wTaSiIeLViVHirg/
w6H/nYToD4a8HLdgT7BEQqEC3MckaQAOkawK6xfNbVGtP3W6QxP210kat1nF335G
F58q64tr++MY7winzyTO
=T+0k
-----END PGP SIGNATURE-----

--=-z1zb59w/4W1UKymD55mm--

