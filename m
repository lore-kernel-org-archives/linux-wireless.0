Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.mail.ru ([194.67.23.149]:23470 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbYJKOVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 10:21:38 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net
Subject: [PATCH 2/2] orinoco: cache downloadable firmware image in memory for use during resume
Date: Sat, 11 Oct 2008 18:21:33 +0400
Cc: linux-wireless@vger.kernel.org
References: <200810111816.26370.arvidjaar@mail.ru>
In-Reply-To: <200810111816.26370.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart11129890.7nKNOlxRV2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810111821.34045.arvidjaar@mail.ru> (sfid-20081011_162142_410843_86FA6864)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart11129890.7nKNOlxRV2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

orinoco: cache downloadable firmware image in memory for use during resume

If card is using downloadable firmware (like Agere 9.x), firmware has
to be reloaded during resume. It is not possible to use request_firmware
for that, because tasks are still frozen, so request_firmware will
just timeout and fail. So cache firmware image in memory for later
reuse in ->resume method.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

Unfortunately this is the only way to do it given current infrastructure.
I think that extra memory cost (~60kb) does not warrant anything more
sophisticated - even if this is possible. Also users not using dowloadable
firmware won't be penalized at all.

 drivers/net/wireless/orinoco.c |   42 ++++++++++++++++++++++++++++++------=
=2D---
 drivers/net/wireless/orinoco.h |    4 ++++
 2 files changed, 35 insertions(+), 11 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 76c480b..204b2a6 100644
=2D-- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -487,15 +487,25 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	if (err)
 		goto free;
=20
=2D	err =3D request_firmware(&fw_entry, firmware, priv->dev);
=2D	if (err) {
=2D		printk(KERN_ERR "%s: Cannot find firmware %s\n",
=2D		       dev->name, firmware);
=2D		err =3D -ENOENT;
=2D		goto free;
+	if (!priv->cached_fw_data) {
+		err =3D request_firmware(&fw_entry, firmware, priv->dev);
+		if (err) {
+			printk(KERN_ERR "%s: Cannot find firmware %s\n",
+			       dev->name, firmware);
+			err =3D -ENOENT;
+			goto free;
+		}
+		priv->cached_fw_size =3D fw_entry->size;
+		priv->cached_fw_data =3D kmemdup(fw_entry->data, fw_entry->size,
+						GFP_KERNEL);
+		release_firmware(fw_entry);
+		if (!priv->cached_fw_data) {
+			err =3D -ENOMEM;
+			goto abort;
+		}
 	}
=20
=2D	hdr =3D (const struct orinoco_fw_header *) fw_entry->data;
+	hdr =3D (const struct orinoco_fw_header *) priv->cached_fw_data;
=20
 	/* Enable aux port to allow programming */
 	err =3D hermesi_program_init(hw, le32_to_cpu(hdr->entry_point));
@@ -504,10 +514,10 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 		goto abort;
=20
 	/* Program data */
=2D	first_block =3D (fw_entry->data +
+	first_block =3D (priv->cached_fw_data +
 		       le16_to_cpu(hdr->headersize) +
 		       le32_to_cpu(hdr->block_offset));
=2D	end =3D fw_entry->data + fw_entry->size;
+	end =3D priv->cached_fw_data + priv->cached_fw_size;
=20
 	err =3D hermes_program(hw, first_block, end);
 	printk(KERN_DEBUG "%s: Program returned %d\n", dev->name, err);
@@ -515,7 +525,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 		goto abort;
=20
 	/* Update production data */
=2D	first_block =3D (fw_entry->data +
+	first_block =3D (priv->cached_fw_data +
 		       le16_to_cpu(hdr->headersize) +
 		       le32_to_cpu(hdr->pdr_offset));
=20
@@ -535,7 +545,13 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	       dev->name, hermes_present(hw));
=20
 abort:
=2D	release_firmware(fw_entry);
+
+	/* If downloading failed, destroy cached copy */
+	if (err) {
+		priv->cached_fw_size =3D 0;
+		kfree(priv->cached_fw_data);
+		priv->cached_fw_data =3D NULL;
+	}
=20
 free:
 	kfree(pda);
@@ -3534,6 +3550,9 @@ struct net_device
 	netif_carrier_off(dev);
 	priv->last_linkstatus =3D 0xffff;
=20
+	priv->cached_fw_size =3D 0;
+	priv->cached_fw_data =3D NULL;
+
 	return dev;
 }
=20
@@ -3545,6 +3564,7 @@ void free_orinocodev(struct net_device *dev)
 	 * when we call tasklet_kill it will run one final time,
 	 * emptying the list */
 	tasklet_kill(&priv->rx_tasklet);
+	kfree(priv->cached_fw_data);
 	priv->wpa_ie_len =3D 0;
 	kfree(priv->wpa_ie);
 	orinoco_mic_free(priv);
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index 981570b..403fff8 100644
=2D-- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -164,6 +164,10 @@ struct orinoco_private {
 	unsigned int wpa_enabled:1;
 	unsigned int tkip_cm_active:1;
 	unsigned int key_mgmt:3;
+
+	/* Cached firmware to use in ->resume */
+	u8 *cached_fw_data;
+	size_t cached_fw_size;
 };
=20
 #ifdef ORINOCO_DEBUG

--nextPart11129890.7nKNOlxRV2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjwtm0ACgkQR6LMutpd94wFlACfVSQctlZp503nTc/8ZqleNa2k
QJ0AoMfZYhFzTM3FfyFjwn6o3eJJeMeX
=/oSO
-----END PGP SIGNATURE-----

--nextPart11129890.7nKNOlxRV2--
