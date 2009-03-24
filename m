Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:7506 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbZCXUdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:33:37 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1004437muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 13:33:34 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Marvell CF8381
Date: Tue, 24 Mar 2009 21:33:43 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <1237890387.25734.9.camel@localhost.localdomain> <20090324200118.GD19335@tuxdriver.com>
In-Reply-To: <20090324200118.GD19335@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nOUyJA5x/5bVHU2"
Message-Id: <200903242133.43882.marek.vasut@gmail.com> (sfid-20090324_213339_658745_4F13211F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_nOUyJA5x/5bVHU2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 24 of March 2009 21:01:18 John W. Linville wrote:
> On Tue, Mar 24, 2009 at 06:26:27AM -0400, Dan Williams wrote:
> > On Tue, 2009-03-24 at 00:42 +0100, Marek Vasut wrote:
> > > Ok, here is another version, hopefully last one.
> > >
> > > From a7522df9d610702cfc3066861a2e315552e29086 Mon Sep 17 00:00:00 2001
> > > From: Marek Vasut <marek.vasut@gmail.com>
> > > Date: Tue, 24 Mar 2009 00:40:44 +0100
> > > Subject: [PATCH] Add support for CF8381 WiFi card.
> > >  A detection function was added for identifying CF8381.
> > >
> > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> >
> > Acked-by: Dan Williams <dcbw@redhat.com>
>
> The patch is whitespace-damaged.  Please resubmit w/o whitespace
> damage in a separate email.
Sending as an attachment so it wont get broken.
>
> Thanks,
>
> John



--Boundary-00=_nOUyJA5x/5bVHU2
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="0001-Add-support-for-CF8381-WiFi-card.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Add-support-for-CF8381-WiFi-card.patch"

=46rom a7522df9d610702cfc3066861a2e315552e29086 Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Tue, 24 Mar 2009 00:40:44 +0100
Subject: [PATCH] Add support for CF8381 WiFi card.
 A detection function was added for identifying CF8381.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 drivers/net/wireless/libertas/if_cs.c |   34 +++++++++++++++++++++++++++++=
++-
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/l=
ibertas/if_cs.c
index 3f02e6a..1da23e5 100644
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
+#define CF8381_MANFID		0x02db
+#define CF8381_CARDID		0x6064
+#define CF8385_MANFID		0x02df
+#define CF8385_CARDID		0x8103
+
+static inline int if_cs_hw_is_cf8381(struct pcmcia_device *p_dev)
+{
+	return (p_dev->manf_id =3D=3D CF8381_MANFID &&
+		p_dev->card_id =3D=3D CF8381_CARDID);
+}
+
+static inline int if_cs_hw_is_cf8385(struct pcmcia_device *p_dev)
+{
+	return (p_dev->manf_id =3D=3D CF8385_MANFID &&
+		p_dev->card_id =3D=3D CF8385_CARDID);
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
@@ -859,7 +881,14 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
=20
 	/* Check if we have a current silicon */
=2D	if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
+	prod_id =3D if_cs_read8(card, IF_CS_PRODUCT_ID);
+	if (if_cs_hw_is_cf8381(p_dev) && prod_id < IF_CS_CF8381_B3_REV) {
+		lbs_pr_err("old chips like 8381 rev B3 aren't supported\n");
+		ret =3D -ENODEV;
+		goto out2;
+	}
+
+	if (if_cs_hw_is_cf8385(p_dev) && prod_id < IF_CS_CF8385_B1_REV) {
 		lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
 		ret =3D -ENODEV;
 		goto out2;
@@ -950,7 +979,8 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
 /********************************************************************/
=20
 static struct pcmcia_device_id if_cs_ids[] =3D {
=2D	PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
+	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
+	PCMCIA_DEVICE_MANF_CARD(CF8385_MANFID, CF8385_CARDID),
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, if_cs_ids);
=2D-=20
1.6.2


--Boundary-00=_nOUyJA5x/5bVHU2--
