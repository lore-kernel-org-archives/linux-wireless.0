Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52245 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab2B0X51 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:57:27 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 02/11] ssb: remove 5GHz antenna gain from sprom
Date: Tue, 28 Feb 2012 00:56:05 +0100
Message-Id: <1330386974-4056-3-git-send-email-hauke@hauke-m.de> (sfid-20120228_005730_743788_16491180)
In-Reply-To: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
References: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no 2.4 GHz or 5GHz antenna gain stored in sprom. The sprom
just stores the gain values for antenna 1 and 2 or 1 to 4 for more
recent sprom versions. On old devices antenna 2 was used for 5 GHz wifi.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43legacy/phy.c |    2 +-
 drivers/ssb/pci.c                    |   41 +++++++++++----------------------
 drivers/ssb/pcmcia.c                 |   12 +++------
 drivers/ssb/sdio.c                   |   12 +++------
 include/linux/ssb/ssb.h              |    7 +-----
 5 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/phy.c b/drivers/net/wireless/b43legacy/phy.c
index 96faaef..9503341 100644
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -1860,7 +1860,7 @@ void b43legacy_phy_xmitpower(struct b43legacy_wldev *dev)
 	 * which accounts for the factor of 4 */
 #define REG_MAX_PWR 20
 	max_pwr = min(REG_MAX_PWR * 4
-		      - dev->dev->bus->sprom.antenna_gain.ghz24.a0
+		      - dev->dev->bus->sprom.antenna_gain.a0
 		      - 0x6, max_pwr);
 
 	/* find the desired power in Q5.2 - power_level is in dBm
diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index befa89e..ed41244 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -331,7 +331,6 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 {
 	int i;
 	u16 v;
-	s8 gain;
 	u16 loc[3];
 
 	if (out->revision == 3)			/* rev 3 moved MAC */
@@ -390,20 +389,12 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 		SPEX(boardflags_hi, SSB_SPROM2_BFLHI, 0xFFFF, 0);
 
 	/* Extract the antenna gain values. */
-	gain = r123_extract_antgain(out->revision, in,
-				    SSB_SPROM1_AGAIN_BG,
-				    SSB_SPROM1_AGAIN_BG_SHIFT);
-	out->antenna_gain.ghz24.a0 = gain;
-	out->antenna_gain.ghz24.a1 = gain;
-	out->antenna_gain.ghz24.a2 = gain;
-	out->antenna_gain.ghz24.a3 = gain;
-	gain = r123_extract_antgain(out->revision, in,
-				    SSB_SPROM1_AGAIN_A,
-				    SSB_SPROM1_AGAIN_A_SHIFT);
-	out->antenna_gain.ghz5.a0 = gain;
-	out->antenna_gain.ghz5.a1 = gain;
-	out->antenna_gain.ghz5.a2 = gain;
-	out->antenna_gain.ghz5.a3 = gain;
+	out->antenna_gain.a0 = r123_extract_antgain(out->revision, in,
+						    SSB_SPROM1_AGAIN_BG,
+						    SSB_SPROM1_AGAIN_BG_SHIFT);
+	out->antenna_gain.a1 = r123_extract_antgain(out->revision, in,
+						    SSB_SPROM1_AGAIN_A,
+						    SSB_SPROM1_AGAIN_A_SHIFT);
 }
 
 /* Revs 4 5 and 8 have partially shared layout */
@@ -504,16 +495,14 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 	}
 
 	/* Extract the antenna gain values. */
