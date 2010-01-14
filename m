Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62654 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab0ANWnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 17:43:31 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so56513fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 14:43:31 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 23:43:27 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 6/6] b43: N-PHY: add huge cal TX IQ LO
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6jn2p0e9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c       |  214 +++++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/phy_n.h       |    9 ++
  drivers/net/wireless/b43/tables_nphy.c |   60 +++++++++
  drivers/net/wireless/b43/tables_nphy.h |   24 ++++
  4 files changed, 301 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 356b89f..d7eeed0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1033,6 +1033,207 @@ static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalTxIqlo */
+static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
+				struct nphy_txgains target,
+				bool full, bool mphase)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	int i;
+	int error = 0;
+	int freq;
+	bool avoid = false;
+	u8 length;
+	u16 tmp, core, type, count, max, numb, last, cmd;
+	const u16 *table;
+	bool phy6or5x;
+
+	u16 buffer[11];
+	u16 diq_start = 0;
+	u16 save[2];
+	u16 gain[2];
+	struct nphy_iqcal_params params[2];
+	bool updated[2] = { };
+
+	b43_nphy_stay_in_carrier_search(dev, true);
+
+	if (dev->phy.rev >= 4) {
+		avoid = nphy->hang_avoid;
+		nphy->hang_avoid = 0;
+	}
+
+	//TODO: Read an N PHY Table with ID 7, length 2, offset 0x110, width 16, and data pointer save
+
+	for (i = 0; i < 2; i++) {
+		b43_nphy_iq_cal_gain_params(dev, i, target, &params[i]);
+		gain[i] = params[i].cal_gain;
+	}
+	//TODO: Write an N PHY Table with ID 7, length 2, offset 0x110, width 16, and data pointer gain
+
+	b43_nphy_tx_cal_radio_setup(dev);
+	//TODO: Call N PHY TX Cal PHY Setup
+
+	phy6or5x = dev->phy.rev >= 6 ||
+		(dev->phy.rev == 5 && nphy->ipa2g_on &&
+		b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ);
+	if (phy6or5x) {
+		/* TODO */
+	}
+
+	b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);
+
+	if (1 /*FIXME: the band width is 20 MHz*/)
+		freq = 2500;
+	else
+		freq = 5000;
+
+	if (nphy->mphase_cal_phase_id > 2)
+		;//TODO: Call N PHY Run Samples with (band width * 8), 0xFFFF, 0, 1, 0 as arguments
+	else
+		;//TODO: Call N PHY TX Tone with freq, 250, 1, 0 as arguments and save result as error
+
+	if (error == 0) {
+		if (nphy->mphase_cal_phase_id > 2) {
+			table = nphy->mphase_txcal_bestcoeffs;
+			length = 11;
+			if (dev->phy.rev < 3)
+				length -= 2;
+		} else {
+			if (!full && nphy->txiqlocal_coeffsvalid) {
+				table = nphy->txiqlocal_bestc;
+				length = 11;
+				if (dev->phy.rev < 3)
+					length -= 2;
+			} else {
+				full = true;
+				if (dev->phy.rev >= 3) {
+					table = tbl_tx_iqlo_cal_startcoefs_nphyrev3;
+					length = B43_NTAB_TX_IQLO_CAL_STARTCOEFS_REV3;
+				} else {
+					table = tbl_tx_iqlo_cal_startcoefs;
+					length = B43_NTAB_TX_IQLO_CAL_STARTCOEFS;
+				}
+			}
+		}
+
+		//TODO: Write an N PHY Table with ID 15, length from above, offset 64, width 16, and the data pointer from above
+
+		if (full) {
+			if (dev->phy.rev >= 3)
+				max = B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL_REV3;
+			else
+				max = B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL;
+		} else {
+			if (dev->phy.rev >= 3)
+				max = B43_NTAB_TX_IQLO_CAL_CMDS_RECAL_REV3;
+			else
+				max = B43_NTAB_TX_IQLO_CAL_CMDS_RECAL;
+		}
+
+		if (mphase) {
+			count = nphy->mphase_txcal_cmdidx;
+			numb = min(max,
+				(u16)(count + nphy->mphase_txcal_numcmds));
+		} else {
+			count = 0;
+			numb = max;
+		}
+
+		for (; count < numb; count++) {
+			if (full) {
+				if (dev->phy.rev >= 3)
+					cmd = tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[count];
+				else
+					cmd = tbl_tx_iqlo_cal_cmds_fullcal[count];
+			} else {
+				if (dev->phy.rev >= 3)
+					cmd = tbl_tx_iqlo_cal_cmds_recal_nphyrev3[count];
+				else
+					cmd = tbl_tx_iqlo_cal_cmds_recal[count];
+			}
+
+			core = (cmd & 0x3000) >> 12;
+			type = (cmd & 0x0F00) >> 8;
+
+			if (phy6or5x && updated[core] == 0) {
+				b43_nphy_update_tx_cal_ladder(dev, core);
+				updated[core] = 1;
+			}
+
+			tmp = (params[core].ncorr[type] << 8) | 0x66;
+			b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDNNUM, tmp);
+
+			if (type == 1 || type == 3 || type == 4) {
+				//TODO: Read an N PHY Table with ID 15, length 1, offset 69 + core, width 16, and data pointer buffer
+				diq_start = buffer[0];
+				buffer[0] = 0;
+				//TODO: Write an N PHY Table with ID 15, length 1, offset 69 + core, width 16, and data of 0
+			}
+
+			b43_phy_write(dev, B43_NPHY_IQLOCAL_CMD, cmd);
+			for (i = 0; i < 2000; i++) {
+				tmp = b43_phy_read(dev, B43_NPHY_IQLOCAL_CMD);
+				if (tmp & 0xC000)
+					break;
+				udelay(10);
+			}
+
+			//TODO: Read an N PHY Table with ID 15, length table_length, offset 96, width 16, and data pointer buffer
+			//TODO: Write an N PHY Table with ID 15, length table_length, offset 64, width 16, and data pointer buffer
+
+			if (type == 1 || type == 3 || type == 4)
+				buffer[0] = diq_start;
+		}
+
+		if (mphase)
+			nphy->mphase_txcal_cmdidx = (numb >= max) ? 0 : numb;
+
+		last = (dev->phy.rev < 3) ? 6 : 7;
+
+		if (!mphase || nphy->mphase_cal_phase_id == last) {
+			//TODO: Write an N PHY Table with ID 15, length 4, offset 96, width 16, and data pointer buffer
+			//TODO: Read an N PHY Table with ID 15, length 4, offset 80, width 16, and data pointer buffer
+			if (dev->phy.rev < 3) {
+				buffer[0] = 0;
+				buffer[1] = 0;
+				buffer[2] = 0;
+				buffer[3] = 0;
+			}
+			//TODO: Write an N PHY Table with ID 15, length 4, offset 88, width 16, and data pointer buffer
+			//TODO: Read an N PHY Table with ID 15, length 2, offset 101, width 16, and data pointer buffer
+			//TODO: Write an N PHY Table with ID 15, length 2, offset 85, width 16, and data pointer buffer
+			//TODO: Write an N PHY Table with ID 15, length 2, offset 93, width 16, and data pointer buffer
+			length = 11;
+			if (dev->phy.rev < 3)
+				length -= 2;
+			//TODO: Read an N PHY Table with ID 15, length length, offset 96, width 16, and data pointer nphy->txiqlocal_bestc
+			nphy->txiqlocal_coeffsvalid = true;
+			//TODO: Set nphy->txiqlocal_chanspec to the current channel
+		} else {
+			length = 11;
+			if (dev->phy.rev < 3)
+				length -= 2;
+			//TODO: Read an N PHY Table with ID 5, length length, offset 96, width 16, and data pointer nphy->mphase_txcal_bestcoeffs
+		}
+
+		//TODO: Call N PHY Stop Playback
+		b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0);
+	}
+
+	//TODO: Call N PHY TX Cal PHY Cleanup
+	//TODO: Write an N PHY Table with ID 7, length 2, offset 0x110, width 16, and data from save
+
+	if (dev->phy.rev < 2 && (!mphase || nphy->mphase_cal_phase_id == last))
+		b43_nphy_tx_iq_workaround(dev);
+
+	if (dev->phy.rev >= 4)
+		nphy->hang_avoid = avoid;
+
+	b43_nphy_stay_in_carrier_search(dev, false);
+
+	return error;
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
  static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
  {
@@ -1685,7 +1886,9 @@ int b43_phy_initn(struct b43_wldev *dev)
  	struct ssb_bus *bus = dev->dev->bus;
  	struct b43_phy *phy = &dev->phy;
  	struct b43_phy_n *nphy = phy->n;
+
  	u8 tx_pwr_state;
+	struct nphy_txgains target;
  	u16 tmp;
  	enum ieee80211_band tmp2;
  	bool do_rssi_cal;
@@ -1827,8 +2030,7 @@ int b43_phy_initn(struct b43_wldev *dev)
  			do_cal = false;

  		if (do_cal) {
-			struct nphy_txgains target =
-				b43_nphy_get_tx_gains(dev);
+			target = b43_nphy_get_tx_gains(dev);

  			if (nphy->antsel_type == 2)
  				;//TODO N PHY Superswitch Init with argument 1
@@ -1846,14 +2048,14 @@ int b43_phy_initn(struct b43_wldev *dev)
  		}
  	}

