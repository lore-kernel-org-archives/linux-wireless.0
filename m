Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbYJVRYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 13:24:37 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Sujith <m.sujith@gmail.com>, Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <1ba2fa240810220441o5b86e29co183deb7dc273fb0a@mail.gmail.com> (sfid-20081022_134116_057747_7F7CB0C2)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
	 <1ba2fa240810220441o5b86e29co183deb7dc273fb0a@mail.gmail.com>
	 (sfid-20081022_134116_057747_7F7CB0C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WJqIHvVbDcJlLYL7CB9x"
Date: Wed, 22 Oct 2008 19:24:29 +0200
Message-Id: <1224696269.30459.15.camel@johannes.berg> (sfid-20081022_192442_972164_ED07E70A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WJqIHvVbDcJlLYL7CB9x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 13:41 +0200, Tomas Winkler wrote:

> >> * mac80211 sends down a frame
> >>    * Initiate an aggregation session for the <RA,TID> if one isn't alr=
eady in progress.
> >
> > It seems that should be a rate control decision? Possibly taking into
> > account more than just always doing aggregation sessions. Then again, I
> > suppose aggregation sessions are cheap. What about latency here?
>=20
> Aggregation has it's overhead, both computing resources and on the
> air. Obvious that it has negative affect on latency so if the 'minimum
> HW queue depth'  is not satisfied the  packets
> are delayed till the queue is full enough.

That would be "do I have enough frames to aggregate them"?

> In iwl-agn-rs scale we keep track of  current tpt to take decision
> about starting aggregation. The throughput watch  can be viewed as
> different entity it was just convenient and conceptually fit  to
> incorporate into rate scale.

Sure, that kinda makes sense. The RC algorithm is conceptually
responsible for making sure things go as fast as possible :)

> > Obviously. But why isn't this done in parallel? I mean, why not send ou=
t
> > the frame and do addba and don't aggregate until addba was successful,
> > that would mean no latency for those frames... addba could even time ou=
t
> > which would add a lot of latency, no?
>=20
> The negotiation is done on starting sequence number.

Ah, good point.

johannes

--=-WJqIHvVbDcJlLYL7CB9x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/2HJAAoJEKVg1VMiehFYrVEQALJVVVknYSYVA4lZ3L+wWOJA
aX+DCpiTXxKazuGXXr841/e6XdfTHVTeR69omsBR/zRua4WXUs/4Vs7KKhegEGpU
g+GHS1dkpz7sQ7MVi8n7wFnWNbzpmuTKrMZj12Aov2bY+0I9LtFovQeB0LsM1tZq
2ME01Q8dJvfo+a60yRiE4onr5UEzH44d6Ujs9EXkRsijPhVoV6vUEd9cSfVACSxb
gH03sa+7bmY3g1A3an+D1eoL2bUQsfGXy1L6rhqjdpxRpI+jJK4E52D7juz2vYt4
NJZ8doimyOzjc+DdL3ZLE9PeF6+8eLKZfVso66Ztrd63+FsEHoUeR5B5DMzK4uEy
4AyFxPNBqdp9qSvnyvntCXBjJbRcg4RJjC3PDSD6WSVnhz2ILq4adsQuWFAv3PGW
/0zZli1g0rvzZW3cUHtx9DNqF6dqIiIfUVRFsTIRbuhTpQI/jh9wgJ/saKNg3pHi
OU4Ou1Cac7+zSgQm2EYUVVQxCy+8S2rz7Onfsuum8D2BIiWsj170w/0JFv4VTgOw
7eUEyagIjDNAK4sow4SijHnFtrDYTjDez5dMjq3QiafSlav3mpG38hQV7Iwx5QB8
3BoCwJvu809HC8+kXC6cqKv0hmYnBnRDAjylXoKUZpjN1y6+xq31BaXr/y2PXdpy
y+NWGriYZpIhl0rmtZkH
=tk/j
-----END PGP SIGNATURE-----

--=-WJqIHvVbDcJlLYL7CB9x--

