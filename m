Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44620 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab2D2AF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:05:28 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/8] bcma: read out some additional sprom attributes
Date: Sun, 29 Apr 2012 02:04:12 +0200
Message-Id: <1335657853-23925-8-git-send-email-hauke@hauke-m.de> (sfid-20120429_020532_654219_4D5413E5)
In-Reply-To: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code is copied from the ssb sprom read code. These attributes are
partly used by b43 and brcmsmac and should also be read out on bcma
based devices.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/sprom.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 1799372..22c9968 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -181,6 +181,10 @@ static int bcma_sprom_valid(const u16 *sprom)
 #define SPEX(_field, _offset, _mask, _shift)	\
 	bus->sprom._field = ((sprom[SPOFF(_offset)] & (_mask)) >> (_shift))
 
+#define SPEX32(_field, _offset, _mask, _shift)	\
+	bus->sprom._field = ((((u32)sprom[SPOFF((_offset)+2)] << 16 | \
+				sprom[SPOFF(_offset)]) & (_mask)) >> (_shift))
+
 static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 {
 	u16 v, o;
@@ -299,6 +303,78 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	     SSB_SROM8_FEM_TR_ISO_SHIFT);
 	SPEX(fem.ghz5.antswlut, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_ANTSWLUT,
 	     SSB_SROM8_FEM_ANTSWLUT_SHIFT);
