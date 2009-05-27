Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762024AbZE0OZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 10:25:01 -0400
Subject: Re: [PATCH v11] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20090527140020.GA14440@khazad-dum.debian.net>
References: <1242942720.4212.19.camel@johannes.local>
	 <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com>
	 <20090526131533.GA3932@tuxdriver.com>
	 <20090527025516.GC22235@khazad-dum.debian.net>
	 <1243405682.26933.0.camel@johannes.local>
	 <20090527140020.GA14440@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MNIxAihzJGkLfQu/WDMV"
Date: Wed, 27 May 2009 16:24:17 +0200
Message-Id: <1243434258.4170.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MNIxAihzJGkLfQu/WDMV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-27 at 11:00 -0300, Henrique de Moraes Holschuh wrote:

> Well, thinkpad-acpi has users of that functionality, and not just that, i=
t
> is in the middle of a two year effort to deprecate the thinkpad-acpi
> specific driver attributes and switch to just rfkill.   This effort will =
be
> destroyed if a kernel releases without support to writes to the "state"
> attribute.
>=20
> I need that userspace interface (writes to the state attribute) in place =
and
> working.  It _is_ a big regression for thinkpad-acpi to have it return
> -EOPNOTSUPP.

You're free to implement a sane API -- I don't think the current API is
feasible because we need to be able to set the soft state regardless of
the hard state, query each state separately, and ideally poll the
states. Also, the old user_claim is crap when it comes to userspace apps
'forgetting' to reset it when they're finished.

I was suggesting earlier today to John that it might make sense to
create a character device for each rfkill instance so that you can
 * read soft/hard state from it
 * while the device is open for write, that's the equivalent of
   user_claim
 * you can poll() the fd for the device instead of having to listen to
   the stupid uevents

Also, I want to have any actual proper use cases like switching between
classes covered better.

> Also, regardless of the "claim" attribute (and the related
> user_claim_unsupported nonsense), the old core would allow the user to
> change the soft state using sysfs, so I really don't understand what you
> mean when you say "almost all drivers disabled that functionality", you
> can't disable writes to the "state" attribute in the old core from what I
> can see.  Please correct me if I am wrong on this.

Without user_claim userspace can have no expectation of actually having
control over the state attribute. If your userspace tools do not always
user_claim before I believe they are broken.

johannes

--=-MNIxAihzJGkLfQu/WDMV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKHU0MAAoJEODzc/N7+Qma3/EP/2rA3frtZAra431fgNVANGSZ
iMiHb5qfXUb4HCRmUp5RYHq4akmNVHn65Rk6WfZ8RzvWIF5cRMb07Z1Ibzwauq24
TXtaMTU8cM3p3J7oeZybDMgOcwEk5qJcAzZbj708Px8c3X58KfWtLyajiZgh2oVO
fsKbOfj7wEqODqKaFFDa3mQD7/yfFxwfpH/cJBla9eJBnHvtY9/yx07xFqM9caNc
Tgm4Omhq75tGbDdDe8aw/Wh59eFuAnaD4OM9B0A9z5gPli7FXEEW9j4J3AA2Pbo+
nR0O/YW4TTF/jp5lEg2LnTGpcv2Igo7wU1eWDEZ5UsfquYcEnh5BYzigiEELj2zz
nHI0dLB8pZsjfIPDJ/lSoLKKFptouL3RkeDwjmE8LgT8p9xgTvK6hVpaVyc5hPsv
vuhdg3YIZeKlVo0ykx8MK8om6LrnuSmJekVelBwqhZEIBVGvi2EArHCz8l0tRLQV
ZMujv8u0X2hA14roXcnYHoaQargKwfLFhCMVLPUihWWVXZqUye9kXpwrc1nF+mwg
2EbCzpJVUAvDxPbIFCtCxhnCH9bYgB3AQTtouUEJ+3rnCb0IrIayef3D+dCJOB4v
xeVyOR0olRMlTYHsFHwl6ceptVYehoWB2+2xx0E0qD3ni6J3aT4TnlOIzAtBtlxO
RdgaSaR3brG0DrYYdvYV
=EevX
-----END PGP SIGNATURE-----

--=-MNIxAihzJGkLfQu/WDMV--

