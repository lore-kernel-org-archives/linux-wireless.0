Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:34101 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaGOO4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 10:56:15 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so5647332wes.26
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 07:56:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: extract antenna gains from SPROM correctly
Date: Tue, 15 Jul 2014 16:54:47 +0200
Message-Id: <1405436087-17695-1-git-send-email-zajec5@gmail.com> (sfid-20140715_165618_456549_D6E7252A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just like in case of SSB SPROMs they are encoded in a bit tricky way.
SPROM struct already uses s8 type and it's supposed to store decoded
values.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c                           | 41 +++++++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 37 -----------------------
 2 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 72bf454..a9dfb1a 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -201,6 +201,23 @@ static int bcma_sprom_valid(struct bcma_bus *bus, const u16 *sprom,
 		SPEX(_field[7], _offset + 14, _mask, _shift);	\
 	} while (0)
 
+static s8 sprom_extract_antgain(const u16 *in, u16 offset, u16 mask, u16 shift)
+{
+	u16 v;
+	u8 gain;
+
+	v = in[SPOFF(offset)];
+	gain = (v & mask) >> shift;
+	if (gain == 0xFF) {
+		gain = 8; /* If unset use 2dBm */
+	} else {
+		/* Q5.2 Fractional part is stored in 0xC0 */
+		gain = ((gain & 0xC0) >> 6) | ((gain & 0x3F) << 2);
+	}
+
+	return (s8)gain;
+}
+
 static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 {
 	u16 v, o;
@@ -381,14 +398,22 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	SPEX32(ofdm5ghpo, SSB_SPROM8_OFDM5GHPO, ~0, 0);
 
 	/* Extract the antenna gain values. */
-	SPEX(antenna_gain.a0, SSB_SPROM8_AGAIN01,
-	     SSB_SPROM8_AGAIN0, SSB_SPROM8_AGAIN0_SHIFT);
-	SPEX(antenna_gain.a1, SSB_SPROM8_AGAIN01,
-	     SSB_SPROM8_AGAIN1, SSB_SPROM8_AGAIN1_SHIFT);
-	SPEX(antenna_gain.a2, SSB_SPROM8_AGAIN23,
-	     SSB_SPROM8_AGAIN2, SSB_SPROM8_AGAIN2_SHIFT);
-	SPEX(antenna_gain.a3, SSB_SPROM8_AGAIN23,
-	     SSB_SPROM8_AGAIN3, SSB_SPROM8_AGAIN3_SHIFT);
+	bus->sprom.antenna_gain.a0 = sprom_extract_antgain(sprom,
+							   SSB_SPROM8_AGAIN01,
+							   SSB_SPROM8_AGAIN0,
+							   SSB_SPROM8_AGAIN0_SHIFT);
+	bus->sprom.antenna_gain.a1 = sprom_extract_antgain(sprom,
+							   SSB_SPROM8_AGAIN01,
+							   SSB_SPROM8_AGAIN1,
+							   SSB_SPROM8_AGAIN1_SHIFT);
+	bus->sprom.antenna_gain.a2 = sprom_extract_antgain(sprom,
+							   SSB_SPROM8_AGAIN23,
+							   SSB_SPROM8_AGAIN2,
+							   SSB_SPROM8_AGAIN2_SHIFT);
+	bus->sprom.antenna_gain.a3 = sprom_extract_antgain(sprom,
+							   SSB_SPROM8_AGAIN23,
+							   SSB_SPROM8_AGAIN3,
+							   SSB_SPROM8_AGAIN3_SHIFT);
 
 	SPEX(leddc_on_time, SSB_SPROM8_LEDDC, SSB_SPROM8_LEDDC_ON,
 	     SSB_SPROM8_LEDDC_ON_SHIFT);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index af8ba64..1b47482 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4707,41 +4707,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	return err;
 }
 
-static void brcms_c_attach_antgain_init(struct brcms_c_info *wlc)
-{
-	uint unit;
-	unit = wlc->pub->unit;
-
-	if ((wlc->band->antgain == -1) && (wlc->pub->sromrev == 1)) {
-		/* default antenna gain for srom rev 1 is 2 dBm (8 qdbm) */
-		wlc->band->antgain = 8;
-	} else if (wlc->band->antgain == -1) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
-			  " srom, using 2dB\n", unit, __func__);
-		wlc->band->antgain = 8;
-	} else {
-		s8 gain, fract;
-		/* Older sroms specified gain in whole dbm only.  In order
-		 * be able to specify qdbm granularity and remain backward
-		 * compatible the whole dbms are now encoded in only
-		 * low 6 bits and remaining qdbms are encoded in the hi 2 bits.
-		 * 6 bit signed number ranges from -32 - 31.
-		 *
-		 * Examples:
-		 * 0x1 = 1 db,
-		 * 0xc1 = 1.75 db (1 + 3 quarters),
-		 * 0x3f = -1 (-1 + 0 quarters),
-		 * 0x7f = -.75 (-1 + 1 quarters) = -3 qdbm.
-		 * 0xbf = -.50 (-1 + 2 quarters) = -2 qdbm.
-		 */
-		gain = wlc->band->antgain & 0x3f;
-		gain <<= 2;	/* Sign extend */
-		gain >>= 2;
-		fract = (wlc->band->antgain & 0xc0) >> 6;
-		wlc->band->antgain = 4 * gain + fract;
-	}
-}
-
 static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 {
 	int aa;
@@ -4780,8 +4745,6 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 	else
 		wlc->band->antgain = sprom->antenna_gain.a0;
 
-	brcms_c_attach_antgain_init(wlc);
-
 	return true;
 }
 
-- 
1.8.4.5

