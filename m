Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:62074 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaCDWy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 17:54:26 -0500
Received: by mail-oa0-f43.google.com with SMTP id g12so236774oah.16
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 14:54:25 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/9] rtlwifi: Move common routines to core
Date: Tue,  4 Mar 2014 16:53:48 -0600
Message-Id: <1393973635-24799-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140304_235433_971106_F288B759)
In-Reply-To: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/rtlwifi/btcoexist/halbt_precomp.h |  12 -
 drivers/net/wireless/rtlwifi/core.c                |  60 +++
 drivers/net/wireless/rtlwifi/core.h                |   4 +
 drivers/net/wireless/rtlwifi/ps.c                  | 100 +++++
 drivers/net/wireless/rtlwifi/ps.h                  |  60 +++
 drivers/net/wireless/rtlwifi/rtl8188ee/Makefile    |   1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |  19 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/phy.c       |  61 +--
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h    |   1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h       |  16 -
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |  71 +---
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |  16 -
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |  71 +---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |  50 +--
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |  10 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       | 429 +++++++++------------
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h       |  14 -
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |  87 +----
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |  12 -
 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile    |   1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |   1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c       |  48 +--
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h    |   1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h       |  16 -
 drivers/net/wireless/rtlwifi/rtl8723be/Makefile    |   1 -
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c        |  15 +-
 drivers/net/wireless/rtlwifi/rtl8723be/phy.c       |  29 +-
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h    |   1 -
 drivers/net/wireless/rtlwifi/rtl8723be/reg.h       |  16 -
 drivers/net/wireless/rtlwifi/wifi.h                |  16 +
 31 files changed, 520 insertions(+), 725 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
index 582532f..d76684e 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
@@ -72,16 +72,4 @@
 #define BIT30	0x40000000
 #define BIT31	0x80000000
 
-#define	MASKBYTE0	0xff
-#define	MASKBYTE1	0xff00
-#define	MASKBYTE2	0xff0000
-#define	MASKBYTE3	0xff000000
-#define	MASKHWORD	0xffff0000
-#define	MASKLWORD	0x0000ffff
-#define	MASKDWORD	0xffffffff
-#define	MASK12BITS	0xfff
-#define	MASKH4BITS	0xf0000000
-#define MASKOFDM_D	0xffc00000
-#define	MASKCCK		0x3f3f3f3f
-
 #endif	/* __HALBT_PRECOMP_H__ */
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 724b830..ded691f 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -36,6 +36,66 @@
 
 #include <linux/export.h>
 
+void rtl_addr_delay(u32 addr)
+{
+	if (addr == 0xfe)
+		mdelay(50);
+	else if (addr == 0xfd)
+		mdelay(5);
+	else if (addr == 0xfc)
+		mdelay(1);
+	else if (addr == 0xfb)
+		udelay(50);
+	else if (addr == 0xfa)
+		udelay(5);
+	else if (addr == 0xf9)
+		udelay(1);
+}
+EXPORT_SYMBOL(rtl_addr_delay);
+
+void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
+		     u32 mask, u32 data)
+{
+	if (addr == 0xfe) {
+		mdelay(50);
+	} else if (addr == 0xfd) {
+		mdelay(5);
+	} else if (addr == 0xfc) {
+		mdelay(1);
+	} else if (addr == 0xfb) {
+		udelay(50);
+	} else if (addr == 0xfa) {
+		udelay(5);
+	} else if (addr == 0xf9) {
+		udelay(1);
+	} else {
+		rtl_set_rfreg(hw, rfpath, addr, mask, data);
+		udelay(1);
+	}
+}
+EXPORT_SYMBOL(rtl_rfreg_delay);
+
+void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data)
+{
+	if (addr == 0xfe) {
+		mdelay(50);
+	} else if (addr == 0xfd) {
+		mdelay(5);
+	} else if (addr == 0xfc) {
+		mdelay(1);
+	} else if (addr == 0xfb) {
+		udelay(50);
+	} else if (addr == 0xfa) {
+		udelay(5);
+	} else if (addr == 0xf9) {
+		udelay(1);
+	} else {
+		rtl_set_bbreg(hw, addr, MASKDWORD, data);
+		udelay(1);
+	}
+}
+EXPORT_SYMBOL(rtl_bb_delay);
+
 void rtl_fw_cb(const struct firmware *firmware, void *context)
 {
 	struct ieee80211_hw *hw = context;
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 2fe46a1..027e753 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -41,5 +41,9 @@
 
 extern const struct ieee80211_ops rtl_ops;
 void rtl_fw_cb(const struct firmware *firmware, void *context);
+void rtl_addr_delay(u32 addr);
+void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
+		     u32 mask, u32 data);
+void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index d1c0191..de7f05f 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -32,6 +32,106 @@
 #include "base.h"
 #include "ps.h"
 
+/*	Description:
+ *		This routine deals with the Power Configuration CMD
+ *		 parsing for RTL8723/RTL8188E Series IC.
+ *	Assumption:
+ *		We should follow specific format that was released from HW SD.
+ */
+bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
+			      u8 faversion, u8 interface_type,
+			      struct wlan_pwr_cfg pwrcfgcmd[])
+{
+	struct wlan_pwr_cfg cfg_cmd = {0};
+	bool polling_bit = false;
+	u32 ary_idx = 0;
+	u8 value = 0;
+	u32 offset = 0;
+	u32 polling_count = 0;
+	u32 max_polling_cnt = 5000;
+
+	do {
+		cfg_cmd = pwrcfgcmd[ary_idx];
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			"rtl_hal_pwrseqcmdparsing(): offset(%#x),cut_msk(%#x), famsk(%#x),"
+			"interface_msk(%#x), base(%#x), cmd(%#x), msk(%#x), value(%#x)\n",
+			GET_PWR_CFG_OFFSET(cfg_cmd),
+					   GET_PWR_CFG_CUT_MASK(cfg_cmd),
+			GET_PWR_CFG_FAB_MASK(cfg_cmd),
+					     GET_PWR_CFG_INTF_MASK(cfg_cmd),
+			GET_PWR_CFG_BASE(cfg_cmd), GET_PWR_CFG_CMD(cfg_cmd),
+			GET_PWR_CFG_MASK(cfg_cmd), GET_PWR_CFG_VALUE(cfg_cmd));
+
+		if ((GET_PWR_CFG_FAB_MASK(cfg_cmd)&faversion) &&
+		    (GET_PWR_CFG_CUT_MASK(cfg_cmd)&cut_version) &&
+		    (GET_PWR_CFG_INTF_MASK(cfg_cmd)&interface_type)) {
+			switch (GET_PWR_CFG_CMD(cfg_cmd)) {
+			case PWR_CMD_READ:
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+					"rtl_hal_pwrseqcmdparsing(): PWR_CMD_READ\n");
+				break;
+			case PWR_CMD_WRITE:
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+					"rtl_hal_pwrseqcmdparsing(): PWR_CMD_WRITE\n");
+				offset = GET_PWR_CFG_OFFSET(cfg_cmd);
+
+				/*Read the value from system register*/
+				value = rtl_read_byte(rtlpriv, offset);
+				value &= (~(GET_PWR_CFG_MASK(cfg_cmd)));
+				value |= (GET_PWR_CFG_VALUE(cfg_cmd) &
+					  GET_PWR_CFG_MASK(cfg_cmd));
+
+				/*Write the value back to sytem register*/
+				rtl_write_byte(rtlpriv, offset, value);
+				break;
+			case PWR_CMD_POLLING:
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+					"rtl_hal_pwrseqcmdparsing(): PWR_CMD_POLLING\n");
+				polling_bit = false;
+				offset = GET_PWR_CFG_OFFSET(cfg_cmd);
+
+				do {
+					value = rtl_read_byte(rtlpriv, offset);
+
+					value &= GET_PWR_CFG_MASK(cfg_cmd);
+					if (value ==
+					    (GET_PWR_CFG_VALUE(cfg_cmd)
+					    & GET_PWR_CFG_MASK(cfg_cmd)))
+						polling_bit = true;
+					else
+						udelay(10);
+
+					if (polling_count++ > max_polling_cnt)
+						return false;
+				} while (!polling_bit);
+				break;
+			case PWR_CMD_DELAY:
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+					"rtl_hal_pwrseqcmdparsing(): PWR_CMD_DELAY\n");
+				if (GET_PWR_CFG_VALUE(cfg_cmd) ==
+				    PWRSEQ_DELAY_US)
+					udelay(GET_PWR_CFG_OFFSET(cfg_cmd));
+				else
+					mdelay(GET_PWR_CFG_OFFSET(cfg_cmd));
+				break;
+			case PWR_CMD_END:
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+					 "rtl_hal_pwrseqcmdparsing(): PWR_CMD_END\n");
+				return true;
+			default:
+				RT_ASSERT(false,
+					 "rtl_hal_pwrseqcmdparsing(): Unknown CMD!!\n");
+				break;
+			}
+
+		}
+		ary_idx++;
+	} while (1);
+
+	return true;
+}
+EXPORT_SYMBOL(rtl_hal_pwrseqcmdparsing);
+
 bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
diff --git a/drivers/net/wireless/rtlwifi/ps.h b/drivers/net/wireless/rtlwifi/ps.h
index 88bd76e..3bd41f9 100644
--- a/drivers/net/wireless/rtlwifi/ps.h
+++ b/drivers/net/wireless/rtlwifi/ps.h
@@ -32,6 +32,66 @@
 
 #define MAX_SW_LPS_SLEEP_INTV	5
 
+/*---------------------------------------------
+ * 3 The value of cmd: 4 bits
+ *---------------------------------------------
+ */
+#define    PWR_CMD_READ		0x00
+#define    PWR_CMD_WRITE	0x01
+#define    PWR_CMD_POLLING	0x02
+#define    PWR_CMD_DELAY	0x03
+#define    PWR_CMD_END		0x04
+
+/* define the base address of each block */
+#define	PWR_BASEADDR_MAC	0x00
+#define	PWR_BASEADDR_USB	0x01
+#define	PWR_BASEADDR_PCIE	0x02
+#define	PWR_BASEADDR_SDIO	0x03
+
+#define	PWR_FAB_ALL_MSK		(BIT(0)|BIT(1)|BIT(2)|BIT(3))
+#define	PWR_CUT_TESTCHIP_MSK	BIT(0)
+#define	PWR_CUT_A_MSK		BIT(1)
+#define	PWR_CUT_B_MSK		BIT(2)
+#define	PWR_CUT_C_MSK		BIT(3)
+#define	PWR_CUT_D_MSK		BIT(4)
+#define	PWR_CUT_E_MSK		BIT(5)
+#define	PWR_CUT_F_MSK		BIT(6)
+#define	PWR_CUT_G_MSK		BIT(7)
+#define	PWR_CUT_ALL_MSK		0xFF
+#define PWR_INTF_SDIO_MSK	BIT(0)
+#define PWR_INTF_USB_MSK	BIT(1)
+#define PWR_INTF_PCI_MSK	BIT(2)
+#define PWR_INTF_ALL_MSK	(BIT(0)|BIT(1)|BIT(2)|BIT(3))
+
+enum pwrseq_delay_unit {
+	PWRSEQ_DELAY_US,
+	PWRSEQ_DELAY_MS,
+};
+
+struct wlan_pwr_cfg {
+	u16 offset;
+	u8 cut_msk;
+	u8 fab_msk:4;
+	u8 interface_msk:4;
+	u8 base:4;
+	u8 cmd:4;
+	u8 msk;
+	u8 value;
+};
+
+#define	GET_PWR_CFG_OFFSET(__PWR_CMD)	(__PWR_CMD.offset)
+#define	GET_PWR_CFG_CUT_MASK(__PWR_CMD)	(__PWR_CMD.cut_msk)
+#define	GET_PWR_CFG_FAB_MASK(__PWR_CMD)	(__PWR_CMD.fab_msk)
+#define	GET_PWR_CFG_INTF_MASK(__PWR_CMD)	(__PWR_CMD.interface_msk)
+#define	GET_PWR_CFG_BASE(__PWR_CMD)	(__PWR_CMD.base)
+#define	GET_PWR_CFG_CMD(__PWR_CMD)	(__PWR_CMD.cmd)
+#define	GET_PWR_CFG_MASK(__PWR_CMD)	(__PWR_CMD.msk)
+#define	GET_PWR_CFG_VALUE(__PWR_CMD)	(__PWR_CMD.value)
+
+bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
+			      u8 fab_version, u8 interface_type,
+			      struct wlan_pwr_cfg pwrcfgcmd[]);
+
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			 enum rf_pwrstate state_toset, u32 changesource);
 bool rtl_ps_enable_nic(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile b/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
index 5b194e9..a85419a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
@@ -5,7 +5,6 @@ rtl8188ee-objs :=		\
 		led.o		\
 		phy.o		\
 		pwrseq.o	\
-		pwrseqcmd.o	\
 		rf.o		\
 		sw.o		\
 		table.o		\
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index d608d75..6561805 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -41,7 +41,6 @@
 #include "fw.h"
 #include "led.h"
 #include "hw.h"
-#include "pwrseqcmd.h"
 #include "pwrseq.h"
 
 #define LLT_CONFIG		5
@@ -815,11 +814,11 @@ static bool _rtl88ee_init_mac(struct ieee80211_hw *hw)
 
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x00);
 	/* HW Power on sequence */
-	if (!rtl88_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
-					PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,
-					Rtl8188E_NIC_ENABLE_FLOW)) {
+	if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
+				      PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,
+				      Rtl8188E_NIC_ENABLE_FLOW)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-			 "init MAC Fail as rtl88_hal_pwrseqcmdparsing\n");
+			 "init MAC Fail as rtl_hal_pwrseqcmdparsing\n");
 		return false;
 	}
 
@@ -1346,9 +1345,9 @@ static void _rtl88ee_poweroff_adapter(struct ieee80211_hw *hw)
 	}
 	rtl_write_byte(rtlpriv, REG_PCIE_CTRL_REG+1, 0xFF);
 
-	rtl88_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				   PWR_INTF_PCI_MSK,
-				   Rtl8188E_NIC_LPS_ENTER_FLOW);
+	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
+				 PWR_INTF_PCI_MSK,
+				 Rtl8188E_NIC_LPS_ENTER_FLOW);
 
 	rtl_write_byte(rtlpriv, REG_RF_CTRL, 0x00);
 
@@ -1362,8 +1361,8 @@ static void _rtl88ee_poweroff_adapter(struct ieee80211_hw *hw)
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_32K_CTRL);
 	rtl_write_byte(rtlpriv, REG_32K_CTRL, (u1b_tmp & (~BIT(0))));
 
