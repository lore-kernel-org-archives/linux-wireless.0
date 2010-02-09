Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:42996 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0BIUEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:04:30 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1670038eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 12:04:29 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 01/11] b43: N-PHY: add some registers and structs definitions
Date: Tue,  9 Feb 2010 21:04:33 +0100
Message-Id: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h         |    1 +
 drivers/net/wireless/b43/phy_n.h       |    9 +++++++++
 drivers/net/wireless/b43/tables_nphy.h |    9 +++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 6a6ab0f..bd7c505 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -104,6 +104,7 @@
 #define B43_MMIO_MACFILTER_CONTROL	0x420
 #define B43_MMIO_MACFILTER_DATA		0x422
 #define B43_MMIO_RCMTA_COUNT		0x43C
+#define B43_MMIO_PSM_PHY_HDR		0x492	/* programmable state machine */
 #define B43_MMIO_RADIO_HWENABLED_LO	0x49A
 #define B43_MMIO_GPIO_CONTROL		0x49C
 #define B43_MMIO_GPIO_MASK		0x49E
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 403aad3..47d20dc 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -711,6 +711,8 @@
 #define B43_NPHY_PAPD_EN1			B43_PHY_N(0x29B) /* PAPD Enable1 TBD */
 #define B43_NPHY_EPS_TABLE_ADJ1			B43_PHY_N(0x29C) /* EPS Table Adj1 TBD */
 
+#define B43_PHY_B_BBCFG				B43_PHY_N_BMODE(0x001) /* BB config */
+#define B43_PHY_B_TEST				B43_PHY_N_BMODE(0x00A)
 
 
 /* Broadcom 2055 radio registers */
@@ -924,6 +926,13 @@
 
 struct b43_wldev;
 
+struct b43_chanspec {
+	u8 channel;
+	u8 sideband;
+	u8 b_width;
+	u8 b_freq;
+};
+
 struct b43_phy_n_iq_comp {
 	s16 a0;
 	s16 b0;
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 9c1c6ec..b23036f 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -4,6 +4,15 @@
 #include <linux/types.h>
 
 
+struct b43_phy_n_sfo_cfg {
+	u16 phy_bw1a;
+	u16 phy_bw2;
+	u16 phy_bw3;
+	u16 phy_bw4;
+	u16 phy_bw5;
+	u16 phy_bw6;
+};
+
 struct b43_nphy_channeltab_entry {
 	/* The channel number */
 	u8 channel;
-- 
1.6.4.2

