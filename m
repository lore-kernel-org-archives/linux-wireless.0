Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:55979 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754395AbbCFXAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 18:00:01 -0500
Message-ID: <1425682797.12017.58.camel@perches.com> (sfid-20150307_000007_685056_904537C7)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Fri, 06 Mar 2015 14:59:57 -0800
In-Reply-To: <1425680126-25928-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1425680126-25928-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-03-06 at 17:15 -0500, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
> from scratch utilizing the mac80211 stack.
> 
> After spending months cleaning up the vendor provided rtl8723au
> driver, which comes with it's own 802.11 stack included, I decided to
> rewrite this driver from the bottom up.
> 
> Many thanks to Johannes Berg for 802.11 insights and help and Larry
> Finger for help with the vendor driver.

cool.

I hope it can be fairly modular so that it can be
extensible to support multiple devices more sensibly
than the realtek code.

btw:  Here are some trivial checkpatch cleanups.

There are a few places where it seems there are
missing braces because indentation changes occur.

see:
@@ -1245,11 +1242,11 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
@@ -2540,10 +2534,10 @@ void rtl8xxxu_set_ampdu_factor(struct rtl8xxxu_priv *priv, u8 ampdu_factor)

and

+++ b/drivers/net/wireless/rtl8xxxu.h
[]
 struct rtl8723au_idx {
-#if defined (__LITTLE_ENDIAN)
+#if defined(__LITTLE_ENDIAN)
 	int	a:4;
 	int	b:4;
-#elif defined (__LITTLE_ENDIAN)
+#elif defined(__LITTLE_ENDIAN)
 	int	b:4;
 	int	a:4;

Presumably the second should be __BIG_ENDIAN.

---
 drivers/net/wireless/rtl8xxxu.c      | 124 ++++++++++++++++-------------------
 drivers/net/wireless/rtl8xxxu.h      |   9 ++-
 drivers/net/wireless/rtl8xxxu_regs.h |  22 ++-----
 3 files changed, 69 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/rtl8xxxu.c b/drivers/net/wireless/rtl8xxxu.c
index 6728a74..af1c44d 100644
--- a/drivers/net/wireless/rtl8xxxu.c
+++ b/drivers/net/wireless/rtl8xxxu.c
@@ -677,8 +677,8 @@ static int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c)
 			pr_debug("H2C_EXT %04x\n", le16_to_cpu(h2c->raw.ext));
 	}
 	rtl8723au_write32(priv, mbox_reg, le32_to_cpu(h2c->raw.data));
-		if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
-			pr_debug("H2C %08x\n", le16_to_cpu(h2c->raw.data));
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
+		pr_debug("H2C %08x\n", le16_to_cpu(h2c->raw.data));
 
 	priv->next_mbox = (mbox_nr + 1) % H2C_MAX_MBOX;
 
@@ -757,7 +757,6 @@ static void rtl8723a_disable_rf(struct rtl8xxxu_priv *priv)
 	rtl8723au_write8(priv, REG_SPS0_CTRL, sps0);
 }
 
-
 static void rtl8723a_stop_tx_beacon(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -774,7 +773,6 @@ static void rtl8723a_stop_tx_beacon(struct rtl8xxxu_priv *priv)
 	rtl8723au_write8(priv, REG_TBTT_PROHIBIT + 2, val8);
 }
 
