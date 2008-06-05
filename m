Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13648 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbYFELIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 07:08:47 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/4] libertas: check for old, unsupported hardware
Date: Thu, 5 Jun 2008 13:08:35 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806051308.35863.hs4233@mail.mn-solutions.de> (sfid-20080605_130850_601233_325FD81E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux.orig/drivers/net/wireless/libertas/if_cs.c
+++ linux/drivers/net/wireless/libertas/if_cs.c
@@ -268,6 +268,12 @@
 #define IF_CS_SCRATCH_BOOT_OK		0x00
 #define IF_CS_SCRATCH_HELPER_OK		0x5a
 
+/*
+ * Used to detect ancient chips:
+ */
+#define IF_CS_PRODUCT_ID		0x0000001C
+#define IF_CS_CF8385_B1_REV		0x12
+
 
 /********************************************************************/
 /* I/O and interrupt handling                                       */
@@ -864,6 +871,12 @@
 	       p_dev->irq.AssignedIRQ, p_dev->io.BasePort1,
 	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
 
+	/* Check if we have a current silicon */
+	if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
+		lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
+		ret = -ENODEV;
+		goto out2;
+	}
 
 	/* Load the firmware early, before calling into libertas.ko */
 	ret = if_cs_prog_helper(card);
