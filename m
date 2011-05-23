Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1EWBtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:49:55 -0400
Date: Sun, 22 May 2011 20:49:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Message-ID: <4dd9bd41.I4TeeDKoEoFoecJu%Larry.Finger@lwfinger.net> (sfid-20110523_034959_137784_AE856A58)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.6.0 warnings for rtl8192c-common:

  CC [M]  drivers/net/wireless/rtlwifi/rtl8192c/fw_common.o
drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: In function ‘_rtl92c_cmd_send_packet’:
drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:549:5: warning: variable ‘own’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192c/phy_common.o
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c: In function ‘_rtl92c_phy_iq_calibrate’:
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:1256:6: warning: variable ‘bbvalue’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c: In function ‘rtl92c_phy_iq_calibrate’:
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:1766:6: warning: variable ‘reg_ecc’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:1765:34: warning: variable ‘reg_eac’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -546,7 +546,6 @@ static bool _rtl92c_cmd_send_packet(stru
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring;
 	struct rtl_tx_desc *pdesc;
-	u8 own;
 	unsigned long flags;
 	struct sk_buff *pskb = NULL;
 
@@ -559,7 +558,6 @@ static bool _rtl92c_cmd_send_packet(stru
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 
 	pdesc = &ring->desc[0];
-	own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc, true, HW_DESC_OWN);
 
 	rtlpriv->cfg->ops->fill_tx_cmddesc(hw, (u8 *) pdesc, 1, 1, skb);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -1253,10 +1253,9 @@ static void _rtl92c_phy_iq_calibrate(str
 
 	const u32 retrycount = 2;
 
-	u32 bbvalue;
-
 	if (t == 0) {
-		bbvalue = rtl_get_bbreg(hw, 0x800, MASKDWORD);
+		/* dummy read */
+		rtl_get_bbreg(hw, 0x800, MASKDWORD);
 
 		_rtl92c_phy_save_adda_registers(hw, adda_reg,
 						rtlphy->adda_backup, 16);
@@ -1762,8 +1761,7 @@ void rtl92c_phy_iq_calibrate(struct ieee
 	long result[4][8];
 	u8 i, final_candidate;
 	bool patha_ok, pathb_ok;
-	long reg_e94, reg_e9c, reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4,
-	    reg_ecc, reg_tmp = 0;
+	long reg_e94, reg_e9c, reg_ea4, reg_eb4, reg_ebc, reg_ec4, reg_tmp = 0;
 	bool is12simular, is13simular, is23simular;
 	bool start_conttx = false, singletone = false;
 	u32 iqk_bb_reg[10] = {
@@ -1841,21 +1839,17 @@ void rtl92c_phy_iq_calibrate(struct ieee
 		reg_e94 = result[i][0];
 		reg_e9c = result[i][1];
 		reg_ea4 = result[i][2];
-		reg_eac = result[i][3];
 		reg_eb4 = result[i][4];
 		reg_ebc = result[i][5];
 		reg_ec4 = result[i][6];
-		reg_ecc = result[i][7];
 	}
 	if (final_candidate != 0xff) {
 		rtlphy->reg_e94 = reg_e94 = result[final_candidate][0];
 		rtlphy->reg_e9c = reg_e9c = result[final_candidate][1];
 		reg_ea4 = result[final_candidate][2];
-		reg_eac = result[final_candidate][3];
 		rtlphy->reg_eb4 = reg_eb4 = result[final_candidate][4];
 		rtlphy->reg_ebc = reg_ebc = result[final_candidate][5];
 		reg_ec4 = result[final_candidate][6];
-		reg_ecc = result[final_candidate][7];
 		patha_ok = pathb_ok = true;
 	} else {
 		rtlphy->reg_e94 = rtlphy->reg_eb4 = 0x100;
