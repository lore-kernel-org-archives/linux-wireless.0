Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx27.mail.ru ([194.67.23.23]:52129 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbYJLRnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Oct 2008 13:43:04 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH 2/2] orinoco: cache downloadable firmware image in memory for use during resume
Date: Sun, 12 Oct 2008 21:42:35 +0400
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200810111816.26370.arvidjaar@mail.ru> <200810111821.34045.arvidjaar@mail.ru> <48F0E983.8010708@gmail.com>
In-Reply-To: <48F0E983.8010708@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2438024.NkSefnMLfd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810122142.36756.arvidjaar@mail.ru> (sfid-20081012_194310_664247_A6AEAC7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2438024.NkSefnMLfd
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Mcj8Ii3B78jCuj/"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_Mcj8Ii3B78jCuj/
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 11 October 2008, Dave wrote:
> Andrey Borzenkov wrote:
> > orinoco: cache downloadable firmware image in memory for use during res=
ume
> >=20
> > If card is using downloadable firmware (like Agere 9.x), firmware has
> > to be reloaded during resume. It is not possible to use request_firmware
> > for that, because tasks are still frozen, so request_firmware will
> > just timeout and fail. So cache firmware image in memory for later
> > reuse in ->resume method.
> >=20
> > Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > ---
> >=20
> > Unfortunately this is the only way to do it given current infrastructur=
e.
> > I think that extra memory cost (~60kb) does not warrant anything more
> > sophisticated - even if this is possible. Also users not using dowloada=
ble
> > firmware won't be penalized at all.
>=20
> Spectrum_cs has had firmware download for a while. It achieves the firmwa=
re reload on resume by doing schedule_work(&priv->reset_work).
>=20
> Would the same work for orinoco_cs?
>=20

I think it could result in hard to trace race condition, because you really
have no way to synchronize it with unfreezing of udev.

> If not, is there a way to avoid the caching when you've got the firmware =
built into the kernel image?
>=20

Actually, yes. Patch attached. It needs some touching when (if) we start
supporting AP mode; right now only one kind of image is ever loaded.

--Boundary-01=_Mcj8Ii3B78jCuj/
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="02-orinoco-cache-firmware-image-in-memory"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="02-orinoco-cache-firmware-image-in-memory"

Subject: [PATCH] orinoco: cache downloadable firmware image in memory for u=
se during resume
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

If card is using downloadable firmware (like Agere 9.x), firmware has
to be reloaded during resume. It is not possible to use request_firmware
for that, because tasks are still frozen, so request_firmware will
just timeout and fail. So cache firmware image in memory for later
reuse in ->resume method.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco.c |   28 +++++++++++++++++++++-------
 drivers/net/wireless/orinoco.h |    5 +++++
 2 files changed, 26 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 722619c..8a15230 100644
=2D-- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -487,12 +487,17 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	if (err)
 		goto free;
=20
=2D	err =3D request_firmware(&fw_entry, firmware, priv->dev);
=2D	if (err) {
=2D		printk(KERN_ERR "%s: Cannot find firmware %s\n",
=2D		       dev->name, firmware);
=2D		err =3D -ENOENT;
=2D		goto free;
+	if (priv->cached_fw)
+		fw_entry =3D priv->cached_fw;
+	else {
+		err =3D request_firmware(&fw_entry, firmware, priv->dev);
+		if (err) {
+			printk(KERN_ERR "%s: Cannot find firmware %s\n",
+			       dev->name, firmware);
+			err =3D -ENOENT;
+			goto free;
+		}
+		priv->cached_fw =3D fw_entry;
 	}
=20
 	hdr =3D (const struct orinoco_fw_header *) fw_entry->data;
@@ -535,7 +540,11 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	       dev->name, hermes_present(hw));
=20
 abort:
=2D	release_firmware(fw_entry);
+	/* In case of error, assume firmware was bogus and release it */
+	if (err) {
+		priv->cached_fw =3D NULL;
+		release_firmware(fw_entry);
+	}
=20
 free:
 	kfree(pda);
@@ -3534,6 +3543,8 @@ struct net_device
 	netif_carrier_off(dev);
 	priv->last_linkstatus =3D 0xffff;
=20
+	priv->cached_fw =3D NULL;
+
 	return dev;
 }
=20
@@ -3545,6 +3556,9 @@ void free_orinocodev(struct net_device *dev)
 	 * when we call tasklet_kill it will run one final time,
 	 * emptying the list */
 	tasklet_kill(&priv->rx_tasklet);
+	if (priv->cached_fw)
+		release_firmware(priv->cached_fw);
+	priv->cached_fw =3D NULL;
 	priv->wpa_ie_len =3D 0;
 	kfree(priv->wpa_ie);
 	orinoco_mic_free(priv);
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index 981570b..8c29538 100644
=2D-- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -66,6 +66,8 @@ struct orinoco_rx_data {
 	struct list_head list;
 };
=20
+struct firmware;
+
 struct orinoco_private {
 	void *card;	/* Pointer to card dependent structure */
 	struct device *dev;
@@ -164,6 +166,9 @@ struct orinoco_private {
 	unsigned int wpa_enabled:1;
 	unsigned int tkip_cm_active:1;
 	unsigned int key_mgmt:3;
+
+	/* Cached in memory firmware to use in ->resume */
+	const struct firmware *cached_fw;
 };
=20
 #ifdef ORINOCO_DEBUG

--Boundary-01=_Mcj8Ii3B78jCuj/--

--nextPart2438024.NkSefnMLfd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjyNwwACgkQR6LMutpd94xBxwCggz6cs3i+RI362sxgRNljNZPV
K4IAn0l8awYYcobje+SFSEvm5ygSmplI
=usZp
-----END PGP SIGNATURE-----

--nextPart2438024.NkSefnMLfd--
