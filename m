Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761931AbZEMXOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 19:14:18 -0400
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending
 on the stop callback
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Bob Copeland <bcopeland@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890905131608y4e6400c9x31e37459d7ec4b51@mail.gmail.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	 <1242208388.14227.46.camel@johannes.local>
	 <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
	 <b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
	 <1242253626.10076.9.camel@johannes.local>
	 <43e72e890905131608y4e6400c9x31e37459d7ec4b51@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cGi2oQSMprFt1inHeEZz"
Date: Thu, 14 May 2009 01:13:46 +0200
Message-Id: <1242256426.10076.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cGi2oQSMprFt1inHeEZz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 16:08 -0700, Luis R. Rodriguez wrote:

> > That's a good point. Somehow I thought this was intimately tied to
> > suspend. And I think for cfg80211 that makes sense, since cfg80211
> > doesn't do much for suspend. But for mac80211 you're right in that it
> > would make sense to
> >  * keep the radio on
>=20
> This is implicit by not calling stop, right?

Yeah, I think so.

> >  * not call stop
>=20
> This makes sense for ath9k so far -- I was just exiting out.

Ok.

> >  * maybe not remove all the sta info structs
>=20
> Which ones? In my tests I'm just not removing any.

I'm talking about sta_notify() not code :)

> >  * and whatever else may be necessary -- that might even depend on the
> >   wow mode
>=20
> So lets start with a basic goal -- magic packet. If you think about it
> though if you disassociate you won't get this magic packet=20

Actually I think you still can or something, it's very strange. Does
anyone have a WoW documentation/spec?

> so I guess
> that's also why we have link-change trigger (or called disassoc
> trigger on some other hardware?).

That could make some sense, though do you want to wake up, reassociate
(if possible) and go to sleep again? That would take some
synchronisation across layers...

>  Anyway out of these link change and
> magic packet seem like a reasonable goal to get working first. For
> that besides the above I'm not sure what else is required.
>=20
> I'm building this stuff now on a box with a card that is supposed to
> have WoW working so I'll know for sure if we are missing something
> soon.

Cool.

Anyway I think Bob is right, we may not need to have anything added to
->stop() and instead do some wow config, or something. Too tired to
think about it I think.

johannes

--=-cGi2oQSMprFt1inHeEZz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC1QmAAoJEODzc/N7+QmanM8QAI5G/yNZun3mZfrgN33zI9Ky
aFr/4s6y6QtfqPaWidHp8EUYe4B2ldsGRSO+lQ4h/YT2OC+FcHwdLiGLiD74T88+
W0mEv0MHyIP7M9CfaDof65MogqEZKsPWv0MsXjkclfJJ6Sr9JXZoIg2pA2xHnz58
ldszYoaStm9moO5z6PLdG7uXktawHg5etk0CJQW3zWUaWqeHB/tQCg41Ti6+gcxi
AhiCLH1oWnP6UT779NXEKsvRny5ms7MhMWr4H0KpwIBeEua7PaxZIXfiecP2MMI0
rf3IyBjtKUgEzU7u1v9DLKpqnZD7Qm3oKhcG1RpNE/EdTpbv3ZSe5UpbzdJ3IMeo
LztLhgHlL/ro53Zp5mIhyzSh49iLR+FqAMLCu8vmUkceHHI9wKu6wVJFNAM1nBJP
H8DcjhqeLAIrz1/sx2Kl9ZBhbfqXytTw4kgczTIImdf8p9NLogG5RBKhQZ6LIV5j
laHzkRikHewaeuySe6FVITrhYZG7Bk5bOwWejHxKBWVB9cRqOdfRxIiyoc+FVD3F
gqTpkbRsglKfGFne/ybFMPfbfxafd3oigAVWjCop6n8ImTKoLMDvoCYw/CEvE+g2
dYSG2bHgcHc5MV77XBS+MdH7qW4G8mEMVJykUNpOnhyXB/3VSKUGSBnwKC/6Myrc
o2mlNlrVZ8DmSqsb+iPx
=BzD+
-----END PGP SIGNATURE-----

--=-cGi2oQSMprFt1inHeEZz--

