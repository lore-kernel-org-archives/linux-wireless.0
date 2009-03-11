Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZCKRaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 13:30:21 -0400
Subject: Re: [ath9k-devel] [PATCH v5 1/4] ath9k: implement IO serialization
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <43e72e890903111020m10537058wbca980eb07ceb132@mail.gmail.com> (sfid-20090311_182051_361038_EF61AB10)
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
	 <1236739953-17701-2-git-send-email-lrodriguez@atheros.com>
	 <1236762611.9658.87.camel@johannes.local> <20090311160740.GB5669@tesla>
	 <1236791626.20266.37.camel@johannes.local>
	 <43e72e890903111020m10537058wbca980eb07ceb132@mail.gmail.com>
	 (sfid-20090311_182051_361038_EF61AB10)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YIasxbfJwnmTtWuzjM7N"
Date: Wed, 11 Mar 2009 18:30:16 +0100
Message-Id: <1236792616.20266.39.camel@johannes.local> (sfid-20090311_183025_273280_2C8BB8AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YIasxbfJwnmTtWuzjM7N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-11 at 10:20 -0700, Luis R. Rodriguez wrote:

> > Hmm. I really don't understand this at all. Most operations won't be
> > single writes and reads, and if you need multiple like a write+read for
> > indirect register accesses then I'm sure you need to serialise them
> > against each other in some other way too, no?
>=20
> The issue is not serializing against separate routines calling some
> reads or writes, this serialization prevents the PCI hardware FIFO
> queue from getting more than two requests as otherwise the hardware
> poops out. But as you can see this is only an issue with PCI devices,
> not PCI express devices.

Well yes, but if you ever do multi-read/write operations then you need
to synchronise at a higher level anyway -- hence I don't quite
understand why this is necessary at all.

johannes

--=-YIasxbfJwnmTtWuzjM7N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt/UmAAoJEKVg1VMiehFY0x0QAKz0cGsW0nsDCV2u47bxoipJ
uf7ijDGIHQLxQPKYdefdBMwB0YnQhrrTVfedHndM5eiPUWI4Rj+lrFIbgLjfFV8y
FwqXZ23GTV/u5dCmIUr+FCuXjUDw3Bg+L5VPQILI2hNSIYnMZXii+JdbNJtaTpon
adbBVTRRb2EwT9I91r9VQ479GQg7PwN/SjpeL1jTxoNuc5rgXLuHYVhFXP2PJ1NW
vKH8Gsf39Ohp4NuJx1fZwub8CPlln6iR1+PP3eyE9qn0ibj9jIHmy8qViZiVkFRm
zAZkyDe+Or8qKKnD7dBSbRS0He7xBEmNfslAd7VXpD/DTr37JZEAb+2m1udS861D
0Y8hdQkpClgiRpeFuJj8SS2iDzXhWfI6+G+VPeJLYxblNBc1PPxXOgEEZxme7JhU
oUS+A2rCcG7p13IWoSW2hPW0mb0YfgxQCy2AX2gXJcipHVFpeZelrNzfLqVeCTmQ
TyF0eVeuJiL+3jWgJkQpJMQc4Bq9SkpVxj7BehAi0BXx8Zw4Vq6xEIuqQDR8LrZt
z5VZUIoNVOKm+sKm9gNDN42HqUGkEGNC39jOV1Ggjp1LB3+T0UdWzoFtRX6B0KEZ
FZq3Ekx4V6M4PFC9ZtD2h/K4MeKnR6mAZ/BvLNO8rzNvPVWdBVa5r/KR/eg1XDfe
ru1c2MG57BLZKLJr8+Gy
=P/DZ
-----END PGP SIGNATURE-----

--=-YIasxbfJwnmTtWuzjM7N--

