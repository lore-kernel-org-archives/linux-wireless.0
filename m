Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33715 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2ABHAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 02:00:11 -0500
Received: by wibhm6 with SMTP id hm6so8194352wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jan 2012 23:00:10 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] bcma: SPROM: add macro for easier extraction
Date: Mon,  2 Jan 2012 08:41:24 +0100
Message-Id: <1325490085-3806-2-git-send-email-zajec5@gmail.com> (sfid-20120102_080038_471898_712E8552)
In-Reply-To: <1325490085-3806-1-git-send-email-zajec5@gmail.com>
References: <1325490085-3806-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c |  139 +++++++++++++++++++++++++------------------------
 1 files changed, 71 insertions(+), 68 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 6f230fb..27f62cc 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -14,8 +14,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 
-#define SPOFF(offset)	((offset) / sizeof(u16))
-
 /**************************************************
  * R/W ops.
  **************************************************/
@@ -124,6 +122,11 @@ static int bcma_sprom_valid(const u16 *sprom)
  * SPROM extraction.
  **************************************************/
 
+#define SPOFF(offset)	((offset) / sizeof(u16))
+
+#define SPEX(_field, _offset, _mask, _shift)	\
+	bus->sprom._field = ((sprom[SPOFF(_offset)] & (_mask)) >> (_shift))
+
 static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 {
 	u16 v;
@@ -137,72 +140,72 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
 	}
 
