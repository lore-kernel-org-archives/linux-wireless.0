Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46931 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZFUSiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 14:38:10 -0400
Date: Sun, 21 Jun 2009 20:38:00 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090621203800.08cb4a2d@mjolnir.ossman.eu>
In-Reply-To: <b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi>
	<20090613220908.271865cd@mjolnir.ossman.eu>
	<20090613205737.GA30439@hash.localnet>
	<20090618022524.GC10014@hash.localnet>
	<20090619212419.2f3626d7@mjolnir.ossman.eu>
	<b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-13610-1245609490-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-13610-1245609490-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jun 2009 16:31:41 -0400
Bob Copeland <me@bobcopeland.com> wrote:

> On Fri, Jun 19, 2009 at 3:24 PM, Pierre Ossman<pierre@ossman.eu> wrote:
> > I'm afraid I don't understand the problem. If you power up the card
> > before the MMC system has started, it should still properly find the
> > card and activate the wl12xx driver once things are in sync.
>=20
> Okay a little more background:
>=20
> This is with the out-of-tree Android msm_sdcc host driver.  There are
> various implicit assumptions in module ordering.  For example, one of
> the platform callbacks sets a "virtual card select" flag, and then
> tries to notify the MMC host via another callback to do
> mmc_detect_change().  But that code runs before the MMC driver is
> loaded so the callback isn't yet registered and no one gets the
> notification.
>=20

This does not sound very Linux:y. Module loading order should not foul
up things. If it does, then there is some missing dependency somewhere.

> > Do you want me to merge it?
>=20
> It can go via the wireless tree if that's ok with you, since the
> SPI driver already lives there and this all needs to be rebased
> on Kalle Valo's latest changes anyway.
>=20
> It'd be nice to get msm_sdcc upstream though.
>=20

Yeah, sorry. Of course it should go through wireless. I was just in
merge-mode from all the MMC patches thrown my way. :)


I noticed one more thing though. You call wl12xx_irq() on interrupts,
and that's all you do. So I have to assume that calls back to
wl12xx_sdio_read(). That in turn calls sdio_claim_host(), which will
cause the system to deadlock as that lock is not recursive (yeah I
know, patches welcome).

Has this code actually been tested? It doesn't seem like it can work to
me.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-13610-1245609490-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko+fhEACgkQ7b8eESbyJLg+9gCgtRZx+Vcj+P7xSNOV0QrY1aCb
SIAAnjr24U1XcEXchKOS7dW8GL4sVlOs
=P+Q2
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-13610-1245609490-0001-2--
