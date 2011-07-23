Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38846 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GWIba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 04:31:30 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so6327489fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 01:31:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: define boardflags
Date: Sat, 23 Jul 2011 11:10:11 +0200
Message-Id: <1311412213-3825-2-git-send-email-zajec5@gmail.com> (sfid-20110723_103134_025216_50BC8792)
In-Reply-To: <1311412213-3825-1-git-send-email-zajec5@gmail.com>
References: <1311412213-3825-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are SPROM specific, so all should be defined in ssb code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/ssb/ssb_regs.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index efbf459..9894120 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -462,6 +462,46 @@
 #define SSB_SPROM8_OFDM5GLPO		0x014A	/* 5.2GHz OFDM power offset */
 #define SSB_SPROM8_OFDM5GHPO		0x014E	/* 5.8GHz OFDM power offset */
 
+/* Values for boardflags_lo read from SPROM */
+#define SSB_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
+#define SSB_BFL_PACTRL			0x0002	/* GPIO 9 controlling the PA */
+#define SSB_BFL_AIRLINEMODE		0x0004	/* implements GPIO 13 radio disable indication */
+#define SSB_BFL_RSSI			0x0008	/* software calculates nrssi slope. */
+#define SSB_BFL_ENETSPI			0x0010	/* has ephy roboswitch spi */
+#define SSB_BFL_XTAL_NOSLOW		0x0020	/* no slow clock available */
+#define SSB_BFL_CCKHIPWR		0x0040	/* can do high power CCK transmission */
+#define SSB_BFL_ENETADM			0x0080	/* has ADMtek switch */
+#define SSB_BFL_ENETVLAN		0x0100	/* can do vlan */
+#define SSB_BFL_AFTERBURNER		0x0200	/* supports Afterburner mode */
+#define SSB_BFL_NOPCI			0x0400	/* board leaves PCI floating */
+#define SSB_BFL_FEM			0x0800	/* supports the Front End Module */
+#define SSB_BFL_EXTLNA			0x1000	/* has an external LNA */
+#define SSB_BFL_HGPA			0x2000	/* had high gain PA */
+#define SSB_BFL_BTCMOD			0x4000	/* BFL_BTCOEXIST is given in alternate GPIOs */
+#define SSB_BFL_ALTIQ			0x8000	/* alternate I/Q settings */
+
+/* Values for boardflags_hi read from SPROM */
+#define SSB_BFH_NOPA			0x0001	/* has no PA */
+#define SSB_BFH_RSSIINV			0x0002	/* RSSI uses positive slope (not TSSI) */
+#define SSB_BFH_PAREF			0x0004	/* uses the PARef LDO */
+#define SSB_BFH_3TSWITCH		0x0008	/* uses a triple throw switch shared with bluetooth */
+#define SSB_BFH_PHASESHIFT		0x0010	/* can support phase shifter */
+#define SSB_BFH_BUCKBOOST		0x0020	/* has buck/booster */
+#define SSB_BFH_FEM_BT			0x0040	/* has FEM and switch to share antenna with bluetooth */
+
+/* Values for boardflags2_lo read from SPROM */
+#define SSB_BFL2_RXBB_INT_REG_DIS	0x0001	/* external RX BB regulator present */
+#define SSB_BFL2_APLL_WAR		0x0002	/* alternative A-band PLL settings implemented */
+#define SSB_BFL2_TXPWRCTRL_EN 		0x0004	/* permits enabling TX Power Control */
+#define SSB_BFL2_2X4_DIV		0x0008	/* 2x4 diversity switch */
+#define SSB_BFL2_5G_PWRGAIN		0x0010	/* supports 5G band power gain */
+#define SSB_BFL2_PCIEWAR_OVR		0x0020	/* overrides ASPM and Clkreq settings */
+#define SSB_BFL2_CAESERS_BRD		0x0040	/* is Caesers board (unused) */
+#define SSB_BFL2_BTC3WIRE		0x0080	/* used 3-wire bluetooth coexist */
+#define SSB_BFL2_SKWRKFEM_BRD		0x0100	/* 4321mcm93 uses Skyworks FEM */
+#define SSB_BFL2_SPUR_WAR		0x0200	/* has a workaround for clock-harmonic spurs */
+#define SSB_BFL2_GPLL_WAR		0x0400	/* altenative G-band PLL settings implemented */
+
 /* Values for SSB_SPROM1_BINF_CCODE */
 enum {
 	SSB_SPROM1CCODE_WORLD = 0,
-- 
1.7.3.4