-
 /*
  * The rtl8723a has 3 channel groups for it's efuse settings. It only
  * supports the 2.4GHz band, so channels 1 - 14:
@@ -834,9 +832,9 @@ static void rtl8723au_config_channel(struct ieee80211_hw *hw)
 		rtl8723au_write32(priv, REG_FPGA0_ANALOG2, val32);
 		break;
 	case NL80211_CHAN_WIDTH_40:
-                if (hw->conf.chandef.center_freq1 >
+		if (hw->conf.chandef.center_freq1 >
 		    hw->conf.chandef.chan->center_freq)
-                        sec_ch_above = 1;
+			sec_ch_above = 1;
 		else
 			sec_ch_above = 0;
 
@@ -935,8 +933,7 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	}
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_CHANNEL)
-		pr_debug("%s: Setting TX power CCK A: %02x, "
-			 "CCK B: %02x, OFDM A: %02x, OFDM B: %02x\n",
+		pr_debug("%s: Setting TX power CCK A: %02x, CCK B: %02x, OFDM A: %02x, OFDM B: %02x\n",
 			 DRIVER_NAME, cck[0], cck[1], ofdm[0], ofdm[1]);
 
 	for (i = 0; i < RTL8723A_MAX_RF_PATHS; i++) {
@@ -977,9 +974,9 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 		mcsbase[1] += efuse->ht20_tx_power_index_diff[group].b;
 
 	ofdm_a = ofdmbase[0] | ofdmbase[0] << 8 |
-		ofdmbase[0] << 16 | ofdmbase[0] <<24;
+		ofdmbase[0] << 16 | ofdmbase[0] << 24;
 	ofdm_b = ofdmbase[1] | ofdmbase[1] << 8 |
-		ofdmbase[1] << 16 | ofdmbase[1] <<24;
+		ofdmbase[1] << 16 | ofdmbase[1] << 24;
 	rtl8723au_write32(priv, REG_TX_AGC_A_RATE18_06, ofdm_a);
 	rtl8723au_write32(priv, REG_TX_AGC_B_RATE18_06, ofdm_b);
 
@@ -987,9 +984,9 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	rtl8723au_write32(priv, REG_TX_AGC_B_RATE54_24, ofdm_b);
 
 	mcs_a = mcsbase[0] | mcsbase[0] << 8 |
-		mcsbase[0] << 16 | mcsbase[0] <<24;
+		mcsbase[0] << 16 | mcsbase[0] << 24;
 	mcs_b = mcsbase[1] | mcsbase[1] << 8 |
-		mcsbase[1] << 16 | mcsbase[1] <<24;
+		mcsbase[1] << 16 | mcsbase[1] << 24;
 
 	rtl8723au_write32(priv, REG_TX_AGC_A_MCS03_MCS00, mcs_a);
 	rtl8723au_write32(priv, REG_TX_AGC_B_MCS03_MCS00, mcs_b);
@@ -1081,7 +1078,7 @@ static void rtl8xxxu_8723au_identify_chip(struct rtl8xxxu_priv *priv)
 	val32 = rtl8723au_read32(priv, REG_SYS_CFG);
 	priv->chip_cut = (val32 & SYS_CFG_CHIP_VERSION_MASK) >>
 		SYS_CFG_CHIP_VERSION_SHIFT;
-	switch(priv->chip_cut) {
+	switch (priv->chip_cut) {
 	case 0:
 		cut = "A";
 		break;
@@ -1224,7 +1221,7 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 			offset = (header & 0xe0) >> 5;
 
 			ret = rtl8xxxu_read_efuse8(priv, efuse_addr++,
-						 &extheader);
+						   &extheader);
 			if (ret)
 				goto exit;
 			/* All words disabled */
@@ -1245,11 +1242,11 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 			/* We have 8 bits to indicate validity */
 			map_addr = offset * 8;
 			if (map_addr >= EFUSE_MAP_LEN_8723A) {
-				pr_debug("%s: %s: Illegal map_addr (%04x), "
-					 "efuse corrupt!\n", DRIVER_NAME,
+				pr_debug("%s: %s: Illegal map_addr (%04x), efuse corrupt!\n",
+					 DRIVER_NAME,
 					 __func__, map_addr);
-			ret = -EINVAL;
-			goto exit;
+				ret = -EINVAL;
+				goto exit;
 
 				ret = -EINVAL;
 			}
@@ -1257,21 +1254,21 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 				/* Check word enable condition in the section */
 				if (!(word_mask & BIT(i))) {
 					ret = rtl8xxxu_read_efuse8(priv,
-								 efuse_addr++,
-								 &val8);
+								   efuse_addr++,
+								   &val8);
 					priv->efuse_wifi.raw[map_addr++] = val8;
 
 					ret = rtl8xxxu_read_efuse8(priv,
-								 efuse_addr++,
-								 &val8);
+								   efuse_addr++,
+								   &val8);
 					priv->efuse_wifi.raw[map_addr++] = val8;
 				} else
 					map_addr += 2;
 			}
 		} else {
-			pr_debug("%s: %s: Illegal offset (%04x), "
-				 "efuse corrupt!\n", DRIVER_NAME, __func__,
-			       offset);
+			pr_debug("%s: %s: Illegal offset (%04x), efuse corrupt!\n",
+				 DRIVER_NAME, __func__,
+				 offset);
 			ret = -EINVAL;
 			goto exit;
 		}
