Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47218 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3BAQku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 11:40:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 6/6] rtlwifi: rtl8723ae: Fix W=1 compile warnings
Date: Fri,  1 Feb 2013 10:40:27 -0600
Message-Id: <1359736827-30977-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130201_174058_006848_941AD59A)
In-Reply-To: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whe this driver is built with "make W=1", the following warnings are output:

drivers/net/wireless/rtlwifi/rtl8723ae/fw.c:515:5: warning: variable ‘own’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c:1436:5: warning: variable ‘bt_retry_cnt’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/hw.c:706:6: warning: variable ‘reg_ratr’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/hw.c:2033:41: warning: variable ‘cur_rfstate’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/phy.c:620:23: warning: variable ‘radiob_arraylen’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/phy.c:619:7: warning: variable ‘radiob_array_table’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/phy.c:617:7: warning: variable ‘rtstatus’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/phy.c:1534:6: warning: variable ‘bbvalue’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/phy.c:1716:6: warning: variable ‘reg_ecc’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/phy.c:1715:61: warning: variable ‘reg_ec4’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/phy.c:1715:34: warning: variable ‘reg_eac’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c:247:6: warning: variable ‘psaddr’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c      |  2 --
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c |  2 --
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c      |  8 ++------
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c     | 20 ++------------------
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c     |  2 --
 5 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
index 3b71dab..35cb8f8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
@@ -512,7 +512,6 @@ static bool _rtl8723ae_cmd_send_packet(struct ieee80211_hw *hw,
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring;
 	struct rtl_tx_desc *pdesc;
-	u8 own;
 	unsigned long flags;
 	struct sk_buff *pskb = NULL;
 
@@ -525,7 +524,6 @@ static bool _rtl8723ae_cmd_send_packet(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 
 	pdesc = &ring->desc[0];
-	own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc, true, HW_DESC_OWN);
 
 	rtlpriv->cfg->ops->fill_tx_cmddesc(hw, (u8 *) pdesc, 1, 1, skb);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
index 887d521..68c2834 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
@@ -1433,7 +1433,6 @@ static void _rtl8723ae_dm_bt_coexist_2_ant(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
-	u8 bt_retry_cnt;
 	u8 bt_info_original;
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
 		 "[BTCoex] Get bt info by fw!!\n");
@@ -1445,7 +1444,6 @@ static void _rtl8723ae_dm_bt_coexist_2_ant(struct ieee80211_hw *hw)
 				 "[BTCoex] c2h for btInfo not rcvd yet!!\n");
 	}
 
