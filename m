Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58830 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1BHWc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 17:32:26 -0500
Received: by ewy5 with SMTP id 5so3340342ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 14:32:25 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: extract boardflags2 for SPROMs rev 4 and 5
Date: Tue,  8 Feb 2011 23:32:17 +0100
Message-Id: <1297204337-7932-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pci.c            |    4 ++++
 include/linux/ssb/ssb_regs.h |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 158449e..5b33b3b 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -468,10 +468,14 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 		SPEX(country_code, SSB_SPROM4_CCODE, 0xFFFF, 0);
 		SPEX(boardflags_lo, SSB_SPROM4_BFLLO, 0xFFFF, 0);
 		SPEX(boardflags_hi, SSB_SPROM4_BFLHI, 0xFFFF, 0);
+		SPEX(boardflags2_lo, SSB_SPROM4_BFL2LO, 0xFFFF, 0);
+		SPEX(boardflags2_hi, SSB_SPROM4_BFL2HI, 0xFFFF, 0);
 	} else {
 		SPEX(country_code, SSB_SPROM5_CCODE, 0xFFFF, 0);
 		SPEX(boardflags_lo, SSB_SPROM5_BFLLO, 0xFFFF, 0);
 		SPEX(boardflags_hi, SSB_SPROM5_BFLHI, 0xFFFF, 0);
+		SPEX(boardflags2_lo, SSB_SPROM5_BFL2LO, 0xFFFF, 0);
+		SPEX(boardflags2_hi, SSB_SPROM5_BFL2HI, 0xFFFF, 0);
 	}
 	SPEX(ant_available_a, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_A,
 	     SSB_SPROM4_ANTAVAIL_A_SHIFT);
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 489f7b6..df9211a 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -268,6 +268,8 @@
 /* SPROM Revision 4 */
 #define SSB_SPROM4_BFLLO		0x0044	/* Boardflags (low 16 bits) */
 #define SSB_SPROM4_BFLHI		0x0046  /* Board Flags Hi */
+#define SSB_SPROM4_BFL2LO		0x0048	/* Board flags 2 (low 16 bits) */
+#define SSB_SPROM4_BFL2HI		0x004A	/* Board flags 2 Hi */
 #define SSB_SPROM4_IL0MAC		0x004C	/* 6 byte MAC address for a/b/g/n */
 #define SSB_SPROM4_CCODE		0x0052	/* Country Code (2 bytes) */
 #define SSB_SPROM4_GPIOA		0x0056	/* Gen. Purpose IO # 0 and 1 */
@@ -358,6 +360,8 @@
 #define SSB_SPROM5_CCODE		0x0044	/* Country Code (2 bytes) */
 #define SSB_SPROM5_BFLLO		0x004A	/* Boardflags (low 16 bits) */
 #define SSB_SPROM5_BFLHI		0x004C  /* Board Flags Hi */
+#define SSB_SPROM5_BFL2LO		0x004E	/* Board flags 2 (low 16 bits) */
+#define SSB_SPROM5_BFL2HI		0x0050	/* Board flags 2 Hi */
 #define SSB_SPROM5_IL0MAC		0x0052	/* 6 byte MAC address for a/b/g/n */
 #define SSB_SPROM5_GPIOA		0x0076	/* Gen. Purpose IO # 0 and 1 */
 #define  SSB_SPROM5_GPIOA_P0		0x00FF	/* Pin 0 */
-- 
1.7.1

