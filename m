Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:65013 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYEXASG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 20:18:06 -0400
Received: by an-out-0708.google.com with SMTP id d40so201069and.103
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 17:18:03 -0700 (PDT)
From: =?iso-8859-1?q?Andr=E9s_Ambrois?= <andresambrois@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: hostap oops
Date: Fri, 23 May 2008 21:18:03 -0300
References: <48374F39.40904@gmx.de> <69e28c910805231616m401f5222xfe85ae34ca2fb05d@mail.gmail.com> <48375141.5000704@gmx.de>
In-Reply-To: <48375141.5000704@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2411183.ZvSUGVNhLF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200805232118.08189.andresambrois@gmail.com> (sfid-20080524_021811_114716_6B72ED19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2411183.ZvSUGVNhLF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 23 May 2008 20:20:33 Thomas Kunze wrote:
> Stefanik G=E1bor wrote:
> > Hmm... can you make the comments and variables English? You know,
> > Linus Torvalds is Finnish, yet he still uses English comments and
> > variable names.
>
> I would like to, but I can't read spanish (?).  I didn't write this
> patch, I googled it.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Here goes the translation.=20

Just trying to make myself useful :).=20

  -Andr=E9s
=2D-

diff --git a/drivers/net/wireless/hostap/hostap_cs.c=20
b/drivers/net/wireless/hostap/hostap_cs.c
index ed4317a..804f365 100644
=2D-- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -35,7 +35,7 @@ static int ignore_cis_vcc;
=A0module_param(ignore_cis_vcc, int, 0444);
=A0MODULE_PARM_DESC(ignore_cis_vcc, "Ignore broken CIS VCC entry");
=A0
=2D
+int activate=3D0;
=A0/* struct local_info::hw_priv */
=A0struct hostap_cs_priv {
=A0=A0=A0=A0=A0=A0=A0=A0dev_node_t node;
@@ -499,11 +499,13 @@ static int hostap_cs_probe(struct pcmcia_device *p_de=
v)
=A0
=A0=A0=A0=A0=A0=A0=A0=A0PDEBUG(DEBUG_HW, "%s: setting Vcc=3D33 (constant)\n=
", dev_info);
=A0=A0=A0=A0=A0=A0=A0=A0p_dev->conf.IntType =3D INT_MEMORY_AND_IO;
=2D
+=A0=A0=A0=A0=A0=A0=A0
+=A0=A0=A0=A0=A0=A0=A0activate=3D0;
=A0=A0=A0=A0=A0=A0=A0=A0ret =3D prism2_config(p_dev);
=A0=A0=A0=A0=A0=A0=A0=A0if (ret) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0PDEBUG(DEBUG_EXTRA, "prism2=
_config() failed\n");
=A0=A0=A0=A0=A0=A0=A0=A0}
+=A0=A0=A0=A0=A0=A0=A0activate=3D1;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0return ret;
=A0}
diff --git a/drivers/net/wireless/hostap/hostap_hw.c=20
b/drivers/net/wireless/hostap/hostap_hw.c
index cdf90c4..d79a2a5 100644
=2D-- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -54,6 +54,7 @@
=A0#include "hostap.h"
=A0#include "hostap_ap.h"
=A0
+extern int activate;
=A0
=A0/* #define final_version */
=A0
@@ -1497,6 +1498,8 @@ static int prism2_hw_config(struct net_device *dev, i=
nt=20
initial)
=A0=A0=A0=A0=A0=A0=A0=A0if (local->hw_downloading)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
=A0
+=A0=A0=A0=A0=A0=A0=A0activate=3D1;
+
=A0=A0=A0=A0=A0=A0=A0=A0if (prism2_hw_init(dev, initial)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return local->no_pri ? 0 : =
1;
=A0=A0=A0=A0=A0=A0=A0=A0}
@@ -2628,8 +2631,15 @@ static irqreturn_t prism2_interrupt(int irq, void=20
*dev_id)
=A0=A0=A0=A0=A0=A0=A0=A0int events =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0u16 ev;
=A0
=2D=A0=A0=A0=A0=A0=A0=A0iface =3D netdev_priv(dev);
=2D=A0=A0=A0=A0=A0=A0=A0local =3D iface->local;
+
+=A0=A0=A0=A0=A0=A0=A0// All the input parameters are correct (not null). A=
t the moment,=20
this is the only way I know to detect the problem.=20
+=A0=A0=A0=A0=A0=A0=A0if (!activate) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0printk("hostap_hw.c: INTERRUP=
T BEFORE DEVICE INIT!\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return IRQ_HANDLED;
+=A0=A0=A0=A0=A0=A0=A0}
+
+ =A0=A0=A0=A0=A0=A0iface =3D netdev_priv(dev);
+ =A0=A0=A0=A0=A0=A0local =3D iface->local;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0prism2_io_debug_add(dev, PRISM2_IO_DEBUG_CMD_INTERR=
UPT, 0, 0);
=A0
diff --git a/drivers/net/wireless/hostap/hostap_pci.c=20
b/drivers/net/wireless/hostap/hostap_pci.c
index 3a874fc..df58aa3 100644
=2D-- a/drivers/net/wireless/hostap/hostap_pci.c
+++ b/drivers/net/wireless/hostap/hostap_pci.c
@@ -19,6 +19,7 @@
=A0
=A0#include "hostap_wlan.h"
=A0
+int activate=3D1;
=A0
=A0static char *dev_info =3D "hostap_pci";
=A0
diff --git a/drivers/net/wireless/hostap/hostap_plx.c=20
b/drivers/net/wireless/hostap/hostap_plx.c
index cbf15d7..4475174 100644
=2D-- a/drivers/net/wireless/hostap/hostap_plx.c
+++ b/drivers/net/wireless/hostap/hostap_plx.c
@@ -21,7 +21,7 @@
=A0#include <asm/io.h>
=A0
=A0#include "hostap_wlan.h"
=2D
+int activate=3D1;
=A0
=A0static char *dev_info =3D "hostap_plx";
=20

--nextPart2411183.ZvSUGVNhLF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIN17AE4AIC3GVWaoRArhzAJ4/rpBAgkTnLJx3Ow2U+cmU9jqz1wCgg8Z6
e8rKLzHrQF160QlMktNmHtA=
=iceg
-----END PGP SIGNATURE-----

--nextPart2411183.ZvSUGVNhLF--
