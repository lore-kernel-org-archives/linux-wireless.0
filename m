Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43412 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178Ab1JGQoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:44:20 -0400
Received: by mail-yw0-f46.google.com with SMTP id 5so3801334ywb.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 09:44:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 4/5] rtlwifi: rtl8192se: Updates from latest Realtek driver version - Part II
Date: Fri,  7 Oct 2011 11:43:21 -0500
Message-Id: <1318005802-29057-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111007_184430_401626_E8F96A80)
In-Reply-To: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtl8192se driver.

The changes include:

1. Fixing some typos in register usage.
2. A change in the handling of decryption status for 802.11w packets.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |   22 +++++-----
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   53 +++++++++++++++----------
 drivers/net/wireless/rtlwifi/wifi.h          |    1 +
 5 files changed, 46 insertions(+), 32 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1382,7 +1382,7 @@ static void _rtl92se_power_domain_init(s
 	rtl_write_byte(rtlpriv, LDOA15_CTRL, 0x34);
 
 	/* Reset MAC-IO and CPU and Core Digital BIT10/11/15 */
-	tmpu1b = rtl_read_byte(rtlpriv, SYS_FUNC_EN + 1);
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
 
 	/* If IPS we need to turn LED on. So we not
 	 * not disable BIT 3/7 of reg3. */
@@ -1391,7 +1391,7 @@ static void _rtl92se_power_domain_init(s
 	else
 		tmpu1b &= 0x73;
 
-	rtl_write_byte(rtlpriv, SYS_FUNC_EN + 1, tmpu1b);
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, tmpu1b);
 	/* wait for BIT 10/11/15 to pull high automatically!! */
 	mdelay(1);
 
@@ -1428,15 +1428,15 @@ static void _rtl92se_power_domain_init(s
 	rtl_write_byte(rtlpriv, LDOA15_CTRL, (tmpu1b | BIT(0)));
 
 	/* Set Digital Vdd to Retention isolation Path. */
-	tmpu2b = rtl_read_word(rtlpriv, SYS_ISO_CTRL);
-	rtl_write_word(rtlpriv, SYS_ISO_CTRL, (tmpu2b | BIT(11)));
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_ISO_CTRL);
+	rtl_write_word(rtlpriv, REG_SYS_ISO_CTRL, (tmpu2b | BIT(11)));
 
 
 	/* For warm reboot NIC disappera bug. */
-	tmpu2b = rtl_read_word(rtlpriv, SYS_FUNC_EN);
-	rtl_write_word(rtlpriv, SYS_FUNC_EN, (tmpu2b | BIT(13)));
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(13)));
 
-	rtl_write_byte(rtlpriv, SYS_ISO_CTRL + 1, 0x68);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, 0x68);
 
 	/* Enable AFE PLL Macro Block */
 	tmpu1b = rtl_read_byte(rtlpriv, AFE_PLL_CTRL);
@@ -1447,17 +1447,17 @@ static void _rtl92se_power_domain_init(s
 	mdelay(1);
 
 	/* Release isolation AFE PLL & MD */
-	rtl_write_byte(rtlpriv, SYS_ISO_CTRL, 0xA6);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL, 0xA6);
 
 	/* Enable MAC clock */
 	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
 	rtl_write_word(rtlpriv, SYS_CLKR, (tmpu2b | BIT(12) | BIT(11)));
 
 	/* Enable Core digital and enable IOREG R/W */
-	tmpu2b = rtl_read_word(rtlpriv, SYS_FUNC_EN);
-	rtl_write_word(rtlpriv, SYS_FUNC_EN, (tmpu2b | BIT(11)));
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11)));
 	/* enable REG_EN */
-	rtl_write_word(rtlpriv, SYS_FUNC_EN, (tmpu2b | BIT(11) | BIT(15)));
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11) | BIT(15)));
 
 	/* Switch the control path. */
 	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
@@ -735,6 +735,7 @@
 #define	HWSET_MAX_SIZE_92S			128
 #define EFUSE_MAX_SECTION			16
 #define EFUSE_REAL_CONTENT_LEN			512
+#define EFUSE_OOB_PROTECT_BYTES			15
 
 #define RTL8190_EEPROM_ID			0x8129
 #define EEPROM_HPON				0x02
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -304,6 +304,7 @@ static struct rtl_hal_cfg rtl92se_hal_cf
 	.maps[EFUSE_HWSET_MAX_SIZE] = HWSET_MAX_SIZE_92S,
 	.maps[EFUSE_MAX_SECTION_MAP] = EFUSE_MAX_SECTION,
 	.maps[EFUSE_REAL_CONTENT_SIZE] = EFUSE_REAL_CONTENT_LEN,