-	rtl88_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				   PWR_INTF_PCI_MSK, Rtl8188E_NIC_DISABLE_FLOW);
+	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
+				 PWR_INTF_PCI_MSK, Rtl8188E_NIC_DISABLE_FLOW);
 
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_RSV_CTRL+1);
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL+1, (u1b_tmp & (~BIT(3))));
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
index 54d4ec2..1cd6c16 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
@@ -29,6 +29,7 @@
 
 #include "../wifi.h"
 #include "../pci.h"
+#include "../core.h"
 #include "../ps.h"
 #include "reg.h"
 #include "def.h"
@@ -151,18 +152,7 @@ static bool config_bb_with_pgheader(struct ieee80211_hw *hw,
 			v2 = table_pg[i + 1];
 
 			if (v1 < 0xcdcdcdcd) {
-				if (table_pg[i] == 0xfe)
-					mdelay(50);
-				else if (table_pg[i] == 0xfd)
-					mdelay(5);
-				else if (table_pg[i] == 0xfc)
-					mdelay(1);
-				else if (table_pg[i] == 0xfb)
-					udelay(50);
-				else if (table_pg[i] == 0xfa)
-					udelay(5);
-				else if (table_pg[i] == 0xf9)
-					udelay(1);
+				rtl_addr_delay(table_pg[i]);
 
 				store_pwrindex_offset(hw, table_pg[i],
 						      table_pg[i + 1],
@@ -672,24 +662,9 @@ static void _rtl8188e_config_rf_reg(struct ieee80211_hw *hw,
 				    u32 addr, u32 data, enum radio_path rfpath,
 				    u32 regaddr)
 {
-	if (addr == 0xffe) {
-		mdelay(50);
-	} else if (addr == 0xfd) {
-		mdelay(5);
-	} else if (addr == 0xfc) {
-		mdelay(1);
-	} else if (addr == 0xfb) {
-		udelay(50);
-	} else if (addr == 0xfa) {
-		udelay(5);
-	} else if (addr == 0xf9) {
-		udelay(1);
-	} else {
-		rtl_set_rfreg(hw, rfpath, regaddr,
-			      RFREG_OFFSET_MASK,
-			      data);
-		udelay(1);
-	}
+	rtl_rfreg_delay(hw, rfpath, regaddr,
+			RFREG_OFFSET_MASK,
+			data);
 }
 
 static void rtl88_config_s(struct ieee80211_hw *hw,
@@ -702,28 +677,6 @@ static void rtl88_config_s(struct ieee80211_hw *hw,
 				addr | maskforphyset);
 }
 
-static void _rtl8188e_config_bb_reg(struct ieee80211_hw *hw,
-				    u32 addr, u32 data)
-{
-	if (addr == 0xfe) {
-		mdelay(50);
-	} else if (addr == 0xfd) {
-		mdelay(5);
-	} else if (addr == 0xfc) {
-		mdelay(1);
-	} else if (addr == 0xfb) {
-		udelay(50);
-	} else if (addr == 0xfa) {
-		udelay(5);
-	} else if (addr == 0xf9) {
-		udelay(1);
-	} else {
-		rtl_set_bbreg(hw, addr, MASKDWORD, data);
-		udelay(1);
-	}
-}
-
-
 #define NEXT_PAIR(v1, v2, i)				\
 	do {						\
 		i += 2; v1 = array_table[i];		\
@@ -795,7 +748,7 @@ static void set_baseband_phy_config(struct ieee80211_hw *hw)
 		v1 = array_table[i];
 		v2 = array_table[i + 1];
 		if (v1 < 0xcdcdcdcd) {
-			_rtl8188e_config_bb_reg(hw, v1, v2);
+			rtl_bb_delay(hw, v1, v2);
 		} else {/*This line is the start line of branch.*/
 			if (!check_cond(hw, array_table[i])) {
 				/*Discard the following (offset, data) pairs*/
@@ -811,7 +764,7 @@ static void set_baseband_phy_config(struct ieee80211_hw *hw)
 				while (v2 != 0xDEAD &&
 				       v2 != 0xCDEF &&
 				       v2 != 0xCDCD && i < arraylen - 2) {
-					_rtl8188e_config_bb_reg(hw, v1, v2);
+					rtl_bb_delay(hw, v1, v2);
 					NEXT_PAIR(v1, v2, i);
 				}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
index 028ec6d..32e135a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
@@ -30,7 +30,6 @@
 #ifndef __RTL8723E_PWRSEQ_H__
 #define __RTL8723E_PWRSEQ_H__
 
-#include "pwrseqcmd.h"
 /*
 	Check document WM-20110607-Paul-RTL8188E_Power_Architecture-R02.vsd
 	There are 6 HW Power States:
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h b/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
index d849abf..7af85cf 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
@@ -2215,22 +2215,6 @@
 #define	BWORD1					0xc
 #define	BWORD					0xf
 
-#define	MASKBYTE0				0xff
-#define	MASKBYTE1				0xff00
-#define	MASKBYTE2				0xff0000
-#define	MASKBYTE3				0xff000000
-#define	MASKHWORD				0xffff0000
-#define	MASKLWORD				0x0000ffff
-#define	MASKDWORD				0xffffffff
-#define	MASK12BITS				0xfff
-#define	MASKH4BITS				0xf0000000
-#define MASKOFDM_D				0xffc00000
-#define	MASKCCK					0x3f3f3f3f
-
-#define	MASK4BITS				0x0f
-#define	MASK20BITS				0xfffff
-#define RFREG_OFFSET_MASK			0xfffff
-
 #define	BENABLE					0x1
 #define	BDISABLE				0x0
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 73262ca..98b2230 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -30,6 +30,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
+#include "../core.h"
 #include "reg.h"
 #include "def.h"
 #include "hw.h"
@@ -198,18 +199,7 @@ bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 	}
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_reg_arraylen; i = i + 2) {
-			if (phy_regarray_table[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray_table[i]);
 			rtl_set_bbreg(hw, phy_regarray_table[i], MASKDWORD,
 				      phy_regarray_table[i + 1]);
 			udelay(1);
@@ -245,18 +235,7 @@ bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_regarray_pg_len; i = i + 3) {
-			if (phy_regarray_table_pg[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table_pg[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table_pg[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table_pg[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray_table_pg[i]);
 
 			_rtl92c_store_pwrIndex_diffrate_offset(hw,
 					       phy_regarray_table_pg[i],
@@ -305,46 +284,16 @@ bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	switch (rfpath) {
 	case RF90_PATH_A:
 		for (i = 0; i < radioa_arraylen; i = i + 2) {
-			if (radioa_array_table[i] == 0xfe)
-				mdelay(50);
-			else if (radioa_array_table[i] == 0xfd)
-				mdelay(5);
-			else if (radioa_array_table[i] == 0xfc)
-				mdelay(1);
-			else if (radioa_array_table[i] == 0xfb)
-				udelay(50);
-			else if (radioa_array_table[i] == 0xfa)
-				udelay(5);
-			else if (radioa_array_table[i] == 0xf9)
-				udelay(1);
-			else {
-				rtl_set_rfreg(hw, rfpath, radioa_array_table[i],
-					      RFREG_OFFSET_MASK,
-					      radioa_array_table[i + 1]);
-				udelay(1);
-			}
+			rtl_rfreg_delay(hw, rfpath, radioa_array_table[i],
+					RFREG_OFFSET_MASK,
+					radioa_array_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_B:
 		for (i = 0; i < radiob_arraylen; i = i + 2) {
-			if (radiob_array_table[i] == 0xfe) {
-				mdelay(50);
-			} else if (radiob_array_table[i] == 0xfd)
-				mdelay(5);
-			else if (radiob_array_table[i] == 0xfc)
-				mdelay(1);
-			else if (radiob_array_table[i] == 0xfb)
-				udelay(50);
-			else if (radiob_array_table[i] == 0xfa)
-				udelay(5);
-			else if (radiob_array_table[i] == 0xf9)
-				udelay(1);
-			else {
-				rtl_set_rfreg(hw, rfpath, radiob_array_table[i],
-					      RFREG_OFFSET_MASK,
-					      radiob_array_table[i + 1]);
-				udelay(1);
-			}
+			rtl_rfreg_delay(hw, rfpath, radiob_array_table[i],
+					RFREG_OFFSET_MASK,
+					radiob_array_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_C:
@@ -355,6 +304,8 @@ bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case not processed\n");
 		break;
+	default:
+		break;
 	}
 	return true;
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
index 8922ecb..ed703a1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -2044,22 +2044,6 @@
 #define	BWORD1					0xc
 #define	BWORD					0xf
 
-#define	MASKBYTE0				0xff
-#define	MASKBYTE1				0xff00
-#define	MASKBYTE2				0xff0000
-#define	MASKBYTE3				0xff000000
-#define	MASKHWORD				0xffff0000
-#define	MASKLWORD				0x0000ffff
-#define	MASKDWORD				0xffffffff
-#define	MASK12BITS				0xfff
-#define	MASKH4BITS				0xf0000000
-#define MASKOFDM_D				0xffc00000
-#define	MASKCCK					0x3f3f3f3f
-
-#define	MASK4BITS				0x0f
-#define	MASK20BITS				0xfffff
-#define RFREG_OFFSET_MASK			0xfffff
-
 #define	BENABLE					0x1
 #define	BDISABLE				0x0
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 0c09240..9831ff1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -30,6 +30,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
+#include "../core.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -188,18 +189,7 @@ bool _rtl92cu_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 	}
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_reg_arraylen; i = i + 2) {
-			if (phy_regarray_table[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray_table[i]);
 			rtl_set_bbreg(hw, phy_regarray_table[i], MASKDWORD,
 				      phy_regarray_table[i + 1]);
 			udelay(1);
@@ -236,18 +226,7 @@ bool _rtl92cu_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 	phy_regarray_table_pg = rtlphy->hwparam_tables[PHY_REG_PG].pdata;
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_regarray_pg_len; i = i + 3) {
-			if (phy_regarray_table_pg[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table_pg[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table_pg[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table_pg[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray_table_pg[i]);
 			_rtl92c_store_pwrIndex_diffrate_offset(hw,
 						  phy_regarray_table_pg[i],
 						  phy_regarray_table_pg[i + 1],
@@ -294,46 +273,16 @@ bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	switch (rfpath) {
 	case RF90_PATH_A:
 		for (i = 0; i < radioa_arraylen; i = i + 2) {
-			if (radioa_array_table[i] == 0xfe)
-				mdelay(50);
-			else if (radioa_array_table[i] == 0xfd)
-				mdelay(5);
-			else if (radioa_array_table[i] == 0xfc)
-				mdelay(1);
-			else if (radioa_array_table[i] == 0xfb)
-				udelay(50);
-			else if (radioa_array_table[i] == 0xfa)
-				udelay(5);
-			else if (radioa_array_table[i] == 0xf9)
-				udelay(1);
-			else {
-				rtl_set_rfreg(hw, rfpath, radioa_array_table[i],
-					      RFREG_OFFSET_MASK,
-					      radioa_array_table[i + 1]);
-				udelay(1);
-			}
+			rtl_rfreg_delay(hw, rfpath, radioa_array_table[i],
+					RFREG_OFFSET_MASK,
+					radioa_array_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_B:
 		for (i = 0; i < radiob_arraylen; i = i + 2) {
-			if (radiob_array_table[i] == 0xfe) {
-				mdelay(50);
-			} else if (radiob_array_table[i] == 0xfd)
-				mdelay(5);
-			else if (radiob_array_table[i] == 0xfc)
-				mdelay(1);
-			else if (radiob_array_table[i] == 0xfb)
-				udelay(50);
-			else if (radiob_array_table[i] == 0xfa)
-				udelay(5);
-			else if (radiob_array_table[i] == 0xf9)
-				udelay(1);
-			else {
-				rtl_set_rfreg(hw, rfpath, radiob_array_table[i],
-					      RFREG_OFFSET_MASK,
-					      radiob_array_table[i + 1]);
-				udelay(1);
-			}
+			rtl_rfreg_delay(hw, rfpath, radiob_array_table[i],
+					RFREG_OFFSET_MASK,
+					radiob_array_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_C:
@@ -344,6 +293,8 @@ bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case not processed\n");
 		break;
+	default:
+		break;
 	}
 	return true;
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index 7908e1c..304c443 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -194,15 +194,15 @@ static void rtl92d_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 	rtl_set_bbreg(hw, ROFDM0_LSTF, BIT(31), 1); /* hold page C counter */
 	rtl_set_bbreg(hw, ROFDM1_LSTF, BIT(31), 1); /*hold page D counter */
 
-	ret_value = rtl_get_bbreg(hw, ROFDM0_FRAMESYNC, BMASKDWORD);
+	ret_value = rtl_get_bbreg(hw, ROFDM0_FRAMESYNC, MASKDWORD);
 	falsealm_cnt->cnt_fast_fsync_fail = (ret_value & 0xffff);
 	falsealm_cnt->cnt_sb_search_fail = ((ret_value & 0xffff0000) >> 16);
-	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER1, BMASKDWORD);
+	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER1, MASKDWORD);
 	falsealm_cnt->cnt_parity_fail = ((ret_value & 0xffff0000) >> 16);
-	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER2, BMASKDWORD);
+	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER2, MASKDWORD);
 	falsealm_cnt->cnt_rate_illegal = (ret_value & 0xffff);
 	falsealm_cnt->cnt_crc8_fail = ((ret_value & 0xffff0000) >> 16);
-	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER3, BMASKDWORD);
+	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER3, MASKDWORD);
 	falsealm_cnt->cnt_mcs_fail = (ret_value & 0xffff);
 	falsealm_cnt->cnt_ofdm_fail = falsealm_cnt->cnt_parity_fail +
 				      falsealm_cnt->cnt_rate_illegal +
