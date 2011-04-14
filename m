Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64408 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1DNCAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 22:00:05 -0400
Date: Wed, 13 Apr 2011 21:00:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix unitialized variable warnings
Message-ID: <4da65522.5Q2derfNcHLlWHiC%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In http://lkml.indiana.edu/hypermail/linux/kernel/1104.1/01955.html, Geerti
Uytterhoeven reports the following warnings for the rtlwifi drivers.

src/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c: warning:
	 'cck_index' may be used uninitialized in this function: => 637
src/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c: warning:
	 'cck_index_old' may be used uninitialized in this function: => 637
src/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: warning:
	 'box_extreg' may be used uninitialized in this function: => 303
src/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: warning:
	 'box_reg' may be used uninitialized in this function: => 303
src/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c: warning:
	 'chnlgroup' may be used uninitialized in this function: => 205
src/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c: warning:
	 'u4_regvalue' may be used uninitialized in this function: => 450
src/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c: warning:
	 'hq_sele' may be used uninitialized in this function: => 924

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch was made against wireless-testing. When applied to mainline,
it has an offset and fuzz 1, but it applies correctly. I hope that is
not important.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -634,7 +634,7 @@ static void rtl92c_dm_txpower_tracking_c
 	u8 thermalvalue, delta, delta_lck, delta_iqk;
 	long ele_a, ele_d, temp_cck, val_x, value32;
 	long val_y, ele_c;
-	u8 ofdm_index[2], cck_index, ofdm_index_old[2], cck_index_old;
+	u8 ofdm_index[2], cck_index = 0, ofdm_index_old[2], cck_index_old = 0;
 	int i;
 	bool is2t = IS_92C_SERIAL(rtlhal->version);
 	u8 txpwr_level[2] = {0, 0};
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -293,7 +293,7 @@ static void _rtl92c_fill_h2c_command(str
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 boxnum;
-	u16 box_reg, box_extreg;
+	u16 box_reg = 0, box_extreg = 0;
 	u8 u1b_tmp;
 	bool isfw_read = false;
 	bool bwrite_sucess = false;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -202,7 +202,7 @@ static void _rtl92c_get_txpower_writeval
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 i, chnlgroup, pwr_diff_limit[4];
+	u8 i, chnlgroup = 0, pwr_diff_limit[4];
 	u32 writeVal, customer_limit, rf;
 
 	for (rf = 0; rf < 2; rf++) {
@@ -447,7 +447,7 @@ static bool _rtl92c_phy_rf6052_config_pa
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	u32 u4_regvalue;
+	u32 u4_regvalue = 0;
 	u8 rfpath;
 	bool rtstatus;
 	struct bb_reg_def *pphyreg;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -921,7 +921,7 @@ static void _rtl92cu_init_chipT_queue_pr
 					       u8 out_ep_num,
 					       u8 queue_sel)
 {
-	u8	hq_sele;
+	u8 hq_sele = 0;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	switch (out_ep_num) {