+	.maps[EFUSE_OOB_PROTECT_BYTES_LEN] = EFUSE_OOB_PROTECT_BYTES,
 
 	.maps[RWCAM] = REG_RWCAM,
 	.maps[WCAMI] = REG_WCAMI,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -124,18 +124,15 @@ static void _rtl92se_query_rxphystatus(s
 	u8 i, max_spatial_stream;
 	u32 rssi, total_rssi = 0;
 	bool in_powersavemode = false;
-	bool is_cck_rate;
+	bool is_cck = pstats->is_cck;
 
-	is_cck_rate = SE_RX_HAL_IS_CCK_RATE(pdesc);
 	pstats->packet_matchbssid = packet_match_bssid;
 	pstats->packet_toself = packet_toself;
-	pstats->is_cck = is_cck_rate;
 	pstats->packet_beacon = packet_beacon;
-	pstats->is_cck = is_cck_rate;
 	pstats->rx_mimo_signalquality[0] = -1;
 	pstats->rx_mimo_signalquality[1] = -1;
 
-	if (is_cck_rate) {
+	if (is_cck) {
 		u8 report, cck_highpwr;
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 
@@ -246,9 +243,8 @@ static void _rtl92se_query_rxphystatus(s
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
 
-		if (GET_RX_STATUS_DESC_RX_HT(pdesc) &&
-			GET_RX_STATUS_DESC_RX_MCS(pdesc) >= DESC92_RATEMCS8 &&
-		    GET_RX_STATUS_DESC_RX_MCS(pdesc) <= DESC92_RATEMCS15)
+		if (pstats->is_ht && pstats->rate >= DESC92_RATEMCS8 &&
+		    pstats->rate <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -266,7 +262,7 @@ static void _rtl92se_query_rxphystatus(s
 		}
 	}
 
-	if (is_cck_rate)
+	if (is_cck)
 		pstats->signalstrength = (u8)(_rtl92se_signal_scale_mapping(hw,
 					 pwdb_all));
 	else if (rf_rx_num != 0)
@@ -518,6 +514,7 @@ bool rtl92se_rx_query_desc(struct ieee80
 {
 	struct rx_fwinfo *p_drvinfo;
 	u32 phystatus = (u32)GET_RX_STATUS_DESC_PHY_STATUS(pdesc);
+	struct ieee80211_hdr *hdr;
 
 	stats->length = (u16)GET_RX_STATUS_DESC_PKT_LEN(pdesc);
 	stats->rx_drvinfo_size = (u8)GET_RX_STATUS_DESC_DRVINFO_SIZE(pdesc) * 8;
@@ -530,8 +527,12 @@ bool rtl92se_rx_query_desc(struct ieee80
 	stats->rate = (u8)GET_RX_STATUS_DESC_RX_MCS(pdesc);
 	stats->shortpreamble = (u16)GET_RX_STATUS_DESC_SPLCP(pdesc);
 	stats->isampdu = (bool)(GET_RX_STATUS_DESC_PAGGR(pdesc) == 1);
+	stats->isfirst_ampdu = (bool) ((GET_RX_STATUS_DESC_PAGGR(pdesc) == 1)
+			       && (GET_RX_STATUS_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_STATUS_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool)GET_RX_STATUS_DESC_BW(pdesc);
+	stats->is_ht = (bool)GET_RX_STATUS_DESC_RX_HT(pdesc);
+	stats->is_cck = SE_RX_HAL_IS_CCK_RATE(pdesc);
 
 	if (stats->hwerror)
 		return false;
@@ -539,29 +540,39 @@ bool rtl92se_rx_query_desc(struct ieee80
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->band = hw->conf.channel->band;
 
-	if (GET_RX_STATUS_DESC_CRC32(pdesc))
-		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	hdr = (struct ieee80211_hdr *)(skb->data + stats->rx_drvinfo_size
+	      + stats->rx_bufshift);
 
-	if (!GET_RX_STATUS_DESC_SWDEC(pdesc))
-		rx_status->flag |= RX_FLAG_DECRYPTED;
+	if (stats->crc)
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (GET_RX_STATUS_DESC_BW(pdesc))
+	if (stats->rx_is40Mhzpacket)
 		rx_status->flag |= RX_FLAG_40MHZ;
 
-	if (GET_RX_STATUS_DESC_RX_HT(pdesc))
+	if (stats->is_ht)
 		rx_status->flag |= RX_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
-	if (stats->decrypted)
-		rx_status->flag |= RX_FLAG_DECRYPTED;
+	/* hw will set stats->decrypted true, if it finds the
+	 * frame is open data frame or mgmt frame,
+	 * hw will not decrypt robust managment frame
+	 * for IEEE80211w but still set stats->decrypted
+	 * true, so here we should set it back to undecrypted
+	 * for IEEE80211w frame, and mac80211 sw will help
+	 * to decrypt it */
+	if (stats->decrypted) {
+		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+			(ieee80211_has_protected(hdr->frame_control)))
+			rx_status->flag &= ~RX_FLAG_DECRYPTED;
+		else
+			rx_status->flag |= RX_FLAG_DECRYPTED;
+	}
 
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-				(bool)GET_RX_STATUS_DESC_RX_HT(pdesc),
-				(u8)GET_RX_STATUS_DESC_RX_MCS(pdesc));
-
+			     stats->is_ht, stats->rate);
 
-	rx_status->mactime = GET_RX_STATUS_DESC_TSFL(pdesc);
+	rx_status->mactime = stats->timestamp_low;
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo *)(skb->data +
 						 stats->rx_bufshift);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -450,6 +450,7 @@ enum rtl_var_map {
 	EFUSE_HWSET_MAX_SIZE,
 	EFUSE_MAX_SECTION_MAP,
 	EFUSE_REAL_CONTENT_SIZE,
+	EFUSE_OOB_PROTECT_BYTES_LEN,
 
 	/*CAM map */
 	RWCAM,
@@ -1324,6 +1325,7 @@ struct rtl_stats {
 	s8 rx_mimo_signalquality[2];
 	bool packet_matchbssid;
 	bool is_cck;
+	bool is_ht;
 	bool packet_toself;
 	bool packet_beacon;	/*for rssi */
 	char cck_adc_pwdb[4];	/*for rx path selection */
