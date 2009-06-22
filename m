Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47331 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZFVGOj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 02:14:39 -0400
Date: Mon, 22 Jun 2009 08:14:36 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090622081436.24c78984@mjolnir.ossman.eu>
In-Reply-To: <20090622080931.66aa51fa@mjolnir.ossman.eu>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi>
	<20090613220908.271865cd@mjolnir.ossman.eu>
	<20090613205737.GA30439@hash.localnet>
	<20090618022524.GC10014@hash.localnet>
	<20090619212419.2f3626d7@mjolnir.ossman.eu>
	<b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com>
	<20090621203800.08cb4a2d@mjolnir.ossman.eu>
	<20090622000512.GA30186@hash.localnet>
	<20090622080931.66aa51fa@mjolnir.ossman.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-19497-1245651280-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-19497-1245651280-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jun 2009 08:09:31 +0200
Pierre Ossman <pierre@ossman.eu> wrote:

> On Sun, 21 Jun 2009 20:05:12 -0400
> Bob Copeland <me@bobcopeland.com> wrote:
>=20
> > On Sun, Jun 21, 2009 at 08:38:00PM +0200, Pierre Ossman wrote:
> > > I noticed one more thing though. You call wl12xx_irq() on interrupts,
> > > and that's all you do. So I have to assume that calls back to
> > > wl12xx_sdio_read().
> >=20
> > It schedules a workqueue, so it shouldn't be a problem.
> >=20
>=20
> Ah, I see. In that case you can add:
>=20
> Acked-by: Pierre Ossman <pierre@ossman.eu>
>=20

And just as I hit send I realised another problem...

SDIO interrupts are level interrupts, not edge. That means that the
interrupt source needs to be handled before the interrupt routine
returns or the system will get stuck in a fairly tight loop, rehandling
the same interrupt over and over again.

Has the testing been performed on a host that has proper SDIO interrupt
support, or one that polls? If it's the latter, then you probably have
latent issues that just haven't been noticed yet.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-19497-1245651280-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko/IU8ACgkQ7b8eESbyJLjK+ACgsuffz1QDW7N5XVOEZZJmH99y
RF4AoMNacEORsXQD+vn+ceydKHetfb0N
=hTaS
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-19497-1245651280-0001-2--
