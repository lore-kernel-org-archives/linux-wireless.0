Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55139 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZBTN2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 08:28:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix radio host flags
Date: Fri, 20 Feb 2009 14:27:15 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902201427.15652.mb@bu3sch.de> (sfid-20090220_142815_120826_7059C3ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes initialization of some radio related hostflags.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this doesn't fix a known bug. Please queue for the next feature release.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-02-20 12:34:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-02-20 12:34:53.000000000 +0100
@@ -4178,16 +4178,18 @@ static int b43_wireless_core_init(struct
 	if (phy->type == B43_PHYTYPE_G) {
 		hf |= B43_HF_SYMW;
 		if (phy->rev == 1)
 			hf |= B43_HF_GDCW;
 		if (sprom->boardflags_lo & B43_BFL_PACTRL)
 			hf |= B43_HF_OFDMPABOOST;
-	} else if (phy->type == B43_PHYTYPE_B) {
-		hf |= B43_HF_SYMW;
-		if (phy->rev >= 2 && phy->radio_ver == 0x2050)
-			hf &= ~B43_HF_GDCW;
+	}
+	if (phy->radio_ver == 0x2050) {
+		if (phy->radio_rev == 6)
+			hf |= B43_HF_4318TSSI;
+		if (phy->radio_rev < 6)
+			hf |= B43_HF_VCORECALC;
 	}
 	b43_hf_write(dev, hf);
 
 	b43_set_retry_limits(dev, B43_DEFAULT_SHORT_RETRY_LIMIT,
 			     B43_DEFAULT_LONG_RETRY_LIMIT);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);

-- 
Greetings, Michael.
