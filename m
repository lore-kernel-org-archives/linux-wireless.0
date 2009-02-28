Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.mail.ru ([94.100.176.17]:15103 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbZB1UJd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2009 15:09:33 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: [PATCH v3] orinoco: firmware: consistently compile out fw cache support if not requested
Date: Sat, 28 Feb 2009 23:09:09 +0300
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
References: <20090215100902.7895.2670.stgit@cooker.net> <200902211911.25718.arvidjaar@mail.ru> <49A033A8.4070006@gmail.com>
In-Reply-To: <49A033A8.4070006@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1697587.xtBJHVPjmJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200902282309.16655.arvidjaar@mail.ru> (sfid-20090228_210945_019343_D5185619)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1697587.xtBJHVPjmJ
Content-Type: multipart/mixed;
  boundary="Boundary-01=_snZqJrLUl/tWN1q"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_snZqJrLUl/tWN1q
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 21 =D1=84=D0=B5=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2009 20:02:32 Dave wrote:
> > +#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) ||
> > defined(CONFIG_PM_SLEEP) +extern void orinoco_cache_fw(struct
> > orinoco_private *priv, int ap); +extern void
> > orinoco_uncache_fw(struct orinoco_private *priv);
>
> Please remove the explicit externs.
>

OK

> > --- a/drivers/net/wireless/orinoco/main.c
> > +++ b/drivers/net/wireless/orinoco/main.c
> > @@ -2580,8 +2580,10 @@ struct net_device
> >
> > -	priv->cached_pri_fw =3D NULL;
> > +#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) ||
> > defined(CONFIG_PM_SLEEP) priv->cached_fw =3D NULL;
> > +	priv->cached_pri_fw =3D NULL;
> > +#endif
>
> Please leave the orderring alone.
>

OK

> These just minimize the changes and reduce potential for conflicts
> during rebases/merges.
>
> Acked-by: David Kilroy <kilroyd@googlemail.com>

=46ixed version attached.

--Boundary-01=_snZqJrLUl/tWN1q
Content-Type: message/rfc822;
  name="orinoco-conditional-fw-cache"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="orinoco-conditional-fw-cache"

Subject: [PATCH] orinoco: firmware: consistently compile out fw cache support if not requested
From: Andrey Borzenkov <arvidjaar@mail.ru>

Currently part of support for FW caching is unconditionally compiled
in even if it is never used. Consistently remove caching support if
not requested by user.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

---

 drivers/net/wireless/orinoco/fw.c      |   37 +++++++++++++++++++++-----------
 drivers/net/wireless/orinoco/fw.h      |    5 ++++
 drivers/net/wireless/orinoco/main.c    |    2 ++
 drivers/net/wireless/orinoco/orinoco.h |    2 ++
 4 files changed, 33 insertions(+), 13 deletions(-)


diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 7d2292d..9bbc1dd 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -43,6 +43,19 @@ struct orinoco_fw_header {
 	char signature[0];      /* FW signature length headersize-20 */
 } __attribute__ ((packed));
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
+static inline const struct firmware *
+orinoco_cached_fw_get(struct orinoco_private *priv, bool primary)
+{
+	if (primary)
+		return priv->cached_pri_fw;
+	else
+		return priv->cached_fw;
+}
+#else
+#define orinoco_cached_fw_get(priv, primary) (NULL)
+#endif
+
 /* Download either STA or AP firmware into the card. */
 static int
 orinoco_dl_firmware(struct orinoco_private *priv,
@@ -79,7 +92,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	if (err)
 		goto free;
 
-	if (!priv->cached_fw) {
+	if (!orinoco_cached_fw_get(priv, false)) {
 		err = request_firmware(&fw_entry, firmware, priv->dev);
 
 		if (err) {
@@ -89,7 +102,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 			goto free;
 		}
 	} else
-		fw_entry = priv->cached_fw;
+		fw_entry = orinoco_cached_fw_get(priv, false);
 
 	hdr = (const struct orinoco_fw_header *) fw_entry->data;
 
@@ -132,7 +145,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 abort:
 	/* If we requested the firmware, release it. */
-	if (!priv->cached_fw)
+	if (!orinoco_cached_fw_get(priv, false))
 		release_firmware(fw_entry);
 
 free:
@@ -234,20 +247,20 @@ symbol_dl_firmware(struct orinoco_private *priv,
 	int ret;
 	const struct firmware *fw_entry;
 
-	if (!priv->cached_pri_fw) {
+	if (!orinoco_cached_fw_get(priv, true)) {
 		if (request_firmware(&fw_entry, fw->pri_fw, priv->dev) != 0) {
 			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
 			       dev->name, fw->pri_fw);
 			return -ENOENT;
 		}
 	} else
-		fw_entry = priv->cached_pri_fw;
+		fw_entry = orinoco_cached_fw_get(priv, true);
 
 	/* Load primary firmware */
 	ret = symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 0);
 
-	if (!priv->cached_pri_fw)
+	if (!orinoco_cached_fw_get(priv, true))
 		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Primary firmware download failed\n",
@@ -255,19 +268,19 @@ symbol_dl_firmware(struct orinoco_private *priv,
 		return ret;
 	}
 
-	if (!priv->cached_fw) {
+	if (!orinoco_cached_fw_get(priv, false)) {
 		if (request_firmware(&fw_entry, fw->sta_fw, priv->dev) != 0) {
 			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
 			       dev->name, fw->sta_fw);
 			return -ENOENT;
 		}
 	} else
-		fw_entry = priv->cached_fw;
+		fw_entry = orinoco_cached_fw_get(priv, false);
 
 	/* Load secondary firmware */
 	ret = symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 1);
-	if (!priv->cached_fw)
+	if (!orinoco_cached_fw_get(priv, false))
 		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Secondary firmware download failed\n",
@@ -301,9 +314,9 @@ int orinoco_download(struct orinoco_private *priv)
 	return err;
 }
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 {
-#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	const struct firmware *fw_entry = NULL;
 	const char *pri_fw;
 	const char *fw;
@@ -323,12 +336,10 @@ void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 		if (request_firmware(&fw_entry, fw, priv->dev) == 0)
 			priv->cached_fw = fw_entry;
 	}
-#endif
 }
 
 void orinoco_uncache_fw(struct orinoco_private *priv)
 {
-#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	if (priv->cached_pri_fw)
 		release_firmware(priv->cached_pri_fw);
 	if (priv->cached_fw)
@@ -336,5 +347,5 @@ void orinoco_uncache_fw(struct orinoco_private *priv)
 
 	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
-#endif
 }
