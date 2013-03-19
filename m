Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45104 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab3CSP7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 11:59:08 -0400
Received: by mail-ea0-f169.google.com with SMTP id z7so314657eaf.14
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 08:59:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: define more board types
Date: Tue, 19 Mar 2013 16:58:58 +0100
Message-Id: <1363708739-25721-1-git-send-email-zajec5@gmail.com> (sfid-20130319_165914_637560_55BCD240)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/ssb/ssb.h |   54 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 8b13222..c64999f 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -340,13 +340,61 @@ enum ssb_bustype {
 #define SSB_BOARDVENDOR_DELL	0x1028	/* Dell */
 #define SSB_BOARDVENDOR_HP	0x0E11	/* HP */
 /* board_type */
+#define SSB_BOARD_BCM94301CB	0x0406
+#define SSB_BOARD_BCM94301MP	0x0407
+#define SSB_BOARD_BU4309	0x040A
+#define SSB_BOARD_BCM94309CB	0x040B
+#define SSB_BOARD_BCM4309MP	0x040C
+#define SSB_BOARD_BU4306	0x0416
 #define SSB_BOARD_BCM94306MP	0x0418
 #define SSB_BOARD_BCM4309G	0x0421
 #define SSB_BOARD_BCM4306CB	0x0417
-#define SSB_BOARD_BCM4309MP	0x040C
+#define SSB_BOARD_BCM94306PC	0x0425	/* pcmcia 3.3v 4306 card */
+#define SSB_BOARD_BCM94306CBSG	0x042B	/* with SiGe PA */
+#define SSB_BOARD_PCSG94306	0x042D	/* with SiGe PA */
+#define SSB_BOARD_BU4704SD	0x042E	/* with sdram */
+#define SSB_BOARD_BCM94704AGR	0x042F	/* dual 11a/11g Router */
+#define SSB_BOARD_BCM94308MP	0x0430	/* 11a-only minipci */
+#define SSB_BOARD_BU4318	0x0447
+#define SSB_BOARD_CB4318	0x0448
+#define SSB_BOARD_MPG4318	0x0449
 #define SSB_BOARD_MP4318	0x044A
-#define SSB_BOARD_BU4306	0x0416
-#define SSB_BOARD_BU4309	0x040A
+#define SSB_BOARD_SD4318	0x044B
+#define SSB_BOARD_BCM94306P	0x044C	/* with SiGe */
+#define SSB_BOARD_BCM94303MP	0x044E
+#define SSB_BOARD_BCM94306MPM	0x0450
+#define SSB_BOARD_BCM94306MPL	0x0453
+#define SSB_BOARD_PC4303	0x0454	/* pcmcia */
+#define SSB_BOARD_BCM94306MPLNA	0x0457
+#define SSB_BOARD_BCM94306MPH	0x045B
+#define SSB_BOARD_BCM94306PCIV	0x045C
+#define SSB_BOARD_BCM94318MPGH	0x0463
+#define SSB_BOARD_BU4311	0x0464
+#define SSB_BOARD_BCM94311MC	0x0465
+#define SSB_BOARD_BCM94311MCAG	0x0466
+/* 4321 boards */
+#define SSB_BOARD_BU4321	0x046B
+#define SSB_BOARD_BU4321E	0x047C
+#define SSB_BOARD_MP4321	0x046C
+#define SSB_BOARD_CB2_4321	0x046D
+#define SSB_BOARD_CB2_4321_AG	0x0066
+#define SSB_BOARD_MC4321	0x046E
+/* 4325 boards */
+#define SSB_BOARD_BCM94325DEVBU	0x0490
+#define SSB_BOARD_BCM94325BGABU	0x0491
+#define SSB_BOARD_BCM94325SDGWB	0x0492
+#define SSB_BOARD_BCM94325SDGMDL	0x04AA
+#define SSB_BOARD_BCM94325SDGMDL2	0x04C6
+#define SSB_BOARD_BCM94325SDGMDL3	0x04C9
+#define SSB_BOARD_BCM94325SDABGWBA	0x04E1
+/* 4322 boards */
+#define SSB_BOARD_BCM94322MC	0x04A4
+#define SSB_BOARD_BCM94322USB	0x04A8	/* dualband */
+#define SSB_BOARD_BCM94322HM	0x04B0
+#define SSB_BOARD_BCM94322USB2D	0x04Bf	/* single band discrete front end */
+/* 4312 boards */
+#define SSB_BOARD_BU4312	0x048A
+#define SSB_BOARD_BCM4312MCGSG	0x04B5
 /* chip_package */
 #define SSB_CHIPPACK_BCM4712S	1	/* Small 200pin 4712 */
 #define SSB_CHIPPACK_BCM4712M	2	/* Medium 225pin 4712 */
-- 
1.7.10.4

