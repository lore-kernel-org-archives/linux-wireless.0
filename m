Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49538 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab3CUP03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 11:26:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: fix sprom constant for ant_available_{bg,a}
Date: Thu, 21 Mar 2013 16:26:19 +0100
Message-Id: <1363879579-7027-1-git-send-email-hauke@hauke-m.de> (sfid-20130321_162635_227230_004CB686)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was done accordingly to new specs.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/ssb/ssb_regs.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 6ecfa02..3a72569 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -289,11 +289,11 @@
 #define  SSB_SPROM4_ETHPHY_ET1A_SHIFT	5
 #define  SSB_SPROM4_ETHPHY_ET0M		(1<<14)	/* MDIO for enet0 */
 #define  SSB_SPROM4_ETHPHY_ET1M		(1<<15)	/* MDIO for enet1 */
-#define SSB_SPROM4_ANTAVAIL		0x005D  /* Antenna available bitfields */
-#define  SSB_SPROM4_ANTAVAIL_A		0x00FF	/* A-PHY bitfield */
-#define  SSB_SPROM4_ANTAVAIL_A_SHIFT	0
-#define  SSB_SPROM4_ANTAVAIL_BG		0xFF00	/* B-PHY and G-PHY bitfield */
-#define  SSB_SPROM4_ANTAVAIL_BG_SHIFT	8
+#define SSB_SPROM4_ANTAVAIL		0x005C  /* Antenna available bitfields */
+#define  SSB_SPROM4_ANTAVAIL_BG		0x00FF	/* B-PHY and G-PHY bitfield */
+#define  SSB_SPROM4_ANTAVAIL_BG_SHIFT	0
+#define  SSB_SPROM4_ANTAVAIL_A		0xFF00	/* A-PHY bitfield */
+#define  SSB_SPROM4_ANTAVAIL_A_SHIFT	8
 #define SSB_SPROM4_AGAIN01		0x005E	/* Antenna Gain (in dBm Q5.2) */
 #define  SSB_SPROM4_AGAIN0		0x00FF	/* Antenna 0 */
 #define  SSB_SPROM4_AGAIN0_SHIFT	0
-- 
1.7.10.4