+#endif
diff --git a/drivers/net/wireless/orinoco/fw.h b/drivers/net/wireless/orinoco/fw.h
index 2290f08..89fc26d 100644
--- a/drivers/net/wireless/orinoco/fw.h
+++ b/drivers/net/wireless/orinoco/fw.h
@@ -10,7 +10,12 @@ struct orinoco_private;
 
 int orinoco_download(struct orinoco_private *priv);
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 void orinoco_cache_fw(struct orinoco_private *priv, int ap);
 void orinoco_uncache_fw(struct orinoco_private *priv);
+#else
+#define orinoco_cache_fw(priv, ap) do { } while(0)
+#define orinoco_uncache_fw(priv) do { } while (0)
+#endif
 
 #endif /* _ORINOCO_FW_H_ */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index f953059..0a0c96a 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -2580,8 +2580,10 @@ struct net_device
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
+#endif
 
 	/* Register PM notifiers */
 	orinoco_register_pm_notifier(priv);
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index f3f94b2..8e5a72c 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -159,9 +159,11 @@ struct orinoco_private {
 	unsigned int tkip_cm_active:1;
 	unsigned int key_mgmt:3;
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	/* Cached in memory firmware to use during ->resume. */
 	const struct firmware *cached_pri_fw;
 	const struct firmware *cached_fw;
+#endif
 
 	struct notifier_block pm_notifier;
 };

--Boundary-01=_snZqJrLUl/tWN1q--

--nextPart1697587.xtBJHVPjmJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmpmewACgkQR6LMutpd94zjYwCdF8cgb6p1jLMhSr7rwhYEYSif
RmsAn26UfKPG575g4S6c0GVOmdpmM8pz
=wslp
-----END PGP SIGNATURE-----

--nextPart1697587.xtBJHVPjmJ--
