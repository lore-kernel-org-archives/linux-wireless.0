Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYJWOrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 10:47:23 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <18688.15460.336059.400706@gargle.gargle.HOWL>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	 <1224669827.28639.54.camel@johannes.berg>
	 <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	 <1224696170.30459.12.camel@johannes.berg>
	 <18688.15460.336059.400706@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5W2NbhkU3Nbzc7Eo3eyV"
Date: Thu, 23 Oct 2008 16:46:41 +0200
Message-Id: <1224773201.6002.35.camel@johannes.berg> (sfid-20081023_164728_323941_77D1C1C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5W2NbhkU3Nbzc7Eo3eyV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 14:27 +0530, Sujith wrote:

> > Yeah, this is something we definitely need to work out. We haven't even
> > managed to decide yet how aggregated packets are given to the driver :)
> > I think for atheros and bcom a model where mac80211 decides pretty much
> > everything and hands the driver a list of skbs to aggregate would work
> > best, but then I think that wouldn't work with your hw at all.
> >=20
>=20
> Retransmission of unacked frames is done within the driver, in ath9k.
> In case of retry exhaustion (failed transmission), we do what Intel does,
> i.e, request for a BAR to be sent out.

We have this "ampdu_ack_map" parameter in the TX status which could be
set by the driver. But that assumes we only want a single TX status for
all A-MPDU frames, do we really? Or do we want to split them up and
handle it all in mac80211?

johannes

--=-5W2NbhkU3Nbzc7Eo3eyV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAI5NAAoJEKVg1VMiehFYyLsQAJWjrf8DsF5IN3+kEcJZgikX
3IBPnao25bJsEZwMFbKpDp1xYK1C/1Rqub0LWgeciGqujgPG45lod6easdFKYlEy
UjbyyIhu49Zgd/08vsBWO/axSn2IEGnhYQXuVKhX+YgOWNVpf3SsNMcnU8NAVIh2
7p8UdTCdT/bOAT4mFNpX/o4cpTckcDeHsVL/wjf8p5TNXyyvEuehtOgQ4JEQDNa8
pzKz3FX9Cl+dL6PSPVuFrcHYqx26eD6QX+4kxT2Yeoo7ZdZeDOnCW5Tfpl812K0b
hHq6D9ehN6QhFG0v+LvYAxFqJGhMCRfQ8gTv9InOtcIp/anKKloUI+yFg3XYxENc
0NsdjKA99ExDBlDzotZW2sgILWgNcKtvpUegmndRfCjh8ERf1VAkNO+Nh+Dao39n
buoWfnLbZECqEOsg8bAxlFHNe7bm1qUe+4admDXwhcyMT7Eo2iT8JKVzYUaiZ1Ao
juqrEHejsX+cLGTBO2yfWsFum1KAVnYmlB4K0TosLf1KeMKQvkI1zoeqhztNO9Cp
ykFBOrc2yFjNGjAjtjPiXY03uUkfYxQVdeDlqq7HhqsKhUIMwBBvaPh8cAnx9iEZ
n1GbcKMB1zn5XbV5Yk6t0PotsCv+vqmhCc+ET1v8Z0dBAJZ2xS5hpiffL0NeGT0G
KeBh9MgN/fUMv7mjLnDA
=cY1t
-----END PGP SIGNATURE-----

--=-5W2NbhkU3Nbzc7Eo3eyV--

