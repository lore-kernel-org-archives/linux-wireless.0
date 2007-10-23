Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway.drzeus.cx ([85.8.24.16]:33429 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbXJWF3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 01:29:10 -0400
Date: Tue, 23 Oct 2007 07:29:01 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: [PATCH] libertas: make if_sdio align packets
Message-ID: <20071023072901.5ee79aa8@poseidon.drzeus.cx> (sfid-20071023_062916_053141_749452FF)
In-Reply-To: <20071022.181530.28790082.davem@davemloft.net>
References: <20071022190532.5077ce3d@poseidon.drzeus.cx>
	<20071022.181530.28790082.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-4372-1193117313-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-4372-1193117313-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Oct 2007 18:15:30 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Pierre Ossman <drzeus@drzeus.cx>
> Date: Mon, 22 Oct 2007 19:05:32 +0200
>=20
> > +	/*
> > +	 * The IP stack is littered with silly assumptions on alignment,
> > +	 * so we need to do a bit of layering violation here and make
> > +	 * assumptions about the size of the headers between us and the
> > +	 * IP stack.
> > +	 */
> > +	skb_reserve(skb, NET_IP_ALIGN);
> > +
>=20
> Please remove this comment.
>=20
> Where else could we possibly ensure that post-link-level headers are
> aligned properly, taking into account DMA engine restrictions and
> whatnot, other than in the driver itself?
>=20

If the assumption was that this driver was just below post-link-level, then=
 fine. But this driver has a header of 4 bytes. The problem is one level up=
, and even has variable headers at that point.

> It's not about IP, even though the macro has "IP" in it's name.  It's
> meant to ensure reasonable alignment after the link-level header,
> regardless of upper-level protocol.  So your layering violation
> commentary is simply rediculious and frankly starting to annoy the
> crap out of me.
>=20
> As you were also shown, all of THIS is fully documented in a huge
> comment above the definition of NET_IP_ALIGN.
>=20

And digging through every header file is the norm when trying to figure out=
 the broad details of writing a network driver? I looked at both of if_sdio=
's sister drivers, if_usb and if_cs; only one had the reserve call and it d=
idn't have a single comment (and not even the right macro). if_cs now has a=
 call, but with the bare minimum of a comment. I also tried looking through=
 Documentation/, but all I could find were driver specific docs.

> I'm sorry for flaming you so much, but you are showing zero respect
> for existing practice in the kernel networking and you behave as if
> you're the only person in the world who has to deal with these issues.
> You accuse us openly of mis-architecting the Linux networking with
> these so-called "layering violations" and having maintained the stack
> for more than 10 years I start to take things like that quite
> personally.

It _is_ a layering violation, with the upside of a performance gain. You're=
 free to make that trade-off, but that doesn't mean I have to like it. If y=
ou feel offended by that, then I'm sorry. It was never my intention to piss=
 anyone off.

Feel free to remove the comment. I don't see this discussion going anywhere=
 productive.

/Pierre

--=_hera.drzeus.cx-4372-1193117313-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHHYae7b8eESbyJLgRAv9mAKCfJJ4lYytzBGK3vLq5+sDswQwm2wCfZRWn
zi7BRWBM8OFWkrB4gIZlvEI=
=HtC3
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-4372-1193117313-0001-2--
