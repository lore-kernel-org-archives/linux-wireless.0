Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx27.mail.ru ([194.67.23.23]:56592 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYJZI3i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 04:29:38 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] orinoco: cache downloadable firmware image in memory for use during resume
Date: Sun, 26 Oct 2008 12:29:35 +0400
Cc: orinoco-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart38286511.lB7vzvk4mH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810261129.36971.arvidjaar@mail.ru> (sfid-20081026_092956_549650_40BEB97B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart38286511.lB7vzvk4mH
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom: Andrey Borzenkov <arvidjaar@mail.ru>
Date: Sun, 19 Oct 2008 12:06:11 +0400
Subject: [PATCH 2/2] orinoco: cache downloadable firmware image in memory f=
or use during resume

If card is using downloadable firmware (like Agere 9.x), firmware has
to be reloaded during resume. It is not possible to use request_firmware
for that, because tasks are still frozen, so request_firmware will
just timeout and fail. So cache firmware image in memory for later
reuse in ->resume method.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
=2D--

This version transparently works both with external and built-in firmware.
In case of built in extra overhead is one "struct firmware".

spectrum_cs has used delayed work to reset card after resume. After
reading multiple discussions on lkml I got impression, that this is
unreliable - there is no way to sycnronize delayed task with unfreezing
of user space.

 drivers/net/wireless/orinoco.c |   28 +++++++++++++++++++++-------
 drivers/net/wireless/orinoco.h |    5 +++++
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 860803e..653306f 100644
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
=2D-=20
1.6.0.2


--nextPart38286511.lB7vzvk4mH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkEKnAACgkQR6LMutpd94whYgCgltBfCu21IfdvpNvmzfBLvQh1
qP8AnA3eitMqHDXCz7jxJIbpRrTgOuWV
=a1w5
-----END PGP SIGNATURE-----

--nextPart38286511.lB7vzvk4mH--
