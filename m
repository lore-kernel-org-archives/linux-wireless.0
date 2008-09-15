Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYIOTWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:22:42 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221505251.4511.77.camel@localhost> (sfid-20080915_210128_632488_FB448E33)
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)  <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost> (sfid-20080915_210128_632488_FB448E33)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eMz7ax98P6ikACzdFbY4"
Date: Mon, 15 Sep 2008 21:21:36 +0200
Message-Id: <1221506496.3700.81.camel@johannes.berg> (sfid-20080915_212251_594269_9437C190)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eMz7ax98P6ikACzdFbY4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 21:00 +0200, Mattias Nissler wrote:

> Ok. If we take this path I think we do not need to add more flags to
> mac80211 and the drivers that enable special processing w.r.t. the
> device packet filters (as suggested by Ivo previously). Instead, the
> driver itself should take whatever action is necessary to tell the
> hardware to deliver ACK frames.

Yes, but we could also make the ack queue processing part of mac80211,
i.e. we stick the packet on the queue before ->tx() and add a few new
flags to the status callback which can then process the queue.

> Johannes, could you recap for me
> whether the driver should report these additional ACKs to mac80211 or
> keep quiet if they weren't requested?

This is largely theoretical right now as mac80211 is _always_ requesting
status reports via IEEE80211_TX_CTL_REQ_TX_STATUS. This is something I
can't talk much about, you helped designed the rate control algorithm
and I think you're in a much better position to evaluate how this should
work with respect to rate control.

Then again, I think I'm misunderstanding you, are you thinking whether
it should hand those frames to mac80211? It doesn't matter to mac80211,
to be honest.

> Good point :-) So I suggest we have one function that adds new packets
> to the ACK queue (which is represented by a struct an instance of which
> a driver can keep in its queue information) and another one that matches
> a received ACK with the queue, reports the status to mac80211 and purges
> the queue entries up to the match (reporting them as failed).

can we stop talking about "ACK queue"? It really is a "unknown status
queue" or something like that.

johannes

--=-eMz7ax98P6ikACzdFbY4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzrW8AAoJEKVg1VMiehFYWkYP/1kGrhjg2gzFnEbM/+QbJbp0
JncHXgKpS4VfewZjb7SVAMM6pl7tbBWTatAM8NQ+z7CCXkjmA1YmC8GFAr8aeC5d
EgOIkV/lh9lisZ/iEY53JcAgtlZqRInOEGw9vZ0RzC5Brf80L9gYWU81zIQjDGqV
Qbe23t1WouCM0ZsM0UZvpaszeuqmdP2FKDeT9tQ+rMnUMSIQPjneWEWA7URmjYzz
Ij1G+LqtoPnJ2+ohUSJNro/GynH0SMZkkTwugYjwqJ29SaVh/jHqxMHsW1jkMDN5
OIryFyDEkeyP7jcKhgSjh1gIPjAy+oIlZLyCnsvQoHIhLiDsO0j+0Rgf5xpdZ91W
z9s/k6BobB2E6ZGaaaSbFQmiUQ+VDvy9a16ErIDKaJ1+GZk5S67roKReE/uyykpt
TlsDD7P4S5PzbHyXv8y23l1szvZ7TV355KVJUHQeenrau6iiM/9pcSllZw/6JcQK
GAdro6aNhIdMm8w6aYAKnCs9bZ56kMaHWLJADTNh/Pt9Mreh9aPUVvUktVcqm9O5
NJojqLRlErx6XDUZ9CpKJC6rLQTUZPkQVeG91FUNJH5d2QF7Lwkkw1AVoimnUgnd
i13iGW66hkDenfAOOgxqeB80Khtac/YlMUHZOOQlm8UcEX+Q4WERkT6FZ8sXn6l+
roe7lZjoiAWF3+SI3OV6
=HwrQ
-----END PGP SIGNATURE-----

--=-eMz7ax98P6ikACzdFbY4--

