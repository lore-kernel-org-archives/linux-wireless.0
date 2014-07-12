Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62590 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaGLOmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 10:42:21 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so2261642wgh.13
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 07:42:19 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: make code for antenna gain extraction more generic
Date: Sat, 12 Jul 2014 16:42:09 +0200
Message-Id: <1405176130-15908-1-git-send-email-zajec5@gmail.com> (sfid-20140712_164245_236315_74018062)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pci.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index a8dc95e..ca973d1 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -326,13 +326,13 @@ err_ctlreg:
 	return err;
 }
 
-static s8 r123_extract_antgain(u8 sprom_revision, const u16 *in,
-			       u16 mask, u16 shift)
+static s8 sprom_extract_antgain(u8 sprom_revision, const u16 *in, u16 offset,
+				u16 mask, u16 shift)
 {
 	u16 v;
 	u8 gain;
 
-	v = in[SPOFF(SSB_SPROM1_AGAIN)];
+	v = in[SPOFF(offset)];
 	gain = (v & mask) >> shift;
 	if (gain == 0xFF)
 		gain = 2; /* If unset use 2dBm */
@@ -416,12 +416,14 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 	SPEX(alpha2[1], SSB_SPROM1_CCODE, 0x00ff, 0);
 
 	/* Extract the antenna gain values. */
-	out->antenna_gain.a0 = r123_extract_antgain(out->revision, in,
-						    SSB_SPROM1_AGAIN_BG,
-						    SSB_SPROM1_AGAIN_BG_SHIFT);
-	out->antenna_gain.a1 = r123_extract_antgain(out->revision, in,
-						    SSB_SPROM1_AGAIN_A,
-						    SSB_SPROM1_AGAIN_A_SHIFT);
+	out->antenna_gain.a0 = sprom_extract_antgain(out->revision, in,
+						     SSB_SPROM1_AGAIN,
+						     SSB_SPROM1_AGAIN_BG,
+						     SSB_SPROM1_AGAIN_BG_SHIFT);
+	out->antenna_gain.a1 = sprom_extract_antgain(out->revision, in,
+						     SSB_SPROM1_AGAIN,
+						     SSB_SPROM1_AGAIN_A,
+						     SSB_SPROM1_AGAIN_A_SHIFT);
 	if (out->revision >= 2)
 		sprom_extract_r23(out, in);
 }
-- 
1.8.4.5

