Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZDPUs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 16:48:59 -0400
Subject: Re: [Proposal]TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: radiotap <radiotap@radiotap.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090416203353.GC25412@ojctech.com>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	 <1239902910.26575.14.camel@johannes.local>
	 <69e28c910904161147h5a68d3b5nd054b043d6ad2719@mail.gmail.com>
	 <1239908374.26575.20.camel@johannes.local>
	 <20090416203353.GC25412@ojctech.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BGszA72U+fNSA6hGNPy2"
Date: Thu, 16 Apr 2009 22:48:27 +0200
Message-Id: <1239914907.26575.28.camel@johannes.local> (sfid-20090416_224901_239297_677BC011)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BGszA72U+fNSA6hGNPy2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 15:33 -0500, David Young wrote:

> > > TX Flags absent: Use RTS & CTS as needed.
> > > TX Flags present: {
> > > RTS=3D0, CTS=3D0: Use RTS & CTS as needed.
> > > RTS=3D0, CTS=3D1: Use CTS-to-self.
> > > RTS=3D1, CTS=3D0: Use RTS/CTS-handshake.
> > > RTS=3D1, CTS=3D1: Use neither RTS nor CTS.
> > > }
> > >=20
> > > (By reading the second proposal again, I find it more and more
> > > sympathetic... but let the discussion decide.)
> >=20
> > That _works_, but is impossible to describe in any feature discovery.
>=20
> The discovery mechanism that we have begun to discuss would have a hard
> time describing that feature at its current level of development, but
> that is not the only feature that it will have a hard time describing.
> Feature discovery may need more development before we measure new
> proposals against it.  What do you think?

True, but why make the job harder than it is? Michael has a good point
too. And we have free bits, I don't see why we can't add one for "do
what I said" (wrt. rts/cts), which, if unset means to do be in automatic
mode and ignore the other bits.

Or we really do use a two-bit field with values;
	0 automatic
	1 neither
	2 rts
	3 cts
or something.

johannes

--=-BGszA72U+fNSA6hGNPy2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ55mYAAoJEKVg1VMiehFYB+sP/iWFsHYWRejVcMyUxMCnqk5C
0cyLKLkJJEelO3QsjBmgyIHI7fKCe+QsNsWsKn8HuHmIlRzXbace9K2rMVQ7I3O/
cs3ci2vYWy8MVjXST8SVjo0AKxGhVABeGxl3QyQoAU8mFhGCxgzGqke3nXC69Oeu
UDBJyQFOvhDHSj5RYdPVbx9NBYM9HUSjSh4aK8Qxiblmmpx/OHrAX/q3YFOp6Qz7
v4bvBwhb/ivgfQO5SeUf0dyqsIlSTp4odWk8VB3JLjaR+MfNN+WsoQjFJu2qFKZm
FSp4C9swjqRDop+WJCl++eUsPgC1fBSUN3+dXaDTKQV9nKBri52M9XNnCkk0Z50W
9SFobXo6r4/3wQtnc9yEptyDyKCebZi2AguoEu5kaIG432ok/TSmxeV+vaPokTlm
sztxsHO3JmWnasNwVAI1q30T2yW67G3LBCkquAukM5pM2TsfCmAcrnsIsySUgcCi
LvSuGDLAryA7LW3MDJSJj/K8cvfL/M3wdDibLoTXGY4oWJ6mblE88g/ST8BBNUpj
aAgHmh/wVop/oOMOjqPAGKXkCMIqckO5cmeWJ+AgzTO3hC1mC8bQd1Uu6swIcjbM
Nslh0TslFDTUAYaKexiMkZojacfW3WFYiYfmq7SMfMEpm2qFS/yvkqsGoMnTSmvh
fULZp+98Mq7IzQWRbDLM
=pJw9
-----END PGP SIGNATURE-----

--=-BGszA72U+fNSA6hGNPy2--

