Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1EWByp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:54:45 -0400
Date: Sun, 22 May 2011 20:54:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7 V2] rtl8192se: Fix warnings from gcc 4.6.0
Message-ID: <4dd9be63.EJkDWyDIfgEcjRvA%Larry.Finger@lwfinger.net> (sfid-20110523_035447_559319_8BBF08D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.6.0 warnings for rtl8192se:

  CC [M]  drivers/net/wireless/rtlwifi/rtl8192se/dm.o
drivers/net/wireless/rtlwifi/rtl8192se/dm.c: In function ‘_rtl92s_dm_refresh_rateadaptive_mask’:
drivers/net/wireless/rtlwifi/rtl8192se/dm.c:225:5: warning: variable ‘rssi_level’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192se/fw.o
drivers/net/wireless/rtlwifi/rtl8192se/fw.c: In function ‘rtl92s_download_fw’:
drivers/net/wireless/rtlwifi/rtl8192se/fw.c:361:6: warning: variable ‘file_length’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192se/hw.o
drivers/net/wireless/rtlwifi/rtl8192se/hw.c: In function ‘_rtl92se_hw_configure’:
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:887:6: warning: variable ‘reg_ratr’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8192se/hw.c: In function ‘_rtl92se_set_media_status’:
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:1125:20: warning: variable ‘ledaction’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8192se/hw.c: In function ‘rtl92se_gpio_radio_on_off_checking’:
drivers/net/wireless/rtlwifi/rtl8192se/hw.c:2274:32: warning: variable ‘cur_rfstate’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192se/phy.o
drivers/net/wireless/rtlwifi/rtl8192se/phy.c: In function ‘rtl92s_phy_set_bw_mode’:
drivers/net/wireless/rtlwifi/rtl8192se/phy.c:266:5: warning: variable ‘reg_prsr_rsc’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192se/trx.o
drivers/net/wireless/rtlwifi/rtl8192se/trx.c: In function ‘_rtl92se_translate_rx_signal_stuff’:
drivers/net/wireless/rtlwifi/rtl8192se/trx.c:584:6: warning: variable ‘psaddr’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -222,7 +222,6 @@ static void _rtl92s_dm_refresh_rateadapt
 	u32 low_rssi_thresh = 0;
 	u32 middle_rssi_thresh = 0;
 	u32 high_rssi_thresh = 0;
-	u8 rssi_level;
 	struct ieee80211_sta *sta = NULL;
 
 	if (is_hal_stop(rtlhal))
@@ -272,18 +271,14 @@ static void _rtl92s_dm_refresh_rateadapt
 		if (rtlpriv->dm.undecorated_smoothed_pwdb >
 		    (long)high_rssi_thresh) {
 			ra->ratr_state = DM_RATR_STA_HIGH;
-			rssi_level = 1;
 		} else if (rtlpriv->dm.undecorated_smoothed_pwdb >
 			   (long)middle_rssi_thresh) {
 			ra->ratr_state = DM_RATR_STA_LOW;
-			rssi_level = 3;
 		} else if (rtlpriv->dm.undecorated_smoothed_pwdb >
 			   (long)low_rssi_thresh) {
 			ra->ratr_state = DM_RATR_STA_LOW;
-			rssi_level = 5;
 		} else {
 			ra->ratr_state = DM_RATR_STA_ULTRALOW;
-			rssi_level = 6;
 		}
 
 		if (ra->pre_ratr_state != ra->ratr_state) {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -358,7 +358,6 @@ int rtl92s_download_fw(struct ieee80211_
 	struct fw_priv *pfw_priv = NULL;
 	u8 *puc_mappedfile = NULL;
 	u32 ul_filelength = 0;
-	u32 file_length = 0;
 	u8 fwhdr_size = RT_8192S_FIRMWARE_HDR_SIZE;
 	u8 fwstatus = FW_STATUS_INIT;
 	bool rtstatus = true;
@@ -370,7 +369,6 @@ int rtl92s_download_fw(struct ieee80211_
 	firmware->fwstatus = FW_STATUS_INIT;
 
 	puc_mappedfile = firmware->sz_fw_tmpbuffer;
-	file_length = firmware->sz_fw_tmpbufferlen;
 
 	/* 1. Retrieve FW header. */
 	firmware->pfwheader = (struct fw_hdr *) puc_mappedfile;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -884,12 +884,10 @@ static void _rtl92se_hw_configure(struct
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
 	u8 reg_bw_opmode = 0;
-	u32 reg_ratr = 0, reg_rrsr = 0;
+	u32 reg_rrsr = 0;
 	u8 regtmp = 0;
 
 	reg_bw_opmode = BW_OPMODE_20MHZ;
-	reg_ratr = RATE_ALL_CCK | RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS |
-				RATE_ALL_OFDM_2SS;
 	reg_rrsr = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 
 	regtmp = rtl_read_byte(rtlpriv, INIRTSMCS_SEL);
@@ -1122,14 +1120,12 @@ static int _rtl92se_set_media_status(str
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 bt_msr = rtl_read_byte(rtlpriv, MSR);
-	enum led_ctl_mode ledaction = LED_CTL_NO_LINK;
 	u32 temp;
 	bt_msr &= ~MSR_LINK_MASK;
 
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
 		bt_msr |= (MSR_LINK_NONE << MSR_LINK_SHIFT);
-		ledaction = LED_CTL_LINK;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("Set Network type to NO LINK!\n"));
 		break;
@@ -1140,7 +1136,6 @@ static int _rtl92se_set_media_status(str
 		break;
 	case NL80211_IFTYPE_STATION:
 		bt_msr |= (MSR_LINK_MANAGED << MSR_LINK_SHIFT);
-		ledaction = LED_CTL_LINK;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("Set Network type to STA!\n"));
 		break;
@@ -2271,7 +2266,7 @@ bool rtl92se_gpio_radio_on_off_checking(
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	enum rf_pwrstate rfpwr_toset, cur_rfstate;
+	enum rf_pwrstate rfpwr_toset /*, cur_rfstate */;
 	unsigned long flag = 0;
 	bool actuallyset = false;
 	bool turnonbypowerdomain = false;
@@ -2292,7 +2287,7 @@ bool rtl92se_gpio_radio_on_off_checking(
 		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
 	}
 
-	cur_rfstate = ppsc->rfpwr_state;
+	/* cur_rfstate = ppsc->rfpwr_state;*/
 
 	/* because after _rtl92s_phy_set_rfhalt, all power
 	 * closed, so we must open some power for GPIO check,
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -263,7 +263,6 @@ void rtl92s_phy_set_bw_mode(struct ieee8
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	u8 reg_bw_opmode;
-	u8 reg_prsr_rsc;
 
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("Switch to %s bandwidth\n",
 		  rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ?
@@ -277,7 +276,8 @@ void rtl92s_phy_set_bw_mode(struct ieee8
 	rtlphy->set_bwmode_inprogress = true;
 
 	reg_bw_opmode = rtl_read_byte(rtlpriv, BW_OPMODE);
-	reg_prsr_rsc = rtl_read_byte(rtlpriv, RRSR + 2);
+	/* dummy read */
+	rtl_read_byte(rtlpriv, RRSR + 2);
 
 	switch (rtlphy->current_chan_bw) {
 	case HT_CHANNEL_WIDTH_20:
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -581,7 +581,6 @@ static void _rtl92se_translate_rx_signal
 	struct ieee80211_hdr *hdr;
 	u8 *tmp_buf;
 	u8 *praddr;
-	u8 *psaddr;
 	__le16 fc;
 	u16 type, cfc;
 	bool packet_matchbssid, packet_toself, packet_beacon;
@@ -593,7 +592,6 @@ static void _rtl92se_translate_rx_signal
 	cfc = le16_to_cpu(fc);
 	type = WLAN_FC_GET_TYPE(fc);
 	praddr = hdr->addr1;
-	psaddr = hdr->addr2;
 
 	packet_matchbssid = ((IEEE80211_FTYPE_CTL != type) &&
 	     (!compare_ether_addr(mac->bssid, (cfc & IEEE80211_FCTL_TODS) ?
