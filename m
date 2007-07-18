Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765720AbXGSKFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 06:05:12 -0400
Subject: Re: Confuse with little endian and big endian problem of Airgo  Wireless card.
From: Johannes Berg <johannes@sipsolutions.net>
To: Li YanBo <dreamfly281@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1197ff4c0707180026r6b28e0c8tf0cc82a8e0b61be@mail.gmail.com>
References: <1197ff4c0707180026r6b28e0c8tf0cc82a8e0b61be@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fepG1HCxfd6vC0UtmCkv"
Date: Wed, 18 Jul 2007 20:39:20 +0200
Message-Id: <1184783960.8125.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fepG1HCxfd6vC0UtmCkv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

It might be useful for you to put all your current code into a git tree
and publish that to linux-wireless@vger.kernel.org so other people can
take a look too :)

That said,

> Jeff write the RX&TX  packet Description  as Be order at
> http://airgo.wdwconsulting.net/mymoin/PacketStructures,=20

Don't have that right now, am offline.

> as what we
> know, if we set the Owner bit field to 1, the packet will be fire.
> the testing environment is: the host is Le but the card is work in Be
> mode.
> so I define the desc structure like that:
>=20
> #define SET_FRAG_PACLEN(f,d)    do { (f) |=3D ((d)&0xFFF)<<20; } while(0)
> /* ------------------------------------------------ */
> #define SET_FIRFRA_PACMASK(f,d)   do { (f) |=3D (((d)&0x1)<<19); } while(=
0)
> #define SET_FIRFRA_RESERV2(f,d)   do { (f) |=3D (((d)&0x1)<<18); } while(=
0)
> #define SET_FIRFRA_TKIPERR(f,d)   do { (f) |=3D (((d)&0x1)<<17); } while(=
0)
> #define SET_FIRFRA_TKIPPAC(f,d)   do { (f) |=3D (((d)&0x1)<<16); } while(=
0)
> #define SET_FIRFRA_RESERV1(f,d)   do { (f) |=3D (((d)&0xF)<<12); } while(=
0)
> #define SET_FIRFRA_FRAGNUM(f,d)   do { (f) |=3D (((d)&0x1FF)<<3); } while=
(0)
> /* ------------------------------------------------ */
> #define SET_SUBFRA_RESERV2(f,d)   do { (f) |=3D (((d)&0x3)<<18); } while(=
0)
> #define SET_SUBFRA_TKIPERR(f,d)   do { (f) |=3D (((d)&0x1)<<17); } while(=
0)
> #define SET_SUBFRA_TKIPPAC(f,d)   do { (f) |=3D (((d)&0x1)<<16); } while(=
0)
> #define SET_SUBFRA_RESERV1(f,d)   do { (f) |=3D (((d)&0x1)<<15); } while(=
0)
> #define SET_SUBFRA_FRAGLEN(f,d)   do { (f) |=3D (((d)&0xFFF)<<3); } while=
(0)
> /* ------------------------------------------------ */
> #define SET_FRAG_FIRFRA(f,d)    do { (f) |=3D (((d)&0x1)<<2); } while(0)
> #define SET_FRAG_LASTFRA(f,d)   do { (f) |=3D (((d)&0x1)<<1); } while(0)
> #define SET_FRAG_OWNER(f,d)     do { (f) |=3D ((d)&0x1); } while(0)

Uh, pretty complicated. I'd suggest defining the bits as follows:

#define FRAG_OWNER		0x00000001
#define FRAG_LAST_FRAME		0x00000002
#define FRAG_FIRST_FRAME	0x00000004
#define FRAG_SUBFRAME_LEN_MASK	0x00007FF8
#define FRAG_SUBFRAME_LEN_SHIFT	3

etc., and then see below

> struct agnx_desc {
>         u32 frag;
>         dma_addr_t dma_addr;
> } __attribute__ ((packed));

If the field really is big endian then you should define it as such:
struct agnx_desc  {
  __be32 frag;
  __be32 address;
} __attribute__((__packed__));

Note that I also changed the address field, dma_addr_t is a kernel type
and not suited for passing to hardware, hardware most likely just takes
a 32-bit value and if you use dma_addr_t then it'll be a 64-bit value on
64-bit machines which will be quite wrong. Also note the packed
attribute -- don't let the compiler play tricks with the layout of the
struct if it is passed to the hardware.

>   frag =3D desc->frag;
>   SET_FRAG_OWNER(frag, 1);
>   desc->frag =3D frag;

That looks wrong; if it's supposed to be big endian you'll have to say
   desc->frag =3D cpu_to_be32(frag);

With my defines that'd look like

desc->frag =3D cpu_to_be32(be32_to_cpu(desc->frag) | FRAG_OWNER))

note the endianness conversions

> The TX packet was fired after I done above, but it make me very
> confuse, because I think the owner bit should be the 32th but not the
> 0th. I think in order to set the owner bits field, from physical
> memory perspective it should be like that:

> I have talk with Jeff(the author of the SPECS) and he think everything
> is Ok, but I really confuse with why it is correct?  I know you have
> lots of experience both software and hardware, I hope you can help me
> figure out the Le-->Be problem, but I also worry about I don't express
> what I want to because of my poor English, if you need any more info,
> just tell me, Thanks in advance.

Well, if the packet was actually sent with your code then the hardware
is most likely operating in little endian mode. It would, incidentally,
be extremely confusing if the hardware worked in big endian mode, the
802.11 specs are quite suited for processing with a little-endian
processor.

In that case, you should write the struct as:
struct agnx_desc  {
  __le32 frag;
  __le32 address;
} __attribute__((__packed__));

and use, following my example above:

desc->frag =3D cpu_to_le32(le32_to_cpu(desc->frag) | FRAG_OWNER))

johannes

--=-fepG1HCxfd6vC0UtmCkv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGnl5Y/ETPhpq3jKURAgcpAJ92+3n4DmQoaLFnwON6sU85vqr7owCgoVsT
/5PNVL1lHQGJ+M7Lmm+TLr8=
=lvR6
-----END PGP SIGNATURE-----

--=-fepG1HCxfd6vC0UtmCkv--