-	/* TODO: If the output of N PHY Cal TX Iqlo with target, 1 0 as arguments is 0 {
+	if (!b43_nphy_cal_tx_iq_lo(dev, target, true, false)) {
  		if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
-			Call N PHY Save Cal
+			;//TODO: Call N PHY Save Cal
  		else if (nphy->mphase_cal_phase_id == 0)
-			//TODO: N PHY Periodic Calibration with argument 3
+			;//TODO: N PHY Periodic Calibration with argument 3
  	} else {
  		b43_nphy_restore_cal(dev);
-	} */
+	}

  	b43_nphy_tx_pwr_ctrl_coef_setup(dev);
  	//TODO N PHY TX Power Control Enable with argument tx_pwr_state
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index a5f3a94..121050b 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -969,10 +969,19 @@ struct b43_phy_n {
  	u8 measure_hold;
  	u8 phyrxchain;
  	u8 perical;
+
  	u8 mphase_cal_phase_id;
+	u16 mphase_txcal_cmdidx;
+	u16 mphase_txcal_numcmds;
+	u16 mphase_txcal_bestcoeffs[11];
+
  	u8 antsel_type;
+
  	u16 tx_rx_cal_radio_saveregs[22];
  	u16 txcal_bbmult;
+	u16 txiqlocal_bestc[11];
+	bool txiqlocal_coeffsvalid;
+
  	u16 papd_epsilon_offset[2];
  	u32 deaf_count;
  	u32 rxcalparams;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index d9291cf..7dff853 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2823,6 +2823,66 @@ const u16 loscale[] = {
  	962, 1019, 1019, 256
  };

+const u16 tbl_tx_iqlo_cal_loft_ladder_40[] = {
+	0x0200, 0x0300, 0x0400, 0x0700,
+	0x0900, 0x0c00, 0x1200, 0x1201,
+	0x1202, 0x1203, 0x1204, 0x1205,
+	0x1206, 0x1207, 0x1907, 0x2307,
+	0x3207, 0x4707
+};
+
+const u16 tbl_tx_iqlo_cal_loft_ladder_20[] = {
+	0x0300, 0x0500, 0x0700, 0x0900,
+	0x0d00, 0x1100, 0x1900, 0x1901,
+	0x1902, 0x1903, 0x1904, 0x1905,
+	0x1906, 0x1907, 0x2407, 0x3207,
+	0x4607, 0x6407
+};
+
+const u16 tbl_tx_iqlo_cal_iqimb_ladder_40[] = {
+	0x0100, 0x0200, 0x0400, 0x0700,
+	0x0900, 0x0c00, 0x1200, 0x1900,
+	0x2300, 0x3200, 0x4700, 0x4701,
+	0x4702, 0x4703, 0x4704, 0x4705,
+	0x4706, 0x4707
+};
+
+const u16 tbl_tx_iqlo_cal_iqimb_ladder_20[] = {
+	0x0200, 0x0300, 0x0600, 0x0900,
+	0x0d00, 0x1100, 0x1900, 0x2400,
+	0x3200, 0x4600, 0x6400, 0x6401,
+	0x6402, 0x6403, 0x6404, 0x6405,
+	0x6406, 0x6407
+};
+
+const u16 tbl_tx_iqlo_cal_startcoefs_nphyrev3[B43_NTAB_TX_IQLO_CAL_STARTCOEFS_REV3] = { };
+
+const u16 tbl_tx_iqlo_cal_startcoefs[B43_NTAB_TX_IQLO_CAL_STARTCOEFS] = { };
+
+const u16 tbl_tx_iqlo_cal_cmds_recal_nphyrev3[] = {
+	0x8423, 0x8323, 0x8073, 0x8256,
+	0x8045, 0x8223, 0x9423, 0x9323,
+	0x9073, 0x9256, 0x9045, 0x9223
+};
+
+const u16 tbl_tx_iqlo_cal_cmds_recal[] = {
+	0x8101, 0x8253, 0x8053, 0x8234,
+	0x8034, 0x9101, 0x9253, 0x9053,
+	0x9234, 0x9034
+};
+
+const u16 tbl_tx_iqlo_cal_cmds_fullcal[] = {
+	0x8123, 0x8264, 0x8086, 0x8245,
+	0x8056, 0x9123, 0x9264, 0x9086,
+	0x9245, 0x9056
+};
+
+const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
+	0x8434, 0x8334, 0x8084, 0x8267,
+	0x8056, 0x8234, 0x9434, 0x9334,
+	0x9084, 0x9267, 0x9056, 0x9234
+};
+
  static inline void assert_ntab_array_sizes(void)
  {
  #undef check
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 4a3d666..e359d9b 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -130,6 +130,19 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8 channel);
  #define B43_NTAB_C1_LOFEEDTH		B43_NTAB16(0x1B, 0x1C0) /* Local Oscillator Feed Through Lookup Table Core 1 */
  #define B43_NTAB_C1_LOFEEDTH_SIZE	128