@@ -214,9 +214,9 @@ static void rtl92d_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 	if (rtlpriv->rtlhal.current_bandtype != BAND_ON_5G) {
 		/* hold cck counter */
 		rtl92d_acquire_cckandrw_pagea_ctl(hw, &flag);
-		ret_value = rtl_get_bbreg(hw, RCCK0_FACOUNTERLOWER, BMASKBYTE0);
+		ret_value = rtl_get_bbreg(hw, RCCK0_FACOUNTERLOWER, MASKBYTE0);
 		falsealm_cnt->cnt_cck_fail = ret_value;
-		ret_value = rtl_get_bbreg(hw, RCCK0_FACOUNTERUPPER, BMASKBYTE3);
+		ret_value = rtl_get_bbreg(hw, RCCK0_FACOUNTERUPPER, MASKBYTE3);
 		falsealm_cnt->cnt_cck_fail += (ret_value & 0xff) << 8;
 		rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
 	} else {
@@ -331,11 +331,11 @@ static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 	if (de_digtable->pre_cck_pd_state != de_digtable->cur_cck_pd_state) {
 		if (de_digtable->cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
 			rtl92d_acquire_cckandrw_pagea_ctl(hw, &flag);
-			rtl_set_bbreg(hw, RCCK0_CCA, BMASKBYTE2, 0x83);
+			rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2, 0x83);
 			rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
 		} else {
 			rtl92d_acquire_cckandrw_pagea_ctl(hw, &flag);
-			rtl_set_bbreg(hw, RCCK0_CCA, BMASKBYTE2, 0xcd);
+			rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2, 0xcd);
 			rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
 		}
 		de_digtable->pre_cck_pd_state = de_digtable->cur_cck_pd_state;
@@ -722,7 +722,7 @@ static void rtl92d_dm_rxgain_tracking_thermalmeter(struct ieee80211_hw *hw)
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		 "===> Rx Gain %x\n", u4tmp);
 	for (i = RF90_PATH_A; i < rtlpriv->phy.num_total_rfpath; i++)
-		rtl_set_rfreg(hw, i, 0x3C, BRFREGOFFSETMASK,
+		rtl_set_rfreg(hw, i, 0x3C, RFREG_OFFSET_MASK,
 			      (rtlpriv->phy.reg_rf3c[i] & (~(0xF000))) | u4tmp);
 }
 
@@ -737,7 +737,7 @@ static void rtl92d_bandtype_2_4G(struct ieee80211_hw *hw, long *temp_cckg,
 	/* Query CCK default setting From 0xa24 */
 	rtl92d_acquire_cckandrw_pagea_ctl(hw, &flag);
 	temp_cck = rtl_get_bbreg(hw, RCCK0_TXFILTER2,
-				 BMASKDWORD) & BMASKCCK;
+				 MASKDWORD) & MASKCCK;
 	rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
 	for (i = 0; i < CCK_TABLE_LENGTH; i++) {
 		if (rtlpriv->dm.cck_inch14) {
@@ -896,9 +896,9 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 		rf = 1;
 	if (thermalvalue) {
 		ele_d = rtl_get_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
-				      BMASKDWORD) & BMASKOFDM_D;
+				      MASKDWORD) & MASKOFDM_D;
 		for (i = 0; i < OFDM_TABLE_SIZE_92D; i++) {
-			if (ele_d == (ofdmswing_table[i] & BMASKOFDM_D)) {
+			if (ele_d == (ofdmswing_table[i] & MASKOFDM_D)) {
 				ofdm_index_old[0] = (u8) i;
 
 				RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
@@ -910,10 +910,10 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 		}
 		if (is2t) {
 			ele_d = rtl_get_bbreg(hw, ROFDM0_XBTxIQIMBALANCE,
-					      BMASKDWORD) & BMASKOFDM_D;
+					      MASKDWORD) & MASKOFDM_D;
 			for (i = 0; i < OFDM_TABLE_SIZE_92D; i++) {
 				if (ele_d ==
-				    (ofdmswing_table[i] & BMASKOFDM_D)) {
+				    (ofdmswing_table[i] & MASKOFDM_D)) {
 					ofdm_index_old[1] = (u8) i;
 					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
 						 DBG_LOUD,
@@ -1091,10 +1091,10 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 				value32 = (ele_d << 22) | ((ele_c & 0x3F) <<
 					  16) | ele_a;
 				rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
-					      BMASKDWORD, value32);
+					      MASKDWORD, value32);
 
 				value32 = (ele_c & 0x000003C0) >> 6;
-				rtl_set_bbreg(hw, ROFDM0_XCTxAFE, BMASKH4BITS,
+				rtl_set_bbreg(hw, ROFDM0_XCTxAFE, MASKH4BITS,
 					      value32);
 
 				value32 = ((val_x * ele_d) >> 7) & 0x01;
@@ -1103,10 +1103,10 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 
 			} else {
 				rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
-					      BMASKDWORD,
+					      MASKDWORD,
 					      ofdmswing_table
 					      [(u8)ofdm_index[0]]);
-				rtl_set_bbreg(hw, ROFDM0_XCTxAFE, BMASKH4BITS,
+				rtl_set_bbreg(hw, ROFDM0_XCTxAFE, MASKH4BITS,
 					      0x00);
 				rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD,
 					      BIT(24), 0x00);
@@ -1204,21 +1204,21 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 						  ele_a;
 					rtl_set_bbreg(hw,
 						      ROFDM0_XBTxIQIMBALANCE,
-						      BMASKDWORD, value32);
+						      MASKDWORD, value32);
 					value32 = (ele_c & 0x000003C0) >> 6;
 					rtl_set_bbreg(hw, ROFDM0_XDTxAFE,
-						      BMASKH4BITS, value32);
+						      MASKH4BITS, value32);
 					value32 = ((val_x * ele_d) >> 7) & 0x01;
 					rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD,
 						      BIT(28), value32);
 				} else {
 					rtl_set_bbreg(hw,
 						      ROFDM0_XBTxIQIMBALANCE,
-						      BMASKDWORD,
+						      MASKDWORD,
 						      ofdmswing_table
 						      [(u8) ofdm_index[1]]);
 					rtl_set_bbreg(hw, ROFDM0_XDTxAFE,
-						      BMASKH4BITS, 0x00);
+						      MASKH4BITS, 0x00);
 					rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD,
 						      BIT(28), 0x00);
 				}
@@ -1229,10 +1229,10 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 			}
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 				 "TxPwrTracking 0xc80 = 0x%x, 0xc94 = 0x%x RF 0x24 = 0x%x\n",
-				 rtl_get_bbreg(hw, 0xc80, BMASKDWORD),
-				 rtl_get_bbreg(hw, 0xc94, BMASKDWORD),
+				 rtl_get_bbreg(hw, 0xc80, MASKDWORD),
+				 rtl_get_bbreg(hw, 0xc94, MASKDWORD),
 				 rtl_get_rfreg(hw, RF90_PATH_A, 0x24,
-					       BRFREGOFFSETMASK));
+					       RFREG_OFFSET_MASK));
 		}
 		if ((delta_iqk > rtlefuse->delta_iqk) &&
 		    (rtlefuse->delta_iqk != 0)) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index c9f6ee7..2b08671 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -985,9 +985,9 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
 	/* set default value after initialize RF,  */
 	rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER4, 0x00f00000, 0);
 	rtlphy->rfreg_chnlval[0] = rtl_get_rfreg(hw, (enum radio_path)0,
-			RF_CHNLBW, BRFREGOFFSETMASK);
+			RF_CHNLBW, RFREG_OFFSET_MASK);
 	rtlphy->rfreg_chnlval[1] = rtl_get_rfreg(hw, (enum radio_path)1,
-			RF_CHNLBW, BRFREGOFFSETMASK);
+			RF_CHNLBW, RFREG_OFFSET_MASK);
 
 	/*---- Set CCK and OFDM Block "ON"----*/
 	if (rtlhal->current_bandtype == BAND_ON_2_4G)
@@ -1035,7 +1035,7 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
 
 				tmp_rega = rtl_get_rfreg(hw,
 						  (enum radio_path)RF90_PATH_A,
-						  0x2a, BMASKDWORD);
+						  0x2a, MASKDWORD);
 
 				if (((tmp_rega & BIT(11)) == BIT(11)))
 					break;
@@ -1334,13 +1334,13 @@ void rtl92de_card_disable(struct ieee80211_hw *hw)
 	/* c. ========RF OFF sequence==========  */
 	/* 0x88c[23:20] = 0xf. */
 	rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER4, 0x00f00000, 0xf);
-	rtl_set_rfreg(hw, RF90_PATH_A, 0x00, BRFREGOFFSETMASK, 0x00);
+	rtl_set_rfreg(hw, RF90_PATH_A, 0x00, RFREG_OFFSET_MASK, 0x00);
 
 	/* APSD_CTRL 0x600[7:0] = 0x40 */
 	rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
 
 	/* Close antenna 0,0xc04,0xd04 */
-	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, BMASKBYTE0, 0);
+	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, MASKBYTE0, 0);
 	rtl_set_bbreg(hw, ROFDM1_TRXPATHENABLE, BDWORD, 0);
 
 	/*  SYS_FUNC_EN 0x02[7:0] = 0xE2   reset BB state machine */
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
index 13196cc..3d1f0dd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -30,6 +30,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
+#include "../core.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -242,7 +243,7 @@ void rtl92d_phy_set_bb_reg(struct ieee80211_hw *hw,
 	else if (rtlhal->during_mac0init_radiob)
 		/* mac0 use phy1 write radio_b. */
 		dbi_direct = BIT(3) | BIT(2);
-	if (bitmask != BMASKDWORD) {
+	if (bitmask != MASKDWORD) {
 		if (rtlhal->during_mac1init_radioa ||
 		    rtlhal->during_mac0init_radiob)
 			originalvalue = rtl92de_read_dword_dbi(hw,
@@ -275,20 +276,20 @@ static u32 _rtl92d_phy_rf_serial_read(struct ieee80211_hw *hw,
 	u32 retvalue;
 
 	newoffset = offset;
-	tmplong = rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, BMASKDWORD);
+	tmplong = rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD);
 	if (rfpath == RF90_PATH_A)
 		tmplong2 = tmplong;
 	else
-		tmplong2 = rtl_get_bbreg(hw, pphyreg->rfhssi_para2, BMASKDWORD);
+		tmplong2 = rtl_get_bbreg(hw, pphyreg->rfhssi_para2, MASKDWORD);
 	tmplong2 = (tmplong2 & (~BLSSIREADADDRESS)) |
 		(newoffset << 23) | BLSSIREADEDGE;
-	rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, BMASKDWORD,
+	rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD,
 		tmplong & (~BLSSIREADEDGE));
 	udelay(10);
-	rtl_set_bbreg(hw, pphyreg->rfhssi_para2, BMASKDWORD, tmplong2);
+	rtl_set_bbreg(hw, pphyreg->rfhssi_para2, MASKDWORD, tmplong2);
 	udelay(50);
 	udelay(50);
-	rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, BMASKDWORD,
+	rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD,
 		tmplong | BLSSIREADEDGE);
 	udelay(10);
 	if (rfpath == RF90_PATH_A)
@@ -321,7 +322,7 @@ static void _rtl92d_phy_rf_serial_write(struct ieee80211_hw *hw,
 	newoffset = offset;
 	/* T65 RF */
 	data_and_addr = ((newoffset << 20) | (data & 0x000fffff)) & 0x0fffffff;
-	rtl_set_bbreg(hw, pphyreg->rf3wire_offset, BMASKDWORD, data_and_addr);
+	rtl_set_bbreg(hw, pphyreg->rf3wire_offset, MASKDWORD, data_and_addr);
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, "RFW-%d Addr[0x%x]=0x%x\n",
 		 rfpath, pphyreg->rf3wire_offset, data_and_addr);
 }