+
+	SPEX(ant_available_a, SSB_SPROM8_ANTAVAIL, SSB_SPROM8_ANTAVAIL_A,
+	     SSB_SPROM8_ANTAVAIL_A_SHIFT);
+	SPEX(ant_available_bg, SSB_SPROM8_ANTAVAIL, SSB_SPROM8_ANTAVAIL_BG,
+	     SSB_SPROM8_ANTAVAIL_BG_SHIFT);
+	SPEX(maxpwr_bg, SSB_SPROM8_MAXP_BG, SSB_SPROM8_MAXP_BG_MASK, 0);
+	SPEX(itssi_bg, SSB_SPROM8_MAXP_BG, SSB_SPROM8_ITSSI_BG,
+	     SSB_SPROM8_ITSSI_BG_SHIFT);
+	SPEX(maxpwr_a, SSB_SPROM8_MAXP_A, SSB_SPROM8_MAXP_A_MASK, 0);
+	SPEX(itssi_a, SSB_SPROM8_MAXP_A, SSB_SPROM8_ITSSI_A,
+	     SSB_SPROM8_ITSSI_A_SHIFT);
+	SPEX(maxpwr_ah, SSB_SPROM8_MAXP_AHL, SSB_SPROM8_MAXP_AH_MASK, 0);
+	SPEX(maxpwr_al, SSB_SPROM8_MAXP_AHL, SSB_SPROM8_MAXP_AL_MASK,
+	     SSB_SPROM8_MAXP_AL_SHIFT);
+	SPEX(gpio0, SSB_SPROM8_GPIOA, SSB_SPROM8_GPIOA_P0, 0);
+	SPEX(gpio1, SSB_SPROM8_GPIOA, SSB_SPROM8_GPIOA_P1,
+	     SSB_SPROM8_GPIOA_P1_SHIFT);
+	SPEX(gpio2, SSB_SPROM8_GPIOB, SSB_SPROM8_GPIOB_P2, 0);
+	SPEX(gpio3, SSB_SPROM8_GPIOB, SSB_SPROM8_GPIOB_P3,
+	     SSB_SPROM8_GPIOB_P3_SHIFT);
+	SPEX(tri2g, SSB_SPROM8_TRI25G, SSB_SPROM8_TRI2G, 0);
+	SPEX(tri5g, SSB_SPROM8_TRI25G, SSB_SPROM8_TRI5G,
+	     SSB_SPROM8_TRI5G_SHIFT);
+	SPEX(tri5gl, SSB_SPROM8_TRI5GHL, SSB_SPROM8_TRI5GL, 0);
+	SPEX(tri5gh, SSB_SPROM8_TRI5GHL, SSB_SPROM8_TRI5GH,
+	     SSB_SPROM8_TRI5GH_SHIFT);
+	SPEX(rxpo2g, SSB_SPROM8_RXPO, SSB_SPROM8_RXPO2G,
+	     SSB_SPROM8_RXPO2G_SHIFT);
+	SPEX(rxpo5g, SSB_SPROM8_RXPO, SSB_SPROM8_RXPO5G,
+	     SSB_SPROM8_RXPO5G_SHIFT);
+	SPEX(rssismf2g, SSB_SPROM8_RSSIPARM2G, SSB_SPROM8_RSSISMF2G, 0);
+	SPEX(rssismc2g, SSB_SPROM8_RSSIPARM2G, SSB_SPROM8_RSSISMC2G,
+	     SSB_SPROM8_RSSISMC2G_SHIFT);
+	SPEX(rssisav2g, SSB_SPROM8_RSSIPARM2G, SSB_SPROM8_RSSISAV2G,
+	     SSB_SPROM8_RSSISAV2G_SHIFT);
+	SPEX(bxa2g, SSB_SPROM8_RSSIPARM2G, SSB_SPROM8_BXA2G,
+	     SSB_SPROM8_BXA2G_SHIFT);
+	SPEX(rssismf5g, SSB_SPROM8_RSSIPARM5G, SSB_SPROM8_RSSISMF5G, 0);
+	SPEX(rssismc5g, SSB_SPROM8_RSSIPARM5G, SSB_SPROM8_RSSISMC5G,
+	     SSB_SPROM8_RSSISMC5G_SHIFT);
+	SPEX(rssisav5g, SSB_SPROM8_RSSIPARM5G, SSB_SPROM8_RSSISAV5G,
+	     SSB_SPROM8_RSSISAV5G_SHIFT);
+	SPEX(bxa5g, SSB_SPROM8_RSSIPARM5G, SSB_SPROM8_BXA5G,
+	     SSB_SPROM8_BXA5G_SHIFT);
+
+	SPEX(pa0b0, SSB_SPROM8_PA0B0, ~0, 0);
+	SPEX(pa0b1, SSB_SPROM8_PA0B1, ~0, 0);
+	SPEX(pa0b2, SSB_SPROM8_PA0B2, ~0, 0);
+	SPEX(pa1b0, SSB_SPROM8_PA1B0, ~0, 0);
+	SPEX(pa1b1, SSB_SPROM8_PA1B1, ~0, 0);
+	SPEX(pa1b2, SSB_SPROM8_PA1B2, ~0, 0);
+	SPEX(pa1lob0, SSB_SPROM8_PA1LOB0, ~0, 0);
+	SPEX(pa1lob1, SSB_SPROM8_PA1LOB1, ~0, 0);
+	SPEX(pa1lob2, SSB_SPROM8_PA1LOB2, ~0, 0);
+	SPEX(pa1hib0, SSB_SPROM8_PA1HIB0, ~0, 0);
+	SPEX(pa1hib1, SSB_SPROM8_PA1HIB1, ~0, 0);
+	SPEX(pa1hib2, SSB_SPROM8_PA1HIB2, ~0, 0);
+	SPEX(cck2gpo, SSB_SPROM8_CCK2GPO, ~0, 0);
+	SPEX32(ofdm2gpo, SSB_SPROM8_OFDM2GPO, ~0, 0);
+	SPEX32(ofdm5glpo, SSB_SPROM8_OFDM5GLPO, ~0, 0);
+	SPEX32(ofdm5gpo, SSB_SPROM8_OFDM5GPO, ~0, 0);
+	SPEX32(ofdm5ghpo, SSB_SPROM8_OFDM5GHPO, ~0, 0);
+
+	/* Extract the antenna gain values. */
+	SPEX(antenna_gain.a0, SSB_SPROM8_AGAIN01,
+	     SSB_SPROM8_AGAIN0, SSB_SPROM8_AGAIN0_SHIFT);
+	SPEX(antenna_gain.a1, SSB_SPROM8_AGAIN01,
+	     SSB_SPROM8_AGAIN1, SSB_SPROM8_AGAIN1_SHIFT);
+	SPEX(antenna_gain.a2, SSB_SPROM8_AGAIN23,
+	     SSB_SPROM8_AGAIN2, SSB_SPROM8_AGAIN2_SHIFT);
+	SPEX(antenna_gain.a3, SSB_SPROM8_AGAIN23,
+	     SSB_SPROM8_AGAIN3, SSB_SPROM8_AGAIN3_SHIFT);
 }
 
 /*
-- 
1.7.9.5

