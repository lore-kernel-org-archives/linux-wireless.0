Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62654 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0ANWnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 17:43:16 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so56513fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 14:43:15 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 23:43:14 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 4/6] b43: N-PHY: TX power control coeff setup
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6jn2cb19lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/b43.h         |    3 +
  drivers/net/wireless/b43/phy_n.c       |   68 +++++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/tables_nphy.c |   35 ++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.h |    1 +
  4 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index d5c67a6..964ddd4 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -260,6 +260,9 @@ enum {
  #define B43_SHM_SH_NPHY_TXIQW1		0x0702
  #define B43_SHM_SH_NPHY_TXIQW2		0x0704
  #define B43_SHM_SH_NPHY_TXIQW3		0x0706
+/* SHM_SHARED tx pwr ctrl */
+#define B43_SHM_SH_NPHY_TXPWR_INDX0	0x0708
+#define B43_SHM_SH_NPHY_TXPWR_INDX1	0x070E

  /* SHM_SCRATCH offsets */
  #define B43_SHM_SC_MINCONT		0x0003	/* Minimum contention window */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 67717c1..d5a2dc8 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -709,6 +709,72 @@ static void b43_nphy_update_tx_cal_ladder(struct b43_wldev *dev, u16 core)
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
+static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	int i, j;
+	u32 tmp;
+	u32 cur_real, cur_imag, real_part, imag_part;
+
+	u16 buffer[7];
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, true);
+
+	//TODO: Read an N PHY Table with ID 15, length 7, offset 80, width 16, and data pointer buffer
+	
+	for (i = 0; i < 2; i++) {
+		tmp = ((buffer[i * 2] & 0x3FF) << 10) |
+			(buffer[i * 2 + 1] & 0x3FF);
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
+				(((i + 26) << 10) | 320));
+		for (j = 0; j < 128; j++) {
+			b43_phy_write(dev, B43_NPHY_TABLE_DATAHI,
+					((tmp >> 16) & 0xFFFF));
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(tmp & 0xFFFF));
+		}
+	}
+
+	for (i = 0; i < 2; i++) {
+		tmp = buffer[5 + i];
+		real_part = (tmp >> 8) & 0xFF;
+		imag_part = (tmp & 0xFF);
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
+				(((i + 26) << 10) | 448));
+
+		if (dev->phy.rev >= 3) {
+			cur_real = real_part;
+			cur_imag = imag_part;
+			tmp = ((cur_real & 0xFF) << 8) | (cur_imag & 0xFF);
+		}
+
+		for (j = 0; j < 128; j++) {
+			if (dev->phy.rev < 3) {
+				cur_real = (real_part * loscale[j] + 128) >> 8;
+				cur_imag = (imag_part * loscale[j] + 128) >> 8;
+				tmp = ((cur_real & 0xFF) << 8) |
+					(cur_imag & 0xFF);
+			}
+			b43_phy_write(dev, B43_NPHY_TABLE_DATAHI,
+					((tmp >> 16) & 0xFFFF));
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(tmp & 0xFFFF));
+		}
+	}
+
+	if (dev->phy.rev >= 3) {
+		b43_shm_write16(dev, B43_SHM_SHARED,
+				B43_SHM_SH_NPHY_TXPWR_INDX0, 0xFFFF);
+		b43_shm_write16(dev, B43_SHM_SHARED,
+				B43_SHM_SH_NPHY_TXPWR_INDX1, 0xFFFF);
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, false);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIqRev2 */
  static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  			struct nphy_txgains target, u8 type, bool debug)
@@ -1787,7 +1853,7 @@ int b43_phy_initn(struct b43_wldev *dev)
  		}
  	}

-	//TODO N PHY TX Power Control Coef Setup
+	b43_nphy_tx_pwr_ctrl_coef_setup(dev);
  	//TODO N PHY TX Power Control Enable with argument tx_pwr_state
  	b43_phy_write(dev, B43_NPHY_TXMACIF_HOLDOFF, 0x0015);
  	b43_phy_write(dev, B43_NPHY_TXMACDELAY, 0x0320);
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 4816b70..d9291cf 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2788,6 +2788,41 @@ const struct nphy_txiqcal_ladder ladder_iq[] = {
  	{ 100, 7 }
  };

+const u16 loscale[] = {
+	256, 256, 271, 271,
+	287, 256, 256, 271,
+	271, 287, 287, 304,
+	304, 256, 256, 271,
+	271, 287, 287, 304,
+	304, 322, 322, 341,
+	341, 362, 362, 383,
+	383, 256, 256, 271,
+	271, 287, 287, 304,
+	304, 322, 322, 256,
+	256, 271, 271, 287,
+	287, 304, 304, 322,
+	322, 341, 341, 362,
+	362, 256, 256, 271,
+	271, 287, 287, 304,
+	304, 322, 322, 256,
+	256, 271, 271, 287,
+	287, 304, 304, 322,
+	322, 341, 341, 362,
+	362, 256, 256, 271,
+	271, 287, 287, 304,
+	304, 322, 322, 341,
+	341, 362, 362, 383,
+	383, 406, 406, 430,
+	430, 455, 455, 482,
+	482, 511, 511, 541,
+	541, 573, 573, 607,
+	607, 643, 643, 681,
+	681, 722, 722, 764,
+	764, 810, 810, 858,
+	858, 908, 908, 962,
+	962, 1019, 1019, 256
+};
+
  static inline void assert_ntab_array_sizes(void)
  {
  #undef check
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index b5e0e4b..4a3d666 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -148,5 +148,6 @@ extern const u32 txpwrctrl_tx_gain_ipa_5g[];
  extern const u16 tbl_iqcal_gainparams[2][9][8];
  extern const struct nphy_txiqcal_ladder ladder_lo[];
  extern const struct nphy_txiqcal_ladder ladder_iq[];
+extern const u16 loscale[];

  #endif /* B43_TABLES_NPHY_H_ */
-- 
1.6.4.2