@@ -362,7 +363,7 @@ void rtl92d_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 		return;
 	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
 	if (rtlphy->rf_mode != RF_OP_BY_FW) {
-		if (bitmask != BRFREGOFFSETMASK) {
+		if (bitmask != RFREG_OFFSET_MASK) {
 			original_value = _rtl92d_phy_rf_serial_read(hw,
 				rfpath, regaddr);
 			bitshift = _rtl92d_phy_calculate_bit_shift(bitmask);
@@ -567,19 +568,8 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 		 " ===> phy:Rtl819XPHY_REG_Array_PG\n");
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_reg_arraylen; i = i + 2) {
-			if (phy_regarray_table[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table[i] == 0xf9)
-				udelay(1);
-			rtl_set_bbreg(hw, phy_regarray_table[i], BMASKDWORD,
+			rtl_addr_delay(phy_regarray_table[i]);
+			rtl_set_bbreg(hw, phy_regarray_table[i], MASKDWORD,
 				      phy_regarray_table[i + 1]);
 			udelay(1);
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
@@ -591,7 +581,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 		if (rtlhal->interfaceindex == 0) {
 			for (i = 0; i < agctab_arraylen; i = i + 2) {
 				rtl_set_bbreg(hw, agctab_array_table[i],
-					BMASKDWORD,
+					MASKDWORD,
 					agctab_array_table[i + 1]);
 				/* Add 1us delay between BB/RF register
 				 * setting. */
@@ -607,7 +597,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 			if (rtlhal->current_bandtype == BAND_ON_2_4G) {
 				for (i = 0; i < agctab_arraylen; i = i + 2) {
 					rtl_set_bbreg(hw, agctab_array_table[i],
-						BMASKDWORD,
+						MASKDWORD,
 						agctab_array_table[i + 1]);
 					/* Add 1us delay between BB/RF register
 					 * setting. */
@@ -623,7 +613,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 				for (i = 0; i < agctab_5garraylen; i = i + 2) {
 					rtl_set_bbreg(hw,
 						agctab_5garray_table[i],
-						BMASKDWORD,
+						MASKDWORD,
 						agctab_5garray_table[i + 1]);
 					/* Add 1us delay between BB/RF registeri
 					 * setting. */
@@ -705,18 +695,7 @@ static bool _rtl92d_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 	phy_regarray_table_pg = rtl8192de_phy_reg_array_pg;
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_regarray_pg_len; i = i + 3) {
-			if (phy_regarray_table_pg[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table_pg[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table_pg[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table_pg[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray_table_pg[i]);
 			_rtl92d_store_pwrindex_diffrate_offset(hw,
 				phy_regarray_table_pg[i],
 				phy_regarray_table_pg[i + 1],
@@ -843,54 +822,16 @@ bool rtl92d_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	switch (rfpath) {
 	case RF90_PATH_A:
 		for (i = 0; i < radioa_arraylen; i = i + 2) {
-			if (radioa_array_table[i] == 0xfe) {
-				mdelay(50);
-			} else if (radioa_array_table[i] == 0xfd) {
-				/* delay_ms(5); */
-				mdelay(5);
-			} else if (radioa_array_table[i] == 0xfc) {
-				/* delay_ms(1); */
-				mdelay(1);
-			} else if (radioa_array_table[i] == 0xfb) {
-				udelay(50);
-			} else if (radioa_array_table[i] == 0xfa) {
-				udelay(5);
-			} else if (radioa_array_table[i] == 0xf9) {
-				udelay(1);
-			} else {
-				rtl_set_rfreg(hw, rfpath, radioa_array_table[i],
-					      BRFREGOFFSETMASK,
-					      radioa_array_table[i + 1]);
-				/*  Add 1us delay between BB/RF register set. */
-				udelay(1);
-			}
+			rtl_rfreg_delay(hw, rfpath, radioa_array_table[i],
+					RFREG_OFFSET_MASK,
+					radioa_array_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_B:
 		for (i = 0; i < radiob_arraylen; i = i + 2) {
-			if (radiob_array_table[i] == 0xfe) {
-				/* Delay specific ms. Only RF configuration
-				 * requires delay. */
-				mdelay(50);
-			} else if (radiob_array_table[i] == 0xfd) {
-				/* delay_ms(5); */
-				mdelay(5);
-			} else if (radiob_array_table[i] == 0xfc) {
-				/* delay_ms(1); */
-				mdelay(1);
-			} else if (radiob_array_table[i] == 0xfb) {
-				udelay(50);
-			} else if (radiob_array_table[i] == 0xfa) {
-				udelay(5);
-			} else if (radiob_array_table[i] == 0xf9) {
-				udelay(1);
-			} else {
-				rtl_set_rfreg(hw, rfpath, radiob_array_table[i],
-					      BRFREGOFFSETMASK,
-					      radiob_array_table[i + 1]);
-				/*  Add 1us delay between BB/RF register set. */
-				udelay(1);
-			}
+			rtl_rfreg_delay(hw, rfpath, radiob_array_table[i],
+					RFREG_OFFSET_MASK,
+					radiob_array_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_C:
@@ -911,13 +852,13 @@ void rtl92d_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 
 	rtlphy->default_initialgain[0] =
-	    (u8) rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1, BMASKBYTE0);
+	    (u8) rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1, MASKBYTE0);
 	rtlphy->default_initialgain[1] =
-	    (u8) rtl_get_bbreg(hw, ROFDM0_XBAGCCORE1, BMASKBYTE0);
+	    (u8) rtl_get_bbreg(hw, ROFDM0_XBAGCCORE1, MASKBYTE0);
 	rtlphy->default_initialgain[2] =
-	    (u8) rtl_get_bbreg(hw, ROFDM0_XCAGCCORE1, BMASKBYTE0);
+	    (u8) rtl_get_bbreg(hw, ROFDM0_XCAGCCORE1, MASKBYTE0);
 	rtlphy->default_initialgain[3] =
-	    (u8) rtl_get_bbreg(hw, ROFDM0_XDAGCCORE1, BMASKBYTE0);
+	    (u8) rtl_get_bbreg(hw, ROFDM0_XDAGCCORE1, MASKBYTE0);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 		 "Default initial gain (c50=0x%x, c58=0x%x, c60=0x%x, c68=0x%x\n",
 		 rtlphy->default_initialgain[0],
@@ -925,9 +866,9 @@ void rtl92d_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
 		 rtlphy->default_initialgain[2],
 		 rtlphy->default_initialgain[3]);
 	rtlphy->framesync = (u8)rtl_get_bbreg(hw, ROFDM0_RXDETECTOR3,
-					      BMASKBYTE0);
+					      MASKBYTE0);
 	rtlphy->framesync_c34 = rtl_get_bbreg(hw, ROFDM0_RXDETECTOR2,
-					      BMASKDWORD);
+					      MASKDWORD);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 		 "Default framesync (0x%x) = 0x%x\n",
 		 ROFDM0_RXDETECTOR3, rtlphy->framesync);
@@ -1106,7 +1047,7 @@ static void _rtl92d_phy_stop_trx_before_changeband(struct ieee80211_hw *hw)
 {
 	rtl_set_bbreg(hw, RFPGA0_RFMOD, BCCKEN, 0);
 	rtl_set_bbreg(hw, RFPGA0_RFMOD, BOFDMEN, 0);
-	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, BMASKBYTE0, 0x00);
+	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, MASKBYTE0, 0x00);
 	rtl_set_bbreg(hw, ROFDM1_TRXPATHENABLE, BDWORD, 0x0);
 }
 
@@ -1168,7 +1109,7 @@ static void _rtl92d_phy_reload_imr_setting(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 imr_num = MAX_RF_IMR_INDEX;
-	u32 rfmask = BRFREGOFFSETMASK;
+	u32 rfmask = RFREG_OFFSET_MASK;
 	u8 group, i;
 	unsigned long flag = 0;
 
@@ -1211,7 +1152,7 @@ static void _rtl92d_phy_reload_imr_setting(struct ieee80211_hw *hw,
 			for (i = 0; i < imr_num; i++) {
 				rtl_set_rfreg(hw, (enum radio_path)rfpath,
 					      rf_reg_for_5g_swchnl_normal[i],
-					      BRFREGOFFSETMASK,
+					      RFREG_OFFSET_MASK,
 					      rf_imr_param_normal[0][0][i]);
 			}
 			rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER4,
@@ -1329,7 +1270,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 			if (i == 0 && (rtlhal->macphymode == DUALMAC_DUALPHY)) {
 				rtl_set_rfreg(hw, (enum radio_path)path,
 					      rf_reg_for_c_cut_5g[i],
-					      BRFREGOFFSETMASK, 0xE439D);
+					      RFREG_OFFSET_MASK, 0xE439D);
 			} else if (rf_reg_for_c_cut_5g[i] == RF_SYN_G4) {
 				u4tmp2 = (rf_reg_pram_c_5g[index][i] &
 				     0x7FF) | (u4tmp << 11);
@@ -1337,11 +1278,11 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 					u4tmp2 &= ~(BIT(7) | BIT(6));
 				rtl_set_rfreg(hw, (enum radio_path)path,
 					      rf_reg_for_c_cut_5g[i],
-					      BRFREGOFFSETMASK, u4tmp2);
+					      RFREG_OFFSET_MASK, u4tmp2);
 			} else {
 				rtl_set_rfreg(hw, (enum radio_path)path,
 					      rf_reg_for_c_cut_5g[i],
-					      BRFREGOFFSETMASK,
+					      RFREG_OFFSET_MASK,
 					      rf_reg_pram_c_5g[index][i]);
 			}
 			RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
@@ -1351,7 +1292,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 				 path, index,
 				 rtl_get_rfreg(hw, (enum radio_path)path,
 					       rf_reg_for_c_cut_5g[i],
-					       BRFREGOFFSETMASK));
+					       RFREG_OFFSET_MASK));
 		}
 		if (need_pwr_down)
 			_rtl92d_phy_restore_rf_env(hw, path, &u4regvalue);
@@ -1381,7 +1322,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 				     i++) {
 					rtl_set_rfreg(hw, rfpath,
 						rf_for_c_cut_5g_internal_pa[i],
-						BRFREGOFFSETMASK,
+						RFREG_OFFSET_MASK,
 						rf_pram_c_5g_int_pa[index][i]);
 					RT_TRACE(rtlpriv, COMP_RF, DBG_LOUD,
 						 "offset 0x%x value 0x%x path %d index %d\n",
@@ -1422,13 +1363,13 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 			if (rf_reg_for_c_cut_2g[i] == RF_SYN_G7)
 				rtl_set_rfreg(hw, (enum radio_path)path,
 					rf_reg_for_c_cut_2g[i],
-					BRFREGOFFSETMASK,
+					RFREG_OFFSET_MASK,
 					(rf_reg_param_for_c_cut_2g[index][i] |
 					BIT(17)));
 			else
 				rtl_set_rfreg(hw, (enum radio_path)path,
 					      rf_reg_for_c_cut_2g[i],
-					      BRFREGOFFSETMASK,
+					      RFREG_OFFSET_MASK,
 					      rf_reg_param_for_c_cut_2g
 					      [index][i]);
 			RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
@@ -1438,14 +1379,14 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 				 rf_reg_mask_for_c_cut_2g[i], path, index,
 				 rtl_get_rfreg(hw, (enum radio_path)path,
 					       rf_reg_for_c_cut_2g[i],
-					       BRFREGOFFSETMASK));
+					       RFREG_OFFSET_MASK));
 		}
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"cosa ver 3 set RF-B, 2G, 0x28 = 0x%x !!\n",
 			rf_syn_g4_for_c_cut_2g | (u4tmp << 11));
 
 		rtl_set_rfreg(hw, (enum radio_path)path, RF_SYN_G4,
-			      BRFREGOFFSETMASK,
+			      RFREG_OFFSET_MASK,
 			      rf_syn_g4_for_c_cut_2g | (u4tmp << 11));
 		if (need_pwr_down)
 			_rtl92d_phy_restore_rf_env(hw, path, &u4regvalue);
@@ -1493,41 +1434,41 @@ static u8 _rtl92d_phy_patha_iqk(struct ieee80211_hw *hw, bool configpathb)
 	/* path-A IQK setting */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path-A IQK setting!\n");
 	if (rtlhal->interfaceindex == 0) {
-		rtl_set_bbreg(hw, 0xe30, BMASKDWORD, 0x10008c1f);
-		rtl_set_bbreg(hw, 0xe34, BMASKDWORD, 0x10008c1f);
+		rtl_set_bbreg(hw, 0xe30, MASKDWORD, 0x10008c1f);
+		rtl_set_bbreg(hw, 0xe34, MASKDWORD, 0x10008c1f);
 	} else {
-		rtl_set_bbreg(hw, 0xe30, BMASKDWORD, 0x10008c22);
-		rtl_set_bbreg(hw, 0xe34, BMASKDWORD, 0x10008c22);
+		rtl_set_bbreg(hw, 0xe30, MASKDWORD, 0x10008c22);
+		rtl_set_bbreg(hw, 0xe34, MASKDWORD, 0x10008c22);
 	}
-	rtl_set_bbreg(hw, 0xe38, BMASKDWORD, 0x82140102);
-	rtl_set_bbreg(hw, 0xe3c, BMASKDWORD, 0x28160206);
+	rtl_set_bbreg(hw, 0xe38, MASKDWORD, 0x82140102);
+	rtl_set_bbreg(hw, 0xe3c, MASKDWORD, 0x28160206);
 	/* path-B IQK setting */
 	if (configpathb) {
-		rtl_set_bbreg(hw, 0xe50, BMASKDWORD, 0x10008c22);
-		rtl_set_bbreg(hw, 0xe54, BMASKDWORD, 0x10008c22);
-		rtl_set_bbreg(hw, 0xe58, BMASKDWORD, 0x82140102);
-		rtl_set_bbreg(hw, 0xe5c, BMASKDWORD, 0x28160206);
+		rtl_set_bbreg(hw, 0xe50, MASKDWORD, 0x10008c22);
+		rtl_set_bbreg(hw, 0xe54, MASKDWORD, 0x10008c22);
+		rtl_set_bbreg(hw, 0xe58, MASKDWORD, 0x82140102);
+		rtl_set_bbreg(hw, 0xe5c, MASKDWORD, 0x28160206);
 	}
 	/* LO calibration setting */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "LO calibration setting!\n");
-	rtl_set_bbreg(hw, 0xe4c, BMASKDWORD, 0x00462911);
+	rtl_set_bbreg(hw, 0xe4c, MASKDWORD, 0x00462911);
 	/* One shot, path A LOK & IQK */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "One shot, path A LOK & IQK!\n");
-	rtl_set_bbreg(hw, 0xe48, BMASKDWORD, 0xf9000000);
-	rtl_set_bbreg(hw, 0xe48, BMASKDWORD, 0xf8000000);
+	rtl_set_bbreg(hw, 0xe48, MASKDWORD, 0xf9000000);
+	rtl_set_bbreg(hw, 0xe48, MASKDWORD, 0xf8000000);
 	/* delay x ms */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		"Delay %d ms for One shot, path A LOK & IQK\n",
 		IQK_DELAY_TIME);
 	mdelay(IQK_DELAY_TIME);
 	/* Check failed */
