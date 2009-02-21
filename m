Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx40.mail.ru ([94.100.176.54]:65528 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbZBUQLd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 11:11:33 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH] orinoco: firmware: consistently compile out fw cache support if not requested
Date: Sat, 21 Feb 2009 19:11:14 +0300
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
References: <20090215100902.7895.2670.stgit@cooker.net> <49984F0F.3090401@gmail.com>
In-Reply-To: <49984F0F.3090401@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1606191.4qUQvCHPOi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200902211911.25718.arvidjaar@mail.ru> (sfid-20090221_171154_727320_DF47FA09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1606191.4qUQvCHPOi
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 15 of February 2009 20:21:19 Dave wrote:
> Andrey Borzenkov wrote:
> > Currently part of support for FW caching is unconditionally
> > compiled in even if it is never used. Consistently remove caching
> > support if not requested by user.
> >
> > Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
>
> I don't see much point, but...
>

It let me catch pm_notifiers errors at the very least :)

May be you are right; so if you NACK this one I won't object. But as long a=
s=20
time was already spent in it ...

> Rather than fiddling with how we access the pointers, I think it
> would be better to refactor these if..elses into function calls like
>
> fw_entry =3D orinoco_get_pri_fw(...);
>
> #if CACHING
> struct firmware *orinoco_get_pri_fw(...) {
>     priv->cached_fw;
> }
> #else
> struct firmware *orinoco_get_pri_fw(...) {
>     return request_firmware(..);
> }
> #endif
>

Won't work. We do need to know whether fw is cached or not (to properly=20
release it). And #ifdefs around if() statement are really unreadable.


> Don't remove the forward declaration, you introduce a dependency of
> this header on orinoco.h, which is otherwise unnecessary.
>

No more required in this version.

> Ick. Only fw.c needs the _get calls so they should not be in the
> header. Because the _set makes the other half of the pair I would
> argue they don't want to be there either. I'd suggest adding
> orinoco_fw_init instead, which cleared both elements.
>

I think in this case explicit #ifdef at the point of initialization makes i=
t=20
more clear.


> Suggest you don't move the inclusion forward.

Again no more needed in this version.

Let's test kmail again :)

Subject: [PATCH] orinoco: firmware: consistently compile out fw cache=20
support if not requested
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Currently part of support for FW caching is unconditionally compiled
in even if it is never used. Consistently remove caching support if
not requested by user.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco/fw.c      |   37=20
+++++++++++++++++++++-----------
 drivers/net/wireless/orinoco/fw.h      |    9 ++++++--
 drivers/net/wireless/orinoco/main.c    |    4 +++
 drivers/net/wireless/orinoco/orinoco.h |    2 ++
 4 files changed, 36 insertions(+), 16 deletions(-)


diff --git a/drivers/net/wireless/orinoco/fw.c=20
b/drivers/net/wireless/orinoco/fw.c
index 7d2292d..9bbc1dd 100644
=2D-- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -43,6 +43,19 @@ struct orinoco_fw_header {
 	char signature[0];      /* FW signature length headersize-20 */
 } __attribute__ ((packed));
=20
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
=20
=2D	if (!priv->cached_fw) {
+	if (!orinoco_cached_fw_get(priv, false)) {
 		err =3D request_firmware(&fw_entry, firmware, priv->dev);
=20
 		if (err) {
@@ -89,7 +102,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 			goto free;
 		}
 	} else
=2D		fw_entry =3D priv->cached_fw;
+		fw_entry =3D orinoco_cached_fw_get(priv, false);
=20
 	hdr =3D (const struct orinoco_fw_header *) fw_entry->data;
=20
@@ -132,7 +145,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
=20
 abort:
 	/* If we requested the firmware, release it. */
=2D	if (!priv->cached_fw)
+	if (!orinoco_cached_fw_get(priv, false))
 		release_firmware(fw_entry);
=20
 free:
@@ -234,20 +247,20 @@ symbol_dl_firmware(struct orinoco_private *priv,
 	int ret;
 	const struct firmware *fw_entry;
=20
=2D	if (!priv->cached_pri_fw) {
+	if (!orinoco_cached_fw_get(priv, true)) {
 		if (request_firmware(&fw_entry, fw->pri_fw, priv->dev) !=3D 0) {
 			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
 			       dev->name, fw->pri_fw);
 			return -ENOENT;
 		}
 	} else
=2D		fw_entry =3D priv->cached_pri_fw;
+		fw_entry =3D orinoco_cached_fw_get(priv, true);
=20
 	/* Load primary firmware */
 	ret =3D symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 0);
=20
=2D	if (!priv->cached_pri_fw)
+	if (!orinoco_cached_fw_get(priv, true))
 		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Primary firmware download failed\n",
@@ -255,19 +268,19 @@ symbol_dl_firmware(struct orinoco_private *priv,
 		return ret;
 	}
=20
=2D	if (!priv->cached_fw) {
+	if (!orinoco_cached_fw_get(priv, false)) {
 		if (request_firmware(&fw_entry, fw->sta_fw, priv->dev) !=3D 0) {
 			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
 			       dev->name, fw->sta_fw);
 			return -ENOENT;
 		}
 	} else
=2D		fw_entry =3D priv->cached_fw;
+		fw_entry =3D orinoco_cached_fw_get(priv, false);
=20
 	/* Load secondary firmware */
 	ret =3D symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 1);
