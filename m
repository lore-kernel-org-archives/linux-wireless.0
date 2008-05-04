Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbYEDM2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 08:28:22 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1209900355.6210.64.camel@johannes.berg> (sfid-20080504_132540_547555_169FA253)
References: <1209815533.3987.21.camel@johannes.berg>
	 <20080503.180300.10562559.davem@davemloft.net>
	 <1209865354.6210.23.camel@johannes.berg>
	 <20080504020203.GA30514@gondor.apana.org.au>
	 <1209866916.6210.39.camel@johannes.berg>
	 <20080504021213.GA30660@gondor.apana.org.au>
	 <1209867740.6210.46.camel@johannes.berg>
	 <20080504031652.GA30993@gondor.apana.org.au>
	 <1209890847.6210.51.camel@johannes.berg>
	 <1209892489.6210.56.camel@johannes.berg>
	 <20080504094444.GA541@gondor.apana.org.au>
	 <1209894754.6210.58.camel@johannes.berg>
	 (sfid-20080504_115215_663728_A338AE69)  <1209900355.6210.64.camel@johannes.berg>
	 (sfid-20080504_132540_547555_169FA253)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W7Um0qbqf+T92OqxLuli"
Date: Sun, 04 May 2008 14:28:08 +0200
Message-Id: <1209904088.4065.11.camel@johannes.berg> (sfid-20080504_142805_379089_9BA7B10E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W7Um0qbqf+T92OqxLuli
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> http://johannes.sipsolutions.net/patches/kernel/all/2008-05-04-11%3a23/02=
7-skb-alloc-stackdump.patch

This was broken when cloning, this one works:

http://johannes.sipsolutions.net/patches/kernel/all/2008-05-04-12%3a19/027-=
skb-alloc-stackdump.patch

Now I see the problem. I increased the LL_MAX_HEADER constant, but all
code uses dev->hard_header_len to allocate the headroom (via
LL_RESERVED_SPACE), e.g. packet.c:

packet_sendmsg_spkt:
        skb =3D sock_wmalloc(sk, len + LL_RESERVED_SPACE(dev), 0, GFP_KERNE=
L); =20
  =20
[...]
        /* FIXME: Save some space for broken drivers that write a
         * hard header at transmission time by themselves. PPP is the
         * notable one here. This should really be fixed at the driver leve=
l.
         */
        skb_reserve(skb, LL_RESERVED_SPACE(dev));

This one even complains about "broken drivers" (like PPP, but wireless
code behaves like this too). This is getting really really really
frustrating. All kinds of comments all over tell you how this all is
wrong but NEVER actually tell you how to do it correctly!

As far as I understand, I cannot change dev->hard_header_len because I
want/need an ethernet header and not more. But then I don't get enough
headroom.

Oddly enough, I even get a warning from tcp_connect() although that
actually does
        /* Reserve space for headers. */
        skb_reserve(buff, MAX_TCP_HEADER);

which should definitely be sufficient. Maybe the packet gets cloned
somewhere? On the other hand, IPv4 raw's =EF=BB=BFraw_send_hdrinc reserves
LL_RESERVED_SPACE(rt->u.dst.dev) like af_packet....

johannes

--=-W7Um0qbqf+T92OqxLuli
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB2r16Vg1VMiehFYAQIFMhAAsYkGt890QyUngQpCW1CCkIlJ07k+ggx+
QZJfxYv9b3vK6VjqJ9ULWcBAZQhkCJjspn78dzZfnIxUO/65Z3tLH9Q4EnOG3luN
ATCP0IKFplSngF2YlheKyjMceGeBGCczy13sAT571LvjLb9EFSsSs+67fJ9VqgBQ
zYu702fGy9STMeDiimf14RW+fywWTlR3eOnxBXDNMZJI8qQuHupMS5yw41LqrNyT
rTLMqCBGNq5gNrnTBtGO63zM9ZUYhn7if9sgTyJrx4TTtKpF5ITHIFIwL4y/YfpV
tQVuATFB4saEc3Amp0gH6GkjATG6saacGLeVp7epCV+dliPiR9t159tCZh6xfVcE
08FGnmh1R0XYzSRRqjs9/PZfixOKbuTNQv8c1ES7hzB1lpo97PwHoRDS94burvPg
56RsIX+97B1oqNzpr1c5f/nH2Gc+FGpz7UhQMpLZ4hE/+Hvw9mm2oX7FFDc0TOw3
sYg6eCHlHBS8Qzj6oWGmQmH+/1LYFl0JmF/j0L4wmzZrbHR3J3hbwjEv9lUs92nF
fyFJJyza7KZ+GQfyLOojRVasuNSehhdKFFJdoJX5XaY6XtD/2Y3ub8bcLi1HRcTU
Dczxr10UFFBeLwSYNhCwkKlFw4xJevwiuG1Y2WP9AWcGw4BzvGcRQ9kBqICUNBQT
+EBN2NebIX4=
=1Z1l
-----END PGP SIGNATURE-----

--=-W7Um0qbqf+T92OqxLuli--