-	bt_retry_cnt = rtlhal->hal_coex_8723.bt_retry_cnt;
 	bt_info_original = rtlhal->hal_coex_8723.c2h_bt_info_original;
 
 	/* when bt inquiry or page scan, we have to set h2c 0x25
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index 0a8c038..1498048 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -703,11 +703,9 @@ static void _rtl8723ae_hw_configure(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 reg_bw_opmode;
-	u32 reg_ratr, reg_prsr;
+	u32 reg_prsr;
 
 	reg_bw_opmode = BW_OPMODE_20MHZ;
-	reg_ratr = RATE_ALL_CCK | RATE_ALL_OFDM_AG |
-	    RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
 	reg_prsr = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 
 	rtl_write_byte(rtlpriv, REG_INIRTS_RATE_SEL, 0x8);
@@ -2030,7 +2028,7 @@ bool rtl8723ae_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	enum rf_pwrstate e_rfpowerstate_toset, cur_rfstate;
+	enum rf_pwrstate e_rfpowerstate_toset;
 	u8 u1tmp;
 	bool actuallyset = false;
 
@@ -2049,8 +2047,6 @@ bool rtl8723ae_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 		spin_unlock(&rtlpriv->locks.rf_ps_lock);
 	}
 
-	cur_rfstate = ppsc->rfpwr_state;
-
 	rtl_write_byte(rtlpriv, REG_GPIO_IO_SEL_2,
 		       rtl_read_byte(rtlpriv, REG_GPIO_IO_SEL_2)&~(BIT(1)));
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
index 3d8536b..eafbb18 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
@@ -614,17 +614,11 @@ bool rtl8723ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int i;
-	bool rtstatus = true;
 	u32 *radioa_array_table;
-	u32 *radiob_array_table;
-	u16 radioa_arraylen, radiob_arraylen;
+	u16 radioa_arraylen;
 
 	radioa_arraylen = Rtl8723ERADIOA_1TARRAYLENGTH;
 	radioa_array_table = RTL8723E_RADIOA_1TARRAY;
-	radiob_arraylen = RTL8723E_RADIOB_1TARRAYLENGTH;
-	radiob_array_table = RTL8723E_RADIOB_1TARRAY;
-
-	rtstatus = true;
 
 	switch (rfpath) {
 	case RF90_PATH_A:
@@ -1531,11 +1525,8 @@ static void _rtl8723ae_phy_iq_calibrate(struct ieee80211_hw *hw,
 		0x522, 0x550, 0x551, 0x040
 	};
 	const u32 retrycount = 2;
-	u32 bbvalue;
 
 	if (t == 0) {
-		bbvalue = rtl_get_bbreg(hw, 0x800, MASKDWORD);
-
 		phy_save_adda_regs(hw, adda_reg, rtlphy->adda_backup, 16);
 		phy_save_mac_regs(hw, iqk_mac_reg, rtlphy->iqk_mac_backup);
 	}
@@ -1712,8 +1703,7 @@ void rtl8723ae_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery)
 	long result[4][8];
 	u8 i, final_candidate;
 	bool patha_ok, pathb_ok;
-	long reg_e94, reg_e9c, reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4,
-	    reg_ecc, reg_tmp = 0;
+	long reg_e94, reg_e9c, reg_ea4, reg_eb4, reg_ebc, reg_tmp = 0;
 	bool is12simular, is13simular, is23simular;
 	bool start_conttx = false, singletone = false;
 	u32 iqk_bb_reg[10] = {
@@ -1780,21 +1770,15 @@ void rtl8723ae_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery)
 		reg_e94 = result[i][0];
 		reg_e9c = result[i][1];
 		reg_ea4 = result[i][2];
-		reg_eac = result[i][3];
 		reg_eb4 = result[i][4];
 		reg_ebc = result[i][5];
-		reg_ec4 = result[i][6];
-		reg_ecc = result[i][7];
 	}
 	if (final_candidate != 0xff) {
 		rtlphy->reg_e94 = reg_e94 = result[final_candidate][0];
 		rtlphy->reg_e9c = reg_e9c = result[final_candidate][1];
 		reg_ea4 = result[final_candidate][2];
-		reg_eac = result[final_candidate][3];
 		rtlphy->reg_eb4 = reg_eb4 = result[final_candidate][4];
 		rtlphy->reg_ebc = reg_ebc = result[final_candidate][5];
-		reg_ec4 = result[final_candidate][6];
-		reg_ecc = result[final_candidate][7];
 		patha_ok = pathb_ok = true;
 	} else {
 		rtlphy->reg_e94 = rtlphy->reg_eb4 = 0x100;
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index ce8ad12..b1fd2b3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -244,7 +244,6 @@ static void _rtl8723ae_translate_rx_signal_stuff(struct ieee80211_hw *hw,
 	struct ieee80211_hdr *hdr;
 	u8 *tmp_buf;
 	u8 *praddr;
-	u8 *psaddr;
 	__le16 fc;
 	u16 type;
 	bool packet_matchbssid, packet_toself, packet_beacon = false;
@@ -255,7 +254,6 @@ static void _rtl8723ae_translate_rx_signal_stuff(struct ieee80211_hw *hw,
 	fc = hdr->frame_control;
 	type = WLAN_FC_GET_TYPE(fc);
 	praddr = hdr->addr1;
-	psaddr = ieee80211_get_SA(hdr);
 
 	packet_matchbssid = ((IEEE80211_FTYPE_CTL != type) &&
 			    (!compare_ether_addr(mac->bssid,
-- 
1.8.1

