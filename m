Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYLGN5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 08:57:47 -0500
Subject: Re: mac80211 user space
From: Johannes Berg <johannes@sipsolutions.net>
To: igor_trindade@yahoo.com.br
Cc: Jouni Malinen <j@w1.fi>, Andrey Yurovsky <andrey@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <456087.50493.qm@web59308.mail.re1.yahoo.com>
References: <456087.50493.qm@web59308.mail.re1.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YYzkkey6BEKbam1KM23F"
Date: Sun, 07 Dec 2008 14:57:40 +0100
Message-Id: <1228658260.22164.41.camel@johannes.berg> (sfid-20081207_145835_458650_89284B50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YYzkkey6BEKbam1KM23F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[CC'ing more people for a wider discussion]

On Sat, 2008-12-06 at 07:26 -0800, Igor Trindade Oliveira wrote:
> i was seeing your description about mac80211 hwsim in kernelnewbies
> and i see something about mac80211 userspace API.
> you can explain your idea?

I think the userspace API idea is probably not a good idea as is, it
makes it very complicated to program things, I guess hwsim should be
extended instead.

One thing I was especially looking for is, instead of having "virtual
air" inside the kernel, have "virtual air" in userspace.

For example, consider this scenario with three mesh points:

MP1 ---- MP2 ---- MP3

where MP1 and MP3 cannot directly communicate because they are too far
apart, physically. It isn't possible to test such a scenario with hwsim
because hwsim has no concept of distance.

One easy solution to this would be to introduce "air groups", each just
a number. In mac80211_hwsim_tx_frame, we have:

        list_for_each_entry(data2, &hwsim_radios, list) {
                struct sk_buff *nskb;

                if (data =3D=3D data2)
                        continue;

                if (!data2->started || !data2->radio_enabled ||
                    !hwsim_ps_rx_ok(data2, skb) ||
                    data->channel->center_freq !=3D data2->channel->center_=
freq)
                        continue;

The easiest way to do "air groups" would be to add:

		if (!(data->airgroups & data2->airgroups))
			continue;

and have the "airgroups" value be a u32 (or u64?) which can be modified
in configfs and defaults to 1. That way, you can have up to 32 (64)
groups (each bit being a group) and the above picture would become:

virtual device:  MP1 ---- MP2 ---- MP3
airgroups:        1        3        2

Does that make sense? Do you think it's flexible enough? Should we maybe
use a u64 so we have more flexibility? It should be fairly easy to do
this, I think.


Of course, this isn't as general as it could be. I suppose some testing
scenarios will require simulating packet loss and similar, so we'll want
to have userspace make the decision about which packets get to which
radios. For this, you'd want to have a radiotap interface per virtual
hardware, which shows all frames transmitted by this virtual hardware
and, when frames are sent into that interface, the frame is given to
mac80211.

That would be the most generic way, but since it's also a lot more
complex I think there still is value in having the "airgroups" above,
especially since if we implement this idea then we still need a way to
decouple the virtual radios from the "virtual air" that's implemented in
the kernel, which perfectly fits with setting all "airgroups" to zero
which makes the "virtual air" in the kernel that I quoted above do
nothing.

Thoughts?

johannes

--=-YYzkkey6BEKbam1KM23F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJO9ZQAAoJEKVg1VMiehFYsu8QAJHkEm+jcuoxiZVgnPY/nMWv
GTASbxGZ7NfO6O096+RQ00CzxKT15770byjKx0XrfYlN5z+sXIbCsWxMbpI7XVtV
wCLrnUqehWJ/q8bFgOkNxDNF5yJiBTXgtJ0lPhsR7scIXpDOasyTRydPNNrVWONw
Jwc6FOzYzd7lEABipcDMPrJrINWPgYFQIrydnuw3v6vSbd7qp2GpjCN7aMVZWw0W
qnjaZ/H8wcQIIGo5wfA05wv8WpzqVCRNSY9Pt+SutLc72axyW48pa/Qtjt7H/8tk
jzqpHXH4OH2Z7j1nwPWSmsdhaOmsgvUN+tgqkqE7JbxTUpM8CayFsudbJWa+Z+Ov
Pi6qk4+Rptcvyh3YdBkvC/lgNZPmyFg5d3cKfhnPNFnmZFp++RPst5WfiTDbZw4a
p2eHnk6HrWKIWTnyvg428+56UHEfqIJjPjMH0wc6y+4tg7A4iBwxYnFOBaLYWy11
5T3ZqDLYzzSvEdRsiu04CqfIGM+uJI+/Kr+q4fZ0NCnv3bcuJgQcJwrJWKSATE2B
7+rsT3EIB+2ol6X5JyarKRf8s01GpcNsALAkbVHi1pVrb1SehDe83xhNjRDCs/kU
bgDEW158goLgM/epIgUKS09MxAsDsKEQUsfXkdufyydoQSzSvvF6E9iGrataIv6+
UN5WfEBuJzErDmymoVct
=xvux
-----END PGP SIGNATURE-----

--=-YYzkkey6BEKbam1KM23F--