-	bus->sprom.board_rev = sprom[SPOFF(SSB_SPROM8_BOARDREV)];
-
-	bus->sprom.txpid2g[0] = (sprom[SPOFF(SSB_SPROM4_TXPID2G01)] &
-	     SSB_SPROM4_TXPID2G0) >> SSB_SPROM4_TXPID2G0_SHIFT;
-	bus->sprom.txpid2g[1] = (sprom[SPOFF(SSB_SPROM4_TXPID2G01)] &
-	     SSB_SPROM4_TXPID2G1) >> SSB_SPROM4_TXPID2G1_SHIFT;
-	bus->sprom.txpid2g[2] = (sprom[SPOFF(SSB_SPROM4_TXPID2G23)] &
-	     SSB_SPROM4_TXPID2G2) >> SSB_SPROM4_TXPID2G2_SHIFT;
-	bus->sprom.txpid2g[3] = (sprom[SPOFF(SSB_SPROM4_TXPID2G23)] &
-	     SSB_SPROM4_TXPID2G3) >> SSB_SPROM4_TXPID2G3_SHIFT;
-
-	bus->sprom.txpid5gl[0] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL01)] &
-	     SSB_SPROM4_TXPID5GL0) >> SSB_SPROM4_TXPID5GL0_SHIFT;
-	bus->sprom.txpid5gl[1] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL01)] &
-	     SSB_SPROM4_TXPID5GL1) >> SSB_SPROM4_TXPID5GL1_SHIFT;
-	bus->sprom.txpid5gl[2] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL23)] &
-	     SSB_SPROM4_TXPID5GL2) >> SSB_SPROM4_TXPID5GL2_SHIFT;
-	bus->sprom.txpid5gl[3] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL23)] &
-	     SSB_SPROM4_TXPID5GL3) >> SSB_SPROM4_TXPID5GL3_SHIFT;
-
-	bus->sprom.txpid5g[0] = (sprom[SPOFF(SSB_SPROM4_TXPID5G01)] &
-	     SSB_SPROM4_TXPID5G0) >> SSB_SPROM4_TXPID5G0_SHIFT;
-	bus->sprom.txpid5g[1] = (sprom[SPOFF(SSB_SPROM4_TXPID5G01)] &
-	     SSB_SPROM4_TXPID5G1) >> SSB_SPROM4_TXPID5G1_SHIFT;
-	bus->sprom.txpid5g[2] = (sprom[SPOFF(SSB_SPROM4_TXPID5G23)] &
-	     SSB_SPROM4_TXPID5G2) >> SSB_SPROM4_TXPID5G2_SHIFT;
-	bus->sprom.txpid5g[3] = (sprom[SPOFF(SSB_SPROM4_TXPID5G23)] &
-	     SSB_SPROM4_TXPID5G3) >> SSB_SPROM4_TXPID5G3_SHIFT;
-
-	bus->sprom.txpid5gh[0] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH01)] &
-	     SSB_SPROM4_TXPID5GH0) >> SSB_SPROM4_TXPID5GH0_SHIFT;
-	bus->sprom.txpid5gh[1] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH01)] &
-	     SSB_SPROM4_TXPID5GH1) >> SSB_SPROM4_TXPID5GH1_SHIFT;
-	bus->sprom.txpid5gh[2] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH23)] &
-	     SSB_SPROM4_TXPID5GH2) >> SSB_SPROM4_TXPID5GH2_SHIFT;
-	bus->sprom.txpid5gh[3] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH23)] &
-	     SSB_SPROM4_TXPID5GH3) >> SSB_SPROM4_TXPID5GH3_SHIFT;
-
-	bus->sprom.boardflags_lo = sprom[SPOFF(SSB_SPROM8_BFLLO)];
-	bus->sprom.boardflags_hi = sprom[SPOFF(SSB_SPROM8_BFLHI)];
-	bus->sprom.boardflags2_lo = sprom[SPOFF(SSB_SPROM8_BFL2LO)];
-	bus->sprom.boardflags2_hi = sprom[SPOFF(SSB_SPROM8_BFL2HI)];
-
-	bus->sprom.country_code = sprom[SPOFF(SSB_SPROM8_CCODE)];
-
-	bus->sprom.fem.ghz2.tssipos = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
-		SSB_SROM8_FEM_TSSIPOS) >> SSB_SROM8_FEM_TSSIPOS_SHIFT;
-	bus->sprom.fem.ghz2.extpa_gain = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
-		SSB_SROM8_FEM_EXTPA_GAIN) >> SSB_SROM8_FEM_EXTPA_GAIN_SHIFT;
-	bus->sprom.fem.ghz2.pdet_range = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
-		SSB_SROM8_FEM_PDET_RANGE) >> SSB_SROM8_FEM_PDET_RANGE_SHIFT;
-	bus->sprom.fem.ghz2.tr_iso = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
-		SSB_SROM8_FEM_TR_ISO) >> SSB_SROM8_FEM_TR_ISO_SHIFT;
-	bus->sprom.fem.ghz2.antswlut = (sprom[SPOFF(SSB_SPROM8_FEM2G)] &
-		SSB_SROM8_FEM_ANTSWLUT) >> SSB_SROM8_FEM_ANTSWLUT_SHIFT;
-
-	bus->sprom.fem.ghz5.tssipos = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
-		SSB_SROM8_FEM_TSSIPOS) >> SSB_SROM8_FEM_TSSIPOS_SHIFT;
-	bus->sprom.fem.ghz5.extpa_gain = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
-		SSB_SROM8_FEM_EXTPA_GAIN) >> SSB_SROM8_FEM_EXTPA_GAIN_SHIFT;
-	bus->sprom.fem.ghz5.pdet_range = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
-		SSB_SROM8_FEM_PDET_RANGE) >> SSB_SROM8_FEM_PDET_RANGE_SHIFT;
-	bus->sprom.fem.ghz5.tr_iso = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
-		SSB_SROM8_FEM_TR_ISO) >> SSB_SROM8_FEM_TR_ISO_SHIFT;
-	bus->sprom.fem.ghz5.antswlut = (sprom[SPOFF(SSB_SPROM8_FEM5G)] &
-		SSB_SROM8_FEM_ANTSWLUT) >> SSB_SROM8_FEM_ANTSWLUT_SHIFT;
+	SPEX(board_rev, SSB_SPROM8_BOARDREV, ~0, 0);
+
+	SPEX(txpid2g[0], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G0,
+	     SSB_SPROM4_TXPID2G0_SHIFT);
+	SPEX(txpid2g[1], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G1,
+	     SSB_SPROM4_TXPID2G1_SHIFT);
+	SPEX(txpid2g[2], SSB_SPROM4_TXPID2G23, SSB_SPROM4_TXPID2G2,
+	     SSB_SPROM4_TXPID2G2_SHIFT);
+	SPEX(txpid2g[3], SSB_SPROM4_TXPID2G23, SSB_SPROM4_TXPID2G3,
+	     SSB_SPROM4_TXPID2G3_SHIFT);
+
+	SPEX(txpid5gl[0], SSB_SPROM4_TXPID5GL01, SSB_SPROM4_TXPID5GL0,
+	     SSB_SPROM4_TXPID5GL0_SHIFT);
+	SPEX(txpid5gl[1], SSB_SPROM4_TXPID5GL01, SSB_SPROM4_TXPID5GL1,
+	     SSB_SPROM4_TXPID5GL1_SHIFT);
+	SPEX(txpid5gl[2], SSB_SPROM4_TXPID5GL23, SSB_SPROM4_TXPID5GL2,
+	     SSB_SPROM4_TXPID5GL2_SHIFT);
+	SPEX(txpid5gl[3], SSB_SPROM4_TXPID5GL23, SSB_SPROM4_TXPID5GL3,
+	     SSB_SPROM4_TXPID5GL3_SHIFT);
+
+	SPEX(txpid5g[0], SSB_SPROM4_TXPID5G01, SSB_SPROM4_TXPID5G0,
+	     SSB_SPROM4_TXPID5G0_SHIFT);
+	SPEX(txpid5g[1], SSB_SPROM4_TXPID5G01, SSB_SPROM4_TXPID5G1,
+	     SSB_SPROM4_TXPID5G1_SHIFT);
+	SPEX(txpid5g[2], SSB_SPROM4_TXPID5G23, SSB_SPROM4_TXPID5G2,
+	     SSB_SPROM4_TXPID5G2_SHIFT);
+	SPEX(txpid5g[3], SSB_SPROM4_TXPID5G23, SSB_SPROM4_TXPID5G3,
+	     SSB_SPROM4_TXPID5G3_SHIFT);
+
+	SPEX(txpid5gh[0], SSB_SPROM4_TXPID5GH01, SSB_SPROM4_TXPID5GH0,
+	     SSB_SPROM4_TXPID5GH0_SHIFT);
+	SPEX(txpid5gh[1], SSB_SPROM4_TXPID5GH01, SSB_SPROM4_TXPID5GH1,
+	     SSB_SPROM4_TXPID5GH1_SHIFT);
+	SPEX(txpid5gh[2], SSB_SPROM4_TXPID5GH23, SSB_SPROM4_TXPID5GH2,
+	     SSB_SPROM4_TXPID5GH2_SHIFT);
+	SPEX(txpid5gh[3], SSB_SPROM4_TXPID5GH23, SSB_SPROM4_TXPID5GH3,
+	     SSB_SPROM4_TXPID5GH3_SHIFT);
+
+	SPEX(boardflags_lo, SSB_SPROM8_BFLLO, ~0, 0);
+	SPEX(boardflags_hi, SSB_SPROM8_BFLHI, ~0, 0);
+	SPEX(boardflags2_lo, SSB_SPROM8_BFL2LO, ~0, 0);
+	SPEX(boardflags2_hi, SSB_SPROM8_BFL2HI, ~0, 0);
+
+	SPEX(country_code, SSB_SPROM8_CCODE, ~0, 0);
+
+	SPEX(fem.ghz2.tssipos, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_TSSIPOS,
+	     SSB_SROM8_FEM_TSSIPOS_SHIFT);
+	SPEX(fem.ghz2.extpa_gain, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_EXTPA_GAIN,
+	     SSB_SROM8_FEM_EXTPA_GAIN_SHIFT);
+	SPEX(fem.ghz2.pdet_range, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_PDET_RANGE,
+	     SSB_SROM8_FEM_PDET_RANGE_SHIFT);
+	SPEX(fem.ghz2.tr_iso, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_TR_ISO,
+	     SSB_SROM8_FEM_TR_ISO_SHIFT);
+	SPEX(fem.ghz2.antswlut, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_ANTSWLUT,
+	     SSB_SROM8_FEM_ANTSWLUT_SHIFT);
+
+	SPEX(fem.ghz5.tssipos, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_TSSIPOS,
+	     SSB_SROM8_FEM_TSSIPOS_SHIFT);
+	SPEX(fem.ghz5.extpa_gain, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_EXTPA_GAIN,
+	     SSB_SROM8_FEM_EXTPA_GAIN_SHIFT);
+	SPEX(fem.ghz5.pdet_range, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_PDET_RANGE,
+	     SSB_SROM8_FEM_PDET_RANGE_SHIFT);
+	SPEX(fem.ghz5.tr_iso, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_TR_ISO,
+	     SSB_SROM8_FEM_TR_ISO_SHIFT);
+	SPEX(fem.ghz5.antswlut, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_ANTSWLUT,
+	     SSB_SROM8_FEM_ANTSWLUT_SHIFT);
 }
 
 int bcma_sprom_get(struct bcma_bus *bus)
-- 
1.7.3.4

