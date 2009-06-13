Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41122 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZFMUJM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 16:09:12 -0400
Date: Sat, 13 Jun 2009 22:09:08 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090613220908.271865cd@mjolnir.ossman.eu>
In-Reply-To: <87bposnmxi.fsf@litku.valot.fi>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29230-1244923753-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29230-1244923753-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jun 2009 19:00:41 +0300
Kalle Valo <kalle.valo@iki.fi> wrote:

>=20
> When the power line is pulled up, the chip will power on itself.
> Whenever the power line goes down, the chip will power off. For example,
> the power line can be controlled with a GPIO pin from the host. But how
> the power line is really controlled, is board specific and should be
> handled in the board file. And here comes the set_power() function to
> the picture. The wl1251 driver will call set_power() function every time
> user space calls wlan interface up or down.
>=20

That doesn't make sense. If the card doesn't have power then there will
be no device and no interface to bring up.

I suspect we're not talking about the same thing. I'm referring to this:

+static int wifi_probe(struct platform_device *pdev)
+{
+	struct wifi_platform_data *wifi_ctrl =3D
+		(struct wifi_platform_data *)(pdev->dev.platform_data);
+
+	if (!wifi_ctrl)
+		return -ENODEV;
+
+	wifi_ctrl->set_power(1);	/* Power On */
+	wifi_ctrl->set_reset(0);	/* Reset clear */
+	wifi_ctrl->set_carddetect(1);	/* CardDetect (0->1) */
+
+	return 0;
+}

This seems very board specific and not something that should be in the
chip driver.

> Pierre, how do you propose we should do this? I understood based on
> discussions from linux-omap that this is a common way.

I haven't seen anything like this before, but it might just be that
I've looked in the wrong places.

I think this should be somewhere under arch/ in the board setup code,
where currently you have some code adding the "msm_wifi" platform
device.

(I also agree with Marcel that this looks like RFKILL material)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-29230-1244923753-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko0B2gACgkQ7b8eESbyJLik1wCg++EOdQ92y8c47QTCNiSdl5wh
/8YAoLohTU52Nckm7jVoMIE5MPF18GyC
=Ixeq
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29230-1244923753-0001-2--
