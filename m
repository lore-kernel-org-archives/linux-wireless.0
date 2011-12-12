Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab1LLTwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 14:52:15 -0500
Received: by eaaj10 with SMTP id j10so825520eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 11:52:14 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: extract revision and TX power IDs from SPROM
Date: Mon, 12 Dec 2011 21:33:12 +0100
Message-Id: <1323721992-3941-1-git-send-email-zajec5@gmail.com> (sfid-20111212_205219_822267_D94AF3CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index b6c474b..6f230fb 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -129,6 +129,9 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	u16 v;
 	int i;
 
+	bus->sprom.revision = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] &
+		SSB_SPROM_REVISION_REV;
+
 	for (i = 0; i < 3; i++) {
 		v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
 		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
@@ -136,6 +139,42 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 
 	bus->sprom.board_rev = sprom[SPOFF(SSB_SPROM8_BOARDREV)];
 
+	bus->sprom.txpid2g[0] = (sprom[SPOFF(SSB_SPROM4_TXPID2G01)] &
+	     SSB_SPROM4_TXPID2G0) >> SSB_SPROM4_TXPID2G0_SHIFT;
+	bus->sprom.txpid2g[1] = (sprom[SPOFF(SSB_SPROM4_TXPID2G01)] &
+	     SSB_SPROM4_TXPID2G1) >> SSB_SPROM4_TXPID2G1_SHIFT;
+	bus->sprom.txpid2g[2] = (sprom[SPOFF(SSB_SPROM4_TXPID2G23)] &
+	     SSB_SPROM4_TXPID2G2) >> SSB_SPROM4_TXPID2G2_SHIFT;
+	bus->sprom.txpid2g[3] = (sprom[SPOFF(SSB_SPROM4_TXPID2G23)] &
+	     SSB_SPROM4_TXPID2G3) >> SSB_SPROM4_TXPID2G3_SHIFT;
+
+	bus->sprom.txpid5gl[0] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL01)] &
+	     SSB_SPROM4_TXPID5GL0) >> SSB_SPROM4_TXPID5GL0_SHIFT;
+	bus->sprom.txpid5gl[1] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL01)] &
+	     SSB_SPROM4_TXPID5GL1) >> SSB_SPROM4_TXPID5GL1_SHIFT;
+	bus->sprom.txpid5gl[2] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL23)] &
+	     SSB_SPROM4_TXPID5GL2) >> SSB_SPROM4_TXPID5GL2_SHIFT;
+	bus->sprom.txpid5gl[3] = (sprom[SPOFF(SSB_SPROM4_TXPID5GL23)] &
+	     SSB_SPROM4_TXPID5GL3) >> SSB_SPROM4_TXPID5GL3_SHIFT;
+
+	bus->sprom.txpid5g[0] = (sprom[SPOFF(SSB_SPROM4_TXPID5G01)] &
+	     SSB_SPROM4_TXPID5G0) >> SSB_SPROM4_TXPID5G0_SHIFT;
+	bus->sprom.txpid5g[1] = (sprom[SPOFF(SSB_SPROM4_TXPID5G01)] &
+	     SSB_SPROM4_TXPID5G1) >> SSB_SPROM4_TXPID5G1_SHIFT;
+	bus->sprom.txpid5g[2] = (sprom[SPOFF(SSB_SPROM4_TXPID5G23)] &
+	     SSB_SPROM4_TXPID5G2) >> SSB_SPROM4_TXPID5G2_SHIFT;
+	bus->sprom.txpid5g[3] = (sprom[SPOFF(SSB_SPROM4_TXPID5G23)] &
+	     SSB_SPROM4_TXPID5G3) >> SSB_SPROM4_TXPID5G3_SHIFT;
+
+	bus->sprom.txpid5gh[0] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH01)] &
+	     SSB_SPROM4_TXPID5GH0) >> SSB_SPROM4_TXPID5GH0_SHIFT;
+	bus->sprom.txpid5gh[1] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH01)] &
+	     SSB_SPROM4_TXPID5GH1) >> SSB_SPROM4_TXPID5GH1_SHIFT;
+	bus->sprom.txpid5gh[2] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH23)] &
+	     SSB_SPROM4_TXPID5GH2) >> SSB_SPROM4_TXPID5GH2_SHIFT;
+	bus->sprom.txpid5gh[3] = (sprom[SPOFF(SSB_SPROM4_TXPID5GH23)] &
+	     SSB_SPROM4_TXPID5GH3) >> SSB_SPROM4_TXPID5GH3_SHIFT;
+
 	bus->sprom.boardflags_lo = sprom[SPOFF(SSB_SPROM8_BFLLO)];
 	bus->sprom.boardflags_hi = sprom[SPOFF(SSB_SPROM8_BFLHI)];
 	bus->sprom.boardflags2_lo = sprom[SPOFF(SSB_SPROM8_BFL2LO)];
-- 
1.7.3.4

