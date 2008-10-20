Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYJTJYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:24:39 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <43e72e890810200214g16f847caqa6cbf724b7b7b625@mail.gmail.com> (sfid-20081020_111448_276653_1A9A8E59)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <43e72e890810200214g16f847caqa6cbf724b7b7b625@mail.gmail.com>
	 (sfid-20081020_111448_276653_1A9A8E59)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EZN09TwwTLB4HDcPS3N3"
Date: Mon, 20 Oct 2008 11:24:29 +0200
Message-Id: <1224494669.18024.51.camel@johannes.berg> (sfid-20081020_112445_020542_B69DA58E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EZN09TwwTLB4HDcPS3N3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 02:14 -0700, Luis R. Rodriguez wrote:

> Indeed I agree with this. I think we can do this in three steps:
>=20
> 1. resolve aggregation for now for ath9k

That's what Sujith's patch does, basically. It just leaves the Intel
hooks in place.

> 2. resolve aggregation for amdpu_queue case. My suggestion here is to
> use skb_buf_head (after Jouni's suggestion for our driver in fact),
> and do not make use of a qdisc at all for this

I agree on both, but this is more of an implementation detail than an
API description, which we really want to have first.

> 3. consider what we can really share when schedulers on aggr differ,
> in one case where everything is in the driver and the other where its
> not. For example -- when a new driver requiring aggregation is needed
> we can consolidate aggr scheduler mechanisms. If this is not
> acceptable this means we have to do it now but I don't know enough
> about any other hardware to do it accurately to make it work for 2
> hardwares.

I think the scheduler probably doesn't really matter as long as we have
a way to let the frames stop coming in/start again. And I also don't
think there are any other possible much different hardware designs.

johannes

--=-EZN09TwwTLB4HDcPS3N3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/E5JAAoJEKVg1VMiehFYt+oQAKjqe0Z6+3wOEMloxZRJ0a2q
vqUzdP1R/LoumCR+oNtZWReAo8XkvanxebLg/YCCsnDKlRPhXZdaFfB6ltV/TYAM
yQsf30Mc2vMxkLXWbKFeBYys9851rOUIkaacpzLXKUJcB/+/u1ni+xLqIvD2c/fP
Ev2qTkjcx/AabpszkoI3YO2A2j2gSJx+PiGFW/0a43cXcE7yASFfZXWjdI+gdebm
f/NFsZXnpr2+d3OkWyseAGmDcaVUuF94JZfe9uDXf49GzKpqU9K+WzOHLhhm6zr9
Uzv48kc9Yo/89ryv0bV9qFfjnI69T3LVFzgncUUdp/ajOrp3hLecoQSrjquMJnrm
bxrMrFJwatM3cm0jEFn4RVk2PVbw96rgF5XIuA39snhs4xQ9NOBvby6Rjn2c3BTs
Rft+LCB7hnZw7H6J8lHhvxXUl7TGvNhre18Onl7mH3lLc3UNhOFz0Bz4kW8sMKP3
WYj/Hc3YxR+Ppt+/F4scu6K3MJpwWW4Q6IeuzUQ2YWdgSRzjUcniCQxlPGAPrAPz
vv9SagyVCI2T7HcQsVA3s6kq9Ul+piBIyyB5obqojgn95ay4nKiECgx9JaEkeTD2
w4INd01ry1Ux6dk3+kaaohDR4ZZZCTRvg+6l0KcAvaAbBq37BnIZiXj5g9v6Wj2j
SkJfor6OknBI375ljjDX
=J+Fg
-----END PGP SIGNATURE-----

--=-EZN09TwwTLB4HDcPS3N3--

