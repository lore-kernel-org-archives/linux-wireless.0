Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63652 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1LUXGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 18:06:08 -0500
Received: by eekc4 with SMTP id c4so7959769eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 15:06:07 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] b43: add lacking boardflags defines
Date: Thu, 22 Dec 2011 00:47:16 +0100
Message-Id: <1324511239-3536-1-git-send-email-zajec5@gmail.com> (sfid-20111222_000612_583964_E08227D6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index f19605e..16e8f80 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -191,6 +191,9 @@
 #define B43_BFH_BUCKBOOST		0x0020	/* has buck/booster */
 #define B43_BFH_FEM_BT			0x0040	/* has FEM and switch to share antenna
 						 * with bluetooth */
+#define B43_BFH_NOCBUCK			0x0080
+#define B43_BFH_PALDO			0x0200
+#define B43_BFH_EXTLNA_5GHZ		0x1000	/* has an external LNA (5GHz mode) */
 
 /* SPROM boardflags2_lo values */
 #define B43_BFL2_RXBB_INT_REG_DIS	0x0001	/* external RX BB regulator present */
@@ -204,6 +207,14 @@
 #define B43_BFL2_SKWRKFEM_BRD		0x0100	/* 4321mcm93 uses Skyworks FEM */
 #define B43_BFL2_SPUR_WAR		0x0200	/* has a workaround for clock-harmonic spurs */
 #define B43_BFL2_GPLL_WAR		0x0400	/* altenative G-band PLL settings implemented */
+#define B43_BFL2_SINGLEANT_CCK		0x1000
+#define B43_BFL2_2G_SPUR_WAR		0x2000
+
+/* SPROM boardflags2_hi values */
+#define B43_BFH2_GPLL_WAR2		0x0001
+#define B43_BFH2_IPALVLSHIFT_3P3	0x0002
+#define B43_BFH2_INTERNDET_TXIQCAL	0x0004
+#define B43_BFH2_XTALBUFOUTEN		0x0008
 
 /* GPIO register offset, in both ChipCommon and PCI core. */
 #define B43_GPIO_CONTROL		0x6c
-- 
1.7.3.4

