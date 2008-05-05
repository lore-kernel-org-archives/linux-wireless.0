Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYEEXYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 19:24:48 -0400
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080505.161458.46071527.davem@davemloft.net>
References: <1210021066.4181.41.camel@johannes.berg>
	 <20080505.153730.186617868.davem@davemloft.net>
	 <1210027447.8012.15.camel@johannes.berg>
	 <20080505.161458.46071527.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GpBbEZhH4YPp3KVAxfc8"
Date: Tue, 06 May 2008 01:23:55 +0200
Message-Id: <1210029835.8012.30.camel@johannes.berg> (sfid-20080506_012404_631329_AE8BF0FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GpBbEZhH4YPp3KVAxfc8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 16:14 -0700, David Miller wrote:

> > Right, that makes sense. But will it ever return false? skb_cloned()
> > returns true often enough, and we only accept linear skbs, but I think =
I
> > don't understand yet what skb_header_cloned() vs. skb_cloned() refers
> > to. Which exactly is the header space I'm allowed to modify when
> > skb_header_cloned() returns false?
>=20
> skb_header_cloned() will return false always if the buffer is not
> cloned.

Right, it's less than skb_cloned().

> If it is cloned, it makes sure the data reference count allows
> for modification of the buffer.

Which buffer? skb->data..skb->tail? And isn't that, in mac80211's case,
at least currently all the buffer anyway?

> For normal traffic, you should see skb_header_cloned() always return
> false unless a network tap like tcpdump is registered.

Interesting point. I'll have to see when socket filters are run,
wpa_supplicant could have a tap open I think. Maybe that's why I'm
seeing so many cloned packets. I think I'll stacktrace skb_clone and
print that out.

johannes

--=-GpBbEZhH4YPp3KVAxfc8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB+XCqVg1VMiehFYAQKp1RAAhlAKc45MkvYo7TK4dhGkzjQVTn3B9dLO
4MBPAvyL1Bphsf/AWIVVwcJOuGhy9SRGLmE4bpAq+rsN4IGQoFKmQDEMo+NH4dXG
50TPuEHnQu5r+ti+NlvcFW72HR5RtPoQ5jz/9/rlYEBrhez/FjbJWRcmcSqC06ke
qsvtuSZVMtC+7f5A3WL5MwPnrbHw2o6uvTLgsRHHO4xdzmX4wVaet+Eqw6e4eGV6
DtjVWd4whKoQOumQTegGJI1lMAK8pQfGSrTX67acvbcfWmf2MUaa7Y+s1fVgMMkp
BxZBOqVLvrrnQRYpbnIcM8vVQxZ8KDkIJbzcdUjjHAc6p/3yc34mpFdPUvf3wGyt
aqR3wAKWgN42nVbX42rRbm5FnClJpT3WMOPh5Rw4LR1Mn1+TiOJxBxH4s5GX4iXK
ybBCO/4DjrWEsgwpdNVYjB0DuJWHknJtNqoGOZJy0xAKtF2W02siXKGWwJGaXqMw
iHlxTq/CV5J8wrjmondlJNqVGYSck2ilnYn4/R4ED9aTH7HcH9IorTYGjQRESYv7
pZbE9h2wYHb6uXOXVaKhL44npkc+CTx07oK9CEfpI1bPV7D8nCzo3UfuCzYFsVb5
BODxFGnGxPaILbXpqKe3xh/rZPrsORNdGqXpMKLYKH+snYoEY3DWDTm7yipbsoIR
/sdtKOKkyHo=
=RhVy
-----END PGP SIGNATURE-----

--=-GpBbEZhH4YPp3KVAxfc8--

