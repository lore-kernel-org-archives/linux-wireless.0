Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62654 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab0ANWnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 17:43:06 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so56513fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 14:43:05 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 23:43:04 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 3/6] b43: N-PHY: add update TX cal ladder
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6jn12l09lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c       |   23 +++++++++++++++++
  drivers/net/wireless/b43/phy_n.h       |    1 +
  drivers/net/wireless/b43/tables_nphy.c |   42 ++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.h |    6 ++++
  4 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 77be96d..67717c1 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -686,6 +686,29 @@ static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
  	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW3, array[3]);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/UpdateTxCalLadder */
+static void b43_nphy_update_tx_cal_ladder(struct b43_wldev *dev, u16 core)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	int i;
+	u16 scale, entry;
+
+	u16 tmp = nphy->txcal_bbmult;
+	if (core == 0)
+		tmp >>= 8;
+	tmp &= 0xff;
+
+	for (i = 0; i < 18; i++) {
+		scale = (ladder_lo[i].percent * tmp) / 100;
+		entry = ((scale & 0xFF) << 8) | ladder_lo[i].g_env;
+		//TODO: Write an N PHY Table with ID 15, length 1, offset i, width 16, and data entry
+
+		scale = (ladder_iq[i].percent * tmp) / 100;
+		entry = ((scale & 0xFF) << 8) | ladder_iq[i].g_env;
+		//TODO: Write an N PHY Table with ID 15, length 1, offset i + 32, width 16, and data entry
+	}
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIqRev2 */
  static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  			struct nphy_txgains target, u8 type, bool debug)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index d435720..a5f3a94 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -972,6 +972,7 @@ struct b43_phy_n {
  	u8 mphase_cal_phase_id;
  	u8 antsel_type;
  	u16 tx_rx_cal_radio_saveregs[22];
+	u16 txcal_bbmult;
  	u16 papd_epsilon_offset[2];
  	u32 deaf_count;
  	u32 rxcalparams;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index de8a609..4816b70 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2746,6 +2746,48 @@ const u16 tbl_iqcal_gainparams[2][9][8] = {
  	}
  };

+const struct nphy_txiqcal_ladder ladder_lo[] = {
+	{ 3, 0 },
+	{ 4, 0 },
+	{ 6, 0 },
+	{ 9, 0 },
+	{ 13, 0 },
+	{ 18, 0 },
+	{ 25, 0 },
+	{ 25, 1 },
+	{ 25, 2 },
+	{ 25, 3 },
+	{ 25, 4 },
+	{ 25, 5 },
+	{ 25, 6 },
+	{ 25, 7 },
+	{ 35, 7 },
+	{ 50, 7 },
+	{ 71, 7 },
+	{ 100, 7 }
+};
+
+const struct nphy_txiqcal_ladder ladder_iq[] = {
+	{ 3, 0 },
+	{ 4, 0 },
+	{ 6, 0 },
+	{ 9, 0 },
+	{ 13, 0 },
+	{ 18, 0 },
+	{ 25, 0 },
+	{ 35, 0 },
+	{ 50, 0 },
+	{ 71, 0 },
+	{ 100, 0 },
+	{ 100, 1 },
+	{ 100, 2 },
+	{ 100, 3 },
+	{ 100, 4 },
+	{ 100, 5 },
+	{ 100, 6 },
+	{ 100, 7 }
+};
+
  static inline void assert_ntab_array_sizes(void)
  {
  #undef check
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 86c394c..b5e0e4b 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -43,6 +43,10 @@ struct b43_nphy_channeltab_entry {
  	u16 unk2;
  };

+struct nphy_txiqcal_ladder {
+	u8 percent;
+	u8 g_env;
+};

  struct b43_wldev;

@@ -142,5 +146,7 @@ extern const u32 txpwrctrl_tx_gain_ipa_rev5[];
  extern const u32 txpwrctrl_tx_gain_ipa_rev6[];
  extern const u32 txpwrctrl_tx_gain_ipa_5g[];
  extern const u16 tbl_iqcal_gainparams[2][9][8];
+extern const struct nphy_txiqcal_ladder ladder_lo[];
+extern const struct nphy_txiqcal_ladder ladder_iq[];

  #endif /* B43_TABLES_NPHY_H_ */
-- 
1.6.4.2