+#define B43_NTAB_TX_IQLO_CAL_LOFT_LADDER_40_SIZE	18
+#define B43_NTAB_TX_IQLO_CAL_LOFT_LADDER_20_SIZE	18
+#define B43_NTAB_TX_IQLO_CAL_IQIMB_LADDER_40_SIZE	18
+#define B43_NTAB_TX_IQLO_CAL_IQIMB_LADDER_20_SIZE	18
+#define B43_NTAB_TX_IQLO_CAL_STARTCOEFS_REV3		11
+#define B43_NTAB_TX_IQLO_CAL_STARTCOEFS			9
+#define B43_NTAB_TX_IQLO_CAL_CMDS_RECAL_REV3		12
+#define B43_NTAB_TX_IQLO_CAL_CMDS_RECAL			10
+#define B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL		10
+#define B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL_REV3		12
+
+
+
  void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value);

  void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev);
@@ -150,4 +163,15 @@ extern const struct nphy_txiqcal_ladder ladder_lo[];
  extern const struct nphy_txiqcal_ladder ladder_iq[];
  extern const u16 loscale[];

+extern const u16 tbl_tx_iqlo_cal_loft_ladder_40[];
+extern const u16 tbl_tx_iqlo_cal_loft_ladder_20[];
+extern const u16 tbl_tx_iqlo_cal_iqimb_ladder_40[];
+extern const u16 tbl_tx_iqlo_cal_iqimb_ladder_20[];
+extern const u16 tbl_tx_iqlo_cal_startcoefs_nphyrev3[];
+extern const u16 tbl_tx_iqlo_cal_startcoefs[];
+extern const u16 tbl_tx_iqlo_cal_cmds_recal_nphyrev3[];
+extern const u16 tbl_tx_iqlo_cal_cmds_recal[];
+extern const u16 tbl_tx_iqlo_cal_cmds_fullcal[];
+extern const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[];
+
  #endif /* B43_TABLES_NPHY_H_ */
-- 
1.6.4.2