-	regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
+	regeac = rtl_get_bbreg(hw, 0xeac, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xeac = 0x%x\n", regeac);
-	rege94 = rtl_get_bbreg(hw, 0xe94, BMASKDWORD);
+	rege94 = rtl_get_bbreg(hw, 0xe94, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xe94 = 0x%x\n", rege94);
-	rege9c = rtl_get_bbreg(hw, 0xe9c, BMASKDWORD);
+	rege9c = rtl_get_bbreg(hw, 0xe9c, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xe9c = 0x%x\n", rege9c);
-	regea4 = rtl_get_bbreg(hw, 0xea4, BMASKDWORD);
+	regea4 = rtl_get_bbreg(hw, 0xea4, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xea4 = 0x%x\n", regea4);
 	if (!(regeac & BIT(28)) && (((rege94 & 0x03FF0000) >> 16) != 0x142) &&
 	    (((rege9c & 0x03FF0000) >> 16) != 0x42))
@@ -1563,42 +1504,42 @@ static u8 _rtl92d_phy_patha_iqk_5g_normal(struct ieee80211_hw *hw,
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path A IQK!\n");
 	/* path-A IQK setting */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path-A IQK setting!\n");
-	rtl_set_bbreg(hw, 0xe30, BMASKDWORD, 0x18008c1f);
-	rtl_set_bbreg(hw, 0xe34, BMASKDWORD, 0x18008c1f);
-	rtl_set_bbreg(hw, 0xe38, BMASKDWORD, 0x82140307);
-	rtl_set_bbreg(hw, 0xe3c, BMASKDWORD, 0x68160960);
+	rtl_set_bbreg(hw, 0xe30, MASKDWORD, 0x18008c1f);
+	rtl_set_bbreg(hw, 0xe34, MASKDWORD, 0x18008c1f);
+	rtl_set_bbreg(hw, 0xe38, MASKDWORD, 0x82140307);
+	rtl_set_bbreg(hw, 0xe3c, MASKDWORD, 0x68160960);
 	/* path-B IQK setting */
 	if (configpathb) {
-		rtl_set_bbreg(hw, 0xe50, BMASKDWORD, 0x18008c2f);
-		rtl_set_bbreg(hw, 0xe54, BMASKDWORD, 0x18008c2f);
-		rtl_set_bbreg(hw, 0xe58, BMASKDWORD, 0x82110000);
-		rtl_set_bbreg(hw, 0xe5c, BMASKDWORD, 0x68110000);
+		rtl_set_bbreg(hw, 0xe50, MASKDWORD, 0x18008c2f);
+		rtl_set_bbreg(hw, 0xe54, MASKDWORD, 0x18008c2f);
+		rtl_set_bbreg(hw, 0xe58, MASKDWORD, 0x82110000);
+		rtl_set_bbreg(hw, 0xe5c, MASKDWORD, 0x68110000);
 	}
 	/* LO calibration setting */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "LO calibration setting!\n");
-	rtl_set_bbreg(hw, 0xe4c, BMASKDWORD, 0x00462911);
+	rtl_set_bbreg(hw, 0xe4c, MASKDWORD, 0x00462911);
 	/* path-A PA on */
-	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, BMASKDWORD, 0x07000f60);
-	rtl_set_bbreg(hw, RFPGA0_XA_RFINTERFACEOE, BMASKDWORD, 0x66e60e30);
+	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, MASKDWORD, 0x07000f60);
+	rtl_set_bbreg(hw, RFPGA0_XA_RFINTERFACEOE, MASKDWORD, 0x66e60e30);
 	for (i = 0; i < retrycount; i++) {
 		/* One shot, path A LOK & IQK */
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"One shot, path A LOK & IQK!\n");
-		rtl_set_bbreg(hw, 0xe48, BMASKDWORD, 0xf9000000);
-		rtl_set_bbreg(hw, 0xe48, BMASKDWORD, 0xf8000000);
+		rtl_set_bbreg(hw, 0xe48, MASKDWORD, 0xf9000000);
+		rtl_set_bbreg(hw, 0xe48, MASKDWORD, 0xf8000000);
 		/* delay x ms */
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"Delay %d ms for One shot, path A LOK & IQK.\n",
 			IQK_DELAY_TIME);
 		mdelay(IQK_DELAY_TIME * 10);
 		/* Check failed */
-		regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
+		regeac = rtl_get_bbreg(hw, 0xeac, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xeac = 0x%x\n", regeac);
-		rege94 = rtl_get_bbreg(hw, 0xe94, BMASKDWORD);
+		rege94 = rtl_get_bbreg(hw, 0xe94, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xe94 = 0x%x\n", rege94);
-		rege9c = rtl_get_bbreg(hw, 0xe9c, BMASKDWORD);
+		rege9c = rtl_get_bbreg(hw, 0xe9c, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xe9c = 0x%x\n", rege9c);
-		regea4 = rtl_get_bbreg(hw, 0xea4, BMASKDWORD);
+		regea4 = rtl_get_bbreg(hw, 0xea4, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xea4 = 0x%x\n", regea4);
 		if (!(regeac & TxOKBit) &&
 		     (((rege94 & 0x03FF0000) >> 16) != 0x142)) {
@@ -1620,9 +1561,9 @@ static u8 _rtl92d_phy_patha_iqk_5g_normal(struct ieee80211_hw *hw,
 		}
 	}
 	/* path A PA off */
-	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, BMASKDWORD,
+	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, MASKDWORD,
 		      rtlphy->iqk_bb_backup[0]);
-	rtl_set_bbreg(hw, RFPGA0_XA_RFINTERFACEOE, BMASKDWORD,
+	rtl_set_bbreg(hw, RFPGA0_XA_RFINTERFACEOE, MASKDWORD,
 		      rtlphy->iqk_bb_backup[1]);
 	return result;
 }
@@ -1637,22 +1578,22 @@ static u8 _rtl92d_phy_pathb_iqk(struct ieee80211_hw *hw)
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path B IQK!\n");
 	/* One shot, path B LOK & IQK */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "One shot, path A LOK & IQK!\n");
-	rtl_set_bbreg(hw, 0xe60, BMASKDWORD, 0x00000002);
-	rtl_set_bbreg(hw, 0xe60, BMASKDWORD, 0x00000000);
+	rtl_set_bbreg(hw, 0xe60, MASKDWORD, 0x00000002);
+	rtl_set_bbreg(hw, 0xe60, MASKDWORD, 0x00000000);
 	/* delay x ms  */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		"Delay %d ms for One shot, path B LOK & IQK\n", IQK_DELAY_TIME);
 	mdelay(IQK_DELAY_TIME);
 	/* Check failed */
-	regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
+	regeac = rtl_get_bbreg(hw, 0xeac, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xeac = 0x%x\n", regeac);
-	regeb4 = rtl_get_bbreg(hw, 0xeb4, BMASKDWORD);
+	regeb4 = rtl_get_bbreg(hw, 0xeb4, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xeb4 = 0x%x\n", regeb4);
-	regebc = rtl_get_bbreg(hw, 0xebc, BMASKDWORD);
+	regebc = rtl_get_bbreg(hw, 0xebc, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xebc = 0x%x\n", regebc);
-	regec4 = rtl_get_bbreg(hw, 0xec4, BMASKDWORD);
+	regec4 = rtl_get_bbreg(hw, 0xec4, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xec4 = 0x%x\n", regec4);
-	regecc = rtl_get_bbreg(hw, 0xecc, BMASKDWORD);
+	regecc = rtl_get_bbreg(hw, 0xecc, MASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xecc = 0x%x\n", regecc);
 	if (!(regeac & BIT(31)) && (((regeb4 & 0x03FF0000) >> 16) != 0x142) &&
 	    (((regebc & 0x03FF0000) >> 16) != 0x42))
@@ -1680,31 +1621,31 @@ static u8 _rtl92d_phy_pathb_iqk_5g_normal(struct ieee80211_hw *hw)
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path B IQK!\n");
 	/* path-A IQK setting */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path-A IQK setting!\n");
-	rtl_set_bbreg(hw, 0xe30, BMASKDWORD, 0x18008c1f);
-	rtl_set_bbreg(hw, 0xe34, BMASKDWORD, 0x18008c1f);
-	rtl_set_bbreg(hw, 0xe38, BMASKDWORD, 0x82110000);
-	rtl_set_bbreg(hw, 0xe3c, BMASKDWORD, 0x68110000);
+	rtl_set_bbreg(hw, 0xe30, MASKDWORD, 0x18008c1f);
+	rtl_set_bbreg(hw, 0xe34, MASKDWORD, 0x18008c1f);
+	rtl_set_bbreg(hw, 0xe38, MASKDWORD, 0x82110000);
+	rtl_set_bbreg(hw, 0xe3c, MASKDWORD, 0x68110000);
 
 	/* path-B IQK setting */
-	rtl_set_bbreg(hw, 0xe50, BMASKDWORD, 0x18008c2f);
-	rtl_set_bbreg(hw, 0xe54, BMASKDWORD, 0x18008c2f);
-	rtl_set_bbreg(hw, 0xe58, BMASKDWORD, 0x82140307);
-	rtl_set_bbreg(hw, 0xe5c, BMASKDWORD, 0x68160960);
+	rtl_set_bbreg(hw, 0xe50, MASKDWORD, 0x18008c2f);
+	rtl_set_bbreg(hw, 0xe54, MASKDWORD, 0x18008c2f);
+	rtl_set_bbreg(hw, 0xe58, MASKDWORD, 0x82140307);
+	rtl_set_bbreg(hw, 0xe5c, MASKDWORD, 0x68160960);
 
 	/* LO calibration setting */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "LO calibration setting!\n");
-	rtl_set_bbreg(hw, 0xe4c, BMASKDWORD, 0x00462911);
+	rtl_set_bbreg(hw, 0xe4c, MASKDWORD, 0x00462911);
 
 	/* path-B PA on */
-	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, BMASKDWORD, 0x0f600700);
-	rtl_set_bbreg(hw, RFPGA0_XB_RFINTERFACEOE, BMASKDWORD, 0x061f0d30);
+	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, MASKDWORD, 0x0f600700);
+	rtl_set_bbreg(hw, RFPGA0_XB_RFINTERFACEOE, MASKDWORD, 0x061f0d30);
 
 	for (i = 0; i < retrycount; i++) {
 		/* One shot, path B LOK & IQK */
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"One shot, path A LOK & IQK!\n");
-		rtl_set_bbreg(hw, 0xe48, BMASKDWORD, 0xfa000000);
-		rtl_set_bbreg(hw, 0xe48, BMASKDWORD, 0xf8000000);
+		rtl_set_bbreg(hw, 0xe48, MASKDWORD, 0xfa000000);
+		rtl_set_bbreg(hw, 0xe48, MASKDWORD, 0xf8000000);
 
 		/* delay x ms */
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
@@ -1712,15 +1653,15 @@ static u8 _rtl92d_phy_pathb_iqk_5g_normal(struct ieee80211_hw *hw)
 		mdelay(IQK_DELAY_TIME * 10);
 
 		/* Check failed */
-		regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
+		regeac = rtl_get_bbreg(hw, 0xeac, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xeac = 0x%x\n", regeac);
-		regeb4 = rtl_get_bbreg(hw, 0xeb4, BMASKDWORD);
+		regeb4 = rtl_get_bbreg(hw, 0xeb4, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xeb4 = 0x%x\n", regeb4);
-		regebc = rtl_get_bbreg(hw, 0xebc, BMASKDWORD);
+		regebc = rtl_get_bbreg(hw, 0xebc, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xebc = 0x%x\n", regebc);
-		regec4 = rtl_get_bbreg(hw, 0xec4, BMASKDWORD);
+		regec4 = rtl_get_bbreg(hw, 0xec4, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xec4 = 0x%x\n", regec4);
-		regecc = rtl_get_bbreg(hw, 0xecc, BMASKDWORD);
+		regecc = rtl_get_bbreg(hw, 0xecc, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xecc = 0x%x\n", regecc);
 		if (!(regeac & BIT(31)) &&
 		    (((regeb4 & 0x03FF0000) >> 16) != 0x142))
@@ -1738,9 +1679,9 @@ static u8 _rtl92d_phy_pathb_iqk_5g_normal(struct ieee80211_hw *hw)
 	}
 
 	/* path B PA off */
-	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, BMASKDWORD,
+	rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW, MASKDWORD,
 		      rtlphy->iqk_bb_backup[0]);
-	rtl_set_bbreg(hw, RFPGA0_XB_RFINTERFACEOE, BMASKDWORD,
+	rtl_set_bbreg(hw, RFPGA0_XB_RFINTERFACEOE, MASKDWORD,
 		      rtlphy->iqk_bb_backup[2]);
 	return result;
 }
@@ -1754,7 +1695,7 @@ static void _rtl92d_phy_save_adda_registers(struct ieee80211_hw *hw,
 
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Save ADDA parameters.\n");
 	for (i = 0; i < regnum; i++)
-		adda_backup[i] = rtl_get_bbreg(hw, adda_reg[i], BMASKDWORD);
+		adda_backup[i] = rtl_get_bbreg(hw, adda_reg[i], MASKDWORD);
 }
 
 static void _rtl92d_phy_save_mac_registers(struct ieee80211_hw *hw,
@@ -1779,7 +1720,7 @@ static void _rtl92d_phy_reload_adda_registers(struct ieee80211_hw *hw,
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		"Reload ADDA power saving parameters !\n");
 	for (i = 0; i < regnum; i++)
-		rtl_set_bbreg(hw, adda_reg[i], BMASKDWORD, adda_backup[i]);
+		rtl_set_bbreg(hw, adda_reg[i], MASKDWORD, adda_backup[i]);
 }
 
 static void _rtl92d_phy_reload_mac_registers(struct ieee80211_hw *hw,
@@ -1807,7 +1748,7 @@ static void _rtl92d_phy_path_adda_on(struct ieee80211_hw *hw,
 		pathon = rtlpriv->rtlhal.interfaceindex == 0 ?
 		    0x04db25a4 : 0x0b1b25a4;
 	for (i = 0; i < IQK_ADDA_REG_NUM; i++)
-		rtl_set_bbreg(hw, adda_reg[i], BMASKDWORD, pathon);
+		rtl_set_bbreg(hw, adda_reg[i], MASKDWORD, pathon);
 }
 
 static void _rtl92d_phy_mac_setting_calibration(struct ieee80211_hw *hw,
@@ -1830,9 +1771,9 @@ static void _rtl92d_phy_patha_standby(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path-A standby mode!\n");
 
-	rtl_set_bbreg(hw, 0xe28, BMASKDWORD, 0x0);
-	rtl_set_bbreg(hw, RFPGA0_XA_LSSIPARAMETER, BMASKDWORD, 0x00010000);
-	rtl_set_bbreg(hw, 0xe28, BMASKDWORD, 0x80800000);
+	rtl_set_bbreg(hw, 0xe28, MASKDWORD, 0x0);
+	rtl_set_bbreg(hw, RFPGA0_XA_LSSIPARAMETER, MASKDWORD, 0x00010000);
+	rtl_set_bbreg(hw, 0xe28, MASKDWORD, 0x80800000);
 }
 
 static void _rtl92d_phy_pimode_switch(struct ieee80211_hw *hw, bool pi_mode)
@@ -1843,8 +1784,8 @@ static void _rtl92d_phy_pimode_switch(struct ieee80211_hw *hw, bool pi_mode)
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		"BB Switch to %s mode!\n", pi_mode ? "PI" : "SI");
 	mode = pi_mode ? 0x01000100 : 0x01000000;
-	rtl_set_bbreg(hw, 0x820, BMASKDWORD, mode);
-	rtl_set_bbreg(hw, 0x828, BMASKDWORD, mode);
+	rtl_set_bbreg(hw, 0x820, MASKDWORD, mode);
+	rtl_set_bbreg(hw, 0x828, MASKDWORD, mode);
 }
 
 static void _rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw, long result[][8],
@@ -1875,7 +1816,7 @@ static void _rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw, long result[][8],
 
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "IQK for 2.4G :Start!!!\n");
 	if (t == 0) {
-		bbvalue = rtl_get_bbreg(hw, RFPGA0_RFMOD, BMASKDWORD);
+		bbvalue = rtl_get_bbreg(hw, RFPGA0_RFMOD, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "==>0x%08x\n", bbvalue);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, "IQ Calibration for %s\n",
 			is2t ? "2T2R" : "1T1R");
@@ -1898,40 +1839,40 @@ static void _rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw, long result[][8],
 		_rtl92d_phy_pimode_switch(hw, true);
 
 	rtl_set_bbreg(hw, RFPGA0_RFMOD, BIT(24), 0x00);
-	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, BMASKDWORD, 0x03a05600);
-	rtl_set_bbreg(hw, ROFDM0_TRMUXPAR, BMASKDWORD, 0x000800e4);
-	rtl_set_bbreg(hw, RFPGA0_XCD_RFINTERFACESW, BMASKDWORD, 0x22204000);
+	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, MASKDWORD, 0x03a05600);
+	rtl_set_bbreg(hw, ROFDM0_TRMUXPAR, MASKDWORD, 0x000800e4);
+	rtl_set_bbreg(hw, RFPGA0_XCD_RFINTERFACESW, MASKDWORD, 0x22204000);
 	rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER4, 0xf00000, 0x0f);
 	if (is2t) {
-		rtl_set_bbreg(hw, RFPGA0_XA_LSSIPARAMETER, BMASKDWORD,
+		rtl_set_bbreg(hw, RFPGA0_XA_LSSIPARAMETER, MASKDWORD,
 			      0x00010000);
-		rtl_set_bbreg(hw, RFPGA0_XB_LSSIPARAMETER, BMASKDWORD,
+		rtl_set_bbreg(hw, RFPGA0_XB_LSSIPARAMETER, MASKDWORD,
 			      0x00010000);
 	}
 	/* MAC settings */
 	_rtl92d_phy_mac_setting_calibration(hw, iqk_mac_reg,
 					    rtlphy->iqk_mac_backup);
 	/* Page B init */
-	rtl_set_bbreg(hw, 0xb68, BMASKDWORD, 0x0f600000);
+	rtl_set_bbreg(hw, 0xb68, MASKDWORD, 0x0f600000);
 	if (is2t)
-		rtl_set_bbreg(hw, 0xb6c, BMASKDWORD, 0x0f600000);
+		rtl_set_bbreg(hw, 0xb6c, MASKDWORD, 0x0f600000);
 	/* IQ calibration setting */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "IQK setting!\n");
-	rtl_set_bbreg(hw, 0xe28, BMASKDWORD, 0x80800000);
-	rtl_set_bbreg(hw, 0xe40, BMASKDWORD, 0x01007c00);
-	rtl_set_bbreg(hw, 0xe44, BMASKDWORD, 0x01004800);
+	rtl_set_bbreg(hw, 0xe28, MASKDWORD, 0x80800000);
+	rtl_set_bbreg(hw, 0xe40, MASKDWORD, 0x01007c00);
+	rtl_set_bbreg(hw, 0xe44, MASKDWORD, 0x01004800);
 	for (i = 0; i < retrycount; i++) {
 		patha_ok = _rtl92d_phy_patha_iqk(hw, is2t);
 		if (patha_ok == 0x03) {
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,
 				"Path A IQK Success!!\n");
-			result[t][0] = (rtl_get_bbreg(hw, 0xe94, BMASKDWORD) &
+			result[t][0] = (rtl_get_bbreg(hw, 0xe94, MASKDWORD) &
 					0x3FF0000) >> 16;
-			result[t][1] = (rtl_get_bbreg(hw, 0xe9c, BMASKDWORD) &
+			result[t][1] = (rtl_get_bbreg(hw, 0xe9c, MASKDWORD) &
 					0x3FF0000) >> 16;
-			result[t][2] = (rtl_get_bbreg(hw, 0xea4, BMASKDWORD) &
+			result[t][2] = (rtl_get_bbreg(hw, 0xea4, MASKDWORD) &
 					0x3FF0000) >> 16;
-			result[t][3] = (rtl_get_bbreg(hw, 0xeac, BMASKDWORD) &
+			result[t][3] = (rtl_get_bbreg(hw, 0xeac, MASKDWORD) &
 					0x3FF0000) >> 16;
 			break;
 		} else if (i == (retrycount - 1) && patha_ok == 0x01) {
@@ -1939,9 +1880,9 @@ static void _rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw, long result[][8],
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,
 				"Path A IQK Only  Tx Success!!\n");
 
-			result[t][0] = (rtl_get_bbreg(hw, 0xe94, BMASKDWORD) &
+			result[t][0] = (rtl_get_bbreg(hw, 0xe94, MASKDWORD) &
 					0x3FF0000) >> 16;
-			result[t][1] = (rtl_get_bbreg(hw, 0xe9c, BMASKDWORD) &
+			result[t][1] = (rtl_get_bbreg(hw, 0xe9c, MASKDWORD) &
 					0x3FF0000) >> 16;
 		}
 	}
@@ -1957,22 +1898,22 @@ static void _rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw, long result[][8],
 				RTPRINT(rtlpriv, FINIT, INIT_IQK,
 					"Path B IQK Success!!\n");
 				result[t][4] = (rtl_get_bbreg(hw, 0xeb4,
-					       BMASKDWORD) & 0x3FF0000) >> 16;
+					       MASKDWORD) & 0x3FF0000) >> 16;
 				result[t][5] = (rtl_get_bbreg(hw, 0xebc,
-					       BMASKDWORD) & 0x3FF0000) >> 16;
+					       MASKDWORD) & 0x3FF0000) >> 16;
 				result[t][6] = (rtl_get_bbreg(hw, 0xec4,
-					       BMASKDWORD) & 0x3FF0000) >> 16;
+					       MASKDWORD) & 0x3FF0000) >> 16;
 				result[t][7] = (rtl_get_bbreg(hw, 0xecc,
-					       BMASKDWORD) & 0x3FF0000) >> 16;
+					       MASKDWORD) & 0x3FF0000) >> 16;
 				break;
 			} else if (i == (retrycount - 1) && pathb_ok == 0x01) {
 				/* Tx IQK OK */
 				RTPRINT(rtlpriv, FINIT, INIT_IQK,
 					"Path B Only Tx IQK Success!!\n");
 				result[t][4] = (rtl_get_bbreg(hw, 0xeb4,
-					       BMASKDWORD) & 0x3FF0000) >> 16;
+					       MASKDWORD) & 0x3FF0000) >> 16;
 				result[t][5] = (rtl_get_bbreg(hw, 0xebc,
-					       BMASKDWORD) & 0x3FF0000) >> 16;
+					       MASKDWORD) & 0x3FF0000) >> 16;
 			}
 		}
 		if (0x00 == pathb_ok)
