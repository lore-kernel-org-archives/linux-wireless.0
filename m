Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54869 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab2EHCTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:19:03 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: =?UTF-8?q?=5BPATCH=209/9=5D=20rtlwifi=3A=20add=20rtl8192su=20subdriver?=
Date: Mon, 7 May 2012 22:18:41 -0400
Message-ID: <1336443521-15299-10-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041923_035478_F1877D0D)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently a WIP.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/Kconfig            |   15 +-
 drivers/net/wireless/rtlwifi/Makefile           |    1 +
 drivers/net/wireless/rtlwifi/rtl8192su/Makefile |   14 +
 drivers/net/wireless/rtlwifi/rtl8192su/def.h    |   30 +
 drivers/net/wireless/rtlwifi/rtl8192su/dm.c     |  737 +++++++
 drivers/net/wireless/rtlwifi/rtl8192su/dm.h     |  119 ++
 drivers/net/wireless/rtlwifi/rtl8192su/fw.c     |  800 +++++++
 drivers/net/wireless/rtlwifi/rtl8192su/fw.h     |  456 ++++
 drivers/net/wireless/rtlwifi/rtl8192su/hw.c     | 2573 +++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192su/hw.h     |   79 +
 drivers/net/wireless/rtlwifi/rtl8192su/led.c    |  154 ++
 drivers/net/wireless/rtlwifi/rtl8192su/led.h    |   38 +
 drivers/net/wireless/rtlwifi/rtl8192su/phy.c    | 1751 +++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192su/phy.h    |  100 +
 drivers/net/wireless/rtlwifi/rtl8192su/reg.h    | 1232 +++++++++++
 drivers/net/wireless/rtlwifi/rtl8192su/rf.c     |  542 +++++
 drivers/net/wireless/rtlwifi/rtl8192su/rf.h     |   42 +
 drivers/net/wireless/rtlwifi/rtl8192su/sw.c     |  546 +++++
 drivers/net/wireless/rtlwifi/rtl8192su/sw.h     |   36 +
 drivers/net/wireless/rtlwifi/rtl8192su/table.c  |  633 ++++++
 drivers/net/wireless/rtlwifi/rtl8192su/table.h  |   48 +
 drivers/net/wireless/rtlwifi/rtl8192su/trx.c    | 1089 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8192su/trx.h    |   59 +
 23 files changed, 11092 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192su/trx.h

diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index cefac6a..b528f41 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -44,14 +44,25 @@ config RTL8192CU
 
 	If you choose to build it as a module, it will be called rtl8192cu
 
+config RTL8192SU
+	tristate "Realtek RTL8192SU/RTL8191SU/RTL8188SU USB Wireless Network Adapter"
+	depends on MAC80211 && USB && EXPERIMENTAL
+	select FW_LOADER
+	select RTLWIFI
+	---help---
+	This is the driver for Realtek RTL8192SU/RTL8191SU/RTL8188SU 802.11 USB
+	wireless network adapters.
+
+	If you choose to build it as a module, it will be called rtl8192su
+
 config RTLWIFI
 	tristate
-	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
+	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192SU || RTL8192DE
 	default m
 
 config RTLWIFI_DEBUG
 	bool "Additional debugging output"
-	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
+	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192SU || RTL8192DE
 	default y
 
 config RTL8192C_COMMON
diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
index 97935c5..b54f45e 100644
--- a/drivers/net/wireless/rtlwifi/Makefile
+++ b/drivers/net/wireless/rtlwifi/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
 obj-$(CONFIG_RTL8192SE)		+= rtl8192se/
+obj-$(CONFIG_RTL8192SU)		+= rtl8192su/
 obj-$(CONFIG_RTL8192DE)		+= rtl8192de/
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/Makefile b/drivers/net/wireless/rtlwifi/rtl8192su/Makefile
new file mode 100644
index 0000000..ebd7080
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/Makefile
@@ -0,0 +1,14 @@
+rtl8192su-objs :=		\
+		dm.o		\
+		fw.o		\
+		hw.o		\
+		led.o		\
+		phy.o		\
+		rf.o		\
+		sw.o		\
+		table.o		\
+		trx.o
+
+obj-$(CONFIG_RTL8192SU) += rtl8192su.o
+
+ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/def.h b/drivers/net/wireless/rtlwifi/rtl8192su/def.h
new file mode 100644
index 0000000..f2ce4bf
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/def.h
@@ -0,0 +1,30 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../rtl8192se/def.h"
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/dm.c b/drivers/net/wireless/rtlwifi/rtl8192su/dm.c
new file mode 100644
index 0000000..27df33d
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/dm.c
@@ -0,0 +1,737 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../base.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "dm.h"
+#include "fw.h"
+
+static const u32 edca_setting_dl[PEER_MAX] = {
+	0xa44f,		/* 0 UNKNOWN */
+	0x5ea44f,	/* 1 REALTEK_90 */
+	0x5ea44f,	/* 2 REALTEK_92SE */
+	0xa630,		/* 3 BROAD	*/
+	0xa44f,		/* 4 RAL */
+	0xa630,		/* 5 ATH */
+	0xa630,		/* 6 CISCO */
+	0xa42b,		/* 7 MARV */
+};
+
+static const u32 edca_setting_dl_gmode[PEER_MAX] = {
+	0x4322,		/* 0 UNKNOWN */
+	0xa44f,		/* 1 REALTEK_90 */
+	0x5ea44f,	/* 2 REALTEK_92SE */
+	0xa42b,		/* 3 BROAD */
+	0x5e4322,	/* 4 RAL */
+	0x4322,		/* 5 ATH */
+	0xa430,		/* 6 CISCO */
+	0x5ea44f,	/* 7 MARV */
+};
+
+static const u32 edca_setting_ul[PEER_MAX] = {
+	0x5e4322,	/* 0 UNKNOWN */
+	0xa44f,		/* 1 REALTEK_90 */
+	0x5ea44f,	/* 2 REALTEK_92SE */
+	0x5ea322,	/* 3 BROAD */
+	0x5ea422,	/* 4 RAL */
+	0x5ea322,	/* 5 ATH */
+	0x3ea44f,	/* 6 CISCO */
+	0x5ea44f,	/* 7 MARV */
+};
+
+#if 0
+static void _rtl92s_dm_check_edca_turbo(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+
+	static u64 last_txok_cnt;
+	static u64 last_rxok_cnt;
+	u64 cur_txok_cnt = 0;
+	u64 cur_rxok_cnt = 0;
+
+	u32 edca_be_ul = edca_setting_ul[mac->vendor];
+	u32 edca_be_dl = edca_setting_dl[mac->vendor];
+	u32 edca_gmode = edca_setting_dl_gmode[mac->vendor];
+
+	if (mac->link_state != MAC80211_LINKED) {
+		rtlpriv->dm.current_turbo_edca = false;
+		goto dm_checkedcaturbo_exit;
+	}
+
+	if ((!rtlpriv->dm.is_any_nonbepkts) &&
+	    (!rtlpriv->dm.disable_framebursting)) {
+		cur_txok_cnt = rtlpriv->stats.txbytesunicast - last_txok_cnt;
+		cur_rxok_cnt = rtlpriv->stats.rxbytesunicast - last_rxok_cnt;
+
+		if (rtlpriv->phy.rf_type == RF_1T2R) {
+			if (cur_txok_cnt > 4 * cur_rxok_cnt) {
+				/* Uplink TP is present. */
+				if (rtlpriv->dm.is_cur_rdlstate ||
+					!rtlpriv->dm.current_turbo_edca) {
+					rtl_write_dword(rtlpriv, EDCAPARA_BE,
+							edca_be_ul);
+					rtlpriv->dm.is_cur_rdlstate = false;
+				}
+			} else {/* Balance TP is present. */
+				if (!rtlpriv->dm.is_cur_rdlstate ||
+					!rtlpriv->dm.current_turbo_edca) {
+					if (mac->mode == WIRELESS_MODE_G ||
+					    mac->mode == WIRELESS_MODE_B)
+						rtl_write_dword(rtlpriv,
+								EDCAPARA_BE,
+								edca_gmode);
+					else
+						rtl_write_dword(rtlpriv,
+								EDCAPARA_BE,
+								edca_be_dl);
+					rtlpriv->dm.is_cur_rdlstate = true;
+				}
+			}
+			rtlpriv->dm.current_turbo_edca = true;
+		} else {
+			if (cur_rxok_cnt > 4 * cur_txok_cnt) {
+				if (!rtlpriv->dm.is_cur_rdlstate ||
+					!rtlpriv->dm.current_turbo_edca) {
+					if (mac->mode == WIRELESS_MODE_G ||
+					    mac->mode == WIRELESS_MODE_B)
+						rtl_write_dword(rtlpriv,
+								EDCAPARA_BE,
+								edca_gmode);
+					else
+						rtl_write_dword(rtlpriv,
+								EDCAPARA_BE,
+								edca_be_dl);
+					rtlpriv->dm.is_cur_rdlstate = true;
+				}
+			} else {
+				if (rtlpriv->dm.is_cur_rdlstate ||
+					!rtlpriv->dm.current_turbo_edca) {
+					rtl_write_dword(rtlpriv, EDCAPARA_BE,
+							edca_be_ul);
+					rtlpriv->dm.is_cur_rdlstate = false;
+				}
+			}
+			rtlpriv->dm.current_turbo_edca = true;
+		}
+	} else {
+		if (rtlpriv->dm.current_turbo_edca) {
+			u8 tmp = AC0_BE;
+			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_AC_PARAM,
+						      (u8 *)(&tmp));
+			rtlpriv->dm.current_turbo_edca = false;
+		}
+	}
+
+dm_checkedcaturbo_exit:
+	rtlpriv->dm.is_any_nonbepkts = false;
+	last_txok_cnt = rtlpriv->stats.txbytesunicast;
+	last_rxok_cnt = rtlpriv->stats.rxbytesunicast;
+}
+
+static void _rtl92s_dm_txpowertracking_callback_thermalmeter(
+					struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u8 thermalvalue = 0;
+
+	rtlpriv->dm.txpower_trackinginit = true;
+
+	thermalvalue = (u8)rtl_get_rfreg(hw, RF90_PATH_A, RF_T_METER, 0x1f);
+
+	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
+		 "Readback Thermal Meter = 0x%x pre thermal meter 0x%x eeprom_thermal meter 0x%x\n",
+		 thermalvalue,
+		 rtlpriv->dm.thermalvalue, rtlefuse->eeprom_thermalmeter);
+
+	if (thermalvalue) {
+		rtlpriv->dm.thermalvalue = thermalvalue;
+		rtl92s_phy_set_fw_cmd(hw, FW_CMD_TXPWR_TRACK_THERMAL);
+	}
+
+	rtlpriv->dm.txpowercount = 0;
+}
+
+static void _rtl92s_dm_check_txpowertracking_thermalmeter(
+					struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	static u8 tm_trigger;
+	u8 tx_power_checkcnt = 5;
+
+	/* 2T2R TP issue */
+	if (rtlphy->rf_type == RF_2T2R)
+		return;
+
+	if (!rtlpriv->dm.txpower_tracking)
+		return;
+
+	if (rtlpriv->dm.txpowercount <= tx_power_checkcnt) {
+		rtlpriv->dm.txpowercount++;
+		return;
+	}
+
+	if (!tm_trigger) {
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER,
+			      RFREG_OFFSET_MASK, 0x60);
+		tm_trigger = 1;
+	} else {
+		_rtl92s_dm_txpowertracking_callback_thermalmeter(hw);
+		tm_trigger = 0;
+	}
+}
+
+static void _rtl92s_dm_refresh_rateadaptive_mask(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rate_adaptive *ra = &(rtlpriv->ra);
+
+	u32 low_rssi_thresh = 0;
+	u32 middle_rssi_thresh = 0;
+	u32 high_rssi_thresh = 0;
+	struct ieee80211_sta *sta = NULL;
+
+	if (is_hal_stop(rtlhal))
+		return;
+
+	if (!rtlpriv->dm.useramask)
+		return;
+
+	if (!rtlpriv->dm.inform_fw_driverctrldm) {
+		rtl92s_phy_set_fw_cmd(hw, FW_CMD_CTRL_DM_BY_DRIVER);
+		rtlpriv->dm.inform_fw_driverctrldm = true;
+	}
+
+	rcu_read_lock();
+	if (mac->opmode == NL80211_IFTYPE_STATION)
+		sta = get_sta(hw, mac->vif, mac->bssid);
+	if ((mac->link_state == MAC80211_LINKED) &&
+	    (mac->opmode == NL80211_IFTYPE_STATION)) {
+		switch (ra->pre_ratr_state) {
+		case DM_RATR_STA_HIGH:
+			high_rssi_thresh = 40;
+			middle_rssi_thresh = 30;
+			low_rssi_thresh = 20;
+			break;
+		case DM_RATR_STA_MIDDLE:
+			high_rssi_thresh = 44;
+			middle_rssi_thresh = 30;
+			low_rssi_thresh = 20;
+			break;
+		case DM_RATR_STA_LOW:
+			high_rssi_thresh = 44;
+			middle_rssi_thresh = 34;
+			low_rssi_thresh = 20;
+			break;
+		case DM_RATR_STA_ULTRALOW:
+			high_rssi_thresh = 44;
+			middle_rssi_thresh = 34;
+			low_rssi_thresh = 24;
+			break;
+		default:
+			high_rssi_thresh = 44;
+			middle_rssi_thresh = 34;
+			low_rssi_thresh = 24;
+			break;
+		}
+
+		if (rtlpriv->dm.undecorated_smoothed_pwdb >
+		    (long)high_rssi_thresh) {
+			ra->ratr_state = DM_RATR_STA_HIGH;
+		} else if (rtlpriv->dm.undecorated_smoothed_pwdb >
+			   (long)middle_rssi_thresh) {
+			ra->ratr_state = DM_RATR_STA_LOW;
+		} else if (rtlpriv->dm.undecorated_smoothed_pwdb >
+			   (long)low_rssi_thresh) {
+			ra->ratr_state = DM_RATR_STA_LOW;
+		} else {
+			ra->ratr_state = DM_RATR_STA_ULTRALOW;
+		}
+
+		if (ra->pre_ratr_state != ra->ratr_state) {
+			RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
+				 "RSSI = %ld RSSI_LEVEL = %d PreState = %d, CurState = %d\n",
+				 rtlpriv->dm.undecorated_smoothed_pwdb,
+				 ra->ratr_state,
+				 ra->pre_ratr_state, ra->ratr_state);
+
+			rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
+							   ra->ratr_state);
+			ra->pre_ratr_state = ra->ratr_state;
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void _rtl92s_dm_switch_baseband_mrc(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	bool current_mrc;
+	bool enable_mrc = true;
+	long tmpentry_maxpwdb = 0;
+	u8 rssi_a = 0;
+	u8 rssi_b = 0;
+
+	if (is_hal_stop(rtlhal))
+		return;
+
+	if ((rtlphy->rf_type == RF_1T1R) || (rtlphy->rf_type == RF_2T2R))
+		return;
+
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_MRC, (u8 *)(&current_mrc));
+
+	if (mac->link_state >= MAC80211_LINKED) {
+		if (rtlpriv->dm.undecorated_smoothed_pwdb > tmpentry_maxpwdb) {
+			rssi_a = rtlpriv->stats.rx_rssi_percentage[RF90_PATH_A];
+			rssi_b = rtlpriv->stats.rx_rssi_percentage[RF90_PATH_B];
+		}
+	}
+
+	/* MRC settings would NOT affect TP on Wireless B mode. */
+	if (mac->mode != WIRELESS_MODE_B) {
+		if ((rssi_a == 0) && (rssi_b == 0)) {
+			enable_mrc = true;
+		} else if (rssi_b > 30) {
+			/* Turn on B-Path */
+			enable_mrc = true;
+		} else if (rssi_b < 5) {
+			/* Turn off B-path  */
+			enable_mrc = false;
+		/* Take care of RSSI differentiation. */
+		} else if (rssi_a > 15 && (rssi_a >= rssi_b)) {
+			if ((rssi_a - rssi_b) > 15)
+				/* Turn off B-path  */
+				enable_mrc = false;
+			else if ((rssi_a - rssi_b) < 10)
+				/* Turn on B-Path */
+				enable_mrc = true;
+			else
+				enable_mrc = current_mrc;
+		} else {
+			/* Turn on B-Path */
+			enable_mrc = true;
+		}
+	}
+
+	/* Update MRC settings if needed. */
+	if (enable_mrc != current_mrc)
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_MRC,
+					      (u8 *)&enable_mrc);
+
+}
+#endif
+
+void rtl92s_dm_init_edca_turbo(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->dm.current_turbo_edca = false;
+	rtlpriv->dm.is_any_nonbepkts = false;
+	rtlpriv->dm.is_cur_rdlstate = false;
+}
+
+static void _rtl92s_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rate_adaptive *ra = &(rtlpriv->ra);
+
+	ra->ratr_state = DM_RATR_STA_MAX;
+	ra->pre_ratr_state = DM_RATR_STA_MAX;
+
+	if (rtlpriv->dm.dm_type == DM_TYPE_BYDRIVER)
+		rtlpriv->dm.useramask = true;
+	else
+		rtlpriv->dm.useramask = false;
+
+	rtlpriv->dm.useramask = false;
+	rtlpriv->dm.inform_fw_driverctrldm = false;
+}
+
+static void _rtl92s_dm_init_txpowertracking_thermalmeter(
+				struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->dm.txpower_tracking = true;
+	rtlpriv->dm.txpowercount = 0;
+	rtlpriv->dm.txpower_trackinginit = false;
+}
+
+#if 0
+static void _rtl92s_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
+	u32 ret_value;
+
+	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER1, MASKDWORD);
+	falsealm_cnt->cnt_parity_fail = ((ret_value & 0xffff0000) >> 16);
+
+	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER2, MASKDWORD);
+	falsealm_cnt->cnt_rate_illegal = (ret_value & 0xffff);
+	falsealm_cnt->cnt_crc8_fail = ((ret_value & 0xffff0000) >> 16);
+	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER3, MASKDWORD);
+	falsealm_cnt->cnt_mcs_fail = (ret_value & 0xffff);
+
+	falsealm_cnt->cnt_ofdm_fail = falsealm_cnt->cnt_parity_fail +
+		falsealm_cnt->cnt_rate_illegal + falsealm_cnt->cnt_crc8_fail +
+		falsealm_cnt->cnt_mcs_fail;
+
+	/* read CCK false alarm */
+	ret_value = rtl_get_bbreg(hw, 0xc64, MASKDWORD);
+	falsealm_cnt->cnt_cck_fail = (ret_value & 0xffff);
+	falsealm_cnt->cnt_all =	falsealm_cnt->cnt_ofdm_fail +
+		falsealm_cnt->cnt_cck_fail;
+}
+
+static void rtl92s_backoff_enable_flag(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
+	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
+
+	if (falsealm_cnt->cnt_all > digtable->fa_highthresh) {
+		if ((digtable->backoff_val - 6) <
+			digtable->backoffval_range_min)
+			digtable->backoff_val = digtable->backoffval_range_min;
+		else
+			digtable->backoff_val -= 6;
+	} else if (falsealm_cnt->cnt_all < digtable->fa_lowthresh) {
+		if ((digtable->backoff_val + 6) >
+			digtable->backoffval_range_max)
+			digtable->backoff_val =
+				 digtable->backoffval_range_max;
+		else
+			digtable->backoff_val += 6;
+	}
+}
+
+static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
+	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
+	static u8 initialized, force_write;
+	u8 initial_gain = 0;
+
+	if ((digtable->pre_sta_connectstate == digtable->cur_sta_connectstate) ||
+		(digtable->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT)) {
+		if (digtable->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT) {
+			if (rtlpriv->psc.rfpwr_state != ERFON)
+				return;
+
+			if (digtable->backoff_enable_flag)
+				rtl92s_backoff_enable_flag(hw);
+			else
+				digtable->backoff_val = DM_DIG_BACKOFF;
+
+			if ((digtable->rssi_val + 10 - digtable->backoff_val) >
+				digtable->rx_gain_range_max)
+				digtable->cur_igvalue =
+						digtable->rx_gain_range_max;
+			else if ((digtable->rssi_val + 10 - digtable->backoff_val)
+				 < digtable->rx_gain_range_min)
+				digtable->cur_igvalue =
+						digtable->rx_gain_range_min;
+			else
+				digtable->cur_igvalue = digtable->rssi_val + 10 -
+						digtable->backoff_val;
+
+			if (falsealm_cnt->cnt_all > 10000)
+				digtable->cur_igvalue =
+					 (digtable->cur_igvalue > 0x33) ?
+					 digtable->cur_igvalue : 0x33;
+
+			if (falsealm_cnt->cnt_all > 16000)
+				digtable->cur_igvalue =
+						 digtable->rx_gain_range_max;
+		/* connected -> connected or disconnected -> disconnected  */
+		} else {
+			/* Firmware control DIG, do nothing in driver dm */
+			return;
+		}
+		/* disconnected -> connected or connected ->
+		 * disconnected or beforeconnect->(dis)connected */
+	} else {
+		/* Enable FW DIG */
+		digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+		rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_ENABLE);
+
+		digtable->backoff_val = DM_DIG_BACKOFF;
+		digtable->cur_igvalue = rtlpriv->phy.default_initialgain[0];
+		digtable->pre_igvalue = 0;
+		return;
+	}
+
+	/* Forced writing to prevent from fw-dig overwriting. */
+	if (digtable->pre_igvalue != rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1,
+						  MASKBYTE0))
+		force_write = 1;
+
+	if ((digtable->pre_igvalue != digtable->cur_igvalue) ||
+	    !initialized || force_write) {
+		/* Disable FW DIG */
+		rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_DISABLE);
+
+		initial_gain = (u8)digtable->cur_igvalue;
+
+		/* Set initial gain. */
+		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, MASKBYTE0, initial_gain);
+		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, MASKBYTE0, initial_gain);
+		digtable->pre_igvalue = digtable->cur_igvalue;
+		initialized = 1;
+		force_write = 0;
+	}
+}
+
+static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
+
+	if (rtlpriv->mac80211.act_scanning)
+		return;
+
+	/* Decide the current status and if modify initial gain or not */
+	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED ||
+	    rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
+		digtable->cur_sta_connectstate = DIG_STA_CONNECT;
+	else
+		digtable->cur_sta_connectstate = DIG_STA_DISCONNECT;
+
+	digtable->rssi_val = rtlpriv->dm.undecorated_smoothed_pwdb;
+
+	/* Change dig mode to rssi */
+	if (digtable->cur_sta_connectstate != DIG_STA_DISCONNECT) {
+		if (digtable->dig_twoport_algorithm ==
+		    DIG_TWO_PORT_ALGO_FALSE_ALARM) {
+			digtable->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
+			rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_MODE_SS);
+		}
+	}
+
+	_rtl92s_dm_false_alarm_counter_statistics(hw);
+	_rtl92s_dm_initial_gain_sta_beforeconnect(hw);
+
+	digtable->pre_sta_connectstate = digtable->cur_sta_connectstate;
+}
+
+static void _rtl92s_dm_ctrl_initgain_byrssi(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
+
+	/* 2T2R TP issue */
+	if (rtlphy->rf_type == RF_2T2R)
+		return;
+
+	if (!rtlpriv->dm.dm_initialgain_enable)
+		return;
+
+	if (digtable->dig_enable_flag == false)
+		return;
+
+	_rtl92s_dm_ctrl_initgain_bytwoport(hw);
+}
+
+static void _rtl92s_dm_dynamic_txpower(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	long undecorated_smoothed_pwdb;
+	long txpwr_threshold_lv1, txpwr_threshold_lv2;
+
+	/* 2T2R TP issue */
+	if (rtlphy->rf_type == RF_2T2R)
+		return;
+
+	if (!rtlpriv->dm.dynamic_txpower_enable ||
+	    rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) {
+		rtlpriv->dm.dynamic_txhighpower_lvl = TX_HIGHPWR_LEVEL_NORMAL;
+		return;
+	}
+
+	if ((mac->link_state < MAC80211_LINKED) &&
+	    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb == 0)) {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
+			 "Not connected to any\n");
+
+		rtlpriv->dm.dynamic_txhighpower_lvl = TX_HIGHPWR_LEVEL_NORMAL;
+
+		rtlpriv->dm.last_dtp_lvl = TX_HIGHPWR_LEVEL_NORMAL;
+		return;
+	}
+
+	if (mac->link_state >= MAC80211_LINKED) {
+		if (mac->opmode == NL80211_IFTYPE_ADHOC) {
+			undecorated_smoothed_pwdb =
+			    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 "AP Client PWDB = 0x%lx\n",
+				 undecorated_smoothed_pwdb);
+		} else {
+			undecorated_smoothed_pwdb =
+			    rtlpriv->dm.undecorated_smoothed_pwdb;
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 "STA Default Port PWDB = 0x%lx\n",
+				 undecorated_smoothed_pwdb);
+		}
+	} else {
+		undecorated_smoothed_pwdb =
+		    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
+
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "AP Ext Port PWDB = 0x%lx\n",
+			 undecorated_smoothed_pwdb);
+	}
+
+	txpwr_threshold_lv2 = TX_POWER_NEAR_FIELD_THRESH_LVL2;
+	txpwr_threshold_lv1 = TX_POWER_NEAR_FIELD_THRESH_LVL1;
+
+	if (rtl_get_bbreg(hw, 0xc90, MASKBYTE0) == 1)
+		rtlpriv->dm.dynamic_txhighpower_lvl = TX_HIGHPWR_LEVEL_NORMAL;
+	else if (undecorated_smoothed_pwdb >= txpwr_threshold_lv2)
+		rtlpriv->dm.dynamic_txhighpower_lvl = TX_HIGHPWR_LEVEL_NORMAL2;
+	else if ((undecorated_smoothed_pwdb < (txpwr_threshold_lv2 - 3)) &&
+		(undecorated_smoothed_pwdb >= txpwr_threshold_lv1))
+		rtlpriv->dm.dynamic_txhighpower_lvl = TX_HIGHPWR_LEVEL_NORMAL1;
+	else if (undecorated_smoothed_pwdb < (txpwr_threshold_lv1 - 3))
+		rtlpriv->dm.dynamic_txhighpower_lvl = TX_HIGHPWR_LEVEL_NORMAL;
+
+	if ((rtlpriv->dm.dynamic_txhighpower_lvl != rtlpriv->dm.last_dtp_lvl))
+		rtl92s_phy_set_txpower(hw, rtlphy->current_channel);
+
+	rtlpriv->dm.last_dtp_lvl = rtlpriv->dm.dynamic_txhighpower_lvl;
+}
+#endif
+
+static void _rtl92s_dm_init_dig(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
+
+	/* Disable DIG scheme now.*/
+	digtable->dig_enable_flag = true;
+	digtable->backoff_enable_flag = true;
+
+	if ((rtlpriv->dm.dm_type == DM_TYPE_BYDRIVER) &&
+	    (hal_get_firmwareversion(rtlpriv) >= 0x3c))
+		digtable->dig_algorithm = DIG_ALGO_BY_TOW_PORT;
+	else
+		digtable->dig_algorithm =
+			 DIG_ALGO_BEFORE_CONNECT_BY_RSSI_AND_ALARM;
+
+	digtable->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
+	digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+	/* off=by real rssi value, on=by digtable->rssi_val for new dig */
+	digtable->dig_dbgmode = DM_DBG_OFF;
+	digtable->dig_slgorithm_switch = 0;
+
+	/* 2007/10/04 MH Define init gain threshol. */
+	digtable->dig_state = DM_STA_DIG_MAX;
+	digtable->dig_highpwrstate = DM_STA_DIG_MAX;
+
+	digtable->cur_sta_connectstate = DIG_STA_DISCONNECT;
+	digtable->pre_sta_connectstate = DIG_STA_DISCONNECT;
+	digtable->cur_ap_connectstate = DIG_AP_DISCONNECT;
+	digtable->pre_ap_connectstate = DIG_AP_DISCONNECT;
+
+	digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
+	digtable->rssi_highthresh = DM_DIG_THRESH_HIGH;
+
+	digtable->fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
+	digtable->fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
+
+	digtable->rssi_highpower_lowthresh = DM_DIG_HIGH_PWR_THRESH_LOW;
+	digtable->rssi_highpower_highthresh = DM_DIG_HIGH_PWR_THRESH_HIGH;
+
+	/* for dig debug rssi value */
+	digtable->rssi_val = 50;
+	digtable->backoff_val = DM_DIG_BACKOFF;
+	digtable->rx_gain_range_max = DM_DIG_MAX;
+
+	digtable->rx_gain_range_min = DM_DIG_MIN;
+
+	digtable->backoffval_range_max = DM_DIG_BACKOFF_MAX;
+	digtable->backoffval_range_min = DM_DIG_BACKOFF_MIN;
+}
+
+static void _rtl92s_dm_init_dynamic_txpower(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if ((hal_get_firmwareversion(rtlpriv) >= 60) &&
+	    (rtlpriv->dm.dm_type == DM_TYPE_BYDRIVER))
+		rtlpriv->dm.dynamic_txpower_enable = true;
+	else
+		rtlpriv->dm.dynamic_txpower_enable = false;
+
+	rtlpriv->dm.last_dtp_lvl = TX_HIGHPWR_LEVEL_NORMAL;
+	rtlpriv->dm.dynamic_txhighpower_lvl = TX_HIGHPWR_LEVEL_NORMAL;
+}
+
+void rtl92s_dm_init(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->dm.dm_type = DM_TYPE_BYDRIVER;
+	rtlpriv->dm.undecorated_smoothed_pwdb = -1;
+
+	_rtl92s_dm_init_dynamic_txpower(hw);
+	rtl92s_dm_init_edca_turbo(hw);
+	_rtl92s_dm_init_rate_adaptive_mask(hw);
+	_rtl92s_dm_init_txpowertracking_thermalmeter(hw);
+	_rtl92s_dm_init_dig(hw);
+
+	//rtl_write_dword(rtlpriv, WFM5, FW_CCA_CHK_ENABLE);
+}
+
+void rtl92s_dm_watchdog(struct ieee80211_hw *hw)
+{
+/*
+	_rtl92s_dm_check_edca_turbo(hw);
+	_rtl92s_dm_check_txpowertracking_thermalmeter(hw);
+	_rtl92s_dm_ctrl_initgain_byrssi(hw);
+	_rtl92s_dm_dynamic_txpower(hw);
+	_rtl92s_dm_refresh_rateadaptive_mask(hw);
+	_rtl92s_dm_switch_baseband_mrc(hw);
+*/
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/dm.h b/drivers/net/wireless/rtlwifi/rtl8192su/dm.h
new file mode 100644
index 0000000..6bf5c70
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/dm.h
@@ -0,0 +1,119 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef	__RTL_92S_DM_H__
+#define __RTL_92S_DM_H__
+
+enum dm_dig_alg {
+	DIG_ALGO_BY_FALSE_ALARM = 0,
+	DIG_ALGO_BY_RSSI	= 1,
+	DIG_ALGO_BEFORE_CONNECT_BY_RSSI_AND_ALARM = 2,
+	DIG_ALGO_BY_TOW_PORT = 3,
+	DIG_ALGO_MAX
+};
+
+enum dm_dig_two_port_alg {
+	DIG_TWO_PORT_ALGO_RSSI = 0,
+	DIG_TWO_PORT_ALGO_FALSE_ALARM = 1,
+};
+
+enum dm_dig_dbg {
+	DM_DBG_OFF = 0,
+	DM_DBG_ON = 1,
+	DM_DBG_MAX
+};
+
+enum dm_dig_sta {
+	DM_STA_DIG_OFF = 0,
+	DM_STA_DIG_ON,
+	DM_STA_DIG_MAX
+};
+
+enum dm_dig_connect {
+	DIG_STA_DISCONNECT = 0,
+	DIG_STA_CONNECT = 1,
+	DIG_STA_BEFORE_CONNECT = 2,
+	DIG_AP_DISCONNECT = 3,
+	DIG_AP_CONNECT = 4,
+	DIG_AP_ADD_STATION = 5,
+	DIG_CONNECT_MAX
+};
+
+enum dm_dig_ext_port_alg {
+	DIG_EXT_PORT_STAGE_0 = 0,
+	DIG_EXT_PORT_STAGE_1 = 1,
+	DIG_EXT_PORT_STAGE_2 = 2,
+	DIG_EXT_PORT_STAGE_3 = 3,
+	DIG_EXT_PORT_STAGE_MAX = 4,
+};
+
+enum dm_ratr_sta {
+	DM_RATR_STA_HIGH = 0,
+	DM_RATR_STA_MIDDLEHIGH = 1,
+	DM_RATR_STA_MIDDLE = 2,
+	DM_RATR_STA_MIDDLELOW = 3,
+	DM_RATR_STA_LOW = 4,
+	DM_RATR_STA_ULTRALOW = 5,
+	DM_RATR_STA_MAX
+};
+
+#define DM_TYPE_BYFW			0
+#define DM_TYPE_BYDRIVER		1
+
+#define	TX_HIGH_PWR_LEVEL_NORMAL	0
+#define	TX_HIGH_PWR_LEVEL_LEVEL1	1
+#define	TX_HIGH_PWR_LEVEL_LEVEL2	2
+
+#define	HAL_DM_DIG_DISABLE		BIT(0)	/* Disable Dig */
+#define	HAL_DM_HIPWR_DISABLE		BIT(1)	/* Disable High Power */
+
+#define	TX_HIGHPWR_LEVEL_NORMAL		0
+#define	TX_HIGHPWR_LEVEL_NORMAL1	1
+#define	TX_HIGHPWR_LEVEL_NORMAL2	2
+
+#define	TX_POWER_NEAR_FIELD_THRESH_LVL2	74
+#define	TX_POWER_NEAR_FIELD_THRESH_LVL1	67
+
+#define DM_DIG_THRESH_HIGH		40
+#define DM_DIG_THRESH_LOW		35
+#define	DM_FALSEALARM_THRESH_LOW	40
+#define	DM_FALSEALARM_THRESH_HIGH	1000
+#define	DM_DIG_HIGH_PWR_THRESH_HIGH	75
+#define	DM_DIG_HIGH_PWR_THRESH_LOW	70
+#define	DM_DIG_BACKOFF			12
+#define	DM_DIG_MAX			0x3e
+#define	DM_DIG_MIN			0x1c
+#define	DM_DIG_MIN_Netcore		0x12
+#define	DM_DIG_BACKOFF_MAX		12
+#define	DM_DIG_BACKOFF_MIN		-4
+
+void rtl92s_dm_watchdog(struct ieee80211_hw *hw);
+void rtl92s_dm_init(struct ieee80211_hw *hw);
+void rtl92s_dm_init_edca_turbo(struct ieee80211_hw *hw);
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/fw.c b/drivers/net/wireless/rtlwifi/rtl8192su/fw.c
new file mode 100644
index 0000000..1f2a019
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/fw.c
@@ -0,0 +1,800 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../pci.h"
+#include "../usb.h"
+#include "../base.h"
+#include "reg.h"
+#include "def.h"
+#include "fw.h"
+
+/*
+static void _rtl92s_fw_set_rqpn(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtl_write_dword(rtlpriv, RQPN, 0xffffffff);
+	rtl_write_dword(rtlpriv, RQPN + 4, 0xffffffff);
+	rtl_write_byte(rtlpriv, RQPN + 8, 0xff);
+	rtl_write_byte(rtlpriv, RQPN + 0xB, 0x80);
+}
+*/
+
+static bool _rtl92s_firmware_enable_cpu(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 ichecktime = 200;
+	u16 tmpu2b;
+	u8 tmpu1b, cpustatus = 0;
+
+	//_rtl92s_fw_set_rqpn(hw);
+
+	/* Enable CPU. */
+	tmpu1b = rtl_read_byte(rtlpriv, SYS_CLKR);
+	/* AFE source */
+	rtl_write_byte(rtlpriv, SYS_CLKR, (tmpu1b | SYS_CPU_CLKSEL));
+
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | FEN_CPUEN));
+
+	/* Polling IMEM Ready after CPU has refilled. */
+	do {
+		cpustatus = rtl_read_byte(rtlpriv, TCR);
+		if (cpustatus & IMEM_RDY) {
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				 "IMEM Ready after CPU has refilled\n");
+			break;
+		}
+
+		udelay(100);
+	} while (ichecktime--);
+
+	if (!(cpustatus & IMEM_RDY))
+		return false;
+
+	return true;
+}
+
+static enum fw_status _rtl92s_firmware_get_nextstatus(
+		enum fw_status fw_currentstatus)
+{
+	enum fw_status	next_fwstatus = 0;
+
+	switch (fw_currentstatus) {
+	case FW_STATUS_INIT:
+		next_fwstatus = FW_STATUS_LOAD_IMEM;
+		break;
+	case FW_STATUS_LOAD_IMEM:
+		next_fwstatus = FW_STATUS_LOAD_EMEM;
+		break;
+	case FW_STATUS_LOAD_EMEM:
+		next_fwstatus = FW_STATUS_LOAD_DMEM;
+		break;
+	case FW_STATUS_LOAD_DMEM:
+		next_fwstatus = FW_STATUS_READY;
+		break;
+	default:
+		break;
+	}
+
+	return next_fwstatus;
+}
+
+static u8 _rtl92s_firmware_header_map_rftype(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+
+	switch (rtlphy->rf_type) {
+	case RF_1T1R:
+		return 0x11;
+	case RF_1T2R:
+		return 0x12;
+	case RF_2T2R:
+		return 0x22;
+	default:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unknown RF type(%x)\n",
+			 rtlphy->rf_type);
+		break;
+	}
+	return 0x22;
+}
+
+static void _rtl92s_firmwareheader_priveupdate(struct ieee80211_hw *hw,
+		struct fw_priv *pfw_priv)
+{
+	/* Update RF types for RATR settings. */
+	pfw_priv->rf_config = _rtl92s_firmware_header_map_rftype(hw);
+}
+
+
+static void _rtl92s_cmd_complete(struct urb *urb)
+{
+}
+
+static bool _rtl92s_cmd_send_packet(struct ieee80211_hw *hw,
+		struct sk_buff *skb, u8 last)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+	struct rtl_tcb_desc *tcb_desc;
+	struct urb *urb;
+	u8 *pdesc;
+	u32 ep_num;
+
+	pdesc = (u8 *)skb_push(skb, RTL_TX_HEADER_SIZE);
+	rtlpriv->cfg->ops->fill_tx_cmddesc(hw, pdesc, 1, 1, skb);
+
+	tcb_desc = (struct rtl_tcb_desc *)(skb->cb);
+	/* _rtl_usb_transmit */
+	ep_num = rtlusb->ep_map.ep_mapping[tcb_desc->queue_index];
+	/* _rtl_usb_tx_urb_setup */
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb) {
+		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
+			 "Can't allocate URB for bulk out!\n");
+		kfree_skb(skb);
+		return false;
+	}
+	_rtl_install_trx_info(rtlusb, skb, ep_num);
+	usb_fill_bulk_urb(urb, rtlusb->udev, usb_sndbulkpipe(rtlusb->udev,
+			  ep_num), skb->data, skb->len, _rtl92s_cmd_complete,
+			  skb);
+	urb->transfer_flags |= URB_ZERO_PACKET;
+
+	/* _rtl_submit_tx_urb */
+	usb_anchor_urb(urb, &rtlusb->tx_submitted);
+	if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
+		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
+			 "Failed to submit urb\n");
+		usb_unanchor_urb(urb);
+		kfree_skb(skb);
+		return false;
+	}
+	usb_free_urb(urb);
+
+	return true;
+}
+
+static bool _rtl92s_firmware_downloadcode(struct ieee80211_hw *hw,
+		u8 *code_virtual_address, u32 buffer_len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct sk_buff *skb;
+	struct rtl_tcb_desc *tcb_desc;
+	unsigned char *seg_ptr;
+	//u16 frag_threshold = MAX_FIRMWARE_CODE_SIZE;
+	u16 frag_threshold = 0xC000;
+	u16 frag_length, frag_offset = 0;
+	u16 extra_descoffset = 0;
+	u8 last_inipkt = 0;
+
+	//_rtl92s_fw_set_rqpn(hw);
+
+	if (buffer_len >= MAX_FIRMWARE_CODE_SIZE) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Size over FIRMWARE_CODE_SIZE!\n");
+
+		return false;
+	}
+
+	extra_descoffset = 0;
+
+	do {
+		if ((buffer_len - frag_offset) > frag_threshold) {
+			frag_length = frag_threshold + extra_descoffset;
+		} else {
+			frag_length = (u16)(buffer_len - frag_offset +
+					    extra_descoffset);
+			last_inipkt = 1;
+		}
+
+		/* Allocate skb buffer to contain firmware */
+		/* info and tx descriptor info. */
+		skb = dev_alloc_skb(frag_length);
+		if (!skb)
+			return false;
+		skb_reserve(skb, extra_descoffset);
+		seg_ptr = (u8 *)skb_put(skb, (u32)(frag_length -
+					extra_descoffset));
+		memcpy(seg_ptr, code_virtual_address + frag_offset,
+		       (u32)(frag_length - extra_descoffset));
+
+		tcb_desc = (struct rtl_tcb_desc *)(skb->cb);
+		tcb_desc->queue_index = RTL_TXQ_VO;
+		tcb_desc->cmd_or_init = DESC_PACKET_TYPE_INIT;
+		tcb_desc->last_inipkt = last_inipkt;
+
+		_rtl92s_cmd_send_packet(hw, skb, last_inipkt);
+
+		frag_offset += (frag_length - extra_descoffset);
+
+	} while (frag_offset < buffer_len);
+
+	return true ;
+}
+
+static bool _rtl92s_firmware_checkready(struct ieee80211_hw *hw,
+		u8 loadfw_status)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rt_firmware *firmware = (struct rt_firmware *)rtlhal->pfirmware;
+	u32 tmpu4b;
+	u8 cpustatus = 0;
+	short pollingcnt = 1000;
+	bool rtstatus = true;
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "LoadStaus(%d)\n", loadfw_status);
+
+	firmware->fwstatus = (enum fw_status)loadfw_status;
+
+	switch (loadfw_status) {
+	case FW_STATUS_LOAD_IMEM:
+		/* Polling IMEM code done. */
+		do {
+			cpustatus = rtl_read_byte(rtlpriv, TCR);
+			if (cpustatus & IMEM_CODE_DONE)
+				break;
+			udelay(5);
+		} while (pollingcnt--);
+
+		if (!(cpustatus & IMEM_CHK_RPT) || (pollingcnt <= 0)) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "FW_STATUS_LOAD_IMEM FAIL CPU, Status=%x\n",
+				 cpustatus);
+			goto status_check_fail;
+		}
+		break;
+
+	case FW_STATUS_LOAD_EMEM:
+		/* Check Put Code OK and Turn On CPU */
+		/* Polling EMEM code done. */
+		do {
+			cpustatus = rtl_read_byte(rtlpriv, TCR);
+			if (cpustatus & EMEM_CODE_DONE)
+				break;
+			udelay(5);
+		} while (pollingcnt--);
+
+		if (!(cpustatus & EMEM_CHK_RPT) || (pollingcnt <= 0)) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "FW_STATUS_LOAD_EMEM FAIL CPU, Status=%x\n",
+				 cpustatus);
+			goto status_check_fail;
+		}
+
+		/* Turn On CPU */
+		rtstatus = _rtl92s_firmware_enable_cpu(hw);
+		if (!rtstatus) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "Enable CPU fail!\n");
+			goto status_check_fail;
+		}
+		break;
+
+	case FW_STATUS_LOAD_DMEM:
+		/* Polling DMEM code done */
+		do {
+			cpustatus = rtl_read_byte(rtlpriv, TCR);
+			if (cpustatus & DMEM_CODE_DONE)
+				break;
+			udelay(5);
+		} while (pollingcnt--);
+
+		if (!(cpustatus & DMEM_CODE_DONE) || (pollingcnt <= 0)) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "Polling DMEM code done fail ! cpustatus(%#x)\n",
+				 cpustatus);
+			goto status_check_fail;
+		}
+
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+			 "DMEM code download success, cpustatus(%#x)\n",
+			 cpustatus);
+
+		/* Prevent Delay too much and being scheduled out */
+		/* Polling Load Firmware ready */
+		pollingcnt = 30;
+		do {
+			cpustatus = rtl_read_byte(rtlpriv, TCR);
+			if (cpustatus & FWRDY)
+				break;
+			msleep(100);
+		} while (pollingcnt--);
+
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+			 "Polling Load Firmware ready, cpustatus(%x)\n",
+			 cpustatus);
+
+		if (((cpustatus & LOAD_FW_READY) != LOAD_FW_READY) ||
+		    (pollingcnt <= 0)) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "Polling Load Firmware ready fail ! cpustatus(%x)\n",
+				 cpustatus);
+			goto status_check_fail;
+		}
+
+		/* If right here, we can set TCR/RCR to desired value  */
+		/* and config MAC lookback mode to normal mode */
+		tmpu4b = rtl_read_dword(rtlpriv, TCR);
+		rtl_write_dword(rtlpriv, TCR, (tmpu4b & (~TCR_ICV)));
+
+		tmpu4b = rtl_read_dword(rtlpriv, RCR);
+		rtl_write_dword(rtlpriv, RCR, (tmpu4b | RCR_RX_TCPOFDL_EN |
+				RCR_APP_PHYST_RXFF | RCR_APP_ICV | RCR_APP_MIC));
+
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+			 "Current RCR settings(%#x)\n", tmpu4b);
+
+		/* Set to normal mode. */
+		rtl_write_byte(rtlpriv, LBKMD_SEL, LBK_NORMAL);
+		break;
+
+	default:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+			 "Unknown status check!\n");
+		rtstatus = false;
+		break;
+	}
+
+status_check_fail:
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "loadfw_status(%d), rtstatus(%x)\n",
+		 loadfw_status, rtstatus);
+	return rtstatus;
+}
+
+int rtl92s_download_fw(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+	struct rt_firmware *firmware = NULL;
+	struct fw_hdr *pfwheader;
+	struct fw_priv *pfw_priv = NULL;
+	u8 *puc_mappedfile = NULL;
+	u32 ul_filelength = 0;
+	u8 fwhdr_size = RT_8192S_FIRMWARE_HDR_SIZE;
+	u8 fwstatus = FW_STATUS_INIT;
+	bool rtstatus = true;
+
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
+		return 1;
+
+	firmware = (struct rt_firmware *)rtlhal->pfirmware;
+	firmware->fwstatus = FW_STATUS_INIT;
+
+	puc_mappedfile = firmware->sz_fw_tmpbuffer;
+
+	/* 1. Retrieve FW header. */
+	firmware->pfwheader = (struct fw_hdr *) puc_mappedfile;
+	pfwheader = firmware->pfwheader;
+	memset(&pfwheader->fwpriv, 0, sizeof(struct fw_priv));
+	firmware->firmwareversion =  byte(pfwheader->version, 0);
+	firmware->pfwheader->fwpriv.hci_sel = 0x12; /* RTL8712_HCI_TYPE_72USB */
+	firmware->pfwheader->fwpriv.usb_ep_num = rtlusb->in_ep_nums +
+			rtlusb->out_ep_nums;
+	firmware->pfwheader->fwpriv.vcs_type = 2;
+	firmware->pfwheader->fwpriv.vcs_mode = 1;
+	firmware->pfwheader->fwpriv.turbo_mode = 1;
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "signature:%x, version:%x, size:%x, imemsize:%x, sram size:%x\n",
+		 pfwheader->signature,
+		 pfwheader->version, pfwheader->dmem_size,
+		 pfwheader->img_imem_size, pfwheader->img_sram_size);
+
+	/* 2. Retrieve IMEM image. */
+	if ((pfwheader->img_imem_size == 0) || (pfwheader->img_imem_size >
+	    sizeof(firmware->fw_imem))) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "memory for data image is less than IMEM required\n");
+		goto fail;
+	} else {
+		puc_mappedfile += fwhdr_size;
+
+		memcpy(firmware->fw_imem, puc_mappedfile,
+		       pfwheader->img_imem_size);
+		firmware->fw_imem_len = pfwheader->img_imem_size;
+	}
+
+	/* 3. Retriecve EMEM image. */
+	if (pfwheader->img_sram_size > sizeof(firmware->fw_emem)) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "memory for data image is less than EMEM required\n");
+		goto fail;
+	} else {
+		puc_mappedfile += firmware->fw_imem_len;
+
+		memcpy(firmware->fw_emem, puc_mappedfile,
+		       pfwheader->img_sram_size);
+		firmware->fw_emem_len = pfwheader->img_sram_size;
+	}
+
+	/* 4. download fw now */
+	fwstatus = _rtl92s_firmware_get_nextstatus(firmware->fwstatus);
+	while (fwstatus != FW_STATUS_READY) {
+		/* Image buffer redirection. */
+		switch (fwstatus) {
+		case FW_STATUS_LOAD_IMEM:
+			puc_mappedfile = firmware->fw_imem;
+			ul_filelength = firmware->fw_imem_len;
+			break;
+		case FW_STATUS_LOAD_EMEM:
+			puc_mappedfile = firmware->fw_emem;
+			ul_filelength = firmware->fw_emem_len;
+			break;
+		case FW_STATUS_LOAD_DMEM:
+			/* Partial update the content of header private. */
+			pfwheader = firmware->pfwheader;
+			pfw_priv = &pfwheader->fwpriv;
+			_rtl92s_firmwareheader_priveupdate(hw, pfw_priv);
+			puc_mappedfile = (u8 *)(firmware->pfwheader) +
+					RT_8192S_FIRMWARE_HDR_EXCLUDE_PRI_SIZE;
+			ul_filelength = fwhdr_size -
+					RT_8192S_FIRMWARE_HDR_EXCLUDE_PRI_SIZE;
+			break;
+		default:
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "Unexpected Download step!!\n");
+			goto fail;
+			break;
+		}
+
+		/* <2> Download image file */
+		rtstatus = _rtl92s_firmware_downloadcode(hw, puc_mappedfile,
+				ul_filelength);
+
+		if (!rtstatus) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "fail!\n");
+			goto fail;
+		}
+
+		/* <3> Check whether load FW process is ready */
+		rtstatus = _rtl92s_firmware_checkready(hw, fwstatus);
+		if (!rtstatus) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "fail!\n");
+			goto fail;
+		}
+
+		fwstatus = _rtl92s_firmware_get_nextstatus(firmware->fwstatus);
+	}
+
+	return rtstatus;
+fail:
+	return 0;
+}
+
+static u32 _rtl92s_fill_h2c_cmd(struct sk_buff *skb, u32 h2cbufferlen,
+				u32 cmd_num, u32 *pelement_id, u32 *pcmd_len,
+				u8 **pcmb_buffer, u8 *cmd_start_seq)
+{
+	u32 totallen = 0, len = 0, tx_desclen = 0;
+	u32 pre_continueoffset = 0;
+	u8 *ph2c_buffer;
+	u8 i = 0;
+
+	do {
+		/* 8 - Byte aligment */
+		len = H2C_TX_CMD_HDR_LEN + N_BYTE_ALIGMENT(pcmd_len[i], 8);
+
+		/* Buffer length is not enough */
+		if (h2cbufferlen < totallen + len + tx_desclen)
+			break;
+
+		/* Clear content */
+		ph2c_buffer = (u8 *)skb_put(skb, (u32)len);
+		memset((ph2c_buffer + totallen + tx_desclen), 0, len);
+
+		/* CMD len */
+		SET_BITS_TO_LE_4BYTE((ph2c_buffer + totallen + tx_desclen),
+				      0, 16, N_BYTE_ALIGMENT(pcmd_len[i], 8));
+
+		/* CMD ID */
+		SET_BITS_TO_LE_4BYTE((ph2c_buffer + totallen + tx_desclen),
+				      16, 8, pelement_id[i]);
+
+		/* CMD Sequence */
+		*cmd_start_seq = *cmd_start_seq % 0x80;
+		SET_BITS_TO_LE_4BYTE((ph2c_buffer + totallen + tx_desclen),
+				      24, 7, *cmd_start_seq);
+		++*cmd_start_seq;
+
+		/* Copy memory */
+		memcpy((ph2c_buffer + totallen + tx_desclen +
+			H2C_TX_CMD_HDR_LEN), pcmb_buffer[i], pcmd_len[i]);
+
+		/* CMD continue */
+		/* set the continue in prevoius cmd. */
+		if (i < cmd_num - 1)
+			SET_BITS_TO_LE_4BYTE((ph2c_buffer + pre_continueoffset),
+					      31, 1, 1);
+
+		pre_continueoffset = totallen;
+
+		totallen += len;
+	} while (++i < cmd_num);
+
+	return totallen;
+}
+
+static u32 _rtl92s_get_h2c_cmdlen(u32 h2cbufferlen, u32 cmd_num, u32 *pcmd_len)
+{
+	u32 totallen = 0, len = 0, tx_desclen = 0;
+	u8 i = 0;
+
+	do {
+		/* 8 - Byte aligment */
+		len = H2C_TX_CMD_HDR_LEN + N_BYTE_ALIGMENT(pcmd_len[i], 8);
+
+		/* Buffer length is not enough */
+		if (h2cbufferlen < totallen + len + tx_desclen)
+			break;
+
+		totallen += len;
+	} while (++i < cmd_num);
+
+	return totallen + tx_desclen;
+}
+
+static bool _rtl92s_firmware_set_h2c_cmd(struct ieee80211_hw *hw, u8 h2c_cmd,
+					 u8 *pcmd_buffer)
+{
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_tcb_desc *cb_desc;
+	struct sk_buff *skb;
+	u32	element_id = 0;
+	u32	cmd_len = 0;
+	u32	len;
+
+	switch (h2c_cmd) {
+	case FW_H2C_SETPWRMODE:
+		element_id = H2C_SETPWRMODE_CMD ;
+		cmd_len = sizeof(struct h2c_set_pwrmode_parm);
+		break;
+	case FW_H2C_JOINBSSRPT:
+		element_id = H2C_JOINBSSRPT_CMD;
+		cmd_len = sizeof(struct h2c_joinbss_rpt_parm);
+		break;
+/*
+	case FW_H2C_WOWLAN_UPDATE_GTK:
+		element_id = H2C_WOWLAN_UPDATE_GTK_CMD;
+		cmd_len = sizeof(struct h2c_wpa_two_way_parm);
+		break;
+*/
+	case FW_H2C_WOWLAN_UPDATE_IV:
+		element_id = H2C_WOWLAN_UPDATE_IV_CMD;
+		cmd_len = sizeof(unsigned long long);
+		break;
+	case FW_H2C_WOWLAN_OFFLOAD:
+		element_id = H2C_WOWLAN_FW_OFFLOAD;
+		cmd_len = sizeof(u8);
+		break;
+	case FW_H2C_SITESURVEY:
+		element_id = H2C_SITESURVEY_CMD;
+		cmd_len = sizeof(struct h2c_sitesurvey_parm);
+		break;
+	case FW_H2C_DISCONNECT:
+		element_id = H2C_DISCONNECT_CMD;
+		cmd_len = sizeof(struct h2c_disconnect_parm);
+		break;
+	case FW_H2C_SETCHANNEL:
+		element_id = H2C_SETCHANNEL_CMD;
+		cmd_len = sizeof(struct h2c_setchannel_parm);
+		break;
+	case FW_H2C_SETAUTH:
+		element_id = H2C_SETAUTH_CMD;
+		cmd_len = sizeof(struct h2c_setauth_parm);
+		break;
+	default:
+		break;
+	}
+
+	len = _rtl92s_get_h2c_cmdlen(MAX_TRANSMIT_BUFFER_SIZE, 1, &cmd_len);
+	skb = dev_alloc_skb(len);
+	if (!skb)
+		return false;
+	cb_desc = (struct rtl_tcb_desc *)(skb->cb);
+	cb_desc->queue_index = TXCMD_QUEUE;
+	cb_desc->cmd_or_init = DESC_PACKET_TYPE_NORMAL;
+	cb_desc->last_inipkt = false;
+
+	_rtl92s_fill_h2c_cmd(skb, MAX_TRANSMIT_BUFFER_SIZE, 1, &element_id,
+			&cmd_len, &pcmd_buffer,	&rtlhal->h2c_txcmd_seq);
+	_rtl92s_cmd_send_packet(hw, skb, false);
+
+	return true;
+}
+
+void rtl92s_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 Mode)
+{
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct h2c_set_pwrmode_parm	pwrmode;
+	u16 max_wakeup_period = 0;
+
+	pwrmode.mode = Mode;
+	pwrmode.flag_low_traffic_en = 0;
+	pwrmode.flag_lpnav_en = 0;
+	pwrmode.flag_rf_low_snr_en = 0;
+	pwrmode.flag_dps_en = 0;
+	pwrmode.bcn_rx_en = 0;
+	pwrmode.bcn_to = 0;
+	SET_BITS_TO_LE_2BYTE((u8 *)(&pwrmode) + 8, 0, 16,
+			mac->vif->bss_conf.beacon_int);
+	pwrmode.app_itv = 0;
+	pwrmode.awake_bcn_itvl = ppsc->reg_max_lps_awakeintvl;
+	pwrmode.smart_ps = 1;
+	pwrmode.bcn_pass_period = 10;
+
+	/* Set beacon pass count */
+	if (pwrmode.mode == FW_PS_MIN_MODE)
+		max_wakeup_period = mac->vif->bss_conf.beacon_int;
+	else if (pwrmode.mode == FW_PS_MAX_MODE)
+		max_wakeup_period = mac->vif->bss_conf.beacon_int *
+			mac->vif->bss_conf.dtim_period;
+
+	if (max_wakeup_period >= 500)
+		pwrmode.bcn_pass_cnt = 1;
+	else if ((max_wakeup_period >= 300) && (max_wakeup_period < 500))
+		pwrmode.bcn_pass_cnt = 2;
+	else if ((max_wakeup_period >= 200) && (max_wakeup_period < 300))
+		pwrmode.bcn_pass_cnt = 3;
+	else if ((max_wakeup_period >= 20) && (max_wakeup_period < 200))
+		pwrmode.bcn_pass_cnt = 5;
+	else
+		pwrmode.bcn_pass_cnt = 1;
+
+	_rtl92s_firmware_set_h2c_cmd(hw, FW_H2C_SETPWRMODE, (u8 *)&pwrmode);
+
+}
+
+void rtl92s_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw,
+		u8 mstatus, u8 ps_qosinfo)
+{
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct h2c_joinbss_rpt_parm joinbss_rpt;
+
+	joinbss_rpt.opmode = mstatus;
+	joinbss_rpt.ps_qos_info = ps_qosinfo;
+	joinbss_rpt.bssid[0] = mac->bssid[0];
+	joinbss_rpt.bssid[1] = mac->bssid[1];
+	joinbss_rpt.bssid[2] = mac->bssid[2];
+	joinbss_rpt.bssid[3] = mac->bssid[3];
+	joinbss_rpt.bssid[4] = mac->bssid[4];
+	joinbss_rpt.bssid[5] = mac->bssid[5];
+	SET_BITS_TO_LE_2BYTE((u8 *)(&joinbss_rpt) + 8, 0, 16,
+			mac->vif->bss_conf.beacon_int);
+	SET_BITS_TO_LE_2BYTE((u8 *)(&joinbss_rpt) + 10, 0, 16, mac->assoc_id);
+
+	_rtl92s_firmware_set_h2c_cmd(hw, FW_H2C_JOINBSSRPT, (u8 *)&joinbss_rpt);
+}
+
+int rtl92s_set_fw_sitesurvey_cmd(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif, struct cfg80211_scan_request *req)
+{
+	struct h2c_sitesurvey_parm survey_args;
+
+	memset(&survey_args, 0, sizeof(struct h2c_sitesurvey_parm));
+	survey_args.bsslimit = cpu_to_le32(48);
+
+	if (req->n_ssids) {
+		survey_args.active = cpu_to_le32(1);
+		survey_args.ssidlen = cpu_to_le32(req->ssids[0].ssid_len);
+		memcpy(survey_args.ssid, req->ssids[0].ssid, req->ssids[0].ssid_len);
+	}
+
+	return (int)!_rtl92s_firmware_set_h2c_cmd(hw, FW_H2C_SITESURVEY, (u8 *)&survey_args);
+}
+
+void rtl92s_set_fw_disconnect_cmd(struct ieee80211_hw *hw)
+{
+	struct h2c_disconnect_parm disconnect_args;
+
+	memset(&disconnect_args, 0, sizeof(struct h2c_disconnect_parm));
+
+	_rtl92s_firmware_set_h2c_cmd(hw, FW_H2C_DISCONNECT, (u8 *)&disconnect_args);
+}
+
+u8 rtl92s_set_fw_setchannel_cmd(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct h2c_setchannel_parm chan_args;
+
+	RT_TRACE(rtlpriv, COMP_CMD, DBG_TRACE, "SetChannel: %i\n",
+		 rtlphy->current_channel);
+
+	chan_args.channel = cpu_to_le32(rtlphy->current_channel);
+
+	return (u8)_rtl92s_firmware_set_h2c_cmd(hw, FW_H2C_SETCHANNEL, (u8 *)&chan_args);
+}
+
+void rtl92s_set_fw_setauth_cmd(struct ieee80211_hw *hw)
+{
+	struct h2c_setauth_parm auth_args;
+
+	memset(&auth_args, 0, sizeof(struct h2c_setauth_parm));
+	//auth_args.mode = cpu_to_le32(0);
+
+	_rtl92s_firmware_set_h2c_cmd(hw, FW_H2C_SETAUTH, (u8 *)&auth_args);
+}
+
+u8 rtl92s_fw_iocmd(struct ieee80211_hw *hw, u32 cmd)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int pollcount = 50;
+
+	rtl_write_dword(rtlpriv, IOCMD_CTRL, cmd);
+	msleep(100);
+	while (rtl_read_dword(rtlpriv, IOCMD_CTRL) && pollcount > 0) {
+		pollcount--;
+		msleep(20);
+	}
+
+	return !!pollcount;
+}
+
+void rtl92s_fw_iocmd_data(struct ieee80211_hw *hw, u32 *val, u8 flag)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (flag == 0) { /* set */
+		rtl_write_dword(rtlpriv, IOCMD_DATA, *val);
+	}
+	else { /* query */
+		*val = rtl_read_dword(rtlpriv, IOCMD_DATA);
+	}
+}
+
+u32 rtl92s_fw_iocmd_read(struct ieee80211_hw *hw, u8 ioclass, u16 iovalue, u8 ioindex)
+{
+	u32 tmpcmd, retval;
+
+	tmpcmd = (ioclass << 24) | (iovalue << 8) | ioindex;
+	if (rtl92s_fw_iocmd(hw, tmpcmd))
+		rtl92s_fw_iocmd_data(hw, &retval, 1);
+	else
+		retval = 0;
+
+	return retval;
+}
+
+u8 rtl92s_fw_iocmd_write(struct ieee80211_hw *hw, u8 ioclass, u16 iovalue, u8 ioindex, u32 val)
+{
+	u32 tmpcmd;
+
+	rtl92s_fw_iocmd_data(hw, &val, 0);
+	msleep(100);
+	tmpcmd = (ioclass << 24) | (iovalue << 8) | ioindex;
+	return rtl92s_fw_iocmd(hw, tmpcmd);
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/fw.h b/drivers/net/wireless/rtlwifi/rtl8192su/fw.h
new file mode 100644
index 0000000..2e22284
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/fw.h
@@ -0,0 +1,456 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_FIRMWARE92S_H__
+#define __REALTEK_FIRMWARE92S_H__
+
+#define RTL8192_MAX_FIRMWARE_CODE_SIZE		(64 * 1024)
+#define RTL8192_MAX_RAW_FIRMWARE_CODE_SIZE	200000
+#define RTL8192_CPU_START_OFFSET		0x80
+/* Firmware Local buffer size. 64k */
+#define	MAX_FIRMWARE_CODE_SIZE			0xFF00
+
+#define	RT_8192S_FIRMWARE_HDR_SIZE		80
+#define RT_8192S_FIRMWARE_HDR_EXCLUDE_PRI_SIZE	32
+
+/* support till 64 bit bus width OS */
+#define MAX_DEV_ADDR_SIZE			8
+#define MAX_FIRMWARE_INFORMATION_SIZE		32
+#define MAX_802_11_HEADER_LENGTH		(40 + \
+						MAX_FIRMWARE_INFORMATION_SIZE)
+#define ENCRYPTION_MAX_OVERHEAD			128
+#define MAX_FRAGMENT_COUNT			8
+#define MAX_TRANSMIT_BUFFER_SIZE		(1600 + \
+						(MAX_802_11_HEADER_LENGTH + \
+						ENCRYPTION_MAX_OVERHEAD) *\
+						MAX_FRAGMENT_COUNT)
+
+#define H2C_TX_CMD_HDR_LEN			8
+
+/* The following DM control code are for Reg0x364, */
+#define	FW_DIG_ENABLE_CTL			BIT(0)
+#define	FW_HIGH_PWR_ENABLE_CTL			BIT(1)
+#define	FW_SS_CTL				BIT(2)
+#define	FW_RA_INIT_CTL				BIT(3)
+#define	FW_RA_BG_CTL				BIT(4)
+#define	FW_RA_N_CTL				BIT(5)
+#define	FW_PWR_TRK_CTL				BIT(6)
+#define	FW_IQK_CTL				BIT(7)
+#define	FW_FA_CTL				BIT(8)
+#define	FW_DRIVER_CTRL_DM_CTL			BIT(9)
+#define	FW_PAPE_CTL_BY_SW_HW			BIT(10)
+#define	FW_DISABLE_ALL_DM			0
+#define	FW_PWR_TRK_PARAM_CLR			0x0000ffff
+#define	FW_RA_PARAM_CLR				0xffff0000
+
+enum desc_packet_type {
+	DESC_PACKET_TYPE_INIT = 0,
+	DESC_PACKET_TYPE_NORMAL = 1,
+};
+
+/* 8-bytes alignment required */
+struct fw_priv {
+	/* --- long word 0 ---- */
+	/* 0x12: CE product, 0x92: IT product */
+	u8 signature_0;
+	/* 0x87: CE product, 0x81: IT product */
+	u8 signature_1;
+	/* 0x81: PCI-AP, 01:PCIe, 02: 92S-U,
+	 * 0x82: USB-AP, 0x12: 72S-U, 03:SDIO */
+	u8 hci_sel;
+	/* the same value as reigster value  */
+	u8 chip_version;
+	/* customer  ID low byte */
+	u8 customer_id_0;
+	/* customer  ID high byte */
+	u8 customer_id_1;
+	/* 0x11:  1T1R, 0x12: 1T2R,
+	 * 0x92: 1T2R turbo, 0x22: 2T2R */
+	u8 rf_config;
+	/* 4: 4EP, 6: 6EP, 11: 11EP */
+	u8 usb_ep_num;
+
+	/* --- long word 1 ---- */
+	/* regulatory class bit map 0 */
+	u8 regulatory_class_0;
+	/* regulatory class bit map 1 */
+	u8 regulatory_class_1;
+	/* regulatory class bit map 2 */
+	u8 regulatory_class_2;
+	/* regulatory class bit map 3 */
+	u8 regulatory_class_3;
+	/* 0:SWSI, 1:HWSI, 2:HWPI */
+	u8 rfintfs;
+	u8 def_nettype;
+	u8 turbo_mode;
+	u8 lowpower_mode;
+
+	/* --- long word 2 ---- */
+	/* 0x00: normal, 0x03: MACLBK, 0x01: PHYLBK */
+	u8 lbk_mode;
+	/* 1: for MP use, 0: for normal
+	 * driver (to be discussed) */
+	u8 mp_mode;
+	/* 0: off, 1: on, 2: auto */
+	u8 vcs_type;
+	/* 0: none, 1: RTS/CTS, 2: CTS to self */
+	u8 vcs_mode;
+	u8 rsvd022;
+	u8 rsvd023;
+	u8 rsvd024;
+	u8 rsvd025;
+
+	/* --- long word 3 ---- */
+	/* QoS enable */
+	u8 qos_en;
+	/* 40MHz BW enable */
+	/* 4181 convert AMSDU to AMPDU, 0: disable */
+	u8 bw_40mhz_en;
+	u8 amsdu2ampdu_en;
+	/* 11n AMPDU enable */
+	u8 ampdu_en;
+	/* FW offloads, 0: driver handles */
+	u8 rate_control_offload;
+	/* FW offloads, 0: driver handles */
+	u8 aggregation_offload;
+	u8 rsvd030;
+	u8 rsvd031;
+
+	/* --- long word 4 ---- */
+	/* 1. FW offloads, 0: driver handles */
+	u8 beacon_offload;
+	/* 2. FW offloads, 0: driver handles */
+	u8 mlme_offload;
+	/* 3. FW offloads, 0: driver handles */
+	u8 hwpc_offload;
+	/* 4. FW offloads, 0: driver handles */
+	u8 tcp_checksum_offload;
+	/* 5. FW offloads, 0: driver handles */
+	u8 tcp_offload;
+	/* 6. FW offloads, 0: driver handles */
+	u8 ps_control_offload;
+	/* 7. FW offloads, 0: driver handles */
+	u8 wwlan_offload;
+	u8 rsvd040;
+
+	/* --- long word 5 ---- */
+	/* tcp tx packet length low byte */
+	u8 tcp_tx_frame_len_L;
+	/* tcp tx packet length high byte */
+	u8 tcp_tx_frame_len_H;
+	/* tcp rx packet length low byte */
+	u8 tcp_rx_frame_len_L;
+	/* tcp rx packet length high byte */
+	u8 tcp_rx_frame_len_H;
+	u8 rsvd050;
+	u8 rsvd051;
+	u8 rsvd052;
+	u8 rsvd053;
+};
+
+/* 8-byte alinment required */
+struct fw_hdr {
+
+	/* --- LONG WORD 0 ---- */
+	u16 signature;
+	/* 0x8000 ~ 0x8FFF for FPGA version,
+	 * 0x0000 ~ 0x7FFF for ASIC version, */
+	u16 version;
+	/* define the size of boot loader */
+	u32 dmem_size;
+
+
+	/* --- LONG WORD 1 ---- */
+	/* define the size of FW in IMEM */
+	u32 img_imem_size;
+	/* define the size of FW in SRAM */
+	u32 img_sram_size;
+
+	/* --- LONG WORD 2 ---- */
+	/* define the size of DMEM variable */
+	u32 fw_priv_size;
+	u32 rsvd0;
+
+	/* --- LONG WORD 3 ---- */
+	u32 rsvd1;
+	u32 rsvd2;
+
+	struct fw_priv fwpriv;
+
+} ;
+
+enum fw_status {
+	FW_STATUS_INIT = 0,
+	FW_STATUS_LOAD_IMEM = 1,
+	FW_STATUS_LOAD_EMEM = 2,
+	FW_STATUS_LOAD_DMEM = 3,
+	FW_STATUS_READY = 4,
+};
+
+struct rt_firmware {
+	struct fw_hdr *pfwheader;
+	enum fw_status fwstatus;
+	u16 firmwareversion;
+	u8 fw_imem[RTL8192_MAX_FIRMWARE_CODE_SIZE];
+	u8 fw_emem[RTL8192_MAX_FIRMWARE_CODE_SIZE];
+	u32 fw_imem_len;
+	u32 fw_emem_len;
+	u8 sz_fw_tmpbuffer[RTL8192_MAX_RAW_FIRMWARE_CODE_SIZE];
+	u32 sz_fw_tmpbufferlen;
+	u16 cmdpacket_fragthresold;
+};
+
+struct h2c_set_pwrmode_parm {
+	u8 mode;
+	u8 flag_low_traffic_en;
+	u8 flag_lpnav_en;
+	u8 flag_rf_low_snr_en;
+	/* 1: dps, 0: 32k */
+	u8 flag_dps_en;
+	u8 bcn_rx_en;
+	u8 bcn_pass_cnt;
+	/* beacon TO (ms). ¡§=0¡¨ no limit. */
+	u8 bcn_to;
+	u16	bcn_itv;
+	/* only for VOIP mode. */
+	u8 app_itv;
+	u8 awake_bcn_itvl;
+	u8 smart_ps;
+	/* unit: 100 ms */
+	u8 bcn_pass_period;
+};
+
+struct h2c_joinbss_rpt_parm {
+	u8 opmode;
+	u8 ps_qos_info;
+	u8 bssid[6];
+	u16 bcnitv;
+	u16 aid;
+} ;
+
+struct h2c_sitesurvey_parm {
+	u32 active;
+	u32 bsslimit;
+	u32 ssidlen;
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
+};
+
+struct h2c_disconnect_parm {
+	u32 rsvd0;
+};
+
+struct h2c_setchannel_parm {
+	u32 channel;
+};
+
+struct h2c_setauth_parm {
+	u8 mode;
+	u8 _1x;
+	u8 rsvd2[2];
+};
+
+struct h2c_wpa_ptk {
+	/* EAPOL-Key Key Confirmation Key (KCK) */
+	u8 kck[16];
+	/* EAPOL-Key Key Encryption Key (KEK) */
+	u8 kek[16];
+	/* Temporal Key 1 (TK1) */
+	u8 tk1[16];
+	union {
+		/* Temporal Key 2 (TK2) */
+		u8 tk2[16];
+		struct {
+			u8 tx_mic_key[8];
+			u8 rx_mic_key[8];
+		} athu;
+	} u;
+};
+
+struct h2c_wpa_two_way_parm {
+	/* algorithm TKIP or AES */
+	u8 pairwise_en_alg;
+	u8 group_en_alg;
+	struct h2c_wpa_ptk wpa_ptk_value;
+} ;
+
+enum h2c_cmd {
+	FW_H2C_SETPWRMODE = 0,
+	FW_H2C_JOINBSSRPT = 1,
+	FW_H2C_WOWLAN_UPDATE_GTK = 2,
+	FW_H2C_WOWLAN_UPDATE_IV = 3,
+	FW_H2C_WOWLAN_OFFLOAD = 4,
+	FW_H2C_SITESURVEY = 5,
+	FW_H2C_DISCONNECT = 6,
+	FW_H2C_SETCHANNEL = 7,
+	FW_H2C_SETOPMODE = 8,
+	FW_H2C_SETAUTH = 8,
+};
+
+enum fw_h2c_cmd {
+	H2C_READ_MACREG_CMD,				/*0*/
+	H2C_WRITE_MACREG_CMD,
+	H2C_READBB_CMD,
+	H2C_WRITEBB_CMD,
+	H2C_READRF_CMD,
+	H2C_WRITERF_CMD,				/*5*/
+	H2C_READ_EEPROM_CMD,
+	H2C_WRITE_EEPROM_CMD,
+	H2C_READ_EFUSE_CMD,
+	H2C_WRITE_EFUSE_CMD,
+	H2C_READ_CAM_CMD,				/*10*/
+	H2C_WRITE_CAM_CMD,
+	H2C_SETBCNITV_CMD,
+	H2C_SETMBIDCFG_CMD,
+	H2C_JOINBSS_CMD,
+	H2C_DISCONNECT_CMD,				/*15*/
+	H2C_CREATEBSS_CMD,
+	H2C_SETOPMode_CMD,
+	H2C_SITESURVEY_CMD,
+	H2C_SETAUTH_CMD,
+	H2C_SETKEY_CMD,					/*20*/
+	H2C_SETSTAKEY_CMD,
+	H2C_SETASSOCSTA_CMD,
+	H2C_DELASSOCSTA_CMD,
+	H2C_SETSTAPWRSTATE_CMD,
+	H2C_SETBASICRATE_CMD,				/*25*/
+	H2C_GETBASICRATE_CMD,
+	H2C_SETDATARATE_CMD,
+	H2C_GETDATARATE_CMD,
+	H2C_SETPHYINFO_CMD,
+	H2C_GETPHYINFO_CMD,				/*30*/
+	H2C_SETPHY_CMD,
+	H2C_GETPHY_CMD,
+	H2C_READRSSI_CMD,
+	H2C_READGAIN_CMD,
+	H2C_SETATIM_CMD,				/*35*/
+	H2C_SETPWRMODE_CMD,
+	H2C_JOINBSSRPT_CMD,
+	H2C_SETRATABLE_CMD,
+	H2C_GETRATABLE_CMD,
+	H2C_GETCCXREPORT_CMD,				/*40*/
+	H2C_GETDTMREPORT_CMD,
+	H2C_GETTXRATESTATICS_CMD,
+	H2C_SETUSBSUSPEND_CMD,
+	H2C_SETH2CLBK_CMD,
+	H2C_TMP1,					/*45*/
+	H2C_SETCHANNEL_CMD,
+	H2C_WOWLAN_FW_OFFLOAD,
+	H2C_TMP2,
+	H2C_TMP3,
+	H2C_WOWLAN_UPDATE_IV_CMD,			/*50*/
+	H2C_TMP4,
+	MAX_H2CCMD					/*52*/
+};
+
+struct ndis_802_11_ssid {
+	u32 ssidlen;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+};
+
+struct ndis_802_11_configuration_fh {
+	u32 len;
+	u32 hoppattern;
+	u32 hopset;
+	u32 dwelltime;
+};
+
+struct ndis_802_11_configuration {
+	u32 len;
+	u32 beaconperiod;
+	u32 atimwindow;
+	u32 dsconfig;
+	struct ndis_802_11_configuration_fh fhconfig;
+};
+
+struct ndis_wlan_bssid_ex {
+	u32 len;
+	u8 macaddr[6];
+	u8 rsvd10[2];
+	struct ndis_802_11_ssid ssid;
+	u32 privacy;
+	s32 rssi;
+	u32 networktype; // enum
+	struct ndis_802_11_configuration config;
+	u32 inframode; // enum
+	u8 supportedrates[16]; // type
+	u32 ielen;
+	u8 ies[0];
+};
+
+struct ndis_802_11_fixed_ies {
+	u8 timestamp[8];
+	u16 beaconint;
+	u16 caps;
+};
+
+/* The following macros are used for FW
+ * CMD map and parameter updated. */
+#define FW_CMD_IO_CLR(rtlpriv, _Bit)				\
+	do {							\
+		udelay(1000);					\
+		rtlpriv->rtlhal.fwcmd_iomap &= (~_Bit);		\
+	} while (0)
+
+#define FW_CMD_IO_UPDATE(rtlpriv, _val)				\
+	rtlpriv->rtlhal.fwcmd_iomap = _val;
+
+#define FW_CMD_IO_SET(rtlpriv, _val)				\
+	do {							\
+		rtl_write_word(rtlpriv, LBUS_MON_ADDR, (u16)_val);	\
+		FW_CMD_IO_UPDATE(rtlpriv, _val);		\
+	} while (0)
+
+#define FW_CMD_PARA_SET(rtlpriv, _val)				\
+	do {							\
+		rtl_write_dword(rtlpriv, LBUS_ADDR_MASK, _val);	\
+		rtlpriv->rtlhal.fwcmd_ioparam = _val;		\
+	} while (0)
+
+#define FW_CMD_IO_QUERY(rtlpriv)				\
+	(u16)(rtlpriv->rtlhal.fwcmd_iomap)
+#define FW_CMD_IO_PARA_QUERY(rtlpriv)				\
+	((u32)(rtlpriv->rtlhal.fwcmd_ioparam))
+
+int rtl92s_download_fw(struct ieee80211_hw *hw);
+void rtl92s_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
+void rtl92s_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw,
+				      u8 mstatus, u8 ps_qosinfo);
+int rtl92s_set_fw_sitesurvey_cmd(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct cfg80211_scan_request *req);
+void rtl92s_set_fw_disconnect_cmd(struct ieee80211_hw *hw);
+u8 rtl92s_set_fw_setchannel_cmd(struct ieee80211_hw *hw);
+void rtl92s_set_fw_setauth_cmd(struct ieee80211_hw *hw);
+
+u8 rtl92s_fw_iocmd(struct ieee80211_hw *hw, u32 cmd);
+void rtl92s_fw_iocmd_data(struct ieee80211_hw *hw, u32 *val, u8 flag);
+
+u32 rtl92s_fw_iocmd_read(struct ieee80211_hw *hw, u8 ioclass, u16 iovalue, u8 ioindex);
+u8 rtl92s_fw_iocmd_write(struct ieee80211_hw *hw, u8 ioclass, u16 iovalue, u8 ioindex, u32 val);
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/hw.c b/drivers/net/wireless/rtlwifi/rtl8192su/hw.c
new file mode 100644
index 0000000..66e1f5e
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/hw.c
@@ -0,0 +1,2573 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../efuse.h"
+#include "../base.h"
+#include "../regd.h"
+#include "../cam.h"
+#include "../ps.h"
+#include "../usb.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "dm.h"
+#include "fw.h"
+#include "led.h"
+#include "hw.h"
+
+void rtl92su_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+
+	switch (variable) {
+	case HW_VAR_RCR: {
+			*((u32 *)(val)) = mac->rx_conf;
+			break;
+		}
+	case HW_VAR_RF_STATE: {
+			*((enum rf_pwrstate *)(val)) = ppsc->rfpwr_state;
+			break;
+		}
+	case HW_VAR_FW_PSMODE_STATUS: {
+			*((bool *) (val)) = ppsc->fw_current_inpsmode;
+			break;
+		}
+	case HW_VAR_CORRECT_TSF: {
+			u64 tsf;
+			u32 *ptsf_low = (u32 *)&tsf;
+			u32 *ptsf_high = ((u32 *)&tsf) + 1;
+
+			*ptsf_high = rtl_read_dword(rtlpriv, (TSFR + 4));
+			*ptsf_low = rtl_read_dword(rtlpriv, TSFR);
+
+			*((u64 *) (val)) = tsf;
+
+			break;
+		}
+	case HW_VAR_MRC: {
+			*((bool *)(val)) = rtlpriv->dm.current_mrc_switch;
+			break;
+		}
+	default: {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "switch case not processed\n");
+			break;
+		}
+	}
+}
+
+void rtl92su_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+
+	switch (variable) {
+	case HW_VAR_ETHER_ADDR:{
+			rtl_write_dword(rtlpriv, IDR0, ((u32 *)(val))[0]);
+			rtl_write_word(rtlpriv, IDR4, ((u16 *)(val + 4))[0]);
+			break;
+		}
+	case HW_VAR_BASIC_RATE:{
+			u16 rate_cfg = ((u16 *) val)[0];
+			u8 rate_index = 0;
+
+			if (rtlhal->version == VERSION_8192S_ACUT)
+				rate_cfg = rate_cfg & 0x150;
+			else
+				rate_cfg = rate_cfg & 0x15f;
+
+			rate_cfg |= 0x01;
+
+			rtl_write_byte(rtlpriv, RRSR, rate_cfg & 0xff);
+			rtl_write_byte(rtlpriv, RRSR + 1,
+				       (rate_cfg >> 8) & 0xff);
+
+			while (rate_cfg > 0x1) {
+				rate_cfg = (rate_cfg >> 1);
+				rate_index++;
+			}
+			rtl_write_byte(rtlpriv, INIRTSMCS_SEL, rate_index);
+
+			break;
+		}
+	case HW_VAR_BSSID:{
+			rtl_write_dword(rtlpriv, BSSIDR, ((u32 *)(val))[0]);
+			rtl_write_word(rtlpriv, BSSIDR + 4,
+				       ((u16 *)(val + 4))[0]);
+			break;
+		}
+	case HW_VAR_SIFS:{
+			rtl_write_byte(rtlpriv, SIFS_OFDM, val[0]);
+			rtl_write_byte(rtlpriv, SIFS_OFDM + 1, val[1]);
+			break;
+		}
+	case HW_VAR_SLOT_TIME:{
+			u8 e_aci;
+
+			RT_TRACE(rtlpriv, COMP_MLME, DBG_LOUD,
+				 "HW_VAR_SLOT_TIME %x\n", val[0]);
+
+			rtl_write_byte(rtlpriv, SLOT_TIME, val[0]);
+
+			for (e_aci = 0; e_aci < AC_MAX; e_aci++) {
+				rtlpriv->cfg->ops->set_hw_reg(hw,
+						HW_VAR_AC_PARAM,
+						(u8 *)(&e_aci));
+			}
+			break;
+		}
+	case HW_VAR_ACK_PREAMBLE:{
+			u8 reg_tmp;
+			u8 short_preamble = (bool) (*(u8 *) val);
+			reg_tmp = (mac->cur_40_prime_sc) << 5;
+			if (short_preamble)
+				reg_tmp |= 0x80;
+
+			rtl_write_byte(rtlpriv, RRSR + 2, reg_tmp);
+			break;
+		}
+	case HW_VAR_AMPDU_MIN_SPACE:{
+			u8 min_spacing_to_set;
+			u8 sec_min_space;
+
+			min_spacing_to_set = *((u8 *)val);
+			if (min_spacing_to_set <= 7) {
+				if (rtlpriv->sec.pairwise_enc_algorithm ==
+				    NO_ENCRYPTION)
+					sec_min_space = 0;
+				else
+					sec_min_space = 1;
+
+				if (min_spacing_to_set < sec_min_space)
+					min_spacing_to_set = sec_min_space;
+				if (min_spacing_to_set > 5)
+					min_spacing_to_set = 5;
+
+				mac->min_space_cfg =
+						((mac->min_space_cfg & 0xf8) |
+						min_spacing_to_set);
+
+				*val = min_spacing_to_set;
+
+				RT_TRACE(rtlpriv, COMP_MLME, DBG_LOUD,
+					 "Set HW_VAR_AMPDU_MIN_SPACE: %#x\n",
+					 mac->min_space_cfg);
+
+				rtl_write_byte(rtlpriv, AMPDU_MIN_SPACE,
+					       mac->min_space_cfg);
+			}
+			break;
+		}
+	case HW_VAR_SHORTGI_DENSITY:{
+			u8 density_to_set;
+
+			density_to_set = *((u8 *) val);
+			mac->min_space_cfg = rtlpriv->rtlhal.minspace_cfg;
+			mac->min_space_cfg |= (density_to_set << 3);
+
+			RT_TRACE(rtlpriv, COMP_MLME, DBG_LOUD,
+				 "Set HW_VAR_SHORTGI_DENSITY: %#x\n",
+				 mac->min_space_cfg);
+
+			rtl_write_byte(rtlpriv, AMPDU_MIN_SPACE,
+				       mac->min_space_cfg);
+
+			break;
+		}
+	case HW_VAR_AMPDU_FACTOR:{
+			u8 factor_toset;
+			u8 regtoset;
+			u8 factorlevel[18] = {
+				2, 4, 4, 7, 7, 13, 13,
+				13, 2, 7, 7, 13, 13,
+				15, 15, 15, 15, 0};
+			u8 index = 0;
+
+			factor_toset = *((u8 *) val);
+			if (factor_toset <= 3) {
+				factor_toset = (1 << (factor_toset + 2));
+				if (factor_toset > 0xf)
+					factor_toset = 0xf;
+
+				for (index = 0; index < 17; index++) {
+					if (factorlevel[index] > factor_toset)
+						factorlevel[index] =
+								 factor_toset;
+				}
+
+				for (index = 0; index < 8; index++) {
+					regtoset = ((factorlevel[index * 2]) |
+						    (factorlevel[index *
+						    2 + 1] << 4));
+					rtl_write_byte(rtlpriv,
+						       AGGLEN_LMT_L + index,
+						       regtoset);
+				}
+
+				regtoset = ((factorlevel[16]) |
+					    (factorlevel[17] << 4));
+				rtl_write_byte(rtlpriv, AGGLEN_LMT_H, regtoset);
+
+				RT_TRACE(rtlpriv, COMP_MLME, DBG_LOUD,
+					 "Set HW_VAR_AMPDU_FACTOR: %#x\n",
+					 factor_toset);
+			}
+			break;
+		}
+	case HW_VAR_AC_PARAM:{
+			u8 e_aci = *((u8 *) val);
+			rtl92s_dm_init_edca_turbo(hw);
+
+			if (rtlusb->acm_method != eAcmWay2_SW)
+				rtlpriv->cfg->ops->set_hw_reg(hw,
+						 HW_VAR_ACM_CTRL,
+						 (u8 *)(&e_aci));
+			break;
+		}
+	case HW_VAR_ACM_CTRL:{
+			u8 e_aci = *((u8 *) val);
+			union aci_aifsn *p_aci_aifsn = (union aci_aifsn *)(&(
+							mac->ac[0].aifs));
+			u8 acm = p_aci_aifsn->f.acm;
+			u8 acm_ctrl = rtl_read_byte(rtlpriv, AcmHwCtrl);
+
+			acm_ctrl = acm_ctrl | ((rtlusb->acm_method == 2) ?
+				   0x0 : 0x1);
+
+			if (acm) {
+				switch (e_aci) {
+				case AC0_BE:
+					acm_ctrl |= AcmHw_BeqEn;
+					break;
+				case AC2_VI:
+					acm_ctrl |= AcmHw_ViqEn;
+					break;
+				case AC3_VO:
+					acm_ctrl |= AcmHw_VoqEn;
+					break;
+				default:
+					RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+						 "HW_VAR_ACM_CTRL acm set failed: eACI is %d\n",
+						 acm);
+					break;
+				}
+			} else {
+				switch (e_aci) {
+				case AC0_BE:
+					acm_ctrl &= (~AcmHw_BeqEn);
+					break;
+				case AC2_VI:
+					acm_ctrl &= (~AcmHw_ViqEn);
+					break;
+				case AC3_VO:
+					acm_ctrl &= (~AcmHw_BeqEn);
+					break;
+				default:
+					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+						 "switch case not processed\n");
+					break;
+				}
+			}
+
+			RT_TRACE(rtlpriv, COMP_QOS, DBG_TRACE,
+				 "HW_VAR_ACM_CTRL Write 0x%X\n", acm_ctrl);
+			rtl_write_byte(rtlpriv, AcmHwCtrl, acm_ctrl);
+			break;
+		}
+	case HW_VAR_RCR:{
+			rtl_write_dword(rtlpriv, RCR, ((u32 *) (val))[0]);
+			mac->rx_conf = ((u32 *) (val))[0];
+			break;
+		}
+	case HW_VAR_RETRY_LIMIT:{
+			u8 retry_limit = ((u8 *) (val))[0];
+
+			rtl_write_word(rtlpriv, RETRY_LIMIT,
+				       retry_limit << RETRY_LIMIT_SHORT_SHIFT |
+				       retry_limit << RETRY_LIMIT_LONG_SHIFT);
+			break;
+		}
+	case HW_VAR_DUAL_TSF_RST: {
+			break;
+		}
+	case HW_VAR_EFUSE_BYTES: {
+			rtlefuse->efuse_usedbytes = *((u16 *) val);
+			break;
+		}
+	case HW_VAR_EFUSE_USAGE: {
+			rtlefuse->efuse_usedpercentage = *((u8 *) val);
+			break;
+		}
+	case HW_VAR_IO_CMD: {
+			break;
+		}
+	case HW_VAR_WPA_CONFIG: {
+			rtl_write_byte(rtlpriv, REG_SECR, *((u8 *) val));
+			break;
+		}
+	case HW_VAR_SET_RPWM:{
+			break;
+		}
+	case HW_VAR_H2C_FW_PWRMODE:{
+			break;
+		}
+	case HW_VAR_FW_PSMODE_STATUS: {
+			ppsc->fw_current_inpsmode = *((bool *) val);
+			break;
+		}
+	case HW_VAR_H2C_FW_JOINBSSRPT:{
+			break;
+		}
+	case HW_VAR_AID:{
+			break;
+		}
+	case HW_VAR_CORRECT_TSF:{
+			break;
+		}
+	case HW_VAR_MRC: {
+			bool bmrc_toset = *((bool *)val);
+//			u8 u1bdata = 0;
+
+			if (bmrc_toset) {
+/*
+				rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE,
+					      MASKBYTE0, 0x33);
+				u1bdata = (u8)rtl_get_bbreg(hw,
+						ROFDM1_TRXPATHENABLE,
+						MASKBYTE0);
+				rtl_set_bbreg(hw, ROFDM1_TRXPATHENABLE,
+					      MASKBYTE0,
+					      ((u1bdata & 0xf0) | 0x03));
+				u1bdata = (u8)rtl_get_bbreg(hw,
+						ROFDM0_TRXPATHENABLE,
+						MASKBYTE1);
+				rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE,
+					      MASKBYTE1,
+					      (u1bdata | 0x04));
+*/
+
+				/* Update current settings. */
+				rtlpriv->dm.current_mrc_switch = bmrc_toset;
+			} else {
+/*
+				rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE,
+					      MASKBYTE0, 0x13);
+				u1bdata = (u8)rtl_get_bbreg(hw,
+						 ROFDM1_TRXPATHENABLE,
+						 MASKBYTE0);
+				rtl_set_bbreg(hw, ROFDM1_TRXPATHENABLE,
+					      MASKBYTE0,
+					      ((u1bdata & 0xf0) | 0x01));
+				u1bdata = (u8)rtl_get_bbreg(hw,
+						ROFDM0_TRXPATHENABLE,
+						MASKBYTE1);
+				rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE,
+					      MASKBYTE1, (u1bdata & 0xfb));
+*/
+
+				/* Update current settings. */
+				rtlpriv->dm.current_mrc_switch = bmrc_toset;
+			}
+
+			break;
+		}
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "switch case not processed\n");
+		break;
+	}
+
+}
+
+void rtl92su_enable_hw_security_config(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 sec_reg_value = 0x0;
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "PairwiseEncAlgorithm = %d GroupEncAlgorithm = %d\n",
+		 rtlpriv->sec.pairwise_enc_algorithm,
+		 rtlpriv->sec.group_enc_algorithm);
+
+	if (rtlpriv->cfg->mod_params->sw_crypto || rtlpriv->sec.use_sw_sec) {
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			 "not open hw encryption\n");
+		return;
+	}
+
+	sec_reg_value = SCR_TXENCENABLE | SCR_RXENCENABLE;
+
+	if (rtlpriv->sec.use_defaultkey) {
+		sec_reg_value |= SCR_TXUSEDK;
+		sec_reg_value |= SCR_RXUSEDK;
+	}
+
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD, "The SECR-value %x\n",
+		 sec_reg_value);
+
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_WPA_CONFIG, &sec_reg_value);
+
+}
+
+static u8 _rtl92su_halset_sysclk(struct ieee80211_hw *hw, u16 data)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 waitcount = 100;
+	bool bresult = false;
+	u16 tmpvalue;
+
+	rtl_write_word(rtlpriv, SYS_CLKR, data);
+
+	/* Wait the MAC synchronized. */
+	udelay(400);
+
+	/* Check if it is set ready. */
+	tmpvalue = rtl_read_word(rtlpriv, SYS_CLKR);
+	bresult = ((tmpvalue & SYS_FWHW_SEL) == (data & SYS_FWHW_SEL));
+
+	if ((data & (SYS_SWHW_SEL | SYS_FWHW_SEL)) == false) {
+		waitcount = 100;
+		tmpvalue = 0;
+
+		while (1) {
+			waitcount--;
+
+			tmpvalue = rtl_read_word(rtlpriv, SYS_CLKR);
+			if ((tmpvalue & SYS_SWHW_SEL))
+				break;
+
+			pr_err("wait for SYS_SWHW_SEL in %x\n", tmpvalue);
+			if (waitcount == 0)
+				break;
+
+			udelay(10);
+		}
+
+		if (waitcount == 0)
+			bresult = false;
+		else
+			bresult = true;
+	}
+
+	return bresult;
+}
+
+void rtl8192su_gpiobit3_cfg_inputmode(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 u1tmp;
+
+	/* The following config GPIO function */
+	rtl_write_byte(rtlpriv, MAC_PINMUX_CFG, (GPIOMUX_EN | GPIOSEL_GPIO));
+	u1tmp = rtl_read_byte(rtlpriv, GPIO_IO_SEL);
+
+	/* config GPIO3 to input */
+	u1tmp &= HAL_8192S_HW_GPIO_OFF_MASK;
+	rtl_write_byte(rtlpriv, GPIO_IO_SEL, u1tmp);
+
+}
+
+static u8 _rtl92su_rf_onoff_detect(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 u1tmp;
+	u8 retval = ERFON;
+
+	/* The following config GPIO function */
+	rtl_write_byte(rtlpriv, MAC_PINMUX_CFG, (GPIOMUX_EN | GPIOSEL_GPIO));
+	u1tmp = rtl_read_byte(rtlpriv, GPIO_IO_SEL);
+
+	/* config GPIO3 to input */
+	u1tmp &= HAL_8192S_HW_GPIO_OFF_MASK;
+	rtl_write_byte(rtlpriv, GPIO_IO_SEL, u1tmp);
+
+	/* On some of the platform, driver cannot read correct
+	 * value without delay between Write_GPIO_SEL and Read_GPIO_IN */
+	mdelay(10);
+
+	/* check GPIO3 */
+	u1tmp = rtl_read_byte(rtlpriv, GPIO_IN_SE);
+	retval = (u1tmp & HAL_8192S_HW_GPIO_OFF_BIT) ? ERFON : ERFOFF;
+
+	return retval;
+}
+
+static void _rtl92su_macconfig_before_fwdownload(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	u8 i;
+	u8 tmpu1b;
+	u16 tmpu2b;
+	u8 pollingcnt = 20;
+
+	/* Prevent EFUSE leakage */
+	rtl_write_byte(rtlpriv, REG_EFUSE_TEST + 3, 0xb0);
+	msleep(20);
+	rtl_write_byte(rtlpriv, REG_EFUSE_TEST + 3, 0x30);
+
+	/* Switch to SW IO control */
+	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
+	if (tmpu2b & SYS_FWHW_SEL) {
+		tmpu2b &= ~(SYS_SWHW_SEL | SYS_FWHW_SEL);
+
+		/* Set failed, return to prevent hang. */
+		if (!_rtl92su_halset_sysclk(hw, tmpu2b))
+			return;
+	}
+
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL, 0x0);
+	udelay(50);
+	rtl_write_byte(rtlpriv, LDOA15_CTRL, 0x54); // 0x34
+	udelay(50);
+
+	/* Reset MAC-IO and CPU and Core Digital BIT(10)/11/15 */
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
+	tmpu1b &= 0x73;
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, tmpu1b);
+	/* wait for BIT 10/11/15 to pull high automatically!! */
+	mdelay(1);
+
+	rtl_write_byte(rtlpriv, SPS0_CTRL + 1, 0x53);
+	rtl_write_byte(rtlpriv, SPS0_CTRL + 0, 0x57);
+
+	rtl_write_byte(rtlpriv, CMDR, 0);
+	rtl_write_byte(rtlpriv, TCR, 0);
+
+	/* Enable AFE clock source */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_XTAL_CTRL);
+	rtl_write_byte(rtlpriv, AFE_XTAL_CTRL, (tmpu1b | 0x01));
+	/* Delay 1.5ms */
+	mdelay(2);
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_XTAL_CTRL + 1);
+	rtl_write_byte(rtlpriv, AFE_XTAL_CTRL + 1, (tmpu1b & 0xfb));
+
+	/* Enable AFE Macro Block's Bandgap */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_MISC);
+	rtl_write_byte(rtlpriv, AFE_MISC, (tmpu1b | AFE_BGEN));
+	mdelay(1);
+
+	/* Enable AFE Mbias */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_MISC);
+	rtl_write_byte(rtlpriv, AFE_MISC, (tmpu1b | AFE_MBEN |
+		       AFE_MISC_I32_EN));
+	mdelay(1);
+
+	/* Enable LDOA15 block	*/
+	tmpu1b = rtl_read_byte(rtlpriv, LDOA15_CTRL);
+	rtl_write_byte(rtlpriv, LDOA15_CTRL, (tmpu1b | LDA15_EN));
+
+	/* Enable LDOV12D block */
+	tmpu1b = rtl_read_byte(rtlpriv, LDOV12D_CTRL);
+	rtl_write_byte(rtlpriv, LDOV12D_CTRL, (tmpu1b | LDV12_EN));
+
+	/* Set Digital Vdd to Retention isolation Path. */
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_ISO_CTRL);
+	rtl_write_word(rtlpriv, REG_SYS_ISO_CTRL, (tmpu2b | ISO_PWC_DV2RP));
+
+	/* For warm reboot NIC disappear bug. */
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(13)));
+
+	/* Support 64k IMEM */
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_ISO_CTRL + 1);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, (tmpu1b & 0x68));
+
+	/* Enable AFE PLL Macro Block */
+	/* We need to delay 100u before enabling PLL. */
+	udelay(200);
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_PLL_CTRL);
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL, (tmpu1b | BIT(0) | BIT(4)));
+
+	/* for divider reset  */
+	udelay(500);
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL, (tmpu1b | BIT(0) |
+		       BIT(4) | BIT(6)));
+	udelay(500);
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL, (tmpu1b | BIT(0) | BIT(4)));
+	udelay(500);
+
+	/* Enable MAC 80MHZ clock  */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_PLL_CTRL + 1);
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL + 1, (tmpu1b | BIT(0)));
+	mdelay(1);
+
+	/* Release isolation AFE PLL & MD */
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_ISO_CTRL);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL, (tmpu1b & 0xee));
+
+	/* Switch to 40MHz clock */
+	rtl_write_byte(rtlpriv, SYS_CLKR, 0x00);
+	/* Disable CPU clock and 80MHz SSC to fix FW download timing issue */
+	tmpu1b = rtl_read_byte(rtlpriv, SYS_CLKR);
+	rtl_write_byte(rtlpriv, SYS_CLKR, (tmpu1b | 0xa0));
+	/* Enable MAC clock */
+	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
+	rtl_write_word(rtlpriv, SYS_CLKR, (tmpu2b | BIT(12) | BIT(11)));
+
+	rtl_write_byte(rtlpriv, PMC_FSM, 0x02);
+
+	/* Enable Core digital and enable IOREG R/W */
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11)));
+
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, tmpu1b & ~(BIT(7)));
+
+	/* enable REG_EN */
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11) | BIT(15)));
+
+	/* Switch the control path. */
+	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
+	rtl_write_word(rtlpriv, SYS_CLKR, (tmpu2b & ~SYS_CPU_CLKSEL));
+
+	tmpu2b = ((tmpu2b | SYS_FWHW_SEL) & (~SYS_SWHW_SEL));
+	if (!_rtl92su_halset_sysclk(hw, tmpu2b))
+		return; /* Set failed, return to prevent hang. */
+
+	rtl_write_word(rtlpriv, CMDR, 0x07FC);
+
+	/* MH We must enable the section of code to prevent load IMEM fail. */
+	/* Load MAC register from WMAc temporarily We simulate macreg. */
+	/* txt HW will provide MAC txt later  */
+	rtl_write_byte(rtlpriv, 0x6, 0x30);
+
+	rtl_write_byte(rtlpriv, RCR + 1, 0xf0);
+	rtl_write_byte(rtlpriv, RCR + 3, 0x81);
+
+	rtl_write_byte(rtlpriv, PBP, 0x21);
+
+	rtl_write_byte(rtlpriv, TXDESC_MSK, 0xff);
+	rtl_write_byte(rtlpriv, TXDESC_MSK + 1, 0xff);
+	rtl_write_byte(rtlpriv, TXDESC_MSK + 2, 0xff);
+	rtl_write_byte(rtlpriv, TXDESC_MSK + 3, 0xff);
+
+	rtl_write_byte(rtlpriv, RXFILTERMAP_GP2, 0x00);
+	rtl_write_byte(rtlpriv, RXFILTERMAP_GP2 + 1, 0x00);
+
+	for (i = 0; i < 32; i++)
+		rtl_write_byte(rtlpriv, INIMCS_SEL + i, 0x1b);
+
+/*
+	rtl_write_byte(rtlpriv, CFEND_TH, 0xff);
+
+	rtl_write_byte(rtlpriv, DBG_PORT, 0x91);
+*/
+
+	rtl_write_word(rtlpriv, CMDR, 0x37FC);
+
+	/* Fix USB RX FIFO error */
+	rtl_write_byte(rtlpriv, 0xFE5C, rtl_read_byte(rtlpriv, 0xFE5C) |
+			BIT(7));
+
+	/* Fix 8051 ROM incorrect code operation */
+	rtl_write_byte(rtlpriv, 0xFE1C, 0x80);
+
+	/* To make sure that TxDMA can ready to download FW. */
+	/* We should reset TxDMA if IMEM RPT was not ready. */
+	do {
+		tmpu1b = rtl_read_byte(rtlpriv, TCR);
+		if ((tmpu1b & TXDMA_INIT_VALUE) == TXDMA_INIT_VALUE)
+			break;
+
+		udelay(5);
+	} while (pollingcnt--);
+
+	if (pollingcnt <= 0) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Polling TXDMA_INIT_VALUE timeout!! Current TCR(%#x)\n",
+			 tmpu1b);
+		tmpu1b = rtl_read_byte(rtlpriv, CMDR);
+		rtl_write_byte(rtlpriv, CMDR, tmpu1b & (~TXDMA_EN));
+		udelay(2);
+		/* Reset TxDMA */
+		rtl_write_byte(rtlpriv, CMDR, tmpu1b | TXDMA_EN);
+	}
+
+	/* After MACIO reset,we must refresh LED state. */
+	if ((ppsc->rfoff_reason == RF_CHANGE_BY_IPS) ||
+	   (ppsc->rfoff_reason == 0)) {
+		struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
+		struct rtl_led *pLed0 = &(usbpriv->ledctl.sw_led0);
+		enum rf_pwrstate rfpwr_state_toset;
+		rfpwr_state_toset = _rtl92su_rf_onoff_detect(hw);
+
+		if (rfpwr_state_toset == ERFON)
+			rtl92su_sw_led_on(hw, pLed0);
+	}
+}
+
+static void _rtl92su_macconfig_after_fwdownload(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u8 i;
+	u16 tmpu2b;
+
+	/* 1. System Configure Register (Offset: 0x0000 - 0x003F) */
+
+	/* 2. Command Control Register (Offset: 0x0040 - 0x004F) */
+	/* Turn on 0x40 Command register */
+	rtl_write_word(rtlpriv, CMDR, (BBRSTN | BB_GLB_RSTN |
+			SCHEDULE_EN | MACRXEN | MACTXEN | DDMA_EN | FW2HW_EN |
+			RXDMA_EN | TXDMA_EN | HCI_RXDMA_EN | HCI_TXDMA_EN));
+
+	/* Set TCR TX DMA pre 2 FULL enable bit	*/
+/*
+	rtl_write_dword(rtlpriv, TCR, rtl_read_dword(rtlpriv, TCR) |
+			TXDMAPRE2FULL);
+*/
+
+	/* Set RCR	*/
+	rtl_write_dword(rtlpriv, RCR, mac->rx_conf);
+
+	/* 3. MACID Setting Register (Offset: 0x0050 - 0x007F) */
+
+	/* 4. Timing Control Register  (Offset: 0x0080 - 0x009F) */
+	/* Set CCK/OFDM SIFS */
+	/* CCK SIFS shall always be 10us. */
+	rtl_write_word(rtlpriv, SIFS_CCK, 0x0a0a);
+	rtl_write_word(rtlpriv, SIFS_OFDM, 0x1010);
+
+	/* Set AckTimeout */
+	rtl_write_byte(rtlpriv, ACK_TIMEOUT, 0x40);
+
+	/* Beacon related */
+	rtl_write_word(rtlpriv, BCN_INTERVAL, 100);
+	rtl_write_word(rtlpriv, ATIMWND, 2);
+
+	/* 5. FIFO Control Register (Offset: 0x00A0 - 0x015F) */
+	tmpu2b = rtl_read_word(rtlpriv, RXFILTERMAP);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "MgtRxFilter: %04x\n", tmpu2b);
+	tmpu2b &= ~(BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5) |
+		    BIT(10) | BIT(11) | BIT(12) | BIT(13));
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "MgtRxFilter: %04x\n", tmpu2b);
+	rtl_write_word(rtlpriv, RXFILTERMAP, tmpu2b);
+	rtl_write_word(rtlpriv, RXFILTERMAP_GP1, 0x0000);
+	rtl_write_word(rtlpriv, RXFILTERMAP_GP2, 0x0000);
+	/* 5.1 Initialize Number of Reserved Pages in Firmware Queue */
+	/* Firmware allocate now, associate with FW internal setting.!!! */
+
+	/* 5.2 Setting TX/RX page size 0/1/2/3/4=64/128/256/512/1024 */
+	rtl_write_byte(rtlpriv, PBP, rtl_read_byte(rtlpriv, PBP) | BIT(0));
+	/* 5.3 Set driver info, we only accept PHY status now. */
+	/* 5.4 Set RXDMA arbitration to control RXDMA/MAC/FW R/W for RXFIFO  */
+	/* Set USB RX aggregation */
+	rtl_write_byte(rtlpriv, RXDMA, rtl_read_byte(rtlpriv, RXDMA) | RXDMA_AGG_EN);
+	//rtl_write_byte(rtlpriv, RXDMA, rtl_read_byte(rtlpriv, RXDMA) | BIT(6));
+	/* Set TH=1 */
+	rtl_write_byte(rtlpriv, RXDMA_AGG_PG_TH, 1);
+
+	/* 6. Adaptive Control Register  (Offset: 0x0160 - 0x01CF) */
+	/* Set RRSR to all legacy rate and HT rate
+	 * CCK rate is supported by default.
+	 * CCK rate will be filtered out only when associated
+	 * AP does not support it.
+	 * Only enable ACK rate to OFDM 24M
+	 * Disable RRSR for CCK rate in A-Cut	*/
+
+	if (rtlhal->version == VERSION_8192S_ACUT)
+		rtl_write_byte(rtlpriv, RRSR, 0xf0);
+	else if (rtlhal->version == VERSION_8192S_BCUT)
+		rtl_write_byte(rtlpriv, RRSR, 0xff);
+	rtl_write_byte(rtlpriv, RRSR + 1, 0x01);
+	rtl_write_byte(rtlpriv, RRSR + 2, 0x00);
+
+	/* A-Cut IC do not support CCK rate. We forbid ARFR to */
+	/* fallback to CCK rate */
+	for (i = 0; i < 8; i++) {
+		/*Disable RRSR for CCK rate in A-Cut */
+		if (rtlhal->version == VERSION_8192S_ACUT)
+			rtl_write_dword(rtlpriv, ARFR0 + i * 4, 0x1f0ff0f0);
+	}
+
+	/* Different rate use different AMPDU size */
+	/* MCS32/ MCS15_SG use max AMPDU size 15*2=30K */
+	rtl_write_byte(rtlpriv, AGGLEN_LMT_H, 0x0f);
+	/* MCS0/1/2/3 use max AMPDU size 4*2=8K */
+	rtl_write_word(rtlpriv, AGGLEN_LMT_L, 0x7442);
+	/* MCS4/5 use max AMPDU size 8*2=16K 6/7 use 10*2=20K */
+	rtl_write_word(rtlpriv, AGGLEN_LMT_L + 2, 0xddd7);
+	/* MCS8/9 use max AMPDU size 8*2=16K 10/11 use 10*2=20K */
+	rtl_write_word(rtlpriv, AGGLEN_LMT_L + 4, 0xd772);
+	/* MCS12/13/14/15 use max AMPDU size 15*2=30K */
+	rtl_write_word(rtlpriv, AGGLEN_LMT_L + 6, 0xfffd);
+
+	/* Set Data / Response auto rate fallack retry count */
+	rtl_write_dword(rtlpriv, DARFRC, 0x04010000);
+	rtl_write_dword(rtlpriv, DARFRC + 4, 0x09070605);
+	rtl_write_dword(rtlpriv, RARFRC, 0x04010000);
+	rtl_write_dword(rtlpriv, RARFRC + 4, 0x09070605);
+
+	/* 7. EDCA Setting Register (Offset: 0x01D0 - 0x01FF) */
+	/* Set all rate to support SG */
+	rtl_write_word(rtlpriv, SG_RATE, 0xFFFF);
+
+	/* 8. WMAC, BA, and CCX related Register (Offset: 0x0200 - 0x023F) */
+	/* Set NAV protection length */
+	rtl_write_word(rtlpriv, NAV_PROT_LEN, 0x0080);
+	/* CF-END Threshold */
+	rtl_write_byte(rtlpriv, CFEND_TH, 0xFF);
+	/* Set AMPDU minimum space */
+	rtl_write_byte(rtlpriv, AMPDU_MIN_SPACE, 0x07);
+	/* Set TXOP stall control for several queue/HI/BCN/MGT/ */
+	rtl_write_byte(rtlpriv, TXOP_STALL_CTRL, 0x00);
+
+	/* 9. Security Control Register (Offset: 0x0240 - 0x025F) */
+	/* 10. Power Save Control Register (Offset: 0x0260 - 0x02DF) */
+	/* 11. General Purpose Register (Offset: 0x02E0 - 0x02FF) */
+	/* 12. Host Interrupt Status Register (Offset: 0x0300 - 0x030F) */
+	/* 13. Test Mode and Debug Control Register (Offset: 0x0310 - 0x034F) */
+
+	/* 14. Set driver info, we only accept PHY status now. */
+	rtl_write_byte(rtlpriv, RXDRVINFO_SZ, 4);
+
+	/* 15. For EEPROM R/W Workaround */
+	/* 16. For EFUSE to share REG_SYS_FUNC_EN with EEPROM!!! */
+/*
+	tmpu2b = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, tmpu2b | BIT(13));
+	tmpu2b = rtl_read_byte(rtlpriv, REG_SYS_ISO_CTRL);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL, tmpu2b & (~BIT(8)));
+*/
+
+	/* 17. For EFUSE */
+#if 0
+	/* We may R/W EFUSE in EEPROM mode */
+	if (rtlefuse->epromtype == EEPROM_BOOT_EFUSE) {
+		u8	tempval;
+
+		tempval = rtl_read_byte(rtlpriv, REG_SYS_ISO_CTRL + 1);
+		tempval &= 0xFE;
+		rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, tempval);
+
+		/* Change Program timing */
+		rtl_write_byte(rtlpriv, REG_EFUSE_CTRL + 3, 0x72);
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "EFUSE CONFIG OK\n");
+	}
+#endif
+
+	/* Set USB DMA Aggregation Timeout: 1.7/4ms */
+	rtl_write_byte(rtlpriv, REG_USB_DMA_AGG_TO, 0x04);
+	/* Fix USB RX FIFO error */
+	rtl_write_byte(rtlpriv, 0xFE5C, rtl_read_byte(rtlpriv, 0xFE5C) |
+			BIT(7));
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "OK\n");
+
+}
+
+static void _rtl92su_hw_configure(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+
+	u8 reg_bw_opmode = 0;
+	u32 reg_rrsr = 0;
+	u8 regtmp = 0;
+
+	reg_bw_opmode = BW_OPMODE_20MHZ;
+	reg_rrsr = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
+
+	regtmp = rtl_read_byte(rtlpriv, INIRTSMCS_SEL);
+	reg_rrsr = ((reg_rrsr & 0x000fffff) << 8) | regtmp;
+	rtl_write_dword(rtlpriv, INIRTSMCS_SEL, reg_rrsr);
+	rtl_write_byte(rtlpriv, BW_OPMODE, reg_bw_opmode);
+
+	rtl_write_byte(rtlpriv, MLT, 0x8f);
+
+	/* For Min Spacing configuration. */
+	switch (rtlphy->rf_type) {
+	case RF_1T2R:
+	case RF_1T1R:
+		rtlhal->minspace_cfg = (MAX_MSS_DENSITY_1T << 3);
+		break;
+	case RF_2T2R:
+	case RF_2T2R_GREEN:
+		rtlhal->minspace_cfg = (MAX_MSS_DENSITY_2T << 3);
+		break;
+	}
+	rtl_write_byte(rtlpriv, AMPDU_MIN_SPACE, rtlhal->minspace_cfg);
+}
+
+void rtl92su_read_chip_version(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u8 tmp_byte;
+
+	tmp_byte = (rtl_read_dword(rtlpriv, PMC_FSM) >> 15) & 0x1F;
+	if (tmp_byte != 0x3) {
+		tmp_byte = (tmp_byte >> 1) + 1;
+		if (tmp_byte > 0x3)
+			tmp_byte = 0x2; /* default to BCUT */
+	}
+	rtlhal->version = (enum version_8192s)tmp_byte;
+	rtlhal->hw_type = HARDWARE_TYPE_RTL8192SU;
+}
+
+int rtl92su_hw_init(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	//u8 tmp_byte = 0;
+
+	bool rtstatus = true;
+	//u8 tmp_u1b;
+	int err = false;
+	u8 i;
+	int wdcapra_add[] = {
+		EDCAPARA_BE, EDCAPARA_BK,
+		EDCAPARA_VI, EDCAPARA_VO};
+	u8 secr_value = 0x0;
+
+	rtlhal->h2c_txcmd_seq = 0x01;
+
+	rtl_write_byte(rtlpriv, REG_USB_HRPWM, 0x00);
+
+	/* 1. MAC Initialize */
+	/* Before FW download, we have to set some MAC register */
+	_rtl92su_macconfig_before_fwdownload(hw);
+
+	rtl8192su_gpiobit3_cfg_inputmode(hw);
+
+	/* 2. download firmware */
+	rtstatus = rtl92s_download_fw(hw);
+	if (!rtstatus) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+			 "Failed to download FW. Init HW without FW now... "
+			 "Please copy FW into /lib/firmware/rtlwifi\n");
+		return 1;
+	}
+
+	/* After FW download, we have to reset MAC register */
+	_rtl92su_macconfig_after_fwdownload(hw);
+
+	/*Retrieve default FW Cmd IO map. */
+	//rtlhal->fwcmd_iomap =	rtl_read_word(rtlpriv, LBUS_MON_ADDR);
+	//rtlhal->fwcmd_ioparam = rtl_read_dword(rtlpriv, LBUS_ADDR_MASK);
+
+	/* 3. Initialize MAC/PHY Config by MACPHY_reg.txt */
+	if (!rtl92s_phy_mac_config(hw)) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "MAC Config failed\n");
+		return rtstatus;
+	}
+
+	/* Make sure BB/RF write OK. We should prevent enter IPS. radio off. */
+	/* We must set flag avoid BB/RF config period later!! */
+	//rtl_write_dword(rtlpriv, CMDR, 0x37FC);
+
+	/* 4. Initialize BB After MAC Config PHY_reg.txt, AGC_Tab.txt */
+	if (!rtl92s_phy_bb_config(hw)) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "BB Config failed\n");
+		return rtstatus;
+	}
+
+	/* 5. Initiailze RF RAIO_A.txt RF RAIO_B.txt */
+	/* Before initalizing RF. We can not use FW to do RF-R/W. */
+
+	rtlphy->rf_mode = RF_OP_BY_SW_3WIRE;
+
+	/* RF Power Save */
+#if 0
+	/* H/W or S/W RF OFF before sleep. */
+	if (rtlpriv->psc.rfoff_reason > RF_CHANGE_BY_PS) {
+		u32 rfoffreason = rtlpriv->psc.rfoff_reason;
+
+		rtlpriv->psc.rfoff_reason = RF_CHANGE_BY_INIT;
+		rtlpriv->psc.rfpwr_state = ERFON;
+		/* FIXME: check spinlocks if this block is uncommented */
+		rtl_ps_set_rf_state(hw, ERFOFF, rfoffreason);
+	} else {
+		/* gpio radio on/off is out of adapter start */
+		if (rtlpriv->psc.hwradiooff == false) {
+			rtlpriv->psc.rfpwr_state = ERFON;
+			rtlpriv->psc.rfoff_reason = 0;
+		}
+	}
+#endif
+
+	/* Before RF-R/W we must execute the IO from Scott's suggestion. */
+/*
+	rtl_write_byte(rtlpriv, AFE_XTAL_CTRL + 1, 0xDB);
+	if (rtlhal->version == VERSION_8192S_ACUT)
+		rtl_write_byte(rtlpriv, SPS1_CTRL + 3, 0x07);
+	else
+		rtl_write_byte(rtlpriv, RF_CTRL, 0x07);
+*/
+
+	if (!rtl92s_phy_rf_config(hw)) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "RF Config failed\n");
+		return rtstatus;
+	}
+
+	/* After read predefined TXT, we must set BB/MAC/RF
+	 * register as our requirement */
+
+/*
+	rtlphy->rfreg_chnlval[0] = rtl92s_phy_query_rf_reg(hw,
+							   (enum radio_path)0,
+							   RF_CHNLBW,
+							   RFREG_OFFSET_MASK);
+	rtlphy->rfreg_chnlval[1] = rtl92s_phy_query_rf_reg(hw,
+							   (enum radio_path)1,
+							   RF_CHNLBW,
+							   RFREG_OFFSET_MASK);
+*/
+
+	/*---- Set CCK and OFDM Block "ON"----*/
+	//rtl_set_bbreg(hw, RFPGA0_RFMOD, BCCKEN, 0x1);
+	//rtl_set_bbreg(hw, RFPGA0_RFMOD, BOFDMEN, 0x1);
+
+	/*3 Set Hardware(Do nothing now) */
+	_rtl92su_hw_configure(hw);
+
+	/* Read EEPROM TX power index and PHY_REG_PG.txt to capture correct */
+	/* TX power index for different rate set. */
+	/* Get original hw reg values */
+	//rtl92s_phy_get_hw_reg_originalvalue(hw);
+	/* Write correct tx power index */
+	rtl92s_phy_set_txpower(hw, rtlphy->current_channel);
+
+	/* We must set MAC address after firmware download. */
+	for (i = 0; i < 6; i++)
+		rtl_write_byte(rtlpriv, MACIDR0 + i, rtlefuse->dev_addr[i]);
+
+	/* EEPROM R/W workaround */
+/*
+	tmp_u1b = rtl_read_byte(rtlpriv, MAC_PINMUX_CFG);
+	rtl_write_byte(rtlpriv, MAC_PINMUX_CFG, tmp_u1b & (~BIT(3)));
+
+	rtl_write_byte(rtlpriv, 0x4d, 0x0);
+
+	if (hal_get_firmwareversion(rtlpriv) >= 0x49) {
+		tmp_byte = rtl_read_byte(rtlpriv, FW_RSVD_PG_CRTL) & (~BIT(4));
+		tmp_byte = tmp_byte | BIT(5);
+		rtl_write_byte(rtlpriv, FW_RSVD_PG_CRTL, tmp_byte);
+		rtl_write_dword(rtlpriv, TXDESC_MSK, 0xFFFFCFFF);
+	}
+*/
+
+	/* We enable high power and RA related mechanism after NIC
+	 * initialized. */
+	//rtl92s_phy_set_fw_cmd(hw, FW_CMD_RA_INIT);
+
+	/* Add to prevent ASPM bug. */
+	/* Always enable hst and NIC clock request. */
+	//rtl92s_phy_switch_ephy_parameter(hw);
+
+	/* Security related
+	 * 1. Clear all H/W keys.
+	 * 2. Enable H/W encryption/decryption. */
+	rtl_cam_reset_all_entry(hw);
+	secr_value |= SCR_TXENCENABLE;
+	secr_value |= SCR_RXENCENABLE;
+	secr_value |= SCR_NOSKMC;
+	rtl_write_byte(rtlpriv, REG_SECR, secr_value);
+
+	for (i = 0; i < 4; i++)
+		rtl_write_dword(rtlpriv, wdcapra_add[i], 0x5e4322);
+
+	if (rtlphy->rf_type == RF_1T2R) {
+		bool mrc2set = true;
+		/* Turn on B-Path */
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_MRC, (u8 *)&mrc2set);
+	}
+
+	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_ON);
+	rtl92s_dm_init(hw);
+
+	/* give fw time to boot */
+	msleep(500);
+
+	return err;
+}
+
+void rtl92su_set_mac_addr(struct rtl_io *io, const u8 * addr)
+{
+}
+
+void rtl92su_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u32 reg_rcr = mac->rx_conf;
+
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
+
+	if (check_bssid) {
+		reg_rcr |= (RCR_CBSSID);
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+	} else if (!check_bssid) {
+		reg_rcr &= (~RCR_CBSSID);
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+	}
+
+}
+
+static void _rtl92s_cmd_complete(struct urb *urb)
+{
+}
+
+static int _rtl92su_set_media_status(struct ieee80211_hw *hw,
+				     enum nl80211_iftype type)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	//u8 bt_msr = rtl_read_byte(rtlpriv, MSR);
+	//u32 temp;
+	struct sk_buff *skb;
+	struct rtl_tcb_desc *tcb_desc;
+
+	//bt_msr &= ~MSR_LINK_MASK;
+
+	skb = dev_alloc_skb(RTL_TX_HEADER_SIZE + 8 + IEEE80211_MAX_FRAME_LEN);
+	tcb_desc = (struct rtl_tcb_desc *)(skb->cb);
+	tcb_desc->queue_index = RTL_TXQ_MGT;
+	tcb_desc->cmd_or_init = DESC_PACKET_TYPE_NORMAL;
+	tcb_desc->last_inipkt = 1;
+	// _rtl92s_cmd_send_packet
+	{
+		struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+		struct urb *urb;
+		u8 *pdesc, *fwcmd_hdr, *fwcmd;
+		u32 ep_num;
+
+		pdesc = (u8 *)skb_push(skb, RTL_TX_HEADER_SIZE);
+
+		// _rtl92s_fill_h2c_cmd
+		fwcmd_hdr = (u8 *)skb_put(skb, 8);
+		memset(fwcmd_hdr, 0, 8);
+		fwcmd_hdr[0] = 0x08; // size
+		fwcmd_hdr[1] = 0x00; // size
+		fwcmd_hdr[2] = 0x11; // cmd code
+		fwcmd_hdr[3] = rtlhal->h2c_txcmd_seq++; // seq#
+
+		fwcmd = (u8 *)skb_put(skb, 8); // 4 rounded up to 8
+		memset(fwcmd, 0, 8);
+		fwcmd[0] = 0x02; // AutoUnknown
+
+		rtlpriv->cfg->ops->fill_tx_cmddesc(hw, pdesc, 1, 1, skb);
+
+		ep_num = rtlusb->ep_map.ep_mapping[tcb_desc->queue_index];
+
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (!urb) {
+			kfree_skb(skb);
+			return 1;
+		}
+		usb_fill_bulk_urb(urb, rtlusb->udev, usb_sndbulkpipe(rtlusb->udev,
+				  ep_num), skb->data, skb->len, _rtl92s_cmd_complete,
+				  skb);
+		urb->transfer_flags |= URB_ZERO_PACKET;
+
+		usb_anchor_urb(urb, &rtlusb->tx_submitted);
+		if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
+			usb_unanchor_urb(urb);
+			kfree_skb(skb);
+			return 1;
+		}
+		usb_free_urb(urb);
+	}
+
+	switch (type) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+		//bt_msr |= (MSR_LINK_NONE << MSR_LINK_SHIFT);
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Set Network type to NO LINK!\n");
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		//bt_msr |= (MSR_LINK_ADHOC << MSR_LINK_SHIFT);
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Set Network type to Ad Hoc!\n");
+		break;
+	case NL80211_IFTYPE_STATION:
+		//bt_msr |= (MSR_LINK_MANAGED << MSR_LINK_SHIFT);
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Set Network type to STA!\n");
+		break;
+	case NL80211_IFTYPE_AP:
+		//bt_msr |= (MSR_LINK_MASTER << MSR_LINK_SHIFT);
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Set Network type to AP!\n");
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Network type %d not supported!\n", type);
+		return 1;
+		break;
+
+	}
+
+	//rtl_write_byte(rtlpriv, (MSR), bt_msr);
+
+	//temp = rtl_read_dword(rtlpriv, TCR);
+	//rtl_write_dword(rtlpriv, TCR, temp & (~BIT(8)));
+	//rtl_write_dword(rtlpriv, TCR, temp | BIT(8));
+
+	return 0;
+}
+
+/* HW_VAR_MEDIA_STATUS & HW_VAR_CECHK_BSSID */
+int rtl92su_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (_rtl92su_set_media_status(hw, type))
+		return -EOPNOTSUPP;
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		if (type != NL80211_IFTYPE_AP)
+			rtl92su_set_check_bssid(hw, true);
+	} else {
+		rtl92su_set_check_bssid(hw, false);
+	}
+
+	return 0;
+}
+
+/* don't set REG_EDCA_BE_PARAM here because mac80211 will send pkt when scan */
+void rtl92su_set_qos(struct ieee80211_hw *hw, int aci)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	rtl92s_dm_init_edca_turbo(hw);
+
+	switch (aci) {
+	case AC1_BK:
+		rtl_write_dword(rtlpriv, EDCAPARA_BK, 0xa44f);
+		break;
+	case AC0_BE:
+		/* rtl_write_dword(rtlpriv, EDCAPARA_BE, u4b_ac_param); */
+		break;
+	case AC2_VI:
+		rtl_write_dword(rtlpriv, EDCAPARA_VI, 0x5e4322);
+		break;
+	case AC3_VO:
+		rtl_write_dword(rtlpriv, EDCAPARA_VO, 0x2f3222);
+		break;
+	default:
+		RT_ASSERT(false, "invalid aci: %d !\n", aci);
+		break;
+	}
+}
+
+void rtl92su_enable_interrupt(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+
+	rtl_write_dword(rtlpriv, INTA_MASK, rtlusb->irq_mask[0]);
+	/* Support Bit 32-37(Assign as Bit 0-5) interrupt setting now */
+	rtl_write_dword(rtlpriv, INTA_MASK + 4, rtlusb->irq_mask[1] & 0x3F);
+}
+
+void rtl92su_disable_interrupt(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv;
+
+	rtlpriv = rtl_priv(hw);
+	/* if firmware not available, no interrupts */
+	if (!rtlpriv || !rtlpriv->max_fw_size)
+		return;
+	rtl_write_dword(rtlpriv, INTA_MASK, 0);
+	rtl_write_dword(rtlpriv, INTA_MASK + 4, 0);
+}
+
+
+static u8 _rtl92s_set_sysclk(struct ieee80211_hw *hw, u8 data)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 waitcnt = 100;
+	bool result = false;
+	u8 tmp;
+
+	rtl_write_byte(rtlpriv, SYS_CLKR + 1, data);
+
+	/* Wait the MAC synchronized. */
+	udelay(400);
+
+	/* Check if it is set ready. */
+	tmp = rtl_read_byte(rtlpriv, SYS_CLKR + 1);
+	result = ((tmp & BIT(7)) == (data & BIT(7)));
+
+	if ((data & (BIT(6) | BIT(7))) == false) {
+		waitcnt = 100;
+		tmp = 0;
+
+		while (1) {
+			waitcnt--;
+			tmp = rtl_read_byte(rtlpriv, SYS_CLKR + 1);
+
+			if ((tmp & BIT(6)))
+				break;
+
+			pr_err("wait for BIT(6) return value %x\n", tmp);
+
+			if (waitcnt == 0)
+				break;
+			udelay(10);
+		}
+
+		if (waitcnt == 0)
+			result = false;
+		else
+			result = true;
+	}
+
+	return result;
+}
+
+static void _rtl92s_phy_set_rfhalt(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	//struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	u8 u1btmp;
+
+	/* Power save for BB/RF */
+	u1btmp = rtl_read_byte(rtlpriv, LDOV12D_CTRL);
+	u1btmp &= ~LDV12_EN;
+	rtl_write_byte(rtlpriv, LDOV12D_CTRL, u1btmp);
+	rtl_write_byte(rtlpriv, SPS1_CTRL, 0x0);
+	rtl_write_byte(rtlpriv, TXPAUSE, 0xFF);
+	rtl_write_byte(rtlpriv, RF_CTRL, 0x00);
+/*
+	rtl_write_word(rtlpriv, CMDR, 0x57FC);
+	udelay(100);
+	rtl_write_word(rtlpriv, CMDR, 0x77FC);
+	udelay(10);
+	rtl_write_word(rtlpriv, CMDR, 0x37FC);
+	udelay(10);
+	rtl_write_word(rtlpriv, CMDR, 0x77FC);
+	udelay(10);
+	rtl_write_word(rtlpriv, CMDR, 0x57FC);
+	rtl_write_word(rtlpriv, CMDR, 0x0000);
+
+	if (rtlhal->driver_going2unload) {
+		u1btmp = rtl_read_byte(rtlpriv, (REG_SYS_FUNC_EN + 1));
+		u1btmp &= ~(BIT(0));
+		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, u1btmp);
+	}
+*/
+
+	u1btmp = rtl_read_byte(rtlpriv, (SYS_CLKR + 1));
+
+	/* Add description. After switch control path. register
+	 * after page1 will be invisible. We can not do any IO
+	 * for register>0x40. After resume&MACIO reset, we need
+	 * to remember previous reg content. */
+	if (u1btmp & BIT(7)) {
+		u1btmp &= ~(BIT(6) | BIT(7));
+		if (!_rtl92s_set_sysclk(hw, u1btmp)) {
+			pr_err("Switch ctrl path fail\n");
+			return;
+		}
+	}
+
+#if 0
+	/* Power save for MAC */
+	if (ppsc->rfoff_reason == RF_CHANGE_BY_IPS  &&
+		!rtlhal->driver_going2unload) {
+		/* enable LED function */
+		rtl_write_byte(rtlpriv, 0x03, 0xF9);
+	/* SW/HW radio off or halt adapter!! For example S3/S4 */
+	} else {
+		/* LED function disable. Power range is about 8mA now. */
+		/* if write 0xF1 disconnet_pci power
+		 *	 ifconfig wlan0 down power are both high 35:70 */
+		/* if write oxF9 disconnet_pci power
+		 * ifconfig wlan0 down power are both low  12:45*/
+		rtl_write_byte(rtlpriv, 0x03, 0xF9);
+	}
+#endif
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, 0x70);
+	rtl_write_byte(rtlpriv, PMC_FSM, 0x06);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL, 0xf9);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, 0xe8);
+
+	//rtl_write_byte(rtlpriv, SYS_CLKR + 1, 0x70);
+	//rtl_write_byte(rtlpriv, AFE_PLL_CTRL + 1, 0x68);
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL, 0x00);
+	rtl_write_byte(rtlpriv, LDOA15_CTRL, 0x54); // 0x34
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, 0x50);
+	//rtl_write_byte(rtlpriv, AFE_XTAL_CTRL, 0x0E);
+	rtl_write_byte(rtlpriv, AFE_MISC, 0x30);
+	rtl_write_byte(rtlpriv, SPS0_CTRL, 0x56);
+	rtl_write_byte(rtlpriv, SPS0_CTRL + 1, 0x43);
+	RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
+
+}
+
+static void _rtl92su_gen_refreshledstate(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
+	struct rtl_led *pLed0 = &(usbpriv->ledctl.sw_led0);
+		return;
+
+	if (rtlpriv->psc.rfoff_reason == RF_CHANGE_BY_IPS)
+		rtl92su_sw_led_on(hw, pLed0);
+	else
+		rtl92su_sw_led_off(hw, pLed0);
+}
+
+static void _rtl92su_power_domain_init(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u16 tmpu2b;
+	u8 tmpu1b;
+
+	rtlpriv->psc.pwrdomain_protect = true;
+
+	tmpu1b = rtl_read_byte(rtlpriv, (SYS_CLKR + 1));
+	if (tmpu1b & BIT(7)) {
+		tmpu1b &= ~(BIT(6) | BIT(7));
+		if (!_rtl92s_set_sysclk(hw, tmpu1b)) {
+			rtlpriv->psc.pwrdomain_protect = false;
+			return;
+		}
+	}
+
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL, 0x0);
+	rtl_write_byte(rtlpriv, LDOA15_CTRL, 0x34);
+
+	/* Reset MAC-IO and CPU and Core Digital BIT10/11/15 */
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
+
+	/* If IPS we need to turn LED on. So we not
+	 * not disable BIT 3/7 of reg3. */
+	if (rtlpriv->psc.rfoff_reason & (RF_CHANGE_BY_IPS | RF_CHANGE_BY_HW))
+		tmpu1b &= 0xFB;
+	else
+		tmpu1b &= 0x73;
+
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, tmpu1b);
+	/* wait for BIT 10/11/15 to pull high automatically!! */
+	mdelay(1);
+
+	rtl_write_byte(rtlpriv, SPS0_CTRL + 1, 0x53);
+	rtl_write_byte(rtlpriv, SPS0_CTRL + 0, 0x57);
+
+	rtl_write_byte(rtlpriv, CMDR, 0);
+	rtl_write_byte(rtlpriv, TCR, 0);
+
+	/* Enable AFE clock source */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_XTAL_CTRL);
+	rtl_write_byte(rtlpriv, AFE_XTAL_CTRL, (tmpu1b | 0x01));
+	/* Delay 1.5ms */
+	mdelay(2);
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_XTAL_CTRL + 1);
+	rtl_write_byte(rtlpriv, AFE_XTAL_CTRL + 1, (tmpu1b & 0xfb));
+
+	/* Enable AFE Macro Block's Bandgap */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_MISC);
+	rtl_write_byte(rtlpriv, AFE_MISC, (tmpu1b | AFE_BGEN));
+	mdelay(1);
+
+	/* Enable AFE Mbias */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_MISC);
+	rtl_write_byte(rtlpriv, AFE_MISC, (tmpu1b | AFE_MBEN |
+		       AFE_MISC_I32_EN));
+	mdelay(1);
+
+	/* Enable LDOA15 block */
+	tmpu1b = rtl_read_byte(rtlpriv, LDOA15_CTRL);
+	rtl_write_byte(rtlpriv, LDOA15_CTRL, (tmpu1b | LDA15_EN));
+
+	/* Enable LDOV12D block */
+	tmpu1b = rtl_read_byte(rtlpriv, LDOV12D_CTRL);
+	rtl_write_byte(rtlpriv, LDOV12D_CTRL, (tmpu1b | LDV12_EN));
+
+	/* Set Digital Vdd to Retention isolation Path. */
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_ISO_CTRL);
+	rtl_write_word(rtlpriv, REG_SYS_ISO_CTRL, (tmpu2b | ISO_PWC_DV2RP));
+
+	/* For warm reboot NIC disappera bug. */
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(13)));
+
+	/* Support 64k IMEM */
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_ISO_CTRL + 1);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, (tmpu1b & 0x68));
+
+	/* Enable AFE PLL Macro Block */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_PLL_CTRL);
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL, (tmpu1b | BIT(0) | BIT(4)));
+	/* Enable MAC 80MHZ clock */
+	tmpu1b = rtl_read_byte(rtlpriv, AFE_PLL_CTRL + 1);
+	rtl_write_byte(rtlpriv, AFE_PLL_CTRL + 1, (tmpu1b | BIT(0)));
+	mdelay(1);
+
+	/* Release isolation AFE PLL & MD */
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL, 0xA6);
+
+	/* Enable MAC clock */
+	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
+	rtl_write_word(rtlpriv, SYS_CLKR, (tmpu2b | BIT(12) | BIT(11)));
+
+	/* Enable Core digital and enable IOREG R/W */
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11)));
+	/* enable REG_EN */
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11) | BIT(15)));
+
+	/* Switch the control path. */
+	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
+	rtl_write_word(rtlpriv, SYS_CLKR, (tmpu2b & (~BIT(2))));
+
+	tmpu1b = rtl_read_byte(rtlpriv, (SYS_CLKR + 1));
+	tmpu1b = ((tmpu1b | BIT(7)) & (~BIT(6)));
+	if (!_rtl92s_set_sysclk(hw, tmpu1b)) {
+		rtlpriv->psc.pwrdomain_protect = false;
+		return;
+	}
+
+	rtl_write_word(rtlpriv, CMDR, 0x37FC);
+
+	/* After MACIO reset,we must refresh LED state. */
+	_rtl92su_gen_refreshledstate(hw);
+
+	rtlpriv->psc.pwrdomain_protect = false;
+}
+
+void rtl92su_card_disable(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	enum nl80211_iftype opmode;
+	u8 wait = 30;
+
+	/* we should chnge GPIO to input mode
+	 * this will drop away current about 25mA*/
+	rtl8192su_gpiobit3_cfg_inputmode(hw);
+
+	/* this is very important for ips power save */
+	while (wait-- >= 10 && rtlpriv->psc.pwrdomain_protect) {
+		if (rtlpriv->psc.pwrdomain_protect)
+			mdelay(20);
+		else
+			break;
+	}
+
+	/* notify mac80211 to stop any work related to scanning */
+	//ieee80211_scan_completed(hw, true);
+
+	mac->link_state = MAC80211_NOLINK;
+	opmode = NL80211_IFTYPE_UNSPECIFIED;
+	_rtl92su_set_media_status(hw, opmode);
+
+	_rtl92s_phy_set_rfhalt(hw);
+	udelay(100);
+}
+
+void rtl92su_interrupt_recognized(struct ieee80211_hw *hw, u32 *p_inta,
+			     u32 *p_intb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+
+	*p_inta = rtl_read_dword(rtlpriv, ISR) & rtlusb->irq_mask[0];
+	rtl_write_dword(rtlpriv, ISR, *p_inta);
+
+	*p_intb = rtl_read_dword(rtlpriv, ISR + 4) & rtlusb->irq_mask[1];
+	rtl_write_dword(rtlpriv, ISR + 4, *p_intb);
+}
+
+void rtl92su_set_beacon_related_registers(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u16 bcntime_cfg = 0;
+	u16 bcn_cw = 6, bcn_ifs = 0xf;
+	u16 atim_window = 2;
+
+	/* ATIM Window (in unit of TU). */
+	rtl_write_word(rtlpriv, ATIMWND, atim_window);
+
+	/* Beacon interval (in unit of TU). */
+	rtl_write_word(rtlpriv, BCN_INTERVAL, mac->beacon_interval);
+
+	/* DrvErlyInt (in unit of TU). (Time to send
+	 * interrupt to notify driver to change
+	 * beacon content) */
+	rtl_write_word(rtlpriv, BCN_DRV_EARLY_INT, 10 << 4);
+
+	/* BcnDMATIM(in unit of us). Indicates the
+	 * time before TBTT to perform beacon queue DMA  */
+	rtl_write_word(rtlpriv, BCN_DMATIME, 256);
+
+	/* Force beacon frame transmission even
+	 * after receiving beacon frame from
+	 * other ad hoc STA */
+	rtl_write_byte(rtlpriv, BCN_ERR_THRESH, 100);
+
+	/* Beacon Time Configuration */
+	if (mac->opmode == NL80211_IFTYPE_ADHOC)
+		bcntime_cfg |= (bcn_cw << BCN_TCFG_CW_SHIFT);
+
+	/* TODO: bcn_ifs may required to be changed on ASIC */
+	bcntime_cfg |= bcn_ifs << BCN_TCFG_IFS;
+
+	/*for beacon changed */
+	rtl92s_phy_set_beacon_hwreg(hw, mac->beacon_interval);
+}
+
+void rtl92su_set_beacon_interval(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u16 bcn_interval = mac->beacon_interval;
+
+	/* Beacon interval (in unit of TU). */
+	rtl_write_word(rtlpriv, BCN_INTERVAL, bcn_interval);
+	/* 2008.10.24 added by tynli for beacon changed. */
+	rtl92s_phy_set_beacon_hwreg(hw, bcn_interval);
+}
+
+void rtl92su_update_interrupt_mask(struct ieee80211_hw *hw,
+		u32 add_msr, u32 rm_msr)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+
+	RT_TRACE(rtlpriv, COMP_INTR, DBG_LOUD, "add_msr:%x, rm_msr:%x\n",
+		 add_msr, rm_msr);
+
+	if (add_msr)
+		rtlusb->irq_mask[0] |= add_msr;
+
+	if (rm_msr)
+		rtlusb->irq_mask[0] &= (~rm_msr);
+
+	rtl92su_disable_interrupt(hw);
+	rtl92su_enable_interrupt(hw);
+}
+
+static void _rtl8192se_get_IC_Inferiority(struct ieee80211_hw *hw)
+{
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u8 efuse_id;
+
+	rtlhal->ic_class = IC_INFERIORITY_A;
+
+	/* Only retrieving while using EFUSE. */
+	if ((rtlefuse->epromtype == EEPROM_BOOT_EFUSE) &&
+		!rtlefuse->autoload_failflag) {
+		efuse_id = efuse_read_1byte(hw, EFUSE_IC_ID_OFFSET);
+
+		if (efuse_id == 0xfe)
+			rtlhal->ic_class = IC_INFERIORITY_B;
+	}
+}
+
+static void _rtl92su_read_adapter_info(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u16 i, usvalue;
+	u16	eeprom_id;
+	u8 tempval;
+	u8 hwinfo[HWSET_MAX_SIZE_92S];
+	u8 rf_path, index;
+
+	if (rtlefuse->epromtype == EEPROM_93C46) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "RTL819X Not boot from eeprom, check it !!\n");
+	} else if (rtlefuse->epromtype == EEPROM_BOOT_EFUSE) {
+		rtl_efuse_shadow_map_update(hw);
+
+		memcpy((void *)hwinfo, (void *)
+			&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+			HWSET_MAX_SIZE_92S);
+	}
+
+	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "MAP",
+		      hwinfo, HWSET_MAX_SIZE_92S);
+
+	eeprom_id = *((u16 *)&hwinfo[0]);
+	if (eeprom_id != RTL8190_EEPROM_ID) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+			 "EEPROM ID(%#x) is invalid!!\n", eeprom_id);
+		rtlefuse->autoload_failflag = true;
+	} else {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
+		rtlefuse->autoload_failflag = false;
+	}
+
+	if (rtlefuse->autoload_failflag)
+		return;
+
+	_rtl8192se_get_IC_Inferiority(hw);
+
+	/* Read IC Version && Channel Plan */
+	/* VID, DID	 SE	0xA-D */
+	rtlefuse->eeprom_vid = *(u16 *)&hwinfo[EEPROM_VID];
+	rtlefuse->eeprom_did = *(u16 *)&hwinfo[EEPROM_DID];
+//	rtlefuse->eeprom_svid = *(u16 *)&hwinfo[EEPROM_SVID];
+//	rtlefuse->eeprom_smid = *(u16 *)&hwinfo[EEPROM_SMID];
+	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROMId = 0x%4x\n", eeprom_id);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROM VID = 0x%4x\n", rtlefuse->eeprom_vid);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "EEPROM DID = 0x%4x\n", rtlefuse->eeprom_did);
+//	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+//		 "EEPROM SVID = 0x%4x\n", rtlefuse->eeprom_svid);
+//	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+//		 "EEPROM SMID = 0x%4x\n", rtlefuse->eeprom_smid);
+
+	for (i = 0; i < 6; i += 2) {
+		usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR + i];
+		*((u16 *) (&rtlefuse->dev_addr[i])) = usvalue;
+	}
+
+	for (i = 0; i < 6; i++)
+		rtl_write_byte(rtlpriv, MACIDR0 + i, rtlefuse->dev_addr[i]);
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "%pM\n", rtlefuse->dev_addr);
+
+	/* Get Tx Power Level by Channel */
+	/* Read Tx power of Channel 1 ~ 14 from EEPROM. */
+	/* 92S suupport RF A & B */
+	for (rf_path = 0; rf_path < 2; rf_path++) {
+		for (i = 0; i < 3; i++) {
+			/* Read CCK RF A & B Tx power  */
+			rtlefuse->eeprom_chnlarea_txpwr_cck[rf_path][i] =
+			hwinfo[EEPROM_TXPOWERBASE + rf_path * 3 + i];
+
+			/* Read OFDM RF A & B Tx power for 1T */
+			rtlefuse->eeprom_chnlarea_txpwr_ht40_1s[rf_path][i] =
+			hwinfo[EEPROM_TXPOWERBASE + 6 + rf_path * 3 + i];
+
+			/* Read OFDM RF A & B Tx power for 2T */
+			rtlefuse->eeprom_chnlarea_txpwr_ht40_2sdiif[rf_path][i]
+				 = hwinfo[EEPROM_TXPOWERBASE + 12 +
+				   rf_path * 3 + i];
+		}
+	}
+
+	for (rf_path = 0; rf_path < 2; rf_path++)
+		for (i = 0; i < 3; i++)
+			RTPRINT(rtlpriv, FINIT, INIT_EEPROM,
+				"RF(%d) EEPROM CCK Area(%d) = 0x%x\n",
+				rf_path, i,
+				rtlefuse->eeprom_chnlarea_txpwr_cck
+				[rf_path][i]);
+	for (rf_path = 0; rf_path < 2; rf_path++)
+		for (i = 0; i < 3; i++)
+			RTPRINT(rtlpriv, FINIT, INIT_EEPROM,
+				"RF(%d) EEPROM HT40 1S Area(%d) = 0x%x\n",
+				rf_path, i,
+				rtlefuse->eeprom_chnlarea_txpwr_ht40_1s
+				[rf_path][i]);
+	for (rf_path = 0; rf_path < 2; rf_path++)
+		for (i = 0; i < 3; i++)
+			RTPRINT(rtlpriv, FINIT, INIT_EEPROM,
+				"RF(%d) EEPROM HT40 2S Diff Area(%d) = 0x%x\n",
+				rf_path, i,
+				rtlefuse->eeprom_chnlarea_txpwr_ht40_2sdiif
+				[rf_path][i]);
+
+	for (rf_path = 0; rf_path < 2; rf_path++) {
+
+		/* Assign dedicated channel tx power */
+		for (i = 0; i < 14; i++)	{
+			/* channel 1~3 use the same Tx Power Level. */
+			if (i < 3)
+				index = 0;
+			/* Channel 4-8 */
+			else if (i < 8)
+				index = 1;
+			/* Channel 9-14 */
+			else
+				index = 2;
+
+			/* Record A & B CCK /OFDM - 1T/2T Channel area
+			 * tx power */
+			rtlefuse->txpwrlevel_cck[rf_path][i]  =
+				rtlefuse->eeprom_chnlarea_txpwr_cck
+							[rf_path][index];
+			rtlefuse->txpwrlevel_ht40_1s[rf_path][i]  =
+				rtlefuse->eeprom_chnlarea_txpwr_ht40_1s
+							[rf_path][index];
+			rtlefuse->txpwrlevel_ht40_2s[rf_path][i]  =
+				rtlefuse->eeprom_chnlarea_txpwr_ht40_2sdiif
+							[rf_path][index];
+		}
+
+		for (i = 0; i < 14; i++) {
+			RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+				"RF(%d)-Ch(%d) [CCK / HT40_1S / HT40_2S] = [0x%x / 0x%x / 0x%x]\n",
+				rf_path, i,
+				rtlefuse->txpwrlevel_cck[rf_path][i],
+				rtlefuse->txpwrlevel_ht40_1s[rf_path][i],
+				rtlefuse->txpwrlevel_ht40_2s[rf_path][i]);
+		}
+	}
+
+	for (rf_path = 0; rf_path < 2; rf_path++) {
+		for (i = 0; i < 3; i++) {
+			/* Read Power diff limit. */
+			rtlefuse->eeprom_pwrgroup[rf_path][i] =
+				hwinfo[EEPROM_TXPWRGROUP + rf_path * 3 + i];
+		}
+	}
+
+	for (rf_path = 0; rf_path < 2; rf_path++) {
+		/* Fill Pwr group */
+		for (i = 0; i < 14; i++) {
+			/* Chanel 1-3 */
+			if (i < 3)
+				index = 0;
+			/* Channel 4-8 */
+			else if (i < 8)
+				index = 1;
+			/* Channel 9-13 */
+			else
+				index = 2;
+
+			rtlefuse->pwrgroup_ht20[rf_path][i] =
+				(rtlefuse->eeprom_pwrgroup[rf_path][index] &
+				0xf);
+			rtlefuse->pwrgroup_ht40[rf_path][i] =
+				((rtlefuse->eeprom_pwrgroup[rf_path][index] &
+				0xf0) >> 4);
+
+			RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+				"RF-%d pwrgroup_ht20[%d] = 0x%x\n",
+				rf_path, i,
+				rtlefuse->pwrgroup_ht20[rf_path][i]);
+			RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+				"RF-%d pwrgroup_ht40[%d] = 0x%x\n",
+				rf_path, i,
+				rtlefuse->pwrgroup_ht40[rf_path][i]);
+			}
+	}
+
+	for (i = 0; i < 14; i++) {
+		/* Read tx power difference between HT OFDM 20/40 MHZ */
+		/* channel 1-3 */
+		if (i < 3)
+			index = 0;
+		/* Channel 4-8 */
+		else if (i < 8)
+			index = 1;
+		/* Channel 9-14 */
+		else
+			index = 2;
+
+		tempval = (*(u8 *)&hwinfo[EEPROM_TX_PWR_HT20_DIFF +
+			   index]) & 0xff;
+		rtlefuse->txpwr_ht20diff[RF90_PATH_A][i] = (tempval & 0xF);
+		rtlefuse->txpwr_ht20diff[RF90_PATH_B][i] =
+						 ((tempval >> 4) & 0xF);
+
+		/* Read OFDM<->HT tx power diff */
+		/* Channel 1-3 */
+		if (i < 3)
+			index = 0;
+		/* Channel 4-8 */
+		else if (i < 8)
+			index = 0x11;
+		/* Channel 9-14 */
+		else
+			index = 1;
+
+		tempval = (*(u8 *)&hwinfo[EEPROM_TX_PWR_OFDM_DIFF + index])
+				  & 0xff;
+		rtlefuse->txpwr_legacyhtdiff[RF90_PATH_A][i] =
+				 (tempval & 0xF);
+		rtlefuse->txpwr_legacyhtdiff[RF90_PATH_B][i] =
+				 ((tempval >> 4) & 0xF);
+
+//		tempval = (*(u8 *)&hwinfo[TX_PWR_SAFETY_CHK]);
+//		rtlefuse->txpwr_safetyflag = (tempval & 0x01);
+	}
+
+	rtlefuse->eeprom_regulatory = 0;
+	if (rtlefuse->eeprom_version >= 2) {
+		/* BIT(0)~2 */
+		if (rtlefuse->eeprom_version >= 4)
+			rtlefuse->eeprom_regulatory =
+				 (hwinfo[EEPROM_REGULATORY] & 0x7);
+		else /* BIT(0) */
+			rtlefuse->eeprom_regulatory =
+				 (hwinfo[EEPROM_REGULATORY] & 0x1);
+	}
+	RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+		"eeprom_regulatory = 0x%x\n", rtlefuse->eeprom_regulatory);
+
+	for (i = 0; i < 14; i++)
+		RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+			"RF-A Ht20 to HT40 Diff[%d] = 0x%x\n",
+			i, rtlefuse->txpwr_ht20diff[RF90_PATH_A][i]);
+	for (i = 0; i < 14; i++)
+		RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+			"RF-A Legacy to Ht40 Diff[%d] = 0x%x\n",
+			i, rtlefuse->txpwr_legacyhtdiff[RF90_PATH_A][i]);
+	for (i = 0; i < 14; i++)
+		RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+			"RF-B Ht20 to HT40 Diff[%d] = 0x%x\n",
+			i, rtlefuse->txpwr_ht20diff[RF90_PATH_B][i]);
+	for (i = 0; i < 14; i++)
+		RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+			"RF-B Legacy to HT40 Diff[%d] = 0x%x\n",
+			i, rtlefuse->txpwr_legacyhtdiff[RF90_PATH_B][i]);
+
+//	RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+//		"TxPwrSafetyFlag = %d\n", rtlefuse->txpwr_safetyflag);
+
+	/* Read RF-indication and Tx Power gain
+	 * index diff of legacy to HT OFDM rate. */
+	tempval = (*(u8 *)&hwinfo[EEPROM_RFIND_POWERDIFF]) & 0xff;
+	rtlefuse->eeprom_txpowerdiff = tempval;
+	rtlefuse->legacy_httxpowerdiff =
+		rtlefuse->txpwr_legacyhtdiff[RF90_PATH_A][0];
+
+	RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+		"TxPowerDiff = %#x\n", rtlefuse->eeprom_txpowerdiff);
+
+	/* Get TSSI value for each path. */
+	usvalue = *(u16 *)&hwinfo[EEPROM_TSSI_A];
+	rtlefuse->eeprom_tssi[RF90_PATH_A] = (u8)((usvalue & 0xff00) >> 8);
+	usvalue = *(u8 *)&hwinfo[EEPROM_TSSI_B];
+	rtlefuse->eeprom_tssi[RF90_PATH_B] = (u8)(usvalue & 0xff);
+
+	RTPRINT(rtlpriv, FINIT, INIT_TxPower, "TSSI_A = 0x%x, TSSI_B = 0x%x\n",
+		rtlefuse->eeprom_tssi[RF90_PATH_A],
+		rtlefuse->eeprom_tssi[RF90_PATH_B]);
+
+	/* Read antenna tx power offset of B/C/D to A  from EEPROM */
+	/* and read ThermalMeter from EEPROM */
+	tempval = *(u8 *)&hwinfo[EEPROM_THERMALMETER];
+	rtlefuse->eeprom_thermalmeter = tempval;
+	RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+		"thermalmeter = 0x%x\n", rtlefuse->eeprom_thermalmeter);
+
+	/* ThermalMeter, BIT(0)~3 for RFIC1, BIT(4)~7 for RFIC2 */
+	rtlefuse->thermalmeter[0] = (rtlefuse->eeprom_thermalmeter & 0x1f);
+	rtlefuse->tssi_13dbm = rtlefuse->eeprom_thermalmeter * 100;
+
+	/* Read CrystalCap from EEPROM */
+	tempval = (*(u8 *)&hwinfo[EEPROM_CRYSTALCAP]) >> 4;
+	rtlefuse->eeprom_crystalcap = tempval;
+	/* CrystalCap, BIT(12)~15 */
+	rtlefuse->crystalcap = rtlefuse->eeprom_crystalcap;
+
+	/* Read IC Version && Channel Plan */
+	/* Version ID, Channel plan */
+	rtlefuse->eeprom_channelplan = *(u8 *)&hwinfo[EEPROM_CHANNELPLAN];
+	rtlefuse->txpwr_fromeprom = true;
+	RTPRINT(rtlpriv, FINIT, INIT_TxPower,
+		"EEPROM ChannelPlan = 0x%4x\n", rtlefuse->eeprom_channelplan);
+
+	/* Read Customer ID or Board Type!!! */
+	//tempval = *(u8 *)&hwinfo[EEPROM_BOARDTYPE];
+	/* Change RF type definition */
+/*
+	if (tempval == 0)
+		rtlphy->rf_type = RF_2T2R;
+	else if (tempval == 1)
+		rtlphy->rf_type = RF_1T2R;
+	else if (tempval == 2)
+		rtlphy->rf_type = RF_1T2R;
+	else if (tempval == 3)
+		rtlphy->rf_type = RF_1T1R;
+*/
+	// XXX
+	rtlphy->rf_type = RF_1T2R;
+
+	/* 1T2R but 1SS (1x1 receive combining) */
+	rtlefuse->b1x1_recvcombine = false;
+	if (rtlphy->rf_type == RF_1T2R) {
+		tempval = rtl_read_byte(rtlpriv, 0x07);
+		if (!(tempval & BIT(0))) {
+			rtlefuse->b1x1_recvcombine = true;
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				 "RF_TYPE=1T2R but only 1SS\n");
+		}
+	}
+	rtlefuse->b1ss_support = rtlefuse->b1x1_recvcombine;
+	rtlefuse->eeprom_oemid = *(u8 *)&hwinfo[EEPROM_CUSTOMID];
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "EEPROM Customer ID: 0x%2x",
+		 rtlefuse->eeprom_oemid);
+
+	/* set channel paln to world wide 13 */
+	rtlefuse->channel_plan = COUNTRY_CODE_WORLD_WIDE_13;
+}
+
+void rtl92su_read_eeprom_info(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u8 tmp_u1b = 0;
+
+	tmp_u1b = rtl_read_byte(rtlpriv, EPROM_CMD);
+
+	if (tmp_u1b & BIT(4)) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "Boot from EEPROM\n");
+		rtlefuse->epromtype = EEPROM_93C46;
+	} else {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "Boot from EFUSE\n");
+		rtlefuse->epromtype = EEPROM_BOOT_EFUSE;
+	}
+
+	if (tmp_u1b & BIT(5)) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
+		rtlefuse->autoload_failflag = false;
+		_rtl92su_read_adapter_info(hw);
+	} else {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		rtlefuse->autoload_failflag = true;
+	}
+}
+
+static void rtl92su_update_hal_rate_table(struct ieee80211_hw *hw,
+					  struct ieee80211_sta *sta)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u32 ratr_value;
+	u8 ratr_index = 0;
+	u8 nmode = mac->ht_enable;
+	u8 mimo_ps = IEEE80211_SMPS_OFF;
+	u16 shortgi_rate = 0;
+	u32 tmp_ratr_value = 0;
+	u8 curtxbw_40mhz = mac->bw_40;
+	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+				1 : 0;
+	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+				1 : 0;
+	enum wireless_mode wirelessmode = mac->mode;
+
+	if (rtlhal->current_bandtype == BAND_ON_5G)
+		ratr_value = sta->supp_rates[1] << 4;
+	else
+		ratr_value = sta->supp_rates[0];
+	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
+			sta->ht_cap.mcs.rx_mask[0] << 12);
+	switch (wirelessmode) {
+	case WIRELESS_MODE_B:
+		ratr_value &= 0x0000000D;
+		break;
+	case WIRELESS_MODE_G:
+		ratr_value &= 0x00000FF5;
+		break;
+	case WIRELESS_MODE_N_24G:
+	case WIRELESS_MODE_N_5G:
+		nmode = 1;
+		if (mimo_ps == IEEE80211_SMPS_STATIC) {
+			ratr_value &= 0x0007F005;
+		} else {
+			u32 ratr_mask;
+
+			if (get_rf_type(rtlphy) == RF_1T2R ||
+			    get_rf_type(rtlphy) == RF_1T1R) {
+				if (curtxbw_40mhz)
+					ratr_mask = 0x000ff015;
+				else
+					ratr_mask = 0x000ff005;
+			} else {
+				if (curtxbw_40mhz)
+					ratr_mask = 0x0f0ff015;
+				else
+					ratr_mask = 0x0f0ff005;
+			}
+
+			ratr_value &= ratr_mask;
+		}
+		break;
+	default:
+		if (rtlphy->rf_type == RF_1T2R)
+			ratr_value &= 0x000ff0ff;
+		else
+			ratr_value &= 0x0f0ff0ff;
+
+		break;
+	}
+
+	if (rtlpriv->rtlhal.version >= VERSION_8192S_BCUT)
+		ratr_value &= 0x0FFFFFFF;
+	else if (rtlpriv->rtlhal.version == VERSION_8192S_ACUT)
+		ratr_value &= 0x0FFFFFF0;
+
+	if (nmode && ((curtxbw_40mhz &&
+			 curshortgi_40mhz) || (!curtxbw_40mhz &&
+						 curshortgi_20mhz))) {
+
+		ratr_value |= 0x10000000;
+		tmp_ratr_value = (ratr_value >> 12);
+
+		for (shortgi_rate = 15; shortgi_rate > 0; shortgi_rate--) {
+			if ((1 << shortgi_rate) & tmp_ratr_value)
+				break;
+		}
+
+		shortgi_rate = (shortgi_rate << 12) | (shortgi_rate << 8) |
+		    (shortgi_rate << 4) | (shortgi_rate);
+
+		rtl_write_byte(rtlpriv, SG_RATE, shortgi_rate);
+	}
+
+	rtl_write_dword(rtlpriv, ARFR0 + ratr_index * 4, ratr_value);
+	if (ratr_value & 0xfffff000)
+		rtl92s_phy_set_fw_cmd(hw, FW_CMD_RA_REFRESH_N);
+	else
+		rtl92s_phy_set_fw_cmd(hw, FW_CMD_RA_REFRESH_BG);
+
+	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "%x\n",
+		 rtl_read_dword(rtlpriv, ARFR0));
+}
+
+static void rtl92su_update_hal_rate_mask(struct ieee80211_hw *hw,
+					 struct ieee80211_sta *sta,
+					 u8 rssi_level)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_sta_info *sta_entry = NULL;
+	u32 ratr_bitmap;
+	u8 ratr_index = 0;
+	u8 curtxbw_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+				? 1 : 0;
+	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+				1 : 0;
+	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+				1 : 0;
+	enum wireless_mode wirelessmode = 0;
+	bool shortgi = false;
+	u32 ratr_value = 0;
+	u8 shortgi_rate = 0;
+	u32 mask = 0;
+	u32 band = 0;
+	bool bmulticast = false;
+	u8 macid = 0;
+	u8 mimo_ps = IEEE80211_SMPS_OFF;
+
+	sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+	wirelessmode = sta_entry->wireless_mode;
+	if (mac->opmode == NL80211_IFTYPE_STATION)
+		curtxbw_40mhz = mac->bw_40;
+	else if (mac->opmode == NL80211_IFTYPE_AP ||
+		mac->opmode == NL80211_IFTYPE_ADHOC)
+		macid = sta->aid + 1;
+
+	if (rtlhal->current_bandtype == BAND_ON_5G)
+		ratr_bitmap = sta->supp_rates[1] << 4;
+	else
+		ratr_bitmap = sta->supp_rates[0];
+	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
+			sta->ht_cap.mcs.rx_mask[0] << 12);
+	switch (wirelessmode) {
+	case WIRELESS_MODE_B:
+		band |= WIRELESS_11B;
+		ratr_index = RATR_INX_WIRELESS_B;
+		if (ratr_bitmap & 0x0000000c)
+			ratr_bitmap &= 0x0000000d;
+		else
+			ratr_bitmap &= 0x0000000f;
+		break;
+	case WIRELESS_MODE_G:
+		band |= (WIRELESS_11G | WIRELESS_11B);
+		ratr_index = RATR_INX_WIRELESS_GB;
+
+		if (rssi_level == 1)
+			ratr_bitmap &= 0x00000f00;
+		else if (rssi_level == 2)
+			ratr_bitmap &= 0x00000ff0;
+		else
+			ratr_bitmap &= 0x00000ff5;
+		break;
+	case WIRELESS_MODE_A:
+		band |= WIRELESS_11A;
+		ratr_index = RATR_INX_WIRELESS_A;
+		ratr_bitmap &= 0x00000ff0;
+		break;
+	case WIRELESS_MODE_N_24G:
+	case WIRELESS_MODE_N_5G:
+		band |= (WIRELESS_11N | WIRELESS_11G | WIRELESS_11B);
+		ratr_index = RATR_INX_WIRELESS_NGB;
+
+		if (mimo_ps == IEEE80211_SMPS_STATIC) {
+			if (rssi_level == 1)
+				ratr_bitmap &= 0x00070000;
+			else if (rssi_level == 2)
+				ratr_bitmap &= 0x0007f000;
+			else
+				ratr_bitmap &= 0x0007f005;
+		} else {
+			if (rtlphy->rf_type == RF_1T2R ||
+				rtlphy->rf_type == RF_1T1R) {
+				if (rssi_level == 1) {
+						ratr_bitmap &= 0x000f0000;
+				} else if (rssi_level == 3) {
+					ratr_bitmap &= 0x000fc000;
+				} else if (rssi_level == 5) {
+						ratr_bitmap &= 0x000ff000;
+				} else {
+					if (curtxbw_40mhz)
+						ratr_bitmap &= 0x000ff015;
+					else
+						ratr_bitmap &= 0x000ff005;
+				}
+			} else {
+				if (rssi_level == 1) {
+					ratr_bitmap &= 0x0f8f0000;
+				} else if (rssi_level == 3) {
+					ratr_bitmap &= 0x0f8fc000;
+				} else if (rssi_level == 5) {
+					ratr_bitmap &= 0x0f8ff000;
+				} else {
+					if (curtxbw_40mhz)
+						ratr_bitmap &= 0x0f8ff015;
+					else
+						ratr_bitmap &= 0x0f8ff005;
+				}
+			}
+		}
+
+		if ((curtxbw_40mhz && curshortgi_40mhz) ||
+		    (!curtxbw_40mhz && curshortgi_20mhz)) {
+			if (macid == 0)
+				shortgi = true;
+			else if (macid == 1)
+				shortgi = false;
+		}
+		break;
+	default:
+		band |= (WIRELESS_11N | WIRELESS_11G | WIRELESS_11B);
+		ratr_index = RATR_INX_WIRELESS_NGB;
+
+		if (rtlphy->rf_type == RF_1T2R)
+			ratr_bitmap &= 0x000ff0ff;
+		else
+			ratr_bitmap &= 0x0f8ff0ff;
+		break;
+	}
+
+	if (rtlpriv->rtlhal.version >= VERSION_8192S_BCUT)
+		ratr_bitmap &= 0x0FFFFFFF;
+	else if (rtlpriv->rtlhal.version == VERSION_8192S_ACUT)
+		ratr_bitmap &= 0x0FFFFFF0;
+
+	if (shortgi) {
+		ratr_bitmap |= 0x10000000;
+		/* Get MAX MCS available. */
+		ratr_value = (ratr_bitmap >> 12);
+		for (shortgi_rate = 15; shortgi_rate > 0; shortgi_rate--) {
+			if ((1 << shortgi_rate) & ratr_value)
+				break;
+		}
+
+		shortgi_rate = (shortgi_rate << 12) | (shortgi_rate << 8) |
+			(shortgi_rate << 4) | (shortgi_rate);
+		rtl_write_byte(rtlpriv, SG_RATE, shortgi_rate);
+	}
+
+	mask |= (bmulticast ? 1 : 0) << 9 | (macid & 0x1f) << 4 | (band & 0xf);
+
+	RT_TRACE(rtlpriv, COMP_RATR, DBG_TRACE, "mask = %x, bitmap = %x\n",
+		 mask, ratr_bitmap);
+	rtl_write_dword(rtlpriv, 0x2c4, ratr_bitmap);
+	rtl_write_dword(rtlpriv, WFM5, (FW_RA_UPDATE_MASK | (mask << 8)));
+
+	if (macid != 0)
+		sta_entry->ratr_index = ratr_index;
+}
+
+void rtl92su_update_hal_rate_tbl(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u8 rssi_level)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->dm.useramask)
+		rtl92su_update_hal_rate_mask(hw, sta, rssi_level);
+	else
+		rtl92su_update_hal_rate_table(hw, sta);
+}
+
+void rtl92su_update_channel_access_setting(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u16 sifs_timer;
+
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_SLOT_TIME,
+				      (u8 *)&mac->slot_time);
+	sifs_timer = 0x0e0e;
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_SIFS, (u8 *)&sifs_timer);
+
+}
+
+/* this ifunction is for RFKILL, it's different with windows,
+ * because UI will disable wireless when GPIO Radio Off.
+ * And here we not check or Disable/Enable ASPM like windows*/
+bool rtl92su_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	enum rf_pwrstate rfpwr_toset /*, cur_rfstate */;
+	unsigned long flag = 0;
+	bool actuallyset = false;
+	bool turnonbypowerdomain = false;
+
+	if (ppsc->swrf_processing)
+		return false;
+
+	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+	if (ppsc->rfchange_inprogress) {
+		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+		return false;
+	} else {
+		ppsc->rfchange_inprogress = true;
+		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+	}
+
+	/* cur_rfstate = ppsc->rfpwr_state;*/
+
+	/* because after _rtl92s_phy_set_rfhalt, all power
+	 * closed, so we must open some power for GPIO check,
+	 * or we will always check GPIO RFOFF here,
+	 * And we should close power after GPIO check */
+	if (RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC)) {
+		_rtl92su_power_domain_init(hw);
+		turnonbypowerdomain = true;
+	}
+
+	rfpwr_toset = _rtl92su_rf_onoff_detect(hw);
+
+	if ((ppsc->hwradiooff) && (rfpwr_toset == ERFON)) {
+		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
+			 "RFKILL-HW Radio ON, RF ON\n");
+
+		rfpwr_toset = ERFON;
+		ppsc->hwradiooff = false;
+		actuallyset = true;
+	} else if ((!ppsc->hwradiooff) && (rfpwr_toset == ERFOFF)) {
+		RT_TRACE(rtlpriv, COMP_RF,
+			 DBG_DMESG, "RFKILL-HW Radio OFF, RF OFF\n");
+
+		rfpwr_toset = ERFOFF;
+		ppsc->hwradiooff = true;
+		actuallyset = true;
+	}
+
+	if (actuallyset) {
+		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+		ppsc->rfchange_inprogress = false;
+		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+
+	/* this not include ifconfig wlan0 down case */
+	/* } else if (rfpwr_toset == ERFOFF || cur_rfstate == ERFOFF) { */
+	} else {
+		/* because power_domain_init may be happen when
+		 * _rtl92s_phy_set_rfhalt, this will open some powers
+		 * and cause current increasing about 40 mA for ips,
+		 * rfoff and ifconfig down, so we set
+		 * _rtl92s_phy_set_rfhalt again here */
+		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_HALT_NIC &&
+			turnonbypowerdomain) {
+			_rtl92s_phy_set_rfhalt(hw);
+			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
+		}
+
+		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+		ppsc->rfchange_inprogress = false;
+		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+	}
+
+	*valid = 1;
+	return !ppsc->hwradiooff;
+
+}
+
+/* Is_wepkey just used for WEP used as group & pairwise key
+ * if pairwise is AES ang group is WEP Is_wepkey == false.*/
+void rtl92su_set_key(struct ieee80211_hw *hw, u32 key_index, u8 *p_macaddr,
+	bool is_group, u8 enc_algo, bool is_wepkey, bool clear_all)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u8 *macaddr = p_macaddr;
+
+	u32 entry_id = 0;
+	bool is_pairwise = false;
+
+	static u8 cam_const_addr[4][6] = {
+		{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
+		{0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
+		{0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
+		{0x00, 0x00, 0x00, 0x00, 0x00, 0x03}
+	};
+	static u8 cam_const_broad[] = {
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	};
+
+	if (clear_all) {
+		u8 idx = 0;
+		u8 cam_offset = 0;
+		u8 clear_number = 5;
+
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, "clear_all\n");
+
+		for (idx = 0; idx < clear_number; idx++) {
+			rtl_cam_mark_invalid(hw, cam_offset + idx);
+			rtl_cam_empty_entry(hw, cam_offset + idx);
+
+			if (idx < 5) {
+				memset(rtlpriv->sec.key_buf[idx], 0,
+				       MAX_KEY_LEN);
+				rtlpriv->sec.key_len[idx] = 0;
+			}
+		}
+
+	} else {
+		switch (enc_algo) {
+		case WEP40_ENCRYPTION:
+			enc_algo = CAM_WEP40;
+			break;
+		case WEP104_ENCRYPTION:
+			enc_algo = CAM_WEP104;
+			break;
+		case TKIP_ENCRYPTION:
+			enc_algo = CAM_TKIP;
+			break;
+		case AESCCMP_ENCRYPTION:
+			enc_algo = CAM_AES;
+			break;
+		default:
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "switch case not processed\n");
+			enc_algo = CAM_TKIP;
+			break;
+		}
+
+		if (is_wepkey || rtlpriv->sec.use_defaultkey) {
+			macaddr = cam_const_addr[key_index];
+			entry_id = key_index;
+		} else {
+			if (is_group) {
+				macaddr = cam_const_broad;
+				entry_id = key_index;
+			} else {
+				if (mac->opmode == NL80211_IFTYPE_AP) {
+					entry_id = rtl_cam_get_free_entry(hw,
+								 p_macaddr);
+					if (entry_id >=  TOTAL_CAM_ENTRY) {
+						RT_TRACE(rtlpriv,
+							 COMP_SEC, DBG_EMERG,
+							 "Can not find free hw security cam entry\n");
+						return;
+					}
+				} else {
+					entry_id = CAM_PAIRWISE_KEY_POSITION;
+				}
+
+				key_index = PAIRWISE_KEYIDX;
+				is_pairwise = true;
+			}
+		}
+
+		if (rtlpriv->sec.key_len[key_index] == 0) {
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+				 "delete one entry, entry_id is %d\n",
+				 entry_id);
+			if (mac->opmode == NL80211_IFTYPE_AP)
+				rtl_cam_del_entry(hw, p_macaddr);
+			rtl_cam_delete_one_entry(hw, p_macaddr, entry_id);
+		} else {
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 "The insert KEY length is %d\n",
+				 rtlpriv->sec.key_len[PAIRWISE_KEYIDX]);
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 "The insert KEY is %x %x\n",
+				 rtlpriv->sec.key_buf[0][0],
+				 rtlpriv->sec.key_buf[0][1]);
+
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+				 "add one entry\n");
+			if (is_pairwise) {
+				RT_PRINT_DATA(rtlpriv, COMP_SEC, DBG_LOUD,
+					      "Pairwise Key content",
+					      rtlpriv->sec.pairwise_key,
+					      rtlpriv->sec.
+					      key_len[PAIRWISE_KEYIDX]);
+
+				RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+					 "set Pairwise key\n");
+
+				rtl_cam_add_one_entry(hw, macaddr, key_index,
+					entry_id, enc_algo,
+					CAM_CONFIG_NO_USEDK,
+					rtlpriv->sec.key_buf[key_index]);
+			} else {
+				RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+					 "set group key\n");
+
+				if (mac->opmode == NL80211_IFTYPE_ADHOC) {
+					rtl_cam_add_one_entry(hw,
+						rtlefuse->dev_addr,
+						PAIRWISE_KEYIDX,
+						CAM_PAIRWISE_KEY_POSITION,
+						enc_algo, CAM_CONFIG_NO_USEDK,
+						rtlpriv->sec.key_buf[entry_id]);
+				}
+
+				rtl_cam_add_one_entry(hw, macaddr, key_index,
+					      entry_id, enc_algo,
+					      CAM_CONFIG_NO_USEDK,
+					      rtlpriv->sec.key_buf[entry_id]);
+			}
+
+		}
+	}
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/hw.h b/drivers/net/wireless/rtlwifi/rtl8192su/hw.h
new file mode 100644
index 0000000..3a8e73c
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/hw.h
@@ -0,0 +1,79 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_PCI92SE_HW_H__
+#define __REALTEK_PCI92SE_HW_H__
+
+#define MSR_LINK_MANAGED   2
+#define MSR_LINK_NONE      0
+#define MSR_LINK_SHIFT     0
+#define MSR_LINK_ADHOC     1
+#define MSR_LINK_MASTER    3
+
+enum WIRELESS_NETWORK_TYPE {
+	WIRELESS_11B = 1,
+	WIRELESS_11G = 2,
+	WIRELESS_11A = 4,
+	WIRELESS_11N = 8
+};
+
+void rtl92su_get_hw_reg(struct ieee80211_hw *hw,
+			u8 variable, u8 *val);
+void rtl92su_read_chip_version(struct ieee80211_hw *hw);
+void rtl92su_read_eeprom_info(struct ieee80211_hw *hw);
+void rtl92su_interrupt_recognized(struct ieee80211_hw *hw,
+				  u32 *inta, u32 *intb);
+int rtl92su_hw_init(struct ieee80211_hw *hw);
+void rtl92su_card_disable(struct ieee80211_hw *hw);
+void rtl92su_enable_interrupt(struct ieee80211_hw *hw);
+void rtl92su_disable_interrupt(struct ieee80211_hw *hw);
+int rtl92su_set_network_type(struct ieee80211_hw *hw,
+			     enum nl80211_iftype type);
+void rtl92su_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
+void rtl92su_set_mac_addr(struct rtl_io *io, const u8 * addr);
+void rtl92su_set_qos(struct ieee80211_hw *hw, int aci);
+void rtl92su_set_beacon_related_registers(struct ieee80211_hw *hw);
+void rtl92su_set_beacon_interval(struct ieee80211_hw *hw);
+void rtl92su_update_interrupt_mask(struct ieee80211_hw *hw,
+				   u32 add_msr, u32 rm_msr);
+void rtl92su_set_hw_reg(struct ieee80211_hw *hw, u8 variable,
+			u8 *val);
+void rtl92su_update_hal_rate_tbl(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u8 rssi_level);
+void rtl92su_update_channel_access_setting(struct ieee80211_hw *hw);
+bool rtl92su_gpio_radio_on_off_checking(struct ieee80211_hw *hw,
+					u8 *valid);
+void rtl8192su_gpiobit3_cfg_inputmode(struct ieee80211_hw *hw);
+void rtl92su_enable_hw_security_config(struct ieee80211_hw *hw);
+void rtl92su_set_key(struct ieee80211_hw *hw,
+		     u32 key_index, u8 *macaddr, bool is_group,
+		     u8 enc_algo, bool is_wepkey, bool clear_all);
+void rtl92su_suspend(struct ieee80211_hw *hw);
+void rtl92su_resume(struct ieee80211_hw *hw);
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/led.c b/drivers/net/wireless/rtlwifi/rtl8192su/led.c
new file mode 100644
index 0000000..134b1d1
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/led.c
@@ -0,0 +1,154 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../usb.h"
+#include "reg.h"
+#include "led.h"
+
+static void _rtl92su_init_led(struct ieee80211_hw *hw,
+			      struct rtl_led *pled, enum rtl_led_pin ledpin)
+{
+	pled->hw = hw;
+	pled->ledpin = ledpin;
+	pled->ledon = false;
+}
+
+void rtl92su_init_sw_leds(struct ieee80211_hw *hw)
+{
+	struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
+	_rtl92su_init_led(hw, &(usbpriv->ledctl.sw_led0), LED_PIN_LED0);
+	_rtl92su_init_led(hw, &(usbpriv->ledctl.sw_led1), LED_PIN_LED1);
+}
+
+void rtl92su_deinit_sw_leds(struct ieee80211_hw *hw)
+{
+}
+
+void rtl92su_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
+{
+	u8 ledcfg;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, "LedAddr:%X ledpin=%d\n",
+		 LEDCFG, pled->ledpin);
+
+	ledcfg = rtl_read_byte(rtlpriv, LEDCFG);
+
+	switch (pled->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		rtl_write_byte(rtlpriv, LEDCFG, ledcfg & 0xf0);
+		break;
+	case LED_PIN_LED1:
+		rtl_write_byte(rtlpriv, LEDCFG, ledcfg & 0x0f);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "switch case not processed\n");
+		break;
+	}
+	pled->ledon = true;
+}
+
+void rtl92su_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
+{
+	struct rtl_priv *rtlpriv;
+	struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
+	u8 ledcfg;
+
+	rtlpriv = rtl_priv(hw);
+	if (!rtlpriv || rtlpriv->max_fw_size)
+		return;
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, "LedAddr:%X ledpin=%d\n",
+		 LEDCFG, pled->ledpin);
+
+	ledcfg = rtl_read_byte(rtlpriv, LEDCFG);
+
+	switch (pled->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		ledcfg &= 0xf0;
+		if (usbpriv->ledctl.led_opendrain)
+			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(1)));
+		else
+			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
+		break;
+	case LED_PIN_LED1:
+		ledcfg &= 0x0f;
+		rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "switch case not processed\n");
+		break;
+	}
+	pled->ledon = false;
+}
+
+static void _rtl92su_sw_led_control(struct ieee80211_hw *hw,
+				    enum led_ctl_mode ledaction)
+{
+	struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
+	struct rtl_led *pLed0 = &(usbpriv->ledctl.sw_led0);
+	switch (ledaction) {
+	case LED_CTL_POWER_ON:
+	case LED_CTL_LINK:
+	case LED_CTL_NO_LINK:
+		rtl92su_sw_led_on(hw, pLed0);
+		break;
+	case LED_CTL_POWER_OFF:
+		rtl92su_sw_led_off(hw, pLed0);
+		break;
+	default:
+		break;
+	}
+}
+
+void rtl92su_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	if ((ppsc->rfoff_reason > RF_CHANGE_BY_PS) &&
+	    (ledaction == LED_CTL_TX ||
+	    ledaction == LED_CTL_RX ||
+	    ledaction == LED_CTL_SITE_SURVEY ||
+	    ledaction == LED_CTL_LINK ||
+	    ledaction == LED_CTL_NO_LINK ||
+	    ledaction == LED_CTL_START_TO_LINK ||
+	    ledaction == LED_CTL_POWER_ON)) {
+		return;
+	}
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, "ledaction %d\n", ledaction);
+
+	_rtl92su_sw_led_control(hw, ledaction);
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/led.h b/drivers/net/wireless/rtlwifi/rtl8192su/led.h
new file mode 100644
index 0000000..2ed8772
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/led.h
@@ -0,0 +1,38 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_PCI92SE_LED_H__
+#define __REALTEK_PCI92SE_LED_H__
+
+void rtl92su_init_sw_leds(struct ieee80211_hw *hw);
+void rtl92su_deinit_sw_leds(struct ieee80211_hw *hw);
+void rtl92su_sw_led_on(struct ieee80211_hw *hw,	struct rtl_led *pled);
+void rtl92su_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92su_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/phy.c b/drivers/net/wireless/rtlwifi/rtl8192su/phy.c
new file mode 100644
index 0000000..946bfe7
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/phy.c
@@ -0,0 +1,1751 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../pci.h"
+#include "../ps.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "rf.h"
+#include "dm.h"
+#include "fw.h"
+#include "hw.h"
+#include "table.h"
+
+static u32 _rtl92s_phy_calculate_bit_shift(u32 bitmask)
+{
+	u32 i;
+
+	for (i = 0; i <= 31; i++) {
+		if (((bitmask >> i) & 0x1) == 1)
+			break;
+	}
+
+	return i;
+}
+
+u32 rtl92s_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 returnvalue = 0, originalvalue, bitshift;
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, "regaddr(%#x), bitmask(%#x)\n",
+		 regaddr, bitmask);
+
+	originalvalue = rtl92s_fw_iocmd_read(hw,
+				IOCMD_CLASS_BB_RF,
+				(regaddr & 0x0fff),
+				IOCMD_BB_READ_IDX);
+	bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+	returnvalue = (originalvalue & bitmask) >> bitshift;
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, "BBR MASK=0x%x Addr[0x%x]=0x%x\n",
+		 bitmask, regaddr, originalvalue);
+
+	return returnvalue;
+
+}
+
+void rtl92s_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
+			   u32 data)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 originalvalue, bitshift;
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
+		 "regaddr(%#x), bitmask(%#x), data(%#x)\n",
+		 regaddr, bitmask, data);
+
+	if (bitmask != MASKDWORD) {
+		originalvalue = rtl92s_fw_iocmd_read(hw,
+					IOCMD_CLASS_BB_RF,
+					(regaddr & 0x0fff),
+					IOCMD_BB_READ_IDX);
+		bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+		data = ((originalvalue & (~bitmask)) | (data << bitshift));
+	}
+
+	rtl92s_fw_iocmd_write(hw,
+			IOCMD_CLASS_BB_RF,
+			(regaddr & 0x0fff),
+			IOCMD_BB_WRITE_IDX,
+			data);
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
+		 "regaddr(%#x), bitmask(%#x), data(%#x)\n",
+		 regaddr, bitmask, data);
+
+}
+
+#if 0
+static u32 _rtl92s_phy_rf_serial_read(struct ieee80211_hw *hw,
+				      enum radio_path rfpath, u32 offset)
+{
+
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct bb_reg_def *pphyreg = &rtlphy->phyreg_def[rfpath];
+	u32 newoffset;
+	u32 tmplong, tmplong2;
+	u8 rfpi_enable = 0;
+	u32 retvalue = 0;
+
+	offset &= 0x3f;
+	newoffset = offset;
+
+	tmplong = rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD);
+
+	if (rfpath == RF90_PATH_A)
+		tmplong2 = tmplong;
+	else
+		tmplong2 = rtl_get_bbreg(hw, pphyreg->rfhssi_para2, MASKDWORD);
+
+	tmplong2 = (tmplong2 & (~BLSSI_READADDRESS)) | (newoffset << 23) |
+			BLSSI_READEDGE;
+
+	rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD,
+		      tmplong & (~BLSSI_READEDGE));
+
+	mdelay(1);
+
+	rtl_set_bbreg(hw, pphyreg->rfhssi_para2, MASKDWORD, tmplong2);
+	mdelay(1);
+
+	rtl_set_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD, tmplong |
+		      BLSSI_READEDGE);
+	mdelay(1);
+
+	if (rfpath == RF90_PATH_A)
+		rfpi_enable = (u8)rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER1,
+						BIT(8));
+	else if (rfpath == RF90_PATH_B)
+		rfpi_enable = (u8)rtl_get_bbreg(hw, RFPGA0_XB_HSSIPARAMETER1,
+						BIT(8));
+
+	if (rfpi_enable)
+		retvalue = rtl_get_bbreg(hw, pphyreg->rflssi_readbackpi,
+					 BLSSI_READBACK_DATA);
+	else
+		retvalue = rtl_get_bbreg(hw, pphyreg->rflssi_readback,
+					 BLSSI_READBACK_DATA);
+
+	retvalue = rtl_get_bbreg(hw, pphyreg->rflssi_readback,
+				 BLSSI_READBACK_DATA);
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, "RFR-%d Addr[0x%x]=0x%x\n",
+		 rfpath, pphyreg->rflssi_readback, retvalue);
+
+	return retvalue;
+
+}
+
+static void _rtl92s_phy_rf_serial_write(struct ieee80211_hw *hw,
+					enum radio_path rfpath, u32 offset,
+					u32 data)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct bb_reg_def *pphyreg = &rtlphy->phyreg_def[rfpath];
+	u32 data_and_addr = 0;
+	u32 newoffset;
+
+	offset &= 0x3f;
+	newoffset = offset;
+
+	data_and_addr = ((newoffset << 20) | (data & 0x000fffff)) & 0x0fffffff;
+	rtl_set_bbreg(hw, pphyreg->rf3wire_offset, MASKDWORD, data_and_addr);
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, "RFW-%d Addr[0x%x]=0x%x\n",
+		 rfpath, pphyreg->rf3wire_offset, data_and_addr);
+}
+#endif
+
+u32 rtl92s_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
+			    u32 regaddr, u32 bitmask)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 original_value, readback_value, bitshift;
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
+		 "regaddr(%#x), rfpath(%#x), bitmask(%#x)\n",
+		 regaddr, rfpath, bitmask);
+
+	spin_lock(&rtlpriv->locks.rf_lock);
+
+	original_value = rtl92s_fw_iocmd_read(hw,
+				IOCMD_CLASS_BB_RF,
+				(rfpath << 8) | (regaddr & 0xff),
+				IOCMD_RF_READ_IDX);
+
+	bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+	readback_value = (original_value & bitmask) >> bitshift;
+
+	spin_unlock(&rtlpriv->locks.rf_lock);
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
+		 "regaddr(%#x), rfpath(%#x), bitmask(%#x), original_value(%#x)\n",
+		 regaddr, rfpath, bitmask, original_value);
+
+	return readback_value;
+}
+
+void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
+			   u32 regaddr, u32 bitmask, u32 data)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u32 original_value, bitshift;
+
+	if (!((rtlphy->rf_pathmap >> rfpath) & 0x1))
+		return;
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
+		 "regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
+		 regaddr, bitmask, data, rfpath);
+
+	spin_lock(&rtlpriv->locks.rf_lock);
+
+	if (bitmask != RFREG_OFFSET_MASK) {
+		original_value = rtl92s_fw_iocmd_read(hw,
+					IOCMD_CLASS_BB_RF,
+					(rfpath << 8) | (regaddr & 0xff),
+					IOCMD_RF_READ_IDX);
+		bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+		data = ((original_value & (~bitmask)) | (data << bitshift));
+	}
+
+	rtl92s_fw_iocmd_write(hw,
+			IOCMD_CLASS_BB_RF,
+			(rfpath << 8) | (regaddr & 0xff),
+			IOCMD_RF_WRITE_IDX,
+			data);
+
+	spin_unlock(&rtlpriv->locks.rf_lock);
+
+	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
+		 "regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
+		 regaddr, bitmask, data, rfpath);
+
+}
+
+void rtl92s_phy_scan_operation_backup(struct ieee80211_hw *hw,
+				      u8 operation)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+
+	if (!is_hal_stop(rtlhal)) {
+		switch (operation) {
+		case SCAN_OPT_BACKUP:
+			rtl92s_phy_set_fw_cmd(hw, FW_CMD_PAUSE_DM_BY_SCAN);
+			break;
+		case SCAN_OPT_RESTORE:
+			rtl92s_phy_set_fw_cmd(hw, FW_CMD_RESUME_DM_BY_SCAN);
+			break;
+		default:
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "Unknown operation\n");
+			break;
+		}
+	}
+}
+
+void rtl92s_phy_set_bw_mode(struct ieee80211_hw *hw,
+			    enum nl80211_channel_type ch_type)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u8 reg_bw_opmode;
+
+	// XXX
+	return;
+
+	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, "Switch to %s bandwidth\n",
+		 rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ?
+		 "20MHz" : "40MHz");
+
+	if (rtlphy->set_bwmode_inprogress)
+		return;
+	if (is_hal_stop(rtlhal))
+		return;
+
+	rtlphy->set_bwmode_inprogress = true;
+
+	reg_bw_opmode = rtl_read_byte(rtlpriv, BW_OPMODE);
+	/* dummy read */
+	rtl_read_byte(rtlpriv, RRSR + 2);
+
+	switch (rtlphy->current_chan_bw) {
+	case HT_CHANNEL_WIDTH_20:
+		reg_bw_opmode |= BW_OPMODE_20MHZ;
+		rtl_write_byte(rtlpriv, BW_OPMODE, reg_bw_opmode);
+		break;
+	case HT_CHANNEL_WIDTH_20_40:
+		reg_bw_opmode &= ~BW_OPMODE_20MHZ;
+		rtl_write_byte(rtlpriv, BW_OPMODE, reg_bw_opmode);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		break;
+	}
+
+	switch (rtlphy->current_chan_bw) {
+	case HT_CHANNEL_WIDTH_20:
+		rtl_set_bbreg(hw, RFPGA0_RFMOD, BRFMOD, 0x0);
+		rtl_set_bbreg(hw, RFPGA1_RFMOD, BRFMOD, 0x0);
+
+		if (rtlhal->version >= VERSION_8192S_BCUT)
+			rtl_write_byte(rtlpriv, RFPGA0_ANALOGPARAMETER2, 0x58);
+		break;
+	case HT_CHANNEL_WIDTH_20_40:
+		rtl_set_bbreg(hw, RFPGA0_RFMOD, BRFMOD, 0x1);
+		rtl_set_bbreg(hw, RFPGA1_RFMOD, BRFMOD, 0x1);
+
+		rtl_set_bbreg(hw, RCCK0_SYSTEM, BCCK_SIDEBAND,
+				(mac->cur_40_prime_sc >> 1));
+		rtl_set_bbreg(hw, ROFDM1_LSTF, 0xC00, mac->cur_40_prime_sc);
+
+		if (rtlhal->version >= VERSION_8192S_BCUT)
+			rtl_write_byte(rtlpriv, RFPGA0_ANALOGPARAMETER2, 0x18);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		break;
+	}
+
+	rtl92s_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
+	rtlphy->set_bwmode_inprogress = false;
+	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, "<==\n");
+}
+
+static bool _rtl92s_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
+		u32 cmdtableidx, u32 cmdtablesz, enum swchnlcmd_id cmdid,
+		u32 para1, u32 para2, u32 msdelay)
+{
+	struct swchnlcmd *pcmd;
+
+	if (cmdtable == NULL) {
+		RT_ASSERT(false, "cmdtable cannot be NULL\n");
+		return false;
+	}
+
+	if (cmdtableidx >= cmdtablesz)
+		return false;
+
+	pcmd = cmdtable + cmdtableidx;
+	pcmd->cmdid = cmdid;
+	pcmd->para1 = para1;
+	pcmd->para2 = para2;
+	pcmd->msdelay = msdelay;
+
+	return true;
+}
+
+static bool _rtl92s_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
+	     u8 channel, u8 *stage, u8 *step, u32 *delay)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct swchnlcmd precommoncmd[MAX_PRECMD_CNT];
+	u32 precommoncmdcnt;
+	struct swchnlcmd postcommoncmd[MAX_POSTCMD_CNT];
+	u32 postcommoncmdcnt;
+	struct swchnlcmd rfdependcmd[MAX_RFDEPENDCMD_CNT];
+	u32 rfdependcmdcnt;
+	struct swchnlcmd *currentcmd = NULL;
+	u8 rfpath;
+	u8 num_total_rfpath = rtlphy->num_total_rfpath;
+
+	precommoncmdcnt = 0;
+	_rtl92s_phy_set_sw_chnl_cmdarray(precommoncmd, precommoncmdcnt++,
+			MAX_PRECMD_CNT, CMDID_SET_TXPOWEROWER_LEVEL, 0, 0, 0);
+	_rtl92s_phy_set_sw_chnl_cmdarray(precommoncmd, precommoncmdcnt++,
+			MAX_PRECMD_CNT, CMDID_END, 0, 0, 0);
+
+	postcommoncmdcnt = 0;
+
+	_rtl92s_phy_set_sw_chnl_cmdarray(postcommoncmd, postcommoncmdcnt++,
+			MAX_POSTCMD_CNT, CMDID_END, 0, 0, 0);
+
+	rfdependcmdcnt = 0;
+
+	RT_ASSERT((channel >= 1 && channel <= 14),
+		  "invalid channel for Zebra: %d\n", channel);
+
+	_rtl92s_phy_set_sw_chnl_cmdarray(rfdependcmd, rfdependcmdcnt++,
+					 MAX_RFDEPENDCMD_CNT, CMDID_RF_WRITEREG,
+					 RF_CHNLBW, channel, 10);
+
+	_rtl92s_phy_set_sw_chnl_cmdarray(rfdependcmd, rfdependcmdcnt++,
+			MAX_RFDEPENDCMD_CNT, CMDID_END, 0, 0, 0);
+
+	do {
+		switch (*stage) {
+		case 0:
+			currentcmd = &precommoncmd[*step];
+			break;
+		case 1:
+			currentcmd = &rfdependcmd[*step];
+			break;
+		case 2:
+			currentcmd = &postcommoncmd[*step];
+			break;
+		}
+
+		if (currentcmd->cmdid == CMDID_END) {
+			if ((*stage) == 2) {
+				return true;
+			} else {
+				(*stage)++;
+				(*step) = 0;
+				continue;
+			}
+		}
+
+		switch (currentcmd->cmdid) {
+		case CMDID_SET_TXPOWEROWER_LEVEL:
+			rtl92s_phy_set_txpower(hw, channel);
+			break;
+		case CMDID_WRITEPORT_ULONG:
+			rtl_write_dword(rtlpriv, currentcmd->para1,
+					currentcmd->para2);
+			break;
+		case CMDID_WRITEPORT_USHORT:
+			rtl_write_word(rtlpriv, currentcmd->para1,
+				       (u16)currentcmd->para2);
+			break;
+		case CMDID_WRITEPORT_UCHAR:
+			rtl_write_byte(rtlpriv, currentcmd->para1,
+				       (u8)currentcmd->para2);
+			break;
+		case CMDID_RF_WRITEREG:
+			for (rfpath = 0; rfpath < num_total_rfpath; rfpath++) {
+				rtlphy->rfreg_chnlval[rfpath] =
+					 ((rtlphy->rfreg_chnlval[rfpath] &
+					 0xfffffc00) | currentcmd->para2);
+				rtl_set_rfreg(hw, (enum radio_path)rfpath,
+					      currentcmd->para1,
+					      RFREG_OFFSET_MASK,
+					      rtlphy->rfreg_chnlval[rfpath]);
+			}
+			break;
+		default:
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 "switch case not processed\n");
+			break;
+		}
+
+		break;
+	} while (true);
+
+	(*delay) = currentcmd->msdelay;
+	(*step)++;
+	return false;
+}
+
+u8 rtl92s_phy_sw_chnl(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u32 delay;
+	bool ret;
+
+	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, "switch to channel%d\n",
+		 rtlphy->current_channel);
+
+	if (rtlphy->sw_chnl_inprogress)
+		return 0;
+
+	if (rtlphy->set_bwmode_inprogress)
+		return 0;
+
+	if (is_hal_stop(rtlhal))
+		return 0;
+
+	rtlphy->sw_chnl_inprogress = true;
+	rtlphy->sw_chnl_stage = 0;
+	rtlphy->sw_chnl_step = 0;
+
+	do {
+		if (!rtlphy->sw_chnl_inprogress)
+			break;
+
+		ret = _rtl92s_phy_sw_chnl_step_by_step(hw,
+				 rtlphy->current_channel,
+				 &rtlphy->sw_chnl_stage,
+				 &rtlphy->sw_chnl_step, &delay);
+		if (!ret) {
+			if (delay > 0)
+				mdelay(delay);
+			else
+				continue;
+		} else {
+			rtlphy->sw_chnl_inprogress = false;
+		}
+		break;
+	} while (true);
+
+	rtlphy->sw_chnl_inprogress = false;
+
+	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, "<==\n");
+
+	return 1;
+}
+
+static void _rtl92se_phy_set_rf_sleep(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 u1btmp;
+
+	// XXX
+	return;
+
+	u1btmp = rtl_read_byte(rtlpriv, LDOV12D_CTRL);
+	u1btmp |= BIT(0);
+
+	rtl_write_byte(rtlpriv, LDOV12D_CTRL, u1btmp);
+	rtl_write_byte(rtlpriv, SPS1_CTRL, 0x0);
+	rtl_write_byte(rtlpriv, TXPAUSE, 0xFF);
+	rtl_write_word(rtlpriv, CMDR, 0x57FC);
+	udelay(100);
+
+	rtl_write_word(rtlpriv, CMDR, 0x77FC);
+	rtl_write_byte(rtlpriv, PHY_CCA, 0x0);
+	udelay(10);
+
+	rtl_write_word(rtlpriv, CMDR, 0x37FC);
+	udelay(10);
+
+	rtl_write_word(rtlpriv, CMDR, 0x77FC);
+	udelay(10);
+
+	rtl_write_word(rtlpriv, CMDR, 0x57FC);
+
+	/* we should chnge GPIO to input mode
+	 * this will drop away current about 25mA*/
+	rtl8192su_gpiobit3_cfg_inputmode(hw);
+}
+
+bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
+				   enum rf_pwrstate rfpwr_state)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	bool bresult = true;
+
+	if (rfpwr_state == ppsc->rfpwr_state)
+		return false;
+
+	switch (rfpwr_state) {
+	case ERFON:{
+			if ((ppsc->rfpwr_state == ERFOFF) &&
+			    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC)) {
+
+				bool rtstatus;
+				u32 InitializeCount = 0;
+				do {
+					InitializeCount++;
+					RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
+						 "IPS Set eRf nic enable\n");
+					rtstatus = rtl_ps_enable_nic(hw);
+				} while (!rtstatus && (InitializeCount < 10));
+
+				RT_CLEAR_PS_LEVEL(ppsc,
+						  RT_RF_OFF_LEVL_HALT_NIC);
+			} else {
+				RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
+					 "awake, sleeped:%d ms state_inap:%x\n",
+					 jiffies_to_msecs(jiffies -
+							  ppsc->
+							  last_sleep_jiffies),
+					 rtlpriv->psc.state_inap);
+				ppsc->last_awake_jiffies = jiffies;
+				rtl_write_word(rtlpriv, CMDR, 0x37FC);
+				rtl_write_byte(rtlpriv, TXPAUSE, 0x00);
+				rtl_write_byte(rtlpriv, PHY_CCA, 0x3);
+			}
+
+			if (mac->link_state == MAC80211_LINKED)
+				rtlpriv->cfg->ops->led_control(hw,
+							 LED_CTL_LINK);
+			else
+				rtlpriv->cfg->ops->led_control(hw,
+							 LED_CTL_NO_LINK);
+			break;
+		}
+	case ERFOFF:{
+			if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_HALT_NIC) {
+				RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
+					 "IPS Set eRf nic disable\n");
+				rtl_ps_disable_nic(hw);
+				RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
+			} else {
+				if (ppsc->rfoff_reason == RF_CHANGE_BY_IPS)
+					rtlpriv->cfg->ops->led_control(hw,
+							 LED_CTL_NO_LINK);
+				else
+					rtlpriv->cfg->ops->led_control(hw,
+							 LED_CTL_POWER_OFF);
+			}
+			break;
+		}
+	case ERFSLEEP:
+			if (ppsc->rfpwr_state == ERFOFF)
+				return false;
+
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
+				 "Set ERFSLEEP awaked:%d ms\n",
+				 jiffies_to_msecs(jiffies -
+						  ppsc->last_awake_jiffies));
+
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
+				 "sleep awaked:%d ms state_inap:%x\n",
+				 jiffies_to_msecs(jiffies -
+						  ppsc->last_awake_jiffies),
+				 rtlpriv->psc.state_inap);
+			ppsc->last_sleep_jiffies = jiffies;
+			_rtl92se_phy_set_rf_sleep(hw);
+	    break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "switch case not processed\n");
+		bresult = false;
+		break;
+	}
+
+	if (bresult)
+		ppsc->rfpwr_state = rfpwr_state;
+
+	return bresult;
+}
+
+static bool _rtl92s_phy_config_rfpa_bias_current(struct ieee80211_hw *hw,
+						 enum radio_path rfpath)
+{
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	bool rtstatus = true;
+	u32 tmpval = 0;
+
+	/* If inferiority IC, we have to increase the PA bias current */
+	if (rtlhal->ic_class != IC_INFERIORITY_A) {
+		tmpval = rtl92s_phy_query_rf_reg(hw, rfpath, RF_IPA, 0xf);
+		rtl92s_phy_set_rf_reg(hw, rfpath, RF_IPA, 0xf, tmpval + 1);
+	}
+
+	return rtstatus;
+}
+
+static void _rtl92s_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
+		u32 reg_addr, u32 bitmask, u32 data)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	int index;
+
+	if (reg_addr == RTXAGC_RATE18_06)
+		index = 0;
+	else if (reg_addr == RTXAGC_RATE54_24)
+		index = 1;
+	else if (reg_addr == RTXAGC_CCK_MCS32)
+		index = 6;
+	else if (reg_addr == RTXAGC_MCS03_MCS00)
+		index = 2;
+	else if (reg_addr == RTXAGC_MCS07_MCS04)
+		index = 3;
+	else if (reg_addr == RTXAGC_MCS11_MCS08)
+		index = 4;
+	else if (reg_addr == RTXAGC_MCS15_MCS12)
+		index = 5;
+	else
+		return;
+
+	rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][index] = data;
+	if (index == 5)
+		rtlphy->pwrgroup_cnt++;
+}
+
+static void _rtl92s_phy_init_register_definition(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+
+	/*RF Interface Sowrtware Control */
+	rtlphy->phyreg_def[RF90_PATH_A].rfintfs = RFPGA0_XAB_RFINTERFACESW;
+	rtlphy->phyreg_def[RF90_PATH_B].rfintfs = RFPGA0_XAB_RFINTERFACESW;
+	rtlphy->phyreg_def[RF90_PATH_C].rfintfs = RFPGA0_XCD_RFINTERFACESW;
+	rtlphy->phyreg_def[RF90_PATH_D].rfintfs = RFPGA0_XCD_RFINTERFACESW;
+
+	/* RF Interface Readback Value */
+	rtlphy->phyreg_def[RF90_PATH_A].rfintfi = RFPGA0_XAB_RFINTERFACERB;
+	rtlphy->phyreg_def[RF90_PATH_B].rfintfi = RFPGA0_XAB_RFINTERFACERB;
+	rtlphy->phyreg_def[RF90_PATH_C].rfintfi = RFPGA0_XCD_RFINTERFACERB;
+	rtlphy->phyreg_def[RF90_PATH_D].rfintfi = RFPGA0_XCD_RFINTERFACERB;
+
+	/* RF Interface Output (and Enable) */
+	rtlphy->phyreg_def[RF90_PATH_A].rfintfo = RFPGA0_XA_RFINTERFACEOE;
+	rtlphy->phyreg_def[RF90_PATH_B].rfintfo = RFPGA0_XB_RFINTERFACEOE;
+	rtlphy->phyreg_def[RF90_PATH_C].rfintfo = RFPGA0_XC_RFINTERFACEOE;
+	rtlphy->phyreg_def[RF90_PATH_D].rfintfo = RFPGA0_XD_RFINTERFACEOE;
+
+	/* RF Interface (Output and)  Enable */
+	rtlphy->phyreg_def[RF90_PATH_A].rfintfe = RFPGA0_XA_RFINTERFACEOE;
+	rtlphy->phyreg_def[RF90_PATH_B].rfintfe = RFPGA0_XB_RFINTERFACEOE;
+	rtlphy->phyreg_def[RF90_PATH_C].rfintfe = RFPGA0_XC_RFINTERFACEOE;
+	rtlphy->phyreg_def[RF90_PATH_D].rfintfe = RFPGA0_XD_RFINTERFACEOE;
+
+	/* Addr of LSSI. Wirte RF register by driver */
+	rtlphy->phyreg_def[RF90_PATH_A].rf3wire_offset =
+						 RFPGA0_XA_LSSIPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_B].rf3wire_offset =
+						 RFPGA0_XB_LSSIPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_C].rf3wire_offset =
+						 RFPGA0_XC_LSSIPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_D].rf3wire_offset =
+						 RFPGA0_XD_LSSIPARAMETER;
+
+	/* RF parameter */
+	rtlphy->phyreg_def[RF90_PATH_A].rflssi_select = RFPGA0_XAB_RFPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_B].rflssi_select = RFPGA0_XAB_RFPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_C].rflssi_select = RFPGA0_XCD_RFPARAMETER;
+	rtlphy->phyreg_def[RF90_PATH_D].rflssi_select = RFPGA0_XCD_RFPARAMETER;
+
+	/* Tx AGC Gain Stage (same for all path. Should we remove this?) */
+	rtlphy->phyreg_def[RF90_PATH_A].rftxgain_stage = RFPGA0_TXGAINSTAGE;
+	rtlphy->phyreg_def[RF90_PATH_B].rftxgain_stage = RFPGA0_TXGAINSTAGE;
+	rtlphy->phyreg_def[RF90_PATH_C].rftxgain_stage = RFPGA0_TXGAINSTAGE;
+	rtlphy->phyreg_def[RF90_PATH_D].rftxgain_stage = RFPGA0_TXGAINSTAGE;
+
+	/* Tranceiver A~D HSSI Parameter-1 */
+	rtlphy->phyreg_def[RF90_PATH_A].rfhssi_para1 = RFPGA0_XA_HSSIPARAMETER1;
+	rtlphy->phyreg_def[RF90_PATH_B].rfhssi_para1 = RFPGA0_XB_HSSIPARAMETER1;
+	rtlphy->phyreg_def[RF90_PATH_C].rfhssi_para1 = RFPGA0_XC_HSSIPARAMETER1;
+	rtlphy->phyreg_def[RF90_PATH_D].rfhssi_para1 = RFPGA0_XD_HSSIPARAMETER1;
+
+	/* Tranceiver A~D HSSI Parameter-2 */
+	rtlphy->phyreg_def[RF90_PATH_A].rfhssi_para2 = RFPGA0_XA_HSSIPARAMETER2;
+	rtlphy->phyreg_def[RF90_PATH_B].rfhssi_para2 = RFPGA0_XB_HSSIPARAMETER2;
+	rtlphy->phyreg_def[RF90_PATH_C].rfhssi_para2 = RFPGA0_XC_HSSIPARAMETER2;
+	rtlphy->phyreg_def[RF90_PATH_D].rfhssi_para2 = RFPGA0_XD_HSSIPARAMETER2;
+
+	/* RF switch Control */
+	rtlphy->phyreg_def[RF90_PATH_A].rfswitch_control =
+						 RFPGA0_XAB_SWITCHCONTROL;
+	rtlphy->phyreg_def[RF90_PATH_B].rfswitch_control =
+						 RFPGA0_XAB_SWITCHCONTROL;
+	rtlphy->phyreg_def[RF90_PATH_C].rfswitch_control =
+						 RFPGA0_XCD_SWITCHCONTROL;
+	rtlphy->phyreg_def[RF90_PATH_D].rfswitch_control =
+						 RFPGA0_XCD_SWITCHCONTROL;
+
+	/* AGC control 1  */
+	rtlphy->phyreg_def[RF90_PATH_A].rfagc_control1 = ROFDM0_XAAGCCORE1;
+	rtlphy->phyreg_def[RF90_PATH_B].rfagc_control1 = ROFDM0_XBAGCCORE1;
+	rtlphy->phyreg_def[RF90_PATH_C].rfagc_control1 = ROFDM0_XCAGCCORE1;
+	rtlphy->phyreg_def[RF90_PATH_D].rfagc_control1 = ROFDM0_XDAGCCORE1;
+
+	/* AGC control 2  */
+	rtlphy->phyreg_def[RF90_PATH_A].rfagc_control2 = ROFDM0_XAAGCCORE2;
+	rtlphy->phyreg_def[RF90_PATH_B].rfagc_control2 = ROFDM0_XBAGCCORE2;
+	rtlphy->phyreg_def[RF90_PATH_C].rfagc_control2 = ROFDM0_XCAGCCORE2;
+	rtlphy->phyreg_def[RF90_PATH_D].rfagc_control2 = ROFDM0_XDAGCCORE2;
+
+	/* RX AFE control 1  */
+	rtlphy->phyreg_def[RF90_PATH_A].rfrxiq_imbalance =
+						 ROFDM0_XARXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_B].rfrxiq_imbalance =
+						 ROFDM0_XBRXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_C].rfrxiq_imbalance =
+						 ROFDM0_XCRXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_D].rfrxiq_imbalance =
+						 ROFDM0_XDRXIQIMBALANCE;
+
+	/* RX AFE control 1   */
+	rtlphy->phyreg_def[RF90_PATH_A].rfrx_afe = ROFDM0_XARXAFE;
+	rtlphy->phyreg_def[RF90_PATH_B].rfrx_afe = ROFDM0_XBRXAFE;
+	rtlphy->phyreg_def[RF90_PATH_C].rfrx_afe = ROFDM0_XCRXAFE;
+	rtlphy->phyreg_def[RF90_PATH_D].rfrx_afe = ROFDM0_XDRXAFE;
+
+	/* Tx AFE control 1  */
+	rtlphy->phyreg_def[RF90_PATH_A].rftxiq_imbalance =
+						 ROFDM0_XATXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_B].rftxiq_imbalance =
+						 ROFDM0_XBTXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_C].rftxiq_imbalance =
+						 ROFDM0_XCTXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_D].rftxiq_imbalance =
+						 ROFDM0_XDTXIQIMBALANCE;
+
+	/* Tx AFE control 2  */
+	rtlphy->phyreg_def[RF90_PATH_A].rftx_afe = ROFDM0_XATXAFE;
+	rtlphy->phyreg_def[RF90_PATH_B].rftx_afe = ROFDM0_XBTXAFE;
+	rtlphy->phyreg_def[RF90_PATH_C].rftx_afe = ROFDM0_XCTXAFE;
+	rtlphy->phyreg_def[RF90_PATH_D].rftx_afe = ROFDM0_XDTXAFE;
+
+	/* Tranceiver LSSI Readback */
+	rtlphy->phyreg_def[RF90_PATH_A].rflssi_readback =
+			 RFPGA0_XA_LSSIREADBACK;
+	rtlphy->phyreg_def[RF90_PATH_B].rflssi_readback =
+			 RFPGA0_XB_LSSIREADBACK;
+	rtlphy->phyreg_def[RF90_PATH_C].rflssi_readback =
+			 RFPGA0_XC_LSSIREADBACK;
+	rtlphy->phyreg_def[RF90_PATH_D].rflssi_readback =
+			 RFPGA0_XD_LSSIREADBACK;
+
+	/* Tranceiver LSSI Readback PI mode  */
+	rtlphy->phyreg_def[RF90_PATH_A].rflssi_readbackpi =
+			 TRANSCEIVERA_HSPI_READBACK;
+	rtlphy->phyreg_def[RF90_PATH_B].rflssi_readbackpi =
+			 TRANSCEIVERB_HSPI_READBACK;
+}
+
+
+static bool _rtl92s_phy_config_bb(struct ieee80211_hw *hw, u8 configtype)
+{
+	//int i;
+	u32 *phy_reg_table;
+	u32 *agc_table;
+	u16 phy_reg_len, agc_len;
+
+	agc_len = AGCTAB_ARRAYLENGTH;
+	agc_table = rtl8192seagctab_array;
+	/* Default RF_type: 2T2R */
+	phy_reg_len = PHY_REG_2T2RARRAYLENGTH;
+	phy_reg_table = rtl8192sephy_reg_2t2rarray;
+
+#if 0
+/* this takes forever to complete... comment out for now */
+	if (configtype == BASEBAND_CONFIG_PHY_REG) {
+		for (i = 0; i < phy_reg_len; i = i + 2) {
+			if (phy_reg_table[i] == 0xfe)
+				mdelay(50);
+			else if (phy_reg_table[i] == 0xfd)
+				mdelay(5);
+			else if (phy_reg_table[i] == 0xfc)
+				mdelay(1);
+			else if (phy_reg_table[i] == 0xfb)
+				udelay(50);
+			else if (phy_reg_table[i] == 0xfa)
+				udelay(5);
+			else if (phy_reg_table[i] == 0xf9)
+				udelay(1);
+
+			/* Add delay for ECS T20 & LG malow platform, */
+			udelay(1);
+
+			rtl92s_phy_set_bb_reg(hw, phy_reg_table[i], MASKDWORD,
+					phy_reg_table[i + 1]);
+		}
+	} else if (configtype == BASEBAND_CONFIG_AGC_TAB) {
+		for (i = 0; i < agc_len; i = i + 2) {
+			rtl92s_phy_set_bb_reg(hw, agc_table[i], MASKDWORD,
+					agc_table[i + 1]);
+
+			/* Add delay for ECS T20 & LG malow platform */
+			udelay(1);
+		}
+	}
+#endif
+
+	return true;
+}
+
+static bool _rtl92s_phy_set_bb_to_diff_rf(struct ieee80211_hw *hw,
+					  u8 configtype)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u32 *phy_regarray2xtxr_table;
+	u16 phy_regarray2xtxr_len;
+	int i;
+
+	// XXX
+	return true;
+
+	if (rtlphy->rf_type == RF_1T1R) {
+		phy_regarray2xtxr_table = rtl8192sephy_changeto_1t1rarray;
+		phy_regarray2xtxr_len = PHY_CHANGETO_1T1RARRAYLENGTH;
+	} else if (rtlphy->rf_type == RF_1T2R) {
+		phy_regarray2xtxr_table = rtl8192sephy_changeto_1t2rarray;
+		phy_regarray2xtxr_len = PHY_CHANGETO_1T2RARRAYLENGTH;
+	} else {
+		return false;
+	}
+
+	if (configtype == BASEBAND_CONFIG_PHY_REG) {
+		for (i = 0; i < phy_regarray2xtxr_len; i = i + 3) {
+			if (phy_regarray2xtxr_table[i] == 0xfe)
+				mdelay(50);
+			else if (phy_regarray2xtxr_table[i] == 0xfd)
+				mdelay(5);
+			else if (phy_regarray2xtxr_table[i] == 0xfc)
+				mdelay(1);
+			else if (phy_regarray2xtxr_table[i] == 0xfb)
+				udelay(50);
+			else if (phy_regarray2xtxr_table[i] == 0xfa)
+				udelay(5);
+			else if (phy_regarray2xtxr_table[i] == 0xf9)
+				udelay(1);
+
+			rtl92s_phy_set_bb_reg(hw, phy_regarray2xtxr_table[i],
+				phy_regarray2xtxr_table[i + 1],
+				phy_regarray2xtxr_table[i + 2]);
+		}
+	}
+
+	return true;
+}
+
+static bool _rtl92s_phy_config_bb_with_pg(struct ieee80211_hw *hw,
+					  u8 configtype)
+{
+	int i;
+	u32 *phy_table_pg;
+	u16 phy_pg_len;
+
+	// XXX
+	return true;
+
+	phy_pg_len = PHY_REG_ARRAY_PGLENGTH;
+	phy_table_pg = rtl8192sephy_reg_array_pg;
+
+	if (configtype == BASEBAND_CONFIG_PHY_REG) {
+		for (i = 0; i < phy_pg_len; i = i + 3) {
+			if (phy_table_pg[i] == 0xfe)
+				mdelay(50);
+			else if (phy_table_pg[i] == 0xfd)
+				mdelay(5);
+			else if (phy_table_pg[i] == 0xfc)
+				mdelay(1);
+			else if (phy_table_pg[i] == 0xfb)
+				udelay(50);
+			else if (phy_table_pg[i] == 0xfa)
+				udelay(5);
+			else if (phy_table_pg[i] == 0xf9)
+				udelay(1);
+
+			_rtl92s_store_pwrindex_diffrate_offset(hw,
+					phy_table_pg[i],
+					phy_table_pg[i + 1],
+					phy_table_pg[i + 2]);
+			rtl92s_phy_set_bb_reg(hw, phy_table_pg[i],
+					phy_table_pg[i + 1],
+					phy_table_pg[i + 2]);
+		}
+	}
+
+	return true;
+}
+
+static bool _rtl92s_phy_bb_config_parafile(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	bool rtstatus = true;
+
+	// XXX
+	return true;
+
+	/* 1. Read PHY_REG.TXT BB INIT!! */
+	/* We will separate as 1T1R/1T2R/1T2R_GREEN/2T2R */
+	if (rtlphy->rf_type == RF_1T2R || rtlphy->rf_type == RF_2T2R ||
+	    rtlphy->rf_type == RF_1T1R || rtlphy->rf_type == RF_2T2R_GREEN) {
+		rtstatus = _rtl92s_phy_config_bb(hw, BASEBAND_CONFIG_PHY_REG);
+
+		if (rtlphy->rf_type != RF_2T2R &&
+		    rtlphy->rf_type != RF_2T2R_GREEN)
+			/* so we should reconfig BB reg with the right
+			 * PHY parameters. */
+			rtstatus = _rtl92s_phy_set_bb_to_diff_rf(hw,
+						BASEBAND_CONFIG_PHY_REG);
+	} else {
+		rtstatus = false;
+	}
+
+	if (!rtstatus) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+			 "Write BB Reg Fail!!\n");
+		goto phy_BB8190_Config_ParaFile_Fail;
+	}
+
+	/* 2. If EEPROM or EFUSE autoload OK, We must config by
+	 *    PHY_REG_PG.txt */
+	if (rtlefuse->autoload_failflag == false) {
+		rtlphy->pwrgroup_cnt = 0;
+
+		rtstatus = _rtl92s_phy_config_bb_with_pg(hw,
+						 BASEBAND_CONFIG_PHY_REG);
+	}
+	if (!rtstatus) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+			 "_rtl92s_phy_bb_config_parafile(): BB_PG Reg Fail!!\n");
+		goto phy_BB8190_Config_ParaFile_Fail;
+	}
+
+	/* 3. BB AGC table Initialization */
+	rtstatus = _rtl92s_phy_config_bb(hw, BASEBAND_CONFIG_AGC_TAB);
+
+	if (!rtstatus) {
+		pr_err("%s(): AGC Table Fail\n", __func__);
+		goto phy_BB8190_Config_ParaFile_Fail;
+	}
+
+	/* Check if the CCK HighPower is turned ON. */
+	/* This is used to calculate PWDB. */
+	rtlphy->cck_high_power = (bool)(rtl92s_phy_query_bb_reg(hw,
+			RFPGA0_XA_HSSIPARAMETER2, 0x200));
+
+phy_BB8190_Config_ParaFile_Fail:
+	return rtstatus;
+}
+
+u8 rtl92s_phy_config_rf(struct ieee80211_hw *hw, enum radio_path rfpath)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	int i;
+	bool rtstatus = true;
+	u32 *radio_a_table;
+	u32 *radio_b_table;
+	u16 radio_a_tblen, radio_b_tblen;
+
+	// XXX
+	return true;
+
+	radio_a_tblen = RADIOA_1T_ARRAYLENGTH;
+	radio_a_table = rtl8192seradioa_1t_array;
+
+	/* Using Green mode array table for RF_2T2R_GREEN */
+	if (rtlphy->rf_type == RF_2T2R_GREEN) {
+		radio_b_table = rtl8192seradiob_gm_array;
+		radio_b_tblen = RADIOB_GM_ARRAYLENGTH;
+	} else {
+		radio_b_table = rtl8192seradiob_array;
+		radio_b_tblen = RADIOB_ARRAYLENGTH;
+	}
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
+	rtstatus = true;
+
+	switch (rfpath) {
+	case RF90_PATH_A:
+		for (i = 0; i < radio_a_tblen; i = i + 2) {
+			if (radio_a_table[i] == 0xfe)
+				/* Delay specific ms. Only RF configuration
+				 * requires delay. */
+				mdelay(50);
+			else if (radio_a_table[i] == 0xfd)
+				mdelay(5);
+			else if (radio_a_table[i] == 0xfc)
+				mdelay(1);
+			else if (radio_a_table[i] == 0xfb)
+				udelay(50);
+			else if (radio_a_table[i] == 0xfa)
+				udelay(5);
+			else if (radio_a_table[i] == 0xf9)
+				udelay(1);
+			else
+				rtl92s_phy_set_rf_reg(hw, rfpath,
+						      radio_a_table[i],
+						      MASK20BITS,
+						      radio_a_table[i + 1]);
+
+			/* Add delay for ECS T20 & LG malow platform */
+			udelay(1);
+		}
+
+		/* PA Bias current for inferiority IC */
+		_rtl92s_phy_config_rfpa_bias_current(hw, rfpath);
+		break;
+	case RF90_PATH_B:
+		for (i = 0; i < radio_b_tblen; i = i + 2) {
+			if (radio_b_table[i] == 0xfe)
+				/* Delay specific ms. Only RF configuration
+				 * requires delay.*/
+				mdelay(50);
+			else if (radio_b_table[i] == 0xfd)
+				mdelay(5);
+			else if (radio_b_table[i] == 0xfc)
+				mdelay(1);
+			else if (radio_b_table[i] == 0xfb)
+				udelay(50);
+			else if (radio_b_table[i] == 0xfa)
+				udelay(5);
+			else if (radio_b_table[i] == 0xf9)
+				udelay(1);
+			else
+				rtl92s_phy_set_rf_reg(hw, rfpath,
+						      radio_b_table[i],
+						      MASK20BITS,
+						      radio_b_table[i + 1]);
+
+			/* Add delay for ECS T20 & LG malow platform */
+			udelay(1);
+		}
+		break;
+	case RF90_PATH_C:
+		;
+		break;
+	case RF90_PATH_D:
+		;
+		break;
+	default:
+		break;
+	}
+
+	return rtstatus;
+}
+
+
+bool rtl92s_phy_mac_config(struct ieee80211_hw *hw)
+{
+/*
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 i;
+	u32 arraylength;
+	u32 *ptraArray;
+
+	arraylength = MAC_2T_ARRAYLENGTH;
+	ptraArray = rtl8192semac_2t_array;
+
+	for (i = 0; i < arraylength; i = i + 2)
+		rtl_write_byte(rtlpriv, ptraArray[i], (u8)ptraArray[i + 1]);
+*/
+
+	return true;
+}
+
+
+bool rtl92s_phy_bb_config(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	bool rtstatus = true;
+	u8 pathmap, index, rf_num = 0;
+	u8 path1, path2;
+
+	// XXX
+	return true;
+
+	_rtl92s_phy_init_register_definition(hw);
+
+	/* Config BB and AGC */
+	rtstatus = _rtl92s_phy_bb_config_parafile(hw);
+
+
+	/* Check BB/RF confiuration setting. */
+	/* We only need to configure RF which is turned on. */
+	path1 = (u8)(rtl92s_phy_query_bb_reg(hw, RFPGA0_TXINFO, 0xf));
+	mdelay(10);
+	path2 = (u8)(rtl92s_phy_query_bb_reg(hw, ROFDM0_TRXPATHENABLE, 0xf));
+	pathmap = path1 | path2;
+
+	rtlphy->rf_pathmap = pathmap;
+	for (index = 0; index < 4; index++) {
+		if ((pathmap >> index) & 0x1)
+			rf_num++;
+	}
+
+	if ((rtlphy->rf_type == RF_1T1R && rf_num != 1) ||
+	    (rtlphy->rf_type == RF_1T2R && rf_num != 2) ||
+	    (rtlphy->rf_type == RF_2T2R && rf_num != 2) ||
+	    (rtlphy->rf_type == RF_2T2R_GREEN && rf_num != 2)) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+			 "RF_Type(%x) does not match RF_Num(%x)!!\n",
+			 rtlphy->rf_type, rf_num);
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+			 "path1 0x%x, path2 0x%x, pathmap 0x%x\n",
+			 path1, path2, pathmap);
+	}
+
+	return rtstatus;
+}
+
+bool rtl92s_phy_rf_config(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+
+	/* Initialize general global value */
+	if (rtlphy->rf_type == RF_1T1R)
+		rtlphy->num_total_rfpath = 1;
+	else
+		rtlphy->num_total_rfpath = 2;
+
+	/* Config BB and RF */
+	return rtl92s_phy_rf6052_config(hw);
+}
+
+void rtl92s_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+
+	/* read rx initial gain */
+	rtlphy->default_initialgain[0] = rtl_get_bbreg(hw,
+			ROFDM0_XAAGCCORE1, MASKBYTE0);
+	rtlphy->default_initialgain[1] = rtl_get_bbreg(hw,
+			ROFDM0_XBAGCCORE1, MASKBYTE0);
+	rtlphy->default_initialgain[2] = rtl_get_bbreg(hw,
+			ROFDM0_XCAGCCORE1, MASKBYTE0);
+	rtlphy->default_initialgain[3] = rtl_get_bbreg(hw,
+			ROFDM0_XDAGCCORE1, MASKBYTE0);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "Default initial gain (c50=0x%x, c58=0x%x, c60=0x%x, c68=0x%x)\n",
+		 rtlphy->default_initialgain[0],
+		 rtlphy->default_initialgain[1],
+		 rtlphy->default_initialgain[2],
+		 rtlphy->default_initialgain[3]);
+
+	/* read framesync */
+	rtlphy->framesync = rtl_get_bbreg(hw, ROFDM0_RXDETECTOR3, MASKBYTE0);
+	rtlphy->framesync_c34 = rtl_get_bbreg(hw, ROFDM0_RXDETECTOR2,
+					      MASKDWORD);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "Default framesync (0x%x) = 0x%x\n",
+		 ROFDM0_RXDETECTOR3, rtlphy->framesync);
+
+}
+
+static void _rtl92s_phy_get_txpower_index(struct ieee80211_hw *hw, u8 channel,
+					  u8 *cckpowerlevel, u8 *ofdmpowerLevel)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u8 index = (channel - 1);
+
+	/* 1. CCK */
+	/* RF-A */
+	cckpowerlevel[0] = rtlefuse->txpwrlevel_cck[0][index];
+	/* RF-B */
+	cckpowerlevel[1] = rtlefuse->txpwrlevel_cck[1][index];
+
+	/* 2. OFDM for 1T or 2T */
+	if (rtlphy->rf_type == RF_1T2R || rtlphy->rf_type == RF_1T1R) {
+		/* Read HT 40 OFDM TX power */
+		ofdmpowerLevel[0] = rtlefuse->txpwrlevel_ht40_1s[0][index];
+		ofdmpowerLevel[1] = rtlefuse->txpwrlevel_ht40_1s[1][index];
+	} else if (rtlphy->rf_type == RF_2T2R) {
+		/* Read HT 40 OFDM TX power */
+		ofdmpowerLevel[0] = rtlefuse->txpwrlevel_ht40_2s[0][index];
+		ofdmpowerLevel[1] = rtlefuse->txpwrlevel_ht40_2s[1][index];
+	}
+}
+
+static void _rtl92s_phy_ccxpower_indexcheck(struct ieee80211_hw *hw,
+		u8 channel, u8 *cckpowerlevel, u8 *ofdmpowerlevel)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+
+	rtlphy->cur_cck_txpwridx = cckpowerlevel[0];
+	rtlphy->cur_ofdm24g_txpwridx = ofdmpowerlevel[0];
+}
+
+void rtl92s_phy_set_txpower(struct ieee80211_hw *hw, u8	channel)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	/* [0]:RF-A, [1]:RF-B */
+	u8 cckpowerlevel[2], ofdmpowerLevel[2];
+
+	// XXX
+	return;
+
+	if (!rtlefuse->txpwr_fromeprom)
+		return;
+
+	/* Mainly we use RF-A Tx Power to write the Tx Power registers,
+	 * but the RF-B Tx Power must be calculated by the antenna diff.
+	 * So we have to rewrite Antenna gain offset register here.
+	 * Please refer to BB register 0x80c
+	 * 1. For CCK.
+	 * 2. For OFDM 1T or 2T */
+	_rtl92s_phy_get_txpower_index(hw, channel, &cckpowerlevel[0],
+			&ofdmpowerLevel[0]);
+
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+		 "Channel-%d, cckPowerLevel (A / B) = 0x%x / 0x%x, ofdmPowerLevel (A / B) = 0x%x / 0x%x\n",
+		 channel, cckpowerlevel[0], cckpowerlevel[1],
+		 ofdmpowerLevel[0], ofdmpowerLevel[1]);
+
+	_rtl92s_phy_ccxpower_indexcheck(hw, channel, &cckpowerlevel[0],
+			&ofdmpowerLevel[0]);
+
+	rtl92s_phy_rf6052_set_ccktxpower(hw, cckpowerlevel[0]);
+	rtl92s_phy_rf6052_set_ofdmtxpower(hw, &ofdmpowerLevel[0], channel);
+
+}
+
+void rtl92s_phy_chk_fwcmd_iodone(struct ieee80211_hw *hw)
+{
+	// XXX
+	return;
+#if 0
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u16 pollingcnt = 10000;
+	u32 tmpvalue;
+
+	/* Make sure that CMD IO has be accepted by FW. */
+	do {
+		udelay(10);
+
+		tmpvalue = rtl_read_dword(rtlpriv, WFM5);
+		if (tmpvalue == 0)
+			break;
+	} while (--pollingcnt);
+
+	if (pollingcnt == 0)
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Set FW Cmd fail!!\n");
+#endif
+}
+
+#if 0
+static void _rtl92s_phy_set_fwcmd_io(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u32 input, current_aid = 0;
+
+	if (is_hal_stop(rtlhal))
+		return;
+
+	/* We re-map RA related CMD IO to combinational ones */
+	/* if FW version is v.52 or later. */
+	switch (rtlhal->current_fwcmd_io) {
+	case FW_CMD_RA_REFRESH_N:
+		rtlhal->current_fwcmd_io = FW_CMD_RA_REFRESH_N_COMB;
+		break;
+	case FW_CMD_RA_REFRESH_BG:
+		rtlhal->current_fwcmd_io = FW_CMD_RA_REFRESH_BG_COMB;
+		break;
+	default:
+		break;
+	}
+
+	switch (rtlhal->current_fwcmd_io) {
+	case FW_CMD_RA_RESET:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG, "FW_CMD_RA_RESET\n");
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_RESET);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_RA_ACTIVE:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG, "FW_CMD_RA_ACTIVE\n");
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_ACTIVE);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_RA_REFRESH_N:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG, "FW_CMD_RA_REFRESH_N\n");
+		input = FW_RA_REFRESH;
+		rtl_write_dword(rtlpriv, WFM5, input);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_ENABLE_RSSI_MASK);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_RA_REFRESH_BG:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG,
+			 "FW_CMD_RA_REFRESH_BG\n");
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_REFRESH);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_DISABLE_RSSI_MASK);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_RA_REFRESH_N_COMB:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG,
+			 "FW_CMD_RA_REFRESH_N_COMB\n");
+		input = FW_RA_IOT_N_COMB;
+		rtl_write_dword(rtlpriv, WFM5, input);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_RA_REFRESH_BG_COMB:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG,
+			 "FW_CMD_RA_REFRESH_BG_COMB\n");
+		input = FW_RA_IOT_BG_COMB;
+		rtl_write_dword(rtlpriv, WFM5, input);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_IQK_ENABLE:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG, "FW_CMD_IQK_ENABLE\n");
+		rtl_write_dword(rtlpriv, WFM5, FW_IQK_ENABLE);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_PAUSE_DM_BY_SCAN:
+		/* Lower initial gain */
+		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, MASKBYTE0, 0x17);
+		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, MASKBYTE0, 0x17);
+		/* CCA threshold */
+		rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2, 0x40);
+		break;
+	case FW_CMD_RESUME_DM_BY_SCAN:
+		/* CCA threshold */
+		rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2, 0xcd);
+		rtl92s_phy_set_txpower(hw, rtlphy->current_channel);
+		break;
+	case FW_CMD_HIGH_PWR_DISABLE:
+		if (rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE)
+			break;
+
+		/* Lower initial gain */
+		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, MASKBYTE0, 0x17);
+		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, MASKBYTE0, 0x17);
+		/* CCA threshold */
+		rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2, 0x40);
+		break;
+	case FW_CMD_HIGH_PWR_ENABLE:
+		if ((rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) ||
+			rtlpriv->dm.dynamic_txpower_enable)
+			break;
+
+		/* CCA threshold */
+		rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2, 0xcd);
+		break;
+	case FW_CMD_LPS_ENTER:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG, "FW_CMD_LPS_ENTER\n");
+		current_aid = rtlpriv->mac80211.assoc_id;
+		rtl_write_dword(rtlpriv, WFM5, (FW_LPS_ENTER |
+				((current_aid | 0xc000) << 8)));
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		/* FW set TXOP disable here, so disable EDCA
+		 * turbo mode until driver leave LPS */
+		break;
+	case FW_CMD_LPS_LEAVE:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG, "FW_CMD_LPS_LEAVE\n");
+		rtl_write_dword(rtlpriv, WFM5, FW_LPS_LEAVE);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_ADD_A2_ENTRY:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_DMESG, "FW_CMD_ADD_A2_ENTRY\n");
+		rtl_write_dword(rtlpriv, WFM5, FW_ADD_A2_ENTRY);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+	case FW_CMD_CTRL_DM_BY_DRIVER:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 "FW_CMD_CTRL_DM_BY_DRIVER\n");
+		rtl_write_dword(rtlpriv, WFM5, FW_CTRL_DM_BY_DRIVER);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		break;
+
+	default:
+		break;
+	}
+
+	rtl92s_phy_chk_fwcmd_iodone(hw);
+
+	/* Clear FW CMD operation flag. */
+	rtlhal->set_fwcmd_inprogress = false;
+}
+#endif
+
+bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fw_cmdio)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u32	fw_param = FW_CMD_IO_PARA_QUERY(rtlpriv);
+	u16	fw_cmdmap = FW_CMD_IO_QUERY(rtlpriv);
+	bool bPostProcessing = false;
+
+	RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+		 "Set FW Cmd(%#x), set_fwcmd_inprogress(%d)\n",
+		 fw_cmdio, rtlhal->set_fwcmd_inprogress);
+
+	// XXX
+	return true;
+
+	do {
+		/* We re-map to combined FW CMD ones if firmware version */
+		/* is v.53 or later. */
+		switch (fw_cmdio) {
+		case FW_CMD_RA_REFRESH_N:
+			fw_cmdio = FW_CMD_RA_REFRESH_N_COMB;
+			break;
+		case FW_CMD_RA_REFRESH_BG:
+			fw_cmdio = FW_CMD_RA_REFRESH_BG_COMB;
+			break;
+		default:
+			break;
+		}
+
+		/* If firmware version is v.62 or later,
+		 * use FW_CMD_IO_SET for FW_CMD_CTRL_DM_BY_DRIVER */
+		if (hal_get_firmwareversion(rtlpriv) >= 0x3E) {
+			if (fw_cmdio == FW_CMD_CTRL_DM_BY_DRIVER)
+				fw_cmdio = FW_CMD_CTRL_DM_BY_DRIVER_NEW;
+		}
+
+
+		/* We shall revise all FW Cmd IO into Reg0x364
+		 * DM map table in the future. */
+		switch (fw_cmdio) {
+		case FW_CMD_RA_INIT:
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, "RA init!!\n");
+			fw_cmdmap |= FW_RA_INIT_CTL;
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			/* Clear control flag to sync with FW. */
+			FW_CMD_IO_CLR(rtlpriv, FW_RA_INIT_CTL);
+			break;
+		case FW_CMD_DIG_DISABLE:
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 "Set DIG disable!!\n");
+			fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			break;
+		case FW_CMD_DIG_ENABLE:
+		case FW_CMD_DIG_RESUME:
+			if (!(rtlpriv->dm.dm_flag & HAL_DM_DIG_DISABLE)) {
+				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+					 "Set DIG enable or resume!!\n");
+				fw_cmdmap |= (FW_DIG_ENABLE_CTL | FW_SS_CTL);
+				FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			}
+			break;
+		case FW_CMD_DIG_HALT:
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 "Set DIG halt!!\n");
+			fw_cmdmap &= ~(FW_DIG_ENABLE_CTL | FW_SS_CTL);
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			break;
+		case FW_CMD_TXPWR_TRACK_THERMAL: {
+			u8	thermalval = 0;
+			fw_cmdmap |= FW_PWR_TRK_CTL;
+
+			/* Clear FW parameter in terms of thermal parts. */
+			fw_param &= FW_PWR_TRK_PARAM_CLR;
+
+			thermalval = rtlpriv->dm.thermalvalue;
+			fw_param |= ((thermalval << 24) |
+				     (rtlefuse->thermalmeter[0] << 16));
+
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 "Set TxPwr tracking!! FwCmdMap(%#x), FwParam(%#x)\n",
+				 fw_cmdmap, fw_param);
+
+			FW_CMD_PARA_SET(rtlpriv, fw_param);
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+
+			/* Clear control flag to sync with FW. */
+			FW_CMD_IO_CLR(rtlpriv, FW_PWR_TRK_CTL);
+			}
+			break;
+		/* The following FW CMDs are only compatible to
+		 * v.53 or later. */
+		case FW_CMD_RA_REFRESH_N_COMB:
+			fw_cmdmap |= FW_RA_N_CTL;
+
+			/* Clear RA BG mode control. */
+			fw_cmdmap &= ~(FW_RA_BG_CTL | FW_RA_INIT_CTL);
+
+			/* Clear FW parameter in terms of RA parts. */
+			fw_param &= FW_RA_PARAM_CLR;
+
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 "[FW CMD] [New Version] Set RA/IOT Comb in n mode!! FwCmdMap(%#x), FwParam(%#x)\n",
+				 fw_cmdmap, fw_param);
+
+			FW_CMD_PARA_SET(rtlpriv, fw_param);
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+
+			/* Clear control flag to sync with FW. */
+			FW_CMD_IO_CLR(rtlpriv, FW_RA_N_CTL);
+			break;
+		case FW_CMD_RA_REFRESH_BG_COMB:
+			fw_cmdmap |= FW_RA_BG_CTL;
+
+			/* Clear RA n-mode control. */
+			fw_cmdmap &= ~(FW_RA_N_CTL | FW_RA_INIT_CTL);
+			/* Clear FW parameter in terms of RA parts. */
+			fw_param &= FW_RA_PARAM_CLR;
+
+			FW_CMD_PARA_SET(rtlpriv, fw_param);
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+
+			/* Clear control flag to sync with FW. */
+			FW_CMD_IO_CLR(rtlpriv, FW_RA_BG_CTL);
+			break;
+		case FW_CMD_IQK_ENABLE:
+			fw_cmdmap |= FW_IQK_CTL;
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			/* Clear control flag to sync with FW. */
+			FW_CMD_IO_CLR(rtlpriv, FW_IQK_CTL);
+			break;
+		/* The following FW CMD is compatible to v.62 or later.  */
+		case FW_CMD_CTRL_DM_BY_DRIVER_NEW:
+			fw_cmdmap |= FW_DRIVER_CTRL_DM_CTL;
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			break;
+		/*  The followed FW Cmds needs post-processing later. */
+		case FW_CMD_RESUME_DM_BY_SCAN:
+			fw_cmdmap |= (FW_DIG_ENABLE_CTL |
+				      FW_HIGH_PWR_ENABLE_CTL |
+				      FW_SS_CTL);
+
+			if (rtlpriv->dm.dm_flag & HAL_DM_DIG_DISABLE ||
+				!digtable->dig_enable_flag)
+				fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
+
+			if ((rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) ||
+			    rtlpriv->dm.dynamic_txpower_enable)
+				fw_cmdmap &= ~FW_HIGH_PWR_ENABLE_CTL;
+
+			if ((digtable->dig_ext_port_stage ==
+			    DIG_EXT_PORT_STAGE_0) ||
+			    (digtable->dig_ext_port_stage ==
+			    DIG_EXT_PORT_STAGE_1))
+				fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
+
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			bPostProcessing = true;
+			break;
+		case FW_CMD_PAUSE_DM_BY_SCAN:
+			fw_cmdmap &= ~(FW_DIG_ENABLE_CTL |
+				       FW_HIGH_PWR_ENABLE_CTL |
+				       FW_SS_CTL);
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			bPostProcessing = true;
+			break;
+		case FW_CMD_HIGH_PWR_DISABLE:
+			fw_cmdmap &= ~FW_HIGH_PWR_ENABLE_CTL;
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			bPostProcessing = true;
+			break;
+		case FW_CMD_HIGH_PWR_ENABLE:
+			if (!(rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) &&
+			    !rtlpriv->dm.dynamic_txpower_enable) {
+				fw_cmdmap |= (FW_HIGH_PWR_ENABLE_CTL |
+					      FW_SS_CTL);
+				FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+				bPostProcessing = true;
+			}
+			break;
+		case FW_CMD_DIG_MODE_FA:
+			fw_cmdmap |= FW_FA_CTL;
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			break;
+		case FW_CMD_DIG_MODE_SS:
+			fw_cmdmap &= ~FW_FA_CTL;
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			break;
+		case FW_CMD_PAPE_CONTROL:
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 "[FW CMD] Set PAPE Control\n");
+			fw_cmdmap &= ~FW_PAPE_CTL_BY_SW_HW;
+
+			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+			break;
+		default:
+			/* Pass to original FW CMD processing callback
+			 * routine. */
+			bPostProcessing = true;
+			break;
+		}
+	} while (false);
+
+	/* We shall post processing these FW CMD if
+	 * variable bPostProcessing is set. */
+	if (bPostProcessing && !rtlhal->set_fwcmd_inprogress) {
+		rtlhal->set_fwcmd_inprogress = true;
+		/* Update current FW Cmd for callback use. */
+		rtlhal->current_fwcmd_io = fw_cmdio;
+	} else {
+		return false;
+	}
+
+	//_rtl92s_phy_set_fwcmd_io(hw);
+	return true;
+}
+
+static	void _rtl92s_phy_check_ephy_switchready(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32	delay = 100;
+	u8	regu1;
+
+	regu1 = rtl_read_byte(rtlpriv, 0x554);
+	while ((regu1 & BIT(5)) && (delay > 0)) {
+		regu1 = rtl_read_byte(rtlpriv, 0x554);
+		delay--;
+		/* We delay only 50us to prevent
+		 * being scheduled out. */
+		udelay(50);
+	}
+}
+
+void rtl92s_phy_switch_ephy_parameter(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	// XXX
+	return;
+
+	/* The way to be capable to switch clock request
+	 * when the PG setting does not support clock request.
+	 * This is the backdoor solution to switch clock
+	 * request before ASPM or D3. */
+	rtl_write_dword(rtlpriv, 0x540, 0x73c11);
+	rtl_write_dword(rtlpriv, 0x548, 0x2407c);
+
+	/* Switch EPHY parameter!!!! */
+	rtl_write_word(rtlpriv, 0x550, 0x1000);
+	rtl_write_byte(rtlpriv, 0x554, 0x20);
+	_rtl92s_phy_check_ephy_switchready(hw);
+
+	rtl_write_word(rtlpriv, 0x550, 0xa0eb);
+	rtl_write_byte(rtlpriv, 0x554, 0x3e);
+	_rtl92s_phy_check_ephy_switchready(hw);
+
+	rtl_write_word(rtlpriv, 0x550, 0xff80);
+	rtl_write_byte(rtlpriv, 0x554, 0x39);
+	_rtl92s_phy_check_ephy_switchready(hw);
+
+	/* Delay L1 enter time */
+	if (ppsc->support_aspm && !ppsc->support_backdoor)
+		rtl_write_byte(rtlpriv, 0x560, 0x40);
+	else
+		rtl_write_byte(rtlpriv, 0x560, 0x00);
+
+}
+
+void rtl92s_phy_set_beacon_hwreg(struct ieee80211_hw *hw, u16 BeaconInterval)
+{
+/*
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	rtl_write_dword(rtlpriv, WFM5, 0xF1000000 | (BeaconInterval << 8));
+*/
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/phy.h b/drivers/net/wireless/rtlwifi/rtl8192su/phy.h
new file mode 100644
index 0000000..02a9ecf
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/phy.h
@@ -0,0 +1,100 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __RTL92S_PHY_H__
+#define __RTL92S_PHY_H__
+
+#define MAX_TXPWR_IDX_NMODE_92S		63
+#define MAX_DOZE_WAITING_TIMES_9x	64
+
+/* Channel switch:The size of
+ * command tables for switch channel */
+#define MAX_PRECMD_CNT			16
+#define MAX_RFDEPENDCMD_CNT		16
+#define MAX_POSTCMD_CNT			16
+
+#define RF90_PATH_MAX			4
+
+enum version_8192s {
+	VERSION_8192S_ACUT,
+	VERSION_8192S_BCUT,
+	VERSION_8192S_CCUT
+};
+
+enum swchnlcmd_id {
+	CMDID_END,
+	CMDID_SET_TXPOWEROWER_LEVEL,
+	CMDID_BBREGWRITE10,
+	CMDID_WRITEPORT_ULONG,
+	CMDID_WRITEPORT_USHORT,
+	CMDID_WRITEPORT_UCHAR,
+	CMDID_RF_WRITEREG,
+};
+
+struct swchnlcmd {
+	enum swchnlcmd_id cmdid;
+	u32 para1;
+	u32 para2;
+	u32 msdelay;
+};
+
+enum baseband_config_type {
+	/* Radio Path A */
+	BASEBAND_CONFIG_PHY_REG = 0,
+	/* Radio Path B */
+	BASEBAND_CONFIG_AGC_TAB = 1,
+};
+
+#define hal_get_firmwareversion(rtlpriv) \
+	(((struct rt_firmware *)(rtlpriv->rtlhal.pfirmware))->firmwareversion)
+
+u32 rtl92s_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
+void rtl92s_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
+			   u32 data);
+void rtl92s_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
+u32 rtl92s_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
+			    u32 regaddr, u32 bitmask);
+void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw,	enum radio_path rfpath,
+			   u32 regaddr, u32 bitmask, u32 data);
+void rtl92s_phy_set_bw_mode(struct ieee80211_hw *hw,
+			    enum nl80211_channel_type ch_type);
+u8 rtl92s_phy_sw_chnl(struct ieee80211_hw *hw);
+bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
+				   enum rf_pwrstate rfpower_state);
+bool rtl92s_phy_mac_config(struct ieee80211_hw *hw);
+void rtl92s_phy_switch_ephy_parameter(struct ieee80211_hw *hw);
+bool rtl92s_phy_bb_config(struct ieee80211_hw *hw);
+bool rtl92s_phy_rf_config(struct ieee80211_hw *hw);
+void rtl92s_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
+void rtl92s_phy_set_txpower(struct ieee80211_hw *hw, u8	channel);
+bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fwcmd_io);
+void rtl92s_phy_chk_fwcmd_iodone(struct ieee80211_hw *hw);
+void rtl92s_phy_set_beacon_hwreg(struct ieee80211_hw *hw, u16 beaconinterval);
+u8 rtl92s_phy_config_rf(struct ieee80211_hw *hw, enum radio_path rfpath) ;
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/reg.h b/drivers/net/wireless/rtlwifi/rtl8192su/reg.h
new file mode 100644
index 0000000..c29c0b2
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/reg.h
@@ -0,0 +1,1232 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_92S_REG_H__
+#define __REALTEK_92S_REG_H__
+
+/* 1. System Configuration Registers  */
+#define	REG_SYS_ISO_CTRL			0x0000
+#define	REG_SYS_FUNC_EN				0x0002
+#define	PMC_FSM					0x0004
+#define	SYS_CLKR				0x0008
+#define	EPROM_CMD				0x000A
+#define	EE_VPD					0x000C
+#define	AFE_MISC				0x0010
+#define	SPS0_CTRL				0x0011
+#define	SPS1_CTRL				0x0018
+#define	RF_CTRL					0x001F
+#define	LDOA15_CTRL				0x0020
+#define	LDOV12D_CTRL				0x0021
+#define	LDOHCI12_CTRL				0x0022
+#define	LDO_USB_SDIO				0x0023
+#define	LPLDO_CTRL				0x0024
+#define	AFE_XTAL_CTRL				0x0026
+#define	AFE_PLL_CTRL				0x0028
+#define	REG_EFUSE_CTRL				0x0030
+#define	REG_EFUSE_TEST				0x0034
+#define	PWR_DATA				0x0038
+#define	DBG_PORT				0x003A
+#define	DPS_TIMER				0x003C
+#define	RCLK_MON				0x003E
+
+/* 2. Command Control Registers	  */
+#define	CMDR					0x0040
+#define	TXPAUSE					0x0042
+#define	LBKMD_SEL				0x0043
+#define	TCR					0x0044
+#define	RCR					0x0048
+#define	MSR					0x004C
+#define	SYSF_CFG				0x004D
+#define	RX_PKY_LIMIT				0x004E
+#define	MBIDCTRL				0x004F
+
+/* 3. MACID Setting Registers	 */
+#define	MACIDR					0x0050
+#define	MACIDR0					0x0050
+#define	MACIDR4					0x0054
+#define	BSSIDR					0x0058
+#define	HWVID					0x005E
+#define	MAR					0x0060
+#define	MBIDCAMCONTENT				0x0068
+#define	MBIDCAMCFG				0x0070
+#define	BUILDTIME				0x0074
+#define	BUILDUSER				0x0078
+
+#define	IDR0					MACIDR0
+#define	IDR4					MACIDR4
+
+/* 4. Timing Control Registers	 */
+#define	TSFR					0x0080
+#define	SLOT_TIME				0x0089
+#define	USTIME					0x008A
+#define	SIFS_CCK				0x008C
+#define	SIFS_OFDM				0x008E
+#define	PIFS_TIME				0x0090
+#define	ACK_TIMEOUT				0x0091
+#define	EIFSTR					0x0092
+#define	BCN_INTERVAL				0x0094
+#define	ATIMWND					0x0096
+#define	BCN_DRV_EARLY_INT			0x0098
+#define	BCN_DMATIME				0x009A
+#define	BCN_ERR_THRESH				0x009C
+#define	MLT					0x009D
+#define	RSVD_MAC_TUNE_US			0x009E
+
+/* 5. FIFO Control Registers	  */
+#define RQPN					0x00A0
+#define	RQPN1					0x00A0
+#define	RQPN2					0x00A1
+#define	RQPN3					0x00A2
+#define	RQPN4					0x00A3
+#define	RQPN5					0x00A4
+#define	RQPN6					0x00A5
+#define	RQPN7					0x00A6
+#define	RQPN8					0x00A7
+#define	RQPN9					0x00A8
+#define	RQPN10					0x00A9
+#define	LD_RQPN					0x00AB
+#define	RXFF_BNDY				0x00AC
+#define	RXRPT_BNDY				0x00B0
+#define	TXPKTBUF_PGBNDY				0x00B4
+#define	PBP					0x00B5
+#define	RXDRVINFO_SZ				0x00B6
+#define	TXFF_STATUS				0x00B7
+#define	RXFF_STATUS				0x00B8
+#define	TXFF_EMPTY_TH				0x00B9
+#define	SDIO_RX_BLKSZ				0x00BC
+#define	RXDMA					0x00BD
+#define	RXPKT_NUM				0x00BE
+#define	C2HCMD_UDT_SIZE				0x00C0
+#define	C2HCMD_UDT_ADDR				0x00C2
+#define	FIFOPAGE1				0x00C4
+#define	FIFOPAGE2				0x00C8
+#define	FIFOPAGE3				0x00CC
+#define	FIFOPAGE4				0x00D0
+#define	FIFOPAGE5				0x00D4
+#define	FW_RSVD_PG_CRTL				0x00D8
+#define	RXDMA_AGG_PG_TH				0x00D9
+#define	TXDESC_MSK				0x00DC
+#define	TXRPTFF_RDPTR				0x00E0
+#define	TXRPTFF_WTPTR				0x00E4
+#define	C2HFF_RDPTR				0x00E8
+#define	C2HFF_WTPTR				0x00EC
+#define	RXFF0_RDPTR				0x00F0
+#define	RXFF0_WTPTR				0x00F4
+#define	RXFF1_RDPTR				0x00F8
+#define	RXFF1_WTPTR				0x00FC
+#define	RXRPT0_RDPTR				0x0100
+#define	RXRPT0_WTPTR				0x0104
+#define	RXRPT1_RDPTR				0x0108
+#define	RXRPT1_WTPTR				0x010C
+#define	RX0_UDT_SIZE				0x0110
+#define	RX1PKTNUM				0x0114
+#define	RXFILTERMAP				0x0116
+#define	RXFILTERMAP_GP1				0x0118
+#define	RXFILTERMAP_GP2				0x011A
+#define	RXFILTERMAP_GP3				0x011C
+#define	BCNQ_CTRL				0x0120
+#define	MGTQ_CTRL				0x0124
+#define	HIQ_CTRL				0x0128
+#define	VOTID7_CTRL				0x012c
+#define	VOTID6_CTRL				0x0130
+#define	VITID5_CTRL				0x0134
+#define	VITID4_CTRL				0x0138
+#define	BETID3_CTRL				0x013c
+#define	BETID0_CTRL				0x0140
+#define	BKTID2_CTRL				0x0144
+#define	BKTID1_CTRL				0x0148
+#define	CMDQ_CTRL				0x014c
+#define	TXPKT_NUM_CTRL				0x0150
+#define	TXQ_PGADD				0x0152
+#define	TXFF_PG_NUM				0x0154
+#define	TRXDMA_STATUS				0x0156
+
+/* 6. Adaptive Control Registers   */
+#define	INIMCS_SEL				0x0160
+#define	TX_RATE_REG				INIMCS_SEL
+#define	INIRTSMCS_SEL				0x0180
+#define	RRSR					0x0181
+#define	ARFR0					0x0184
+#define	ARFR1					0x0188
+#define	ARFR2					0x018C
+#define	ARFR3					0x0190
+#define	ARFR4					0x0194
+#define	ARFR5					0x0198
+#define	ARFR6					0x019C
+#define	ARFR7					0x01A0
+#define	AGGLEN_LMT_H				0x01A7
+#define	AGGLEN_LMT_L				0x01A8
+#define	DARFRC					0x01B0
+#define	RARFRC					0x01B8
+#define	MCS_TXAGC				0x01C0
+#define	CCK_TXAGC				0x01C8
+
+/* 7. EDCA Setting Registers */
+#define	EDCAPARA_VO				0x01D0
+#define	EDCAPARA_VI				0x01D4
+#define	EDCAPARA_BE				0x01D8
+#define	EDCAPARA_BK				0x01DC
+#define	BCNTCFG					0x01E0
+#define	CWRR					0x01E2
+#define	ACMAVG					0x01E4
+#define	AcmHwCtrl				0x01E7
+#define	VO_ADMTM				0x01E8
+#define	VI_ADMTM				0x01EC
+#define	BE_ADMTM				0x01F0
+#define	RETRY_LIMIT				0x01F4
+#define	SG_RATE					0x01F6
+
+/* 8. WMAC, BA and CCX related Register. */
+#define	NAV_CTRL				0x0200
+#define	BW_OPMODE				0x0203
+#define	BACAMCMD				0x0204
+#define	BACAMCONTENT				0x0208
+
+/* the 0x2xx register WMAC definition */
+#define	LBDLY					0x0210
+#define	FWDLY					0x0211
+#define	HWPC_RX_CTRL				0x0218
+#define	MQIR					0x0220
+#define	MAIR					0x0222
+#define	MSIR					0x0224
+#define	CLM_RESULT				0x0227
+#define	NHM_RPI_CNT				0x0228
+#define	RXERR_RPT				0x0230
+#define	NAV_PROT_LEN				0x0234
+#define	CFEND_TH				0x0236
+#define	AMPDU_MIN_SPACE				0x0237
+#define	TXOP_STALL_CTRL				0x0238
+
+/* 9. Security Control Registers */
+#define	REG_RWCAM				0x0240
+#define	REG_WCAMI				0x0244
+#define	REG_RCAMO				0x0248
+#define	REG_CAMDBG				0x024C
+#define	REG_SECR				0x0250
+
+/* 10. Power Save Control Registers */
+#define	WOW_CTRL				0x0260
+#define	PSSTATUS				0x0261
+#define	PSSWITCH				0x0262
+#define	MIMOPS_WAIT_PERIOD			0x0263
+#define	LPNAV_CTRL				0x0264
+#define	WFM0					0x0270
+#define	WFM1					0x0280
+#define	WFM2					0x0290
+#define	WFM3					0x02A0
+#define	WFM4					0x02B0
+#define	WFM5					0x02C0
+#define	WFCRC					0x02D0
+#define	FW_RPT_REG				0x02c4
+
+/* 11. General Purpose Registers */
+#define	PSTIME					0x02E0
+#define	TIMER0					0x02E4
+#define	TIMER1					0x02E8
+#define	GPIO_IN_SE				0x02EC
+#define	GPIO_IO_SEL				0x02EE
+#define	MAC_PINMUX_CFG				0x02F1
+#define	LEDCFG					0x02F2
+#define	PHY_REG					0x02F3
+#define	PHY_REG_DATA				0x02F4
+#define	REG_EFUSE_CLK				0x02F8
+
+/* 12. Host Interrupt Status Registers */
+#define	INTA_MASK				0x0300
+#define	ISR					0x0308
+
+/* 13. Test Mode and Debug Control Registers */
+#define	DBG_PORT_SWITCH				0x003A
+#define	BIST					0x0310
+#define	DBS					0x0314
+#define	CPUINST					0x0318
+#define	CPUCAUSE				0x031C
+#define	LBUS_ERR_ADDR				0x0320
+#define	LBUS_ERR_CMD				0x0324
+#define	LBUS_ERR_DATA_L				0x0328
+#define	LBUS_ERR_DATA_H				0x032C
+#define	LX_EXCEPTION_ADDR			0x0330
+#define	WDG_CTRL				0x0334
+#define	INTMTU					0x0338
+#define	INTM					0x033A
+#define	FDLOCKTURN0				0x033C
+#define	FDLOCKTURN1				0x033D
+#define	TRXPKTBUF_DBG_DATA			0x0340
+#define	TRXPKTBUF_DBG_CTRL			0x0348
+#define	DPLL					0x034A
+#define	CBUS_ERR_ADDR				0x0350
+#define	CBUS_ERR_CMD				0x0354
+#define	CBUS_ERR_DATA_L				0x0358
+#define	CBUS_ERR_DATA_H				0x035C
+#define	USB_SIE_INTF_ADDR			0x0360
+#define	USB_SIE_INTF_WD				0x0361
+#define	USB_SIE_INTF_RD				0x0362
+#define	USB_SIE_INTF_CTRL			0x0363
+#define LBUS_MON_ADDR				0x0364
+#define LBUS_ADDR_MASK				0x0368
+#define IOCMD_CTRL				0x0370
+#define IOCMD_DATA				0x0374
+
+/* Boundary is 0x37F */
+
+/* 14. PCIE config register */
+#define	TP_POLL					0x0500
+#define	PM_CTRL					0x0502
+#define	PCIF					0x0503
+
+#define	THPDA					0x0514
+#define	TMDA					0x0518
+#define	TCDA					0x051C
+#define	HDA					0x0520
+#define	TVODA					0x0524
+#define	TVIDA					0x0528
+#define	TBEDA					0x052C
+#define	TBKDA					0x0530
+#define	TBDA					0x0534
+#define	RCDA					0x0538
+#define	RDQDA					0x053C
+#define	DBI_WDATA				0x0540
+#define	DBI_RDATA				0x0544
+#define	DBI_CTRL				0x0548
+#define	MDIO_DATA				0x0550
+#define	MDIO_CTRL				0x0554
+#define	PCI_RPWM				0x0561
+#define	PCI_CPWM				0x0563
+
+/* Config register	(Offset 0x800-) */
+#define	PHY_CCA					0x803
+
+/* USB Configuration */
+#define REG_USB_INFO				0xFE17
+#define REG_USB_SPECIAL_OPTION			0xFE55
+#define REG_USB_HCPWM				0xFE57
+#define REG_USB_HRPWM				0xFE58
+#define REG_USB_DMA_AGG_TO			0xFE5B
+#define REG_USB_AGG_TO				0xFE5C
+#define REG_USB_AGG_TH				0xFE5D
+
+#define REG_USB_VID				0xFE60
+#define REG_USB_PID				0xFE62
+#define REG_USB_OPTIONAL			0xFE64
+#define REG_USB_CHIRP_K				0xFE65 // REG_USB_EP
+#define REG_USB_PHY				0xFE66 // 0xFE68?
+#define REG_USB_MAC_ADDR			0xFE70
+#define REG_USB_STRING				0xFE80
+
+/* Min Spacing related settings. */
+#define	MAX_MSS_DENSITY_2T			0x13
+#define	MAX_MSS_DENSITY_1T			0x0A
+
+/* Rx DMA Control related settings */
+#define	RXDMA_AGG_EN				BIT(7)
+
+#define	RPWM					PCI_RPWM
+
+/* Regsiter Bit and Content definition  */
+
+#define	ISO_MD2PP				BIT(0)
+#define	ISO_PA2PCIE				BIT(3)
+#define	ISO_PLL2MD				BIT(4)
+#define	ISO_PWC_DV2RP				BIT(11)
+#define	ISO_PWC_RV2RP				BIT(12)
+
+
+#define	FEN_MREGEN				BIT(15)
+#define	FEN_DCORE				BIT(11)
+#define	FEN_CPUEN				BIT(10)
+
+#define	PAD_HWPD_IDN				BIT(22)
+
+#define	SYS_CLKSEL_80M				BIT(0)
+#define	SYS_PS_CLKSEL				BIT(1)
+#define	SYS_CPU_CLKSEL				BIT(2)
+#define	SYS_MAC_CLK_EN				BIT(11)
+#define	SYS_SWHW_SEL				BIT(14)
+#define	SYS_FWHW_SEL				BIT(15)
+
+#define	CmdEEPROM_En				BIT(5)
+#define	CmdEERPOMSEL				BIT(4)
+#define	Cmd9346CR_9356SEL			BIT(4)
+
+#define AFE_MISC_I32_EN				BIT(3)
+#define	AFE_MBEN				BIT(1)
+#define	AFE_BGEN				BIT(0)
+
+#define	SPS1_SWEN				BIT(1)
+#define	SPS1_LDEN				BIT(0)
+
+#define	RF_EN					BIT(0)
+#define	RF_RSTB					BIT(1)
+#define	RF_SDMRSTB				BIT(2)
+
+#define	LDA15_EN				BIT(0)
+
+#define	LDV12_EN				BIT(0)
+#define	LDV12_SDBY				BIT(1)
+
+#define	XTAL_GATE_AFE				BIT(10)
+
+#define	APLL_EN					BIT(0)
+
+#define	AFR_CardBEn				BIT(0)
+#define	AFR_CLKRUN_SEL				BIT(1)
+#define	AFR_FuncRegEn				BIT(2)
+
+#define	APSDOFF_STATUS				BIT(15)
+#define	APSDOFF					BIT(14)
+#define	BBRSTN					BIT(13)
+#define	BB_GLB_RSTN				BIT(12)
+#define	SCHEDULE_EN				BIT(10)
+#define	MACRXEN					BIT(9)
+#define	MACTXEN					BIT(8)
+#define	DDMA_EN					BIT(7)
+#define	FW2HW_EN				BIT(6)
+#define	RXDMA_EN				BIT(5)
+#define	TXDMA_EN				BIT(4)
+#define	HCI_RXDMA_EN				BIT(3)
+#define	HCI_TXDMA_EN				BIT(2)
+
+#define	StopHCCA				BIT(6)
+#define	StopHigh				BIT(5)
+#define	StopMgt					BIT(4)
+#define	StopVO					BIT(3)
+#define	StopVI					BIT(2)
+#define	StopBE					BIT(1)
+#define	StopBK					BIT(0)
+
+#define	LBK_NORMAL				0x00
+#define	LBK_MAC_LB				(BIT(0) | BIT(1) | BIT(3))
+#define	LBK_MAC_DLB				(BIT(0) | BIT(1))
+#define	LBK_DMA_LB				(BIT(0) | BIT(1) | BIT(2))
+
+#define	TCP_OFDL_EN				BIT(25)
+#define	HWPC_TX_EN				BIT(24)
+#define	TXDMAPRE2FULL				BIT(23)
+#define	DISCW					BIT(20)
+#define	TCRICV					BIT(19)
+#define	CfendForm				BIT(17)
+#define	TCRCRC					BIT(16)
+#define	FAKE_IMEM_EN				BIT(15)
+#define	TSFRST					BIT(9)
+#define	TSFEN					BIT(8)
+#define	FWALLRDY				(BIT(0) | BIT(1) | BIT(2) | \
+						BIT(3) | BIT(4) | BIT(5) | \
+						BIT(6) | BIT(7))
+#define	FWRDY					BIT(7)
+#define	BASECHG					BIT(6)
+#define	IMEM					BIT(5)
+#define	DMEM_CODE_DONE				BIT(4)
+#define	EXT_IMEM_CHK_RPT			BIT(3)
+#define	EXT_IMEM_CODE_DONE			BIT(2)
+#define	IMEM_CHK_RPT				BIT(1)
+#define	IMEM_CODE_DONE				BIT(0)
+#define	IMEM_CODE_DONE				BIT(0)
+#define	IMEM_CHK_RPT				BIT(1)
+#define	EMEM_CODE_DONE				BIT(2)
+#define	EMEM_CHK_RPT				BIT(3)
+#define	DMEM_CODE_DONE				BIT(4)
+#define	IMEM_RDY				BIT(5)
+#define	BASECHG					BIT(6)
+#define	FWRDY					BIT(7)
+#define	LOAD_FW_READY				(IMEM_CODE_DONE | \
+						IMEM_CHK_RPT | \
+						EMEM_CODE_DONE | \
+						EMEM_CHK_RPT | \
+						DMEM_CODE_DONE | \
+						IMEM_RDY | \
+						BASECHG | \
+						FWRDY)
+#define	TCR_TSFEN				BIT(8)
+#define	TCR_TSFRST				BIT(9)
+#define	TCR_FAKE_IMEM_EN			BIT(15)
+#define	TCR_CRC					BIT(16)
+#define	TCR_ICV					BIT(19)
+#define	TCR_DISCW				BIT(20)
+#define	TCR_HWPC_TX_EN				BIT(24)
+#define	TCR_TCP_OFDL_EN				BIT(25)
+#define	TXDMA_INIT_VALUE			(IMEM_CHK_RPT | \
+						EXT_IMEM_CHK_RPT)
+
+#define	RCR_APPFCS				BIT(31)
+#define	RCR_DIS_ENC_2BYTE			BIT(30)
+#define	RCR_DIS_AES_2BYTE			BIT(29)
+#define	RCR_HTC_LOC_CTRL			BIT(28)
+#define	RCR_ENMBID				BIT(27)
+#define	RCR_RX_TCPOFDL_EN			BIT(26)
+#define	RCR_APP_PHYST_RXFF			BIT(25)
+#define	RCR_APP_PHYST_STAFF			BIT(24)
+#define	RCR_CBSSID				BIT(23)
+#define	RCR_APWRMGT				BIT(22)
+#define	RCR_ADD3				BIT(21)
+#define	RCR_AMF					BIT(20)
+#define	RCR_ACF					BIT(19)
+#define	RCR_ADF					BIT(18)
+#define	RCR_APP_MIC				BIT(17)
+#define	RCR_APP_ICV				BIT(16)
+#define	RCR_RXFTH				BIT(13)
+#define	RCR_AICV				BIT(12)
+#define	RCR_RXDESC_LK_EN			BIT(11)
+#define	RCR_APP_BA_SSN				BIT(6)
+#define	RCR_ACRC32				BIT(5)
+#define	RCR_RXSHFT_EN				BIT(4)
+#define	RCR_AB					BIT(3)
+#define	RCR_AM					BIT(2)
+#define	RCR_APM					BIT(1)
+#define	RCR_AAP					BIT(0)
+#define	RCR_MXDMA_OFFSET			8
+#define	RCR_FIFO_OFFSET				13
+
+
+#define MSR_LINK_MASK				((1 << 0) | (1 << 1))
+#define MSR_LINK_MANAGED			2
+#define MSR_LINK_NONE				0
+#define MSR_LINK_SHIFT				0
+#define MSR_LINK_ADHOC				1
+#define MSR_LINK_MASTER				3
+#define	MSR_NOLINK				0x00
+#define	MSR_ADHOC				0x01
+#define	MSR_INFRA				0x02
+#define	MSR_AP					0x03
+
+#define	ENUART					BIT(7)
+#define	ENJTAG					BIT(3)
+#define	BTMODE					(BIT(2) | BIT(1))
+#define	ENBT					BIT(0)
+
+#define	ENMBID					BIT(7)
+#define	BCNUM					(BIT(6) | BIT(5) | BIT(4))
+
+#define	USTIME_EDCA				0xFF00
+#define	USTIME_TSF				0x00FF
+
+#define	SIFS_TRX				0xFF00
+#define	SIFS_CTX				0x00FF
+
+#define	ENSWBCN					BIT(15)
+#define	DRVERLY_TU				0x0FF0
+#define	DRVERLY_US				0x000F
+#define	BCN_TCFG_CW_SHIFT			8
+#define	BCN_TCFG_IFS				0
+
+#define	RRSR_RSC_OFFSET				21
+#define	RRSR_SHORT_OFFSET			23
+#define	RRSR_RSC_BW_40M				0x600000
+#define	RRSR_RSC_UPSUBCHNL			0x400000
+#define	RRSR_RSC_LOWSUBCHNL			0x200000
+#define	RRSR_SHORT				0x800000
+#define	RRSR_1M					BIT(0)
+#define	RRSR_2M					BIT(1)
+#define	RRSR_5_5M				BIT(2)
+#define	RRSR_11M				BIT(3)
+#define	RRSR_6M					BIT(4)
+#define	RRSR_9M					BIT(5)
+#define	RRSR_12M				BIT(6)
+#define	RRSR_18M				BIT(7)
+#define	RRSR_24M				BIT(8)
+#define	RRSR_36M				BIT(9)
+#define	RRSR_48M				BIT(10)
+#define	RRSR_54M				BIT(11)
+#define	RRSR_MCS0				BIT(12)
+#define	RRSR_MCS1				BIT(13)
+#define	RRSR_MCS2				BIT(14)
+#define	RRSR_MCS3				BIT(15)
+#define	RRSR_MCS4				BIT(16)
+#define	RRSR_MCS5				BIT(17)
+#define	RRSR_MCS6				BIT(18)
+#define	RRSR_MCS7				BIT(19)
+#define	BRSR_AckShortPmb			BIT(23)
+
+#define	RATR_1M					0x00000001
+#define	RATR_2M					0x00000002
+#define	RATR_55M				0x00000004
+#define	RATR_11M				0x00000008
+#define	RATR_6M					0x00000010
+#define	RATR_9M					0x00000020
+#define	RATR_12M				0x00000040
+#define	RATR_18M				0x00000080
+#define	RATR_24M				0x00000100
+#define	RATR_36M				0x00000200
+#define	RATR_48M				0x00000400
+#define	RATR_54M				0x00000800
+#define	RATR_MCS0				0x00001000
+#define	RATR_MCS1				0x00002000
+#define	RATR_MCS2				0x00004000
+#define	RATR_MCS3				0x00008000
+#define	RATR_MCS4				0x00010000
+#define	RATR_MCS5				0x00020000
+#define	RATR_MCS6				0x00040000
+#define	RATR_MCS7				0x00080000
+#define	RATR_MCS8				0x00100000
+#define	RATR_MCS9				0x00200000
+#define	RATR_MCS10				0x00400000
+#define	RATR_MCS11				0x00800000
+#define	RATR_MCS12				0x01000000
+#define	RATR_MCS13				0x02000000
+#define	RATR_MCS14				0x04000000
+#define	RATR_MCS15				0x08000000
+
+#define	RATE_ALL_CCK				(RATR_1M | RATR_2M | \
+						RATR_55M | RATR_11M)
+#define	RATE_ALL_OFDM_AG			(RATR_6M | RATR_9M | \
+						RATR_12M | RATR_18M | \
+						RATR_24M | RATR_36M | \
+						RATR_48M | RATR_54M)
+#define	RATE_ALL_OFDM_1SS			(RATR_MCS0 | RATR_MCS1 | \
+						RATR_MCS2 | RATR_MCS3 | \
+						RATR_MCS4 | RATR_MCS5 | \
+						RATR_MCS6 | RATR_MCS7)
+#define	RATE_ALL_OFDM_2SS			(RATR_MCS8 | RATR_MCS9 | \
+						RATR_MCS10 | RATR_MCS11 | \
+						RATR_MCS12 | RATR_MCS13 | \
+						RATR_MCS14 | RATR_MCS15)
+
+#define	AC_PARAM_TXOP_LIMIT_OFFSET		16
+#define	AC_PARAM_ECW_MAX_OFFSET			12
+#define	AC_PARAM_ECW_MIN_OFFSET			8
+#define	AC_PARAM_AIFS_OFFSET			0
+
+#define	AcmHw_HwEn				BIT(0)
+#define	AcmHw_BeqEn				BIT(1)
+#define	AcmHw_ViqEn				BIT(2)
+#define	AcmHw_VoqEn				BIT(3)
+#define	AcmHw_BeqStatus				BIT(4)
+#define	AcmHw_ViqStatus				BIT(5)
+#define	AcmHw_VoqStatus				BIT(6)
+
+#define	RETRY_LIMIT_SHORT_SHIFT			8
+#define	RETRY_LIMIT_LONG_SHIFT			0
+
+#define	NAV_UPPER_EN				BIT(16)
+#define	NAV_UPPER				0xFF00
+#define	NAV_RTSRST				0xFF
+
+#define	BW_OPMODE_20MHZ				BIT(2)
+#define	BW_OPMODE_5G				BIT(1)
+#define	BW_OPMODE_11J				BIT(0)
+
+#define	RXERR_RPT_RST				BIT(27)
+#define	RXERR_OFDM_PPDU				0
+#define	RXERR_OFDM_FALSE_ALARM			1
+#define	RXERR_OFDM_MPDU_OK			2
+#define	RXERR_OFDM_MPDU_FAIL			3
+#define	RXERR_CCK_PPDU				4
+#define	RXERR_CCK_FALSE_ALARM			5
+#define	RXERR_CCK_MPDU_OK			6
+#define	RXERR_CCK_MPDU_FAIL			7
+#define	RXERR_HT_PPDU				8
+#define	RXERR_HT_FALSE_ALARM			9
+#define	RXERR_HT_MPDU_TOTAL			10
+#define	RXERR_HT_MPDU_OK			11
+#define	RXERR_HT_MPDU_FAIL			12
+#define	RXERR_RX_FULL_DROP			15
+
+#define	SCR_TXUSEDK				BIT(0)
+#define	SCR_RXUSEDK				BIT(1)
+#define	SCR_TXENCENABLE				BIT(2)
+#define	SCR_RXENCENABLE				BIT(3)
+#define	SCR_SKBYA2				BIT(4)
+#define	SCR_NOSKMC				BIT(5)
+
+#define	CAM_VALID				BIT(15)
+#define	CAM_NOTVALID				0x0000
+#define	CAM_USEDK				BIT(5)
+
+#define	CAM_NONE				0x0
+#define	CAM_WEP40				0x01
+#define	CAM_TKIP				0x02
+#define	CAM_AES					0x04
+#define	CAM_WEP104				0x05
+
+#define	TOTAL_CAM_ENTRY				32
+#define	HALF_CAM_ENTRY				16
+
+#define	CAM_WRITE				BIT(16)
+#define	CAM_READ				0x00000000
+#define	CAM_POLLINIG				BIT(31)
+
+#define	WOW_PMEN				BIT(0)
+#define	WOW_WOMEN				BIT(1)
+#define	WOW_MAGIC				BIT(2)
+#define	WOW_UWF					BIT(3)
+
+#define	GPIOMUX_EN				BIT(3)
+#define	GPIOSEL_GPIO				0
+#define	GPIOSEL_PHYDBG				1
+#define	GPIOSEL_BT				2
+#define	GPIOSEL_WLANDBG				3
+#define	GPIOSEL_GPIO_MASK			(~(BIT(0)|BIT(1)))
+
+#define	HST_RDBUSY				BIT(0)
+#define	CPU_WTBUSY				BIT(1)
+
+#define	IMR8190_DISABLED			0x0
+#define	IMR_CPUERR				BIT(5)
+#define	IMR_ATIMEND				BIT(4)
+#define	IMR_TBDOK				BIT(3)
+#define	IMR_TBDER				BIT(2)
+#define	IMR_BCNDMAINT8				BIT(1)
+#define	IMR_BCNDMAINT7				BIT(0)
+#define	IMR_BCNDMAINT6				BIT(31)
+#define	IMR_BCNDMAINT5				BIT(30)
+#define	IMR_BCNDMAINT4				BIT(29)
+#define	IMR_BCNDMAINT3				BIT(28)
+#define	IMR_BCNDMAINT2				BIT(27)
+#define	IMR_BCNDMAINT1				BIT(26)
+#define	IMR_BCNDOK8				BIT(25)
+#define	IMR_BCNDOK7				BIT(24)
+#define	IMR_BCNDOK6				BIT(23)
+#define	IMR_BCNDOK5				BIT(22)
+#define	IMR_BCNDOK4				BIT(21)
+#define	IMR_BCNDOK3				BIT(20)
+#define	IMR_BCNDOK2				BIT(19)
+#define	IMR_BCNDOK1				BIT(18)
+#define	IMR_TIMEOUT2				BIT(17)
+#define	IMR_TIMEOUT1				BIT(16)
+#define	IMR_TXFOVW				BIT(15)
+#define	IMR_PSTIMEOUT				BIT(14)
+#define	IMR_BCNINT				BIT(13)
+#define	IMR_RXFOVW				BIT(12)
+#define	IMR_RDU					BIT(11)
+#define	IMR_RXCMDOK				BIT(10)
+#define	IMR_BDOK				BIT(9)
+#define	IMR_HIGHDOK				BIT(8)
+#define	IMR_COMDOK				BIT(7)
+#define	IMR_MGNTDOK				BIT(6)
+#define	IMR_HCCADOK				BIT(5)
+#define	IMR_BKDOK				BIT(4)
+#define	IMR_BEDOK				BIT(3)
+#define	IMR_VIDOK				BIT(2)
+#define	IMR_VODOK				BIT(1)
+#define	IMR_ROK					BIT(0)
+
+#define	TPPOLL_BKQ				BIT(0)
+#define	TPPOLL_BEQ				BIT(1)
+#define	TPPOLL_VIQ				BIT(2)
+#define	TPPOLL_VOQ				BIT(3)
+#define	TPPOLL_BQ				BIT(4)
+#define	TPPOLL_CQ				BIT(5)
+#define	TPPOLL_MQ				BIT(6)
+#define	TPPOLL_HQ				BIT(7)
+#define	TPPOLL_HCCAQ				BIT(8)
+#define	TPPOLL_STOPBK				BIT(9)
+#define	TPPOLL_STOPBE				BIT(10)
+#define	TPPOLL_STOPVI				BIT(11)
+#define	TPPOLL_STOPVO				BIT(12)
+#define	TPPOLL_STOPMGT				BIT(13)
+#define	TPPOLL_STOPHIGH				BIT(14)
+#define	TPPOLL_STOPHCCA				BIT(15)
+#define	TPPOLL_SHIFT				8
+
+#define	CCX_CMD_CLM_ENABLE			BIT(0)
+#define	CCX_CMD_NHM_ENABLE			BIT(1)
+#define	CCX_CMD_FUNCTION_ENABLE			BIT(8)
+#define	CCX_CMD_IGNORE_CCA			BIT(9)
+#define	CCX_CMD_IGNORE_TXON			BIT(10)
+#define	CCX_CLM_RESULT_READY			BIT(16)
+#define	CCX_NHM_RESULT_READY			BIT(16)
+#define	CCX_CMD_RESET				0x0
+
+/* REG_USB_SPECIAL_OPTION */
+#define USB_SPECIAL_OPTION_AGG_EN		BIT(3)
+
+/* REG_USB_HRPWM */
+#define USB_PS_ALL_ON				BIT(2)
+#define USB_PS_ACTIVE				BIT(3)
+
+/* REG_USB_CHIRP_K / REG_USB_EP ??? */
+#define USB_EP_HQ_M				0x000f
+#define USB_EP_HQ_S				0
+#define USB_EP_NQ_M				0x00f0
+#define USB_EP_NQ_S				4
+#define USB_EP_LQ_M				0x0f00
+#define USB_EP_LQ_S				8
+
+
+#define	HWSET_MAX_SIZE_92S			256
+#define EFUSE_MAX_SECTION			16
+#define EFUSE_REAL_CONTENT_LEN			512
+#define EFUSE_OOB_PROTECT_BYTES			15
+
+#define RTL8190_EEPROM_ID			0x8129
+#define EEPROM_HPON				0x02
+
+#define EEPROM_VID				0x08
+#define EEPROM_DID				0x0A
+
+#define EEPROM_USB_OPTIONAL			0x0C // (&0x18)>>2 == #ep?
+#define EEPROM_USB_PHY_PARA1			0x0D // 0x0D-0x11
+
+#define EEPROM_MAC_ADDR				0x12
+#define EEPROM_NODE_ADDRESS_BYTE_0		0x12
+
+// 0x18-0x19?
+
+#define EEPROM_VERSION				0x50
+#define EEPROM_CHANNELPLAN			0x51
+#define	EEPROM_CUSTOMID				0x52
+#define EEPROM_SUBCUSTOMID			0x53
+#define EEPROM_BOARDTYPE			0x54
+
+#define EEPROM_TXPOWERBASE			0x55 // 0x55-0x66 // should be TxPwIndex
+#define	EEPROM_TX_PWR_INDEX_RANGE		18
+#define EEPROM_PWDIFF				0x67
+
+#define EEPROM_THERMALMETER			0x68
+#define EEPROM_CRYSTALCAP			0x69
+//#define EEPROM_TXPOWERBASE			0x6A
+
+#define EEPROM_TSSI_A				0x6B
+#define EEPROM_TSSI_B				0x6C
+//#define EEPROM_TXPWTKMODE			0x6D
+
+#define EEPROM_TX_PWR_HT20_DIFF			0x6E // 0x6E-0x70
+#define DEFAULT_HT20_TXPWR_DIFF			2
+#define EEPROM_TX_PWR_OFDM_DIFF			0x71 // 0x71-0x72,0x82
+
+// 0x73-0x78?
+
+#define	EEPROM_TXPWRGROUP			0x79 // ???
+#define EEPROM_REGULATORY			0x7A // ???
+
+//#define TX_PWR_SAFETY_CHK			0x6D
+//#define EEPROM_TXPWINDEX_CCK_24G		0x5D
+//#define EEPROM_TXPWINDEX_OFDM_24G		0x6B
+//#define EEPROM_HT2T_CH1_A			0x6c
+//#define EEPROM_HT2T_CH7_A			0x6d
+//#define EEPROM_HT2T_CH13_A			0x6e
+//#define EEPROM_HT2T_CH1_B			0x6f
+//#define EEPROM_HT2T_CH7_B			0x70
+//#define EEPROM_HT2T_CH13_B			0x71
+
+#define	EEPROM_RFIND_POWERDIFF			0x7B
+#define	EEPROM_DEFAULT_LEGACYHTTXPOWERDIFF	0x3
+
+//#define	EEPROM_BLUETOOTH_COEXIST		0x78
+//#define	EEPROM_BLUETOOTH_TYPE			0x4f
+
+//#define	EEPROM_OPTIONAL				0x78
+//#define	EEPROM_WOWLAN				0x78
+
+#define	EEPROM_CHANNEL_PLAN_FCC			0x0
+#define	EEPROM_CHANNEL_PLAN_IC			0x1
+#define	EEPROM_CHANNEL_PLAN_ETSI		0x2
+#define	EEPROM_CHANNEL_PLAN_SPAIN		0x3
+#define	EEPROM_CHANNEL_PLAN_FRANCE		0x4
+#define	EEPROM_CHANNEL_PLAN_MKK			0x5
+#define	EEPROM_CHANNEL_PLAN_MKK1		0x6
+#define	EEPROM_CHANNEL_PLAN_ISRAEL		0x7
+#define	EEPROM_CHANNEL_PLAN_TELEC		0x8
+#define	EEPROM_CHANNEL_PLAN_GLOBAL_DOMAIN	0x9
+#define	EEPROM_CHANNEL_PLAN_WORLD_WIDE_13	0xA
+#define	EEPROM_CHANNEL_PLAN_NCC			0xB
+#define	EEPROM_CHANNEL_PLAN_BY_HW_MASK		0x80
+
+#define	FW_DIG_DISABLE				0xfd00cc00
+#define	FW_DIG_ENABLE				0xfd000000
+#define	FW_DIG_HALT				0xfd000001
+#define	FW_DIG_RESUME				0xfd000002
+#define	FW_HIGH_PWR_DISABLE			0xfd000008
+#define	FW_HIGH_PWR_ENABLE			0xfd000009
+#define	FW_ADD_A2_ENTRY				0xfd000016
+#define	FW_TXPWR_TRACK_ENABLE			0xfd000017
+#define	FW_TXPWR_TRACK_DISABLE			0xfd000018
+#define	FW_TXPWR_TRACK_THERMAL			0xfd000019
+#define	FW_TXANT_SWITCH_ENABLE			0xfd000023
+#define	FW_TXANT_SWITCH_DISABLE			0xfd000024
+#define	FW_RA_INIT				0xfd000026
+#define	FW_CTRL_DM_BY_DRIVER			0Xfd00002a
+#define	FW_RA_IOT_BG_COMB			0xfd000030
+#define	FW_RA_IOT_N_COMB			0xfd000031
+#define	FW_RA_REFRESH				0xfd0000a0
+#define	FW_RA_UPDATE_MASK			0xfd0000a2
+#define	FW_RA_DISABLE				0xfd0000a4
+#define	FW_RA_ACTIVE				0xfd0000a6
+#define	FW_RA_DISABLE_RSSI_MASK			0xfd0000ac
+#define	FW_RA_ENABLE_RSSI_MASK			0xfd0000ad
+#define	FW_RA_RESET				0xfd0000af
+#define	FW_DM_DISABLE				0xfd00aa00
+#define	FW_IQK_ENABLE				0xf0000020
+#define	FW_IQK_SUCCESS				0x0000dddd
+#define	FW_IQK_FAIL				0x0000ffff
+#define	FW_OP_FAILURE				0xffffffff
+#define	FW_TX_FEEDBACK_NONE			0xfb000000
+#define	FW_TX_FEEDBACK_DTM_ENABLE		(FW_TX_FEEDBACK_NONE | 0x1)
+#define	FW_TX_FEEDBACK_CCX_ENABL		(FW_TX_FEEDBACK_NONE | 0x2)
+#define	FW_BB_RESET_ENABLE			0xff00000d
+#define	FW_BB_RESET_DISABLE			0xff00000e
+#define	FW_CCA_CHK_ENABLE			0xff000011
+#define	FW_CCK_RESET_CNT			0xff000013
+#define	FW_LPS_ENTER				0xfe000010
+#define	FW_LPS_LEAVE				0xfe000011
+#define	FW_INDIRECT_READ			0xf2000000
+#define	FW_INDIRECT_WRITE			0xf2000001
+#define	FW_CHAN_SET				0xf3000001
+
+#define IOCMD_CLASS_BB_RF			0xF0
+#define IOCMD_BB_READ_IDX			0x00
+#define IOCMD_BB_WRITE_IDX			0x01
+#define IOCMD_RF_READ_IDX			0x02
+#define IOCMD_RF_WRITE_IDX			0x03
+
+#define RFPC					0x5F
+#define RCR_9356SEL				BIT(6)
+#define TCR_LRL_OFFSET				0
+#define TCR_SRL_OFFSET				8
+#define TCR_MXDMA_OFFSET			21
+#define TCR_SAT					BIT(24)
+#define RCR_MXDMA_OFFSET			8
+#define RCR_FIFO_OFFSET				13
+#define RCR_OnlyErlPkt				BIT(31)
+#define CWR					0xDC
+#define RETRYCTR				0xDE
+
+#define CPU_GEN_SYSTEM_RESET			0x00000001
+
+#define	CCX_COMMAND_REG				0x890
+#define	CLM_PERIOD_REG				0x894
+#define	NHM_PERIOD_REG				0x896
+
+#define	NHM_THRESHOLD0				0x898
+#define	NHM_THRESHOLD1				0x899
+#define	NHM_THRESHOLD2				0x89A
+#define	NHM_THRESHOLD3				0x89B
+#define	NHM_THRESHOLD4				0x89C
+#define	NHM_THRESHOLD5				0x89D
+#define	NHM_THRESHOLD6				0x89E
+#define	CLM_RESULT_REG				0x8D0
+#define	NHM_RESULT_REG				0x8D4
+#define	NHM_RPI_COUNTER0			0x8D8
+#define	NHM_RPI_COUNTER1			0x8D9
+#define	NHM_RPI_COUNTER2			0x8DA
+#define	NHM_RPI_COUNTER3			0x8DB
+#define	NHM_RPI_COUNTER4			0x8DC
+#define	NHM_RPI_COUNTER5			0x8DD
+#define	NHM_RPI_COUNTER6			0x8DE
+#define	NHM_RPI_COUNTER7			0x8DF
+
+#define	HAL_8192S_HW_GPIO_OFF_BIT		BIT(3)
+#define	HAL_8192S_HW_GPIO_OFF_MASK		0xF7
+#define	HAL_8192S_HW_GPIO_WPS_BIT		BIT(4)
+
+#define	RPMAC_RESET				0x100
+#define	RPMAC_TXSTART				0x104
+#define	RPMAC_TXLEGACYSIG			0x108
+#define	RPMAC_TXHTSIG1				0x10c
+#define	RPMAC_TXHTSIG2				0x110
+#define	RPMAC_PHYDEBUG				0x114
+#define	RPMAC_TXPACKETNNM			0x118
+#define	RPMAC_TXIDLE				0x11c
+#define	RPMAC_TXMACHEADER0			0x120
+#define	RPMAC_TXMACHEADER1			0x124
+#define	RPMAC_TXMACHEADER2			0x128
+#define	RPMAC_TXMACHEADER3			0x12c
+#define	RPMAC_TXMACHEADER4			0x130
+#define	RPMAC_TXMACHEADER5			0x134
+#define	RPMAC_TXDATATYPE			0x138
+#define	RPMAC_TXRANDOMSEED			0x13c
+#define	RPMAC_CCKPLCPPREAMBLE			0x140
+#define	RPMAC_CCKPLCPHEADER			0x144
+#define	RPMAC_CCKCRC16				0x148
+#define	RPMAC_OFDMRXCRC32OK			0x170
+#define	RPMAC_OFDMRXCRC32ER			0x174
+#define	RPMAC_OFDMRXPARITYER			0x178
+#define	RPMAC_OFDMRXCRC8ER			0x17c
+#define	RPMAC_CCKCRXRC16ER			0x180
+#define	RPMAC_CCKCRXRC32ER			0x184
+#define	RPMAC_CCKCRXRC32OK			0x188
+#define	RPMAC_TXSTATUS				0x18c
+
+#define	RF_BB_CMD_ADDR				0x02c0
+#define	RF_BB_CMD_DATA				0x02c4
+
+#define	RFPGA0_RFMOD				0x800
+
+#define	RFPGA0_TXINFO				0x804
+#define	RFPGA0_PSDFUNCTION			0x808
+
+#define	RFPGA0_TXGAINSTAGE			0x80c
+
+#define	RFPGA0_RFTIMING1			0x810
+#define	RFPGA0_RFTIMING2			0x814
+#define	RFPGA0_XA_HSSIPARAMETER1		0x820
+#define	RFPGA0_XA_HSSIPARAMETER2		0x824
+#define	RFPGA0_XB_HSSIPARAMETER1		0x828
+#define	RFPGA0_XB_HSSIPARAMETER2		0x82c
+#define	RFPGA0_XC_HSSIPARAMETER1		0x830
+#define	RFPGA0_XC_HSSIPARAMETER2		0x834
+#define	RFPGA0_XD_HSSIPARAMETER1		0x838
+#define	RFPGA0_XD_HSSIPARAMETER2		0x83c
+#define	RFPGA0_XA_LSSIPARAMETER			0x840
+#define	RFPGA0_XB_LSSIPARAMETER			0x844
+#define	RFPGA0_XC_LSSIPARAMETER			0x848
+#define	RFPGA0_XD_LSSIPARAMETER			0x84c
+
+#define	RFPGA0_RFWAKEUP_PARAMETER		0x850
+#define	RFPGA0_RFSLEEPUP_PARAMETER		0x854
+
+#define	RFPGA0_XAB_SWITCHCONTROL		0x858
+#define	RFPGA0_XCD_SWITCHCONTROL		0x85c
+
+#define	RFPGA0_XA_RFINTERFACEOE			0x860
+#define	RFPGA0_XB_RFINTERFACEOE			0x864
+#define	RFPGA0_XC_RFINTERFACEOE			0x868
+#define	RFPGA0_XD_RFINTERFACEOE			0x86c
+
+#define	RFPGA0_XAB_RFINTERFACESW		0x870
+#define	RFPGA0_XCD_RFINTERFACESW		0x874
+
+#define	RFPGA0_XAB_RFPARAMETER			0x878
+#define	RFPGA0_XCD_RFPARAMETER			0x87c
+
+#define	RFPGA0_ANALOGPARAMETER1			0x880
+#define	RFPGA0_ANALOGPARAMETER2			0x884
+#define	RFPGA0_ANALOGPARAMETER3			0x888
+#define	RFPGA0_ANALOGPARAMETER4			0x88c
+
+#define	RFPGA0_XA_LSSIREADBACK			0x8a0
+#define	RFPGA0_XB_LSSIREADBACK			0x8a4
+#define	RFPGA0_XC_LSSIREADBACK			0x8a8
+#define	RFPGA0_XD_LSSIREADBACK			0x8ac
+
+#define	RFPGA0_PSDREPORT			0x8b4
+#define	TRANSCEIVERA_HSPI_READBACK		0x8b8
+#define	TRANSCEIVERB_HSPI_READBACK		0x8bc
+#define	RFPGA0_XAB_RFINTERFACERB		0x8e0
+#define	RFPGA0_XCD_RFINTERFACERB		0x8e4
+#define	RFPGA1_RFMOD				0x900
+
+#define	RFPGA1_TXBLOCK				0x904
+#define	RFPGA1_DEBUGSELECT			0x908
+#define	RFPGA1_TXINFO				0x90c
+
+#define	RCCK0_SYSTEM				0xa00
+
+#define	RCCK0_AFESETTING			0xa04
+#define	RCCK0_CCA				0xa08
+
+#define	RCCK0_RXAGC1				0xa0c
+#define	RCCK0_RXAGC2				0xa10
+
+#define	RCCK0_RXHP				0xa14
+
+#define	RCCK0_DSPPARAMETER1			0xa18
+#define	RCCK0_DSPPARAMETER2			0xa1c
+
+#define	RCCK0_TXFILTER1				0xa20
+#define	RCCK0_TXFILTER2				0xa24
+#define	RCCK0_DEBUGPORT				0xa28
+#define	RCCK0_FALSEALARMREPORT			0xa2c
+#define	RCCK0_TRSSIREPORT			0xa50
+#define	RCCK0_RXREPORT				0xa54
+#define	RCCK0_FACOUNTERLOWER			0xa5c
+#define	RCCK0_FACOUNTERUPPER			0xa58
+
+#define	ROFDM0_LSTF				0xc00
+
+#define	ROFDM0_TRXPATHENABLE			0xc04
+#define	ROFDM0_TRMUXPAR				0xc08
+#define	ROFDM0_TRSWISOLATION			0xc0c
+
+#define	ROFDM0_XARXAFE				0xc10
+#define	ROFDM0_XARXIQIMBALANCE			0xc14
+#define	ROFDM0_XBRXAFE				0xc18
+#define	ROFDM0_XBRXIQIMBALANCE			0xc1c
+#define	ROFDM0_XCRXAFE				0xc20
+#define	ROFDM0_XCRXIQIMBALANCE			0xc24
+#define	ROFDM0_XDRXAFE				0xc28
+#define	ROFDM0_XDRXIQIMBALANCE			0xc2c
+
+#define	ROFDM0_RXDETECTOR1			0xc30
+#define	ROFDM0_RXDETECTOR2			0xc34
+#define	ROFDM0_RXDETECTOR3			0xc38
+#define	ROFDM0_RXDETECTOR4			0xc3c
+
+#define	ROFDM0_RXDSP				0xc40
+#define	ROFDM0_CFO_AND_DAGC			0xc44
+#define	ROFDM0_CCADROP_THRESHOLD		0xc48
+#define	ROFDM0_ECCA_THRESHOLD			0xc4c
+
+#define	ROFDM0_XAAGCCORE1			0xc50
+#define	ROFDM0_XAAGCCORE2			0xc54
+#define	ROFDM0_XBAGCCORE1			0xc58
+#define	ROFDM0_XBAGCCORE2			0xc5c
+#define	ROFDM0_XCAGCCORE1			0xc60
+#define	ROFDM0_XCAGCCORE2			0xc64
+#define	ROFDM0_XDAGCCORE1			0xc68
+#define	ROFDM0_XDAGCCORE2			0xc6c
+
+#define	ROFDM0_AGCPARAMETER1			0xc70
+#define	ROFDM0_AGCPARAMETER2			0xc74
+#define	ROFDM0_AGCRSSITABLE			0xc78
+#define	ROFDM0_HTSTFAGC				0xc7c
+
+#define	ROFDM0_XATXIQIMBALANCE			0xc80
+#define	ROFDM0_XATXAFE				0xc84
+#define	ROFDM0_XBTXIQIMBALANCE			0xc88
+#define	ROFDM0_XBTXAFE				0xc8c
+#define	ROFDM0_XCTXIQIMBALANCE			0xc90
+#define	ROFDM0_XCTXAFE				0xc94
+#define	ROFDM0_XDTXIQIMBALANCE			0xc98
+#define	ROFDM0_XDTXAFE				0xc9c
+
+#define	ROFDM0_RXHP_PARAMETER			0xce0
+#define	ROFDM0_TXPSEUDO_NOISE_WGT		0xce4
+#define	ROFDM0_FRAME_SYNC			0xcf0
+#define	ROFDM0_DFSREPORT			0xcf4
+#define	ROFDM0_TXCOEFF1				0xca4
+#define	ROFDM0_TXCOEFF2				0xca8
+#define	ROFDM0_TXCOEFF3				0xcac
+#define	ROFDM0_TXCOEFF4				0xcb0
+#define	ROFDM0_TXCOEFF5				0xcb4
+#define	ROFDM0_TXCOEFF6				0xcb8
+
+
+#define	ROFDM1_LSTF				0xd00
+#define	ROFDM1_TRXPATHENABLE			0xd04
+
+#define	ROFDM1_CFO				0xd08
+#define	ROFDM1_CSI1				0xd10
+#define	ROFDM1_SBD				0xd14
+#define	ROFDM1_CSI2				0xd18
+#define	ROFDM1_CFOTRACKING			0xd2c
+#define	ROFDM1_TRXMESAURE1			0xd34
+#define	ROFDM1_INTF_DET				0xd3c
+#define	ROFDM1_PSEUDO_NOISESTATEAB		0xd50
+#define	ROFDM1_PSEUDO_NOISESTATECD		0xd54
+#define	ROFDM1_RX_PSEUDO_NOISE_WGT		0xd58
+
+#define	ROFDM_PHYCOUNTER1			0xda0
+#define	ROFDM_PHYCOUNTER2			0xda4
+#define	ROFDM_PHYCOUNTER3			0xda8
+
+#define	ROFDM_SHORT_CFOAB			0xdac
+#define	ROFDM_SHORT_CFOCD			0xdb0
+#define	ROFDM_LONG_CFOAB			0xdb4
+#define	ROFDM_LONG_CFOCD			0xdb8
+#define	ROFDM_TAIL_CFOAB			0xdbc
+#define	ROFDM_TAIL_CFOCD			0xdc0
+#define	ROFDM_PW_MEASURE1			0xdc4
+#define	ROFDM_PW_MEASURE2			0xdc8
+#define	ROFDM_BW_REPORT				0xdcc
+#define	ROFDM_AGC_REPORT			0xdd0
+#define	ROFDM_RXSNR				0xdd4
+#define	ROFDM_RXEVMCSI				0xdd8
+#define	ROFDM_SIG_REPORT			0xddc
+
+
+#define	RTXAGC_RATE18_06			0xe00
+#define	RTXAGC_RATE54_24			0xe04
+#define	RTXAGC_CCK_MCS32			0xe08
+#define	RTXAGC_MCS03_MCS00			0xe10
+#define	RTXAGC_MCS07_MCS04			0xe14
+#define	RTXAGC_MCS11_MCS08			0xe18
+#define	RTXAGC_MCS15_MCS12			0xe1c
+
+
+#define	RF_AC					0x00
+#define	RF_IQADJ_G1				0x01
+#define	RF_IQADJ_G2				0x02
+#define	RF_POW_TRSW				0x05
+#define	RF_GAIN_RX				0x06
+#define	RF_GAIN_TX				0x07
+#define	RF_TXM_IDAC				0x08
+#define	RF_BS_IQGEN				0x0F
+
+#define	RF_MODE1				0x10
+#define	RF_MODE2				0x11
+#define	RF_RX_AGC_HP				0x12
+#define	RF_TX_AGC				0x13
+#define	RF_BIAS					0x14
+#define	RF_IPA					0x15
+#define	RF_POW_ABILITY				0x17
+#define	RF_MODE_AG				0x18
+#define	RF_CHANNEL				0x18
+#define	RF_CHNLBW				0x18
+#define	RF_TOP					0x19
+#define	RF_RX_G1				0x1A
+#define	RF_RX_G2				0x1B
+#define	RF_RX_BB2				0x1C
+#define	RF_RX_BB1				0x1D
+#define	RF_RCK1					0x1E
+#define	RF_RCK2					0x1F
+
+#define	RF_TX_G1				0x20
+#define	RF_TX_G2				0x21
+#define	RF_TX_G3				0x22
+#define	RF_TX_BB1				0x23
+#define	RF_T_METER				0x24
+#define	RF_SYN_G1				0x25
+#define	RF_SYN_G2				0x26
+#define	RF_SYN_G3				0x27
+#define	RF_SYN_G4				0x28
+#define	RF_SYN_G5				0x29
+#define	RF_SYN_G6				0x2A
+#define	RF_SYN_G7				0x2B
+#define	RF_SYN_G8				0x2C
+
+#define	RF_RCK_OS				0x30
+#define	RF_TXPA_G1				0x31
+#define	RF_TXPA_G2				0x32
+#define	RF_TXPA_G3				0x33
+
+#define	BRFMOD					0x1
+#define	BCCKEN					0x1000000
+#define	BOFDMEN					0x2000000
+
+#define	BXBTXAGC				0xf00
+#define	BXCTXAGC				0xf000
+#define	BXDTXAGC				0xf0000
+
+#define	B3WIRE_DATALENGTH			0x800
+#define	B3WIRE_ADDRESSLENGTH			0x400
+
+#define	BRFSI_RFENV				0x10
+
+#define	BLSSI_READADDRESS			0x7f800000
+#define	BLSSI_READEDGE				0x80000000
+#define	BLSSI_READBACK_DATA			0xfffff
+
+#define	BADCLKPHASE				0x4000000
+
+#define	BCCK_SIDEBAND				0x10
+
+#define	BTX_AGCRATECCK				0x7f00
+
+#define	MASKBYTE0				0xff
+#define	MASKBYTE1				0xff00
+#define	MASKBYTE2				0xff0000
+#define	MASKBYTE3				0xff000000
+#define	MASKHWORD				0xffff0000
+#define	MASKLWORD				0x0000ffff
+#define	MASKDWORD				0xffffffff
+
+#define	MAKS12BITS				0xfffff
+#define	MASK20BITS				0xfffff
+#define RFREG_OFFSET_MASK			0xfffff
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/rf.c b/drivers/net/wireless/rtlwifi/rtl8192su/rf.c
new file mode 100644
index 0000000..3fa351d
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/rf.c
@@ -0,0 +1,542 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "rf.h"
+#include "dm.h"
+
+
+static void _rtl92s_get_powerbase(struct ieee80211_hw *hw, u8 *p_pwrlevel,
+				  u8 chnl, u32 *ofdmbase, u32 *mcsbase,
+				  u8 *p_final_pwridx)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u32 pwrbase0, pwrbase1;
+	u8 legacy_pwrdiff = 0, ht20_pwrdiff = 0;
+	u8 i, pwrlevel[4];
+
+	for (i = 0; i < 2; i++)
+		pwrlevel[i] = p_pwrlevel[i];
+
+	/* We only care about the path A for legacy. */
+	if (rtlefuse->eeprom_version < 2) {
+		pwrbase0 = pwrlevel[0] + (rtlefuse->legacy_httxpowerdiff & 0xf);
+	} else if (rtlefuse->eeprom_version >= 2) {
+		legacy_pwrdiff = rtlefuse->txpwr_legacyhtdiff
+						[RF90_PATH_A][chnl - 1];
+
+		/* For legacy OFDM, tx pwr always > HT OFDM pwr.
+		 * We do not care Path B
+		 * legacy OFDM pwr diff. NO BB register
+		 * to notify HW. */
+		pwrbase0 = pwrlevel[0] + legacy_pwrdiff;
+	}
+
+	pwrbase0 = (pwrbase0 << 24) | (pwrbase0 << 16) | (pwrbase0 << 8) |
+		    pwrbase0;
+	*ofdmbase = pwrbase0;
+
+	/* MCS rates */
+	if (rtlefuse->eeprom_version >= 2) {
+		/* Check HT20 to HT40 diff	*/
+		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20) {
+			for (i = 0; i < 2; i++) {
+				/* rf-A, rf-B */
+				/* HT 20<->40 pwr diff */
+				ht20_pwrdiff = rtlefuse->txpwr_ht20diff
+							[i][chnl - 1];
+
+				if (ht20_pwrdiff < 8) /* 0~+7 */
+					pwrlevel[i] += ht20_pwrdiff;
+				else /* index8-15=-8~-1 */
+					pwrlevel[i] -= (16 - ht20_pwrdiff);
+			}
+		}
+	}
+
+	/* use index of rf-A */
+	pwrbase1 = pwrlevel[0];
+	pwrbase1 = (pwrbase1 << 24) | (pwrbase1 << 16) | (pwrbase1 << 8) |
+				pwrbase1;
+	*mcsbase = pwrbase1;
+
+	/* The following is for Antenna
+	 * diff from Ant-B to Ant-A */
+	p_final_pwridx[0] = pwrlevel[0];
+	p_final_pwridx[1] = pwrlevel[1];
+
+	switch (rtlefuse->eeprom_regulatory) {
+	case 3:
+		/* The following is for calculation
+		 * of the power diff for Ant-B to Ant-A. */
+		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
+			p_final_pwridx[0] += rtlefuse->pwrgroup_ht40
+						[RF90_PATH_A][
+						chnl - 1];
+			p_final_pwridx[1] += rtlefuse->pwrgroup_ht40
+						[RF90_PATH_B][
+						chnl - 1];
+		} else {
+			p_final_pwridx[0] += rtlefuse->pwrgroup_ht20
+						[RF90_PATH_A][
+						chnl - 1];
+			p_final_pwridx[1] += rtlefuse->pwrgroup_ht20
+						[RF90_PATH_B][
+						chnl - 1];
+		}
+		break;
+	default:
+		break;
+	}
+
+	if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "40MHz finalpwr_idx (A / B) = 0x%x / 0x%x\n",
+			 p_final_pwridx[0], p_final_pwridx[1]);
+	} else {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "20MHz finalpwr_idx (A / B) = 0x%x / 0x%x\n",
+			 p_final_pwridx[0], p_final_pwridx[1]);
+	}
+}
+
+static void _rtl92s_set_antennadiff(struct ieee80211_hw *hw,
+				    u8 *p_final_pwridx)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	char ant_pwr_diff = 0;
+	u32	u4reg_val = 0;
+
+	if (rtlphy->rf_type == RF_2T2R) {
+		ant_pwr_diff = p_final_pwridx[1] - p_final_pwridx[0];
+
+		/* range is from 7~-8,
+		 * index = 0x0~0xf */
+		if (ant_pwr_diff > 7)
+			ant_pwr_diff = 7;
+		if (ant_pwr_diff < -8)
+			ant_pwr_diff = -8;
+
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "Antenna Diff from RF-B to RF-A = %d (0x%x)\n",
+			 ant_pwr_diff, ant_pwr_diff & 0xf);
+
+		ant_pwr_diff &= 0xf;
+	}
+
+	/* Antenna TX power difference */
+	rtlefuse->antenna_txpwdiff[2] = 0;/* RF-D, don't care */
+	rtlefuse->antenna_txpwdiff[1] = 0;/* RF-C, don't care */
+	rtlefuse->antenna_txpwdiff[0] = (u8)(ant_pwr_diff);	/* RF-B */
+
+	u4reg_val = rtlefuse->antenna_txpwdiff[2] << 8 |
+				rtlefuse->antenna_txpwdiff[1] << 4 |
+				rtlefuse->antenna_txpwdiff[0];
+
+	rtl_set_bbreg(hw, RFPGA0_TXGAINSTAGE, (BXBTXAGC | BXCTXAGC | BXDTXAGC),
+		      u4reg_val);
+
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, "Write BCD-Diff(0x%x) = 0x%x\n",
+		 RFPGA0_TXGAINSTAGE, u4reg_val);
+}
+
+static void _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
+						      u8 chnl, u8 index,
+						      u32 pwrbase0,
+						      u32 pwrbase1,
+						      u32 *p_outwrite_val)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u8 i, chnlgroup, pwrdiff_limit[4];
+	u32 writeval, customer_limit;
+
+	/* Index 0 & 1= legacy OFDM, 2-5=HT_MCS rate */
+	switch (rtlefuse->eeprom_regulatory) {
+	case 0:
+		/* Realtek better performance increase power diff
+		 * defined by Realtek for large power */
+		chnlgroup = 0;
+
+		writeval = rtlphy->mcs_txpwrlevel_origoffset
+				[chnlgroup][index] +
+				((index < 2) ? pwrbase0 : pwrbase1);
+
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "RTK better performance, writeval = 0x%x\n", writeval);
+		break;
+	case 1:
+		/* Realtek regulatory increase power diff defined
+		 * by Realtek for regulatory */
+		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
+			writeval = ((index < 2) ? pwrbase0 : pwrbase1);
+
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 "Realtek regulatory, 40MHz, writeval = 0x%x\n",
+				 writeval);
+		} else {
+			if (rtlphy->pwrgroup_cnt == 1)
+				chnlgroup = 0;
+
+			if (rtlphy->pwrgroup_cnt >= 3) {
+				if (chnl <= 3)
+					chnlgroup = 0;
+				else if (chnl >= 4 && chnl <= 8)
+					chnlgroup = 1;
+				else if (chnl > 8)
+					chnlgroup = 2;
+				if (rtlphy->pwrgroup_cnt == 4)
+					chnlgroup++;
+			}
+
+			writeval = rtlphy->mcs_txpwrlevel_origoffset
+					[chnlgroup][index]
+					+ ((index < 2) ?
+					pwrbase0 : pwrbase1);
+
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 "Realtek regulatory, 20MHz, writeval = 0x%x\n",
+				 writeval);
+		}
+		break;
+	case 2:
+		/* Better regulatory don't increase any power diff */
+		writeval = ((index < 2) ? pwrbase0 : pwrbase1);
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "Better regulatory, writeval = 0x%x\n", writeval);
+		break;
+	case 3:
+		/* Customer defined power diff. increase power diff
+		  defined by customer. */
+		chnlgroup = 0;
+
+		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 "customer's limit, 40MHz = 0x%x\n",
+				 rtlefuse->pwrgroup_ht40
+				 [RF90_PATH_A][chnl - 1]);
+		} else {
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 "customer's limit, 20MHz = 0x%x\n",
+				 rtlefuse->pwrgroup_ht20
+				 [RF90_PATH_A][chnl - 1]);
+		}
+
+		for (i = 0; i < 4; i++) {
+			pwrdiff_limit[i] =
+				(u8)((rtlphy->mcs_txpwrlevel_origoffset
+				[chnlgroup][index] & (0x7f << (i * 8)))
+				>> (i * 8));
+
+			if (rtlphy->current_chan_bw ==
+			    HT_CHANNEL_WIDTH_20_40) {
+				if (pwrdiff_limit[i] >
+				    rtlefuse->pwrgroup_ht40
+				    [RF90_PATH_A][chnl - 1]) {
+					pwrdiff_limit[i] =
+					  rtlefuse->pwrgroup_ht20
+					  [RF90_PATH_A][chnl - 1];
+				}
+			} else {
+				if (pwrdiff_limit[i] >
+				    rtlefuse->pwrgroup_ht20
+				    [RF90_PATH_A][chnl - 1]) {
+					pwrdiff_limit[i] =
+					    rtlefuse->pwrgroup_ht20
+					    [RF90_PATH_A][chnl - 1];
+				}
+			}
+		}
+
+		customer_limit = (pwrdiff_limit[3] << 24) |
+				(pwrdiff_limit[2] << 16) |
+				(pwrdiff_limit[1] << 8) |
+				(pwrdiff_limit[0]);
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "Customer's limit = 0x%x\n", customer_limit);
+
+		writeval = customer_limit + ((index < 2) ?
+					     pwrbase0 : pwrbase1);
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "Customer, writeval = 0x%x\n", writeval);
+		break;
+	default:
+		chnlgroup = 0;
+		writeval = rtlphy->mcs_txpwrlevel_origoffset[chnlgroup][index] +
+				((index < 2) ? pwrbase0 : pwrbase1);
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 "RTK better performance, writeval = 0x%x\n", writeval);
+		break;
+	}
+
+	if (rtlpriv->dm.dynamic_txhighpower_lvl == TX_HIGH_PWR_LEVEL_LEVEL1)
+		writeval = 0x10101010;
+	else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+		 TX_HIGH_PWR_LEVEL_LEVEL2)
+		writeval = 0x0;
+
+	*p_outwrite_val = writeval;
+
+}
+
+static void _rtl92s_write_ofdm_powerreg(struct ieee80211_hw *hw,
+					u8 index, u32 val)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u16 regoffset[6] = {0xe00, 0xe04, 0xe10, 0xe14, 0xe18, 0xe1c};
+	u8 i, rfa_pwr[4];
+	u8 rfa_lower_bound = 0, rfa_upper_bound = 0, rf_pwr_diff = 0;
+	u32 writeval = val;
+
+	/* If path A and Path B coexist, we must limit Path A tx power.
+	 * Protect Path B pwr over or under flow. We need to calculate
+	 * upper and lower bound of path A tx power. */
+	if (rtlphy->rf_type == RF_2T2R) {
+		rf_pwr_diff = rtlefuse->antenna_txpwdiff[0];
+
+		/* Diff=-8~-1 */
+		if (rf_pwr_diff >= 8) {
+			/* Prevent underflow!! */
+			rfa_lower_bound = 0x10 - rf_pwr_diff;
+		/* if (rf_pwr_diff >= 0) Diff = 0-7 */
+		} else {
+			rfa_upper_bound = RF6052_MAX_TX_PWR - rf_pwr_diff;
+		}
+	}
+
+	for (i = 0; i < 4; i++) {
+		rfa_pwr[i] = (u8)((writeval & (0x7f << (i * 8))) >> (i * 8));
+		if (rfa_pwr[i]  > RF6052_MAX_TX_PWR)
+			rfa_pwr[i]  = RF6052_MAX_TX_PWR;
+
+		/* If path A and Path B coexist, we must limit Path A tx power.
+		 * Protect Path B pwr over or under flow. We need to calculate
+		 * upper and lower bound of path A tx power. */
+		if (rtlphy->rf_type == RF_2T2R) {
+			/* Diff=-8~-1 */
+			if (rf_pwr_diff >= 8) {
+				/* Prevent underflow!! */
+				if (rfa_pwr[i] < rfa_lower_bound)
+					rfa_pwr[i] = rfa_lower_bound;
+			/* Diff = 0-7 */
+			} else if (rf_pwr_diff >= 1) {
+				/* Prevent overflow */
+				if (rfa_pwr[i] > rfa_upper_bound)
+					rfa_pwr[i] = rfa_upper_bound;
+			}
+		}
+
+	}
+
+	writeval = (rfa_pwr[3] << 24) | (rfa_pwr[2] << 16) | (rfa_pwr[1] << 8) |
+				rfa_pwr[0];
+
+	rtl_set_bbreg(hw, regoffset[index], 0x7f7f7f7f, writeval);
+}
+
+void rtl92s_phy_rf6052_set_ofdmtxpower(struct ieee80211_hw *hw,
+				       u8 *p_pwrlevel, u8 chnl)
+{
+	u32 writeval, pwrbase0, pwrbase1;
+	u8 index = 0;
+	u8 finalpwr_idx[4];
+
+	_rtl92s_get_powerbase(hw, p_pwrlevel, chnl, &pwrbase0, &pwrbase1,
+			&finalpwr_idx[0]);
+	_rtl92s_set_antennadiff(hw, &finalpwr_idx[0]);
+
+	for (index = 0; index < 6; index++) {
+		_rtl92s_get_txpower_writeval_byregulatory(hw, chnl, index,
+				pwrbase0, pwrbase1, &writeval);
+
+		_rtl92s_write_ofdm_powerreg(hw, index, writeval);
+	}
+}
+
+void rtl92s_phy_rf6052_set_ccktxpower(struct ieee80211_hw *hw, u8 pwrlevel)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	u32 txagc = 0;
+	bool dont_inc_cck_or_turboscanoff = false;
+
+//	if (((rtlefuse->eeprom_version >= 2) &&
+//	      (rtlefuse->txpwr_safetyflag == 1)) ||
+	if ((rtlefuse->eeprom_version >= 2) ||
+	      ((rtlefuse->eeprom_version >= 2) &&
+	      (rtlefuse->eeprom_regulatory != 0)))
+		dont_inc_cck_or_turboscanoff = true;
+
+	if (mac->act_scanning) {
+		txagc = 0x3f;
+		if (dont_inc_cck_or_turboscanoff)
+			txagc = pwrlevel;
+	} else {
+		txagc = pwrlevel;
+
+		if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+		    TX_HIGH_PWR_LEVEL_LEVEL1)
+			txagc = 0x10;
+		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+			TX_HIGH_PWR_LEVEL_LEVEL2)
+			txagc = 0x0;
+	}
+
+	if (txagc > RF6052_MAX_TX_PWR)
+		txagc = RF6052_MAX_TX_PWR;
+
+	rtl_set_bbreg(hw, RTXAGC_CCK_MCS32, BTX_AGCRATECCK, txagc);
+
+}
+
+bool rtl92s_phy_rf6052_config(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u32 u4reg_val = 0;
+	u8 rfpath;
+	bool rtstatus = true;
+	struct bb_reg_def *pphyreg;
+
+	// XXX
+	return true;
+
+	/* Initialize RF */
+	for (rfpath = 0; rfpath < rtlphy->num_total_rfpath; rfpath++) {
+
+		pphyreg = &rtlphy->phyreg_def[rfpath];
+
+		/* Store original RFENV control type */
+		switch (rfpath) {
+		case RF90_PATH_A:
+		case RF90_PATH_C:
+			u4reg_val = rtl92s_phy_query_bb_reg(hw,
+							    pphyreg->rfintfs,
+							    BRFSI_RFENV);
+			break;
+		case RF90_PATH_B:
+		case RF90_PATH_D:
+			u4reg_val = rtl92s_phy_query_bb_reg(hw,
+							    pphyreg->rfintfs,
+							    BRFSI_RFENV << 16);
+			break;
+		}
+
+		/* Set RF_ENV enable */
+		rtl92s_phy_set_bb_reg(hw, pphyreg->rfintfe,
+				      BRFSI_RFENV << 16, 0x1);
+
+		/* Set RF_ENV output high */
+		rtl92s_phy_set_bb_reg(hw, pphyreg->rfintfo, BRFSI_RFENV, 0x1);
+
+		/* Set bit number of Address and Data for RF register */
+		rtl92s_phy_set_bb_reg(hw, pphyreg->rfhssi_para2,
+				B3WIRE_ADDRESSLENGTH, 0x0);
+		rtl92s_phy_set_bb_reg(hw, pphyreg->rfhssi_para2,
+				B3WIRE_DATALENGTH, 0x0);
+
+		/* Initialize RF fom connfiguration file */
+		switch (rfpath) {
+		case RF90_PATH_A:
+			rtstatus = rtl92s_phy_config_rf(hw,
+						(enum radio_path)rfpath);
+			break;
+		case RF90_PATH_B:
+			rtstatus = rtl92s_phy_config_rf(hw,
+						(enum radio_path)rfpath);
+			break;
+		case RF90_PATH_C:
+			break;
+		case RF90_PATH_D:
+			break;
+		}
+
+		/* Restore RFENV control type */
+		switch (rfpath) {
+		case RF90_PATH_A:
+		case RF90_PATH_C:
+			rtl92s_phy_set_bb_reg(hw, pphyreg->rfintfs, BRFSI_RFENV,
+					      u4reg_val);
+			break;
+		case RF90_PATH_B:
+		case RF90_PATH_D:
+			rtl92s_phy_set_bb_reg(hw, pphyreg->rfintfs,
+					      BRFSI_RFENV << 16,
+					      u4reg_val);
+			break;
+		}
+
+		if (!rtstatus) {
+			pr_err("Radio[%d] Fail!!\n", rfpath);
+			goto fail;
+		}
+
+	}
+
+	return rtstatus;
+
+fail:
+	return rtstatus;
+}
+
+void rtl92s_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+
+	switch (bandwidth) {
+	case HT_CHANNEL_WIDTH_20:
+		rtlphy->rfreg_chnlval[0] = ((rtlphy->rfreg_chnlval[0] &
+					   0xfffff3ff) | 0x0400);
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_CHNLBW, RFREG_OFFSET_MASK,
+					rtlphy->rfreg_chnlval[0]);
+		break;
+	case HT_CHANNEL_WIDTH_20_40:
+		rtlphy->rfreg_chnlval[0] = ((rtlphy->rfreg_chnlval[0] &
+					    0xfffff3ff));
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_CHNLBW, RFREG_OFFSET_MASK,
+					rtlphy->rfreg_chnlval[0]);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "unknown bandwidth: %#X\n", bandwidth);
+		break;
+	}
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/rf.h b/drivers/net/wireless/rtlwifi/rtl8192su/rf.h
new file mode 100644
index 0000000..bf4c34a
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/rf.h
@@ -0,0 +1,42 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __INC_RTL92S_RF_H
+#define __INC_RTL92S_RF_H
+
+#define	RF6052_MAX_TX_PWR	0x3F
+
+void rtl92s_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw,
+				     u8 bandwidth);
+bool rtl92s_phy_rf6052_config(struct ieee80211_hw *hw) ;
+void rtl92s_phy_rf6052_set_ccktxpower(struct ieee80211_hw *hw,
+				      u8 powerlevel);
+void rtl92s_phy_rf6052_set_ofdmtxpower(struct ieee80211_hw *hw,
+				       u8 *p_pwrlevel, u8 chnl);
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/sw.c b/drivers/net/wireless/rtlwifi/rtl8192su/sw.c
new file mode 100644
index 0000000..45d63a6
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/sw.c
@@ -0,0 +1,546 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ * Joshua Roys <Joshua.Roys@gtri.gatech.edu>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../core.h"
+#include "../usb.h"
+#include "../base.h"
+#include "../efuse.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "dm.h"
+#include "fw.h"
+#include "hw.h"
+#include "sw.h"
+#include "trx.h"
+#include "led.h"
+
+#include <linux/module.h>
+
+MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
+MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
+MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
+MODULE_AUTHOR("Joshua Roys      <Joshua.Roys@gtri.gatech.edu>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Realtek 8192S/8191S 802.11n USB wireless");
+MODULE_FIRMWARE("rtlwifi/rtl8712u.bin");
+
+static void rtl92su_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct ieee80211_hw *hw = context;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rt_firmware *pfirmware = NULL;
+	//int err;
+
+	RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
+			 "Firmware callback routine entered!\n");
+	complete(&rtlpriv->firmware_loading_complete);
+	if (!firmware) {
+		pr_err("Firmware %s not available\n", rtlpriv->cfg->fw_name);
+		rtlpriv->max_fw_size = 0;
+		return;
+	}
+	if (firmware->size > rtlpriv->max_fw_size) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Firmware is too big!\n");
+		rtlpriv->max_fw_size = 0;
+		release_firmware(firmware);
+		return;
+	}
+	pfirmware = (struct rt_firmware *)rtlpriv->rtlhal.pfirmware;
+	memcpy(pfirmware->sz_fw_tmpbuffer, firmware->data, firmware->size);
+	pfirmware->sz_fw_tmpbufferlen = firmware->size;
+	release_firmware(firmware);
+
+	//rtlusb->irq_enabled = 1;
+	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
+
+	/*init rfkill */
+	//rtl_init_rfkill(hw);
+}
+
+static void rtl92su_modify_ieee80211_ops(struct ieee80211_ops *ops)
+{
+	ops->hw_scan = rtl92s_set_fw_sitesurvey_cmd;
+}
+
+static int rtl92su_init_sw_vars(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+	int err = 0;
+	u16 earlyrxthreshold = 7;
+
+	hw->wiphy->max_scan_ssids = 1;
+
+	rtlpriv->dm.dm_initialgain_enable = true;
+	rtlpriv->dm.dm_flag = 0;
+	rtlpriv->dm.disable_framebursting = false;
+	rtlpriv->dm.thermalvalue = 0;
+	rtlpriv->dm.useramask = true;
+	//rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	rtlpriv->dbg.global_debuglevel = DBG_TRACE;
+
+	/* compatible 5G band 91su just 2.4G band & smsp */
+	rtlpriv->rtlhal.current_bandtype = BAND_ON_2_4G;
+	rtlpriv->rtlhal.bandset = BAND_ON_2_4G;
+	rtlpriv->rtlhal.macphymode = SINGLEMAC_SINGLEPHY;
+
+	mac->rx_conf =
+			RCR_APPFCS |
+			RCR_APWRMGT |
+			/*RCR_ADD3 |*/
+			RCR_AMF	|
+			RCR_ADF |
+			RCR_APP_MIC |
+			RCR_APP_ICV |
+			RCR_AICV |
+			/* Accept ICV error, CRC32 Error */
+			RCR_ACRC32 |
+			RCR_AB |
+			/* Accept Broadcast, Multicast */
+			RCR_AM	|
+			/* Accept Physical match */
+			RCR_APM |
+			/* Accept Destination Address packets */
+			/*RCR_AAP |*/
+			RCR_APP_PHYST_STAFF |
+			/* Accept PHY status */
+			RCR_APP_PHYST_RXFF |
+			RCR_RX_TCPOFDL_EN |
+			(earlyrxthreshold << RCR_FIFO_OFFSET);
+
+	rtlusb->irq_mask[0] = (u32)
+			(IMR_ROK |
+			IMR_VODOK |
+			IMR_VIDOK |
+			IMR_BEDOK |
+			IMR_BKDOK |
+			IMR_HCCADOK |
+			IMR_MGNTDOK |
+			IMR_COMDOK |
+			IMR_HIGHDOK |
+			IMR_BDOK |
+			IMR_RXCMDOK |
+			/*IMR_TIMEOUT0 |*/
+			IMR_RDU |
+			IMR_RXFOVW	|
+			IMR_BCNINT
+			/*| IMR_TXFOVW*/
+			/*| IMR_TBDOK |
+			IMR_TBDER*/);
+
+	rtlusb->irq_mask[1] = (u32) 0;
+
+	/* for LPS & IPS */
+	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
+	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
+	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
+	if (!rtlpriv->psc.inactiveps)
+		pr_info("Power Save off (module option)\n");
+	if (!rtlpriv->psc.fwctrl_lps)
+		pr_info("FW Power Save off (module option)\n");
+	rtlpriv->psc.reg_fwctrl_lps = 3;
+	rtlpriv->psc.reg_max_lps_awakeintvl = 5;
+
+	if (rtlpriv->psc.reg_fwctrl_lps == 1)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_MIN_MODE;
+	else if (rtlpriv->psc.reg_fwctrl_lps == 2)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_MAX_MODE;
+	else if (rtlpriv->psc.reg_fwctrl_lps == 3)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
+
+	/* for firmware buf */
+	rtlpriv->rtlhal.pfirmware = vzalloc(sizeof(struct rt_firmware));
+	if (!rtlpriv->rtlhal.pfirmware)
+		return 1;
+
+	rtlpriv->max_fw_size = RTL8192_MAX_RAW_FIRMWARE_CODE_SIZE;
+
+	pr_info("Driver for Realtek RTL8192SU/RTL8191SU/RTL8188SU\n"
+		"Loading firmware %s\n", rtlpriv->cfg->fw_name);
+	/* request fw */
+	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl92su_fw_cb);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Failed to request firmware!\n");
+		return 1;
+	}
+
+	return err;
+}
+
+static void rtl92su_deinit_sw_vars(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->rtlhal.pfirmware) {
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
+	}
+}
+
+static struct rtl_hal_ops rtl8192su_hal_ops = {
+	.modify_ieee80211_ops = rtl92su_modify_ieee80211_ops,
+	.init_sw_vars = rtl92su_init_sw_vars,
+	.deinit_sw_vars = rtl92su_deinit_sw_vars,
+	.read_chip_version = rtl92su_read_chip_version,
+	.read_eeprom_info = rtl92su_read_eeprom_info,
+	.interrupt_recognized = rtl92su_interrupt_recognized,
+	.hw_init = rtl92su_hw_init,
+	.hw_disable = rtl92su_card_disable,
+	//.hw_suspend = rtl92su_suspend,
+	//.hw_resume = rtl92su_resume,
+	.enable_interrupt = rtl92su_enable_interrupt,
+	.disable_interrupt = rtl92su_disable_interrupt,
+	.set_network_type = rtl92su_set_network_type,
+	.set_chk_bssid = rtl92su_set_check_bssid,
+	.set_qos = rtl92su_set_qos,
+	.set_bcn_reg = rtl92su_set_beacon_related_registers,
+	.set_bcn_intv = rtl92su_set_beacon_interval,
+	.update_interrupt_mask = rtl92su_update_interrupt_mask,
+	.get_hw_reg = rtl92su_get_hw_reg,
+	.set_hw_reg = rtl92su_set_hw_reg,
+	.update_rate_tbl = rtl92su_update_hal_rate_tbl,
+	.fill_tx_desc = rtl92su_tx_fill_desc,
+	.fill_tx_cmddesc = rtl92su_tx_fill_cmddesc,
+	.query_rx_desc = rtl92su_rx_query_desc,
+	.set_channel_access = rtl92su_update_channel_access_setting,
+	.radio_onoff_checking = rtl92su_gpio_radio_on_off_checking,
+	.set_bw_mode = rtl92s_phy_set_bw_mode,
+	//.switch_channel = rtl92s_phy_sw_chnl,
+	.switch_channel = rtl92s_set_fw_setchannel_cmd,
+	.dm_watchdog = rtl92s_dm_watchdog,
+	.scan_operation_backup = rtl92s_phy_scan_operation_backup,
+	.set_rf_power_state = rtl92s_phy_set_rf_power_state,
+	.led_control = rtl92su_led_control,
+	//.set_desc = rtl92su_set_desc,
+	//.get_desc = rtl92su_get_desc,
+	//.tx_polling = rtl92su_tx_polling,
+	.enable_hw_sec = rtl92su_enable_hw_security_config,
+	.set_key = rtl92su_set_key,
+	.init_sw_leds = rtl92su_init_sw_leds,
+	.deinit_sw_leds = rtl92su_deinit_sw_leds,
+	.get_bbreg = rtl92s_phy_query_bb_reg,
+	.set_bbreg = rtl92s_phy_set_bb_reg,
+	.get_rfreg = rtl92s_phy_query_rf_reg,
+	.set_rfreg = rtl92s_phy_set_rf_reg,
+};
+
+static struct rtl_mod_params rtl92su_mod_params = {
+	.sw_crypto = false,
+	.inactiveps = false,
+	.swctrl_lps = false,
+	.fwctrl_lps = false,
+	.debug = DBG_TRACE,
+};
+
+static struct rtl_hal_usbint_cfg rtl92su_interface_cfg = {
+	/* rx */
+	.in_ep_num = RTL92S_USB_BULK_IN_NUM,
+	.rx_urb_num = RTL92S_NUM_RX_URBS,
+	.rx_max_size = RTL92S_SIZE_MAX_RX_BUFFER,
+	.usb_rx_hdl = rtl8192su_rx_hdl,
+	.usb_rx_segregate_hdl = NULL, /* rtl8192s_rx_segregate_hdl; */
+	/* tx */
+	.usb_tx_cleanup = rtl8192s_tx_cleanup,
+	.usb_tx_post_hdl = rtl8192s_tx_post_hdl,
+	.usb_tx_aggregate_hdl = rtl8192s_tx_aggregate_hdl,
+	/* endpoint mapping */
+	.usb_endpoint_mapping = rtl8192su_endpoint_mapping,
+	.usb_mq_to_hwq = rtl8192su_mq_to_hwq,
+};
+
+static struct rtl_hal_cfg rtl92su_hal_cfg = {
+	.name = "rtl92s_usb",
+	.fw_name = "rtlwifi/rtl8712u.bin",
+	.ops = &rtl8192su_hal_ops,
+	.mod_params = &rtl92su_mod_params,
+	.usb_interface_cfg = &rtl92su_interface_cfg,
+
+	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
+	.maps[SYS_FUNC_EN] = REG_SYS_FUNC_EN,
+	.maps[SYS_CLK] = SYS_CLKR,
+	.maps[MAC_RCR_AM] = RCR_AM,
+	.maps[MAC_RCR_AB] = RCR_AB,
+	.maps[MAC_RCR_ACRC32] = RCR_ACRC32,
+	.maps[MAC_RCR_ACF] = RCR_ACF,
+	.maps[MAC_RCR_AAP] = RCR_AAP,
+
+	.maps[EFUSE_TEST] = REG_EFUSE_TEST,
+	.maps[EFUSE_CTRL] = REG_EFUSE_CTRL,
+	.maps[EFUSE_CLK] = REG_EFUSE_CLK,
+	.maps[EFUSE_CLK_CTRL] = REG_EFUSE_CTRL,
+	.maps[EFUSE_PWC_EV12V] = 0,
+	.maps[EFUSE_FEN_ELDR] = 0,
+	.maps[EFUSE_LOADER_CLK_EN] = 0,
+	.maps[EFUSE_ANA8M] = EFUSE_ANA8M,
+	.maps[EFUSE_HWSET_MAX_SIZE] = HWSET_MAX_SIZE_92S,
+	.maps[EFUSE_MAX_SECTION_MAP] = EFUSE_MAX_SECTION,
+	.maps[EFUSE_REAL_CONTENT_SIZE] = EFUSE_REAL_CONTENT_LEN,
+	.maps[EFUSE_OOB_PROTECT_BYTES_LEN] = EFUSE_OOB_PROTECT_BYTES,
+
+	.maps[RWCAM] = REG_RWCAM,
+	.maps[WCAMI] = REG_WCAMI,
+	.maps[RCAMO] = REG_RCAMO,
+	.maps[CAMDBG] = REG_CAMDBG,
+	.maps[SECR] = REG_SECR,
+	.maps[SEC_CAM_NONE] = CAM_NONE,
+	.maps[SEC_CAM_WEP40] = CAM_WEP40,
+	.maps[SEC_CAM_TKIP] = CAM_TKIP,
+	.maps[SEC_CAM_AES] = CAM_AES,
+	.maps[SEC_CAM_WEP104] = CAM_WEP104,
+
+	.maps[RTL_IMR_BCNDMAINT6] = IMR_BCNDMAINT6,
+	.maps[RTL_IMR_BCNDMAINT5] = IMR_BCNDMAINT5,
+	.maps[RTL_IMR_BCNDMAINT4] = IMR_BCNDMAINT4,
+	.maps[RTL_IMR_BCNDMAINT3] = IMR_BCNDMAINT3,
+	.maps[RTL_IMR_BCNDMAINT2] = IMR_BCNDMAINT2,
+	.maps[RTL_IMR_BCNDMAINT1] = IMR_BCNDMAINT1,
+	.maps[RTL_IMR_BCNDOK8] = IMR_BCNDOK8,
+	.maps[RTL_IMR_BCNDOK7] = IMR_BCNDOK7,
+	.maps[RTL_IMR_BCNDOK6] = IMR_BCNDOK6,
+	.maps[RTL_IMR_BCNDOK5] = IMR_BCNDOK5,
+	.maps[RTL_IMR_BCNDOK4] = IMR_BCNDOK4,
+	.maps[RTL_IMR_BCNDOK3] = IMR_BCNDOK3,
+	.maps[RTL_IMR_BCNDOK2] = IMR_BCNDOK2,
+	.maps[RTL_IMR_BCNDOK1] = IMR_BCNDOK1,
+	.maps[RTL_IMR_TIMEOUT2] = IMR_TIMEOUT2,
+	.maps[RTL_IMR_TIMEOUT1] = IMR_TIMEOUT1,
+
+	.maps[RTL_IMR_TXFOVW] = IMR_TXFOVW,
+	.maps[RTL_IMR_PSTIMEOUT] = IMR_PSTIMEOUT,
+	.maps[RTL_IMR_BcnInt] = IMR_BCNINT,
+	.maps[RTL_IMR_RXFOVW] = IMR_RXFOVW,
+	.maps[RTL_IMR_RDU] = IMR_RDU,
+	.maps[RTL_IMR_ATIMEND] = IMR_ATIMEND,
+	.maps[RTL_IMR_BDOK] = IMR_BDOK,
+	.maps[RTL_IMR_MGNTDOK] = IMR_MGNTDOK,
+	.maps[RTL_IMR_TBDER] = IMR_TBDER,
+	.maps[RTL_IMR_HIGHDOK] = IMR_HIGHDOK,
+	.maps[RTL_IMR_COMDOK] = IMR_COMDOK,
+	.maps[RTL_IMR_TBDOK] = IMR_TBDOK,
+	.maps[RTL_IMR_BKDOK] = IMR_BKDOK,
+	.maps[RTL_IMR_BEDOK] = IMR_BEDOK,
+	.maps[RTL_IMR_VIDOK] = IMR_VIDOK,
+	.maps[RTL_IMR_VODOK] = IMR_VODOK,
+	.maps[RTL_IMR_ROK] = IMR_ROK,
+	.maps[RTL_IBSS_INT_MASKS] = (IMR_BCNINT | IMR_TBDOK | IMR_TBDER),
+
+	.maps[RTL_RC_CCK_RATE1M] = DESC92_RATE1M,
+	.maps[RTL_RC_CCK_RATE2M] = DESC92_RATE2M,
+	.maps[RTL_RC_CCK_RATE5_5M] = DESC92_RATE5_5M,
+	.maps[RTL_RC_CCK_RATE11M] = DESC92_RATE11M,
+	.maps[RTL_RC_OFDM_RATE6M] = DESC92_RATE6M,
+	.maps[RTL_RC_OFDM_RATE9M] = DESC92_RATE9M,
+	.maps[RTL_RC_OFDM_RATE12M] = DESC92_RATE12M,
+	.maps[RTL_RC_OFDM_RATE18M] = DESC92_RATE18M,
+	.maps[RTL_RC_OFDM_RATE24M] = DESC92_RATE24M,
+	.maps[RTL_RC_OFDM_RATE36M] = DESC92_RATE36M,
+	.maps[RTL_RC_OFDM_RATE48M] = DESC92_RATE48M,
+	.maps[RTL_RC_OFDM_RATE54M] = DESC92_RATE54M,
+
+	.maps[RTL_RC_HT_RATEMCS7] = DESC92_RATEMCS7,
+	.maps[RTL_RC_HT_RATEMCS15] = DESC92_RATEMCS15,
+};
+
+module_param_named(swenc, rtl92su_mod_params.sw_crypto, bool, 0444);
+module_param_named(debug, rtl92su_mod_params.debug, int, 0444);
+//module_param_named(ips, rtl92su_mod_params.inactiveps, bool, 0444);
+//module_param_named(swlps, rtl92su_mod_params.swctrl_lps, bool, 0444);
+//module_param_named(fwlps, rtl92su_mod_params.fwctrl_lps, bool, 0444);
+MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)");
+MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+//MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)");
+//MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)");
+//MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)");
+
+#define USB_VENDER_ID_REALTEK		0x0bda
+
+static struct usb_device_id rtl8192s_usb_ids[] = {
+
+/* RTL8188SU */
+	/* Realtek */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8171, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8173, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8712, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8713, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0xC512, rtl92su_hal_cfg)},
+	/* Abocom */
+	{RTL_USB_DEVICE(0x07B8, 0x8188, rtl92su_hal_cfg)},
+	/* ASUS */
+	{RTL_USB_DEVICE(0x0B05, 0x1786, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0B05, 0x1791, rtl92su_hal_cfg)}, /* 11n mode disable */
+	/* Belkin */
+	{RTL_USB_DEVICE(0x050D, 0x945A, rtl92su_hal_cfg)},
+	/* Corega */
+	{RTL_USB_DEVICE(0x07AA, 0x0047, rtl92su_hal_cfg)},
+	/* D-Link */
+	{RTL_USB_DEVICE(0x2001, 0x3306, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x07D1, 0x3306, rtl92su_hal_cfg)}, /* 11n mode disable */
+	/* Edimax */
+	{RTL_USB_DEVICE(0x7392, 0x7611, rtl92su_hal_cfg)},
+	/* EnGenius */
+	{RTL_USB_DEVICE(0x1740, 0x9603, rtl92su_hal_cfg)},
+	/* Hawking */
+	{RTL_USB_DEVICE(0x0E66, 0x0016, rtl92su_hal_cfg)},
+	/* Hercules */
+	{RTL_USB_DEVICE(0x06F8, 0xE034, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x06F8, 0xE032, rtl92su_hal_cfg)},
+	/* Logitec */
+	{RTL_USB_DEVICE(0x0789, 0x0167, rtl92su_hal_cfg)},
+	/* PCI */
+	{RTL_USB_DEVICE(0x2019, 0xAB28, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x2019, 0xED16, rtl92su_hal_cfg)},
+	/* Sitecom */
+	{RTL_USB_DEVICE(0x0DF6, 0x0057, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x0045, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x0059, rtl92su_hal_cfg)}, /* 11n mode disable */
+	{RTL_USB_DEVICE(0x0DF6, 0x004B, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x005B, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x005D, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x0063, rtl92su_hal_cfg)},
+	/* Sweex */
+	{RTL_USB_DEVICE(0x177F, 0x0154, rtl92su_hal_cfg)},
+	/* Thinkware */
+	{RTL_USB_DEVICE(0x0BDA, 0x5077, rtl92su_hal_cfg)},
+	/* Toshiba */
+	{RTL_USB_DEVICE(0x1690, 0x0752, rtl92su_hal_cfg)},
+	/* - */
+	{RTL_USB_DEVICE(0x20F4, 0x646B, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x083A, 0xC512, rtl92su_hal_cfg)},
+
+/* RTL8191SU */
+	/* Realtek */
+	{RTL_USB_DEVICE(0x0BDA, 0x8172, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0BDA, 0x8192, rtl92su_hal_cfg)},
+	/* Amigo */
+	{RTL_USB_DEVICE(0x0EB0, 0x9061, rtl92su_hal_cfg)},
+	/* ASUS/EKB */
+	{RTL_USB_DEVICE(0x13D3, 0x3323, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x13D3, 0x3311, rtl92su_hal_cfg)}, /* 11n mode disable */
+	{RTL_USB_DEVICE(0x13D3, 0x3342, rtl92su_hal_cfg)},
+	/* ASUS/EKBLenovo */
+	{RTL_USB_DEVICE(0x13D3, 0x3333, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x13D3, 0x3334, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x13D3, 0x3335, rtl92su_hal_cfg)}, /* 11n mode disable */
+	{RTL_USB_DEVICE(0x13D3, 0x3336, rtl92su_hal_cfg)}, /* 11n mode disable */
+	/* ASUS/Media BOX */
+	{RTL_USB_DEVICE(0x13D3, 0x3309, rtl92su_hal_cfg)},
+	/* Belkin */
+	{RTL_USB_DEVICE(0x050D, 0x815F, rtl92su_hal_cfg)},
+	/* D-Link */
+	{RTL_USB_DEVICE(0x07D1, 0x3302, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x07D1, 0x3300, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x07D1, 0x3303, rtl92su_hal_cfg)},
+	/* Edimax */
+	{RTL_USB_DEVICE(0x7392, 0x7612, rtl92su_hal_cfg)},
+	/* EnGenius */
+	{RTL_USB_DEVICE(0x1740, 0x9605, rtl92su_hal_cfg)},
+	/* Guillemot */
+	{RTL_USB_DEVICE(0x06F8, 0xE031, rtl92su_hal_cfg)},
+	/* Hawking */
+	{RTL_USB_DEVICE(0x0E66, 0x0015, rtl92su_hal_cfg)},
+	/* Mediao */
+	{RTL_USB_DEVICE(0x13D3, 0x3306, rtl92su_hal_cfg)},
+	/* PCI */
+	{RTL_USB_DEVICE(0x2019, 0xED18, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x2019, 0x4901, rtl92su_hal_cfg)},
+	/* Sitecom */
+	{RTL_USB_DEVICE(0x0DF6, 0x0058, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x0049, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x004C, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x0DF6, 0x0064, rtl92su_hal_cfg)},
+	/* Skyworth */
+	{RTL_USB_DEVICE(0x14b2, 0x3300, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x14b2, 0x3301, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x14B2, 0x3302, rtl92su_hal_cfg)},
+	/* - */
+	{RTL_USB_DEVICE(0x04F2, 0xAFF2, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x04F2, 0xAFF5, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x04F2, 0xAFF6, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x13D3, 0x3339, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x13D3, 0x3340, rtl92su_hal_cfg)}, /* 11n mode disable */
+	{RTL_USB_DEVICE(0x13D3, 0x3341, rtl92su_hal_cfg)}, /* 11n mode disable */
+	{RTL_USB_DEVICE(0x13D3, 0x3310, rtl92su_hal_cfg)},
+	{RTL_USB_DEVICE(0x13D3, 0x3325, rtl92su_hal_cfg)},
+
+/* RTL8192SU */
+	/* Realtek */
+	{RTL_USB_DEVICE(0x0BDA, 0x8174, rtl92su_hal_cfg)},
+	/* Belkin */
+	{RTL_USB_DEVICE(0x050D, 0x845A, rtl92su_hal_cfg)},
+	/* Corega */
+	{RTL_USB_DEVICE(0x07AA, 0x0051, rtl92su_hal_cfg)},
+	/* Edimax */
+	{RTL_USB_DEVICE(0x7392, 0x7622, rtl92su_hal_cfg)},
+	/* NEC */
+	{RTL_USB_DEVICE(0x0409, 0x02B6, rtl92su_hal_cfg)},
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, rtl8192s_usb_ids);
+
+static struct usb_driver rtl8192su_driver = {
+	.name = "rtl8192su",
+	.probe = rtl_usb_probe,
+	.disconnect = rtl_usb_disconnect,
+	.id_table = rtl8192s_usb_ids,
+
+#ifdef CONFIG_PM
+	/* .suspend = rtl_usb_suspend, */
+	/* .resume = rtl_usb_resume, */
+	/* .reset_resume = rtl8192c_resume, */
+#endif /* CONFIG_PM */
+#ifdef CONFIG_AUTOSUSPEND
+	.supports_autosuspend = 1,
+#endif
+};
+
+#if 1
+static int __init rtl8192su_init(void)
+{
+	return usb_register(&rtl8192su_driver);
+}
+
+static void __exit rtl8192su_exit(void)
+{
+	usb_deregister(&rtl8192su_driver);
+}
+
+module_init(rtl8192su_init);
+module_exit(rtl8192su_exit);
+#else
+module_usb_driver(rtl8192su_driver);
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/sw.h b/drivers/net/wireless/rtlwifi/rtl8192su/sw.h
new file mode 100644
index 0000000..5b9b553
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/sw.h
@@ -0,0 +1,36 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_PCI92SE_SW_H__
+#define __REALTEK_PCI92SE_SW_H__
+
+#define EFUSE_MAX_SECTION	16
+
+int rtl92su_init_sw(struct ieee80211_hw *hw);
+void rtl92su_deinit_sw(struct ieee80211_hw *hw);
+void rtl92su_init_var_map(struct ieee80211_hw *hw);
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/table.c b/drivers/net/wireless/rtlwifi/rtl8192su/table.c
new file mode 100644
index 0000000..9295208
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/table.c
@@ -0,0 +1,633 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Created on  2010/ 5/18,  1:41
+ *****************************************************************************/
+
+#include "table.h"
+
+u32 rtl8192sephy_reg_2t2rarray[PHY_REG_2T2RARRAYLENGTH] = {
+	0x01c, 0x07000000,
+	0x800, 0x00040000,
+	0x804, 0x00008003,
+	0x808, 0x0000fc00,
+	0x80c, 0x0000000a,
+	0x810, 0x10005088,
+	0x814, 0x020c3d10,
+	0x818, 0x00200185,
+	0x81c, 0x00000000,
+	0x820, 0x01000000,
+	0x824, 0x00390004,
+	0x828, 0x01000000,
+	0x82c, 0x00390004,
+	0x830, 0x00000004,
+	0x834, 0x00690200,
+	0x838, 0x00000004,
+	0x83c, 0x00690200,
+	0x840, 0x00010000,
+	0x844, 0x00010000,
+	0x848, 0x00000000,
+	0x84c, 0x00000000,
+	0x850, 0x00000000,
+	0x854, 0x00000000,
+	0x858, 0x48484848,
+	0x85c, 0x65a965a9,
+	0x860, 0x0f7f0130,
+	0x864, 0x0f7f0130,
+	0x868, 0x0f7f0130,
+	0x86c, 0x0f7f0130,
+	0x870, 0x03000700,
+	0x874, 0x03000300,
+	0x878, 0x00020002,
+	0x87c, 0x004f0201,
+	0x880, 0xa8300ac1,
+	0x884, 0x00000058,
+	0x888, 0x00000008,
+	0x88c, 0x00000004,
+	0x890, 0x00000000,
+	0x894, 0xfffffffe,
+	0x898, 0x40302010,
+	0x89c, 0x00706050,
+	0x8b0, 0x00000000,
+	0x8e0, 0x00000000,
+	0x8e4, 0x00000000,
+	0xe00, 0x30333333,
+	0xe04, 0x2a2d2e2f,
+	0xe08, 0x00003232,
+	0xe10, 0x30333333,
+	0xe14, 0x2a2d2e2f,
+	0xe18, 0x30333333,
+	0xe1c, 0x2a2d2e2f,
+	0xe30, 0x01007c00,
+	0xe34, 0x01004800,
+	0xe38, 0x1000dc1f,
+	0xe3c, 0x10008c1f,
+	0xe40, 0x021400a0,
+	0xe44, 0x281600a0,
+	0xe48, 0xf8000001,
+	0xe4c, 0x00002910,
+	0xe50, 0x01007c00,
+	0xe54, 0x01004800,
+	0xe58, 0x1000dc1f,
+	0xe5c, 0x10008c1f,
+	0xe60, 0x021400a0,
+	0xe64, 0x281600a0,
+	0xe6c, 0x00002910,
+	0xe70, 0x31ed92fb,
+	0xe74, 0x361536fb,
+	0xe78, 0x361536fb,
+	0xe7c, 0x361536fb,
+	0xe80, 0x361536fb,
+	0xe84, 0x000d92fb,
+	0xe88, 0x000d92fb,
+	0xe8c, 0x31ed92fb,
+	0xed0, 0x31ed92fb,
+	0xed4, 0x31ed92fb,
+	0xed8, 0x000d92fb,
+	0xedc, 0x000d92fb,
+	0xee0, 0x000d92fb,
+	0xee4, 0x015e5448,
+	0xee8, 0x21555448,
+	0x900, 0x00000000,
+	0x904, 0x00000023,
+	0x908, 0x00000000,
+	0x90c, 0x01121313,
+	0xa00, 0x00d047c8,
+	0xa04, 0x80ff0008,
+	0xa08, 0x8ccd8300,
+	0xa0c, 0x2e62120f,
+	0xa10, 0x9500bb78,
+	0xa14, 0x11144028,
+	0xa18, 0x00881117,
+	0xa1c, 0x89140f00,
+	0xa20, 0x1a1b0000,
+	0xa24, 0x090e1317,
+	0xa28, 0x00000204,
+	0xa2c, 0x10d30000,
+	0xc00, 0x40071d40,
+	0xc04, 0x00a05633,
+	0xc08, 0x000000e4,
+	0xc0c, 0x6c6c6c6c,
+	0xc10, 0x08800000,
+	0xc14, 0x40000100,
+	0xc18, 0x08000000,
+	0xc1c, 0x40000100,
+	0xc20, 0x08000000,
+	0xc24, 0x40000100,
+	0xc28, 0x08000000,
+	0xc2c, 0x40000100,
+	0xc30, 0x6de9ac44,
+	0xc34, 0x469652cf,
+	0xc38, 0x49795994,
+	0xc3c, 0x0a979764,
+	0xc40, 0x1f7c403f,
+	0xc44, 0x000100b7,
+	0xc48, 0xec020000,
+	0xc4c, 0x007f037f,
+	0xc50, 0x69543420,
+	0xc54, 0x433c0094,
+	0xc58, 0x69543420,
+	0xc5c, 0x433c0094,
+	0xc60, 0x69543420,
+	0xc64, 0x433c0094,
+	0xc68, 0x69543420,
+	0xc6c, 0x433c0094,
+	0xc70, 0x2c7f000d,
+	0xc74, 0x0186155b,
+	0xc78, 0x0000001f,
+	0xc7c, 0x00b91612,
+	0xc80, 0x40000100,
+	0xc84, 0x20f60000,
+	0xc88, 0x20000080,
+	0xc8c, 0x20200000,
+	0xc90, 0x40000100,
+	0xc94, 0x00000000,
+	0xc98, 0x40000100,
+	0xc9c, 0x00000000,
+	0xca0, 0x00492492,
+	0xca4, 0x00000000,
+	0xca8, 0x00000000,
+	0xcac, 0x00000000,
+	0xcb0, 0x00000000,
+	0xcb4, 0x00000000,
+	0xcb8, 0x00000000,
+	0xcbc, 0x28000000,
+	0xcc0, 0x00000000,
+	0xcc4, 0x00000000,
+	0xcc8, 0x00000000,
+	0xccc, 0x00000000,
+	0xcd0, 0x00000000,
+	0xcd4, 0x00000000,
+	0xcd8, 0x64b22427,
+	0xcdc, 0x00766932,
+	0xce0, 0x00222222,
+	0xce4, 0x00000000,
+	0xce8, 0x37644302,
+	0xcec, 0x2f97d40c,
+	0xd00, 0x00000750,
+	0xd04, 0x00000403,
+	0xd08, 0x0000907f,
+	0xd0c, 0x00000001,
+	0xd10, 0xa0633333,
+	0xd14, 0x33333c63,
+	0xd18, 0x6a8f5b6b,
+	0xd1c, 0x00000000,
+	0xd20, 0x00000000,
+	0xd24, 0x00000000,
+	0xd28, 0x00000000,
+	0xd2c, 0xcc979975,
+	0xd30, 0x00000000,
+	0xd34, 0x00000000,
+	0xd38, 0x00000000,
+	0xd3c, 0x00027293,
+	0xd40, 0x00000000,
+	0xd44, 0x00000000,
+	0xd48, 0x00000000,
+	0xd50, 0x6437140a,
+	0xd54, 0x024dbd02,
+	0xd58, 0x00000000,
+	0xd5c, 0x30032064,
+	0xd60, 0x4653de68,
+	0xd64, 0x00518a3c,
+	0xd68, 0x00002101,
+	0xf14, 0x00000003,
+	0xf4c, 0x00000000,
+	0xf00, 0x00000300,
+};
+
+u32 rtl8192sephy_changeto_1t1rarray[PHY_CHANGETO_1T1RARRAYLENGTH] = {
+	0x844, 0xffffffff, 0x00010000,
+	0x804, 0x0000000f, 0x00000001,
+	0x824, 0x00f0000f, 0x00300004,
+	0x82c, 0x00f0000f, 0x00100002,
+	0x870, 0x04000000, 0x00000001,
+	0x864, 0x00000400, 0x00000000,
+	0x878, 0x000f000f, 0x00000002,
+	0xe74, 0x0f000000, 0x00000002,
+	0xe78, 0x0f000000, 0x00000002,
+	0xe7c, 0x0f000000, 0x00000002,
+	0xe80, 0x0f000000, 0x00000002,
+	0x90c, 0x000000ff, 0x00000011,
+	0xc04, 0x000000ff, 0x00000011,
+	0xd04, 0x0000000f, 0x00000001,
+	0x1f4, 0xffff0000, 0x00007777,
+	0x234, 0xf8000000, 0x0000000a,
+};
+
+u32 rtl8192sephy_changeto_1t2rarray[PHY_CHANGETO_1T2RARRAYLENGTH] = {
+	0x804, 0x0000000f, 0x00000003,
+	0x824, 0x00f0000f, 0x00300004,
+	0x82c, 0x00f0000f, 0x00300002,
+	0x870, 0x04000000, 0x00000001,
+	0x864, 0x00000400, 0x00000000,
+	0x878, 0x000f000f, 0x00000002,
+	0xe74, 0x0f000000, 0x00000002,
+	0xe78, 0x0f000000, 0x00000002,
+	0xe7c, 0x0f000000, 0x00000002,
+	0xe80, 0x0f000000, 0x00000002,
+	0x90c, 0x000000ff, 0x00000011,
+	0xc04, 0x000000ff, 0x00000033,
+	0xd04, 0x0000000f, 0x00000003,
+	0x1f4, 0xffff0000, 0x00007777,
+	0x234, 0xf8000000, 0x0000000a,
+};
+
+u32 rtl8192sephy_reg_array_pg[PHY_REG_ARRAY_PGLENGTH] = {
+	0xe00, 0xffffffff, 0x06090909,
+	0xe04, 0xffffffff, 0x00030406,
+	0xe08, 0x0000ff00, 0x00000000,
+	0xe10, 0xffffffff, 0x0a0c0d0e,
+	0xe14, 0xffffffff, 0x04070809,
+	0xe18, 0xffffffff, 0x0a0c0d0e,
+	0xe1c, 0xffffffff, 0x04070809,
+	0xe00, 0xffffffff, 0x04040404,
+	0xe04, 0xffffffff, 0x00020204,
+	0xe08, 0x0000ff00, 0x00000000,
+	0xe10, 0xffffffff, 0x02040404,
+	0xe14, 0xffffffff, 0x00000002,
+	0xe18, 0xffffffff, 0x02040404,
+	0xe1c, 0xffffffff, 0x00000002,
+	0xe00, 0xffffffff, 0x04040404,
+	0xe04, 0xffffffff, 0x00020204,
+	0xe08, 0x0000ff00, 0x00000000,
+	0xe10, 0xffffffff, 0x02040404,
+	0xe14, 0xffffffff, 0x00000002,
+	0xe18, 0xffffffff, 0x02040404,
+	0xe1c, 0xffffffff, 0x00000002,
+	0xe00, 0xffffffff, 0x02020202,
+	0xe04, 0xffffffff, 0x00020202,
+	0xe08, 0x0000ff00, 0x00000000,
+	0xe10, 0xffffffff, 0x02020202,
+	0xe14, 0xffffffff, 0x00000002,
+	0xe18, 0xffffffff, 0x02020202,
+	0xe1c, 0xffffffff, 0x00000002,
+};
+
+u32 rtl8192seradioa_1t_array[RADIOA_1T_ARRAYLENGTH] = {
+	0x000, 0x00030159,
+	0x001, 0x00030250,
+	0x002, 0x00010000,
+	0x010, 0x0008000f,
+	0x011, 0x000231fc,
+	0x010, 0x000c000f,
+	0x011, 0x0003f9f8,
+	0x010, 0x0002000f,
+	0x011, 0x00020101,
+	0x014, 0x0001093e,
+	0x014, 0x0009093e,
+	0x015, 0x0000f8f4,
+	0x017, 0x000f6500,
+	0x01a, 0x00013056,
+	0x01b, 0x00060000,
+	0x01c, 0x00000300,
+	0x01e, 0x00031059,
+	0x021, 0x00054000,
+	0x022, 0x0000083c,
+	0x023, 0x00001558,
+	0x024, 0x00000060,
+	0x025, 0x00022583,
+	0x026, 0x0000f200,
+	0x027, 0x000eacf1,
+	0x028, 0x0009bd54,
+	0x029, 0x00004582,
+	0x02a, 0x00000001,
+	0x02b, 0x00021334,
+	0x02a, 0x00000000,
+	0x02b, 0x0000000a,
+	0x02a, 0x00000001,
+	0x02b, 0x00000808,
+	0x02b, 0x00053333,
+	0x02c, 0x0000000c,
+	0x02a, 0x00000002,
+	0x02b, 0x00000808,
+	0x02b, 0x0005b333,
+	0x02c, 0x0000000d,
+	0x02a, 0x00000003,
+	0x02b, 0x00000808,
+	0x02b, 0x00063333,
+	0x02c, 0x0000000d,
+	0x02a, 0x00000004,
+	0x02b, 0x00000808,
+	0x02b, 0x0006b333,
+	0x02c, 0x0000000d,
+	0x02a, 0x00000005,
+	0x02b, 0x00000709,
+	0x02b, 0x00053333,
+	0x02c, 0x0000000d,
+	0x02a, 0x00000006,
+	0x02b, 0x00000709,
+	0x02b, 0x0005b333,
+	0x02c, 0x0000000d,
+	0x02a, 0x00000007,
+	0x02b, 0x00000709,
+	0x02b, 0x00063333,
+	0x02c, 0x0000000d,
+	0x02a, 0x00000008,
+	0x02b, 0x00000709,
+	0x02b, 0x0006b333,
+	0x02c, 0x0000000d,
+	0x02a, 0x00000009,
+	0x02b, 0x0000060a,
+	0x02b, 0x00053333,
+	0x02c, 0x0000000d,
+	0x02a, 0x0000000a,
+	0x02b, 0x0000060a,
+	0x02b, 0x0005b333,
+	0x02c, 0x0000000d,
+	0x02a, 0x0000000b,
+	0x02b, 0x0000060a,
+	0x02b, 0x00063333,
+	0x02c, 0x0000000d,
+	0x02a, 0x0000000c,
+	0x02b, 0x0000060a,
+	0x02b, 0x0006b333,
+	0x02c, 0x0000000d,
+	0x02a, 0x0000000d,
+	0x02b, 0x0000050b,
+	0x02b, 0x00053333,
+	0x02c, 0x0000000d,
+	0x02a, 0x0000000e,
+	0x02b, 0x0000050b,
+	0x02b, 0x00066623,
+	0x02c, 0x0000001a,
+	0x02a, 0x000e4000,
+	0x030, 0x00020000,
+	0x031, 0x000b9631,
+	0x032, 0x0000130d,
+	0x033, 0x00000187,
+	0x013, 0x00019e6c,
+	0x013, 0x00015e94,
+	0x000, 0x00010159,
+	0x018, 0x0000f401,
+	0x0fe, 0x00000000,
+	0x01e, 0x0003105b,
+	0x0fe, 0x00000000,
+	0x000, 0x00030159,
+	0x010, 0x0004000f,
+	0x011, 0x000203f9,
+};
+
+u32 rtl8192seradiob_array[RADIOB_ARRAYLENGTH] = {
+	0x000, 0x00030159,
+	0x001, 0x00001041,
+	0x002, 0x00011000,
+	0x005, 0x00080fc0,
+	0x007, 0x000fc803,
+	0x013, 0x00017cb0,
+	0x013, 0x00011cc0,
+	0x013, 0x0000dc60,
+	0x013, 0x00008c60,
+	0x013, 0x00004450,
+	0x013, 0x00000020,
+};
+
+u32 rtl8192seradiob_gm_array[RADIOB_GM_ARRAYLENGTH] = {
+	0x000, 0x00030159,
+	0x001, 0x00001041,
+	0x002, 0x00011000,
+	0x005, 0x00080fc0,
+	0x007, 0x000fc803,
+};
+
+u32 rtl8192semac_2t_array[MAC_2T_ARRAYLENGTH] = {
+	0x020, 0x00000035,
+	0x048, 0x0000000e,
+	0x049, 0x000000f0,
+	0x04a, 0x00000077,
+	0x04b, 0x00000083,
+	0x0b5, 0x00000021,
+	0x0dc, 0x000000ff,
+	0x0dd, 0x000000ff,
+	0x0de, 0x000000ff,
+	0x0df, 0x000000ff,
+	0x116, 0x00000000,
+	0x117, 0x00000000,
+	0x118, 0x00000000,
+	0x119, 0x00000000,
+	0x11a, 0x00000000,
+	0x11b, 0x00000000,
+	0x11c, 0x00000000,
+	0x11d, 0x00000000,
+	0x160, 0x0000000b,
+	0x161, 0x0000000b,
+	0x162, 0x0000000b,
+	0x163, 0x0000000b,
+	0x164, 0x0000000b,
+	0x165, 0x0000000b,
+	0x166, 0x0000000b,
+	0x167, 0x0000000b,
+	0x168, 0x0000000b,
+	0x169, 0x0000000b,
+	0x16a, 0x0000000b,
+	0x16b, 0x0000000b,
+	0x16c, 0x0000000b,
+	0x16d, 0x0000000b,
+	0x16e, 0x0000000b,
+	0x16f, 0x0000000b,
+	0x170, 0x0000000b,
+	0x171, 0x0000000b,
+	0x172, 0x0000000b,
+	0x173, 0x0000000b,
+	0x174, 0x0000000b,
+	0x175, 0x0000000b,
+	0x176, 0x0000000b,
+	0x177, 0x0000000b,
+	0x178, 0x0000000b,
+	0x179, 0x0000000b,
+	0x17a, 0x0000000b,
+	0x17b, 0x0000000b,
+	0x17c, 0x0000000b,
+	0x17d, 0x0000000b,
+	0x17e, 0x0000000b,
+	0x17f, 0x0000000b,
+	0x236, 0x0000000c,
+	0x503, 0x00000022,
+	0x560, 0x00000000,
+};
+
+u32 rtl8192seagctab_array[AGCTAB_ARRAYLENGTH] = {
+	0xc78, 0x7f000001,
+	0xc78, 0x7f010001,
+	0xc78, 0x7e020001,
+	0xc78, 0x7d030001,
+	0xc78, 0x7c040001,
+	0xc78, 0x7b050001,
+	0xc78, 0x7a060001,
+	0xc78, 0x79070001,
+	0xc78, 0x78080001,
+	0xc78, 0x77090001,
+	0xc78, 0x760a0001,
+	0xc78, 0x750b0001,
+	0xc78, 0x740c0001,
+	0xc78, 0x730d0001,
+	0xc78, 0x720e0001,
+	0xc78, 0x710f0001,
+	0xc78, 0x70100001,
+	0xc78, 0x6f110001,
+	0xc78, 0x6f120001,
+	0xc78, 0x6e130001,
+	0xc78, 0x6d140001,
+	0xc78, 0x6d150001,
+	0xc78, 0x6c160001,
+	0xc78, 0x6b170001,
+	0xc78, 0x6a180001,
+	0xc78, 0x6a190001,
+	0xc78, 0x691a0001,
+	0xc78, 0x681b0001,
+	0xc78, 0x671c0001,
+	0xc78, 0x661d0001,
+	0xc78, 0x651e0001,
+	0xc78, 0x641f0001,
+	0xc78, 0x63200001,
+	0xc78, 0x4c210001,
+	0xc78, 0x4b220001,
+	0xc78, 0x4a230001,
+	0xc78, 0x49240001,
+	0xc78, 0x48250001,
+	0xc78, 0x47260001,
+	0xc78, 0x46270001,
+	0xc78, 0x45280001,
+	0xc78, 0x44290001,
+	0xc78, 0x2c2a0001,
+	0xc78, 0x2b2b0001,
+	0xc78, 0x2a2c0001,
+	0xc78, 0x292d0001,
+	0xc78, 0x282e0001,
+	0xc78, 0x272f0001,
+	0xc78, 0x26300001,
+	0xc78, 0x25310001,
+	0xc78, 0x24320001,
+	0xc78, 0x23330001,
+	0xc78, 0x22340001,
+	0xc78, 0x09350001,
+	0xc78, 0x08360001,
+	0xc78, 0x07370001,
+	0xc78, 0x06380001,
+	0xc78, 0x05390001,
+	0xc78, 0x043a0001,
+	0xc78, 0x033b0001,
+	0xc78, 0x023c0001,
+	0xc78, 0x013d0001,
+	0xc78, 0x003e0001,
+	0xc78, 0x003f0001,
+	0xc78, 0x7f400001,
+	0xc78, 0x7f410001,
+	0xc78, 0x7e420001,
+	0xc78, 0x7d430001,
+	0xc78, 0x7c440001,
+	0xc78, 0x7b450001,
+	0xc78, 0x7a460001,
+	0xc78, 0x79470001,
+	0xc78, 0x78480001,
+	0xc78, 0x77490001,
+	0xc78, 0x764a0001,
+	0xc78, 0x754b0001,
+	0xc78, 0x744c0001,
+	0xc78, 0x734d0001,
+	0xc78, 0x724e0001,
+	0xc78, 0x714f0001,
+	0xc78, 0x70500001,
+	0xc78, 0x6f510001,
+	0xc78, 0x6f520001,
+	0xc78, 0x6e530001,
+	0xc78, 0x6d540001,
+	0xc78, 0x6d550001,
+	0xc78, 0x6c560001,
+	0xc78, 0x6b570001,
+	0xc78, 0x6a580001,
+	0xc78, 0x6a590001,
+	0xc78, 0x695a0001,
+	0xc78, 0x685b0001,
+	0xc78, 0x675c0001,
+	0xc78, 0x665d0001,
+	0xc78, 0x655e0001,
+	0xc78, 0x645f0001,
+	0xc78, 0x63600001,
+	0xc78, 0x4c610001,
+	0xc78, 0x4b620001,
+	0xc78, 0x4a630001,
+	0xc78, 0x49640001,
+	0xc78, 0x48650001,
+	0xc78, 0x47660001,
+	0xc78, 0x46670001,
+	0xc78, 0x45680001,
+	0xc78, 0x44690001,
+	0xc78, 0x2c6a0001,
+	0xc78, 0x2b6b0001,
+	0xc78, 0x2a6c0001,
+	0xc78, 0x296d0001,
+	0xc78, 0x286e0001,
+	0xc78, 0x276f0001,
+	0xc78, 0x26700001,
+	0xc78, 0x25710001,
+	0xc78, 0x24720001,
+	0xc78, 0x23730001,
+	0xc78, 0x22740001,
+	0xc78, 0x09750001,
+	0xc78, 0x08760001,
+	0xc78, 0x07770001,
+	0xc78, 0x06780001,
+	0xc78, 0x05790001,
+	0xc78, 0x047a0001,
+	0xc78, 0x037b0001,
+	0xc78, 0x027c0001,
+	0xc78, 0x017d0001,
+	0xc78, 0x007e0001,
+	0xc78, 0x007f0001,
+	0xc78, 0x3000001e,
+	0xc78, 0x3001001e,
+	0xc78, 0x3002001e,
+	0xc78, 0x3003001e,
+	0xc78, 0x3004001e,
+	0xc78, 0x3405001e,
+	0xc78, 0x3806001e,
+	0xc78, 0x3e07001e,
+	0xc78, 0x3e08001e,
+	0xc78, 0x4409001e,
+	0xc78, 0x460a001e,
+	0xc78, 0x480b001e,
+	0xc78, 0x480c001e,
+	0xc78, 0x4e0d001e,
+	0xc78, 0x560e001e,
+	0xc78, 0x5a0f001e,
+	0xc78, 0x5e10001e,
+	0xc78, 0x6211001e,
+	0xc78, 0x6c12001e,
+	0xc78, 0x7213001e,
+	0xc78, 0x7214001e,
+	0xc78, 0x7215001e,
+	0xc78, 0x7216001e,
+	0xc78, 0x7217001e,
+	0xc78, 0x7218001e,
+	0xc78, 0x7219001e,
+	0xc78, 0x721a001e,
+	0xc78, 0x721b001e,
+	0xc78, 0x721c001e,
+	0xc78, 0x721d001e,
+	0xc78, 0x721e001e,
+	0xc78, 0x721f001e,
+};
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/table.h b/drivers/net/wireless/rtlwifi/rtl8192su/table.h
new file mode 100644
index 0000000..df5b861
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/table.h
@@ -0,0 +1,48 @@
+/******************************************************************************
+ * Copyright(c) 2008 - 2012 Realtek Corporation. All rights reserved.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
+#ifndef __INC_HAL8192SE_FW_IMG_H
+#define __INC_HAL8192SE_FW_IMG_H
+
+#include <linux/types.h>
+
+/*Created on  2010/ 4/12,  5:56*/
+
+#define PHY_REG_2T2RARRAYLENGTH 372
+extern u32 rtl8192sephy_reg_2t2rarray[PHY_REG_2T2RARRAYLENGTH];
+#define PHY_CHANGETO_1T1RARRAYLENGTH 48
+extern u32 rtl8192sephy_changeto_1t1rarray[PHY_CHANGETO_1T1RARRAYLENGTH];
+#define PHY_CHANGETO_1T2RARRAYLENGTH 45
+extern u32 rtl8192sephy_changeto_1t2rarray[PHY_CHANGETO_1T2RARRAYLENGTH];
+#define PHY_REG_ARRAY_PGLENGTH 84
+extern u32 rtl8192sephy_reg_array_pg[PHY_REG_ARRAY_PGLENGTH];
+#define RADIOA_1T_ARRAYLENGTH 202
+extern u32 rtl8192seradioa_1t_array[RADIOA_1T_ARRAYLENGTH];
+#define RADIOB_ARRAYLENGTH 22
+extern u32 rtl8192seradiob_array[RADIOB_ARRAYLENGTH];
+#define RADIOB_GM_ARRAYLENGTH 10
+extern u32 rtl8192seradiob_gm_array[RADIOB_GM_ARRAYLENGTH];
+#define MAC_2T_ARRAYLENGTH 106
+extern u32 rtl8192semac_2t_array[MAC_2T_ARRAYLENGTH];
+#define AGCTAB_ARRAYLENGTH 320
+extern u32 rtl8192seagctab_array[AGCTAB_ARRAYLENGTH];
+
+#endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/trx.c b/drivers/net/wireless/rtlwifi/rtl8192su/trx.c
new file mode 100644
index 0000000..67abf79
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/trx.c
@@ -0,0 +1,1089 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../usb.h"
+#include "../ps.h"
+#include "../base.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "fw.h"
+#include "trx.h"
+#include "led.h"
+#include "rf.h"
+#include "dm.h"
+
+static void _ThreeOutEpMapping(struct rtl_ep_map *ep_map)
+{
+	ep_map->ep_mapping[RTL_TXQ_BK]	= 0x06;
+	ep_map->ep_mapping[RTL_TXQ_BE]	= 0x06;
+	ep_map->ep_mapping[RTL_TXQ_VI]	= 0x04;
+	ep_map->ep_mapping[RTL_TXQ_VO]	= 0x04;
+	ep_map->ep_mapping[RTL_TXQ_MGT] = 0x0d;
+	ep_map->ep_mapping[RTL_TXQ_BCN] = 0x0d;
+	ep_map->ep_mapping[RTL_TXQ_HI]	= 0x0d;
+}
+
+static void _FiveOutEpMapping(struct rtl_ep_map *ep_map)
+{
+	ep_map->ep_mapping[RTL_TXQ_BK]	= 0x07;
+	ep_map->ep_mapping[RTL_TXQ_BE]	= 0x06;
+	ep_map->ep_mapping[RTL_TXQ_VI]	= 0x05;
+	ep_map->ep_mapping[RTL_TXQ_VO]	= 0x04;
+	ep_map->ep_mapping[RTL_TXQ_MGT] = 0x0d;
+	ep_map->ep_mapping[RTL_TXQ_BCN] = 0x0d;
+	ep_map->ep_mapping[RTL_TXQ_HI]	= 0x0d;
+}
+
+static void _EightOutEpMapping(struct rtl_ep_map *ep_map)
+{
+	ep_map->ep_mapping[RTL_TXQ_BK]	= 0x07;
+	ep_map->ep_mapping[RTL_TXQ_BE]	= 0x06;
+	ep_map->ep_mapping[RTL_TXQ_VI]	= 0x05;
+	ep_map->ep_mapping[RTL_TXQ_VO]  = 0x04;
+	ep_map->ep_mapping[RTL_TXQ_MGT] = 0x0c;
+	ep_map->ep_mapping[RTL_TXQ_BCN] = 0x0a;
+	ep_map->ep_mapping[RTL_TXQ_HI]	= 0x0b;
+}
+
+/* endpoint mapping */
+int rtl8192su_endpoint_mapping(struct ieee80211_hw *hw)
+{
+	struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
+	struct rtl_ep_map *ep_map = &(rtlusb->ep_map);
+
+	rtlusb->in_ep = 0x03;
+	switch (rtlusb->out_ep_nums) {
+	case 3:
+		_ThreeOutEpMapping(ep_map);
+		break;
+	case 5:
+		_FiveOutEpMapping(ep_map);
+		break;
+	case 8:
+		_EightOutEpMapping(ep_map);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+u16 rtl8192su_mq_to_hwq(__le16 fc, u16 mac80211_queue_index)
+{
+	u16 hw_queue_index;
+
+	if (unlikely(ieee80211_is_beacon(fc))) {
+		hw_queue_index = RTL_TXQ_BCN;
+		goto out;
+	}
+	if (ieee80211_is_mgmt(fc)) {
+		hw_queue_index = RTL_TXQ_MGT;
+		goto out;
+	}
+	switch (mac80211_queue_index) {
+	case 0:
+		hw_queue_index = RTL_TXQ_VO;
+		break;
+	case 1:
+		hw_queue_index = RTL_TXQ_VI;
+		break;
+	case 2:
+		hw_queue_index = RTL_TXQ_BE;
+		break;
+	case 3:
+		hw_queue_index = RTL_TXQ_BK;
+		break;
+	default:
+		hw_queue_index = RTL_TXQ_BE;
+		RT_ASSERT(false, "QSLT_BE queue, skb_queue:%d\n",
+			  mac80211_queue_index);
+		break;
+	}
+out:
+	return hw_queue_index;
+}
+
+static u8 _rtl92se_map_hwqueue_to_fwqueue(struct sk_buff *skb,	u8 skb_queue)
+{
+	__le16 fc = rtl_get_fc(skb);
+
+	if (unlikely(ieee80211_is_beacon(fc)))
+		return QSLT_BEACON;
+	if (ieee80211_is_mgmt(fc))
+		return QSLT_MGNT;
+	if (ieee80211_is_nullfunc(fc))
+		return QSLT_HIGH;
+
+	return skb->priority;
+}
+
+#if 0
+/* rtl8712_recv.c query_rx_pwr_percentage */
+static u8 _rtl92s_query_rxpwrpercentage(char antpower)
+{
+	if ((antpower <= -100) || (antpower >= 20))
+		return 0;
+	else if (antpower >= 0)
+		return 100;
+	else
+		return 100 + antpower;
+}
+
+/* rtl8712_recv.c evm_db2percentage */
+static u8 _rtl92s_evm_db_to_percentage(char value)
+{
+	char ret_val;
+	ret_val = value;
+
+	if (ret_val >= 0)
+		ret_val = 0;
+
+	if (ret_val <= -33)
+		ret_val = -33;
+
+	ret_val = 0 - ret_val;
+	ret_val *= 3;
+
+	if (ret_val == 99)
+		ret_val = 100;
+
+	return ret_val;
+}
+
+static long _rtl92se_translate_todbm(struct ieee80211_hw *hw,
+				     u8 signal_strength_index)
+{
+	long signal_power;
+
+	signal_power = (long)((signal_strength_index + 1) >> 1);
+	signal_power -= 95;
+	return signal_power;
+}
+
+/* rtl8712_recv.c r8712_signal_scale_mapping */
+static long _rtl92se_signal_scale_mapping(struct ieee80211_hw *hw,
+		long currsig)
+{
+	long retsig = 0;
+
+	/* Step 1. Scale mapping. */
+	if (currsig > 47)
+		retsig = 100;
+	else if (currsig > 14 && currsig <= 47)
+		retsig = 100 - ((47 - currsig) * 3) / 2;
+	else if (currsig > 2 && currsig <= 14)
+		retsig = 48 - ((14 - currsig) * 15) / 7;
+	else if (currsig >= 0)
+		retsig = currsig * 9 + 1;
+
+	return retsig;
+}
+
+/* rtl8712_recv.c query_rx_phy_status */
+static void _rtl92se_query_rxphystatus(struct ieee80211_hw *hw,
+				       struct rtl_stats *pstats, u8 *pdesc,
+				       struct rx_fwinfo *p_drvinfo,
+				       bool packet_match_bssid,
+				       bool packet_toself,
+				       bool packet_beacon)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct phy_sts_cck_8192s_t *cck_buf;
+	s8 rx_pwr_all = 0, rx_pwr[4];
+	u8 rf_rx_num = 0, evm, pwdb_all;
+	u8 i, max_spatial_stream;
+	u32 rssi, total_rssi = 0;
+	bool in_powersavemode = false;
+	bool is_cck = pstats->is_cck;
+
+	pstats->packet_matchbssid = packet_match_bssid;
+	pstats->packet_toself = packet_toself;
+	pstats->packet_beacon = packet_beacon;
+	pstats->rx_mimo_signalquality[0] = -1;
+	pstats->rx_mimo_signalquality[1] = -1;
+
+	if (is_cck) {
+		u8 report, cck_highpwr;
+		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
+
+		if (!in_powersavemode)
+			cck_highpwr = (u8) rtl_get_bbreg(hw,
+						RFPGA0_XA_HSSIPARAMETER2,
+						0x200);
+		else
+			cck_highpwr = false;
+
+		if (!cck_highpwr) {
+			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+			report = cck_buf->cck_agc_rpt & 0xc0;
+			report = report >> 6;
+			switch (report) {
+			case 0x3:
+				rx_pwr_all = -40 - (cck_agc_rpt & 0x3e);
+				break;
+			case 0x2:
+				rx_pwr_all = -20 - (cck_agc_rpt & 0x3e);
+				break;
+			case 0x1:
+				rx_pwr_all = -2 - (cck_agc_rpt & 0x3e);
+				break;
+			case 0x0:
+				rx_pwr_all = 14 - (cck_agc_rpt & 0x3e);
+				break;
+			}
+		} else {
+			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+			report = p_drvinfo->cfosho[0] & 0x60;
+			report = report >> 5;
+			switch (report) {
+			case 0x3:
+				rx_pwr_all = -40 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			case 0x2:
+				rx_pwr_all = -20 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			case 0x1:
+				rx_pwr_all = -2 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			case 0x0:
+				rx_pwr_all = 14 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			}
+		}
+
+		pwdb_all = _rtl92s_query_rxpwrpercentage(rx_pwr_all);
+
+		/* CCK gain is smaller than OFDM/MCS gain,  */
+		/* so we add gain diff by experiences, the val is 6 */
+		pwdb_all += 6;
+		if (pwdb_all > 100)
+			pwdb_all = 100;
+		/* modify the offset to make the same gain index with OFDM. */
+		if (pwdb_all > 34 && pwdb_all <= 42)
+			pwdb_all -= 2;
+		else if (pwdb_all > 26 && pwdb_all <= 34)
+			pwdb_all -= 6;
+		else if (pwdb_all > 14 && pwdb_all <= 26)
+			pwdb_all -= 8;
+		else if (pwdb_all > 4 && pwdb_all <= 14)
+			pwdb_all -= 4;
+
+		pstats->rx_pwdb_all = pwdb_all;
+		pstats->recvsignalpower = rx_pwr_all;
+
+		if (packet_match_bssid) {
+			u8 sq;
+			if (pstats->rx_pwdb_all > 40) {
+				sq = 100;
+			} else {
+				sq = cck_buf->sq_rpt;
+				if (sq > 64)
+					sq = 0;
+				else if (sq < 20)
+					sq = 100;
+				else
+					sq = ((64 - sq) * 100) / 44;
+			}
+
+			pstats->signalquality = sq;
+			pstats->rx_mimo_signalquality[0] = sq;
+			pstats->rx_mimo_signalquality[1] = -1;
+		}
+	} else {
+		rtlpriv->dm.rfpath_rxenable[0] =
+		    rtlpriv->dm.rfpath_rxenable[1] = true;
+		for (i = RF90_PATH_A; i < RF90_PATH_MAX; i++) {
+			if (rtlpriv->dm.rfpath_rxenable[i])
+				rf_rx_num++;
+
+			rx_pwr[i] = ((p_drvinfo->gain_trsw[i] &
+				    0x3f) * 2) - 110;
+			rssi = _rtl92s_query_rxpwrpercentage(rx_pwr[i]);
+			total_rssi += rssi;
+			rtlpriv->stats.rx_snr_db[i] =
+					 (long)(p_drvinfo->rxsnr[i] / 2);
+
+			if (packet_match_bssid)
+				pstats->rx_mimo_signalstrength[i] = (u8) rssi;
+		}
+
+		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
+		pwdb_all = _rtl92s_query_rxpwrpercentage(rx_pwr_all);
+		pstats->rx_pwdb_all = pwdb_all;
+		pstats->rxpower = rx_pwr_all;
+		pstats->recvsignalpower = rx_pwr_all;
+
+		if (pstats->is_ht && pstats->rate >= DESC92_RATEMCS8 &&
+		    pstats->rate <= DESC92_RATEMCS15)
+			max_spatial_stream = 2;
+		else
+			max_spatial_stream = 1;
+
+		for (i = 0; i < max_spatial_stream; i++) {
+			evm = _rtl92s_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+
+			if (packet_match_bssid) {
+				if (i == 0)
+					pstats->signalquality = (u8)(evm &
+								 0xff);
+				pstats->rx_mimo_signalquality[i] =
+							 (u8) (evm & 0xff);
+			}
+		}
+	}
+
+	if (is_cck)
+		pstats->signalstrength = (u8)(_rtl92se_signal_scale_mapping(hw,
+					 pwdb_all));
+	else if (rf_rx_num != 0)
+		pstats->signalstrength = (u8) (_rtl92se_signal_scale_mapping(hw,
+				total_rssi /= rf_rx_num));
+}
+
+/* rtl8712_recv.c process_rssi */
+static void _rtl92se_process_ui_rssi(struct ieee80211_hw *hw,
+				     struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u8 rfpath;
+	u32 last_rssi, tmpval;
+
+	if (pstats->packet_toself || pstats->packet_beacon) {
+		rtlpriv->stats.rssi_calculate_cnt++;
+
+		if (rtlpriv->stats.ui_rssi.total_num++ >=
+		    PHY_RSSI_SLID_WIN_MAX) {
+			rtlpriv->stats.ui_rssi.total_num =
+					 PHY_RSSI_SLID_WIN_MAX;
+			last_rssi = rtlpriv->stats.ui_rssi.elements[
+				rtlpriv->stats.ui_rssi.index];
+			rtlpriv->stats.ui_rssi.total_val -= last_rssi;
+		}
+
+		rtlpriv->stats.ui_rssi.total_val += pstats->signalstrength;
+		rtlpriv->stats.ui_rssi.elements[rtlpriv->stats.ui_rssi.index++]
+			 = pstats->signalstrength;
+
+		if (rtlpriv->stats.ui_rssi.index >= PHY_RSSI_SLID_WIN_MAX)
+			rtlpriv->stats.ui_rssi.index = 0;
+
+		tmpval = rtlpriv->stats.ui_rssi.total_val /
+			rtlpriv->stats.ui_rssi.total_num;
+		rtlpriv->stats.signal_strength = _rtl92se_translate_todbm(hw,
+								(u8) tmpval);
+		pstats->rssi = rtlpriv->stats.signal_strength;
+	}
+
+	if (!pstats->is_cck && pstats->packet_toself) {
+		for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
+		     rfpath++) {
+			if (rtlpriv->stats.rx_rssi_percentage[rfpath] == 0) {
+				rtlpriv->stats.rx_rssi_percentage[rfpath] =
+				    pstats->rx_mimo_signalstrength[rfpath];
+
+			}
+
+			if (pstats->rx_mimo_signalstrength[rfpath] >
+			    rtlpriv->stats.rx_rssi_percentage[rfpath]) {
+				rtlpriv->stats.rx_rssi_percentage[rfpath] =
+				    ((rtlpriv->stats.rx_rssi_percentage[rfpath]
+				    * (RX_SMOOTH_FACTOR - 1)) +
+				    (pstats->rx_mimo_signalstrength[rfpath])) /
+				    (RX_SMOOTH_FACTOR);
+
+				rtlpriv->stats.rx_rssi_percentage[rfpath] =
+				    rtlpriv->stats.rx_rssi_percentage[rfpath]
+				    + 1;
+			} else {
+				rtlpriv->stats.rx_rssi_percentage[rfpath] =
+				    ((rtlpriv->stats.rx_rssi_percentage[rfpath]
+				    * (RX_SMOOTH_FACTOR - 1)) +
+				    (pstats->rx_mimo_signalstrength[rfpath])) /
+				    (RX_SMOOTH_FACTOR);
+			}
+
+		}
+	}
+}
+
+static void _rtl92se_update_rxsignalstatistics(struct ieee80211_hw *hw,
+					       struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int weighting = 0;
+
+	if (rtlpriv->stats.recv_signal_power == 0)
+		rtlpriv->stats.recv_signal_power = pstats->recvsignalpower;
+
+	if (pstats->recvsignalpower > rtlpriv->stats.recv_signal_power)
+		weighting = 5;
+	else if (pstats->recvsignalpower < rtlpriv->stats.recv_signal_power)
+		weighting = (-5);
+
+	rtlpriv->stats.recv_signal_power = (rtlpriv->stats.recv_signal_power * 5
+					   + pstats->recvsignalpower +
+					   weighting) / 6;
+}
+
+static void _rtl92se_process_pwdb(struct ieee80211_hw *hw,
+				  struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	long undec_sm_pwdb = 0;
+
+	if (mac->opmode == NL80211_IFTYPE_ADHOC) {
+		return;
+	} else {
+		undec_sm_pwdb =
+		    rtlpriv->dm.undecorated_smoothed_pwdb;
+	}
+
+	if (pstats->packet_toself || pstats->packet_beacon) {
+		if (undec_sm_pwdb < 0)
+			undec_sm_pwdb = pstats->rx_pwdb_all;
+
+		if (pstats->rx_pwdb_all > (u32) undec_sm_pwdb) {
+			undec_sm_pwdb =
+			    (((undec_sm_pwdb) *
+			    (RX_SMOOTH_FACTOR - 1)) +
+			    (pstats->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
+
+			undec_sm_pwdb = undec_sm_pwdb + 1;
+		} else {
+			undec_sm_pwdb = (((undec_sm_pwdb) *
+			      (RX_SMOOTH_FACTOR - 1)) + (pstats->rx_pwdb_all)) /
+			      (RX_SMOOTH_FACTOR);
+		}
+
+		rtlpriv->dm.undecorated_smoothed_pwdb = undec_sm_pwdb;
+		_rtl92se_update_rxsignalstatistics(hw, pstats);
+	}
+}
+
+static void rtl_92s_process_streams(struct ieee80211_hw *hw,
+				    struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 stream;
+
+	for (stream = 0; stream < 2; stream++) {
+		if (pstats->rx_mimo_signalquality[stream] != -1) {
+			if (rtlpriv->stats.rx_evm_percentage[stream] == 0) {
+				rtlpriv->stats.rx_evm_percentage[stream] =
+				    pstats->rx_mimo_signalquality[stream];
+			}
+
+			rtlpriv->stats.rx_evm_percentage[stream] =
+			    ((rtlpriv->stats.rx_evm_percentage[stream] *
+					(RX_SMOOTH_FACTOR - 1)) +
+			     (pstats->rx_mimo_signalquality[stream] *
+					1)) / (RX_SMOOTH_FACTOR);
+		}
+	}
+}
+
+/* rtl8712_recv.c process_link_qual */
+static void _rtl92se_process_ui_link_quality(struct ieee80211_hw *hw,
+					     struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 last_evm = 0, tmpval;
+
+	if (pstats->signalquality != 0) {
+		if (pstats->packet_toself || pstats->packet_beacon) {
+
+			if (rtlpriv->stats.ui_link_quality.total_num++ >=
+			    PHY_LINKQUALITY_SLID_WIN_MAX) {
+				rtlpriv->stats.ui_link_quality.total_num =
+				    PHY_LINKQUALITY_SLID_WIN_MAX;
+				last_evm =
+				    rtlpriv->stats.ui_link_quality.elements[
+				    rtlpriv->stats.ui_link_quality.index];
+				rtlpriv->stats.ui_link_quality.total_val -=
+				    last_evm;
+			}
+
+			rtlpriv->stats.ui_link_quality.total_val +=
+			    pstats->signalquality;
+			rtlpriv->stats.ui_link_quality.elements[
+				rtlpriv->stats.ui_link_quality.index++] =
+			    pstats->signalquality;
+
+			if (rtlpriv->stats.ui_link_quality.index >=
+			    PHY_LINKQUALITY_SLID_WIN_MAX)
+				rtlpriv->stats.ui_link_quality.index = 0;
+
+			tmpval = rtlpriv->stats.ui_link_quality.total_val /
+			    rtlpriv->stats.ui_link_quality.total_num;
+			rtlpriv->stats.signal_quality = tmpval;
+
+			rtlpriv->stats.last_sigstrength_inpercent = tmpval;
+
+			rtl_92s_process_streams(hw, pstats);
+
+		}
+	}
+}
+
+/* rtl8712_recv.c process_phy_info */
+static void _rtl92se_process_phyinfo(struct ieee80211_hw *hw,
+				     u8 *buffer,
+				     struct rtl_stats *pcurrent_stats)
+{
+
+	if (!pcurrent_stats->packet_matchbssid &&
+	    !pcurrent_stats->packet_beacon)
+		return;
+
+	_rtl92se_process_ui_rssi(hw, pcurrent_stats);
+	_rtl92se_process_pwdb(hw, pcurrent_stats);
+	_rtl92se_process_ui_link_quality(hw, pcurrent_stats);
+}
+
+static void _rtl92se_translate_rx_signal_stuff(struct ieee80211_hw *hw,
+		struct sk_buff *skb, struct rtl_stats *pstats,
+		u8 *pdesc, struct rx_fwinfo *p_drvinfo)
+{
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+
+	struct ieee80211_hdr *hdr;
+	u8 *tmp_buf;
+	u8 *praddr;
+	__le16 fc;
+	u16 type, cfc;
+	bool packet_matchbssid, packet_toself, packet_beacon;
+
+	tmp_buf = skb->data + pstats->rx_drvinfo_size + pstats->rx_bufshift;
+
+	hdr = (struct ieee80211_hdr *)tmp_buf;
+	fc = hdr->frame_control;
+	cfc = le16_to_cpu(fc);
+	type = WLAN_FC_GET_TYPE(fc);
+	praddr = hdr->addr1;
+
+	packet_matchbssid = ((IEEE80211_FTYPE_CTL != type) &&
+	     (!compare_ether_addr(mac->bssid, (cfc & IEEE80211_FCTL_TODS) ?
+			hdr->addr1 : (cfc & IEEE80211_FCTL_FROMDS) ?
+			hdr->addr2 : hdr->addr3)) && (!pstats->hwerror) &&
+			(!pstats->crc) && (!pstats->icv));
+
+	packet_toself = packet_matchbssid &&
+	    (!compare_ether_addr(praddr, rtlefuse->dev_addr));
+
+	if (ieee80211_is_beacon(fc))
+		packet_beacon = true;
+
+	_rtl92se_query_rxphystatus(hw, pstats, pdesc, p_drvinfo,
+			packet_matchbssid, packet_toself, packet_beacon);
+	_rtl92se_process_phyinfo(hw, tmp_buf, pstats);
+}
+#endif
+
+/* r8712_signal_scale_mapping from rtl8712_recv.c */
+static s32 rtl92s_signal_scale_mapping(s32 cur_sig)
+{
+	s32 ret_sig;
+
+	if (cur_sig >= 51 && cur_sig <= 100)
+		ret_sig = 100;
+	else if (cur_sig >= 41 && cur_sig <= 50)
+		ret_sig = 80 + ((cur_sig - 40) * 2);
+	else if (cur_sig >= 31 && cur_sig <= 40)
+		ret_sig = 66 + (cur_sig - 30);
+	else if (cur_sig >= 21 && cur_sig <= 30)
+		ret_sig = 54 + (cur_sig - 20);
+	else if (cur_sig >= 10 && cur_sig <= 20)
+		ret_sig = 42 + (((cur_sig - 10) * 2) / 3);
+	else if (cur_sig >= 5 && cur_sig <= 9)
+		ret_sig = 22 + (((cur_sig - 5) * 3) / 2);
+	else if (cur_sig >= 1 && cur_sig <= 4)
+		ret_sig = 6 + (((cur_sig - 1) * 3) / 2);
+	else
+		ret_sig = cur_sig;
+	return ret_sig;
+}
+
+static void _rtl92su_c2h_survey_resp(struct ieee80211_hw *hw, u8 *data)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ndis_wlan_bssid_ex *survey = (struct ndis_wlan_bssid_ex *)data;
+	struct ndis_802_11_fixed_ies *fixed;
+	struct ieee80211_channel *chan;
+	struct cfg80211_bss *bss;
+	u16 caps, beaconint;
+	s32 signal;
+	u32 bssid_len;
+	u64 tsf;
+	int freq;
+	size_t ie_len;
+	u8 *ie;
+
+	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, "Found BSS: %s/%pM, channel %i\n",
+		 survey->ssid.ssid, survey->macaddr, survey->config.dsconfig);
+
+	bssid_len = le32_to_cpu(survey->len);
+
+	if (bssid_len < sizeof(struct ndis_wlan_bssid_ex) +
+			sizeof(struct ndis_802_11_fixed_ies))
+		return;
+
+	fixed = (struct ndis_802_11_fixed_ies *)survey->ies;
+
+	ie = survey->ies + sizeof(struct ndis_802_11_fixed_ies);
+	ie_len = survey->ielen - sizeof(struct ndis_802_11_fixed_ies);
+	if (sizeof(struct ndis_802_11_fixed_ies) > survey->ielen)
+		ie_len = 0;
+
+	freq = ieee80211_channel_to_frequency(survey->config.dsconfig,
+					      IEEE80211_BAND_2GHZ);
+	chan = ieee80211_get_channel(hw->wiphy, freq);
+
+	signal = DBM_TO_MBM(rtl92s_signal_scale_mapping(le32_to_cpu(survey->rssi)));
+	tsf = le64_to_cpu(*(__le64 *)fixed->timestamp);
+	caps = le16_to_cpu(fixed->caps);
+	beaconint = le16_to_cpu(fixed->beaconint);
+
+	bss = cfg80211_inform_bss(hw->wiphy, chan, survey->macaddr, tsf, caps,
+				  beaconint, ie, ie_len, signal, GFP_ATOMIC);
+	cfg80211_put_bss(bss);
+}
+
+void rtl92su_c2h_event(struct ieee80211_hw *hw, u8 *pdesc)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u16 len;
+	u8 evnum, seq;
+	u8 *data;
+	bool frag;
+
+	len = (u16)SHIFT_AND_MASK_LE(pdesc, 0, 16);
+	evnum = (u8)SHIFT_AND_MASK_LE(pdesc, 16, 8);
+	seq = (u8)SHIFT_AND_MASK_LE(pdesc, 24, 7);
+	frag = (bool)SHIFT_AND_MASK_LE(pdesc, 31, 1);
+	data = pdesc + 8;
+
+	//RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "C2H ID:%d len:%u\n", evnum, len);
+
+	switch(evnum) {
+	case 0x08: // SURVEY
+		_rtl92su_c2h_survey_resp(hw, data);
+		break;
+	case 0x09: // SURVEY_DONE
+		ieee80211_scan_completed(hw, false);
+		break;
+	case 0x13: // FWDBG
+		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "fwdbg: %s%s",
+			 data, data[len - 2] == '\n' ? "" : "\n");
+		break;
+
+	default:
+		RT_TRACE(rtlpriv, COMP_FW, DBG_WARNING, "unhandled C2H: %i\n",
+			 evnum);
+		break;
+	}
+}
+
+bool rtl92su_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
+			   struct ieee80211_rx_status *rx_status, u8 *pdesc,
+			   struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+/*
+	struct rx_fwinfo *p_drvinfo;
+	u32 phystatus = (u32)GET_RX_STATUS_DESC_PHY_STATUS(pdesc);
+*/
+	struct ieee80211_hdr *hdr;
+	bool first_ampdu = false;
+
+	stats->length = (u16)GET_RX_STATUS_DESC_PKT_LEN(pdesc);
+	stats->rx_drvinfo_size = (u8)GET_RX_STATUS_DESC_DRVINFO_SIZE(pdesc) * 8;
+	stats->rx_bufshift = (u8)(GET_RX_STATUS_DESC_SHIFT(pdesc) & 0x03);
+	stats->icv = (u16)GET_RX_STATUS_DESC_ICV(pdesc);
+	stats->crc = (u16)GET_RX_STATUS_DESC_CRC32(pdesc);
+	stats->hwerror = (u16)(stats->crc | stats->icv);
+	stats->decrypted = !GET_RX_STATUS_DESC_SWDEC(pdesc);
+
+	stats->rate = (u8)GET_RX_STATUS_DESC_RX_MCS(pdesc);
+	stats->shortpreamble = (u16)GET_RX_STATUS_DESC_SPLCP(pdesc);
+	stats->isampdu = (bool)(GET_RX_STATUS_DESC_PAGGR(pdesc) == 1);
+	stats->isfirst_ampdu = (bool) ((GET_RX_STATUS_DESC_PAGGR(pdesc) == 1)
+			       && (GET_RX_STATUS_DESC_FAGGR(pdesc) == 1));
+	stats->timestamp_low = GET_RX_STATUS_DESC_TSFL(pdesc);
+	stats->rx_is40Mhzpacket = (bool)GET_RX_STATUS_DESC_BW(pdesc);
+	stats->is_ht = (bool)GET_RX_STATUS_DESC_RX_HT(pdesc);
+	stats->is_cck = SE_RX_HAL_IS_CCK_RATE(pdesc);
+
+	if (stats->hwerror)
+		return false;
+
+	if (GET_RX_STATUS_DESC_MACID(pdesc) == 0x1f &&
+	    GET_RX_STATUS_DESC_TID(pdesc) == 0x0f) {
+		/* C2H event */
+		rtl92su_c2h_event(hw, pdesc + RX_STATUS_DESC_SIZE);
+		return false;
+	}
+
+	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.channel->band;
+
+	hdr = (struct ieee80211_hdr *)(skb->data + stats->rx_drvinfo_size
+	      + stats->rx_bufshift);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "DATA fc[%02x] a1[%pM] a2[%pM] a3[%pM]\n",
+		 hdr->frame_control, hdr->addr1, hdr->addr2, hdr->addr3);
+
+	if (stats->crc)
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
+	if (stats->rx_is40Mhzpacket)
+		rx_status->flag |= RX_FLAG_40MHZ;
+
+	if (stats->is_ht)
+		rx_status->flag |= RX_FLAG_HT;
+
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+
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
+
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
+			      stats->is_ht, stats->rate, first_ampdu);
+
+	rx_status->mactime = stats->timestamp_low;
+/*
+	if (phystatus) {
+		p_drvinfo = (struct rx_fwinfo *)(skb->data +
+						 stats->rx_bufshift);
+		// this call currently results in a BUG: scheduling while atomic
+		// _rtl_rx_completed+0x81/0x210
+		// _rtl_usb_rx_process_noagg+0xa8/0x220
+		// rtl92su_rx_query_desc+0x782/0xa60
+		// rtl92s_phy_query_bb_reg+0x63/0xe0
+		// ...
+		_rtl92se_translate_rx_signal_stuff(hw, skb, stats, pdesc,
+						   p_drvinfo);
+	}
+*/
+
+	/*rx_status->qual = stats->signal; */
+	rx_status->signal = stats->rssi + 10;
+	/*rx_status->noise = -stats->noise; */
+
+	return true;
+}
+
+void  rtl8192su_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb)
+{
+	struct ieee80211_rx_status *rx_status =
+		 (struct ieee80211_rx_status *)IEEE80211_SKB_RXCB(skb);
+	u8 *rxdesc;
+	struct rtl_stats stats = {
+		.signal = 0,
+		.noise = -98,
+		.rate = 0,
+	};
+
+	memset(rx_status, 0, sizeof(*rx_status));
+	rxdesc = skb->data;
+	if (rtl92su_rx_query_desc(hw, &stats, rx_status, rxdesc, skb)) {
+		skb_pull(skb, (stats.rx_drvinfo_size + RTL_RX_DESC_SIZE));
+		memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
+		ieee80211_rx_irqsafe(hw, skb);
+	}
+}
+
+/*
+void rtl8192s_rx_segregate_hdl(
+	struct ieee80211_hw *hw,
+	struct sk_buff *skb,
+	struct sk_buff_head *skb_list)
+{
+}
+*/
+
+static void _rtl_fill_usb_tx_desc(u8 *txdesc)
+{
+	SET_TX_DESC_OWN(txdesc, 1);
+	SET_TX_DESC_LAST_SEG(txdesc, 1);
+	SET_TX_DESC_FIRST_SEG(txdesc, 1);
+}
+
+/*
+static void _rtl_tx_desc_checksum(u8 *txdesc)
+{
+	u16 *ptr = (u16 *)txdesc;
+	u16	checksum = 0;
+	u32 index;
+
+	// Clear first
+	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, 0);
+	for (index = 0; index < 16; index++)
+		checksum = checksum ^ (*(ptr + index));
+	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, cpu_to_le16(checksum));
+}
+*/
+
+void rtl92su_tx_fill_desc(struct ieee80211_hw *hw,
+		struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+		struct ieee80211_tx_info *info, struct sk_buff *skb,
+		u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct ieee80211_sta *sta = info->control.sta;
+	u8 *pdesc = (u8 *) pdesc_tx;
+	u16 seq_number;
+	__le16 fc = hdr->frame_control;
+	u8 reserved_macid = 0;
+	u8 fw_qsel = _rtl92se_map_hwqueue_to_fwqueue(skb, hw_queue);
+	u8 bw_40 = 0;
+
+	if (mac->opmode == NL80211_IFTYPE_STATION) {
+		bw_40 = mac->bw_40;
+	} else if (mac->opmode == NL80211_IFTYPE_AP ||
+		mac->opmode == NL80211_IFTYPE_ADHOC) {
+		if (sta)
+			bw_40 = sta->ht_cap.cap &
+				    IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	}
+
+	/* 3 Fill necessary field in First Descriptor */
+	/*DWORD 0*/
+	SET_TX_DESC_LINIP(pdesc, 0);
+	SET_TX_DESC_OFFSET(pdesc, 32);
+	/* fill in packet size before adding pdesc header */
+	SET_TX_DESC_PKT_SIZE(pdesc, (u16) skb->len - RTL_TX_HEADER_SIZE);
+
+	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
+
+	rtl_get_tcb_desc(hw, info, sta, skb, ptcb_desc);
+
+	if (hw_queue == RTL_TXQ_MGT) {
+//		SET_TX_DESC_MACID(pdesc, 0x05);
+//		SET_TX_DESC_QUEUE_SEL(pdesc, fw_qsel);
+		SET_TX_DESC_QUEUE_SEL(pdesc, 0x11); // QSLT_HIGH
+		SET_TX_DESC_SEQ(pdesc, seq_number);
+
+		SET_TX_DESC_USER_RATE(pdesc, 1);
+		SET_TX_DESC_DISABLE_FB(pdesc, 1);
+		SET_TX_DESC_DATA_RATE_FB_LIMIT(pdesc, 0x1f);
+	} else {
+		if (rtlpriv->dm.useramask) {
+			/* set pdesc macId */
+			if (ptcb_desc->mac_id < 32) {
+				SET_TX_DESC_MACID(pdesc, ptcb_desc->mac_id);
+				reserved_macid |= ptcb_desc->mac_id;
+			}
+		}
+		SET_TX_DESC_RSVD_MACID(pdesc, reserved_macid);
+
+		SET_TX_DESC_TXHT(pdesc, ((ptcb_desc->hw_rate >=
+				 DESC92_RATEMCS0) ? 1 : 0));
+
+		if (rtlhal->version == VERSION_8192S_ACUT) {
+			if (ptcb_desc->hw_rate == DESC92_RATE1M ||
+				ptcb_desc->hw_rate  == DESC92_RATE2M ||
+				ptcb_desc->hw_rate == DESC92_RATE5_5M ||
+				ptcb_desc->hw_rate == DESC92_RATE11M) {
+				ptcb_desc->hw_rate = DESC92_RATE12M;
+			}
+		}
+
+		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
+
+		if (ptcb_desc->use_shortgi || ptcb_desc->use_shortpreamble)
+			SET_TX_DESC_TX_SHORT(pdesc, 0);
+
+		/* Aggregation related */
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+			SET_TX_DESC_AGG_ENABLE(pdesc, 1);
+
+		/* For AMPDU, we must insert SSN into TX_DESC */
+		SET_TX_DESC_SEQ(pdesc, seq_number);
+
+		/* Protection mode related */
+		/* For 92S, if RTS/CTS are set, HW will execute RTS. */
+		/* We choose only one protection mode to execute */
+		SET_TX_DESC_RTS_ENABLE(pdesc, ((ptcb_desc->rts_enable &&
+				!ptcb_desc->cts_enable) ? 1 : 0));
+		SET_TX_DESC_CTS_ENABLE(pdesc, ((ptcb_desc->cts_enable) ?
+				       1 : 0));
+		SET_TX_DESC_RTS_STBC(pdesc, ((ptcb_desc->rts_stbc) ? 1 : 0));
+
+		SET_TX_DESC_RTS_RATE(pdesc, ptcb_desc->rts_rate);
+		SET_TX_DESC_RTS_BANDWIDTH(pdesc, 0);
+		SET_TX_DESC_RTS_SUB_CARRIER(pdesc, ptcb_desc->rts_sc);
+		SET_TX_DESC_RTS_SHORT(pdesc, ((ptcb_desc->rts_rate <=
+		       DESC92_RATE54M) ?
+		       (ptcb_desc->rts_use_shortpreamble ? 1 : 0)
+		       : (ptcb_desc->rts_use_shortgi ? 1 : 0)));
+
+
+		/* Set Bandwidth and sub-channel settings. */
+		if (bw_40) {
+			if (ptcb_desc->packet_bw) {
+				SET_TX_DESC_TX_BANDWIDTH(pdesc, 1);
+				/* use duplicated mode */
+				SET_TX_DESC_TX_SUB_CARRIER(pdesc, 0);
+			} else {
+				SET_TX_DESC_TX_BANDWIDTH(pdesc, 0);
+				SET_TX_DESC_TX_SUB_CARRIER(pdesc,
+						   mac->cur_40_prime_sc);
+			}
+		} else {
+			SET_TX_DESC_TX_BANDWIDTH(pdesc, 0);
+			SET_TX_DESC_TX_SUB_CARRIER(pdesc, 0);
+		}
+
+		/*DWORD 1*/
+		SET_TX_DESC_RA_BRSR_ID(pdesc, ptcb_desc->ratr_index);
+
+		/* Fill security related */
+		if (info->control.hw_key) {
+			struct ieee80211_key_conf *keyconf;
+
+			keyconf = info->control.hw_key;
+			switch (keyconf->cipher) {
+			case WLAN_CIPHER_SUITE_WEP40:
+			case WLAN_CIPHER_SUITE_WEP104:
+				SET_TX_DESC_SEC_TYPE(pdesc, 0x1);
+				break;
+			case WLAN_CIPHER_SUITE_TKIP:
+				SET_TX_DESC_SEC_TYPE(pdesc, 0x2);
+				break;
+			case WLAN_CIPHER_SUITE_CCMP:
+				SET_TX_DESC_SEC_TYPE(pdesc, 0x3);
+				break;
+			default:
+				SET_TX_DESC_SEC_TYPE(pdesc, 0x0);
+				break;
+
+			}
+		}
+
+		/* Set Packet ID */
+		SET_TX_DESC_PACKET_ID(pdesc, 0);
+
+		/* We will assign magement queue to BK. */
+		SET_TX_DESC_QUEUE_SEL(pdesc, fw_qsel);
+
+		/* Alwasy enable all rate fallback range */
+		SET_TX_DESC_DATA_RATE_FB_LIMIT(pdesc, 0x1F);
+
+		/* Fix: I don't kown why hw use 6.5M to tx when set it */
+		SET_TX_DESC_USER_RATE(pdesc,
+				      ptcb_desc->use_driver_rate ? 1 : 0);
+
+		/* Set NON_QOS bit. */
+		if (!ieee80211_is_data_qos(fc))
+			SET_TX_DESC_NON_QOS(pdesc, 1);
+
+	}
+
+	_rtl_fill_usb_tx_desc(pdesc);
+	//_rtl_tx_desc_checksum(pdesc);
+
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "\n");
+}
+
+void rtl92su_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
+	bool firstseg, bool lastseg, struct sk_buff *skb)
+{
+	//struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_tcb_desc *tcb_desc = (struct rtl_tcb_desc *)(skb->cb);
+
+	memset((void *)pdesc, 0, RTL_TX_HEADER_SIZE);
+
+	/* This bit indicate this packet is used for FW download. */
+	if (tcb_desc->cmd_or_init == DESC_PACKET_TYPE_INIT) {
+		/* For firmware downlaod we only need to set LINIP */
+		SET_TX_DESC_LINIP(pdesc, tcb_desc->last_inipkt);
+
+		/* 92SE must set as 1 for firmware download HW DMA error */
+		//SET_TX_DESC_FIRST_SEG(pdesc, 1);
+		//SET_TX_DESC_LAST_SEG(pdesc, 1);
+
+		/* 92SE need not to set TX packet size when firmware download */
+		SET_TX_DESC_PKT_SIZE(pdesc, (u16)(skb->len) -
+				     RTL_TX_HEADER_SIZE);
+
+		//SET_TX_DESC_OWN(pdesc, 1);
+	} else { /* H2C Command Desc format (Host TXCMD) */
+		/* 92SE must set as 1 for firmware download HW DMA error */
+		SET_TX_DESC_FIRST_SEG(pdesc, 1);
+		SET_TX_DESC_LAST_SEG(pdesc, 1);
+
+		SET_TX_DESC_OFFSET(pdesc, 0x20);
+
+		/* Buffer size + command header */
+		SET_TX_DESC_PKT_SIZE(pdesc, (u16)(skb->len) -
+				     RTL_TX_HEADER_SIZE);
+		/* Fixed queue of H2C command */
+		SET_TX_DESC_QUEUE_SEL(pdesc, 0x13);
+
+		//SET_BITS_TO_LE_4BYTE(skb->data, 24, 7, rtlhal->h2c_txcmd_seq);
+
+		SET_TX_DESC_OWN(pdesc, 1);
+
+	}
+}
+
+void rtl8192s_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb)
+{
+}
+
+int rtl8192s_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
+			 struct sk_buff *skb)
+{
+	return 0;
+}
+
+struct sk_buff *rtl8192s_tx_aggregate_hdl(struct ieee80211_hw *hw,
+					   struct sk_buff_head *list)
+{
+	return skb_dequeue(list);
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192su/trx.h b/drivers/net/wireless/rtlwifi/rtl8192su/trx.h
new file mode 100644
index 0000000..bb5859e
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192su/trx.h
@@ -0,0 +1,59 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2012  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_PCI92SE_TRX_H__
+#define __REALTEK_PCI92SE_TRX_H__
+
+#define RTL92S_USB_BULK_IN_NUM			1
+#define RTL92S_NUM_RX_URBS			8
+
+#define RTL92S_SIZE_MAX_RX_BUFFER		30720
+#define RX_DRV_INFO_SIZE_UNIT			8
+
+int rtl8192su_endpoint_mapping(struct ieee80211_hw *hw);
+u16 rtl8192su_mq_to_hwq(__le16 fc, u16 mac80211_queue_index);
+bool rtl92su_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
+			   struct ieee80211_rx_status *rx_status, u8 *pdesc,
+			   struct sk_buff *skb);
+void  rtl8192su_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb);
+void rtl8192s_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb);
+int rtl8192s_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
+			 struct sk_buff *skb);
+struct sk_buff *rtl8192s_tx_aggregate_hdl(struct ieee80211_hw *,
+					   struct sk_buff_head *);
+void rtl92su_tx_fill_desc(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
+			  u8 *pdesc, struct ieee80211_tx_info *info,
+			  struct sk_buff *skb, u8 hw_queue,
+			  struct rtl_tcb_desc *ptcb_desc);
+void rtl92su_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc, bool firstseg,
+			     bool lastseg, struct sk_buff *skb);
+void rtl92su_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+u32 rtl92su_get_desc(u8 *pdesc, bool istx, u8 desc_name);
+void rtl92su_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
+
+#endif
-- 
1.7.4.1