=2D	if (!priv->cached_fw)
+	if (!orinoco_cached_fw_get(priv, false))
 		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Secondary firmware download failed\n",
@@ -301,9 +314,9 @@ int orinoco_download(struct orinoco_private *priv)
 	return err;
 }
=20
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 {
=2D#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	const struct firmware *fw_entry =3D NULL;
 	const char *pri_fw;
 	const char *fw;
@@ -323,12 +336,10 @@ void orinoco_cache_fw(struct orinoco_private *priv,=20
int ap)
 		if (request_firmware(&fw_entry, fw, priv->dev) =3D=3D 0)
 			priv->cached_fw =3D fw_entry;
 	}
=2D#endif
 }
=20
 void orinoco_uncache_fw(struct orinoco_private *priv)
 {
=2D#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	if (priv->cached_pri_fw)
 		release_firmware(priv->cached_pri_fw);
 	if (priv->cached_fw)
@@ -336,5 +347,5 @@ void orinoco_uncache_fw(struct orinoco_private *priv)
=20
 	priv->cached_pri_fw =3D NULL;
 	priv->cached_fw =3D NULL;
=2D#endif
 }
+#endif
diff --git a/drivers/net/wireless/orinoco/fw.h=20
b/drivers/net/wireless/orinoco/fw.h
index 2290f08..49eb9f8 100644
=2D-- a/drivers/net/wireless/orinoco/fw.h
+++ b/drivers/net/wireless/orinoco/fw.h
@@ -10,7 +10,12 @@ struct orinoco_private;
=20
 int orinoco_download(struct orinoco_private *priv);
=20
=2Dvoid orinoco_cache_fw(struct orinoco_private *priv, int ap);
=2Dvoid orinoco_uncache_fw(struct orinoco_private *priv);
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
+extern void orinoco_cache_fw(struct orinoco_private *priv, int ap);
+extern void orinoco_uncache_fw(struct orinoco_private *priv);
+#else
+#define orinoco_cache_fw(priv, ap) do { } while(0)
+#define orinoco_uncache_fw(priv) do { } while (0)
+#endif
=20
 #endif /* _ORINOCO_FW_H_ */
diff --git a/drivers/net/wireless/orinoco/main.c=20
b/drivers/net/wireless/orinoco/main.c
index f953059..694e74b 100644
=2D-- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -2580,8 +2580,10 @@ struct net_device
 	netif_carrier_off(dev);
 	priv->last_linkstatus =3D 0xffff;
=20
=2D	priv->cached_pri_fw =3D NULL;
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	priv->cached_fw =3D NULL;
+	priv->cached_pri_fw =3D NULL;
+#endif
=20
 	/* Register PM notifiers */
 	orinoco_register_pm_notifier(priv);
diff --git a/drivers/net/wireless/orinoco/orinoco.h=20
b/drivers/net/wireless/orinoco/orinoco.h
index f3f94b2..8e5a72c 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -159,9 +159,11 @@ struct orinoco_private {
 	unsigned int tkip_cm_active:1;
 	unsigned int key_mgmt:3;
=20
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	/* Cached in memory firmware to use during ->resume. */
 	const struct firmware *cached_pri_fw;
 	const struct firmware *cached_fw;
+#endif
=20
 	struct notifier_block pm_notifier;
 };


--nextPart1606191.4qUQvCHPOi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmgJ6QACgkQR6LMutpd94zg9gCfaM3Ytx9DiCzVnerC7QLJLBLV
HU4AnAnbi6dVdNSR0QhbPyyRIAnaanTR
=K6C0
-----END PGP SIGNATURE-----

--nextPart1606191.4qUQvCHPOi--