@@ -1984,7 +1925,7 @@ static void _rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw, long result[][8],
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		"IQK:Back to BB mode, load original value!\n");
 
-	rtl_set_bbreg(hw, 0xe28, BMASKDWORD, 0);
+	rtl_set_bbreg(hw, 0xe28, MASKDWORD, 0);
 	if (t != 0) {
 		/* Switch back BB to SI mode after finish IQ Calibration. */
 		if (!rtlphy->rfpi_enable)
@@ -2004,8 +1945,8 @@ static void _rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw, long result[][8],
 							  rtlphy->iqk_bb_backup,
 							  IQK_BB_REG_NUM - 1);
 		/* load 0xe30 IQC default value */
-		rtl_set_bbreg(hw, 0xe30, BMASKDWORD, 0x01008c00);
-		rtl_set_bbreg(hw, 0xe34, BMASKDWORD, 0x01008c00);
+		rtl_set_bbreg(hw, 0xe30, MASKDWORD, 0x01008c00);
+		rtl_set_bbreg(hw, 0xe34, MASKDWORD, 0x01008c00);
 	}
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "<==\n");
 }
@@ -2042,7 +1983,7 @@ static void _rtl92d_phy_iq_calibrate_5g_normal(struct ieee80211_hw *hw,
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "IQK for 5G NORMAL:Start!!!\n");
 	mdelay(IQK_DELAY_TIME * 20);
 	if (t == 0) {
-		bbvalue = rtl_get_bbreg(hw, RFPGA0_RFMOD, BMASKDWORD);
+		bbvalue = rtl_get_bbreg(hw, RFPGA0_RFMOD, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "==>0x%08x\n", bbvalue);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, "IQ Calibration for %s\n",
 			is2t ? "2T2R" : "1T1R");
@@ -2072,38 +2013,38 @@ static void _rtl92d_phy_iq_calibrate_5g_normal(struct ieee80211_hw *hw,
 	if (!rtlphy->rfpi_enable)
 		_rtl92d_phy_pimode_switch(hw, true);
 	rtl_set_bbreg(hw, RFPGA0_RFMOD, BIT(24), 0x00);
-	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, BMASKDWORD, 0x03a05600);
-	rtl_set_bbreg(hw, ROFDM0_TRMUXPAR, BMASKDWORD, 0x000800e4);
-	rtl_set_bbreg(hw, RFPGA0_XCD_RFINTERFACESW, BMASKDWORD, 0x22208000);
+	rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, MASKDWORD, 0x03a05600);
+	rtl_set_bbreg(hw, ROFDM0_TRMUXPAR, MASKDWORD, 0x000800e4);
+	rtl_set_bbreg(hw, RFPGA0_XCD_RFINTERFACESW, MASKDWORD, 0x22208000);
 	rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER4, 0xf00000, 0x0f);
 
 	/* Page B init */
-	rtl_set_bbreg(hw, 0xb68, BMASKDWORD, 0x0f600000);
+	rtl_set_bbreg(hw, 0xb68, MASKDWORD, 0x0f600000);
 	if (is2t)
-		rtl_set_bbreg(hw, 0xb6c, BMASKDWORD, 0x0f600000);
+		rtl_set_bbreg(hw, 0xb6c, MASKDWORD, 0x0f600000);
 	/* IQ calibration setting  */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "IQK setting!\n");
-	rtl_set_bbreg(hw, 0xe28, BMASKDWORD, 0x80800000);
-	rtl_set_bbreg(hw, 0xe40, BMASKDWORD, 0x10007c00);
-	rtl_set_bbreg(hw, 0xe44, BMASKDWORD, 0x01004800);
+	rtl_set_bbreg(hw, 0xe28, MASKDWORD, 0x80800000);
+	rtl_set_bbreg(hw, 0xe40, MASKDWORD, 0x10007c00);
+	rtl_set_bbreg(hw, 0xe44, MASKDWORD, 0x01004800);
 	patha_ok = _rtl92d_phy_patha_iqk_5g_normal(hw, is2t);
 	if (patha_ok == 0x03) {
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path A IQK Success!!\n");
-		result[t][0] = (rtl_get_bbreg(hw, 0xe94, BMASKDWORD) &
+		result[t][0] = (rtl_get_bbreg(hw, 0xe94, MASKDWORD) &
 				0x3FF0000) >> 16;
-		result[t][1] = (rtl_get_bbreg(hw, 0xe9c, BMASKDWORD) &
+		result[t][1] = (rtl_get_bbreg(hw, 0xe9c, MASKDWORD) &
 				0x3FF0000) >> 16;
-		result[t][2] = (rtl_get_bbreg(hw, 0xea4, BMASKDWORD) &
+		result[t][2] = (rtl_get_bbreg(hw, 0xea4, MASKDWORD) &
 				0x3FF0000) >> 16;
-		result[t][3] = (rtl_get_bbreg(hw, 0xeac, BMASKDWORD) &
+		result[t][3] = (rtl_get_bbreg(hw, 0xeac, MASKDWORD) &
 				0x3FF0000) >> 16;
 	} else if (patha_ok == 0x01) {	/* Tx IQK OK */
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"Path A IQK Only  Tx Success!!\n");
 
-		result[t][0] = (rtl_get_bbreg(hw, 0xe94, BMASKDWORD) &
+		result[t][0] = (rtl_get_bbreg(hw, 0xe94, MASKDWORD) &
 				0x3FF0000) >> 16;
-		result[t][1] = (rtl_get_bbreg(hw, 0xe9c, BMASKDWORD) &
+		result[t][1] = (rtl_get_bbreg(hw, 0xe9c, MASKDWORD) &
 				0x3FF0000) >> 16;
 	} else {
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path A IQK Fail!!\n");
@@ -2116,20 +2057,20 @@ static void _rtl92d_phy_iq_calibrate_5g_normal(struct ieee80211_hw *hw,
 		if (pathb_ok == 0x03) {
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,
 				"Path B IQK Success!!\n");
-			result[t][4] = (rtl_get_bbreg(hw, 0xeb4, BMASKDWORD) &
+			result[t][4] = (rtl_get_bbreg(hw, 0xeb4, MASKDWORD) &
 			     0x3FF0000) >> 16;
-			result[t][5] = (rtl_get_bbreg(hw, 0xebc, BMASKDWORD) &
+			result[t][5] = (rtl_get_bbreg(hw, 0xebc, MASKDWORD) &
 			     0x3FF0000) >> 16;
-			result[t][6] = (rtl_get_bbreg(hw, 0xec4, BMASKDWORD) &
+			result[t][6] = (rtl_get_bbreg(hw, 0xec4, MASKDWORD) &
 			     0x3FF0000) >> 16;
-			result[t][7] = (rtl_get_bbreg(hw, 0xecc, BMASKDWORD) &
+			result[t][7] = (rtl_get_bbreg(hw, 0xecc, MASKDWORD) &
 			     0x3FF0000) >> 16;
 		} else if (pathb_ok == 0x01) { /* Tx IQK OK */
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,
 				"Path B Only Tx IQK Success!!\n");
-			result[t][4] = (rtl_get_bbreg(hw, 0xeb4, BMASKDWORD) &
+			result[t][4] = (rtl_get_bbreg(hw, 0xeb4, MASKDWORD) &
 			     0x3FF0000) >> 16;
-			result[t][5] = (rtl_get_bbreg(hw, 0xebc, BMASKDWORD) &
+			result[t][5] = (rtl_get_bbreg(hw, 0xebc, MASKDWORD) &
 			     0x3FF0000) >> 16;
 		} else {
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,
@@ -2140,7 +2081,7 @@ static void _rtl92d_phy_iq_calibrate_5g_normal(struct ieee80211_hw *hw,
 	/* Back to BB mode, load original value */
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		"IQK:Back to BB mode, load original value!\n");
-	rtl_set_bbreg(hw, 0xe28, BMASKDWORD, 0);
+	rtl_set_bbreg(hw, 0xe28, MASKDWORD, 0);
 	if (t != 0) {
 		if (is2t)
 			_rtl92d_phy_reload_adda_registers(hw, iqk_bb_reg,
@@ -2240,7 +2181,7 @@ static void _rtl92d_phy_patha_fill_iqk_matrix(struct ieee80211_hw *hw,
 		return;
 	} else if (iqk_ok) {
 		oldval_0 = (rtl_get_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
-			BMASKDWORD) >> 22) & 0x3FF;	/* OFDM0_D */
+			MASKDWORD) >> 22) & 0x3FF;	/* OFDM0_D */
 		val_x = result[final_candidate][0];
 		if ((val_x & 0x00000200) != 0)
 			val_x = val_x | 0xFFFFFC00;
@@ -2271,7 +2212,7 @@ static void _rtl92d_phy_patha_fill_iqk_matrix(struct ieee80211_hw *hw,
 				      ((val_y * oldval_0 >> 7) & 0x1));
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, "0xC80 = 0x%x\n",
 			rtl_get_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
-				      BMASKDWORD));
+				      MASKDWORD));
 		if (txonly) {
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,  "only Tx OK\n");
 			return;
@@ -2299,7 +2240,7 @@ static void _rtl92d_phy_pathb_fill_iqk_matrix(struct ieee80211_hw *hw,
 		return;
 	} else if (iqk_ok) {
 		oldval_1 = (rtl_get_bbreg(hw, ROFDM0_XBTxIQIMBALANCE,
-					  BMASKDWORD) >> 22) & 0x3FF;
+					  MASKDWORD) >> 22) & 0x3FF;
 		val_x = result[final_candidate][4];
 		if ((val_x & 0x00000200) != 0)
 			val_x = val_x | 0xFFFFFC00;
@@ -2657,7 +2598,7 @@ static void _rtl92d_phy_lc_calibrate_sw(struct ieee80211_hw *hw, bool is2t)
 		rf_mode[index] = rtl_read_byte(rtlpriv, offset);
 		/* 2. Set RF mode = standby mode */
 		rtl_set_rfreg(hw, (enum radio_path)index, RF_AC,
-			      BRFREGOFFSETMASK, 0x010000);
+			      RFREG_OFFSET_MASK, 0x010000);
 		if (rtlpci->init_ready) {
 			/* switch CV-curve control by LC-calibration */
 			rtl_set_rfreg(hw, (enum radio_path)index, RF_SYN_G7,
@@ -2667,16 +2608,16 @@ static void _rtl92d_phy_lc_calibrate_sw(struct ieee80211_hw *hw, bool is2t)
 				      0x08000, 0x01);
 		}
 		u4tmp = rtl_get_rfreg(hw, (enum radio_path)index, RF_SYN_G6,
-				  BRFREGOFFSETMASK);
+				  RFREG_OFFSET_MASK);
 		while ((!(u4tmp & BIT(11))) && timecount <= timeout) {
 			mdelay(50);
 			timecount += 50;
 			u4tmp = rtl_get_rfreg(hw, (enum radio_path)index,
-					      RF_SYN_G6, BRFREGOFFSETMASK);
+					      RF_SYN_G6, RFREG_OFFSET_MASK);
 		}
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"PHY_LCK finish delay for %d ms=2\n", timecount);
-		u4tmp = rtl_get_rfreg(hw, index, RF_SYN_G4, BRFREGOFFSETMASK);
+		u4tmp = rtl_get_rfreg(hw, index, RF_SYN_G4, RFREG_OFFSET_MASK);
 		if (index == 0 && rtlhal->interfaceindex == 0) {
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,
 				"path-A / 5G LCK\n");
@@ -2696,9 +2637,9 @@ static void _rtl92d_phy_lc_calibrate_sw(struct ieee80211_hw *hw, bool is2t)
 				      0x7f, i);
 
 			rtl_set_rfreg(hw, (enum radio_path)index, 0x4D,
-				BRFREGOFFSETMASK, 0x0);
+				RFREG_OFFSET_MASK, 0x0);
 			readval = rtl_get_rfreg(hw, (enum radio_path)index,
-					  0x4F, BRFREGOFFSETMASK);
+					  0x4F, RFREG_OFFSET_MASK);
 			curvecount_val[2 * i + 1] = (readval & 0xfffe0) >> 5;
 			/* reg 0x4f [4:0] */
 			/* reg 0x50 [19:10] */