@@ -1384,7 +1381,6 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 			ret = -EAGAIN;
 			goto fw_abort;
 		}
-
 	}
 
 	ret = 0;
@@ -1404,7 +1400,7 @@ static int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv)
 	int ret = 0;
 	u16 signature;
 
-	switch(priv->chip_cut) {
+	switch (priv->chip_cut) {
 	case 0:
 		fw_name = "rtlwifi/rtl8723aufw_A.bin";
 		break;
@@ -1436,7 +1432,7 @@ static int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv)
 	priv->fw_size = fw->size - sizeof(struct rtl8xxxu_firmware_header);
 
 	signature = le16_to_cpu(priv->fw_data->signature);
-	switch(signature & 0xfff0) {
+	switch (signature & 0xfff0) {
 	case 0x92c0:
 	case 0x88c0:
 	case 0x2300:
@@ -1591,7 +1587,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	ldov12d = LDOV12D_ENABLE | BIT(2) | (2 << LDOV12D_VADJ_SHIFT);
 	ldohci12 = 0x57;
 	lpldo = 1;
-	val32 = (lpldo << 24) | (ldohci12 << 16) | (ldov12d << 8)| ldoa15;
+	val32 = (lpldo << 24) | (ldohci12 << 16) | (ldov12d << 8) | ldoa15;
 
 	rtl8723au_write32(priv, REG_LDOA15_CTRL, val32);
 
@@ -1612,7 +1608,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 		if (reg == 0xff && val == 0xffffffff)
 			break;
 
-		switch(reg) {
+		switch (reg) {
 		case 0xfe:
 			msleep(50);
 			continue;
@@ -1751,7 +1747,7 @@ static int rtl8xxxu_init_queue_priority(struct rtl8xxxu_priv *priv)
 	int hip, mgp, bkp, bep, vip, vop;
 	int ret = 0;
 
-	switch(priv->ep_tx_count) {
+	switch (priv->ep_tx_count) {
 	case 1:
 		if (priv->ep_tx_high_queue) {
 			hi = TRXDMA_QUEUE_HIGH;
@@ -2037,7 +2033,6 @@ static void rtl8xxxu_restore_regs(struct rtl8xxxu_priv *priv, u32 *regs,
 		rtl8723au_write32(priv, regs[i], backup[i]);
 }
 
-
 static void rtl8xxxu_path_adda_on(struct rtl8xxxu_priv *priv, u32 *regs,
 				  bool path_a_on, bool is_2t)
 {
@@ -2159,10 +2154,10 @@ static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	if (t == 0) {
 		/*  Save ADDA parameters, turn Path A ADDA on */
 		rtl8xxxu_save_regs(priv, ADDA_REG, priv->adda_backup,
-				 RTL8XXXU_ADDA_REGS);
+				   RTL8XXXU_ADDA_REGS);
 		rtl8xxxu_save_mac_regs(priv, IQK_MAC_REG, priv->mac_backup);
 		rtl8xxxu_save_regs(priv, IQK_BB_REG_92C,
-				 priv->bb_backup, RTL8XXXU_BB_REGS);
+				   priv->bb_backup, RTL8XXXU_BB_REGS);
 	}
 
 	rtl8xxxu_path_adda_on(priv, ADDA_REG, true, is_2t);
@@ -2414,9 +2409,8 @@ static void rtl8723a_phy_iq_calibrate(struct rtl8xxxu_priv *priv, bool recovery)
 		reg_ec4 = result[candidate][6];
 		reg_ecc = result[candidate][7];
 		pr_debug("%s: candidate is %x\n", __func__, candidate);
-		pr_debug("%s: reg_e94 =%x reg_e9C =%x reg_eA4 =%x "
-			 "reg_eAC =%x reg_eB4 =%x reg_eBC =%x reg_eC4 =%x "
-			 "reg_eCC =%x\n ", __func__, reg_e94, reg_e9c,
+		pr_debug("%s: reg_e94 =%x reg_e9C =%x reg_eA4 =%x reg_eAC =%x reg_eB4 =%x reg_eBC =%x reg_eC4 =%x reg_eCC =%x\n",
+			 __func__, reg_e94, reg_e9c,
 			 reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc);
 		path_a_ok = true;
 #if 0
@@ -2540,10 +2534,10 @@ void rtl8xxxu_set_ampdu_factor(struct rtl8xxxu_priv *priv, u8 ampdu_factor)
 		if ((vals[i] & 0xf0) > (ampdu_factor << 4))
 			vals[i] = (vals[i] & 0x0f) | (ampdu_factor << 4);
 
-			if ((vals[i] & 0x0f) > ampdu_factor)
-				vals[i] = (vals[i] & 0xf0) | ampdu_factor;
+		if ((vals[i] & 0x0f) > ampdu_factor)
+			vals[i] = (vals[i] & 0xf0) | ampdu_factor;
 
-			rtl8723au_write8(priv, REG_AGGLEN_LMT + i, vals[i]);
+		rtl8723au_write8(priv, REG_AGGLEN_LMT + i, vals[i]);
 	}
 }
 
@@ -2830,7 +2824,7 @@ static int rtl8xxxu_power_on(struct rtl8xxxu_priv *priv)
 
 	/* for Efuse PG */
 	val32 = rtl8723au_read32(priv, REG_EFUSE_CTRL);
-	val32 &= ~(BIT(28)|BIT(29)|BIT(30));
+	val32 &= ~(BIT(28) | BIT(29) | BIT(30));
 	val32 |= (0x06 << 28);
 	rtl8723au_write32(priv, REG_EFUSE_CTRL, val32);
 exit:
@@ -2859,7 +2853,7 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	/* Reset MCU ready status */
 	rtl8723au_write8(priv, REG_MCU_FW_DL, 0x00);
 
-	rtl8xxxu_active_to_emu(priv);	
+	rtl8xxxu_active_to_emu(priv);
 	rtl8xxxu_emu_to_disabled(priv);
 
 	/* Reset MCU IO Wrapper */
@@ -2940,7 +2934,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	val32 = 0x07000000 | FPGA0_RF_TRSW | FPGA0_RF_TRSWB |
 		FPGA0_RF_ANTSW | FPGA0_RF_ANTSWB | FPGA0_RF_PAPE;
 	rtl8723au_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
-	 /* 0x860[6:5]= 00 - why? - this sets antenna B */
+	/* 0x860[6:5]= 00 - why? - this sets antenna B */
 	rtl8723au_write32(priv, REG_FPGA0_XA_RF_INT_OE, 0x66F60210);
 
 	priv->rf_mode_ag[0] = rtl8723au_read_rfreg(priv, RF6052_REG_MODE_AG);
@@ -3057,12 +3051,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	rtl8723au_write32(priv, REG_RARFRC, 0x04030201);
 	rtl8723au_write32(priv, REG_RARFRC + 4, 0x08070605);
 
-        val8 = rtl8723au_read8(priv, REG_FWHW_TXQ_CTRL);
-        val8 |= FWHW_TXQ_CTRL_AMPDU_RETRY;
-        rtl8723au_write8(priv, REG_FWHW_TXQ_CTRL, val8);
+	val8 = rtl8723au_read8(priv, REG_FWHW_TXQ_CTRL);
+	val8 |= FWHW_TXQ_CTRL_AMPDU_RETRY;
+	rtl8723au_write8(priv, REG_FWHW_TXQ_CTRL, val8);
 
-        /*  Set ACK timeout */
-        rtl8723au_write8(priv, REG_ACKTO, 0x40);
+	/*  Set ACK timeout */
+	rtl8723au_write8(priv, REG_ACKTO, 0x40);
 
 	/*
 	 * Initialize beacon parameters
@@ -3206,7 +3200,7 @@ static void rtl8xxxu_disable_device(struct ieee80211_hw *hw)
 }
 
 static void rtl8xxxu_cam_write(struct rtl8xxxu_priv *priv,
-			     struct ieee80211_key_conf *key, const u8 *mac)
+			       struct ieee80211_key_conf *key, const u8 *mac)
 {
 	u32 cmd, val32, addr, ctrl;
 	int j, i, tmp_debug;
@@ -3244,7 +3238,7 @@ static void rtl8xxxu_cam_write(struct rtl8xxxu_priv *priv,
 }
 
 static void rtl8xxxu_sw_scan_start(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif, const u8 *mac)
+				   struct ieee80211_vif *vif, const u8 *mac)
 {
 #if 0
 	struct rtl8xxxu_priv *priv = hw->priv;
@@ -3262,7 +3256,7 @@ static void rtl8xxxu_sw_scan_start(struct ieee80211_hw *hw,
 }
 
 static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif)
+				      struct ieee80211_vif *vif)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	u8 val8;
@@ -3270,14 +3264,14 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
 #if 0
 	pr_debug("%s\n", __func__);
 #endif
-	
+
 	val8 = rtl8723au_read8(priv, REG_BEACON_CTRL);
 	val8 &= ~BEACON_DISABLE_TSF_UPDATE;
 	rtl8723au_write8(priv, REG_BEACON_CTRL, val8);
 }
 
 static void rtl8xxxu_update_rate_table(struct rtl8xxxu_priv *priv,
-				     struct ieee80211_sta *sta)
+				       struct ieee80211_sta *sta)
 {
 	struct h2c_cmd h2c;
 	u32 ramask;
@@ -3306,7 +3300,7 @@ static void rtl8xxxu_update_rate_table(struct rtl8xxxu_priv *priv,
 }
 
 static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv,
-				   struct ieee80211_sta *sta)
+				     struct ieee80211_sta *sta)
 {
 	u32 rate_cfg, val32;
 	u8 rate_idx = 0;
@@ -3322,7 +3316,7 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv,
 	pr_debug("%s: supp_rates %08x rates %08x\n", __func__,
 		 sta->supp_rates[0], rate_cfg);
 
-	while(rate_cfg) {
+	while (rate_cfg) {
 		rate_cfg = (rate_cfg >> 1);
 		rate_idx++;
 	}
@@ -3331,7 +3325,7 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv,
 
 static void
 rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			struct ieee80211_bss_conf *bss_conf, u32 changed)
+			  struct ieee80211_bss_conf *bss_conf, u32 changed)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct ieee80211_sta *sta;
@@ -3489,7 +3483,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		rtl8xxxu_set_ampdu_factor(priv, ampdu_factor);
 		rtl8xxxu_set_ampdu_min_space(priv, ampdu_density);
 #endif
-	
+
 		rtl8723au_write8(priv, REG_SIFS_CCK + 1, sifs);
 		rtl8723au_write8(priv, REG_SIFS_OFDM + 1, sifs);
 		rtl8723au_write8(priv, REG_SPEC_SIFS + 1, sifs);
@@ -3518,7 +3512,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
 		if (sta)
 			rtl8xxxu_set_basic_rates(priv, sta);
-		else 
+		else
 			pr_debug("BSS_CHANGED_BASIC_RATES: No sta found!\n");
 
 		rcu_read_unlock();
@@ -3531,7 +3525,7 @@ static u32 rtl8xxxu_80211_to_rtl_queue(u32 queue)
 {
 	u32 rtlqueue;
 
-	switch(queue) {
+	switch (queue) {
 	case IEEE80211_AC_VO:
 		rtlqueue = TXDESC_QUEUE_VO;
 		break;
@@ -3603,7 +3597,6 @@ static void rtl8xxxu_tx_complete(struct urb *urb)
 	usb_free_urb(urb);
 }
 
-
 static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			struct ieee80211_tx_control *control,
 			struct sk_buff *skb)
@@ -3691,9 +3684,10 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		tx_desc->txdw5 = cpu_to_le32(0x0001ff00);
 
 		if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
-			control->sta->ht_cap.ht_supported &&
-			control && control->sta) {
+		    control->sta->ht_cap.ht_supported &&
+		    control && control->sta) {
 			u8 ampdu = control->sta->ht_cap.ampdu_density;
+
 			tx_desc->txdw2 |=
 				cpu_to_le32(ampdu << TXDESC_AMPDU_DENSITY_SHIFT);
 			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_ENABLE);
@@ -3737,7 +3731,6 @@ error:
 	dev_kfree_skb(skb);
 }
 
-
 static void rtl8xxxu_rx_complete(struct urb *urb)
 {
 	struct rtl8xxxu_rx_urb *rx_urb =
@@ -3912,7 +3905,6 @@ static void rtl8xxxu_int_complete(struct urb *urb)
 	}
 }
 
-
 static int rtl8xxxu_submit_int_urb(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
@@ -4042,7 +4034,7 @@ static int rtl8xxxu_conf_tx(struct ieee80211_hw *hw,
 	pr_debug("%s: IEEE80211 queue %02x val %08x, acm %i, acm_ctrl %02x\n",
 		 __func__, queue, val32, param->acm, acm_ctrl);
 
-	switch(queue) {
+	switch (queue) {
 	case IEEE80211_AC_VO:
 		acm_bit = ACM_HW_CTRL_VO;
 		rtl8723au_write32(priv, REG_EDCA_VO_PARAM, val32);
@@ -4145,7 +4137,7 @@ static int rtl8xxxu_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	val8 |= SEC_CFG_TX_USE_DEFKEY | SEC_CFG_RX_USE_DEFKEY;
 	rtl8723au_write8(priv, REG_SECURITY_CFG, val8);
 
-	switch(cmd) {
+	switch (cmd) {
 	case SET_KEY:
 		/*
 		 * This is a bit of a hack - the lower bits of the cipher
diff --git a/drivers/net/wireless/rtl8xxxu.h b/drivers/net/wireless/rtl8xxxu.h
index 8d9f64c..20e0317 100644
--- a/drivers/net/wireless/rtl8xxxu.h
+++ b/drivers/net/wireless/rtl8xxxu.h
@@ -331,14 +331,14 @@ struct rtl8xxxu_firmware_header {
  * The 8723au has 3 channel groups: 1-3, 4-9, and 10-14
  */
 struct rtl8723au_idx {
-#if defined (__LITTLE_ENDIAN)
+#if defined(__LITTLE_ENDIAN)
 	int	a:4;
 	int	b:4;
-#elif defined (__LITTLE_ENDIAN)
+#elif defined(__LITTLE_ENDIAN)
 	int	b:4;
 	int	a:4;
 #else
-#error "no endianess defined"
+#error "no endianness defined"
 #endif
 } __attribute__((packed));
 
@@ -490,8 +490,7 @@ struct rtl8xxxu_priv {
 	bool use_shortgi;
 };
 
-struct rtl8xxxu_rx_urb
-{
+struct rtl8xxxu_rx_urb {
 	struct urb urb;
 	struct ieee80211_hw *hw;
 };
diff --git a/drivers/net/wireless/rtl8xxxu_regs.h b/drivers/net/wireless/rtl8xxxu_regs.h
index 97320b3..43fde73 100644
--- a/drivers/net/wireless/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/rtl8xxxu_regs.h
@@ -107,7 +107,7 @@
 #define REG_EFUSE_TEST			0x0034
 #define  EFUSE_TRPT			BIT(7)
 	/*  00: Wifi Efuse, 01: BT Efuse0, 10: BT Efuse1, 11: BT Efuse2 */
-#define  EFUSE_CELL_SEL			(BIT(8)|BIT(9))
+#define  EFUSE_CELL_SEL			(BIT(8) | BIT(9))
 #define  EFUSE_LDOE25_ENABLE		BIT(31)
 #define  EFUSE_SELECT_MASK		0x0300
 #define  EFUSE_WIFI_SELECT		0x0000
@@ -165,7 +165,6 @@
 						   control */
 #define	 MULTI_GPS_FUNC_EN		BIT(22)	/* GPS function enable */
 
-
 #define REG_MCU_FW_DL			0x0080
 #define  MCU_FW_DL_ENABLE		BIT(0)
 #define  MCU_FW_DL_READY		BIT(1)
@@ -204,7 +203,7 @@
 #define  SYS_CFG_BD_MAC2		BIT(9)
 #define  SYS_CFG_BD_MAC1		BIT(10)
 #define  SYS_CFG_IC_MACPHY_MODE		BIT(11)
-#define  SYS_CFG_CHIP_VER		(BIT(12)|BIT(13)|BIT(14)|BIT(15))
+#define  SYS_CFG_CHIP_VER		(BIT(12) | BIT(13) | BIT(14) | BIT(15))
 #define  SYS_CFG_BT_FUNC		BIT(16)
 #define  SYS_CFG_VENDOR_ID		BIT(19)
 #define  SYS_CFG_PAD_HWPD_IDN		BIT(22)
@@ -220,11 +219,10 @@
 #define  SYS_CFG_CHIP_VERSION_MASK	0xf000	/* Bit 12 - 15 */
 #define  SYS_CFG_CHIP_VERSION_SHIFT	12
 
-
 #define REG_GPIO_OUTSTS			0x00f4	/*  For RTL8723 only. */
-#define	 GPIO_EFS_HCI_SEL		(BIT(0)|BIT(1))
-#define	 GPIO_PAD_HCI_SEL		(BIT(2)|BIT(3))
-#define	 GPIO_HCI_SEL			(BIT(4)|BIT(5))
+#define	 GPIO_EFS_HCI_SEL		(BIT(0) | BIT(1))
+#define	 GPIO_PAD_HCI_SEL		(BIT(2) | BIT(3))
+#define	 GPIO_HCI_SEL			(BIT(4) | BIT(5))
 #define	 GPIO_PKG_SEL_HCI		BIT(6)
 #define	 GPIO_FEN_GPS			BIT(7)
 #define	 GPIO_FEN_BT			BIT(8)
@@ -241,7 +239,7 @@
 #define	 GPIO_UPHY_SUSB			BIT(21)
 #define	 GPIO_PCI_SUSEN			BIT(22)
 #define	 GPIO_USB_SUSEN			BIT(23)
-#define	 GPIO_RF_RL_ID			(BIT(31)|BIT(30)|BIT(29)|BIT(28))
+#define	 GPIO_RF_RL_ID			(BIT(31) | BIT(30) | BIT(29) | BIT(28))
 
 /* 0x0100 ~ 0x01FF	MACTOP General Configuration */
 #define REG_CR				0x0100
@@ -285,7 +283,6 @@
 #define  TRXDMA_QUEUE_NORMAL		2
 #define  TRXDMA_QUEUE_HIGH		3
 
-
 #define REG_TRXFF_BNDY			0x0114
 #define REG_TRXFF_STATUS		0x0118
 #define REG_RXFF_PTR			0x011c
@@ -360,7 +357,6 @@
 #define REG_HGQ_INFORMATION		0x0414
 #define REG_BCNQ_INFORMATION		0x0418
 
-
 #define REG_CPU_MGQ_INFORMATION		0x041c
 #define REG_FWHW_TXQ_CTRL		0x0420
 #define  FWHW_TXQ_CTRL_AMPDU_RETRY	BIT(7)
@@ -411,7 +407,7 @@
 #define  RSR_MCS7			BIT(19)
 #define  RSR_RSC_LOWER_SUB_CHANNEL	BIT(21)	/* 0x200000 */
 #define  RSR_RSC_UPPER_SUB_CHANNEL	BIT(22)	/* 0x400000 */
-#define  RSR_RSC_BANDWIDTH_40M		(RSR_RSC_UPPER_SUB_CHANNEL|\
+#define  RSR_RSC_BANDWIDTH_40M		(RSR_RSC_UPPER_SUB_CHANNEL | \
 					 RSR_RSC_LOWER_SUB_CHANNEL)
 #define  RSR_ACK_SHORT_PREAMBLE		BIT(23)
 
@@ -427,7 +423,6 @@
 #define REG_INIRTS_RATE_SEL		0x0480
 #define REG_INIDATA_RATE_SEL		0x0484
 
-
 #define REG_POWER_STATUS		0x04a4
 #define REG_POWER_STAGE1		0x04b4
 #define REG_POWER_STAGE2		0x04b8
@@ -446,8 +441,6 @@
 #define REG_PTCL_ERR_STATUS		0x04e2
 #define REG_DUMMY			0x04fc
 
-
-
 /* 0x0500 ~ 0x05FF	EDCA Configuration */
 #define REG_EDCA_VO_PARAM		0x0500
 #define REG_EDCA_VI_PARAM		0x0504
@@ -592,7 +585,6 @@
 #define REG_RXERR_RPT			0x0664
 #define REG_WMAC_TRXPTCL_CTL		0x0668
 
-
 /*  Security */
 #define REG_CAM_CMD			0x0670
 #define	 CAM_CMD_POLLING		BIT(31)