-	SPEX(antenna_gain.ghz24.a0, SSB_SPROM4_AGAIN01,
+	SPEX(antenna_gain.a0, SSB_SPROM4_AGAIN01,
 	     SSB_SPROM4_AGAIN0, SSB_SPROM4_AGAIN0_SHIFT);
-	SPEX(antenna_gain.ghz24.a1, SSB_SPROM4_AGAIN01,
+	SPEX(antenna_gain.a1, SSB_SPROM4_AGAIN01,
 	     SSB_SPROM4_AGAIN1, SSB_SPROM4_AGAIN1_SHIFT);
-	SPEX(antenna_gain.ghz24.a2, SSB_SPROM4_AGAIN23,
+	SPEX(antenna_gain.a2, SSB_SPROM4_AGAIN23,
 	     SSB_SPROM4_AGAIN2, SSB_SPROM4_AGAIN2_SHIFT);
-	SPEX(antenna_gain.ghz24.a3, SSB_SPROM4_AGAIN23,
+	SPEX(antenna_gain.a3, SSB_SPROM4_AGAIN23,
 	     SSB_SPROM4_AGAIN3, SSB_SPROM4_AGAIN3_SHIFT);
-	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
-	       sizeof(out->antenna_gain.ghz5));
 
 	sprom_extract_r458(out, in);
 
@@ -602,16 +591,14 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 	SPEX32(ofdm5ghpo, SSB_SPROM8_OFDM5GHPO, 0xFFFFFFFF, 0);
 
 	/* Extract the antenna gain values. */
-	SPEX(antenna_gain.ghz24.a0, SSB_SPROM8_AGAIN01,
+	SPEX(antenna_gain.a0, SSB_SPROM8_AGAIN01,
 	     SSB_SPROM8_AGAIN0, SSB_SPROM8_AGAIN0_SHIFT);
-	SPEX(antenna_gain.ghz24.a1, SSB_SPROM8_AGAIN01,
+	SPEX(antenna_gain.a1, SSB_SPROM8_AGAIN01,
 	     SSB_SPROM8_AGAIN1, SSB_SPROM8_AGAIN1_SHIFT);
-	SPEX(antenna_gain.ghz24.a2, SSB_SPROM8_AGAIN23,
+	SPEX(antenna_gain.a2, SSB_SPROM8_AGAIN23,
 	     SSB_SPROM8_AGAIN2, SSB_SPROM8_AGAIN2_SHIFT);
-	SPEX(antenna_gain.ghz24.a3, SSB_SPROM8_AGAIN23,
+	SPEX(antenna_gain.a3, SSB_SPROM8_AGAIN23,
 	     SSB_SPROM8_AGAIN3, SSB_SPROM8_AGAIN3_SHIFT);
-	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
-	       sizeof(out->antenna_gain.ghz5));
 
 	/* Extract cores power info info */
 	for (i = 0; i < ARRAY_SIZE(pwr_info_offset); i++) {
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index c821c6b..fbafed5 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -676,14 +676,10 @@ static int ssb_pcmcia_do_get_invariants(struct pcmcia_device *p_dev,
 	case SSB_PCMCIA_CIS_ANTGAIN:
 		GOTO_ERROR_ON(tuple->TupleDataLen != 2,
 			"antg tpl size");
-		sprom->antenna_gain.ghz24.a0 = tuple->TupleData[1];
-		sprom->antenna_gain.ghz24.a1 = tuple->TupleData[1];
-		sprom->antenna_gain.ghz24.a2 = tuple->TupleData[1];
-		sprom->antenna_gain.ghz24.a3 = tuple->TupleData[1];
-		sprom->antenna_gain.ghz5.a0 = tuple->TupleData[1];
-		sprom->antenna_gain.ghz5.a1 = tuple->TupleData[1];
-		sprom->antenna_gain.ghz5.a2 = tuple->TupleData[1];
-		sprom->antenna_gain.ghz5.a3 = tuple->TupleData[1];
+		sprom->antenna_gain.a0 = tuple->TupleData[1];
+		sprom->antenna_gain.a1 = tuple->TupleData[1];
+		sprom->antenna_gain.a2 = tuple->TupleData[1];
+		sprom->antenna_gain.a3 = tuple->TupleData[1];
 		break;
 	case SSB_PCMCIA_CIS_BFLAGS:
 		GOTO_ERROR_ON((tuple->TupleDataLen != 3) &&
diff --git a/drivers/ssb/sdio.c b/drivers/ssb/sdio.c
index 63fd709..b2d36f7 100644
--- a/drivers/ssb/sdio.c
+++ b/drivers/ssb/sdio.c
@@ -551,14 +551,10 @@ int ssb_sdio_get_invariants(struct ssb_bus *bus,
 			case SSB_SDIO_CIS_ANTGAIN:
 				GOTO_ERROR_ON(tuple->size != 2,
 					      "antg tpl size");
-				sprom->antenna_gain.ghz24.a0 = tuple->data[1];
-				sprom->antenna_gain.ghz24.a1 = tuple->data[1];
-				sprom->antenna_gain.ghz24.a2 = tuple->data[1];
-				sprom->antenna_gain.ghz24.a3 = tuple->data[1];
-				sprom->antenna_gain.ghz5.a0 = tuple->data[1];
-				sprom->antenna_gain.ghz5.a1 = tuple->data[1];
-				sprom->antenna_gain.ghz5.a2 = tuple->data[1];
-				sprom->antenna_gain.ghz5.a3 = tuple->data[1];
+				sprom->antenna_gain.a0 = tuple->data[1];
+				sprom->antenna_gain.a1 = tuple->data[1];
+				sprom->antenna_gain.a2 = tuple->data[1];
+				sprom->antenna_gain.a3 = tuple->data[1];
 				break;
 			case SSB_SDIO_CIS_BFLAGS:
 				GOTO_ERROR_ON((tuple->size != 3) &&
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index f169621..1de5675 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -94,12 +94,7 @@ struct ssb_sprom {
 	 * on each band. Values in dBm/4 (Q5.2). Negative gain means the
 	 * loss in the connectors is bigger than the gain. */
 	struct {
-		struct {
-			s8 a0, a1, a2, a3;
-		} ghz24;	/* 2.4GHz band */
-		struct {
-			s8 a0, a1, a2, a3;
-		} ghz5;		/* 5GHz band */
+		s8 a0, a1, a2, a3;
 	} antenna_gain;
 
 	struct {
-- 
1.7.5.4