@@ -2912,7 +2853,7 @@ static bool _rtl92d_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 				}
 				rtl_set_rfreg(hw, (enum radio_path)rfpath,
 					      currentcmd->para1,
-					      BRFREGOFFSETMASK,
+					      RFREG_OFFSET_MASK,
 					      rtlphy->rfreg_chnlval[rfpath]);
 				_rtl92d_phy_reload_imr_setting(hw, channel,
 							       rfpath);
@@ -2960,7 +2901,7 @@ u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw)
 	if (rtlhal->macphymode == SINGLEMAC_SINGLEPHY &&
 	    rtlhal->bandset == BAND_ON_BOTH) {
 		ret_value = rtl_get_bbreg(hw, RFPGA0_XAB_RFPARAMETER,
-					  BMASKDWORD);
+					  MASKDWORD);
 		if (rtlphy->current_channel > 14 && !(ret_value & BIT(0)))
 			rtl92d_phy_switch_wirelessband(hw, BAND_ON_5G);
 		else if (rtlphy->current_channel <= 14 && (ret_value & BIT(0)))
@@ -3112,7 +3053,7 @@ static void _rtl92d_phy_set_rfsleep(struct ieee80211_hw *hw)
 	/* a.   TXPAUSE 0x522[7:0] = 0xFF  Pause MAC TX queue  */
 	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0xFF);
 	/* b.   RF path 0 offset 0x00 = 0x00  disable RF  */
-	rtl_set_rfreg(hw, RF90_PATH_A, 0x00, BRFREGOFFSETMASK, 0x00);
+	rtl_set_rfreg(hw, RF90_PATH_A, 0x00, RFREG_OFFSET_MASK, 0x00);
 	/* c.   APSD_CTRL 0x600[7:0] = 0x40 */
 	rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
 	/* d. APSD_CTRL 0x600[7:0] = 0x00
@@ -3120,12 +3061,12 @@ static void _rtl92d_phy_set_rfsleep(struct ieee80211_hw *hw)
 	 * RF path 0 offset 0x00 = 0x00
 	 * APSD_CTRL 0x600[7:0] = 0x40
 	 * */
-	u4btmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, BRFREGOFFSETMASK);
+	u4btmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, RFREG_OFFSET_MASK);
 	while (u4btmp != 0 && delay > 0) {
 		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x0);
-		rtl_set_rfreg(hw, RF90_PATH_A, 0x00, BRFREGOFFSETMASK, 0x00);
+		rtl_set_rfreg(hw, RF90_PATH_A, 0x00, RFREG_OFFSET_MASK, 0x00);
 		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
-		u4btmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, BRFREGOFFSETMASK);
+		u4btmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, RFREG_OFFSET_MASK);
 		delay--;
 	}
 	if (delay == 0) {
@@ -3468,9 +3409,9 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 		/* 5G LAN ON */
 		rtl_set_bbreg(hw, 0xB30, 0x00F00000, 0xa);
 		/* TX BB gain shift*1,Just for testchip,0xc80,0xc88 */
-		rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, BMASKDWORD,
+		rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, MASKDWORD,
 			      0x40000100);
-		rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, BMASKDWORD,
+		rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, MASKDWORD,
 			      0x40000100);
 		if (rtlhal->macphymode == DUALMAC_DUALPHY) {
 			rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW,
@@ -3524,16 +3465,16 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 		rtl_set_bbreg(hw, 0xB30, 0x00F00000, 0x0);
 		/* TX BB gain shift,Just for testchip,0xc80,0xc88 */
 		if (rtlefuse->internal_pa_5g[0])
-			rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, BMASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, MASKDWORD,
 				      0x2d4000b5);
 		else
-			rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, BMASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, MASKDWORD,
 				      0x20000080);
 		if (rtlefuse->internal_pa_5g[1])
-			rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, BMASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, MASKDWORD,
 				      0x2d4000b5);
 		else
-			rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, BMASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, MASKDWORD,
 				      0x20000080);
 		if (rtlhal->macphymode == DUALMAC_DUALPHY) {
 			rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW,
@@ -3560,8 +3501,8 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 		}
 	}
 	/* update IQK related settings */
-	rtl_set_bbreg(hw, ROFDM0_XARXIQIMBALANCE, BMASKDWORD, 0x40000100);
-	rtl_set_bbreg(hw, ROFDM0_XBRXIQIMBALANCE, BMASKDWORD, 0x40000100);
+	rtl_set_bbreg(hw, ROFDM0_XARXIQIMBALANCE, MASKDWORD, 0x40000100);
+	rtl_set_bbreg(hw, ROFDM0_XBRXIQIMBALANCE, MASKDWORD, 0x40000100);
 	rtl_set_bbreg(hw, ROFDM0_XCTxAFE, 0xF0000000, 0x00);
 	rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD, BIT(30) | BIT(28) |
 		      BIT(26) | BIT(24), 0x00);
@@ -3590,7 +3531,7 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 	/* DMDP */
 	if (rtlphy->rf_type == RF_1T1R) {
 		/* Use antenna 0,0xc04,0xd04 */
-		rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, BMASKBYTE0, 0x11);
+		rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, MASKBYTE0, 0x11);
 		rtl_set_bbreg(hw, ROFDM1_TRXPATHENABLE, BDWORD, 0x1);
 
 		/* enable ad/da clock1 for dual-phy reg0x888 */
@@ -3612,7 +3553,7 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 	} else {
 		/* Single PHY */
 		/* Use antenna 0 & 1,0xc04,0xd04 */
-		rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, BMASKBYTE0, 0x33);
+		rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, MASKBYTE0, 0x33);
 		rtl_set_bbreg(hw, ROFDM1_TRXPATHENABLE, BDWORD, 0x3);
 		/* disable ad/da clock1,0x888 */
 		rtl_set_bbreg(hw, RFPGA0_ADDALLOCKEN, BIT(12) | BIT(13), 0);
@@ -3620,9 +3561,9 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 	for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
 	     rfpath++) {
 		rtlphy->rfreg_chnlval[rfpath] = rtl_get_rfreg(hw, rfpath,
-						RF_CHNLBW, BRFREGOFFSETMASK);
+						RF_CHNLBW, RFREG_OFFSET_MASK);
 		rtlphy->reg_rf3c[rfpath] = rtl_get_rfreg(hw, rfpath, 0x3C,
-			BRFREGOFFSETMASK);
+			RFREG_OFFSET_MASK);
 	}
 	for (i = 0; i < 2; i++)
 		RT_TRACE(rtlpriv, COMP_RF, DBG_LOUD, "RF 0x18 = 0x%x\n",
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/reg.h b/drivers/net/wireless/rtlwifi/rtl8192de/reg.h
index b7498c5..7f29b8d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/reg.h
@@ -1295,18 +1295,4 @@
 #define	BWORD1					0xc
 #define	BDWORD					0xf
 
-#define	BMASKBYTE0				0xff
-#define	BMASKBYTE1				0xff00
-#define	BMASKBYTE2				0xff0000
-#define	BMASKBYTE3				0xff000000
-#define	BMASKHWORD				0xffff0000
-#define	BMASKLWORD				0x0000ffff
-#define	BMASKDWORD				0xffffffff
-#define	BMASK12BITS				0xfff
-#define	BMASKH4BITS				0xf0000000
-#define BMASKOFDM_D				0xffc00000
-#define	BMASKCCK				0x3f3f3f3f
-
-#define BRFREGOFFSETMASK			0xfffff
-
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/rf.c b/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
index 20144e0..6a6ac54 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
@@ -125,7 +125,7 @@ void rtl92d_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 	}
 
 	tmpval = tx_agc[RF90_PATH_A] & 0xff;
-	rtl_set_bbreg(hw, RTXAGC_A_CCK1_MCS32, BMASKBYTE1, tmpval);
+	rtl_set_bbreg(hw, RTXAGC_A_CCK1_MCS32, MASKBYTE1, tmpval);
 	RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 		"CCK PWR 1M (rf-A) = 0x%x (reg 0x%x)\n",
 		tmpval, RTXAGC_A_CCK1_MCS32);
@@ -135,7 +135,7 @@ void rtl92d_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 		"CCK PWR 2~11M (rf-A) = 0x%x (reg 0x%x)\n",
 		tmpval, RTXAGC_B_CCK11_A_CCK2_11);
 	tmpval = tx_agc[RF90_PATH_B] >> 24;
-	rtl_set_bbreg(hw, RTXAGC_B_CCK11_A_CCK2_11, BMASKBYTE0, tmpval);
+	rtl_set_bbreg(hw, RTXAGC_B_CCK11_A_CCK2_11, MASKBYTE0, tmpval);
 	RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 		"CCK PWR 11M (rf-B) = 0x%x (reg 0x%x)\n",
 		tmpval, RTXAGC_B_CCK11_A_CCK2_11);
