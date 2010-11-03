Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51442 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0KCVHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 17:07:15 -0400
Received: by wwe15 with SMTP id 15so1190931wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 14:07:13 -0700 (PDT)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: workarounds: be verbose about hacking SPROM revision, don't duplicate code
Date: Wed,  3 Nov 2010 22:06:26 +0100
Message-Id: <1288818386-25073-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This changes code flow the way even if workaround is needed, standard extracing
calls are used. Additionaly if user wants to know SPROM version (enabled
debugging) we really should let know also about hacking it!

John: this is 2.6.38 material. Is this OK to submit this via wireless tree?
---
 drivers/ssb/pci.c |   45 +++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 6e88d2b..3226832 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -573,37 +573,38 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 	ssb_dprintk(KERN_DEBUG PFX "SPROM revision %d detected.\n", out->revision);
 	memset(out->et0mac, 0xFF, 6);		/* preset et0 and et1 mac */
 	memset(out->et1mac, 0xFF, 6);
+
 	if ((bus->chip_id & 0xFF00) == 0x4400) {
 		/* Workaround: The BCM44XX chip has a stupid revision
 		 * number stored in the SPROM.
 		 * Always extract r1. */
 		out->revision = 1;
-		sprom_extract_r123(out, in);
+		ssb_dprintk(KERN_DEBUG PFX "SPROM treated as revision %d\n", out->revision);
 	} else if (bus->chip_id == 0x4321) {
 		/* the BCM4328 has a chipid == 0x4321 and a rev 4 SPROM */
 		out->revision = 4;
+		ssb_dprintk(KERN_DEBUG PFX "SPROM treated as revision %d\n", out->revision);
+	}
+
+	switch (out->revision) {
+	case 1:
+	case 2:
+	case 3:
+		sprom_extract_r123(out, in);
+		break;
+	case 4:
+	case 5:
 		sprom_extract_r45(out, in);
-	} else {
-		switch (out->revision) {
-		case 1:
-		case 2:
-		case 3:
-			sprom_extract_r123(out, in);
-			break;
-		case 4:
-		case 5:
-			sprom_extract_r45(out, in);
-			break;
-		case 8:
-			sprom_extract_r8(out, in);
-			break;
-		default:
-			ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
-				   "  revision %d detected. Will extract"
-				   " v1\n", out->revision);
-			out->revision = 1;
-			sprom_extract_r123(out, in);
-		}
+		break;
+	case 8:
+		sprom_extract_r8(out, in);
+		break;
+	default:
+		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
+			   "  revision %d detected. Will extract"
+			   " v1\n", out->revision);
+		out->revision = 1;
+		sprom_extract_r123(out, in);
 	}
 
 	if (out->boardflags_lo == 0xFFFF)
-- 
1.6.0.4

