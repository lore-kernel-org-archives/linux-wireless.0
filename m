Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37076 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZCVA1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 20:27:15 -0400
Received: by fxm2 with SMTP id 2so1337150fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2009 17:27:12 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH] Marvell CF8381
Date: Sun, 22 Mar 2009 01:27:21 +0100
Cc: hs4233@mail.mn-solutions.de
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pXYxJkOHNM+nfA1"
Message-Id: <200903220127.21836.marek.vasut@gmail.com> (sfid-20090322_012719_657905_493252C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_pXYxJkOHNM+nfA1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I've finally got this card working ...
See the patches below.

--Boundary-00=_pXYxJkOHNM+nfA1
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="0002-Add-support-for-CF8381-WiFi-card.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-Add-support-for-CF8381-WiFi-card.patch"

=46rom 31724e385f974b334b3a77949ab8aca1cad97e6e Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Sat, 21 Mar 2009 20:53:25 +0100
Subject: [PATCH 2/2] Add support for CF8381 WiFi card

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 drivers/net/wireless/libertas/if_cs.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/l=
ibertas/if_cs.c
index 3f02e6a..6d00d82 100644
=2D-- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -273,7 +273,14 @@ static int if_cs_poll_while_fw_download(struct if_cs_c=
ard *card, uint addr, u8 r
  */
 #define IF_CS_PRODUCT_ID		0x0000001C
 #define IF_CS_CF8385_B1_REV		0x12
+#define	IF_CS_CF8381_B3_REV		0x04
=20
+/*
+ * Used to detect other cards than CF8385 since their revisions of silicon
+ * doesn't match those from CF8385, eg. CF8381 B3 works with this driver.
+ */
+#define	CF8381_MANFID		0x02db
+#define	CF8381_CARDID		0x6064
=20
 /********************************************************************/
 /* I/O and interrupt handling                                       */
@@ -859,7 +866,9 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
=20
 	/* Check if we have a current silicon */
=2D	if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
+	if (!(p_dev->manf_id =3D=3D CF8381_MANFID &&
+		p_dev->card_id =3D=3D CF8381_CARDID) &&
+		(if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV)) {
 		lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
 		ret =3D -ENODEV;
 		goto out2;
@@ -950,6 +959,7 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
 /********************************************************************/
=20
 static struct pcmcia_device_id if_cs_ids[] =3D {
+	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
 	PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
 	PCMCIA_DEVICE_NULL,
 };
=2D-=20
1.6.2


--Boundary-00=_pXYxJkOHNM+nfA1
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="0001-Correct-return-value-of-firmware-loading-functions-h.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Correct-return-value-of-firmware-loading-functions-h.patch"

=46rom f87515bca27571370323292f07526820823b0553 Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Sat, 21 Mar 2009 19:20:30 +0100
Subject: [PATCH 1/2] Correct return value of firmware loading functions han=
dling bug

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 drivers/net/wireless/libertas/if_cs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/l=
ibertas/if_cs.c
index 842a08d..3f02e6a 100644
=2D-- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -867,9 +867,9 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
=20
 	/* Load the firmware early, before calling into libertas.ko */
 	ret =3D if_cs_prog_helper(card);
=2D	if (ret =3D=3D 0)
+	if (ret >=3D 0)
 		ret =3D if_cs_prog_real(card);
=2D	if (ret)
+	if (ret < 0)
 		goto out2;
=20
 	/* Make this card known to the libertas driver */
=2D-=20
1.6.2


--Boundary-00=_pXYxJkOHNM+nfA1--