@@ -360,7 +360,7 @@ static void _rtl92d_write_ofdm_power_reg(struct ieee80211_hw *hw,
 			regoffset = regoffset_a[index];
 		else
 			regoffset = regoffset_b[index];
-		rtl_set_bbreg(hw, regoffset, BMASKDWORD, writeval);
+		rtl_set_bbreg(hw, regoffset, MASKDWORD, writeval);
 		RTPRINT(rtlpriv, FPHY, PHY_TXPWR,
 			"Set 0x%x = %08x\n", regoffset, writeval);
 		if (((get_rf_type(rtlphy) == RF_2T2R) &&
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index 9c092e6..77c5b5f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -30,6 +30,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
+#include "../core.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -833,18 +834,7 @@ static bool _rtl92s_phy_config_bb(struct ieee80211_hw *hw, u8 configtype)
 
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_reg_len; i = i + 2) {
-			if (phy_reg_table[i] == 0xfe)
-				mdelay(50);
-			else if (phy_reg_table[i] == 0xfd)
-				mdelay(5);
-			else if (phy_reg_table[i] == 0xfc)
-				mdelay(1);
-			else if (phy_reg_table[i] == 0xfb)
-				udelay(50);
-			else if (phy_reg_table[i] == 0xfa)
-				udelay(5);
-			else if (phy_reg_table[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_reg_table[i]);
 
 			/* Add delay for ECS T20 & LG malow platform, */
 			udelay(1);
@@ -886,18 +876,7 @@ static bool _rtl92s_phy_set_bb_to_diff_rf(struct ieee80211_hw *hw,
 
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_regarray2xtxr_len; i = i + 3) {
-			if (phy_regarray2xtxr_table[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray2xtxr_table[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray2xtxr_table[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray2xtxr_table[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray2xtxr_table[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray2xtxr_table[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray2xtxr_table[i]);
 
 			rtl92s_phy_set_bb_reg(hw, phy_regarray2xtxr_table[i],
 				phy_regarray2xtxr_table[i + 1],
@@ -920,18 +899,7 @@ static bool _rtl92s_phy_config_bb_with_pg(struct ieee80211_hw *hw,
 
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_pg_len; i = i + 3) {
-			if (phy_table_pg[i] == 0xfe)
-				mdelay(50);
-			else if (phy_table_pg[i] == 0xfd)
-				mdelay(5);
-			else if (phy_table_pg[i] == 0xfc)
-				mdelay(1);
-			else if (phy_table_pg[i] == 0xfb)
-				udelay(50);
-			else if (phy_table_pg[i] == 0xfa)
-				udelay(5);
-			else if (phy_table_pg[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_table_pg[i]);
 
 			_rtl92s_store_pwrindex_diffrate_offset(hw,
 					phy_table_pg[i],
@@ -1034,28 +1002,9 @@ u8 rtl92s_phy_config_rf(struct ieee80211_hw *hw, enum radio_path rfpath)
 	switch (rfpath) {
 	case RF90_PATH_A:
 		for (i = 0; i < radio_a_tblen; i = i + 2) {
-			if (radio_a_table[i] == 0xfe)
-				/* Delay specific ms. Only RF configuration
-				 * requires delay. */
-				mdelay(50);
-			else if (radio_a_table[i] == 0xfd)
-				mdelay(5);
-			else if (radio_a_table[i] == 0xfc)
-				mdelay(1);
-			else if (radio_a_table[i] == 0xfb)
-				udelay(50);
-			else if (radio_a_table[i] == 0xfa)
-				udelay(5);
-			else if (radio_a_table[i] == 0xf9)
-				udelay(1);
-			else
-				rtl92s_phy_set_rf_reg(hw, rfpath,
-						      radio_a_table[i],
-						      MASK20BITS,
-						      radio_a_table[i + 1]);
+			rtl_rfreg_delay(hw, rfpath, radio_a_table[i],
+					MASK20BITS, radio_a_table[i + 1]);
 
-			/* Add delay for ECS T20 & LG malow platform */
-			udelay(1);
 		}
 
 		/* PA Bias current for inferiority IC */
@@ -1063,28 +1012,8 @@ u8 rtl92s_phy_config_rf(struct ieee80211_hw *hw, enum radio_path rfpath)
 		break;
 	case RF90_PATH_B:
 		for (i = 0; i < radio_b_tblen; i = i + 2) {
-			if (radio_b_table[i] == 0xfe)
-				/* Delay specific ms. Only RF configuration
-				 * requires delay.*/
-				mdelay(50);
-			else if (radio_b_table[i] == 0xfd)
-				mdelay(5);
-			else if (radio_b_table[i] == 0xfc)
-				mdelay(1);
-			else if (radio_b_table[i] == 0xfb)
-				udelay(50);
-			else if (radio_b_table[i] == 0xfa)
-				udelay(5);
-			else if (radio_b_table[i] == 0xf9)
-				udelay(1);
-			else
-				rtl92s_phy_set_rf_reg(hw, rfpath,
-						      radio_b_table[i],
-						      MASK20BITS,
-						      radio_b_table[i + 1]);
-
-			/* Add delay for ECS T20 & LG malow platform */
-			udelay(1);
+			rtl_rfreg_delay(hw, rfpath, radio_b_table[i],
+					MASK20BITS, radio_b_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_C:
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/reg.h b/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
index c81c835..e130434 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
@@ -1165,16 +1165,4 @@
 
 #define	BTX_AGCRATECCK				0x7f00
 
-#define	MASKBYTE0				0xff
-#define	MASKBYTE1				0xff00
-#define	MASKBYTE2				0xff0000
-#define	MASKBYTE3				0xff000000
-#define	MASKHWORD				0xffff0000
-#define	MASKLWORD				0x0000ffff
-#define	MASKDWORD				0xffffffff
-
-#define	MAKS12BITS				0xfffff
-#define	MASK20BITS				0xfffff
-#define RFREG_OFFSET_MASK			0xfffff
-
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile b/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
index 4ed731f..9c34a85 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
@@ -10,7 +10,6 @@ rtl8723ae-objs :=		\
 		led.o		\
 		phy.o		\
 		pwrseq.o	\
-		pwrseqcmd.o	\
 		rf.o		\
 		sw.o		\
 		table.o		\
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index 8a8577a..b47167c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -43,7 +43,6 @@
 #include "../rtl8723com/fw_common.h"
 #include "led.h"
 #include "hw.h"
-#include "pwrseqcmd.h"
 #include "pwrseq.h"
 #include "btc.h"
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
index 4f8189d..3ea78af 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
@@ -30,6 +30,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
+#include "../core.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -277,18 +278,7 @@ static bool _phy_cfg_bb_w_header(struct ieee80211_hw *hw, u8 configtype)
 	phy_regarray_table = RTL8723EPHY_REG_1TARRAY;
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_reg_arraylen; i = i + 2) {
-			if (phy_regarray_table[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray_table[i]);
 			rtl_set_bbreg(hw, phy_regarray_table[i], MASKDWORD,
 				      phy_regarray_table[i + 1]);
 			udelay(1);
@@ -450,18 +440,7 @@ static bool _phy_cfg_bb_w_pgheader(struct ieee80211_hw *hw, u8 configtype)
 
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		for (i = 0; i < phy_regarray_pg_len; i = i + 3) {
-			if (phy_regarray_table_pg[i] == 0xfe)
-				mdelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfd)
-				mdelay(5);
-			else if (phy_regarray_table_pg[i] == 0xfc)
-				mdelay(1);
-			else if (phy_regarray_table_pg[i] == 0xfb)
-				udelay(50);
-			else if (phy_regarray_table_pg[i] == 0xfa)
-				udelay(5);
-			else if (phy_regarray_table_pg[i] == 0xf9)
-				udelay(1);
+			rtl_addr_delay(phy_regarray_table_pg[i]);
 
 			_st_pwrIdx_dfrate_off(hw, phy_regarray_table_pg[i],
 					      phy_regarray_table_pg[i + 1],
@@ -488,24 +467,9 @@ bool rtl8723ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	switch (rfpath) {
 	case RF90_PATH_A:
 		for (i = 0; i < radioa_arraylen; i = i + 2) {
-			if (radioa_array_table[i] == 0xfe)
-				mdelay(50);
-			else if (radioa_array_table[i] == 0xfd)
-				mdelay(5);
-			else if (radioa_array_table[i] == 0xfc)
-				mdelay(1);
-			else if (radioa_array_table[i] == 0xfb)
-				udelay(50);
-			else if (radioa_array_table[i] == 0xfa)
-				udelay(5);
-			else if (radioa_array_table[i] == 0xf9)
-				udelay(1);
-			else {
-				rtl_set_rfreg(hw, rfpath, radioa_array_table[i],
-					      RFREG_OFFSET_MASK,
-					      radioa_array_table[i + 1]);
-				udelay(1);
-			}
+			rtl_rfreg_delay(hw, rfpath, radioa_array_table[i],
+					RFREG_OFFSET_MASK,
+					radioa_array_table[i + 1]);
 		}
 		break;
 	case RF90_PATH_B:
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h b/drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h
index 7a46f9f..a418acb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h
@@ -30,7 +30,6 @@
 #ifndef __RTL8723E_PWRSEQ_H__
 #define __RTL8723E_PWRSEQ_H__
 
-#include "pwrseqcmd.h"
 /*
 	Check document WM-20110607-Paul-RTL8723A_Power_Architecture-R02.vsd
 	There are 6 HW Power States:
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/reg.h b/drivers/net/wireless/rtlwifi/rtl8723ae/reg.h
index 199da36..64376b3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/reg.h
@@ -2059,22 +2059,6 @@
 #define	BWORD1					0xc
 #define	BWORD					0xf
 
-#define	MASKBYTE0				0xff
-#define	MASKBYTE1				0xff00
-#define	MASKBYTE2				0xff0000
-#define	MASKBYTE3				0xff000000
-#define	MASKHWORD				0xffff0000
-#define	MASKLWORD				0x0000ffff
-#define	MASKDWORD				0xffffffff
-#define	MASK12BITS				0xfff
-#define	MASKH4BITS				0xf0000000
-#define MASKOFDM_D				0xffc00000
-#define	MASKCCK					0x3f3f3f3f
-
-#define	MASK4BITS				0x0f
-#define	MASK20BITS				0xfffff
-#define RFREG_OFFSET_MASK			0xfffff
-
 #define	BENABLE					0x1
 #define	BDISABLE				0x0
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/Makefile b/drivers/net/wireless/rtlwifi/rtl8723be/Makefile
index 4a75aab..59e416a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/Makefile
@@ -8,7 +8,6 @@ rtl8723be-objs :=		\
 		led.o		\
 		phy.o		\
 		pwrseq.o	\
-		pwrseqcmd.o	\
 		rf.o		\
 		sw.o		\
 		table.o		\
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
index a500d26..fc2af71 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
@@ -39,7 +39,6 @@
 #include "../rtl8723com/fw_common.h"
 #include "led.h"
 #include "hw.h"
-#include "pwrseqcmd.h"
 #include "pwrseq.h"
 #include "../btcoexist/rtl_btc.h"
 
@@ -818,9 +817,9 @@ static bool _rtl8723be_init_mac(struct ieee80211_hw *hw)
 		mac_func_enable = false;
 
 	/* HW Power on sequence */
-	if (!rtlbe_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
-					PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,
-					RTL8723_NIC_ENABLE_FLOW)) {
+	if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
+				      PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,
+				      RTL8723_NIC_ENABLE_FLOW)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 			 "init MAC Fail as power on failure\n");
 		return false;
@@ -1309,8 +1308,8 @@ static void _rtl8723be_poweroff_adapter(struct ieee80211_hw *hw)
 
 	/* Combo (PCIe + USB) Card and PCIe-MF Card */
 	/* 1. Run LPS WL RFOFF flow */
-	rtlbe_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				   PWR_INTF_PCI_MSK, RTL8723_NIC_LPS_ENTER_FLOW);
+	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
+				 PWR_INTF_PCI_MSK, RTL8723_NIC_LPS_ENTER_FLOW);
 
 	/* 2. 0x1F[7:0] = 0 */
 	/* turn off RF */
@@ -1328,8 +1327,8 @@ static void _rtl8723be_poweroff_adapter(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
 
 	/* HW card disable configuration. */
-	rtlbe_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				   PWR_INTF_PCI_MSK, RTL8723_NIC_DISABLE_FLOW);
+	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
+				 PWR_INTF_PCI_MSK, RTL8723_NIC_DISABLE_FLOW);
 
 	/* Reset MCU IO Wrapper */
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_RSV_CTRL + 1);
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
index ebc1e27..cadae9b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
@@ -26,6 +26,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
+#include "../core.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -41,9 +42,6 @@ static bool _rtl8723be_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 static bool rtl8723be_phy_sw_chn_step_by_step(struct ieee80211_hw *hw,
 					      u8 channel, u8 *stage,
 					      u8 *step, u32 *delay);
-static void _rtl8723be_config_bb_reg(struct ieee80211_hw *hw,
-				     u32 addr, u32 data);
-
 static bool _rtl8723be_check_condition(struct ieee80211_hw *hw,
 				       const u32  condition)
 {
@@ -114,7 +112,7 @@ static bool _rtl8723be_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 			v1 = array_table[i];
 			v2 = array_table[i+1];
 			if (v1 < 0xcdcdcdcd) {
-				_rtl8723be_config_bb_reg(hw, v1, v2);
+				rtl_bb_delay(hw, v1, v2);
 			} else {/*This line is the start line of branch.*/
 				if (!_rtl8723be_check_condition(hw, array_table[i])) {
 					/*Discard the following (offset, data) pairs*/
@@ -135,7 +133,7 @@ static bool _rtl8723be_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 					       v2 != 0xCDEF &&
 					       v2 != 0xCDCD &&
 					       i < arraylen - 2) {
-						_rtl8723be_config_bb_reg(hw,
+						rtl_bb_delay(hw,
 								    v1, v2);
 						READ_NEXT_PAIR(v1, v2, i);
 					}
@@ -389,27 +387,6 @@ static void _rtl8723be_phy_init_tx_power_by_rate(struct ieee80211_hw *hw)
 						[path][txnum][section] = 0;
 }
 
-static void _rtl8723be_config_bb_reg(struct ieee80211_hw *hw,
-				     u32 addr, u32 data)
-{
-	if (addr == 0xfe) {
-		mdelay(50);
-	} else if (addr == 0xfd) {
-		mdelay(5);
-	} else if (addr == 0xfc) {
-		mdelay(1);
-	} else if (addr == 0xfb) {
-		udelay(50);
-	} else if (addr == 0xfa) {
-		udelay(5);
-	} else if (addr == 0xf9) {
-		udelay(1);
-	} else {
-		rtl_set_bbreg(hw, addr, MASKDWORD, data);
-		udelay(1);
-	}
-}
-
 static void phy_set_txpwr_by_rate_base(struct ieee80211_hw *hw, u8 band,
 				       u8 path, u8 rate_section,
 				       u8 txnum, u8 value)
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h b/drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h
index 960b408..a62f43e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h
@@ -26,7 +26,6 @@
 #ifndef __RTL8723BE_PWRSEQ_H__
 #define __RTL8723BE_PWRSEQ_H__
 
-#include "pwrseqcmd.h"
 /*	Check document WM-20130425-JackieLau-RTL8723B_Power_Architecture v05.vsd
  *	There are 6 HW Power States:
  *	0: POFF--Power Off
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/reg.h b/drivers/net/wireless/rtlwifi/rtl8723be/reg.h
index 65221e6..4c653fa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/reg.h
@@ -2242,22 +2242,6 @@
 #define	BWORD1	0xc
 #define	BWORD	0xf
 
-#define	MASKBYTE0	0xff
-#define	MASKBYTE1	0xff00
-#define	MASKBYTE2	0xff0000
-#define	MASKBYTE3	0xff000000
-#define	MASKHWORD	0xffff0000
-#define	MASKLWORD	0x0000ffff
-#define	MASKDWORD			0xffffffff
-#define	MASK12BITS			0xfff
-#define	MASKH4BITS			0xf0000000
-#define MASKOFDM_D			0xffc00000
-#define	MASKCCK				0x3f3f3f3f
-
-#define	MASK4BITS		0x0f
-#define	MASK20BITS		0xfffff
-#define RFREG_OFFSET_MASK		0xfffff
-
 #define	BENABLE	0x1
 #define	BDISABLE	0x0
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 5cb799e..0b4d641 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -57,6 +57,22 @@
 #define	MASK20BITS				0xfffff
 #define RFREG_OFFSET_MASK			0xfffff
 
+#define	MASKBYTE0				0xff
+#define	MASKBYTE1				0xff00
+#define	MASKBYTE2				0xff0000
+#define	MASKBYTE3				0xff000000
+#define	MASKHWORD				0xffff0000
+#define	MASKLWORD				0x0000ffff
+#define	MASKDWORD				0xffffffff
+#define	MASK12BITS				0xfff
+#define	MASKH4BITS				0xf0000000
+#define MASKOFDM_D				0xffc00000
+#define	MASKCCK					0x3f3f3f3f
+
+#define	MASK4BITS				0x0f
+#define	MASK20BITS				0xfffff
+#define RFREG_OFFSET_MASK			0xfffff
+
 #define RF_CHANGE_BY_INIT			0
 #define RF_CHANGE_BY_IPS			BIT(28)
 #define RF_CHANGE_BY_PS				BIT(29)
-- 
1.8.4.5

