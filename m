Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40460 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbZCWP66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 11:58:58 -0400
Received: by fxm2 with SMTP id 2so1864670fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 08:58:55 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] Marvell CF8381 and CF8305
Date: Mon, 23 Mar 2009 16:59:05 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903231313.10699.hs4233@mail.mn-solutions.de>
In-Reply-To: <200903231313.10699.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JH7xJnZ2B22e4G7"
Message-Id: <200903231659.05158.marek.vasut@gmail.com> (sfid-20090323_165919_422847_8FF47D55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_JH7xJnZ2B22e4G7
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here's the other patch.
I also added cf8305 support (if_cs.c patched this way works for it too).

--Boundary-00=_JH7xJnZ2B22e4G7
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="0002-Add-support-for-CF8381-and-CF8305-WiFi-card.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-Add-support-for-CF8381-and-CF8305-WiFi-card.patch"

=46rom 4c7fcf79de8ba900c4a9a56e68c9da89491dff27 Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Mon, 23 Mar 2009 16:50:30 +0100
Subject: [PATCH 2/2] Add support for CF8381 and CF8305 WiFi card.
 Two detection functions were added for identifying CF8381 and CF8305.
 Also, CF8305 uses only one-stage firmware, so handle this as well.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 drivers/net/wireless/libertas/if_cs.c |   35 +++++++++++++++++++++++++++++=
+--
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/l=
ibertas/if_cs.c
index 3f02e6a..e115c8f 100644
=2D-- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -273,7 +273,28 @@ static int if_cs_poll_while_fw_download(struct if_cs_c=
ard *card, uint addr, u8 r
  */
 #define IF_CS_PRODUCT_ID		0x0000001C
 #define IF_CS_CF8385_B1_REV		0x12
+#define IF_CS_CF8381_B3_REV		0x04
=20
+/*
+ * Used to detect other cards than CF8385 since their revisions of silicon
+ * doesn't match those from CF8385, eg. CF8381 B3 works with this driver.
+ */
+#define CF8305_MANFID		0x02db
+#define CF8305_CARDID		0x8103
+#define CF8381_MANFID		0x02db
+#define CF8381_CARDID		0x6064
+
+static inline int if_cs_hw_is_cf8305(struct pcmcia_device *p_dev)
+{
+	return (p_dev->manf_id =3D=3D CF8305_MANFID &&
+		p_dev->card_id =3D=3D CF8305_CARDID);
+}
+
+static inline int if_cs_hw_is_cf8381(struct pcmcia_device *p_dev)
+{
+	return (p_dev->manf_id =3D=3D CF8381_MANFID &&
+		p_dev->card_id =3D=3D CF8381_CARDID);
+}
=20
 /********************************************************************/
 /* I/O and interrupt handling                                       */
@@ -757,6 +778,7 @@ static void if_cs_release(struct pcmcia_device *p_dev)
 static int if_cs_probe(struct pcmcia_device *p_dev)
 {
 	int ret =3D -ENOMEM;
+	unsigned int prod_id;
 	struct lbs_private *priv;
 	struct if_cs_card *card;
 	/* CIS parsing */
@@ -859,15 +881,20 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
=20
 	/* Check if we have a current silicon */
=2D	if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
=2D		lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
+	prod_id =3D if_cs_read8(card, IF_CS_PRODUCT_ID);
+	if (!(if_cs_hw_is_cf8305(p_dev) ||
+		(if_cs_hw_is_cf8381(p_dev) &&
+		prod_id >=3D IF_CS_CF8381_B3_REV)) &&
+		(prod_id < IF_CS_CF8385_B1_REV)) {
+		lbs_pr_err("old chips like 8385 rev B1 or "
+			"8381 rev B3 aren't supported\n");
 		ret =3D -ENODEV;
 		goto out2;
 	}
=20
 	/* Load the firmware early, before calling into libertas.ko */
 	ret =3D if_cs_prog_helper(card);
=2D	if (ret >=3D 0)
+	if (ret >=3D 0 && !if_cs_hw_is_cf8305(p_dev))
 		ret =3D if_cs_prog_real(card);
 	if (ret < 0)
 		goto out2;
@@ -950,6 +977,8 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
 /********************************************************************/
=20
 static struct pcmcia_device_id if_cs_ids[] =3D {
+	PCMCIA_DEVICE_MANF_CARD(CF8305_MANFID, CF8305_CARDID),
+	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
 	PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
 	PCMCIA_DEVICE_NULL,
 };
=2D-=20
1.6.2


--Boundary-00=_JH7xJnZ2B22e4G7--
