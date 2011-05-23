Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1EWByi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:54:38 -0400
Date: Sun, 22 May 2011 20:54:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7 V2] rtl8192ce: Fix warnings from gcc 4.6.0
Message-ID: <4dd9be5d.kCHV0Lj8JdhZWJPN%Larry.Finger@lwfinger.net> (sfid-20110523_035443_232604_303FA260)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.6.0 warnings for rtl8192ce:

  CC [M]  drivers/net/wireless/rtlwifi/rtl8192ce/hw.o
drivers/net/wireless/rtlwifi/rtl8192ce/hw.c: In function ‘_rtl92ce_hw_configure’:
drivers/net/wireless/rtlwifi/rtl8192ce/hw.c:766:6: warning: variable ‘reg_ratr’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8192ce/hw.c: In function ‘rtl92ce_gpio_radio_on_off_checking’:
drivers/net/wireless/rtlwifi/rtl8192ce/hw.c:1972:41: warning: variable ‘cur_rfstate’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192ce/phy.o
drivers/net/wireless/rtlwifi/rtl8192ce/phy.c: In function ‘rtl92c_phy_config_rf_with_headerfile’:
drivers/net/wireless/rtlwifi/rtl8192ce/phy.c:284:7: warning: variable ‘rtstatus’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192ce/trx.o
drivers/net/wireless/rtlwifi/rtl8192ce/trx.c: In function ‘_rtl92ce_translate_rx_signal_stuff’:
drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:595:6: warning: variable ‘psaddr’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -763,11 +763,9 @@ static void _rtl92ce_hw_configure(struct
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	u8 reg_bw_opmode;
-	u32 reg_ratr, reg_prsr;
+	u32 reg_prsr;
 
 	reg_bw_opmode = BW_OPMODE_20MHZ;
-	reg_ratr = RATE_ALL_CCK | RATE_ALL_OFDM_AG |
-	    RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
 	reg_prsr = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 
 	rtl_write_byte(rtlpriv, REG_INIRTS_RATE_SEL, 0x8);
@@ -1969,7 +1967,7 @@ bool rtl92ce_gpio_radio_on_off_checking(
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	enum rf_pwrstate e_rfpowerstate_toset, cur_rfstate;
+	enum rf_pwrstate e_rfpowerstate_toset;
 	u8 u1tmp;
 	bool actuallyset = false;
 	unsigned long flag;
@@ -1989,8 +1987,6 @@ bool rtl92ce_gpio_radio_on_off_checking(
 		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
 	}
 
-	cur_rfstate = ppsc->rfpwr_state;
-
 	rtl_write_byte(rtlpriv, REG_MAC_PINMUX_CFG, rtl_read_byte(rtlpriv,
 		       REG_MAC_PINMUX_CFG)&~(BIT(3)));
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -281,7 +281,6 @@ bool rtl92c_phy_config_rf_with_headerfil
 {
 
 	int i;
-	bool rtstatus = true;
 	u32 *radioa_array_table;
 	u32 *radiob_array_table;
 	u16 radioa_arraylen, radiob_arraylen;
@@ -308,7 +307,6 @@ bool rtl92c_phy_config_rf_with_headerfil
 			 ("Radio_B:RTL8192CE_RADIOB_1TARRAY\n"));
 	}
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, ("Radio No %x\n", rfpath));
-	rtstatus = true;
 	switch (rfpath) {
 	case RF90_PATH_A:
 		for (i = 0; i < radioa_arraylen; i = i + 2) {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -592,7 +592,6 @@ static void _rtl92ce_translate_rx_signal
 	struct ieee80211_hdr *hdr;
 	u8 *tmp_buf;
 	u8 *praddr;
-	u8 *psaddr;
 	__le16 fc;
 	u16 type, c_fc;
 	bool packet_matchbssid, packet_toself, packet_beacon;
@@ -604,7 +603,6 @@ static void _rtl92ce_translate_rx_signal
 	c_fc = le16_to_cpu(fc);
 	type = WLAN_FC_GET_TYPE(fc);
 	praddr = hdr->addr1;
-	psaddr = hdr->addr2;
 
 	packet_matchbssid =
 	    ((IEEE80211_FTYPE_CTL != type) &&
