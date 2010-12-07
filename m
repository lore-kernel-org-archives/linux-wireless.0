Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43511 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab0LGSvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 13:51:02 -0500
Received: by wwa36 with SMTP id 36so233005wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 10:51:00 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Matt_Domsch@dell.com, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: initialise priv->hw before assigning the interrupt
Date: Tue,  7 Dec 2010 18:50:42 +0000
Message-Id: <1291747842-5634-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interrupt handler takes a lock - but since commit bcad6e80f3f this
lock goes through an indirection specified in the hermes_t structure.
We must therefore initialise the structure before setting up the
interrupt handler.

Fix orinoco_cs and spectrum_cs

<https://bugzilla.kernel.org/show_bug.cgi?id=23932>

Bisected by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off by: David Kilroy <kilroyd@googlemail.com>
---

This patch is based on wireless-testing.

Matt has tested the equivalent fix based on v2.6.35. There have been
other changes in this area due to pcmcia refactorring.

John, let me know if you'd like a separate version targetted at v2.6.37.

---
 drivers/net/wireless/orinoco/orinoco_cs.c  |   14 +++++++-------
 drivers/net/wireless/orinoco/spectrum_cs.c |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 71b3d68..32954c4 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -151,20 +151,20 @@ orinoco_cs_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	ret = pcmcia_request_irq(link, orinoco_interrupt);
-	if (ret)
-		goto failed;
-
-	/* We initialize the hermes structure before completing PCMCIA
-	 * configuration just in case the interrupt handler gets
-	 * called. */
 	mem = ioport_map(link->resource[0]->start,
 			resource_size(link->resource[0]));
 	if (!mem)
 		goto failed;
 
+	/* We initialize the hermes structure before completing PCMCIA
+	 * configuration just in case the interrupt handler gets
+	 * called. */
 	hermes_struct_init(hw, mem, HERMES_16BIT_REGSPACING);
 
+	ret = pcmcia_request_irq(link, orinoco_interrupt);
+	if (ret)
+		goto failed;
+
 	ret = pcmcia_enable_device(link);
 	if (ret)
 		goto failed;
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index fb859a5..db34c28 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -214,21 +214,21 @@ spectrum_cs_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	ret = pcmcia_request_irq(link, orinoco_interrupt);
-	if (ret)
-		goto failed;
-
-	/* We initialize the hermes structure before completing PCMCIA
-	 * configuration just in case the interrupt handler gets
-	 * called. */
 	mem = ioport_map(link->resource[0]->start,
 			resource_size(link->resource[0]));
 	if (!mem)
 		goto failed;
 
+	/* We initialize the hermes structure before completing PCMCIA
+	 * configuration just in case the interrupt handler gets
+	 * called. */
 	hermes_struct_init(hw, mem, HERMES_16BIT_REGSPACING);
 	hw->eeprom_pda = true;
 
+	ret = pcmcia_request_irq(link, orinoco_interrupt);
+	if (ret)
+		goto failed;
+
 	ret = pcmcia_enable_device(link);
 	if (ret)
 		goto failed;
-- 
1.7.2.2

