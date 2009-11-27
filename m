Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZK0LL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 06:11:56 -0500
Subject: Re: [PATCH 06/12] wl1251: fix payload alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <873a409qdg.fsf@purkki.valot.fi>
References: <20091126150141.917.35278.stgit@tikku>
	 <20091126150904.917.8182.stgit@tikku> <877htd9v5a.fsf@purkki.valot.fi>
	 <1259259183.24540.0.camel@johannes.local>  <873a409qdg.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TGJyuFVLz4x27bk4Az8k"
Date: Fri, 27 Nov 2009 12:11:59 +0100
Message-ID: <1259320319.5428.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TGJyuFVLz4x27bk4Az8k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 13:08 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > On Thu, 2009-11-26 at 17:13 +0200, Kalle Valo wrote:
> >> Kalle Valo <kalle.valo@iki.fi> writes:
> >>=20
> >> > mac80211 complained that in some cases IP payload was not aligned, t=
his
> >> > happens if the 802.11 header is not aligned with four. In that case =
we have
> >> > to move entire packet to make the payload properly aligned.
> >
> > Eh, turn off the debugging option ...
>=20
> Sure. But isn't this warning going to create false alarms for others?

That's why it says "Say N unless you're writing a mac80211 based
driver." Maybe it should say "Say N unless you want to debug potential
alignment issues with your driver." Or maybe it should just go away now
that we align things properly in mac80211, and most firmware either
handles it or not, and there's nothing we can do about the firmware most
of the time... And mesh makes it more complex anyway than the warning
checks.

> > The point of the warning is to make developers aware that alignment by
> > firmware will be better. If you can't put the packet into the right
> > place directly from the device, don't bother, the memmove is done by
> > mac80211.
>=20
> Ok, I have totally misunderstood the warning then. What's the proper
> way to fix this? I'll try to improve the comments in mac80211 to make
> this more clear.
>=20
> At least in wl1251 we have to transfer the frame to an address aligned
> with four, otherwise DMA won't work. So the only solution I can think
> of is that firmware adds two bytes of padding before the frame in case
> of unaligned payload. Is there any other way?

No, there's no other way :) In fact, the padding has to be dynamic --
depending on whether you have QoS and/or 4addr format -- you need
padding if (!(qos ^ 4addr)) IIRC.

johannes

--=-TGJyuFVLz4x27bk4Az8k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD7P7AAoJEODzc/N7+QmaKhEP/iHMCe1Y5De1JMw/J4gEILpj
1rdwKb23CmkWZBFbA23VrXbeOeFepGTy+OF0ME8YlaKjugsPiPi7kZS1Z2vERR6I
RvRPiUbh0o9evICyPwuXJJwpwTc6obJzeDFogWiAa0Z8XNPy2znYHeH6+TyYUQBB
T/ugiEgVjy1Zs+t85RbxCK5Ja4fz8emk1ohkF/Y1ykzXzQk1j2JrkdCXrLoiSYyg
UVn0E1aRECFucwcg5KmFSXwN9WV0NwY0YMX8xuH1YqS8nteTnfDed1eqBgPYKmEV
xBqS0mhspvFqiCzr1+uDjwXbODAmI0p5zyRf6o0oqtzF+HW9DNNGVpP9IIip12g8
pvzd8RZdY0naRrRURoqDKEOY7Tc1sG+L3L/GdM2pYV6kIOH5NHHdv41f85qcuA5n
zl7JfQQBfi5NydGqS3c75pyl1yOnP2mAPGpR/xBvlsxJa5ilA955FQXFfEeEKEyE
xJ7g1lGqCXyBD5eql/8KLPdxzhSblJZ7Dr9OA2zLFqP7rxjBrgyo7hGvoUlcQm45
sc/khBeAMnmMYJDb/sMLodN7uJw/XrpP6+g7EaOkEuI8921eocdYkB0zTBzilvAn
eHXnR8He2CRwQYZcgO+gXxt886D/Cl8MC/BFz4A1MerlcnS6eBYxAI7mmET5qExD
hVSSHmeISPNhvZwe0Ee+
=/san
-----END PGP SIGNATURE-----

--=-TGJyuFVLz4x27bk4Az8k--

