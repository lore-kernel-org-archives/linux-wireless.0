Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6362 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbZEUN20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 09:28:26 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 2/2 V2] iwmc3200wifi: Add new Intel Wireless Multicomm 802.11 driver
Date: Thu, 21 May 2009 21:20:45 +0800
Message-Id: <1242912045-554-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1242912045-554-1-git-send-email-yi.zhu@intel.com>
References: <1242912045-554-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver supports Intel's full MAC wireless multicomm 802.11 hardware.
Although the hardware is a 802.11agn device, we currently only support
802.11ag, in managed and ad-hoc mode (no AP mode for now).

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
V2: adapt to changes in patch 1/2 V2.

 drivers/net/wireless/Kconfig                 |    1 +
 drivers/net/wireless/Makefile                |    2 +
 drivers/net/wireless/iwmc3200wifi/Kconfig    |   23 +
 drivers/net/wireless/iwmc3200wifi/Makefile   |    5 +
 drivers/net/wireless/iwmc3200wifi/bus.h      |   57 +
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |  409 ++++++++
 drivers/net/wireless/iwmc3200wifi/cfg80211.h |   31 +
 drivers/net/wireless/iwmc3200wifi/commands.c |  920 +++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.h |  419 ++++++++
 drivers/net/wireless/iwmc3200wifi/debug.h    |  124 +++
 drivers/net/wireless/iwmc3200wifi/debugfs.c  |  453 ++++++++
 drivers/net/wireless/iwmc3200wifi/eeprom.c   |  187 ++++
 drivers/net/wireless/iwmc3200wifi/eeprom.h   |  114 ++
 drivers/net/wireless/iwmc3200wifi/fw.c       |  388 +++++++
 drivers/net/wireless/iwmc3200wifi/fw.h       |  100 ++
 drivers/net/wireless/iwmc3200wifi/hal.c      |  464 +++++++++
 drivers/net/wireless/iwmc3200wifi/hal.h      |  236 +++++
 drivers/net/wireless/iwmc3200wifi/iwm.h      |  350 +++++++
 drivers/net/wireless/iwmc3200wifi/lmac.h     |  457 ++++++++
 drivers/net/wireless/iwmc3200wifi/main.c     |  680 ++++++++++++
 drivers/net/wireless/iwmc3200wifi/netdev.c   |  172 +++
 drivers/net/wireless/iwmc3200wifi/rfkill.c   |   88 ++
 drivers/net/wireless/iwmc3200wifi/rx.c       | 1431 ++++++++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/rx.h       |   60 ++
 drivers/net/wireless/iwmc3200wifi/sdio.c     |  516 ++++++++++
 drivers/net/wireless/iwmc3200wifi/sdio.h     |   67 ++
 drivers/net/wireless/iwmc3200wifi/tx.c       |  492 +++++++++
 drivers/net/wireless/iwmc3200wifi/umac.h     |  744 +++++++++++++
 drivers/net/wireless/iwmc3200wifi/wext.c     |  723 +++++++++++++
 29 files changed, 9713 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/iwmc3200wifi/Kconfig
 create mode 100644 drivers/net/wireless/iwmc3200wifi/Makefile
 create mode 100644 drivers/net/wireless/iwmc3200wifi/bus.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/cfg80211.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/cfg80211.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/commands.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/commands.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/debug.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/debugfs.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/eeprom.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/eeprom.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/fw.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/fw.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/hal.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/hal.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/iwm.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/lmac.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/main.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/netdev.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/rfkill.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/rx.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/rx.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/sdio.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/sdio.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/tx.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/umac.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/wext.c

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 91be3e7..a67d292 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -501,5 +501,6 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 
 endmenu
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index f2b1861..7a4647e 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -60,3 +60,5 @@ obj-$(CONFIG_ATH_COMMON)	+= ath/
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
 
 obj-$(CONFIG_WL12XX)	+= wl12xx/
+
+obj-$(CONFIG_IWM)	+= iwmc3200wifi/
diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
new file mode 100644
index 0000000..ae84dda
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -0,0 +1,23 @@
+config IWM
+	tristate "Intel Wireless Multicomm 3200 WiFi driver"
+	depends on MMC && WLAN_80211 && EXPERIMENTAL
+	select LIB80211
+	select FW_LOADER
+	select RFKILL
+
+config IWM_DEBUG
+	bool "Enable full debugging output in iwmc3200wifi"
+	depends on IWM && DEBUG_FS
+	---help---
+	  This option will enable debug tracing and setting for iwm
+
+	  You can set the debug level and module through debugfs. By
+	  default all modules are set to the IWL_DL_ERR level.
+	  To see the list of debug modules and levels, see iwm/debug.h
+
+	  For example, if you want the full MLME debug output:
+	  echo 0xff > /debug/iwm/phyN/debug/mlme
+
+	  Or, if you want the full debug, for all modules:
+	  echo 0xff > /debug/iwm/phyN/debug/level
+	  echo 0xff > /debug/iwm/phyN/debug/modules
diff --git a/drivers/net/wireless/iwmc3200wifi/Makefile b/drivers/net/wireless/iwmc3200wifi/Makefile
new file mode 100644
index 0000000..7cb415e
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_IWM) := iwmc3200wifi.o
+iwmc3200wifi-objs += main.o netdev.o rx.o tx.o sdio.o hal.o fw.o
+iwmc3200wifi-objs += commands.o wext.o cfg80211.o eeprom.o rfkill.o
+
+iwmc3200wifi-$(CONFIG_IWM_DEBUG) += debugfs.o
diff --git a/drivers/net/wireless/iwmc3200wifi/bus.h b/drivers/net/wireless/iwmc3200wifi/bus.h
new file mode 100644
index 0000000..836663e
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/bus.h
@@ -0,0 +1,57 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#ifndef __IWM_BUS_H__
+#define __IWM_BUS_H__
+
+#include "iwm.h"
+
+struct iwm_if_ops {
+	int (*enable)(struct iwm_priv *iwm);
+	int (*disable)(struct iwm_priv *iwm);
+	int (*send_chunk)(struct iwm_priv *iwm, u8* buf, int count);
+
+	int (*debugfs_init)(struct iwm_priv *iwm, struct dentry *parent_dir);
+	void (*debugfs_exit)(struct iwm_priv *iwm);
+
+	const char *umac_name;
+	const char *calib_lmac_name;
+	const char *lmac_name;
+};
+
+static inline int iwm_bus_send_chunk(struct iwm_priv *iwm, u8 *buf, int count)
+{
+	return iwm->bus_ops->send_chunk(iwm, buf, count);
+}
+
+static inline int iwm_bus_enable(struct iwm_priv *iwm)
+{
+	return iwm->bus_ops->enable(iwm);
+}
+
+static inline int iwm_bus_disable(struct iwm_priv *iwm)
+{
+	return iwm->bus_ops->disable(iwm);
+}
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
new file mode 100644
index 0000000..3256ad2
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -0,0 +1,409 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+
+#include "iwm.h"
+#include "commands.h"
+#include "cfg80211.h"
+#include "debug.h"
+
+#define RATETAB_ENT(_rate, _rateid, _flags) \
+	{								\
+		.bitrate	= (_rate),				\
+		.hw_value	= (_rateid),				\
+		.flags		= (_flags),				\
+	}
+
+#define CHAN2G(_channel, _freq, _flags) {			\
+	.band			= IEEE80211_BAND_2GHZ,		\
+	.center_freq		= (_freq),			\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 30,				\
+}
+
+#define CHAN5G(_channel, _flags) {				\
+	.band			= IEEE80211_BAND_5GHZ,		\
+	.center_freq		= 5000 + (5 * (_channel)),	\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 30,				\
+}
+
+static struct ieee80211_rate iwm_rates[] = {
+	RATETAB_ENT(10,  0x1,   0),
+	RATETAB_ENT(20,  0x2,   0),
+	RATETAB_ENT(55,  0x4,   0),
+	RATETAB_ENT(110, 0x8,   0),
+	RATETAB_ENT(60,  0x10,  0),
+	RATETAB_ENT(90,  0x20,  0),
+	RATETAB_ENT(120, 0x40,  0),
+	RATETAB_ENT(180, 0x80,  0),
+	RATETAB_ENT(240, 0x100, 0),
+	RATETAB_ENT(360, 0x200, 0),
+	RATETAB_ENT(480, 0x400, 0),
+	RATETAB_ENT(540, 0x800, 0),
+};
+
+#define iwm_a_rates		(iwm_rates + 4)
+#define iwm_a_rates_size	8
+#define iwm_g_rates		(iwm_rates + 0)
+#define iwm_g_rates_size	12
+
+static struct ieee80211_channel iwm_2ghz_channels[] = {
+	CHAN2G(1, 2412, 0),
+	CHAN2G(2, 2417, 0),
+	CHAN2G(3, 2422, 0),
+	CHAN2G(4, 2427, 0),
+	CHAN2G(5, 2432, 0),
+	CHAN2G(6, 2437, 0),
+	CHAN2G(7, 2442, 0),
+	CHAN2G(8, 2447, 0),
+	CHAN2G(9, 2452, 0),
+	CHAN2G(10, 2457, 0),
+	CHAN2G(11, 2462, 0),
+	CHAN2G(12, 2467, 0),
+	CHAN2G(13, 2472, 0),
+	CHAN2G(14, 2484, 0),
+};
+
+static struct ieee80211_channel iwm_5ghz_a_channels[] = {
+	CHAN5G(34, 0),		CHAN5G(36, 0),
+	CHAN5G(38, 0),		CHAN5G(40, 0),
+	CHAN5G(42, 0),		CHAN5G(44, 0),
+	CHAN5G(46, 0),		CHAN5G(48, 0),
+	CHAN5G(52, 0),		CHAN5G(56, 0),
+	CHAN5G(60, 0),		CHAN5G(64, 0),
+	CHAN5G(100, 0),		CHAN5G(104, 0),
+	CHAN5G(108, 0),		CHAN5G(112, 0),
+	CHAN5G(116, 0),		CHAN5G(120, 0),
+	CHAN5G(124, 0),		CHAN5G(128, 0),
+	CHAN5G(132, 0),		CHAN5G(136, 0),
+	CHAN5G(140, 0),		CHAN5G(149, 0),
+	CHAN5G(153, 0),		CHAN5G(157, 0),
+	CHAN5G(161, 0),		CHAN5G(165, 0),
+	CHAN5G(184, 0),		CHAN5G(188, 0),
+	CHAN5G(192, 0),		CHAN5G(196, 0),
+	CHAN5G(200, 0),		CHAN5G(204, 0),
+	CHAN5G(208, 0),		CHAN5G(212, 0),
+	CHAN5G(216, 0),
+};
+
+static struct ieee80211_supported_band iwm_band_2ghz = {
+	.channels = iwm_2ghz_channels,
+	.n_channels = ARRAY_SIZE(iwm_2ghz_channels),
+	.bitrates = iwm_g_rates,
+	.n_bitrates = iwm_g_rates_size,
+};
+
+static struct ieee80211_supported_band iwm_band_5ghz = {
+	.channels = iwm_5ghz_a_channels,
+	.n_channels = ARRAY_SIZE(iwm_5ghz_a_channels),
+	.bitrates = iwm_a_rates,
+	.n_bitrates = iwm_a_rates_size,
+};
+
+int iwm_cfg80211_inform_bss(struct iwm_priv *iwm)
+{
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+	struct iwm_bss_info *bss, *next;
+	struct iwm_umac_notif_bss_info *umac_bss;
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_channel *channel;
+	struct ieee80211_supported_band *band;
+	s32 signal;
+	int freq;
+
+	list_for_each_entry_safe(bss, next, &iwm->bss_list, node) {
+		umac_bss = bss->bss;
+		mgmt = (struct ieee80211_mgmt *)(umac_bss->frame_buf);
+
+		if (umac_bss->band == UMAC_BAND_2GHZ)
+			band = wiphy->bands[IEEE80211_BAND_2GHZ];
+		else if (umac_bss->band == UMAC_BAND_5GHZ)
+			band = wiphy->bands[IEEE80211_BAND_5GHZ];
+		else {
+			IWM_ERR(iwm, "Invalid band: %d\n", umac_bss->band);
+			return -EINVAL;
+		}
+
+		freq = ieee80211_channel_to_frequency(umac_bss->channel);
+		channel = ieee80211_get_channel(wiphy, freq);
+		signal = umac_bss->rssi * 100;
+
+		if (!cfg80211_inform_bss_frame(wiphy, channel, mgmt,
+					       le16_to_cpu(umac_bss->frame_len),
+					       signal, GFP_KERNEL))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int iwm_cfg80211_change_iface(struct wiphy *wiphy, int ifindex,
+				     enum nl80211_iftype type, u32 *flags,
+				     struct vif_params *params)
+{
+	struct net_device *ndev;
+	struct wireless_dev *wdev;
+	struct iwm_priv *iwm;
+	u32 old_mode;
+
+	/* we're under RTNL */
+	ndev = __dev_get_by_index(&init_net, ifindex);
+	if (!ndev)
+		return -ENODEV;
+
+	wdev = ndev->ieee80211_ptr;
+	iwm = ndev_to_iwm(ndev);
+	old_mode = iwm->conf.mode;
+
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+		iwm->conf.mode = UMAC_MODE_BSS;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		iwm->conf.mode = UMAC_MODE_IBSS;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	wdev->iftype = type;
+
+	if ((old_mode == iwm->conf.mode) || !iwm->umac_profile)
+		return 0;
+
+	iwm->umac_profile->mode = cpu_to_le32(iwm->conf.mode);
+
+	if (iwm->umac_profile_active) {
+		int ret = iwm_invalidate_mlme_profile(iwm);
+		if (ret < 0)
+			IWM_ERR(iwm, "Couldn't invalidate profile\n");
+	}
+
+	return 0;
+}
+
+static int iwm_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+			     struct cfg80211_scan_request *request)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(ndev);
+	int ret;
+
+	if (!test_bit(IWM_STATUS_READY, &iwm->status)) {
+		IWM_ERR(iwm, "Scan while device is not ready\n");
+		return -EIO;
+	}
+
+	if (test_bit(IWM_STATUS_SCANNING, &iwm->status)) {
+		IWM_ERR(iwm, "Scanning already\n");
+		return -EAGAIN;
+	}
+
+	if (test_bit(IWM_STATUS_SCAN_ABORTING, &iwm->status)) {
+		IWM_ERR(iwm, "Scanning being aborted\n");
+		return -EAGAIN;
+	}
+
+	set_bit(IWM_STATUS_SCANNING, &iwm->status);
+
+	ret = iwm_scan_ssids(iwm, request->ssids, request->n_ssids);
+	if (ret) {
+		clear_bit(IWM_STATUS_SCANNING, &iwm->status);
+		return ret;
+	}
+
+	iwm->scan_request = request;
+	return 0;
+}
+
+static int iwm_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD &&
+	    (iwm->conf.rts_threshold != wiphy->rts_threshold)) {
+		int ret;
+
+		iwm->conf.rts_threshold = wiphy->rts_threshold;
+
+		ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+					     CFG_RTS_THRESHOLD,
+					     iwm->conf.rts_threshold);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD &&
+	    (iwm->conf.frag_threshold != wiphy->frag_threshold)) {
+		int ret;
+
+		iwm->conf.frag_threshold = wiphy->frag_threshold;
+
+		ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+					     CFG_FRAG_THRESHOLD,
+					     iwm->conf.frag_threshold);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int iwm_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+				  struct cfg80211_ibss_params *params)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+	struct ieee80211_channel *chan = params->channel;
+	struct cfg80211_bss *bss;
+
+	if (!test_bit(IWM_STATUS_READY, &iwm->status))
+		return -EIO;
+
+	/* UMAC doesn't support creating IBSS network with specified bssid.
+	 * This should be removed after we have join only mode supported. */
+	if (params->bssid)
+		return -EOPNOTSUPP;
+
+	bss = cfg80211_get_ibss(iwm_to_wiphy(iwm), NULL,
+				params->ssid, params->ssid_len);
+	if (!bss) {
+		iwm_scan_one_ssid(iwm, params->ssid, params->ssid_len);
+		schedule_timeout_interruptible(2 * HZ);
+		bss = cfg80211_get_ibss(iwm_to_wiphy(iwm), NULL,
+					params->ssid, params->ssid_len);
+	}
+	/* IBSS join only mode is not supported by UMAC ATM */
+	if (bss) {
+		cfg80211_put_bss(bss);
+		return -EOPNOTSUPP;
+	}
+
+	iwm->channel = ieee80211_frequency_to_channel(chan->center_freq);
+	iwm->umac_profile->ibss.band = chan->band;
+	iwm->umac_profile->ibss.channel = iwm->channel;
+	iwm->umac_profile->ssid.ssid_len = params->ssid_len;
+	memcpy(iwm->umac_profile->ssid.ssid, params->ssid, params->ssid_len);
+
+	if (params->bssid)
+		memcpy(&iwm->umac_profile->bssid[0], params->bssid, ETH_ALEN);
+
+	return iwm_send_mlme_profile(iwm);
+}
+
+static int iwm_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+
+	if (iwm->umac_profile_active)
+		return iwm_invalidate_mlme_profile(iwm);
+
+	return 0;
+}
+
+static struct cfg80211_ops iwm_cfg80211_ops = {
+	.change_virtual_intf = iwm_cfg80211_change_iface,
+	.scan = iwm_cfg80211_scan,
+	.set_wiphy_params = iwm_cfg80211_set_wiphy_params,
+	.join_ibss = iwm_cfg80211_join_ibss,
+	.leave_ibss = iwm_cfg80211_leave_ibss,
+};
+
+struct wireless_dev *iwm_wdev_alloc(int sizeof_bus, struct device *dev)
+{
+	int ret = 0;
+	struct wireless_dev *wdev;
+
+	/*
+	 * We're trying to have the following memory
+	 * layout:
+	 *
+	 * +-------------------------+
+	 * | struct wiphy	     |
+	 * +-------------------------+
+	 * | struct iwm_priv         |
+	 * +-------------------------+
+	 * | bus private data        |
+	 * | (e.g. iwm_priv_sdio)    |
+	 * +-------------------------+
+	 *
+	 */
+
+	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!wdev) {
+		dev_err(dev, "Couldn't allocate wireless device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	wdev->wiphy = wiphy_new(&iwm_cfg80211_ops,
+				sizeof(struct iwm_priv) + sizeof_bus);
+	if (!wdev->wiphy) {
+		dev_err(dev, "Couldn't allocate wiphy device\n");
+		ret = -ENOMEM;
+		goto out_err_new;
+	}
+
+	set_wiphy_dev(wdev->wiphy, dev);
+	wdev->wiphy->max_scan_ssids = UMAC_WIFI_IF_PROBE_OPTION_MAX;
+	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				       BIT(NL80211_IFTYPE_ADHOC);
+	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &iwm_band_2ghz;
+	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &iwm_band_5ghz;
+	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	ret = wiphy_register(wdev->wiphy);
+	if (ret < 0) {
+		dev_err(dev, "Couldn't register wiphy device\n");
+		goto out_err_register;
+	}
+
+	return wdev;
+
+ out_err_register:
+	wiphy_free(wdev->wiphy);
+
+ out_err_new:
+	kfree(wdev);
+
+	return ERR_PTR(ret);
+}
+
+void iwm_wdev_free(struct iwm_priv *iwm)
+{
+	struct wireless_dev *wdev = iwm_to_wdev(iwm);
+
+	if (!wdev)
+		return;
+
+	wiphy_unregister(wdev->wiphy);
+	wiphy_free(wdev->wiphy);
+	kfree(wdev);
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.h b/drivers/net/wireless/iwmc3200wifi/cfg80211.h
new file mode 100644
index 0000000..56a3414
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.h
@@ -0,0 +1,31 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#ifndef __IWM_CFG80211_H__
+#define __IWM_CFG80211_H__
+
+int iwm_cfg80211_inform_bss(struct iwm_priv *iwm);
+struct wireless_dev *iwm_wdev_alloc(int sizeof_bus, struct device *dev);
+void iwm_wdev_free(struct iwm_priv *iwm);
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
new file mode 100644
index 0000000..834a7f5
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -0,0 +1,920 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/wireless.h>
+#include <linux/etherdevice.h>
+#include <linux/ieee80211.h>
+
+#include "iwm.h"
+#include "bus.h"
+#include "hal.h"
+#include "umac.h"
+#include "commands.h"
+#include "debug.h"
+
+static int iwm_send_lmac_ptrough_cmd(struct iwm_priv *iwm,
+				     u8 lmac_cmd_id,
+				     const void *lmac_payload,
+				     u16 lmac_payload_size,
+				     u8 resp)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_LMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_lmac_cmd lmac_cmd;
+
+	lmac_cmd.id = lmac_cmd_id;
+
+	umac_cmd.id = UMAC_CMD_OPCODE_WIFI_PASS_THROUGH;
+	umac_cmd.resp = resp;
+
+	return iwm_hal_send_host_cmd(iwm, &udma_cmd, &umac_cmd, &lmac_cmd,
+				     lmac_payload, lmac_payload_size);
+}
+
+int iwm_send_wifi_if_cmd(struct iwm_priv *iwm, void *payload, u16 payload_size,
+			 bool resp)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+
+	umac_cmd.id = UMAC_CMD_OPCODE_WIFI_IF_WRAPPER;
+	umac_cmd.resp = resp;
+
+	return iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd,
+				     payload, payload_size);
+}
+
+static struct coex_event iwm_sta_xor_prio_tbl[COEX_EVENTS_NUM] =
+{
+	{4, 3, 0, COEX_UNASSOC_IDLE_FLAGS},
+	{4, 3, 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
+	{4, 3, 0, COEX_UNASSOC_AUTO_SCAN_FLAGS},
+	{4, 3, 0, COEX_CALIBRATION_FLAGS},
+	{4, 3, 0, COEX_PERIODIC_CALIBRATION_FLAGS},
+	{4, 3, 0, COEX_CONNECTION_ESTAB_FLAGS},
+	{4, 3, 0, COEX_ASSOCIATED_IDLE_FLAGS},
+	{4, 3, 0, COEX_ASSOC_MANUAL_SCAN_FLAGS},
+	{4, 3, 0, COEX_ASSOC_AUTO_SCAN_FLAGS},
+	{4, 3, 0, COEX_ASSOC_ACTIVE_LEVEL_FLAGS},
+	{6, 3, 0, COEX_XOR_RF_ON_FLAGS},
+	{4, 3, 0, COEX_RF_OFF_FLAGS},
+	{6, 6, 0, COEX_STAND_ALONE_DEBUG_FLAGS},
+	{4, 3, 0, COEX_IPAN_ASSOC_LEVEL_FLAGS},
+	{4, 3, 0, COEX_RSRVD1_FLAGS},
+	{4, 3, 0, COEX_RSRVD2_FLAGS}
+};
+
+static struct coex_event iwm_sta_cm_prio_tbl[COEX_EVENTS_NUM] =
+{
+	{1, 1, 0, COEX_UNASSOC_IDLE_FLAGS},
+	{4, 3, 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
+	{3, 3, 0, COEX_UNASSOC_AUTO_SCAN_FLAGS},
+	{5, 5, 0, COEX_CALIBRATION_FLAGS},
+	{4, 4, 0, COEX_PERIODIC_CALIBRATION_FLAGS},
+	{5, 4, 0, COEX_CONNECTION_ESTAB_FLAGS},
+	{4, 4, 0, COEX_ASSOCIATED_IDLE_FLAGS},
+	{4, 4, 0, COEX_ASSOC_MANUAL_SCAN_FLAGS},
+	{4, 4, 0, COEX_ASSOC_AUTO_SCAN_FLAGS},
+	{4, 4, 0, COEX_ASSOC_ACTIVE_LEVEL_FLAGS},
+	{1, 1, 0, COEX_RF_ON_FLAGS},
+	{1, 1, 0, COEX_RF_OFF_FLAGS},
+	{6, 6, 0, COEX_STAND_ALONE_DEBUG_FLAGS},
+	{5, 4, 0, COEX_IPAN_ASSOC_LEVEL_FLAGS},
+	{1, 1, 0, COEX_RSRVD1_FLAGS},
+	{1, 1, 0, COEX_RSRVD2_FLAGS}
+};
+
+int iwm_send_prio_table(struct iwm_priv *iwm)
+{
+	struct iwm_coex_prio_table_cmd coex_table_cmd;
+	u32 coex_enabled, mode_enabled;
+
+	memset(&coex_table_cmd, 0, sizeof(struct iwm_coex_prio_table_cmd));
+
+	coex_table_cmd.flags = COEX_FLAGS_STA_TABLE_VALID_MSK;
+
+	switch (iwm->conf.coexist_mode) {
+	case COEX_MODE_XOR:
+	case COEX_MODE_CM:
+		coex_enabled = 1;
+		break;
+	default:
+		coex_enabled = 0;
+		break;
+	}
+
+	switch (iwm->conf.mode) {
+	case UMAC_MODE_BSS:
+	case UMAC_MODE_IBSS:
+		mode_enabled = 1;
+		break;
+	default:
+		mode_enabled = 0;
+		break;
+	}
+
+	if (coex_enabled && mode_enabled) {
+		coex_table_cmd.flags |= COEX_FLAGS_COEX_ENABLE_MSK |
+					COEX_FLAGS_ASSOC_WAKEUP_UMASK_MSK |
+					COEX_FLAGS_UNASSOC_WAKEUP_UMASK_MSK;
+
+		switch (iwm->conf.coexist_mode) {
+		case COEX_MODE_XOR:
+			memcpy(coex_table_cmd.sta_prio, iwm_sta_xor_prio_tbl,
+			       sizeof(iwm_sta_xor_prio_tbl));
+			break;
+		case COEX_MODE_CM:
+			memcpy(coex_table_cmd.sta_prio, iwm_sta_cm_prio_tbl,
+			       sizeof(iwm_sta_cm_prio_tbl));
+			break;
+		default:
+			IWM_ERR(iwm, "Invalid coex_mode 0x%x\n",
+				iwm->conf.coexist_mode);
+			break;
+		}
+	} else
+		IWM_WARN(iwm, "coexistense disabled\n");
+
+	return iwm_send_lmac_ptrough_cmd(iwm, COEX_PRIORITY_TABLE_CMD,
+				&coex_table_cmd,
+				sizeof(struct iwm_coex_prio_table_cmd), 1);
+}
+
+int iwm_send_init_calib_cfg(struct iwm_priv *iwm, u8 calib_requested)
+{
+	struct iwm_lmac_cal_cfg_cmd cal_cfg_cmd;
+
+	memset(&cal_cfg_cmd, 0, sizeof(struct iwm_lmac_cal_cfg_cmd));
+
+	cal_cfg_cmd.ucode_cfg.init.enable = cpu_to_le32(calib_requested);
+	cal_cfg_cmd.ucode_cfg.init.start = cpu_to_le32(calib_requested);
+	cal_cfg_cmd.ucode_cfg.init.send_res = cpu_to_le32(calib_requested);
+	cal_cfg_cmd.ucode_cfg.flags =
+		cpu_to_le32(CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_AFTER_MSK);
+
+	return iwm_send_lmac_ptrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
+				sizeof(struct iwm_lmac_cal_cfg_cmd), 1);
+}
+
+int iwm_send_periodic_calib_cfg(struct iwm_priv *iwm, u8 calib_requested)
+{
+	struct iwm_lmac_cal_cfg_cmd cal_cfg_cmd;
+
+	memset(&cal_cfg_cmd, 0, sizeof(struct iwm_lmac_cal_cfg_cmd));
+
+	cal_cfg_cmd.ucode_cfg.periodic.enable = cpu_to_le32(calib_requested);
+	cal_cfg_cmd.ucode_cfg.periodic.start = cpu_to_le32(calib_requested);
+
+	return iwm_send_lmac_ptrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
+				sizeof(struct iwm_lmac_cal_cfg_cmd), 0);
+}
+
+int iwm_store_rxiq_calib_result(struct iwm_priv *iwm)
+{
+	struct iwm_calib_rxiq *rxiq;
+	u8 *eeprom_rxiq = iwm_eeprom_access(iwm, IWM_EEPROM_CALIB_RXIQ);
+	int grplen = sizeof(struct iwm_calib_rxiq_group);
+
+	rxiq = kzalloc(sizeof(struct iwm_calib_rxiq), GFP_KERNEL);
+	if (!rxiq) {
+		IWM_ERR(iwm, "Couldn't alloc memory for RX IQ\n");
+		return -ENOMEM;
+	}
+
+	eeprom_rxiq = iwm_eeprom_access(iwm, IWM_EEPROM_CALIB_RXIQ);
+	if (IS_ERR(eeprom_rxiq)) {
+		IWM_ERR(iwm, "Couldn't access EEPROM RX IQ entry\n");
+		return PTR_ERR(eeprom_rxiq);
+	}
+
+	iwm->calib_res[SHILOH_PHY_CALIBRATE_RX_IQ_CMD].buf = (u8 *)rxiq;
+	iwm->calib_res[SHILOH_PHY_CALIBRATE_RX_IQ_CMD].size = sizeof(*rxiq);
+
+	rxiq->hdr.opcode = SHILOH_PHY_CALIBRATE_RX_IQ_CMD;
+	rxiq->hdr.first_grp = 0;
+	rxiq->hdr.grp_num = 1;
+	rxiq->hdr.all_data_valid = 1;
+
+	memcpy(&rxiq->group[0], eeprom_rxiq, 4 * grplen);
+	memcpy(&rxiq->group[4], eeprom_rxiq + 6 * grplen, grplen);
+
+	return 0;
+}
+
+int iwm_send_calib_results(struct iwm_priv *iwm)
+{
+	int i, ret = 0;
+
+	for (i = PHY_CALIBRATE_OPCODES_NUM; i < CALIBRATION_CMD_NUM; i++) {
+		if (test_bit(i - PHY_CALIBRATE_OPCODES_NUM,
+			     &iwm->calib_done_map)) {
+			IWM_DBG_CMD(iwm, DBG,
+				    "Send calibration %d result\n", i);
+			ret |= iwm_send_lmac_ptrough_cmd(iwm,
+					REPLY_PHY_CALIBRATION_CMD,
+					iwm->calib_res[i].buf,
+					iwm->calib_res[i].size, 0);
+
+			kfree(iwm->calib_res[i].buf);
+			iwm->calib_res[i].buf = NULL;
+			iwm->calib_res[i].size = 0;
+		}
+	}
+
+	return ret;
+}
+
+int iwm_send_umac_reset(struct iwm_priv *iwm, __le32 reset_flags, bool resp)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_umac_cmd_reset reset;
+
+	reset.flags = reset_flags;
+
+	umac_cmd.id = UMAC_CMD_OPCODE_RESET;
+	umac_cmd.resp = resp;
+
+	return iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd, &reset,
+				     sizeof(struct iwm_umac_cmd_reset));
+}
+
+int iwm_umac_set_config_fix(struct iwm_priv *iwm, u16 tbl, u16 key, u32 value)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_umac_cmd_set_param_fix param;
+
+	if ((tbl != UMAC_PARAM_TBL_CFG_FIX) &&
+	    (tbl != UMAC_PARAM_TBL_FA_CFG_FIX))
+		return -EINVAL;
+
+	umac_cmd.id = UMAC_CMD_OPCODE_SET_PARAM_FIX;
+	umac_cmd.resp = 0;
+
+	param.tbl = cpu_to_le16(tbl);
+	param.key = cpu_to_le16(key);
+	param.value = cpu_to_le32(value);
+
+	return iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd, &param,
+				     sizeof(struct iwm_umac_cmd_set_param_fix));
+}
+
+int iwm_umac_set_config_var(struct iwm_priv *iwm, u16 key,
+			    void *payload, u16 payload_size)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_umac_cmd_set_param_var *param_hdr;
+	u8 *param;
+	int ret;
+
+	param = kzalloc(payload_size +
+			sizeof(struct iwm_umac_cmd_set_param_var), GFP_KERNEL);
+	if (!param) {
+		IWM_ERR(iwm, "Couldn't allocate param\n");
+		return -ENOMEM;
+	}
+
+	param_hdr = (struct iwm_umac_cmd_set_param_var *)param;
+
+	umac_cmd.id = UMAC_CMD_OPCODE_SET_PARAM_VAR;
+	umac_cmd.resp = 0;
+
+	param_hdr->tbl = cpu_to_le16(UMAC_PARAM_TBL_CFG_VAR);
+	param_hdr->key = cpu_to_le16(key);
+	param_hdr->len = cpu_to_le16(payload_size);
+	memcpy(param + sizeof(struct iwm_umac_cmd_set_param_var),
+	       payload, payload_size);
+
+	ret = iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd, param,
+				    sizeof(struct iwm_umac_cmd_set_param_var) +
+				    payload_size);
+	kfree(param);
+
+	return ret;
+}
+
+int iwm_send_umac_config(struct iwm_priv *iwm,
+			 __le32 reset_flags)
+{
+	int ret;
+
+	/* Use UMAC default values */
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_POWER_INDEX, iwm->conf.power_index);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_FA_CFG_FIX,
+				      CFG_FRAG_THRESHOLD,
+				      iwm->conf.frag_threshold);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_RTS_THRESHOLD,
+				      iwm->conf.rts_threshold);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_CTS_TO_SELF, iwm->conf.cts_to_self);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_COEX_MODE, iwm->conf.coexist_mode);
+	if (ret < 0)
+		return ret;
+
+	/*
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_ASSOCIATION_TIMEOUT,
+				      iwm->conf.assoc_timeout);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_ROAM_TIMEOUT,
+				      iwm->conf.roam_timeout);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_WIRELESS_MODE,
+				      WIRELESS_MODE_11A | WIRELESS_MODE_11G);
+	if (ret < 0)
+		return ret;
+	*/
+
+	ret = iwm_umac_set_config_var(iwm, CFG_NET_ADDR,
+				      iwm_to_ndev(iwm)->dev_addr, ETH_ALEN);
+	if (ret < 0)
+		return ret;
+
+	/* UMAC PM static configurations */
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_PM_LEGACY_RX_TIMEOUT, 0x12C);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_PM_LEGACY_TX_TIMEOUT, 0x15E);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_PM_CTRL_FLAGS, 0x30001);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_PM_KEEP_ALIVE_IN_BEACONS, 0x80);
+	if (ret < 0)
+		return ret;
+
+	/* reset UMAC */
+	ret = iwm_send_umac_reset(iwm, reset_flags, 1);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_notif_handle(iwm, UMAC_CMD_OPCODE_RESET, IWM_SRC_UMAC,
+			       WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Wait for UMAC RESET timeout\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+int iwm_send_packet(struct iwm_priv *iwm, struct sk_buff *skb, int pool_id)
+{
+	struct iwm_udma_wifi_cmd udma_cmd;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_tx_info *tx_info = skb_to_tx_info(skb);
+
+	udma_cmd.eop = 1; /* always set eop for non-concatenated Tx */
+	udma_cmd.credit_group = pool_id;
+	udma_cmd.ra_tid = tx_info->sta << 4 | tx_info->tid;
+	udma_cmd.lmac_offset = 0;
+
+	umac_cmd.id = REPLY_TX;
+	umac_cmd.color = tx_info->color;
+	umac_cmd.resp = 0;
+
+	return iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd,
+				     skb->data, skb->len);
+}
+
+static int iwm_target_read(struct iwm_priv *iwm, __le32 address,
+			   u8 *response, u32 resp_size)
+{
+	struct iwm_udma_nonwifi_cmd target_cmd;
+	struct iwm_nonwifi_cmd *cmd;
+	u16 seq_num;
+	int ret = 0;
+
+	target_cmd.opcode = UMAC_HDI_OUT_OPCODE_READ;
+	target_cmd.addr = address;
+	target_cmd.op1_sz = cpu_to_le32(resp_size);
+	target_cmd.op2 = 0;
+	target_cmd.handle_by_hw = 0;
+	target_cmd.resp = 1;
+	target_cmd.eop = 1;
+
+	ret = iwm_hal_send_target_cmd(iwm, &target_cmd, NULL);
+	if (ret < 0)
+		IWM_ERR(iwm, "Couldn't send READ command\n");
+
+	/* When succeding, the send_target routine returns the seq number */
+	seq_num = ret;
+
+	ret = wait_event_interruptible_timeout(iwm->nonwifi_queue,
+		(cmd = iwm_get_pending_nonwifi_cmd(iwm, seq_num,
+					  UMAC_HDI_OUT_OPCODE_READ)) != NULL,
+					       2 * HZ);
+
+	if (!ret) {
+		IWM_ERR(iwm, "Didn't receive a target READ answer\n");
+		return ret;
+	}
+
+	memcpy(response, cmd->buf.hdr + sizeof(struct iwm_udma_in_hdr),
+	       resp_size);
+
+	kfree(cmd);
+
+	return ret;
+}
+
+int iwm_read_mac(struct iwm_priv *iwm, u8 *mac)
+{
+	int ret;
+	u8 mac_align[ALIGN(ETH_ALEN, 8)];
+
+	ret = iwm_target_read(iwm, cpu_to_le32(WICO_MAC_ADDRESS_ADDR),
+			      mac_align, sizeof(mac_align));
+	if (ret < 0)
+		return ret;
+
+	if (is_valid_ether_addr(mac_align))
+		memcpy(mac, mac_align, ETH_ALEN);
+	else {
+		IWM_ERR(iwm, "Invalid EEPROM MAC\n");
+		memcpy(mac, iwm->conf.mac_addr, ETH_ALEN);
+		get_random_bytes(&mac[3], 3);
+	}
+
+	return 0;
+}
+
+int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx)
+{
+	struct iwm_umac_tx_key_id tx_key_id;
+
+	if (!iwm->default_key || !iwm->default_key->in_use)
+		return -EINVAL;
+
+	tx_key_id.hdr.oid = UMAC_WIFI_IF_CMD_GLOBAL_TX_KEY_ID;
+	tx_key_id.hdr.buf_size = cpu_to_le16(sizeof(struct iwm_umac_tx_key_id) -
+					     sizeof(struct iwm_umac_wifi_if));
+
+	tx_key_id.key_idx = key_idx;
+
+	return iwm_send_wifi_if_cmd(iwm, &tx_key_id, sizeof(tx_key_id), 1);
+}
+
+static int iwm_check_profile(struct iwm_priv *iwm)
+{
+	if (!iwm->umac_profile_active)
+		return -EAGAIN;
+
+	if (iwm->umac_profile->sec.ucast_cipher != UMAC_CIPHER_TYPE_WEP_40 &&
+	    iwm->umac_profile->sec.ucast_cipher != UMAC_CIPHER_TYPE_WEP_104 &&
+	    iwm->umac_profile->sec.ucast_cipher != UMAC_CIPHER_TYPE_TKIP &&
+	    iwm->umac_profile->sec.ucast_cipher != UMAC_CIPHER_TYPE_CCMP) {
+		IWM_ERR(iwm, "Wrong unicast cipher: 0x%x\n",
+			iwm->umac_profile->sec.ucast_cipher);
+		return -EAGAIN;
+	}
+
+	if (iwm->umac_profile->sec.mcast_cipher != UMAC_CIPHER_TYPE_WEP_40 &&
+	    iwm->umac_profile->sec.mcast_cipher != UMAC_CIPHER_TYPE_WEP_104 &&
+	    iwm->umac_profile->sec.mcast_cipher != UMAC_CIPHER_TYPE_TKIP &&
+	    iwm->umac_profile->sec.mcast_cipher != UMAC_CIPHER_TYPE_CCMP) {
+		IWM_ERR(iwm, "Wrong multicast cipher: 0x%x\n",
+			iwm->umac_profile->sec.mcast_cipher);
+		return -EAGAIN;
+	}
+
+	if ((iwm->umac_profile->sec.ucast_cipher == UMAC_CIPHER_TYPE_WEP_40 ||
+	     iwm->umac_profile->sec.ucast_cipher == UMAC_CIPHER_TYPE_WEP_104) &&
+	    (iwm->umac_profile->sec.ucast_cipher !=
+	     iwm->umac_profile->sec.mcast_cipher)) {
+		IWM_ERR(iwm, "Unicast and multicast ciphers differ for WEP\n");
+	}
+
+	return 0;
+}
+
+int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
+		struct iwm_key *key)
+{
+	int ret;
+	u8 cmd[64], *sta_addr, *key_data, key_len;
+	s8 key_idx;
+	u16 cmd_size = 0;
+	struct iwm_umac_key_hdr *key_hdr = &key->hdr;
+	struct iwm_umac_key_wep40 *wep40 = (struct iwm_umac_key_wep40 *)cmd;
+	struct iwm_umac_key_wep104 *wep104 = (struct iwm_umac_key_wep104 *)cmd;
+	struct iwm_umac_key_tkip *tkip = (struct iwm_umac_key_tkip *)cmd;
+	struct iwm_umac_key_ccmp *ccmp = (struct iwm_umac_key_ccmp *)cmd;
+
+	if (set_tx_key)
+		iwm->default_key = key;
+
+	/*
+	 * We check if our current profile is valid.
+	 * If not, we dont push the key, we just cache them,
+	 * so that with the next siwsessid call, the keys
+	 * will be actually pushed.
+	 */
+	if (!remove) {
+		ret = iwm_check_profile(iwm);
+		if (ret < 0)
+			return ret;
+	}
+
+	sta_addr = key->hdr.mac;
+	key_data = key->key;
+	key_len = key->key_len;
+	key_idx = key->hdr.key_idx;
+
+	if (!remove) {
+		IWM_DBG_WEXT(iwm, DBG, "key_idx:%d set tx key:%d\n",
+			     key_idx, set_tx_key);
+		IWM_DBG_WEXT(iwm, DBG, "key_len:%d\n", key_len);
+		IWM_DBG_WEXT(iwm, DBG, "MAC:%pM, idx:%d, multicast:%d\n",
+		       key_hdr->mac, key_hdr->key_idx, key_hdr->multicast);
+
+		IWM_DBG_WEXT(iwm, DBG, "profile: mcast:0x%x, ucast:0x%x\n",
+			     iwm->umac_profile->sec.mcast_cipher,
+			     iwm->umac_profile->sec.ucast_cipher);
+		IWM_DBG_WEXT(iwm, DBG, "profile: auth_type:0x%x, flags:0x%x\n",
+			     iwm->umac_profile->sec.auth_type,
+			     iwm->umac_profile->sec.flags);
+
+		switch (key->alg) {
+		case UMAC_CIPHER_TYPE_WEP_40:
+			wep40->hdr.oid = UMAC_WIFI_IF_CMD_ADD_WEP40_KEY;
+			wep40->hdr.buf_size =
+				cpu_to_le16(sizeof(struct iwm_umac_key_wep40) -
+					    sizeof(struct iwm_umac_wifi_if));
+
+			memcpy(&wep40->key_hdr, key_hdr,
+			       sizeof(struct iwm_umac_key_hdr));
+			memcpy(wep40->key, key_data, key_len);
+			wep40->static_key = 1;
+
+			cmd_size = sizeof(struct iwm_umac_key_wep40);
+			break;
+
+		case UMAC_CIPHER_TYPE_WEP_104:
+			wep104->hdr.oid = UMAC_WIFI_IF_CMD_ADD_WEP104_KEY;
+			wep104->hdr.buf_size =
+				cpu_to_le16(sizeof(struct iwm_umac_key_wep104) -
+					    sizeof(struct iwm_umac_wifi_if));
+
+			memcpy(&wep104->key_hdr, key_hdr,
+			       sizeof(struct iwm_umac_key_hdr));
+			memcpy(wep104->key, key_data, key_len);
+			wep104->static_key = 1;
+
+			cmd_size = sizeof(struct iwm_umac_key_wep104);
+			break;
+
+		case UMAC_CIPHER_TYPE_CCMP:
+			key_hdr->key_idx++;
+			ccmp->hdr.oid = UMAC_WIFI_IF_CMD_ADD_CCMP_KEY;
+			ccmp->hdr.buf_size =
+				cpu_to_le16(sizeof(struct iwm_umac_key_ccmp) -
+					    sizeof(struct iwm_umac_wifi_if));
+
+			memcpy(&ccmp->key_hdr, key_hdr,
+			       sizeof(struct iwm_umac_key_hdr));
+
+			memcpy(ccmp->key, key_data, key_len);
+
+			if (key->flags & IW_ENCODE_EXT_RX_SEQ_VALID)
+				memcpy(ccmp->iv_count, key->rx_seq, 6);
+
+			cmd_size = sizeof(struct iwm_umac_key_ccmp);
+			break;
+
+		case UMAC_CIPHER_TYPE_TKIP:
+			key_hdr->key_idx++;
+			tkip->hdr.oid = UMAC_WIFI_IF_CMD_ADD_TKIP_KEY;
+			tkip->hdr.buf_size =
+				cpu_to_le16(sizeof(struct iwm_umac_key_tkip) -
+					    sizeof(struct iwm_umac_wifi_if));
+
+			memcpy(&tkip->key_hdr, key_hdr,
+			       sizeof(struct iwm_umac_key_hdr));
+
+			memcpy(tkip->tkip_key, key_data, IWM_TKIP_KEY_SIZE);
+			memcpy(tkip->mic_tx_key, key_data + IWM_TKIP_KEY_SIZE,
+			       IWM_TKIP_MIC_SIZE);
+			memcpy(tkip->mic_rx_key,
+			       key_data + IWM_TKIP_KEY_SIZE + IWM_TKIP_MIC_SIZE,
+			       IWM_TKIP_MIC_SIZE);
+
+			if (key->flags & IW_ENCODE_EXT_RX_SEQ_VALID)
+				memcpy(ccmp->iv_count, key->rx_seq, 6);
+
+			cmd_size = sizeof(struct iwm_umac_key_tkip);
+			break;
+
+		default:
+			return -ENOTSUPP;
+		}
+
+		if ((key->alg == UMAC_CIPHER_TYPE_CCMP) ||
+		    (key->alg == UMAC_CIPHER_TYPE_TKIP))
+			/*
+			 * UGLY_UGLY_UGLY
+			 * Copied HACK from the MWG driver.
+			 * Without it, the key is set before the second
+			 * EAPOL frame is sent, and the latter is thus
+			 * encrypted.
+			 */
+			schedule_timeout_interruptible(usecs_to_jiffies(300));
+
+		ret =  iwm_send_wifi_if_cmd(iwm, cmd, cmd_size, 1);
+		if (ret < 0)
+			goto err;
+
+		/*
+		 * We need a default key only if it is set and
+		 * if we're doing WEP.
+		 */
+		if (iwm->default_key == key &&
+			((key->alg == UMAC_CIPHER_TYPE_WEP_40) ||
+			 (key->alg == UMAC_CIPHER_TYPE_WEP_104))) {
+			ret = iwm_set_tx_key(iwm, key_idx);
+			if (ret < 0)
+				goto err;
+		}
+	} else {
+		struct iwm_umac_key_remove key_remove;
+
+		key_remove.hdr.oid = UMAC_WIFI_IF_CMD_REMOVE_KEY;
+		key_remove.hdr.buf_size =
+			cpu_to_le16(sizeof(struct iwm_umac_key_remove) -
+				    sizeof(struct iwm_umac_wifi_if));
+		memcpy(&key_remove.key_hdr, key_hdr,
+		       sizeof(struct iwm_umac_key_hdr));
+
+		ret =  iwm_send_wifi_if_cmd(iwm, &key_remove,
+					    sizeof(struct iwm_umac_key_remove),
+					    1);
+		if (ret < 0)
+			return ret;
+
+		iwm->keys[key_idx].in_use = 0;
+	}
+
+	return 0;
+
+ err:
+	kfree(key);
+	return ret;
+}
+
+
+int iwm_send_mlme_profile(struct iwm_priv *iwm)
+{
+	int ret, i;
+	struct iwm_umac_profile profile;
+
+	memcpy(&profile, iwm->umac_profile, sizeof(profile));
+
+	profile.hdr.oid = UMAC_WIFI_IF_CMD_SET_PROFILE;
+	profile.hdr.buf_size = cpu_to_le16(sizeof(struct iwm_umac_profile) -
+					   sizeof(struct iwm_umac_wifi_if));
+
+	ret = iwm_send_wifi_if_cmd(iwm, &profile, sizeof(profile), 1);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Send profile command failed\n");
+		return ret;
+	}
+
+	/* Wait for the profile to be active */
+	ret = wait_event_interruptible_timeout(iwm->mlme_queue,
+					       iwm->umac_profile_active == 1,
+					       3 * HZ);
+	if (!ret)
+		return -EBUSY;
+
+
+	for (i = 0; i < IWM_NUM_KEYS; i++)
+		if (iwm->keys[i].in_use) {
+			int default_key = 0;
+			struct iwm_key *key = &iwm->keys[i];
+
+			if (key == iwm->default_key)
+				default_key = 1;
+
+			/* Wait for the profile before sending the keys */
+			wait_event_interruptible_timeout(iwm->mlme_queue,
+			     (test_bit(IWM_STATUS_ASSOCIATING, &iwm->status) ||
+			      test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)),
+							 3 * HZ);
+
+			ret = iwm_set_key(iwm, 0, default_key, key);
+			if (ret < 0)
+				return ret;
+		}
+
+	return 0;
+}
+
+int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
+{
+	int ret;
+	struct iwm_umac_invalidate_profile invalid;
+
+	invalid.hdr.oid = UMAC_WIFI_IF_CMD_INVALIDATE_PROFILE;
+	invalid.hdr.buf_size =
+		cpu_to_le16(sizeof(struct iwm_umac_invalidate_profile) -
+			    sizeof(struct iwm_umac_wifi_if));
+
+	invalid.reason = WLAN_REASON_UNSPECIFIED;
+
+	ret = iwm_send_wifi_if_cmd(iwm, &invalid, sizeof(invalid), 1);
+	if (ret < 0)
+		return ret;
+
+	ret = wait_event_interruptible_timeout(iwm->mlme_queue,
+				 (iwm->umac_profile_active == 0),
+					       2 * HZ);
+	if (!ret)
+		return -EBUSY;
+
+	return 0;
+}
+
+int iwm_send_umac_stats_req(struct iwm_priv *iwm, u32 flags)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_umac_cmd_stats_req stats_req;
+
+	stats_req.flags = cpu_to_le32(flags);
+
+	umac_cmd.id = UMAC_CMD_OPCODE_STATISTIC_REQUEST;
+	umac_cmd.resp = 0;
+
+	return iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd, &stats_req,
+				     sizeof(struct iwm_umac_cmd_stats_req));
+}
+
+int iwm_send_umac_channel_list(struct iwm_priv *iwm)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_umac_cmd_get_channel_list *ch_list;
+	int size = sizeof(struct iwm_umac_cmd_get_channel_list) +
+		   sizeof(struct iwm_umac_channel_info) * 4;
+	int ret;
+
+	ch_list = kzalloc(size, GFP_KERNEL);
+	if (!ch_list) {
+		IWM_ERR(iwm, "Couldn't allocate channel list cmd\n");
+		return -ENOMEM;
+	}
+
+	ch_list->ch[0].band = UMAC_BAND_2GHZ;
+	ch_list->ch[0].type = UMAC_CHANNEL_WIDTH_20MHZ;
+	ch_list->ch[0].flags = UMAC_CHANNEL_FLAG_VALID;
+
+	ch_list->ch[1].band = UMAC_BAND_5GHZ;
+	ch_list->ch[1].type = UMAC_CHANNEL_WIDTH_20MHZ;
+	ch_list->ch[1].flags = UMAC_CHANNEL_FLAG_VALID;
+
+	ch_list->ch[2].band = UMAC_BAND_2GHZ;
+	ch_list->ch[2].type = UMAC_CHANNEL_WIDTH_20MHZ;
+	ch_list->ch[2].flags = UMAC_CHANNEL_FLAG_VALID | UMAC_CHANNEL_FLAG_IBSS;
+
+	ch_list->ch[3].band = UMAC_BAND_5GHZ;
+	ch_list->ch[3].type = UMAC_CHANNEL_WIDTH_20MHZ;
+	ch_list->ch[3].flags = UMAC_CHANNEL_FLAG_VALID | UMAC_CHANNEL_FLAG_IBSS;
+
+	ch_list->count = cpu_to_le16(4);
+
+	umac_cmd.id = UMAC_CMD_OPCODE_GET_CHAN_INFO_LIST;
+	umac_cmd.resp = 1;
+
+	ret = iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd, ch_list, size);
+
+	kfree(ch_list);
+
+	return ret;
+}
+
+int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
+		   int ssid_num)
+{
+	struct iwm_umac_cmd_scan_request req;
+	int i, ret;
+
+	memset(&req, 0, sizeof(struct iwm_umac_cmd_scan_request));
+
+	req.hdr.oid = UMAC_WIFI_IF_CMD_SCAN_REQUEST;
+	req.hdr.buf_size = cpu_to_le16(sizeof(struct iwm_umac_cmd_scan_request)
+				       - sizeof(struct iwm_umac_wifi_if));
+	req.type = UMAC_WIFI_IF_SCAN_TYPE_USER;
+	req.timeout = 2;
+	req.seq_num = iwm->scan_id;
+	req.ssid_num = min(ssid_num, UMAC_WIFI_IF_PROBE_OPTION_MAX);
+
+	for (i = 0; i < req.ssid_num; i++) {
+		memcpy(req.ssids[i].ssid, ssids[i].ssid, ssids[i].ssid_len);
+		req.ssids[i].ssid_len = ssids[i].ssid_len;
+	}
+
+	ret = iwm_send_wifi_if_cmd(iwm, &req, sizeof(req), 0);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't send scan request\n");
+		return ret;
+	}
+
+	iwm->scan_id = iwm->scan_id++ % IWM_SCAN_ID_MAX;
+
+	return 0;
+}
+
+int iwm_scan_one_ssid(struct iwm_priv *iwm, u8 *ssid, int ssid_len)
+{
+	struct cfg80211_ssid one_ssid;
+
+	if (test_and_set_bit(IWM_STATUS_SCANNING, &iwm->status))
+		return 0;
+
+	one_ssid.ssid_len = min(ssid_len, IEEE80211_MAX_SSID_LEN);
+	memcpy(&one_ssid.ssid, ssid, one_ssid.ssid_len);
+
+	return iwm_scan_ssids(iwm, &one_ssid, 1);
+}
+
+int iwm_target_reset(struct iwm_priv *iwm)
+{
+	struct iwm_udma_nonwifi_cmd target_cmd;
+
+	target_cmd.opcode = UMAC_HDI_OUT_OPCODE_REBOOT;
+	target_cmd.addr = 0;
+	target_cmd.op1_sz = 0;
+	target_cmd.op2 = 0;
+	target_cmd.handle_by_hw = 0;
+	target_cmd.resp = 0;
+	target_cmd.eop = 1;
+
+	return iwm_hal_send_target_cmd(iwm, &target_cmd, NULL);
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
new file mode 100644
index 0000000..36b13a1
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -0,0 +1,419 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_COMMANDS_H__
+#define __IWM_COMMANDS_H__
+
+#include <linux/ieee80211.h>
+
+#define IWM_BARKER_REBOOT_NOTIFICATION	0xF
+#define IWM_ACK_BARKER_NOTIFICATION	0x10
+
+/* UMAC commands */
+#define UMAC_RST_CTRL_FLG_LARC_CLK_EN	0x0001
+#define UMAC_RST_CTRL_FLG_LARC_RESET	0x0002
+#define UMAC_RST_CTRL_FLG_FUNC_RESET	0x0004
+#define UMAC_RST_CTRL_FLG_DEV_RESET	0x0008
+#define UMAC_RST_CTRL_FLG_WIFI_CORE_EN	0x0010
+#define UMAC_RST_CTRL_FLG_WIFI_LINK_EN	0x0040
+#define UMAC_RST_CTRL_FLG_WIFI_MLME_EN	0x0080
+#define UMAC_RST_CTRL_FLG_NVM_RELOAD	0x0100
+
+struct iwm_umac_cmd_reset {
+	__le32 flags;
+} __attribute__ ((packed));
+
+#define UMAC_PARAM_TBL_ORD_FIX    0x0
+#define UMAC_PARAM_TBL_ORD_VAR    0x1
+#define UMAC_PARAM_TBL_CFG_FIX    0x2
+#define UMAC_PARAM_TBL_CFG_VAR    0x3
+#define UMAC_PARAM_TBL_BSS_TRK    0x4
+#define UMAC_PARAM_TBL_FA_CFG_FIX 0x5
+#define UMAC_PARAM_TBL_STA        0x6
+#define UMAC_PARAM_TBL_CHN        0x7
+#define UMAC_PARAM_TBL_STATISTICS 0x8
+
+/* fast access table */
+enum {
+	CFG_FRAG_THRESHOLD = 0,
+	CFG_FRAME_RETRY_LIMIT,
+	CFG_OS_QUEUE_UTIL_TH,
+	CFG_RX_FILTER,
+	/* <-- LAST --> */
+	FAST_ACCESS_CFG_TBL_FIX_LAST
+};
+
+/* fixed size table */
+enum {
+	CFG_POWER_INDEX = 0,
+	CFG_PM_LEGACY_RX_TIMEOUT,
+	CFG_PM_LEGACY_TX_TIMEOUT,
+	CFG_PM_CTRL_FLAGS,
+	CFG_PM_KEEP_ALIVE_IN_BEACONS,
+	CFG_BT_ON_THRESHOLD,
+	CFG_RTS_THRESHOLD,
+	CFG_CTS_TO_SELF,
+	CFG_COEX_MODE,
+	CFG_WIRELESS_MODE,
+	CFG_ASSOCIATION_TIMEOUT,
+	CFG_ROAM_TIMEOUT,
+	CFG_CAPABILITY_SUPPORTED_RATES,
+	CFG_SCAN_ALLOWED_UNASSOC_FLAGS,
+	CFG_SCAN_ALLOWED_MAIN_ASSOC_FLAGS,
+	CFG_SCAN_ALLOWED_PAN_ASSOC_FLAGS,
+	CFG_SCAN_INTERNAL_PERIODIC_ENABLED,
+	CFG_SCAN_IMM_INTERNAL_PERIODIC_SCAN_ON_INIT,
+	CFG_SCAN_DEFAULT_PERIODIC_FREQ_SEC,
+	CFG_SCAN_NUM_PASSIVE_CHAN_PER_PARTIAL_SCAN,
+	CFG_TLC_SUPPORTED_TX_HT_RATES,
+	CFG_TLC_SUPPORTED_TX_RATES,
+	CFG_TLC_VALID_ANTENNA,
+	CFG_TLC_SPATIAL_STREAM_SUPPORTED,
+	CFG_TLC_RETRY_PER_RATE,
+	CFG_TLC_RETRY_PER_HT_RATE,
+	CFG_TLC_FIXED_RATE,
+	CFG_TLC_FIXED_RATE_FLAGS,
+	CFG_TLC_CONTROL_FLAGS,
+	CFG_TLC_SR_MIN_FAIL,
+	CFG_TLC_SR_MIN_PASS,
+	CFG_TLC_HT_STAY_IN_COL_PASS_THRESH,
+	CFG_TLC_HT_STAY_IN_COL_FAIL_THRESH,
+	CFG_TLC_LEGACY_STAY_IN_COL_PASS_THRESH,
+	CFG_TLC_LEGACY_STAY_IN_COL_FAIL_THRESH,
+	CFG_TLC_HT_FLUSH_STATS_PACKETS,
+	CFG_TLC_LEGACY_FLUSH_STATS_PACKETS,
+	CFG_TLC_LEGACY_FLUSH_STATS_MS,
+	CFG_TLC_HT_FLUSH_STATS_MS,
+	CFG_TLC_STAY_IN_COL_TIME_OUT,
+	CFG_TLC_AGG_SHORT_LIM,
+	CFG_TLC_AGG_LONG_LIM,
+	CFG_TLC_HT_SR_NO_DECREASE,
+	CFG_TLC_LEGACY_SR_NO_DECREASE,
+	CFG_TLC_SR_FORCE_DECREASE,
+	CFG_TLC_SR_ALLOW_INCREASE,
+	CFG_TLC_AGG_SET_LONG,
+	CFG_TLC_AUTO_AGGREGATION,
+	CFG_TLC_AGG_THRESHOLD,
+	CFG_TLC_TID_LOAD_THRESHOLD,
+	CFG_TLC_BLOCK_ACK_TIMEOUT,
+	CFG_TLC_NO_BA_COUNTED_AS_ONE,
+	CFG_TLC_NUM_BA_STREAMS_ALLOWED,
+	CFG_TLC_NUM_BA_STREAMS_PRESENT,
+	CFG_TLC_RENEW_ADDBA_DELAY,
+	CFG_TLC_NUM_OF_MULTISEC_TO_COUN_LOAD,
+	CFG_TLC_IS_STABLE_IN_HT,
+	CFG_RLC_CHAIN_CTRL,
+	CFG_TRK_TABLE_OP_MODE,
+	CFG_TRK_TABLE_RSSI_THRESHOLD,
+	CFG_TX_PWR_TARGET, /* Used By xVT */
+	CFG_TX_PWR_LIMIT_USR,
+	CFG_TX_PWR_LIMIT_BSS, /* 11d limit */
+	CFG_TX_PWR_LIMIT_BSS_CONSTRAINT, /* 11h constraint */
+	CFG_TX_PWR_MODE,
+	CFG_MLME_DBG_NOTIF_BLOCK,
+	CFG_BT_OFF_BECONS_INTERVALS,
+	CFG_BT_FRAG_DURATION,
+
+	/* <-- LAST --> */
+	CFG_TBL_FIX_LAST
+};
+
+/* variable size table */
+enum {
+	CFG_NET_ADDR = 0,
+	CFG_PROFILE,
+	/* <-- LAST --> */
+	CFG_TBL_VAR_LAST
+};
+
+struct iwm_umac_cmd_set_param_fix {
+	__le16 tbl;
+	__le16 key;
+	__le32 value;
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_set_param_var {
+	__le16 tbl;
+	__le16 key;
+	__le16 len;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_get_param {
+	__le16 tbl;
+	__le16 key;
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_get_param_resp {
+	__le16 tbl;
+	__le16 key;
+	__le16 len;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_eeprom_proxy_hdr {
+	__le32 type;
+	__le32 offset;
+	__le32 len;
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_eeprom_proxy {
+	struct iwm_umac_cmd_eeprom_proxy_hdr hdr;
+	u8 buf[0];
+} __attribute__ ((packed));
+
+#define IWM_UMAC_CMD_EEPROM_TYPE_READ       0x1
+#define IWM_UMAC_CMD_EEPROM_TYPE_WRITE      0x2
+
+#define UMAC_CHANNEL_FLAG_VALID		BIT(0)
+#define UMAC_CHANNEL_FLAG_IBSS		BIT(1)
+#define UMAC_CHANNEL_FLAG_ACTIVE	BIT(3)
+#define UMAC_CHANNEL_FLAG_RADAR		BIT(4)
+#define UMAC_CHANNEL_FLAG_DFS		BIT(7)
+
+struct iwm_umac_channel_info {
+	u8 band;
+	u8 type;
+	u8 reserved;
+	u8 flags;
+	__le32 channels_mask;
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_get_channel_list {
+	__le16 count;
+	__le16 reserved;
+	struct iwm_umac_channel_info ch[0];
+} __attribute__ ((packed));
+
+
+/* UMAC WiFi interface commands */
+
+/* Coexistence mode */
+#define COEX_MODE_SA  0x1
+#define COEX_MODE_XOR 0x2
+#define COEX_MODE_CM  0x3
+#define COEX_MODE_MAX 0x4
+
+/* Wireless mode */
+#define WIRELESS_MODE_11A  0x1
+#define WIRELESS_MODE_11G  0x2
+
+#define UMAC_PROFILE_EX_IE_REQUIRED	0x1
+#define UMAC_PROFILE_QOS_ALLOWED	0x2
+
+/* Scanning */
+#define UMAC_WIFI_IF_PROBE_OPTION_MAX        10
+
+#define UMAC_WIFI_IF_SCAN_TYPE_USER          0x0
+#define UMAC_WIFI_IF_SCAN_TYPE_UMAC_RESERVED 0x1
+#define UMAC_WIFI_IF_SCAN_TYPE_HOST_PERIODIC 0x2
+#define UMAC_WIFI_IF_SCAN_TYPE_MAX           0x3
+
+struct iwm_umac_ssid {
+	u8 ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_scan_request {
+	struct iwm_umac_wifi_if hdr;
+	__le32 type; /* UMAC_WIFI_IF_SCAN_TYPE_* */
+	u8 ssid_num;
+	u8 seq_num;
+	u8 timeout; /* In seconds */
+	u8 reserved;
+	struct iwm_umac_ssid ssids[UMAC_WIFI_IF_PROBE_OPTION_MAX];
+} __attribute__ ((packed));
+
+#define UMAC_CIPHER_TYPE_NONE		0xFF
+#define UMAC_CIPHER_TYPE_USE_GROUPCAST	0x00
+#define UMAC_CIPHER_TYPE_WEP_40		0x01
+#define UMAC_CIPHER_TYPE_WEP_104	0x02
+#define UMAC_CIPHER_TYPE_TKIP		0x04
+#define UMAC_CIPHER_TYPE_CCMP		0x08
+
+/* Supported authentication types - bitmap */
+#define UMAC_AUTH_TYPE_OPEN		0x00
+#define UMAC_AUTH_TYPE_LEGACY_PSK	0x01
+#define UMAC_AUTH_TYPE_8021X		0x02
+#define UMAC_AUTH_TYPE_RSNA_PSK		0x04
+
+/* iwm_umac_security.flag is WPA supported -- bits[0:0] */
+#define UMAC_SEC_FLG_WPA_ON_POS		0
+#define UMAC_SEC_FLG_WPA_ON_SEED	1
+#define UMAC_SEC_FLG_WPA_ON_MSK (UMAC_SEC_FLG_WPA_ON_SEED << \
+				 UMAC_SEC_FLG_WPA_ON_POS)
+
+/* iwm_umac_security.flag is WPA2 supported -- bits [1:1] */
+#define UMAC_SEC_FLG_RSNA_ON_POS	1
+#define UMAC_SEC_FLG_RSNA_ON_SEED	1
+#define UMAC_SEC_FLG_RSNA_ON_MSK        (UMAC_SEC_FLG_RSNA_ON_SEED << \
+					 UMAC_SEC_FLG_RSNA_ON_POS)
+
+/* iwm_umac_security.flag is WSC mode on -- bits [2:2] */
+#define UMAC_SEC_FLG_WSC_ON_POS		2
+#define UMAC_SEC_FLG_WSC_ON_SEED	1
+
+/* Legacy profile can use only WEP40 and WEP104 for encryption and
+ * OPEN or PSK for authentication */
+#define UMAC_SEC_FLG_LEGACY_PROFILE	0
+
+struct iwm_umac_security {
+	u8 auth_type;
+	u8 ucast_cipher;
+	u8 mcast_cipher;
+	u8 flags;
+} __attribute__ ((packed));
+
+struct iwm_umac_ibss {
+	u8 beacon_interval;	/* in millisecond */
+	u8 atim;		/* in millisecond */
+	s8 join_only;
+	u8 band;
+	u8 channel;
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+#define UMAC_MODE_BSS	0
+#define UMAC_MODE_IBSS	1
+
+#define UMAC_BSSID_MAX	4
+
+struct iwm_umac_profile {
+	struct iwm_umac_wifi_if hdr;
+	__le32 mode;
+	struct iwm_umac_ssid ssid;
+	u8 bssid[UMAC_BSSID_MAX][ETH_ALEN];
+	struct iwm_umac_security sec;
+	struct iwm_umac_ibss ibss;
+	__le32 channel_2ghz;
+	__le32 channel_5ghz;
+	__le16 flags;
+	u8 wireless_mode;
+	u8 bss_num;
+} __attribute__ ((packed));
+
+struct iwm_umac_invalidate_profile {
+	struct iwm_umac_wifi_if hdr;
+	u8 reason;
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+/* Encryption key commands */
+struct iwm_umac_key_wep40 {
+	struct iwm_umac_wifi_if hdr;
+	struct iwm_umac_key_hdr key_hdr;
+	u8 key[WLAN_KEY_LEN_WEP40];
+	u8 static_key;
+	u8 reserved[2];
+} __attribute__ ((packed));
+
+struct iwm_umac_key_wep104 {
+	struct iwm_umac_wifi_if hdr;
+	struct iwm_umac_key_hdr key_hdr;
+	u8 key[WLAN_KEY_LEN_WEP104];
+	u8 static_key;
+	u8 reserved[2];
+} __attribute__ ((packed));
+
+#define IWM_TKIP_KEY_SIZE 16
+#define IWM_TKIP_MIC_SIZE 8
+struct iwm_umac_key_tkip {
+	struct iwm_umac_wifi_if hdr;
+	struct iwm_umac_key_hdr key_hdr;
+	u8 iv_count[6];
+	u8 reserved[2];
+	u8 tkip_key[IWM_TKIP_KEY_SIZE];
+	u8 mic_rx_key[IWM_TKIP_MIC_SIZE];
+	u8 mic_tx_key[IWM_TKIP_MIC_SIZE];
+} __attribute__ ((packed));
+
+struct iwm_umac_key_ccmp {
+	struct iwm_umac_wifi_if hdr;
+	struct iwm_umac_key_hdr key_hdr;
+	u8 iv_count[6];
+	u8 reserved[2];
+	u8 key[WLAN_KEY_LEN_CCMP];
+} __attribute__ ((packed));
+
+struct iwm_umac_key_remove {
+	struct iwm_umac_wifi_if hdr;
+	struct iwm_umac_key_hdr key_hdr;
+} __attribute__ ((packed));
+
+struct iwm_umac_tx_key_id {
+	struct iwm_umac_wifi_if hdr;
+	u8 key_idx;
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+struct iwm_umac_cmd_stats_req {
+	__le32 flags;
+} __attribute__ ((packed));
+
+/* LMAC commands */
+int iwm_read_mac(struct iwm_priv *iwm, u8 *mac);
+int iwm_send_prio_table(struct iwm_priv *iwm);
+int iwm_send_init_calib_cfg(struct iwm_priv *iwm, u8 calib_requested);
+int iwm_send_periodic_calib_cfg(struct iwm_priv *iwm, u8 calib_requested);
+int iwm_send_calib_results(struct iwm_priv *iwm);
+int iwm_store_rxiq_calib_result(struct iwm_priv *iwm);
+
+/* UMAC commands */
+int iwm_send_wifi_if_cmd(struct iwm_priv *iwm, void *payload, u16 payload_size,
+			 bool resp);
+int iwm_send_umac_reset(struct iwm_priv *iwm, __le32 reset_flags, bool resp);
+int iwm_umac_set_config_fix(struct iwm_priv *iwm, u16 tbl, u16 key, u32 value);
+int iwm_umac_set_config_var(struct iwm_priv *iwm, u16 key,
+			    void *payload, u16 payload_size);
+int iwm_send_umac_config(struct iwm_priv *iwm, __le32 reset_flags);
+int iwm_send_mlme_profile(struct iwm_priv *iwm);
+int iwm_invalidate_mlme_profile(struct iwm_priv *iwm);
+int iwm_send_packet(struct iwm_priv *iwm, struct sk_buff *skb, int pool_id);
+int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx);
+int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
+		struct iwm_key *key);
+int iwm_send_umac_stats_req(struct iwm_priv *iwm, u32 flags);
+int iwm_send_umac_channel_list(struct iwm_priv *iwm);
+int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
+		   int ssid_num);
+int iwm_scan_one_ssid(struct iwm_priv *iwm, u8 *ssid, int ssid_len);
+
+/* UDMA commands */
+int iwm_target_reset(struct iwm_priv *iwm);
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/debug.h b/drivers/net/wireless/iwmc3200wifi/debug.h
new file mode 100644
index 0000000..8fbb42d
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/debug.h
@@ -0,0 +1,124 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#ifndef __IWM_DEBUG_H__
+#define __IWM_DEBUG_H__
+
+#define IWM_ERR(p, f, a...) dev_err(iwm_to_dev(p), f, ## a)
+#define IWM_WARN(p, f, a...) dev_warn(iwm_to_dev(p), f, ## a)
+#define IWM_INFO(p, f, a...) dev_info(iwm_to_dev(p), f, ## a)
+#define IWM_CRIT(p, f, a...) dev_crit(iwm_to_dev(p), f, ## a)
+
+#ifdef CONFIG_IWM_DEBUG
+
+#define IWM_DEBUG_MODULE(i, level, module, f, a...)			     \
+do {									     \
+	if (unlikely(i->dbg.dbg_module[IWM_DM_##module] >= (IWM_DL_##level)))\
+		dev_printk(KERN_INFO, (iwm_to_dev(i)),	             \
+			   "%s " f, __func__ , ## a);			     \
+} while (0)
+
+#define IWM_HEXDUMP(i, level, module, pref, buf, len)		             \
+do {									     \
+	if (unlikely(i->dbg.dbg_module[IWM_DM_##module] >= (IWM_DL_##level)))\
+		print_hex_dump(KERN_INFO, pref, DUMP_PREFIX_OFFSET,	     \
+			       16, 1, buf, len, 1);			     \
+} while (0)
+
+#else
+
+#define IWM_DEBUG_MODULE(i, level, module, f, a...)
+#define IWM_HEXDUMP(i, level, module, pref, buf, len)
+
+#endif /* CONFIG_IWM_DEBUG */
+
+/* Debug modules */
+enum iwm_debug_module_id {
+	IWM_DM_BOOT = 0,
+	IWM_DM_FW,
+	IWM_DM_SDIO,
+	IWM_DM_NTF,
+	IWM_DM_RX,
+	IWM_DM_TX,
+	IWM_DM_MLME,
+	IWM_DM_CMD,
+	IWM_DM_WEXT,
+	__IWM_DM_NR,
+};
+#define IWM_DM_DEFAULT 0
+
+#define IWM_DBG_BOOT(i, l, f, a...) IWM_DEBUG_MODULE(i, l, BOOT, f, ## a)
+#define IWM_DBG_FW(i, l, f, a...)   IWM_DEBUG_MODULE(i, l, FW, f, ## a)
+#define IWM_DBG_SDIO(i, l, f, a...) IWM_DEBUG_MODULE(i, l, SDIO, f, ## a)
+#define IWM_DBG_NTF(i, l, f, a...)  IWM_DEBUG_MODULE(i, l, NTF, f, ## a)
+#define IWM_DBG_RX(i, l, f, a...)   IWM_DEBUG_MODULE(i, l, RX, f, ## a)
+#define IWM_DBG_TX(i, l, f, a...)   IWM_DEBUG_MODULE(i, l, TX, f, ## a)
+#define IWM_DBG_MLME(i, l, f, a...) IWM_DEBUG_MODULE(i, l, MLME, f, ## a)
+#define IWM_DBG_CMD(i, l, f, a...)  IWM_DEBUG_MODULE(i, l, CMD, f, ## a)
+#define IWM_DBG_WEXT(i, l, f, a...) IWM_DEBUG_MODULE(i, l, WEXT, f, ## a)
+
+/* Debug levels */
+enum iwm_debug_level {
+	IWM_DL_NONE = 0,
+	IWM_DL_ERR,
+	IWM_DL_WARN,
+	IWM_DL_INFO,
+	IWM_DL_DBG,
+};
+#define IWM_DL_DEFAULT IWM_DL_ERR
+
+struct iwm_debugfs {
+	struct iwm_priv *iwm;
+	struct dentry *rootdir;
+	struct dentry *devdir;
+	struct dentry *dbgdir;
+	struct dentry *txdir;
+	struct dentry *rxdir;
+	struct dentry *busdir;
+
+	u32 dbg_level;
+	struct dentry *dbg_level_dentry;
+
+	unsigned long dbg_modules;
+	struct dentry *dbg_modules_dentry;
+
+	u8 dbg_module[__IWM_DM_NR];
+	struct dentry *dbg_module_dentries[__IWM_DM_NR];
+
+	struct dentry *txq_dentry;
+	struct dentry *tx_credit_dentry;
+	struct dentry *rx_ticket_dentry;
+};
+
+#ifdef CONFIG_IWM_DEBUG
+int iwm_debugfs_init(struct iwm_priv *iwm);
+void iwm_debugfs_exit(struct iwm_priv *iwm);
+#else
+static inline int iwm_debugfs_init(struct iwm_priv *iwm)
+{
+	return 0;
+}
+static inline void iwm_debugfs_exit(struct iwm_priv *iwm) {}
+#endif
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
new file mode 100644
index 0000000..0fa7b91
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -0,0 +1,453 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/debugfs.h>
+
+#include "iwm.h"
+#include "bus.h"
+#include "rx.h"
+#include "debug.h"
+
+static struct {
+	u8 id;
+	char *name;
+} iwm_debug_module[__IWM_DM_NR] = {
+	 {IWM_DM_BOOT, "boot"},
+	 {IWM_DM_FW,   "fw"},
+	 {IWM_DM_SDIO, "sdio"},
+	 {IWM_DM_NTF,  "ntf"},
+	 {IWM_DM_RX,   "rx"},
+	 {IWM_DM_TX,   "tx"},
+	 {IWM_DM_MLME, "mlme"},
+	 {IWM_DM_CMD,  "cmd"},
+	 {IWM_DM_WEXT,  "wext"},
+};
+
+#define add_dbg_module(dbg, name, id, initlevel) 	\
+do {							\
+	struct dentry *d;				\
+	dbg.dbg_module[id] = (initlevel);		\
+	d = debugfs_create_x8(name, 0600, dbg.dbgdir,	\
+			     &(dbg.dbg_module[id]));	\
+	if (!IS_ERR(d))					\
+		dbg.dbg_module_dentries[id] = d;        \
+} while (0)
+
+static int iwm_debugfs_u32_read(void *data, u64 *val)
+{
+	struct iwm_priv *iwm = data;
+
+	*val = iwm->dbg.dbg_level;
+	return 0;
+}
+
+static int iwm_debugfs_dbg_level_write(void *data, u64 val)
+{
+	struct iwm_priv *iwm = data;
+	int i;
+
+	iwm->dbg.dbg_level = val;
+
+	for (i = 0; i < __IWM_DM_NR; i++)
+		iwm->dbg.dbg_module[i] = val;
+
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_iwm_dbg_level,
+			iwm_debugfs_u32_read, iwm_debugfs_dbg_level_write,
+			"%llu\n");
+
+static int iwm_debugfs_dbg_modules_write(void *data, u64 val)
+{
+	struct iwm_priv *iwm = data;
+	int i, bit;
+
+	iwm->dbg.dbg_modules = val;
+
+	for (i = 0; i < __IWM_DM_NR; i++)
+		iwm->dbg.dbg_module[i] = 0;
+
+	for_each_bit(bit, &iwm->dbg.dbg_modules, __IWM_DM_NR)
+		iwm->dbg.dbg_module[bit] = iwm->dbg.dbg_level;
+
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_iwm_dbg_modules,
+			iwm_debugfs_u32_read, iwm_debugfs_dbg_modules_write,
+			"%llu\n");
+
+static int iwm_txrx_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+
+static ssize_t iwm_debugfs_txq_read(struct file *filp, char __user *buffer,
+				   size_t count, loff_t *ppos)
+{
+	struct iwm_priv *iwm = filp->private_data;
+	char *buf;
+	int i, buf_len = 4096;
+	size_t len = 0;
+	ssize_t ret;
+
+	if (*ppos != 0)
+		return 0;
+	if (count < sizeof(buf))
+		return -ENOSPC;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < IWM_TX_QUEUES; i++) {
+		struct iwm_tx_queue *txq = &iwm->txq[i];
+		struct sk_buff *skb;
+		int j;
+		unsigned long flags;
+
+		spin_lock_irqsave(&txq->queue.lock, flags);
+
+		skb = (struct sk_buff *)&txq->queue;
+
+		len += snprintf(buf + len, buf_len - len, "TXQ #%d\n", i);
+		len += snprintf(buf + len, buf_len - len, "\tStopped:     %d\n",
+				__netif_subqueue_stopped(iwm_to_ndev(iwm),
+							 txq->id));
+		len += snprintf(buf + len, buf_len - len, "\tConcat count:%d\n",
+				txq->concat_count);
+		len += snprintf(buf + len, buf_len - len, "\tQueue len:   %d\n",
+				skb_queue_len(&txq->queue));
+		for (j = 0; j < skb_queue_len(&txq->queue); j++) {
+			struct iwm_tx_info *tx_info;
+
+			skb = skb->next;
+			tx_info = skb_to_tx_info(skb);
+
+			len += snprintf(buf + len, buf_len - len,
+					"\tSKB #%d\n", j);
+			len += snprintf(buf + len, buf_len - len,
+					"\t\tsta:   %d\n", tx_info->sta);
+			len += snprintf(buf + len, buf_len - len,
+					"\t\tcolor: %d\n", tx_info->color);
+			len += snprintf(buf + len, buf_len - len,
+					"\t\ttid:   %d\n", tx_info->tid);
+		}
+
+		spin_unlock_irqrestore(&txq->queue.lock, flags);
+	}
+
+	ret = simple_read_from_buffer(buffer, len, ppos, buf, buf_len);
+	kfree(buf);
+
+	return ret;
+}
+
+static ssize_t iwm_debugfs_tx_credit_read(struct file *filp,
+					  char __user *buffer,
+					  size_t count, loff_t *ppos)
+{
+	struct iwm_priv *iwm = filp->private_data;
+	struct iwm_tx_credit *credit = &iwm->tx_credit;
+	char *buf;
+	int i, buf_len = 4096;
+	size_t len = 0;
+	ssize_t ret;
+
+	if (*ppos != 0)
+		return 0;
+	if (count < sizeof(buf))
+		return -ENOSPC;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += snprintf(buf + len, buf_len - len,
+			"NR pools:  %d\n", credit->pool_nr);
+	len += snprintf(buf + len, buf_len - len,
+			"pools map: 0x%lx\n", credit->full_pools_map);
+
+	len += snprintf(buf + len, buf_len - len, "\n### POOLS ###\n");
+	for (i = 0; i < IWM_MACS_OUT_GROUPS; i++) {
+		len += snprintf(buf + len, buf_len - len,
+				"pools entry #%d\n", i);
+		len += snprintf(buf + len, buf_len - len,
+				"\tid:          %d\n",
+				credit->pools[i].id);
+		len += snprintf(buf + len, buf_len - len,
+				"\tsid:         %d\n",
+				credit->pools[i].sid);
+		len += snprintf(buf + len, buf_len - len,
+				"\tmin_pages:   %d\n",
+				credit->pools[i].min_pages);
+		len += snprintf(buf + len, buf_len - len,
+				"\tmax_pages:   %d\n",
+				credit->pools[i].max_pages);
+		len += snprintf(buf + len, buf_len - len,
+				"\talloc_pages: %d\n",
+				credit->pools[i].alloc_pages);
+		len += snprintf(buf + len, buf_len - len,
+				"\tfreed_pages: %d\n",
+				credit->pools[i].total_freed_pages);
+	}
+
+	len += snprintf(buf + len, buf_len - len, "\n### SPOOLS ###\n");
+	for (i = 0; i < IWM_MACS_OUT_SGROUPS; i++) {
+		len += snprintf(buf + len, buf_len - len,
+				"spools entry #%d\n", i);
+		len += snprintf(buf + len, buf_len - len,
+				"\tid:          %d\n",
+				credit->spools[i].id);
+		len += snprintf(buf + len, buf_len - len,
+				"\tmax_pages:   %d\n",
+				credit->spools[i].max_pages);
+		len += snprintf(buf + len, buf_len - len,
+				"\talloc_pages: %d\n",
+				credit->spools[i].alloc_pages);
+
+	}
+
+	ret = simple_read_from_buffer(buffer, len, ppos, buf, buf_len);
+	kfree(buf);
+
+	return ret;
+}
+
+static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
+					  char __user *buffer,
+					  size_t count, loff_t *ppos)
+{
+	struct iwm_priv *iwm = filp->private_data;
+	struct iwm_rx_ticket_node *ticket, *next;
+	char *buf;
+	int buf_len = 4096, i;
+	size_t len = 0;
+	ssize_t ret;
+
+	if (*ppos != 0)
+		return 0;
+	if (count < sizeof(buf))
+		return -ENOSPC;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	list_for_each_entry_safe(ticket, next, &iwm->rx_tickets, node) {
+		len += snprintf(buf + len, buf_len - len, "Ticket #%d\n",
+				ticket->ticket->id);
+		len += snprintf(buf + len, buf_len - len, "\taction: 0x%x\n",
+				ticket->ticket->action);
+		len += snprintf(buf + len, buf_len - len, "\tflags:  0x%x\n",
+				ticket->ticket->flags);
+	}
+
+	for (i = 0; i < IWM_RX_ID_HASH; i++) {
+		struct iwm_rx_packet *packet, *nxt;
+		struct list_head *pkt_list = &iwm->rx_packets[i];
+		if (!list_empty(pkt_list)) {
+			len += snprintf(buf + len, buf_len - len,
+					"Packet hash #%d\n", i);
+			list_for_each_entry_safe(packet, nxt, pkt_list, node) {
+				len += snprintf(buf + len, buf_len - len,
+						"\tPacket id:     %d\n",
+						packet->id);
+				len += snprintf(buf + len, buf_len - len,
+						"\tPacket length: %lu\n",
+						packet->pkt_size);
+			}
+		}
+	}
+
+	ret = simple_read_from_buffer(buffer, len, ppos, buf, buf_len);
+	kfree(buf);
+
+	return ret;
+}
+
+
+static const struct file_operations iwm_debugfs_txq_fops = {
+	.owner =	THIS_MODULE,
+	.open =		iwm_txrx_open,
+	.read =		iwm_debugfs_txq_read,
+};
+
+static const struct file_operations iwm_debugfs_tx_credit_fops = {
+	.owner =	THIS_MODULE,
+	.open =		iwm_txrx_open,
+	.read =		iwm_debugfs_tx_credit_read,
+};
+
+static const struct file_operations iwm_debugfs_rx_ticket_fops = {
+	.owner =	THIS_MODULE,
+	.open =		iwm_txrx_open,
+	.read =		iwm_debugfs_rx_ticket_read,
+};
+
+int iwm_debugfs_init(struct iwm_priv *iwm)
+{
+	int i, result;
+	char devdir[16];
+
+	iwm->dbg.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	result = PTR_ERR(iwm->dbg.rootdir);
+	if (!result || IS_ERR(iwm->dbg.rootdir)) {
+		if (result == -ENODEV) {
+			IWM_ERR(iwm, "DebugFS (CONFIG_DEBUG_FS) not "
+				"enabled in kernel config\n");
+			result = 0;	/* No debugfs support */
+		}
+		IWM_ERR(iwm, "Couldn't create rootdir: %d\n", result);
+		goto error;
+	}
+
+	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(iwm_to_wiphy(iwm)));
+
+	iwm->dbg.devdir = debugfs_create_dir(devdir, iwm->dbg.rootdir);
+	result = PTR_ERR(iwm->dbg.devdir);
+	if (IS_ERR(iwm->dbg.devdir) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create devdir: %d\n", result);
+		goto error;
+	}
+
+	iwm->dbg.dbgdir = debugfs_create_dir("debug", iwm->dbg.devdir);
+	result = PTR_ERR(iwm->dbg.dbgdir);
+	if (IS_ERR(iwm->dbg.dbgdir) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create dbgdir: %d\n", result);
+		goto error;
+	}
+
+	iwm->dbg.rxdir = debugfs_create_dir("rx", iwm->dbg.devdir);
+	result = PTR_ERR(iwm->dbg.rxdir);
+	if (IS_ERR(iwm->dbg.rxdir) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create rx dir: %d\n", result);
+		goto error;
+	}
+
+	iwm->dbg.txdir = debugfs_create_dir("tx", iwm->dbg.devdir);
+	result = PTR_ERR(iwm->dbg.txdir);
+	if (IS_ERR(iwm->dbg.txdir) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create tx dir: %d\n", result);
+		goto error;
+	}
+
+	iwm->dbg.busdir = debugfs_create_dir("bus", iwm->dbg.devdir);
+	result = PTR_ERR(iwm->dbg.busdir);
+	if (IS_ERR(iwm->dbg.busdir) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create bus dir: %d\n", result);
+		goto error;
+	}
+
+	if (iwm->bus_ops->debugfs_init) {
+		result = iwm->bus_ops->debugfs_init(iwm, iwm->dbg.busdir);
+		if (result < 0) {
+			IWM_ERR(iwm, "Couldn't create bus entry: %d\n", result);
+			goto error;
+		}
+	}
+
+
+	iwm->dbg.dbg_level = IWM_DL_NONE;
+	iwm->dbg.dbg_level_dentry =
+		debugfs_create_file("level", 0200, iwm->dbg.dbgdir, iwm,
+				    &fops_iwm_dbg_level);
+	result = PTR_ERR(iwm->dbg.dbg_level_dentry);
+	if (IS_ERR(iwm->dbg.dbg_level_dentry) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create dbg_level: %d\n", result);
+		goto error;
+	}
+
+
+	iwm->dbg.dbg_modules = IWM_DM_DEFAULT;
+	iwm->dbg.dbg_modules_dentry =
+		debugfs_create_file("modules", 0200, iwm->dbg.dbgdir, iwm,
+				    &fops_iwm_dbg_modules);
+	result = PTR_ERR(iwm->dbg.dbg_modules_dentry);
+	if (IS_ERR(iwm->dbg.dbg_modules_dentry) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create dbg_modules: %d\n", result);
+		goto error;
+	}
+
+	for (i = 0; i < __IWM_DM_NR; i++)
+		add_dbg_module(iwm->dbg, iwm_debug_module[i].name,
+			       iwm_debug_module[i].id, IWM_DL_DEFAULT);
+
+	iwm->dbg.txq_dentry = debugfs_create_file("queues", 0200,
+						  iwm->dbg.txdir, iwm,
+						  &iwm_debugfs_txq_fops);
+	result = PTR_ERR(iwm->dbg.txq_dentry);
+	if (IS_ERR(iwm->dbg.txq_dentry) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create tx queue: %d\n", result);
+		goto error;
+	}
+
+	iwm->dbg.tx_credit_dentry = debugfs_create_file("credits", 0200,
+						   iwm->dbg.txdir, iwm,
+						   &iwm_debugfs_tx_credit_fops);
+	result = PTR_ERR(iwm->dbg.tx_credit_dentry);
+	if (IS_ERR(iwm->dbg.tx_credit_dentry) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create tx credit: %d\n", result);
+		goto error;
+	}
+
+	iwm->dbg.rx_ticket_dentry = debugfs_create_file("tickets", 0200,
+						  iwm->dbg.rxdir, iwm,
+						  &iwm_debugfs_rx_ticket_fops);
+	result = PTR_ERR(iwm->dbg.rx_ticket_dentry);
+	if (IS_ERR(iwm->dbg.rx_ticket_dentry) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create rx ticket: %d\n", result);
+		goto error;
+	}
+
+	return 0;
+
+ error:
+	return result;
+}
+
+void iwm_debugfs_exit(struct iwm_priv *iwm)
+{
+	int i;
+
+	for (i = 0; i < __IWM_DM_NR; i++)
+		debugfs_remove(iwm->dbg.dbg_module_dentries[i]);
+
+	debugfs_remove(iwm->dbg.dbg_modules_dentry);
+	debugfs_remove(iwm->dbg.dbg_level_dentry);
+	debugfs_remove(iwm->dbg.txq_dentry);
+	debugfs_remove(iwm->dbg.tx_credit_dentry);
+	debugfs_remove(iwm->dbg.rx_ticket_dentry);
+	if (iwm->bus_ops->debugfs_exit)
+		iwm->bus_ops->debugfs_exit(iwm);
+
+	debugfs_remove(iwm->dbg.busdir);
+	debugfs_remove(iwm->dbg.dbgdir);
+	debugfs_remove(iwm->dbg.txdir);
+	debugfs_remove(iwm->dbg.rxdir);
+	debugfs_remove(iwm->dbg.devdir);
+	debugfs_remove(iwm->dbg.rootdir);
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/eeprom.c b/drivers/net/wireless/iwmc3200wifi/eeprom.c
new file mode 100644
index 0000000..0f34b84
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/eeprom.c
@@ -0,0 +1,187 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#include <linux/kernel.h>
+
+#include "iwm.h"
+#include "umac.h"
+#include "commands.h"
+#include "eeprom.h"
+
+static struct iwm_eeprom_entry eeprom_map[] = {
+	[IWM_EEPROM_SIG] =
+	{"Signature", IWM_EEPROM_SIG_OFF, IWM_EEPROM_SIG_LEN},
+
+	[IWM_EEPROM_VERSION] =
+	{"Version", IWM_EEPROM_VERSION_OFF, IWM_EEPROM_VERSION_LEN},
+
+	[IWM_EEPROM_OEM_HW_VERSION] =
+	{"OEM HW version", IWM_EEPROM_OEM_HW_VERSION_OFF,
+	 IWM_EEPROM_OEM_HW_VERSION_LEN},
+
+	[IWM_EEPROM_MAC_VERSION] =
+	{"MAC version", IWM_EEPROM_MAC_VERSION_OFF, IWM_EEPROM_MAC_VERSION_LEN},
+
+	[IWM_EEPROM_CARD_ID] =
+	{"Card ID", IWM_EEPROM_CARD_ID_OFF, IWM_EEPROM_CARD_ID_LEN},
+
+	[IWM_EEPROM_RADIO_CONF] =
+	{"Radio config", IWM_EEPROM_RADIO_CONF_OFF, IWM_EEPROM_RADIO_CONF_LEN},
+
+	[IWM_EEPROM_SKU_CAP] =
+	{"SKU capabilities", IWM_EEPROM_SKU_CAP_OFF, IWM_EEPROM_SKU_CAP_LEN},
+
+	[IWM_EEPROM_CALIB_RXIQ_OFFSET] =
+	{"RX IQ offset", IWM_EEPROM_CALIB_RXIQ_OFF, IWM_EEPROM_INDIRECT_LEN},
+
+	[IWM_EEPROM_CALIB_RXIQ] =
+	{"Calib RX IQ", 0, IWM_EEPROM_CALIB_RXIQ_LEN},
+};
+
+
+static int iwm_eeprom_read(struct iwm_priv *iwm, u8 eeprom_id)
+{
+	int ret;
+	u32 entry_size, chunk_size, data_offset = 0, addr_offset = 0;
+	u32 addr;
+	struct iwm_udma_wifi_cmd udma_cmd;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_umac_cmd_eeprom_proxy eeprom_cmd;
+
+	if (eeprom_id > (IWM_EEPROM_LAST - 1))
+		return -EINVAL;
+
+	entry_size = eeprom_map[eeprom_id].length;
+
+	if (eeprom_id >= IWM_EEPROM_INDIRECT_DATA) {
+		/* indirect data */
+		u32 off_id = eeprom_id - IWM_EEPROM_INDIRECT_DATA +
+			     IWM_EEPROM_INDIRECT_OFFSET;
+
+		eeprom_map[eeprom_id].offset =
+			*(u16 *)(iwm->eeprom + eeprom_map[off_id].offset) << 1;
+	}
+
+	addr = eeprom_map[eeprom_id].offset;
+
+	udma_cmd.eop = 1;
+	udma_cmd.credit_group = 0x4;
+	udma_cmd.ra_tid = UMAC_HDI_ACT_TBL_IDX_HOST_CMD;
+	udma_cmd.lmac_offset = 0;
+
+	umac_cmd.id = UMAC_CMD_OPCODE_EEPROM_PROXY;
+	umac_cmd.resp = 1;
+
+	while (entry_size > 0) {
+		chunk_size = min_t(u32, entry_size, IWM_MAX_EEPROM_DATA_LEN);
+
+		eeprom_cmd.hdr.type =
+			cpu_to_le32(IWM_UMAC_CMD_EEPROM_TYPE_READ);
+		eeprom_cmd.hdr.offset = cpu_to_le32(addr + addr_offset);
+		eeprom_cmd.hdr.len = cpu_to_le32(chunk_size);
+
+		ret = iwm_hal_send_umac_cmd(iwm, &udma_cmd,
+					    &umac_cmd, &eeprom_cmd,
+				     sizeof(struct iwm_umac_cmd_eeprom_proxy));
+		if (ret < 0) {
+			IWM_ERR(iwm, "Couldn't read eeprom\n");
+			return ret;
+		}
+
+		ret = iwm_notif_handle(iwm, UMAC_CMD_OPCODE_EEPROM_PROXY,
+				       IWM_SRC_UMAC, 2*HZ);
+		if (ret < 0) {
+			IWM_ERR(iwm, "Did not get any eeprom answer\n");
+			return ret;
+		}
+
+		data_offset += chunk_size;
+		addr_offset += chunk_size;
+		entry_size -= chunk_size;
+	}
+
+	return 0;
+}
+
+u8 *iwm_eeprom_access(struct iwm_priv *iwm, u8 eeprom_id)
+{
+	if (!iwm->eeprom)
+		return ERR_PTR(-ENODEV);
+
+	return iwm->eeprom + eeprom_map[eeprom_id].offset;
+}
+
+int iwm_eeprom_init(struct iwm_priv *iwm)
+{
+	int i, ret = 0;
+	char name[32];
+
+	iwm->eeprom = kzalloc(IWM_EEPROM_LEN, GFP_KERNEL);
+	if (!iwm->eeprom)
+		return -ENOMEM;
+
+	for (i = IWM_EEPROM_FIRST; i < IWM_EEPROM_LAST; i++) {
+#ifdef CONFIG_IWM_B0_HW_SUPPORT
+		if (iwm->conf.hw_b0 && (i >= IWM_EEPROM_INDIRECT_OFFSET))
+			break;
+#endif
+		ret = iwm_eeprom_read(iwm, i);
+		if (ret < 0) {
+			IWM_ERR(iwm, "Couldn't read eeprom entry #%d: %s\n",
+				i, eeprom_map[i].name);
+			break;
+		}
+	}
+
+	IWM_DBG_BOOT(iwm, DBG, "EEPROM dump:\n");
+	for (i = IWM_EEPROM_FIRST; i < IWM_EEPROM_LAST; i++) {
+		memset(name, 0, 32);
+		sprintf(name, "%s: ", eeprom_map[i].name);
+
+		IWM_HEXDUMP(iwm, DBG, BOOT, name,
+			    iwm->eeprom + eeprom_map[i].offset,
+			    eeprom_map[i].length);
+	}
+
+	return ret;
+}
+
+void iwm_eeprom_exit(struct iwm_priv *iwm)
+{
+	kfree(iwm->eeprom);
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/eeprom.h b/drivers/net/wireless/iwmc3200wifi/eeprom.h
new file mode 100644
index 0000000..cdb31a6
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/eeprom.h
@@ -0,0 +1,114 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_EEPROM_H__
+#define __IWM_EEPROM_H__
+
+enum {
+	IWM_EEPROM_SIG = 0,
+	IWM_EEPROM_FIRST = IWM_EEPROM_SIG,
+	IWM_EEPROM_VERSION,
+	IWM_EEPROM_OEM_HW_VERSION,
+	IWM_EEPROM_MAC_VERSION,
+	IWM_EEPROM_CARD_ID,
+	IWM_EEPROM_RADIO_CONF,
+	IWM_EEPROM_SKU_CAP,
+
+	IWM_EEPROM_INDIRECT_OFFSET,
+	IWM_EEPROM_CALIB_RXIQ_OFFSET = IWM_EEPROM_INDIRECT_OFFSET,
+
+	IWM_EEPROM_INDIRECT_DATA,
+	IWM_EEPROM_CALIB_RXIQ = IWM_EEPROM_INDIRECT_DATA,
+
+	IWM_EEPROM_LAST,
+};
+
+#define IWM_EEPROM_SIG_OFF             0x00
+#define IWM_EEPROM_VERSION_OFF        (0x54 << 1)
+#define IWM_EEPROM_OEM_HW_VERSION_OFF (0x56 << 1)
+#define IWM_EEPROM_MAC_VERSION_OFF    (0x30 << 1)
+#define IWM_EEPROM_CARD_ID_OFF        (0x5d << 1)
+#define IWM_EEPROM_RADIO_CONF_OFF     (0x58 << 1)
+#define IWM_EEPROM_SKU_CAP_OFF        (0x55 << 1)
+#define IWM_EEPROM_CALIB_CONFIG_OFF   (0x7c << 1)
+
+#define IWM_EEPROM_SIG_LEN              4
+#define IWM_EEPROM_VERSION_LEN          2
+#define IWM_EEPROM_OEM_HW_VERSION_LEN   2
+#define IWM_EEPROM_MAC_VERSION_LEN      1
+#define IWM_EEPROM_CARD_ID_LEN          2
+#define IWM_EEPROM_RADIO_CONF_LEN       2
+#define IWM_EEPROM_SKU_CAP_LEN          2
+#define IWM_EEPROM_INDIRECT_LEN		2
+
+#define IWM_MAX_EEPROM_DATA_LEN         240
+#define IWM_EEPROM_LEN                  0x800
+
+#define IWM_EEPROM_MIN_ALLOWED_VERSION          0x0610
+#define IWM_EEPROM_MAX_ALLOWED_VERSION          0x0700
+#define IWM_EEPROM_CURRENT_VERSION              0x0612
+
+#define IWM_EEPROM_SKU_CAP_BAND_24GHZ           (1 << 4)
+#define IWM_EEPROM_SKU_CAP_BAND_52GHZ           (1 << 5)
+#define IWM_EEPROM_SKU_CAP_11N_ENABLE           (1 << 6)
+
+enum {
+	IWM_EEPROM_CALIB_CAL_HDR,
+	IWM_EEPROM_CALIB_TX_POWER,
+	IWM_EEPROM_CALIB_XTAL,
+	IWM_EEPROM_CALIB_TEMPERATURE,
+	IWM_EEPROM_CALIB_RX_BB_FILTER,
+	IWM_EEPROM_CALIB_RX_IQ,
+	IWM_EEPROM_CALIB_MAX,
+};
+
+#define IWM_EEPROM_CALIB_RXIQ_OFF	(IWM_EEPROM_CALIB_CONFIG_OFF + \
+					 (IWM_EEPROM_CALIB_RX_IQ << 1))
+#define IWM_EEPROM_CALIB_RXIQ_LEN	sizeof(struct iwm_lmac_calib_rxiq)
+
+struct iwm_eeprom_entry {
+	char *name;
+	u32 offset;
+	u32 length;
+};
+
+int iwm_eeprom_init(struct iwm_priv *iwm);
+void iwm_eeprom_exit(struct iwm_priv *iwm);
+u8 *iwm_eeprom_access(struct iwm_priv *iwm, u8 eeprom_id);
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/fw.c b/drivers/net/wireless/iwmc3200wifi/fw.c
new file mode 100644
index 0000000..db4ba08
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -0,0 +1,388 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/firmware.h>
+
+#include "iwm.h"
+#include "bus.h"
+#include "hal.h"
+#include "umac.h"
+#include "debug.h"
+#include "fw.h"
+#include "commands.h"
+
+static const char fw_barker[] = "*WESTOPFORNOONE*";
+
+/*
+ * @op_code: Op code we're looking for.
+ * @index: There can be several instances of the same opcode within
+ *         the firmware. Index specifies which one we're looking for.
+ */
+static int iwm_fw_op_offset(struct iwm_priv *iwm, const struct firmware *fw,
+			    u16 op_code, u32 index)
+{
+	int offset = -EINVAL, fw_offset;
+	u32 op_index = 0;
+	const u8 *fw_ptr;
+	struct iwm_fw_hdr_rec *rec;
+
+	fw_offset = 0;
+	fw_ptr = fw->data;
+
+	/* We first need to look for the firmware barker */
+	if (memcmp(fw_ptr, fw_barker, IWM_HDR_BARKER_LEN)) {
+		IWM_ERR(iwm, "No barker string in this FW\n");
+		return -EINVAL;
+	}
+
+	if (fw->size < IWM_HDR_LEN) {
+		IWM_ERR(iwm, "FW is too small (%d)\n", fw->size);
+		return -EINVAL;
+	}
+
+	fw_offset += IWM_HDR_BARKER_LEN;
+
+	while (fw_offset < fw->size) {
+		rec = (struct iwm_fw_hdr_rec *)(fw_ptr + fw_offset);
+
+		IWM_DBG_FW(iwm, DBG, "FW: op_code: 0x%x, len: %d @ 0x%x\n",
+			   rec->op_code, rec->len, fw_offset);
+
+		if (rec->op_code == IWM_HDR_REC_OP_INVALID) {
+			IWM_DBG_FW(iwm, DBG, "Reached INVALID op code\n");
+			break;
+		}
+
+		if (rec->op_code == op_code) {
+			if (op_index == index) {
+				fw_offset += sizeof(struct iwm_fw_hdr_rec);
+				offset = fw_offset;
+				goto out;
+			}
+			op_index++;
+		}
+
+		fw_offset += sizeof(struct iwm_fw_hdr_rec) + rec->len;
+	}
+
+ out:
+	return offset;
+}
+
+static int iwm_load_firmware_chunk(struct iwm_priv *iwm,
+				   const struct firmware *fw,
+				   struct iwm_fw_img_desc *img_desc)
+{
+	struct iwm_udma_nonwifi_cmd target_cmd;
+	u32 chunk_size;
+	const u8 *chunk_ptr;
+	int ret = 0;
+
+	IWM_DBG_FW(iwm, INFO, "Loading FW chunk: %d bytes @ 0x%x\n",
+		   img_desc->length, img_desc->address);
+
+	target_cmd.opcode = UMAC_HDI_OUT_OPCODE_WRITE;
+	target_cmd.handle_by_hw = 1;
+	target_cmd.op2 = 0;
+	target_cmd.resp = 0;
+	target_cmd.eop = 1;
+
+	chunk_size = img_desc->length;
+	chunk_ptr = fw->data + img_desc->offset;
+
+	while (chunk_size > 0) {
+		u32 tmp_chunk_size;
+
+		tmp_chunk_size = min_t(u32, chunk_size,
+				       IWM_MAX_NONWIFI_CMD_BUFF_SIZE);
+
+		target_cmd.addr = cpu_to_le32(img_desc->address +
+				    (chunk_ptr - fw->data - img_desc->offset));
+		target_cmd.op1_sz = cpu_to_le32(tmp_chunk_size);
+
+		IWM_DBG_FW(iwm, DBG, "\t%d bytes @ 0x%x\n",
+			   tmp_chunk_size, target_cmd.addr);
+
+		ret = iwm_hal_send_target_cmd(iwm, &target_cmd, chunk_ptr);
+		if (ret < 0) {
+			IWM_ERR(iwm, "Couldn't load FW chunk\n");
+			break;
+		}
+
+		chunk_size -= tmp_chunk_size;
+		chunk_ptr += tmp_chunk_size;
+	}
+
+	return ret;
+}
+/*
+ * To load a fw image to the target, we basically go through the
+ * fw, looking for OP_MEM_DESC records. Once we found one, we
+ * pass it to iwm_load_firmware_chunk().
+ * The OP_MEM_DESC records contain the actuall memory chunk to be
+ * sent, but also the destination address.
+ */
+static int iwm_load_img(struct iwm_priv *iwm, const char *img_name)
+{
+	const struct firmware *fw;
+	struct iwm_fw_img_desc *img_desc;
+	struct iwm_fw_img_ver *ver;
+	int ret = 0, fw_offset;
+	u32 opcode_idx = 0, build_date;
+	char *build_tag;
+
+	ret = request_firmware(&fw, img_name, iwm_to_dev(iwm));
+	if (ret) {
+		IWM_ERR(iwm, "Request firmware failed");
+		return ret;
+	}
+
+	IWM_DBG_FW(iwm, INFO, "Start to load FW %s\n", img_name);
+
+	while (1) {
+		fw_offset = iwm_fw_op_offset(iwm, fw,
+					     IWM_HDR_REC_OP_MEM_DESC,
+					     opcode_idx);
+		if (fw_offset < 0)
+			break;
+
+		img_desc = (struct iwm_fw_img_desc *)(fw->data + fw_offset);
+		ret = iwm_load_firmware_chunk(iwm, fw, img_desc);
+		if (ret < 0)
+			goto err_release_fw;
+		opcode_idx++;
+	};
+
+	/* Read firmware version */
+	fw_offset = iwm_fw_op_offset(iwm, fw, IWM_HDR_REC_OP_SW_VER, 0);
+	if (fw_offset < 0)
+		goto err_release_fw;
+
+	ver = (struct iwm_fw_img_ver *)(fw->data + fw_offset);
+
+	/* Read build tag */
+	fw_offset = iwm_fw_op_offset(iwm, fw, IWM_HDR_REC_OP_BUILD_TAG, 0);
+	if (fw_offset < 0)
+		goto err_release_fw;
+
+	build_tag = (char *)(fw->data + fw_offset);
+
+	/* Read build date */
+	fw_offset = iwm_fw_op_offset(iwm, fw, IWM_HDR_REC_OP_BUILD_DATE, 0);
+	if (fw_offset < 0)
+		goto err_release_fw;
+
+	build_date = *(u32 *)(fw->data + fw_offset);
+
+	IWM_INFO(iwm, "%s:\n", img_name);
+	IWM_INFO(iwm, "\tVersion:    %02X.%02X\n", ver->major, ver->minor);
+	IWM_INFO(iwm, "\tBuild tag:  %s\n", build_tag);
+	IWM_INFO(iwm, "\tBuild date: %x-%x-%x\n",
+		 IWM_BUILD_YEAR(build_date), IWM_BUILD_MONTH(build_date),
+		 IWM_BUILD_DAY(build_date));
+
+
+ err_release_fw:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int iwm_load_umac(struct iwm_priv *iwm)
+{
+	struct iwm_udma_nonwifi_cmd target_cmd;
+	int ret;
+
+	ret = iwm_load_img(iwm, iwm->bus_ops->umac_name);
+	if (ret < 0)
+		return ret;
+
+	/* We've loaded the UMAC, we can tell the target to jump there */
+	target_cmd.opcode = UMAC_HDI_OUT_OPCODE_JUMP;
+	target_cmd.addr = cpu_to_le32(UMAC_MU_FW_INST_DATA_12_ADDR);
+	target_cmd.op1_sz = 0;
+	target_cmd.op2 = 0;
+	target_cmd.handle_by_hw = 0;
+	target_cmd.resp = 1 ;
+	target_cmd.eop = 1;
+
+	ret = iwm_hal_send_target_cmd(iwm, &target_cmd, NULL);
+	if (ret < 0)
+		IWM_ERR(iwm, "Couldn't send JMP command\n");
+
+	return ret;
+}
+
+static int iwm_load_lmac(struct iwm_priv *iwm, const char *img_name)
+{
+	int ret;
+
+	ret = iwm_load_img(iwm, img_name);
+	if (ret < 0)
+		return ret;
+
+	return iwm_send_umac_reset(iwm,
+			cpu_to_le32(UMAC_RST_CTRL_FLG_LARC_CLK_EN), 0);
+}
+
+/*
+ * We currently have to load 3 FWs:
+ * 1) The UMAC (Upper MAC).
+ * 2) The calibration LMAC (Lower MAC).
+ *    We then send the calibration init command, so that the device can
+ *    run a first calibration round.
+ * 3) The operational LMAC, which replaces the calibration one when it's
+ *    done with the first calibration round.
+ *
+ * Once those 3 FWs have been loaded, we send the periodic calibration
+ * command, and then the device is available for regular 802.11 operations.
+ */
+int iwm_load_fw(struct iwm_priv *iwm)
+{
+	int ret;
+
+	/* We first start downloading the UMAC */
+	ret = iwm_load_umac(iwm);
+	if (ret < 0) {
+		IWM_ERR(iwm, "UMAC loading failed\n");
+		return ret;
+	}
+
+	/* Handle UMAC_ALIVE notification */
+	ret = iwm_notif_handle(iwm, UMAC_NOTIFY_OPCODE_ALIVE, IWM_SRC_UMAC,
+			       WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Handle UMAC_ALIVE failed: %d\n", ret);
+		return ret;
+	}
+
+	/* UMAC is alive, we can download the calibration LMAC */
+	ret = iwm_load_lmac(iwm, iwm->bus_ops->calib_lmac_name);
+	if (ret) {
+		IWM_ERR(iwm, "Calibration LMAC loading failed\n");
+		return ret;
+	}
+
+	/* Handle UMAC_INIT_COMPLETE notification */
+	ret = iwm_notif_handle(iwm, UMAC_NOTIFY_OPCODE_INIT_COMPLETE,
+			       IWM_SRC_UMAC, WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Handle INIT_COMPLETE failed for calibration "
+			"LMAC: %d\n", ret);
+		return ret;
+	}
+
+	/* Read EEPROM data */
+	ret = iwm_eeprom_init(iwm);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't init eeprom array\n");
+		return ret;
+	}
+
+#ifdef CONFIG_IWM_B0_HW_SUPPORT
+	if (iwm->conf.hw_b0) {
+		clear_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->conf.init_calib_map);
+		clear_bit(PHY_CALIBRATE_RX_IQ_CMD,
+			  &iwm->conf.periodic_calib_map);
+	}
+#endif
+	/* Read RX IQ calibration result from EEPROM */
+	if (test_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->conf.init_calib_map)) {
+		iwm_store_rxiq_calib_result(iwm);
+		set_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->calib_done_map);
+	}
+
+	iwm_send_prio_table(iwm);
+	iwm_send_init_calib_cfg(iwm, iwm->conf.init_calib_map);
+
+	while (iwm->calib_done_map != iwm->conf.init_calib_map) {
+		ret = iwm_notif_handle(iwm, CALIBRATION_RES_NOTIFICATION,
+				       IWM_SRC_LMAC, WAIT_NOTIF_TIMEOUT);
+		if (ret) {
+			IWM_ERR(iwm, "Wait for calibration result timeout\n");
+			goto out;
+		}
+		IWM_DBG_FW(iwm, DBG, "Got calibration result. calib_done_map: "
+			   "0x%lx, requested calibrations: 0x%lx\n",
+			   iwm->calib_done_map, iwm->conf.init_calib_map);
+	}
+
+	/* Handle LMAC CALIBRATION_COMPLETE notification */
+	ret = iwm_notif_handle(iwm, CALIBRATION_COMPLETE_NOTIFICATION,
+			       IWM_SRC_LMAC, WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Wait for CALIBRATION_COMPLETE timeout\n");
+		goto out;
+	}
+
+	IWM_INFO(iwm, "LMAC calibration done: 0x%lx\n", iwm->calib_done_map);
+
+	iwm_send_umac_reset(iwm, cpu_to_le32(UMAC_RST_CTRL_FLG_LARC_RESET), 1);
+
+	ret = iwm_notif_handle(iwm, UMAC_CMD_OPCODE_RESET, IWM_SRC_UMAC,
+			       WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Wait for UMAC RESET timeout\n");
+		goto out;
+	}
+
+	/* Download the operational LMAC */
+	ret = iwm_load_lmac(iwm, iwm->bus_ops->lmac_name);
+	if (ret) {
+		IWM_ERR(iwm, "LMAC loading failed\n");
+		goto out;
+	}
+
+	ret = iwm_notif_handle(iwm, UMAC_NOTIFY_OPCODE_INIT_COMPLETE,
+			       IWM_SRC_UMAC, WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Handle INIT_COMPLETE failed for LMAC: %d\n", ret);
+		goto out;
+	}
+
+	iwm_send_prio_table(iwm);
+	iwm_send_calib_results(iwm);
+	iwm_send_periodic_calib_cfg(iwm, iwm->conf.periodic_calib_map);
+
+	return 0;
+
+ out:
+	iwm_eeprom_exit(iwm);
+	return ret;
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/fw.h b/drivers/net/wireless/iwmc3200wifi/fw.h
new file mode 100644
index 0000000..c70a3b4
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/fw.h
@@ -0,0 +1,100 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_FW_H__
+#define __IWM_FW_H__
+
+/**
+ * struct iwm_fw_hdr_rec - An iwm firmware image is a
+ * concatenation of various records. Each of them is
+ * defined by an ID (aka op code), a length, and the
+ * actual data.
+ * @op_code: The record ID, see IWM_HDR_REC_OP_*
+ *
+ * @len: The record payload length
+ *
+ * @buf: The record payload
+ */
+struct iwm_fw_hdr_rec {
+	u16 op_code;
+	u16 len;
+	u8 buf[0];
+};
+
+/* Header's definitions */
+#define IWM_HDR_LEN                          (512)
+#define IWM_HDR_BARKER_LEN                   (16)
+
+/* Header's opcodes */
+#define IWM_HDR_REC_OP_INVALID             (0x00)
+#define IWM_HDR_REC_OP_BUILD_DATE          (0x01)
+#define IWM_HDR_REC_OP_BUILD_TAG           (0x02)
+#define IWM_HDR_REC_OP_SW_VER              (0x03)
+#define IWM_HDR_REC_OP_HW_SKU              (0x04)
+#define IWM_HDR_REC_OP_BUILD_OPT           (0x05)
+#define IWM_HDR_REC_OP_MEM_DESC            (0x06)
+#define IWM_HDR_REC_USERDEFS               (0x07)
+
+/* Header's records length (in bytes) */
+#define IWM_HDR_REC_LEN_BUILD_DATE           (4)
+#define IWM_HDR_REC_LEN_BUILD_TAG            (64)
+#define IWM_HDR_REC_LEN_SW_VER               (4)
+#define IWM_HDR_REC_LEN_HW_SKU               (4)
+#define IWM_HDR_REC_LEN_BUILD_OPT            (4)
+#define IWM_HDR_REC_LEN_MEM_DESC             (12)
+#define IWM_HDR_REC_LEN_USERDEF              (64)
+
+#define IWM_BUILD_YEAR(date) ((date >> 16) & 0xffff)
+#define IWM_BUILD_MONTH(date) ((date >> 8) & 0xff)
+#define IWM_BUILD_DAY(date) (date & 0xff)
+
+struct iwm_fw_img_desc {
+	u32 offset;
+	u32 address;
+	u32 length;
+};
+
+struct iwm_fw_img_ver {
+	u8 minor;
+	u8 major;
+	u16 reserved;
+};
+
+int iwm_load_fw(struct iwm_priv *iwm);
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.c b/drivers/net/wireless/iwmc3200wifi/hal.c
new file mode 100644
index 0000000..ee127fe
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -0,0 +1,464 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+/*
+ * Hardware Abstraction Layer for iwm.
+ *
+ * This file mostly defines an abstraction API for
+ * sending various commands to the target.
+ *
+ * We have 2 types of commands: wifi and non-wifi ones.
+ *
+ * - wifi commands:
+ *   They are used for sending LMAC and UMAC commands,
+ *   and thus are the most commonly used ones.
+ *   There are 2 different wifi command types, the regular
+ *   one and the LMAC one. The former is used to send
+ *   UMAC commands (see UMAC_CMD_OPCODE_* from umac.h)
+ *   while the latter is used for sending commands to the
+ *   LMAC. If you look at LMAC commands you'll se that they
+ *   are actually regular iwlwifi target commands encapsulated
+ *   into a special UMAC command called UMAC passthrough.
+ *   This is due to the fact the the host talks exclusively
+ *   to the UMAC and so there needs to be a special UMAC
+ *   command for talking to the LMAC.
+ *   This is how a wifi command is layed out:
+ *    ------------------------
+ *   | iwm_udma_out_wifi_hdr  |
+ *    ------------------------
+ *   | SW meta_data (32 bits) |
+ *    ------------------------
+ *   | iwm_dev_cmd_hdr        |
+ *    ------------------------
+ *   | payload                |
+ *   | ....                   |
+ *
+ * - non-wifi, or general commands:
+ *   Those commands are handled by the device's bootrom,
+ *   and are typically sent when the UMAC and the LMAC
+ *   are not yet available.
+ *    *   This is how a non-wifi command is layed out:
+ *    ---------------------------
+ *   | iwm_udma_out_nonwifi_hdr  |
+ *    ---------------------------
+ *   | payload                   |
+ *   | ....                      |
+
+ *
+ * All the commands start with a UDMA header, which is
+ * basically a 32 bits field. The 4 LSB there define
+ * an opcode that allows the target to differentiate
+ * between wifi (opcode is 0xf) and non-wifi commands
+ * (opcode is [0..0xe]).
+ *
+ * When a command (wifi or non-wifi) is supposed to receive
+ * an answer, we queue the command buffer. When we do receive
+ * a command response from the UMAC, we go through the list
+ * of pending command, and pass both the command and the answer
+ * to the rx handler. Each command is sent with a unique
+ * sequence id, and the answer is sent with the same one. This
+ * is how we're supposed to match an answer with its command.
+ * See rx.c:iwm_rx_handle_[non]wifi() and iwm_get_pending_[non]wifi()
+ * for the implementation details.
+ */
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+
+#include "iwm.h"
+#include "bus.h"
+#include "hal.h"
+#include "umac.h"
+#include "debug.h"
+
+static void iwm_nonwifi_cmd_init(struct iwm_priv *iwm,
+				 struct iwm_nonwifi_cmd *cmd,
+				 struct iwm_udma_nonwifi_cmd *udma_cmd)
+{
+	INIT_LIST_HEAD(&cmd->pending);
+
+	spin_lock(&iwm->cmd_lock);
+
+	cmd->resp_received = 0;
+
+	cmd->seq_num = iwm->nonwifi_seq_num;
+	udma_cmd->seq_num = cpu_to_le16(cmd->seq_num);
+
+	cmd->seq_num = iwm->nonwifi_seq_num++;
+	iwm->nonwifi_seq_num %= UMAC_NONWIFI_SEQ_NUM_MAX;
+
+	if (udma_cmd->resp)
+		list_add_tail(&cmd->pending, &iwm->nonwifi_pending_cmd);
+
+	spin_unlock(&iwm->cmd_lock);
+
+	cmd->buf.start = cmd->buf.payload;
+	cmd->buf.len = 0;
+
+	memcpy(&cmd->udma_cmd, udma_cmd, sizeof(*udma_cmd));
+}
+
+u16 iwm_alloc_wifi_cmd_seq(struct iwm_priv *iwm)
+{
+	u16 seq_num = iwm->wifi_seq_num;
+
+	iwm->wifi_seq_num++;
+	iwm->wifi_seq_num %= UMAC_WIFI_SEQ_NUM_MAX;
+
+	return seq_num;
+}
+
+static void iwm_wifi_cmd_init(struct iwm_priv *iwm,
+			      struct iwm_wifi_cmd *cmd,
+			      struct iwm_udma_wifi_cmd *udma_cmd,
+			      struct iwm_umac_cmd *umac_cmd,
+			      struct iwm_lmac_cmd *lmac_cmd,
+			      u16 payload_size)
+{
+	INIT_LIST_HEAD(&cmd->pending);
+
+	spin_lock(&iwm->cmd_lock);
+
+	cmd->seq_num = iwm_alloc_wifi_cmd_seq(iwm);
+	umac_cmd->seq_num = cpu_to_le16(cmd->seq_num);
+
+	if (umac_cmd->resp)
+		list_add_tail(&cmd->pending, &iwm->wifi_pending_cmd);
+
+	spin_unlock(&iwm->cmd_lock);
+
+	cmd->buf.start = cmd->buf.payload;
+	cmd->buf.len = 0;
+
+	if (lmac_cmd) {
+		cmd->buf.start -= sizeof(struct iwm_lmac_hdr);
+
+		lmac_cmd->seq_num = cpu_to_le16(cmd->seq_num);
+		lmac_cmd->count = cpu_to_le16(payload_size);
+
+		memcpy(&cmd->lmac_cmd, lmac_cmd, sizeof(*lmac_cmd));
+
+		umac_cmd->count = cpu_to_le16(sizeof(struct iwm_lmac_hdr));
+	} else
+		umac_cmd->count = 0;
+
+	umac_cmd->count = cpu_to_le16(payload_size +
+				      le16_to_cpu(umac_cmd->count));
+	udma_cmd->count = cpu_to_le16(sizeof(struct iwm_umac_fw_cmd_hdr) +
+				      le16_to_cpu(umac_cmd->count));
+
+	memcpy(&cmd->udma_cmd, udma_cmd, sizeof(*udma_cmd));
+	memcpy(&cmd->umac_cmd, umac_cmd, sizeof(*umac_cmd));
+}
+
+void iwm_cmd_flush(struct iwm_priv *iwm)
+{
+	struct iwm_wifi_cmd *wcmd, *wnext;
+	struct iwm_nonwifi_cmd *nwcmd, *nwnext;
+
+	list_for_each_entry_safe(wcmd, wnext, &iwm->wifi_pending_cmd, pending) {
+		list_del(&wcmd->pending);
+		kfree(wcmd);
+	}
+
+	list_for_each_entry_safe(nwcmd, nwnext, &iwm->nonwifi_pending_cmd,
+				 pending) {
+		list_del(&nwcmd->pending);
+		kfree(nwcmd);
+	}
+}
+
+struct iwm_wifi_cmd *iwm_get_pending_wifi_cmd(struct iwm_priv *iwm, u16 seq_num)
+{
+	struct iwm_wifi_cmd *cmd, *next;
+
+	list_for_each_entry_safe(cmd, next, &iwm->wifi_pending_cmd, pending)
+		if (cmd->seq_num == seq_num) {
+			list_del(&cmd->pending);
+			return cmd;
+		}
+
+	return NULL;
+}
+
+struct iwm_nonwifi_cmd *
+iwm_get_pending_nonwifi_cmd(struct iwm_priv *iwm, u8 seq_num, u8 cmd_opcode)
+{
+	struct iwm_nonwifi_cmd *cmd, *next;
+
+	list_for_each_entry_safe(cmd, next, &iwm->nonwifi_pending_cmd, pending)
+		if ((cmd->seq_num == seq_num) &&
+		    (cmd->udma_cmd.opcode == cmd_opcode) &&
+		    (cmd->resp_received)) {
+			list_del(&cmd->pending);
+			return cmd;
+		}
+
+	return NULL;
+}
+
+static void iwm_build_udma_nonwifi_hdr(struct iwm_priv *iwm,
+				       struct iwm_udma_out_nonwifi_hdr *hdr,
+				       struct iwm_udma_nonwifi_cmd *cmd)
+{
+	memset(hdr, 0, sizeof(*hdr));
+
+	SET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_OPCODE, cmd->opcode);
+	SET_VAL32(hdr->cmd, UDMA_HDI_OUT_NW_CMD_RESP, cmd->resp);
+	SET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_EOT, 1);
+	SET_VAL32(hdr->cmd, UDMA_HDI_OUT_NW_CMD_HANDLE_BY_HW,
+		  cmd->handle_by_hw);
+	SET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_SIGNATURE, UMAC_HDI_OUT_SIGNATURE);
+	SET_VAL32(hdr->cmd, UDMA_HDI_OUT_CMD_NON_WIFI_HW_SEQ_NUM,
+		  le16_to_cpu(cmd->seq_num));
+
+	hdr->addr = cmd->addr;
+	hdr->op1_sz = cmd->op1_sz;
+	hdr->op2 = cmd->op2;
+}
+
+static int iwm_send_udma_nonwifi_cmd(struct iwm_priv *iwm,
+				     struct iwm_nonwifi_cmd *cmd)
+{
+	struct iwm_udma_out_nonwifi_hdr *udma_hdr;
+	struct iwm_nonwifi_cmd_buff *buf;
+	struct iwm_udma_nonwifi_cmd *udma_cmd = &cmd->udma_cmd;
+
+	buf = &cmd->buf;
+
+	buf->start -= sizeof(struct iwm_umac_nonwifi_out_hdr);
+	buf->len += sizeof(struct iwm_umac_nonwifi_out_hdr);
+
+	udma_hdr = (struct iwm_udma_out_nonwifi_hdr *)(buf->start);
+
+	iwm_build_udma_nonwifi_hdr(iwm, udma_hdr, udma_cmd);
+
+	IWM_DBG_CMD(iwm, DBG,
+		    "Send UDMA nonwifi cmd: opcode = 0x%x, resp = 0x%x, "
+		    "hw = 0x%x, seqnum = %d, addr = 0x%x, op1_sz = 0x%x, "
+		    "op2 = 0x%x\n", udma_cmd->opcode, udma_cmd->resp,
+		    udma_cmd->handle_by_hw, cmd->seq_num, udma_cmd->addr,
+		    udma_cmd->op1_sz, udma_cmd->op2);
+
+	return iwm_bus_send_chunk(iwm, buf->start, buf->len);
+}
+
+void iwm_udma_wifi_hdr_set_eop(struct iwm_priv *iwm, u8 *buf, u8 eop)
+{
+	struct iwm_udma_out_wifi_hdr *hdr = (struct iwm_udma_out_wifi_hdr *)buf;
+
+	SET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_EOT, eop);
+}
+
+void iwm_build_udma_wifi_hdr(struct iwm_priv *iwm,
+			     struct iwm_udma_out_wifi_hdr *hdr,
+			     struct iwm_udma_wifi_cmd *cmd)
+{
+	memset(hdr, 0, sizeof(*hdr));
+
+	SET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_OPCODE, UMAC_HDI_OUT_OPCODE_WIFI);
+	SET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_EOT, cmd->eop);
+	SET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_SIGNATURE, UMAC_HDI_OUT_SIGNATURE);
+
+	SET_VAL32(hdr->meta_data, UMAC_HDI_OUT_BYTE_COUNT,
+		  le16_to_cpu(cmd->count));
+	SET_VAL32(hdr->meta_data, UMAC_HDI_OUT_CREDIT_GRP, cmd->credit_group);
+	SET_VAL32(hdr->meta_data, UMAC_HDI_OUT_RATID, cmd->ra_tid);
+	SET_VAL32(hdr->meta_data, UMAC_HDI_OUT_LMAC_OFFSET, cmd->lmac_offset);
+}
+
+void iwm_build_umac_hdr(struct iwm_priv *iwm,
+			struct iwm_umac_fw_cmd_hdr *hdr,
+			struct iwm_umac_cmd *cmd)
+{
+	memset(hdr, 0, sizeof(*hdr));
+
+	SET_VAL32(hdr->meta_data, UMAC_FW_CMD_BYTE_COUNT,
+		  le16_to_cpu(cmd->count));
+	SET_VAL32(hdr->meta_data, UMAC_FW_CMD_TX_STA_COLOR, cmd->color);
+	SET_VAL8(hdr->cmd.flags, UMAC_DEV_CMD_FLAGS_RESP_REQ, cmd->resp);
+
+	hdr->cmd.cmd = cmd->id;
+	hdr->cmd.seq_num = cmd->seq_num;
+}
+
+static int iwm_send_udma_wifi_cmd(struct iwm_priv *iwm,
+				  struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_wifi_out_hdr *umac_hdr;
+	struct iwm_wifi_cmd_buff *buf;
+	struct iwm_udma_wifi_cmd *udma_cmd = &cmd->udma_cmd;
+	struct iwm_umac_cmd *umac_cmd = &cmd->umac_cmd;
+	int ret;
+
+	buf = &cmd->buf;
+
+	buf->start -= sizeof(struct iwm_umac_wifi_out_hdr);
+	buf->len += sizeof(struct iwm_umac_wifi_out_hdr);
+
+	umac_hdr = (struct iwm_umac_wifi_out_hdr *)(buf->start);
+
+	iwm_build_udma_wifi_hdr(iwm, &umac_hdr->hw_hdr, udma_cmd);
+	iwm_build_umac_hdr(iwm, &umac_hdr->sw_hdr, umac_cmd);
+
+	IWM_DBG_CMD(iwm, DBG,
+		    "Send UDMA wifi cmd: opcode = 0x%x, UMAC opcode = 0x%x, "
+		    "eop = 0x%x, count = 0x%x, credit_group = 0x%x, "
+		    "ra_tid = 0x%x, lmac_offset = 0x%x, seqnum = %d\n",
+		    UMAC_HDI_OUT_OPCODE_WIFI, umac_cmd->id,
+		    udma_cmd->eop, udma_cmd->count, udma_cmd->credit_group,
+		    udma_cmd->ra_tid, udma_cmd->lmac_offset, cmd->seq_num);
+
+	if (umac_cmd->id == UMAC_CMD_OPCODE_WIFI_PASS_THROUGH)
+		IWM_DBG_CMD(iwm, DBG, "\tLMAC opcode: 0x%x\n",
+			    cmd->lmac_cmd.id);
+
+	ret = iwm_tx_credit_alloc(iwm, udma_cmd->credit_group, buf->len);
+
+	/* We keep sending UMAC reset regardless of the command credits.
+	 * The UMAC is supposed to be reset anyway and the Tx credits are
+	 * reinitialized afterwards. If we are lucky, the reset could
+	 * still be done even though we have run out of credits for the
+	 * command pool at this moment.*/
+	if (ret && (umac_cmd->id != UMAC_CMD_OPCODE_RESET)) {
+		IWM_DBG_TX(iwm, DBG, "Failed to alloc tx credit for cmd %d\n",
+			   umac_cmd->id);
+		return ret;
+	}
+
+	return iwm_bus_send_chunk(iwm, buf->start, buf->len);
+}
+
+/* target_cmd a.k.a udma_nonwifi_cmd can be sent when UMAC is not available */
+int iwm_hal_send_target_cmd(struct iwm_priv *iwm,
+			    struct iwm_udma_nonwifi_cmd *udma_cmd,
+			    const void *payload)
+{
+	struct iwm_nonwifi_cmd *cmd;
+	int ret;
+
+	cmd = kzalloc(sizeof(struct iwm_nonwifi_cmd), GFP_KERNEL);
+	if (!cmd) {
+		IWM_ERR(iwm, "Couldn't alloc memory for hal cmd\n");
+		return -ENOMEM;
+	}
+
+	iwm_nonwifi_cmd_init(iwm, cmd, udma_cmd);
+
+	if (cmd->udma_cmd.opcode == UMAC_HDI_OUT_OPCODE_WRITE ||
+	    cmd->udma_cmd.opcode == UMAC_HDI_OUT_OPCODE_WRITE_PERSISTENT) {
+		cmd->buf.len = le32_to_cpu(cmd->udma_cmd.op1_sz);
+		memcpy(&cmd->buf.payload, payload, cmd->buf.len);
+	}
+
+	ret = iwm_send_udma_nonwifi_cmd(iwm, cmd);
+
+	if (!udma_cmd->resp)
+		kfree(cmd);
+
+	if (ret < 0)
+		return ret;
+
+	return cmd->seq_num;
+}
+
+static void iwm_build_lmac_hdr(struct iwm_priv *iwm, struct iwm_lmac_hdr *hdr,
+			       struct iwm_lmac_cmd *cmd)
+{
+	memset(hdr, 0, sizeof(*hdr));
+
+	hdr->id = cmd->id;
+	hdr->flags = 0; /* Is this ever used? */
+	hdr->seq_num = cmd->seq_num;
+}
+
+/*
+ * iwm_hal_send_host_cmd(): sends commands to the UMAC or the LMAC.
+ * Sending command to the LMAC is equivalent to sending a
+ * regular UMAC command with the LMAC passtrough or the LMAC
+ * wrapper UMAC command IDs.
+ */
+int iwm_hal_send_host_cmd(struct iwm_priv *iwm,
+			  struct iwm_udma_wifi_cmd *udma_cmd,
+			  struct iwm_umac_cmd *umac_cmd,
+			  struct iwm_lmac_cmd *lmac_cmd,
+			  const void *payload, u16 payload_size)
+{
+	struct iwm_wifi_cmd *cmd;
+	struct iwm_lmac_hdr *hdr;
+	int lmac_hdr_len = 0;
+	int ret;
+
+	cmd = kzalloc(sizeof(struct iwm_wifi_cmd), GFP_KERNEL);
+	if (!cmd) {
+		IWM_ERR(iwm, "Couldn't alloc memory for wifi hal cmd\n");
+		return -ENOMEM;
+	}
+
+	iwm_wifi_cmd_init(iwm, cmd, udma_cmd, umac_cmd, lmac_cmd, payload_size);
+
+	if (lmac_cmd) {
+		hdr = (struct iwm_lmac_hdr *)(cmd->buf.start);
+
+		iwm_build_lmac_hdr(iwm, hdr, &cmd->lmac_cmd);
+		lmac_hdr_len = sizeof(struct iwm_lmac_hdr);
+	}
+
+	memcpy(cmd->buf.payload, payload, payload_size);
+	cmd->buf.len = le16_to_cpu(umac_cmd->count);
+
+	ret = iwm_send_udma_wifi_cmd(iwm, cmd);
+
+	/* We free the cmd if we're not expecting any response */
+	if (!umac_cmd->resp)
+		kfree(cmd);
+	return ret;
+}
+
+/*
+ * iwm_hal_send_umac_cmd(): This is a special case for
+ * iwm_hal_send_host_cmd() to send direct UMAC cmd (without
+ * LMAC involved).
+ */
+int iwm_hal_send_umac_cmd(struct iwm_priv *iwm,
+			  struct iwm_udma_wifi_cmd *udma_cmd,
+			  struct iwm_umac_cmd *umac_cmd,
+			  const void *payload, u16 payload_size)
+{
+	return iwm_hal_send_host_cmd(iwm, udma_cmd, umac_cmd, NULL,
+				     payload, payload_size);
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.h b/drivers/net/wireless/iwmc3200wifi/hal.h
new file mode 100644
index 0000000..0adfdc8
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/hal.h
@@ -0,0 +1,236 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef _IWM_HAL_H_
+#define _IWM_HAL_H_
+
+#include "umac.h"
+
+#define GET_VAL8(s, name)	((s >> name##_POS) & name##_SEED)
+#define GET_VAL16(s, name)	((le16_to_cpu(s) >> name##_POS) & name##_SEED)
+#define GET_VAL32(s, name)	((le32_to_cpu(s) >> name##_POS) & name##_SEED)
+
+#define SET_VAL8(s, name, val)						  \
+do {									  \
+	s = (s & ~(name##_SEED << name##_POS)) |			  \
+	    ((val & name##_SEED) << name##_POS);			  \
+} while (0)
+
+#define SET_VAL16(s, name, val)						  \
+do {									  \
+	s = cpu_to_le16((le16_to_cpu(s) & ~(name##_SEED << name##_POS)) | \
+			((val & name##_SEED) << name##_POS));		  \
+} while (0)
+
+#define SET_VAL32(s, name, val)						  \
+do {									  \
+	s = cpu_to_le32((le32_to_cpu(s) & ~(name##_SEED << name##_POS)) | \
+			((val & name##_SEED) << name##_POS));		  \
+} while (0)
+
+
+#define UDMA_UMAC_INIT	{	.eop = 1,				  \
+				.credit_group = 0x4,			  \
+				.ra_tid = UMAC_HDI_ACT_TBL_IDX_HOST_CMD,  \
+				.lmac_offset = 0 }
+#define UDMA_LMAC_INIT	{	.eop = 1,				  \
+				.credit_group = 0x4,			  \
+				.ra_tid = UMAC_HDI_ACT_TBL_IDX_HOST_CMD,  \
+				.lmac_offset = 4 }
+
+
+/* UDMA IN OP CODE -- cmd bits [3:0] */
+#define UDMA_IN_OPCODE_MASK			0xF
+
+#define UDMA_IN_OPCODE_GENERAL_RESP		0x0
+#define UDMA_IN_OPCODE_READ_RESP		0x1
+#define UDMA_IN_OPCODE_WRITE_RESP		0x2
+#define UDMA_IN_OPCODE_PERS_WRITE_RESP		0x5
+#define UDMA_IN_OPCODE_PERS_READ_RESP		0x6
+#define UDMA_IN_OPCODE_RD_MDFY_WR_RESP		0x7
+#define UDMA_IN_OPCODE_EP_MNGMT_MSG		0x8
+#define UDMA_IN_OPCODE_CRDT_CHNG_MSG		0x9
+#define UDMA_IN_OPCODE_CNTRL_DATABASE_MSG	0xA
+#define UDMA_IN_OPCODE_SW_MSG			0xB
+#define UDMA_IN_OPCODE_WIFI			0xF
+#define UDMA_IN_OPCODE_WIFI_LMAC		0x1F
+#define UDMA_IN_OPCODE_WIFI_UMAC		0x2F
+
+/* HW API: udma_hdi_nonwifi API (OUT and IN) */
+
+/* iwm_udma_nonwifi_cmd request response -- bits [9:9] */
+#define UDMA_HDI_OUT_NW_CMD_RESP_POS		9
+#define UDMA_HDI_OUT_NW_CMD_RESP_SEED		0x1
+
+/* iwm_udma_nonwifi_cmd handle by HW -- bits [11:11] */
+#define UDMA_HDI_OUT_NW_CMD_HANDLE_BY_HW_POS	11
+#define UDMA_HDI_OUT_NW_CMD_HANDLE_BY_HW_SEED	0x1
+
+/* iwm_udma_nonwifi_cmd sequence-number -- bits [12:15] */
+#define UDMA_HDI_OUT_NW_CMD_SEQ_NUM_POS		12
+#define UDMA_HDI_OUT_NW_CMD_SEQ_NUM_SEED	0xF
+
+/* UDMA IN Non-WIFI HW sequence number -- bits [12:15] */
+#define UDMA_IN_NW_HW_SEQ_NUM_POS		12
+#define UDMA_IN_NW_HW_SEQ_NUM_SEED		0xF
+
+/* UDMA IN Non-WIFI HW signature -- bits [16:31] */
+#define UDMA_IN_NW_HW_SIG_POS			16
+#define UDMA_IN_NW_HW_SIG_SEED			0xFFFF
+
+/* fixed signature */
+#define UDMA_IN_NW_HW_SIG			0xCBBC
+
+/* UDMA IN Non-WIFI HW block length -- bits [32:35] */
+#define UDMA_IN_NW_HW_LENGTH_SEED		0xF
+#define UDMA_IN_NW_HW_LENGTH_POS		32
+
+/* End of HW API: udma_hdi_nonwifi API (OUT and IN) */
+
+#define IWM_SDIO_FW_MAX_CHUNK_SIZE	2032
+#define IWM_MAX_WIFI_HEADERS_SIZE	32
+#define IWM_MAX_NONWIFI_HEADERS_SIZE	16
+#define IWM_MAX_NONWIFI_CMD_BUFF_SIZE	(IWM_SDIO_FW_MAX_CHUNK_SIZE - \
+					 IWM_MAX_NONWIFI_HEADERS_SIZE)
+#define IWM_MAX_WIFI_CMD_BUFF_SIZE	(IWM_SDIO_FW_MAX_CHUNK_SIZE - \
+					 IWM_MAX_WIFI_HEADERS_SIZE)
+
+#define IWM_HAL_CONCATENATE_BUF_SIZE	8192
+
+struct iwm_wifi_cmd_buff {
+	u16 len;
+	u8 *start;
+	u8 hdr[IWM_MAX_WIFI_HEADERS_SIZE];
+	u8 payload[IWM_MAX_WIFI_CMD_BUFF_SIZE];
+};
+
+struct iwm_nonwifi_cmd_buff {
+	u16 len;
+	u8 *start;
+	u8 hdr[IWM_MAX_NONWIFI_HEADERS_SIZE];
+	u8 payload[IWM_MAX_NONWIFI_CMD_BUFF_SIZE];
+};
+
+struct iwm_udma_nonwifi_cmd {
+	u8 opcode;
+	u8 eop;
+	u8 resp;
+	u8 handle_by_hw;
+	__le32 addr;
+	__le32 op1_sz;
+	__le32 op2;
+	__le16 seq_num;
+};
+
+struct iwm_udma_wifi_cmd {
+	__le16 count;
+	u8 eop;
+	u8 credit_group;
+	u8 ra_tid;
+	u8 lmac_offset;
+};
+
+struct iwm_umac_cmd {
+	u8 id;
+	__le16 count;
+	u8 resp;
+	__le16 seq_num;
+	u8 color;
+};
+
+struct iwm_lmac_cmd {
+	u8 id;
+	__le16 count;
+	u8 resp;
+	__le16 seq_num;
+};
+
+struct iwm_nonwifi_cmd {
+	u16 seq_num;
+	bool resp_received;
+	struct list_head pending;
+	struct iwm_udma_nonwifi_cmd udma_cmd;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_lmac_cmd lmac_cmd;
+	struct iwm_nonwifi_cmd_buff buf;
+	u32 flags;
+};
+
+struct iwm_wifi_cmd {
+	u16 seq_num;
+	struct list_head pending;
+	struct iwm_udma_wifi_cmd udma_cmd;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_lmac_cmd lmac_cmd;
+	struct iwm_wifi_cmd_buff buf;
+	u32 flags;
+};
+
+void iwm_cmd_flush(struct iwm_priv *iwm);
+
+struct iwm_wifi_cmd *iwm_get_pending_wifi_cmd(struct iwm_priv *iwm,
+					      u16 seq_num);
+struct iwm_nonwifi_cmd *iwm_get_pending_nonwifi_cmd(struct iwm_priv *iwm,
+						    u8 seq_num, u8 cmd_opcode);
+
+
+int iwm_hal_send_target_cmd(struct iwm_priv *iwm,
+			    struct iwm_udma_nonwifi_cmd *ucmd,
+			    const void *payload);
+
+int iwm_hal_send_host_cmd(struct iwm_priv *iwm,
+			  struct iwm_udma_wifi_cmd *udma_cmd,
+			  struct iwm_umac_cmd *umac_cmd,
+			  struct iwm_lmac_cmd *lmac_cmd,
+			  const void *payload, u16 payload_size);
+
+int iwm_hal_send_umac_cmd(struct iwm_priv *iwm,
+			  struct iwm_udma_wifi_cmd *udma_cmd,
+			  struct iwm_umac_cmd *umac_cmd,
+			  const void *payload, u16 payload_size);
+
+u16 iwm_alloc_wifi_cmd_seq(struct iwm_priv *iwm);
+
+void iwm_udma_wifi_hdr_set_eop(struct iwm_priv *iwm, u8 *buf, u8 eop);
+void iwm_build_udma_wifi_hdr(struct iwm_priv *iwm,
+			     struct iwm_udma_out_wifi_hdr *hdr,
+			     struct iwm_udma_wifi_cmd *cmd);
+void iwm_build_umac_hdr(struct iwm_priv *iwm,
+			struct iwm_umac_fw_cmd_hdr *hdr,
+			struct iwm_umac_cmd *cmd);
+#endif /* _IWM_HAL_H_ */
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
new file mode 100644
index 0000000..3b29681
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -0,0 +1,350 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_H__
+#define __IWM_H__
+
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <net/cfg80211.h>
+
+#include "debug.h"
+#include "hal.h"
+#include "umac.h"
+#include "lmac.h"
+#include "eeprom.h"
+
+#define IWM_COPYRIGHT "Copyright(c) 2009 Intel Corporation"
+#define IWM_AUTHOR "<ilw@linux.intel.com>"
+
+#define CONFIG_IWM_B0_HW_SUPPORT	1
+
+#define IWM_SRC_LMAC	UMAC_HDI_IN_SOURCE_FHRX
+#define IWM_SRC_UDMA	UMAC_HDI_IN_SOURCE_UDMA
+#define IWM_SRC_UMAC	UMAC_HDI_IN_SOURCE_FW
+#define IWM_SRC_NUM	3
+
+#define IWM_POWER_INDEX_MIN	0
+#define IWM_POWER_INDEX_MAX	5
+#define IWM_POWER_INDEX_DEFAULT	3
+
+struct iwm_conf {
+	u32 sdio_ior_timeout;
+	unsigned long init_calib_map;
+	unsigned long periodic_calib_map;
+	bool reset_on_fatal_err;
+	bool auto_connect;
+	bool wimax_not_present;
+	bool enable_qos;
+	u32 mode;
+
+	u32 power_index;
+	u32 frag_threshold;
+	u32 rts_threshold;
+	bool cts_to_self;
+
+	u32 assoc_timeout;
+	u32 roam_timeout;
+	u32 wireless_mode;
+	u32 coexist_mode;
+
+	u8 ibss_band;
+	u8 ibss_channel;
+
+	u8 mac_addr[ETH_ALEN];
+#ifdef CONFIG_IWM_B0_HW_SUPPORT
+	bool hw_b0;
+#endif
+};
+
+enum {
+	COEX_MODE_SA = 1,
+	COEX_MODE_XOR,
+	COEX_MODE_CM,
+	COEX_MODE_MAX,
+};
+
+struct iwm_if_ops;
+struct iwm_wifi_cmd;
+
+struct pool_entry {
+	int id;		/* group id */
+	int sid;	/* super group id */
+	int min_pages;	/* min capacity in pages */
+	int max_pages;	/* max capacity in pages */
+	int alloc_pages;	/* allocated # of pages. incresed by driver */
+	int total_freed_pages;	/* total freed # of pages. incresed by UMAC */
+};
+
+struct spool_entry {
+	int id;
+	int max_pages;
+	int alloc_pages;
+};
+
+struct iwm_tx_credit {
+	spinlock_t lock;
+	int pool_nr;
+	unsigned long full_pools_map; /* bitmap for # of filled tx pools */
+	struct pool_entry pools[IWM_MACS_OUT_GROUPS];
+	struct spool_entry spools[IWM_MACS_OUT_SGROUPS];
+};
+
+struct iwm_notif {
+	struct list_head pending;
+	u32 cmd_id;
+	void *cmd;
+	u8 src;
+	void *buf;
+	unsigned long buf_size;
+};
+
+struct iwm_sta_info {
+	u8 addr[ETH_ALEN];
+	bool valid;
+	bool qos;
+	u8 color;
+};
+
+struct iwm_tx_info {
+	u8 sta;
+	u8 color;
+	u8 tid;
+};
+
+struct iwm_rx_info {
+	unsigned long rx_size;
+	unsigned long rx_buf_size;
+};
+
+#define IWM_NUM_KEYS 4
+
+struct iwm_umac_key_hdr {
+	u8 mac[ETH_ALEN];
+	u8 key_idx;
+	u8 multicast; /* BCast encrypt & BCast decrypt of frames FROM mac */
+} __attribute__ ((packed));
+
+struct iwm_key {
+	struct iwm_umac_key_hdr hdr;
+	u8 in_use;
+	u8 alg;
+	u32 flags;
+	u8 tx_seq[IW_ENCODE_SEQ_MAX_SIZE];
+	u8 rx_seq[IW_ENCODE_SEQ_MAX_SIZE];
+	u8 key_len;
+	u8 key[32];
+};
+
+#define IWM_RX_ID_HASH  0xff
+#define IWM_RX_ID_GET_HASH(id) ((id) % IWM_RX_ID_HASH)
+
+#define IWM_STA_TABLE_NUM	16
+#define IWM_TX_LIST_SIZE	64
+#define IWM_RX_LIST_SIZE        256
+
+#define IWM_SCAN_ID_MAX 0xff
+
+#define IWM_STATUS_READY		0
+#define IWM_STATUS_SCANNING		1
+#define IWM_STATUS_SCAN_ABORTING	2
+#define IWM_STATUS_ASSOCIATING		3
+#define IWM_STATUS_ASSOCIATED		4
+
+#define IWM_RADIO_RFKILL_OFF		0
+#define IWM_RADIO_RFKILL_HW		1
+#define IWM_RADIO_RFKILL_SW		2
+
+struct iwm_tx_queue {
+	int id;
+	struct sk_buff_head queue;
+	struct workqueue_struct *wq;
+	struct work_struct worker;
+	u8 concat_buf[IWM_HAL_CONCATENATE_BUF_SIZE];
+	int concat_count;
+	u8 *concat_ptr;
+};
+
+/* Queues 0 ~ 3 for AC data, 5 for iPAN */
+#define IWM_TX_QUEUES		5
+#define IWM_TX_DATA_QUEUES	4
+#define IWM_TX_CMD_QUEUE	4
+
+struct iwm_bss_info {
+	struct list_head node;
+	struct cfg80211_bss *cfg_bss;
+	struct iwm_umac_notif_bss_info *bss;
+};
+
+typedef int (*iwm_handler)(struct iwm_priv *priv, u8 *buf,
+			   unsigned long buf_size, struct iwm_wifi_cmd *cmd);
+
+#define IWM_WATCHDOG_PERIOD	(6 * HZ)
+
+struct iwm_priv {
+	struct wireless_dev *wdev;
+	struct iwm_if_ops *bus_ops;
+
+	struct iwm_conf conf;
+
+	unsigned long status;
+	unsigned long radio;
+
+	struct list_head pending_notif;
+	wait_queue_head_t notif_queue;
+
+	wait_queue_head_t nonwifi_queue;
+
+	unsigned long calib_done_map;
+	struct {
+		u8 *buf;
+		u32 size;
+	} calib_res[CALIBRATION_CMD_NUM];
+
+	struct iwm_umac_profile *umac_profile;
+	bool umac_profile_active;
+
+	u8 bssid[ETH_ALEN];
+	u8 channel;
+	u16 rate;
+
+	struct iwm_sta_info sta_table[IWM_STA_TABLE_NUM];
+	struct list_head bss_list;
+
+	void (*nonwifi_rx_handlers[UMAC_HDI_IN_OPCODE_NONWIFI_MAX])
+	(struct iwm_priv *priv, u8 *buf, unsigned long buf_size);
+
+	const iwm_handler *umac_handlers;
+	const iwm_handler *lmac_handlers;
+	DECLARE_BITMAP(lmac_handler_map, LMAC_COMMAND_ID_NUM);
+	DECLARE_BITMAP(umac_handler_map, LMAC_COMMAND_ID_NUM);
+	DECLARE_BITMAP(udma_handler_map, LMAC_COMMAND_ID_NUM);
+
+	struct list_head wifi_pending_cmd;
+	struct list_head nonwifi_pending_cmd;
+	u16 wifi_seq_num;
+	u8 nonwifi_seq_num;
+	spinlock_t cmd_lock;
+
+	u32 core_enabled;
+
+	u8 scan_id;
+	struct cfg80211_scan_request *scan_request;
+
+	struct sk_buff_head rx_list;
+	struct list_head rx_tickets;
+	struct list_head rx_packets[IWM_RX_ID_HASH];
+	struct workqueue_struct *rx_wq;
+	struct work_struct rx_worker;
+
+	struct iwm_tx_credit tx_credit;
+	struct iwm_tx_queue txq[IWM_TX_QUEUES];
+
+	struct iwm_key keys[IWM_NUM_KEYS];
+	struct iwm_key *default_key;
+
+	wait_queue_head_t mlme_queue;
+
+	struct iw_statistics wstats;
+	struct delayed_work stats_request;
+
+	struct iwm_debugfs dbg;
+
+	u8 *eeprom;
+	struct timer_list watchdog;
+	struct work_struct reset_worker;
+	struct rfkill *rfkill;
+
+	char private[0] __attribute__((__aligned__(NETDEV_ALIGN)));
+};
+
+static inline void *iwm_private(struct iwm_priv *iwm)
+{
+	BUG_ON(!iwm);
+	return &iwm->private;
+}
+
+#define hw_to_iwm(h) (h->iwm)
+#define iwm_to_dev(i) (wiphy_dev(i->wdev->wiphy))
+#define iwm_to_wiphy(i) (i->wdev->wiphy)
+#define wiphy_to_iwm(w) (struct iwm_priv *)(wiphy_priv(w))
+#define iwm_to_wdev(i) (i->wdev)
+#define wdev_to_iwm(w) (struct iwm_priv *)(wdev_priv(w))
+#define iwm_to_ndev(i) (i->wdev->netdev)
+#define ndev_to_iwm(n) (wdev_to_iwm(n->ieee80211_ptr))
+#define skb_to_rx_info(s) ((struct iwm_rx_info *)(s->cb))
+#define skb_to_tx_info(s) ((struct iwm_tx_info *)s->cb)
+
+extern const struct iw_handler_def iwm_iw_handler_def;
+
+void *iwm_if_alloc(int sizeof_bus, struct device *dev,
+		   struct iwm_if_ops *if_ops);
+void iwm_if_free(struct iwm_priv *iwm);
+int iwm_mode_to_nl80211_iftype(int mode);
+int iwm_priv_init(struct iwm_priv *iwm);
+void iwm_reset(struct iwm_priv *iwm);
+void iwm_tx_credit_init_pools(struct iwm_priv *iwm,
+			      struct iwm_umac_notif_alive *alive);
+int iwm_tx_credit_alloc(struct iwm_priv *iwm, int id, int nb);
+int iwm_notif_send(struct iwm_priv *iwm, struct iwm_wifi_cmd *cmd,
+		   u8 cmd_id, u8 source, u8 *buf, unsigned long buf_size);
+int iwm_notif_handle(struct iwm_priv *iwm, u32 cmd, u8 source, long timeout);
+void iwm_init_default_profile(struct iwm_priv *iwm,
+			      struct iwm_umac_profile *profile);
+void iwm_link_on(struct iwm_priv *iwm);
+void iwm_link_off(struct iwm_priv *iwm);
+int iwm_up(struct iwm_priv *iwm);
+int iwm_down(struct iwm_priv *iwm);
+
+/* TX API */
+void iwm_tx_credit_inc(struct iwm_priv *iwm, int id, int total_freed_pages);
+void iwm_tx_worker(struct work_struct *work);
+int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
+
+/* RX API */
+void iwm_rx_setup_handlers(struct iwm_priv *iwm);
+int iwm_rx_handle(struct iwm_priv *iwm, u8 *buf, unsigned long buf_size);
+int iwm_rx_handle_resp(struct iwm_priv *iwm, u8 *buf, unsigned long buf_size,
+		       struct iwm_wifi_cmd *cmd);
+void iwm_rx_free(struct iwm_priv *iwm);
+
+/* RF Kill API */
+int iwm_rfkill_init(struct iwm_priv *iwm);
+void iwm_rfkill_exit(struct iwm_priv *iwm);
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/lmac.h b/drivers/net/wireless/iwmc3200wifi/lmac.h
new file mode 100644
index 0000000..db2e5ee
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/lmac.h
@@ -0,0 +1,457 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_LMAC_H__
+#define __IWM_LMAC_H__
+
+struct iwm_lmac_hdr {
+	u8 id;
+	u8 flags;
+	__le16 seq_num;
+} __attribute__ ((packed));
+
+/* LMAC commands */
+#define CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_AFTER_MSK  0x1
+
+struct iwm_lmac_cal_cfg_elt {
+	__le32 enable; /* 1 means LMAC needs to do something */
+	__le32 start;  /* 1 to start calibration, 0 to stop */
+	__le32 send_res; /* 1 for sending back results */
+	__le32 apply_res; /* 1 for applying calibration results to HW */
+	__le32 reserved;
+} __attribute__ ((packed));
+
+struct iwm_lmac_cal_cfg_status {
+	struct iwm_lmac_cal_cfg_elt init;
+	struct iwm_lmac_cal_cfg_elt periodic;
+	__le32 flags; /* CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_AFTER_MSK */
+} __attribute__ ((packed));
+
+struct iwm_lmac_cal_cfg_cmd {
+	struct iwm_lmac_cal_cfg_status ucode_cfg;
+	struct iwm_lmac_cal_cfg_status driver_cfg;
+	__le32 reserved;
+} __attribute__ ((packed));
+
+struct iwm_lmac_cal_cfg_resp {
+	__le32 status;
+} __attribute__ ((packed));
+
+#define IWM_CARD_STATE_SW_HW_ENABLED	0x00
+#define IWM_CARD_STATE_HW_DISABLED	0x01
+#define IWM_CARD_STATE_SW_DISABLED	0x02
+#define IWM_CARD_STATE_CTKILL_DISABLED	0x04
+#define IWM_CARD_STATE_IS_RXON		0x10
+
+struct iwm_lmac_card_state {
+	__le32 flags;
+} __attribute__ ((packed));
+
+/**
+ * COEX_PRIORITY_TABLE_CMD
+ *
+ * Priority entry for each state
+ * Will keep two tables, for STA and WIPAN
+ */
+enum {
+	/* UN-ASSOCIATION PART */
+	COEX_UNASSOC_IDLE = 0,
+	COEX_UNASSOC_MANUAL_SCAN,
+	COEX_UNASSOC_AUTO_SCAN,
+
+	/* CALIBRATION */
+	COEX_CALIBRATION,
+	COEX_PERIODIC_CALIBRATION,
+
+	/* CONNECTION */
+	COEX_CONNECTION_ESTAB,
+
+	/* ASSOCIATION PART */
+	COEX_ASSOCIATED_IDLE,
+	COEX_ASSOC_MANUAL_SCAN,
+	COEX_ASSOC_AUTO_SCAN,
+	COEX_ASSOC_ACTIVE_LEVEL,
+
+	/* RF ON/OFF */
+	COEX_RF_ON,
+	COEX_RF_OFF,
+	COEX_STAND_ALONE_DEBUG,
+
+	/* IPNN */
+	COEX_IPAN_ASSOC_LEVEL,
+
+	/* RESERVED */
+	COEX_RSRVD1,
+	COEX_RSRVD2,
+
+	COEX_EVENTS_NUM
+};
+
+#define COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK	0x1
+#define COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK	0x2
+#define COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_MSK	0x4
+
+struct coex_event {
+	u8 req_prio;
+	u8 win_med_prio;
+	u8 reserved;
+	u8 flags;
+} __attribute__ ((packed));
+
+#define COEX_FLAGS_STA_TABLE_VALID_MSK		0x1
+#define COEX_FLAGS_UNASSOC_WAKEUP_UMASK_MSK	0x4
+#define COEX_FLAGS_ASSOC_WAKEUP_UMASK_MSK	0x8
+#define COEX_FLAGS_COEX_ENABLE_MSK		0x80
+
+struct iwm_coex_prio_table_cmd {
+	u8 flags;
+	u8 reserved[3];
+	struct coex_event sta_prio[COEX_EVENTS_NUM];
+} __attribute__ ((packed));
+
+/* Coexistence definitions
+ *
+ * Constants to fill in the Priorities' Tables
+ * RP - Requested Priority
+ * WP - Win Medium Priority: priority assigned when the contention has been won
+ * FLAGS - Combination of COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK and
+ * 	   COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK
+ */
+
+#define COEX_UNASSOC_IDLE_FLAGS		0
+#define COEX_UNASSOC_MANUAL_SCAN_FLAGS	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+					 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK)
+#define COEX_UNASSOC_AUTO_SCAN_FLAGS	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+					 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK)
+#define COEX_CALIBRATION_FLAGS		(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+					 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK)
+#define COEX_PERIODIC_CALIBRATION_FLAGS	0
+/* COEX_CONNECTION_ESTAB: we need DELAY_MEDIUM_FREE_NTFY to let WiMAX
+ * disconnect from network. */
+#define COEX_CONNECTION_ESTAB_FLAGS (COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+				     COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK | \
+				     COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_MSK)
+#define COEX_ASSOCIATED_IDLE_FLAGS	0
+#define COEX_ASSOC_MANUAL_SCAN_FLAGS	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+					 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK)
+#define COEX_ASSOC_AUTO_SCAN_FLAGS	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+					 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK)
+#define COEX_ASSOC_ACTIVE_LEVEL_FLAGS	0
+#define COEX_RF_ON_FLAGS		0
+#define COEX_RF_OFF_FLAGS		0
+#define COEX_STAND_ALONE_DEBUG_FLAGS	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+					 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK)
+#define COEX_IPAN_ASSOC_LEVEL_FLAGS (COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+				     COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK | \
+				     COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_MSK)
+#define COEX_RSRVD1_FLAGS		0
+#define COEX_RSRVD2_FLAGS		0
+/* XOR_RF_ON is the event wrapping all radio ownership. We need
+ * DELAY_MEDIUM_FREE_NTFY to let WiMAX disconnect from network. */
+#define COEX_XOR_RF_ON_FLAGS	    (COEX_EVT_FLAG_MEDIUM_FREE_NTFY_MSK | \
+				     COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK | \
+				     COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_MSK)
+
+/* LMAC OP CODES */
+#define REPLY_PAD			0x0
+#define REPLY_ALIVE			0x1
+#define REPLY_ERROR			0x2
+#define REPLY_ECHO			0x3
+#define REPLY_HALT			0x6
+
+/* RXON state commands */
+#define REPLY_RX_ON			0x10
+#define REPLY_RX_ON_ASSOC		0x11
+#define REPLY_RX_OFF			0x12
+#define REPLY_QOS_PARAM			0x13
+#define REPLY_RX_ON_TIMING		0x14
+#define REPLY_INTERNAL_QOS_PARAM	0x15
+#define REPLY_RX_INT_TIMEOUT_CNFG	0x16
+#define REPLY_NULL			0x17
+
+/* Multi-Station support */
+#define REPLY_ADD_STA			0x18
+#define REPLY_REMOVE_STA		0x19
+#define REPLY_RESET_ALL_STA		0x1a
+
+/* RX, TX */
+#define REPLY_ALM_RX			0x1b
+#define REPLY_TX			0x1c
+#define REPLY_TXFIFO_FLUSH		0x1e
+
+/* MISC commands */
+#define REPLY_MGMT_MCAST_KEY		0x1f
+#define REPLY_WEPKEY			0x20
+#define REPLY_INIT_IV			0x21
+#define REPLY_WRITE_MIB			0x22
+#define REPLY_READ_MIB			0x23
+#define REPLY_RADIO_FE			0x24
+#define REPLY_TXFIFO_CFG		0x25
+#define REPLY_WRITE_READ		0x26
+#define REPLY_INSTALL_SEC_KEY		0x27
+
+
+#define REPLY_RATE_SCALE		0x47
+#define REPLY_LEDS_CMD			0x48
+#define REPLY_TX_LINK_QUALITY_CMD	0x4e
+#define REPLY_ANA_MIB_OVERRIDE_CMD	0x4f
+#define REPLY_WRITE2REG_CMD		0x50
+
+/* winfi-wifi coexistence */
+#define COEX_PRIORITY_TABLE_CMD		0x5a
+#define COEX_MEDIUM_NOTIFICATION	0x5b
+#define COEX_EVENT_CMD			0x5c
+
+/* more Protocol and Protocol-test commands */
+#define REPLY_MAX_SLEEP_TIME_CMD	0x61
+#define CALIBRATION_CFG_CMD		0x65
+#define CALIBRATION_RES_NOTIFICATION	0x66
+#define CALIBRATION_COMPLETE_NOTIFICATION	0x67
+
+/* Measurements */
+#define REPLY_QUIET_CMD			0x71
+#define REPLY_CHANNEL_SWITCH		0x72
+#define CHANNEL_SWITCH_NOTIFICATION	0x73
+
+#define REPLY_SPECTRUM_MEASUREMENT_CMD	0x74
+#define SPECTRUM_MEASURE_NOTIFICATION	0x75
+#define REPLY_MEASUREMENT_ABORT_CMD	0x76
+
+/* Power Management */
+#define POWER_TABLE_CMD			0x77
+#define SAVE_RESTORE_ADRESS_CMD		0x78
+#define REPLY_WATERMARK_CMD		0x79
+#define PM_DEBUG_STATISTIC_NOTIFIC	0x7B
+#define PD_FLUSH_N_NOTIFICATION		0x7C
+
+/* Scan commands and notifications */
+#define REPLY_SCAN_REQUEST_CMD		0x80
+#define REPLY_SCAN_ABORT_CMD		0x81
+#define SCAN_START_NOTIFICATION		0x82
+#define SCAN_RESULTS_NOTIFICATION	0x83
+#define SCAN_COMPLETE_NOTIFICATION	0x84
+
+/* Continuous TX commands */
+#define REPLY_CONT_TX_CMD		0x85
+#define END_OF_CONT_TX_NOTIFICATION	0x86
+
+/* Timer/Eeprom commands */
+#define TIMER_CMD			0x87
+#define EEPROM_WRITE_CMD		0x88
+
+/* PAPD commands */
+#define FEEDBACK_REQUEST_NOTIFICATION	0x8b
+#define REPLY_CW_CMD			0x8c
+
+/* IBSS/AP commands Continue */
+#define BEACON_NOTIFICATION		0x90
+#define REPLY_TX_BEACON			0x91
+#define REPLY_REQUEST_ATIM		0x93
+#define WHO_IS_AWAKE_NOTIFICATION	0x94
+#define TX_PWR_DBM_LIMIT_CMD		0x95
+#define QUIET_NOTIFICATION		0x96
+#define TX_PWR_TABLE_CMD		0x97
+#define TX_ANT_CONFIGURATION_CMD	0x98
+#define MEASURE_ABORT_NOTIFICATION	0x99
+#define REPLY_CALIBRATION_TUNE		0x9a
+
+/* bt config command */
+#define REPLY_BT_CONFIG			0x9b
+#define REPLY_STATISTICS_CMD		0x9c
+#define STATISTICS_NOTIFICATION		0x9d
+
+/* RF-KILL commands and notifications */
+#define REPLY_CARD_STATE_CMD		0xa0
+#define CARD_STATE_NOTIFICATION		0xa1
+
+/* Missed beacons notification */
+#define MISSED_BEACONS_NOTIFICATION	0xa2
+#define MISSED_BEACONS_NOTIFICATION_TH_CMD	0xa3
+
+#define REPLY_CT_KILL_CONFIG_CMD	0xa4
+
+/* HD commands and notifications */
+#define REPLY_HD_PARAMS_CMD		0xa6
+#define HD_PARAMS_NOTIFICATION		0xa7
+#define SENSITIVITY_CMD			0xa8
+#define U_APSD_PARAMS_CMD		0xa9
+#define NOISY_PLATFORM_CMD		0xaa
+#define ILLEGAL_CMD			0xac
+#define REPLY_PHY_CALIBRATION_CMD	0xb0
+#define REPLAY_RX_GAIN_CALIB_CMD	0xb1
+
+/* WiPAN commands */
+#define REPLY_WIPAN_PARAMS_CMD		0xb2
+#define REPLY_WIPAN_RX_ON_CMD		0xb3
+#define REPLY_WIPAN_RX_ON_TIMING	0xb4
+#define REPLY_WIPAN_TX_PWR_TABLE_CMD	0xb5
+#define REPLY_WIPAN_RXON_ASSOC_CMD	0xb6
+#define REPLY_WIPAN_QOS_PARAM		0xb7
+#define WIPAN_REPLY_WEPKEY		0xb8
+
+/* BeamForming commands */
+#define BEAMFORMER_CFG_CMD		0xba
+#define BEAMFORMEE_NOTIFICATION		0xbb
+
+/* TGn new Commands */
+#define REPLY_RX_PHY_CMD		0xc0
+#define REPLY_RX_MPDU_CMD		0xc1
+#define REPLY_MULTICAST_HASH		0xc2
+#define REPLY_KDR_RX			0xc3
+#define REPLY_RX_DSP_EXT_INFO		0xc4
+#define REPLY_COMPRESSED_BA		0xc5
+
+/* PNC commands */
+#define PNC_CONFIG_CMD			0xc8
+#define PNC_UPDATE_TABLE_CMD		0xc9
+#define XVT_GENERAL_CTRL_CMD		0xca
+#define REPLY_LEGACY_RADIO_FE		0xdd
+
+/* WoWLAN commands */
+#define WOWLAN_PATTERNS			0xe0
+#define WOWLAN_WAKEUP_FILTER		0xe1
+#define WOWLAN_TSC_RSC_PARAM		0xe2
+#define WOWLAN_TKIP_PARAM		0xe3
+#define WOWLAN_KEK_KCK_MATERIAL		0xe4
+#define WOWLAN_GET_STATUSES		0xe5
+#define WOWLAN_TX_POWER_PER_DB		0xe6
+#define REPLY_WOWLAN_GET_STATUSES       WOWLAN_GET_STATUSES
+
+#define REPLY_DEBUG_CMD			0xf0
+#define REPLY_DSP_DEBUG_CMD		0xf1
+#define REPLY_DEBUG_MONITOR_CMD		0xf2
+#define REPLY_DEBUG_XVT_CMD		0xf3
+#define REPLY_DEBUG_DC_CALIB		0xf4
+#define REPLY_DYNAMIC_BP		0xf5
+
+/* General purpose Commands */
+#define REPLY_GP1_CMD			0xfa
+#define REPLY_GP2_CMD			0xfb
+#define REPLY_GP3_CMD			0xfc
+#define REPLY_GP4_CMD			0xfd
+#define REPLY_REPLAY_WRAPPER		0xfe
+#define REPLY_FRAME_DURATION_CALC_CMD	0xff
+
+#define LMAC_COMMAND_ID_MAX		0xff
+#define LMAC_COMMAND_ID_NUM		(LMAC_COMMAND_ID_MAX + 1)
+
+
+/* Calibration */
+
+enum {
+	PHY_CALIBRATE_DC_CMD			= 0,
+	PHY_CALIBRATE_LO_CMD			= 1,
+	PHY_CALIBRATE_RX_BB_CMD			= 2,
+	PHY_CALIBRATE_TX_IQ_CMD			= 3,
+	PHY_CALIBRATE_RX_IQ_CMD			= 4,
+	PHY_CALIBRATION_NOISE_CMD		= 5,
+	PHY_CALIBRATE_AGC_TABLE_CMD		= 6,
+	PHY_CALIBRATE_CRYSTAL_FRQ_CMD		= 7,
+	PHY_CALIBRATE_OPCODES_NUM,
+	SHILOH_PHY_CALIBRATE_DC_CMD		= 8,
+	SHILOH_PHY_CALIBRATE_LO_CMD		= 9,
+	SHILOH_PHY_CALIBRATE_RX_BB_CMD		= 10,
+	SHILOH_PHY_CALIBRATE_TX_IQ_CMD		= 11,
+	SHILOH_PHY_CALIBRATE_RX_IQ_CMD		= 12,
+	SHILOH_PHY_CALIBRATION_NOISE_CMD	= 13,
+	SHILOH_PHY_CALIBRATE_AGC_TABLE_CMD	= 14,
+	SHILOH_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
+	SHILOH_PHY_CALIBRATE_BASE_BAND_CMD	= 16,
+	SHILOH_PHY_CALIBRATE_TXIQ_PERIODIC_CMD	= 17,
+	CALIBRATION_CMD_NUM,
+};
+
+struct iwm_lmac_calib_hdr {
+	u8 opcode;
+	u8 first_grp;
+	u8 grp_num;
+	u8 all_data_valid;
+} __attribute__ ((packed));
+
+#define IWM_LMAC_CALIB_FREQ_GROUPS_NR	7
+#define IWM_CALIB_FREQ_GROUPS_NR	5
+#define IWM_CALIB_DC_MODES_NR		12
+
+struct iwm_calib_rxiq_entry {
+	u16 ptam_postdist_ars;
+	u16 ptam_postdist_arc;
+} __attribute__ ((packed));
+
+struct iwm_calib_rxiq_group {
+	struct iwm_calib_rxiq_entry mode[IWM_CALIB_DC_MODES_NR];
+} __attribute__ ((packed));
+
+struct iwm_lmac_calib_rxiq {
+	struct iwm_calib_rxiq_group group[IWM_LMAC_CALIB_FREQ_GROUPS_NR];
+} __attribute__ ((packed));
+
+struct iwm_calib_rxiq {
+	struct iwm_lmac_calib_hdr hdr;
+	struct iwm_calib_rxiq_group group[IWM_CALIB_FREQ_GROUPS_NR];
+} __attribute__ ((packed));
+
+#define LMAC_STA_ID_SEED	0x0f
+#define LMAC_STA_ID_POS		0
+
+#define LMAC_STA_COLOR_SEED	0x7
+#define LMAC_STA_COLOR_POS	4
+
+struct iwm_lmac_power_report {
+	u8 pa_status;
+	u8 pa_integ_res_A[3];
+	u8 pa_integ_res_B[3];
+	u8 pa_integ_res_C[3];
+} __attribute__ ((packed));
+
+struct iwm_lmac_tx_resp {
+	u8 frame_cnt; /* 1-no aggregation, greater then 1 - aggregation */
+	u8 bt_kill_cnt;
+	__le16 retry_cnt;
+	__le32 initial_tx_rate;
+	__le16 wireless_media_time;
+	struct iwm_lmac_power_report power_report;
+	__le32 tfd_info;
+	__le16 seq_ctl;
+	__le16 byte_cnt;
+	u8 tlc_rate_info;
+	u8 ra_tid;
+	__le16 frame_ctl;
+	__le32 status;
+} __attribute__ ((packed));
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
new file mode 100644
index 0000000..6a2640f
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -0,0 +1,680 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/ieee80211.h>
+#include <linux/wireless.h>
+
+#include "iwm.h"
+#include "debug.h"
+#include "bus.h"
+#include "umac.h"
+#include "commands.h"
+#include "hal.h"
+#include "fw.h"
+#include "rx.h"
+
+static struct iwm_conf def_iwm_conf = {
+
+	.sdio_ior_timeout	= 5000,
+	.init_calib_map		= BIT(PHY_CALIBRATE_DC_CMD)	|
+				  BIT(PHY_CALIBRATE_LO_CMD)	|
+				  BIT(PHY_CALIBRATE_TX_IQ_CMD)	|
+				  BIT(PHY_CALIBRATE_RX_IQ_CMD),
+	.periodic_calib_map	= BIT(PHY_CALIBRATE_DC_CMD)	|
+				  BIT(PHY_CALIBRATE_LO_CMD)	|
+				  BIT(PHY_CALIBRATE_TX_IQ_CMD)	|
+				  BIT(PHY_CALIBRATE_RX_IQ_CMD)	|
+				  BIT(SHILOH_PHY_CALIBRATE_BASE_BAND_CMD),
+	.reset_on_fatal_err	= 1,
+	.auto_connect		= 1,
+	.wimax_not_present	= 0,
+	.enable_qos		= 1,
+	.mode			= UMAC_MODE_BSS,
+
+	/* UMAC configuration */
+	.power_index		= 0,
+	.frag_threshold		= IEEE80211_MAX_FRAG_THRESHOLD,
+	.rts_threshold		= IEEE80211_MAX_RTS_THRESHOLD,
+	.cts_to_self		= 0,
+
+	.assoc_timeout		= 2,
+	.roam_timeout		= 10,
+	.wireless_mode		= WIRELESS_MODE_11A | WIRELESS_MODE_11G,
+	.coexist_mode		= COEX_MODE_CM,
+
+	/* IBSS */
+	.ibss_band		= UMAC_BAND_2GHZ,
+	.ibss_channel		= 1,
+
+	.mac_addr		= {0x00, 0x02, 0xb3, 0x01, 0x02, 0x03},
+};
+
+static int modparam_reset;
+module_param_named(reset, modparam_reset, bool, 0644);
+MODULE_PARM_DESC(reset, "reset on firmware errors (default 0 [not reset])");
+
+int iwm_mode_to_nl80211_iftype(int mode)
+{
+	switch (mode) {
+	case UMAC_MODE_BSS:
+		return NL80211_IFTYPE_STATION;
+	case UMAC_MODE_IBSS:
+		return NL80211_IFTYPE_ADHOC;
+	default:
+		return NL80211_IFTYPE_UNSPECIFIED;
+	}
+
+	return 0;
+}
+
+static void iwm_statistics_request(struct work_struct *work)
+{
+	struct iwm_priv *iwm =
+		container_of(work, struct iwm_priv, stats_request.work);
+
+	iwm_send_umac_stats_req(iwm, 0);
+}
+
+static void iwm_reset_worker(struct work_struct *work)
+{
+	struct iwm_priv *iwm;
+	struct iwm_umac_profile *profile = NULL;
+	int uninitialized_var(ret), retry = 0;
+
+	iwm = container_of(work, struct iwm_priv, reset_worker);
+
+	if (iwm->umac_profile_active) {
+		profile = kmalloc(sizeof(struct iwm_umac_profile), GFP_KERNEL);
+		if (profile)
+			memcpy(profile, iwm->umac_profile, sizeof(*profile));
+		else
+			IWM_ERR(iwm, "Couldn't alloc memory for profile\n");
+	}
+
+	iwm_down(iwm);
+
+	while (retry++ < 3) {
+		ret = iwm_up(iwm);
+		if (!ret)
+			break;
+
+		schedule_timeout_uninterruptible(10 * HZ);
+	}
+
+	if (ret) {
+		IWM_WARN(iwm, "iwm_up() failed: %d\n", ret);
+
+		kfree(profile);
+		return;
+	}
+
+	if (profile) {
+		IWM_DBG_MLME(iwm, DBG, "Resend UMAC profile\n");
+		memcpy(iwm->umac_profile, profile, sizeof(*profile));
+		iwm_send_mlme_profile(iwm);
+		kfree(profile);
+	}
+}
+
+static void iwm_watchdog(unsigned long data)
+{
+	struct iwm_priv *iwm = (struct iwm_priv *)data;
+
+	IWM_WARN(iwm, "Watchdog expired: UMAC stalls!\n");
+
+	if (modparam_reset)
+		schedule_work(&iwm->reset_worker);
+}
+
+int iwm_priv_init(struct iwm_priv *iwm)
+{
+	int i;
+	char name[32];
+
+	iwm->status = 0;
+	INIT_LIST_HEAD(&iwm->pending_notif);
+	init_waitqueue_head(&iwm->notif_queue);
+	init_waitqueue_head(&iwm->nonwifi_queue);
+	init_waitqueue_head(&iwm->mlme_queue);
+	memcpy(&iwm->conf, &def_iwm_conf, sizeof(struct iwm_conf));
+	spin_lock_init(&iwm->tx_credit.lock);
+	INIT_LIST_HEAD(&iwm->wifi_pending_cmd);
+	INIT_LIST_HEAD(&iwm->nonwifi_pending_cmd);
+	iwm->wifi_seq_num = UMAC_WIFI_SEQ_NUM_BASE;
+	iwm->nonwifi_seq_num = UMAC_NONWIFI_SEQ_NUM_BASE;
+	spin_lock_init(&iwm->cmd_lock);
+	iwm->scan_id = 1;
+	INIT_DELAYED_WORK(&iwm->stats_request, iwm_statistics_request);
+	INIT_WORK(&iwm->reset_worker, iwm_reset_worker);
+	INIT_LIST_HEAD(&iwm->bss_list);
+
+	skb_queue_head_init(&iwm->rx_list);
+	INIT_LIST_HEAD(&iwm->rx_tickets);
+	for (i = 0; i < IWM_RX_ID_HASH; i++)
+		INIT_LIST_HEAD(&iwm->rx_packets[i]);
+
+	INIT_WORK(&iwm->rx_worker, iwm_rx_worker);
+
+	iwm->rx_wq = create_singlethread_workqueue(KBUILD_MODNAME "_rx");
+	if (!iwm->rx_wq)
+		return -EAGAIN;
+
+	for (i = 0; i < IWM_TX_QUEUES; i++) {
+		INIT_WORK(&iwm->txq[i].worker, iwm_tx_worker);
+		snprintf(name, 32, KBUILD_MODNAME "_tx_%d", i);
+		iwm->txq[i].id = i;
+		iwm->txq[i].wq = create_singlethread_workqueue(name);
+		if (!iwm->txq[i].wq)
+			return -EAGAIN;
+
+		skb_queue_head_init(&iwm->txq[i].queue);
+	}
+
+	for (i = 0; i < IWM_NUM_KEYS; i++)
+		memset(&iwm->keys[i], 0, sizeof(struct iwm_key));
+
+	iwm->default_key = NULL;
+
+	init_timer(&iwm->watchdog);
+	iwm->watchdog.function = iwm_watchdog;
+	iwm->watchdog.data = (unsigned long)iwm;
+
+	return 0;
+}
+
+/*
+ * We reset all the structures, and we reset the UMAC.
+ * After calling this routine, you're expected to reload
+ * the firmware.
+ */
+void iwm_reset(struct iwm_priv *iwm)
+{
+	struct iwm_notif *notif, *next;
+
+	if (test_bit(IWM_STATUS_READY, &iwm->status))
+		iwm_target_reset(iwm);
+
+	iwm->status = 0;
+	iwm->scan_id = 1;
+
+	list_for_each_entry_safe(notif, next, &iwm->pending_notif, pending) {
+		list_del(&notif->pending);
+		kfree(notif->buf);
+		kfree(notif);
+	}
+
+	iwm_cmd_flush(iwm);
+
+	flush_workqueue(iwm->rx_wq);
+
+	iwm_link_off(iwm);
+}
+
+/*
+ * Notification code:
+ *
+ * We're faced with the following issue: Any host command can
+ * have an answer or not, and if there's an answer to expect,
+ * it can be treated synchronously or asynchronously.
+ * To work around the synchronous answer case, we implemented
+ * our notification mechanism.
+ * When a code path needs to wait for a command response
+ * synchronously, it calls notif_handle(), which waits for the
+ * right notification to show up, and then process it. Before
+ * starting to wait, it registered as a waiter for this specific
+ * answer (by toggling a bit in on of the handler_map), so that
+ * the rx code knows that it needs to send a notification to the
+ * waiting processes. It does so by calling iwm_notif_send(),
+ * which adds the notification to the pending notifications list,
+ * and then wakes the waiting processes up.
+ */
+int iwm_notif_send(struct iwm_priv *iwm, struct iwm_wifi_cmd *cmd,
+		   u8 cmd_id, u8 source, u8 *buf, unsigned long buf_size)
+{
+	struct iwm_notif *notif;
+
+	notif = kzalloc(sizeof(struct iwm_notif), GFP_KERNEL);
+	if (!notif) {
+		IWM_ERR(iwm, "Couldn't alloc memory for notification\n");
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&notif->pending);
+	notif->cmd = cmd;
+	notif->cmd_id = cmd_id;
+	notif->src = source;
+	notif->buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!notif->buf) {
+		IWM_ERR(iwm, "Couldn't alloc notification buffer\n");
+		kfree(notif);
+		return -ENOMEM;
+	}
+	notif->buf_size = buf_size;
+	memcpy(notif->buf, buf, buf_size);
+	list_add_tail(&notif->pending, &iwm->pending_notif);
+
+	wake_up_interruptible(&iwm->notif_queue);
+
+	return 0;
+}
+
+static struct iwm_notif *iwm_notif_find(struct iwm_priv *iwm, u32 cmd,
+					u8 source)
+{
+	struct iwm_notif *notif, *next;
+
+	list_for_each_entry_safe(notif, next, &iwm->pending_notif, pending) {
+		if ((notif->cmd_id == cmd) && (notif->src == source)) {
+			list_del(&notif->pending);
+			return notif;
+		}
+	}
+
+	return NULL;
+}
+
+static struct iwm_notif *iwm_notif_wait(struct iwm_priv *iwm, u32 cmd,
+					u8 source, long timeout)
+{
+	int ret;
+	struct iwm_notif *notif;
+	unsigned long *map = NULL;
+
+	switch (source) {
+	case IWM_SRC_LMAC:
+		map = &iwm->lmac_handler_map[0];
+		break;
+	case IWM_SRC_UMAC:
+		map = &iwm->umac_handler_map[0];
+		break;
+	case IWM_SRC_UDMA:
+		map = &iwm->udma_handler_map[0];
+		break;
+	}
+
+	set_bit(cmd, map);
+
+	ret = wait_event_interruptible_timeout(iwm->notif_queue,
+			 ((notif = iwm_notif_find(iwm, cmd, source)) != NULL),
+					       timeout);
+	clear_bit(cmd, map);
+
+	if (!ret)
+		return NULL;
+
+	return notif;
+}
+
+int iwm_notif_handle(struct iwm_priv *iwm, u32 cmd, u8 source, long timeout)
+{
+	int ret;
+	struct iwm_notif *notif;
+
+	notif = iwm_notif_wait(iwm, cmd, source, timeout);
+	if (!notif)
+		return -ETIME;
+
+	ret = iwm_rx_handle_resp(iwm, notif->buf, notif->buf_size, notif->cmd);
+	kfree(notif->buf);
+	kfree(notif);
+
+	return ret;
+}
+
+static int iwm_config_boot_params(struct iwm_priv *iwm)
+{
+	struct iwm_udma_nonwifi_cmd target_cmd;
+	int ret;
+
+	/* check Wimax is off and config debug monitor */
+	if (iwm->conf.wimax_not_present) {
+		u32 data1 = 0x1f;
+		u32 addr1 = 0x606BE258;
+
+		u32 data2_set = 0x0;
+		u32 data2_clr = 0x1;
+		u32 addr2 = 0x606BE100;
+
+		u32 data3 = 0x1;
+		u32 addr3 = 0x606BEC00;
+
+		target_cmd.resp = 0;
+		target_cmd.handle_by_hw = 0;
+		target_cmd.eop = 1;
+
+		target_cmd.opcode = UMAC_HDI_OUT_OPCODE_WRITE;
+		target_cmd.addr = cpu_to_le32(addr1);
+		target_cmd.op1_sz = cpu_to_le32(sizeof(u32));
+		target_cmd.op2 = 0;
+
+		ret = iwm_hal_send_target_cmd(iwm, &target_cmd, &data1);
+		if (ret < 0) {
+			IWM_ERR(iwm, "iwm_hal_send_target_cmd failed\n");
+			return ret;
+		}
+
+		target_cmd.opcode = UMAC_HDI_OUT_OPCODE_READ_MODIFY_WRITE;
+		target_cmd.addr = cpu_to_le32(addr2);
+		target_cmd.op1_sz = cpu_to_le32(data2_set);
+		target_cmd.op2 = cpu_to_le32(data2_clr);
+
+		ret = iwm_hal_send_target_cmd(iwm, &target_cmd, &data1);
+		if (ret < 0) {
+			IWM_ERR(iwm, "iwm_hal_send_target_cmd failed\n");
+			return ret;
+		}
+
+		target_cmd.opcode = UMAC_HDI_OUT_OPCODE_WRITE;
+		target_cmd.addr = cpu_to_le32(addr3);
+		target_cmd.op1_sz = cpu_to_le32(sizeof(u32));
+		target_cmd.op2 = 0;
+
+		ret = iwm_hal_send_target_cmd(iwm, &target_cmd, &data3);
+		if (ret < 0) {
+			IWM_ERR(iwm, "iwm_hal_send_target_cmd failed\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+void iwm_init_default_profile(struct iwm_priv *iwm,
+			      struct iwm_umac_profile *profile)
+{
+	memset(profile, 0, sizeof(struct iwm_umac_profile));
+
+	profile->sec.auth_type = UMAC_AUTH_TYPE_OPEN;
+	profile->sec.flags = UMAC_SEC_FLG_LEGACY_PROFILE;
+	profile->sec.ucast_cipher = UMAC_CIPHER_TYPE_NONE;
+	profile->sec.mcast_cipher = UMAC_CIPHER_TYPE_NONE;
+
+	if (iwm->conf.enable_qos)
+		profile->flags |= cpu_to_le16(UMAC_PROFILE_QOS_ALLOWED);
+
+	profile->wireless_mode = iwm->conf.wireless_mode;
+	profile->mode = cpu_to_le32(iwm->conf.mode);
+
+	profile->ibss.atim = 0;
+	profile->ibss.beacon_interval = 100;
+	profile->ibss.join_only = 0;
+	profile->ibss.band = iwm->conf.ibss_band;
+	profile->ibss.channel = iwm->conf.ibss_channel;
+}
+
+void iwm_link_on(struct iwm_priv *iwm)
+{
+	netif_carrier_on(iwm_to_ndev(iwm));
+	netif_tx_wake_all_queues(iwm_to_ndev(iwm));
+
+	iwm_send_umac_stats_req(iwm, 0);
+}
+
+void iwm_link_off(struct iwm_priv *iwm)
+{
+	struct iw_statistics *wstats = &iwm->wstats;
+	int i;
+
+	netif_tx_stop_all_queues(iwm_to_ndev(iwm));
+	netif_carrier_off(iwm_to_ndev(iwm));
+
+	for (i = 0; i < IWM_TX_QUEUES; i++) {
+		skb_queue_purge(&iwm->txq[i].queue);
+
+		iwm->txq[i].concat_count = 0;
+		iwm->txq[i].concat_ptr = iwm->txq[i].concat_buf;
+
+		flush_workqueue(iwm->txq[i].wq);
+	}
+
+	iwm_rx_free(iwm);
+
+	cancel_delayed_work(&iwm->stats_request);
+	memset(wstats, 0, sizeof(struct iw_statistics));
+	wstats->qual.updated = IW_QUAL_ALL_INVALID;
+
+	del_timer_sync(&iwm->watchdog);
+}
+
+static void iwm_bss_list_clean(struct iwm_priv *iwm)
+{
+	struct iwm_bss_info *bss, *next;
+
+	list_for_each_entry_safe(bss, next, &iwm->bss_list, node) {
+		list_del(&bss->node);
+		kfree(bss->bss);
+		kfree(bss);
+	}
+}
+
+static int iwm_channels_init(struct iwm_priv *iwm)
+{
+	int ret;
+
+#ifdef CONFIG_IWM_B0_HW_SUPPORT
+	if (iwm->conf.hw_b0) {
+		IWM_INFO(iwm, "Workaround EEPROM channels for B0 hardware\n");
+		return 0;
+	}
+#endif
+
+	ret = iwm_send_umac_channel_list(iwm);
+	if (ret) {
+		IWM_ERR(iwm, "Send channel list failed\n");
+		return ret;
+	}
+
+	ret = iwm_notif_handle(iwm, UMAC_CMD_OPCODE_GET_CHAN_INFO_LIST,
+			       IWM_SRC_UMAC, WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Didn't get a channel list notification\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+int iwm_up(struct iwm_priv *iwm)
+{
+	int ret;
+	struct iwm_notif *notif_reboot, *notif_ack = NULL;
+
+	ret = iwm_bus_enable(iwm);
+	if (ret) {
+		IWM_ERR(iwm, "Couldn't enable function\n");
+		return ret;
+	}
+
+	iwm_rx_setup_handlers(iwm);
+
+	/* Wait for initial BARKER_REBOOT from hardware */
+	notif_reboot = iwm_notif_wait(iwm, IWM_BARKER_REBOOT_NOTIFICATION,
+				      IWM_SRC_UDMA, 2 * HZ);
+	if (!notif_reboot) {
+		IWM_ERR(iwm, "Wait for REBOOT_BARKER timeout\n");
+		goto err_disable;
+	}
+
+	/* We send the barker back */
+	ret = iwm_bus_send_chunk(iwm, notif_reboot->buf, 16);
+	if (ret) {
+		IWM_ERR(iwm, "REBOOT barker response failed\n");
+		kfree(notif_reboot);
+		goto err_disable;
+	}
+
+	kfree(notif_reboot->buf);
+	kfree(notif_reboot);
+
+	/* Wait for ACK_BARKER from hardware */
+	notif_ack = iwm_notif_wait(iwm, IWM_ACK_BARKER_NOTIFICATION,
+				   IWM_SRC_UDMA, 2 * HZ);
+	if (!notif_ack) {
+		IWM_ERR(iwm, "Wait for ACK_BARKER timeout\n");
+		goto err_disable;
+	}
+
+	kfree(notif_ack->buf);
+	kfree(notif_ack);
+
+	/* We start to config static boot parameters */
+	ret = iwm_config_boot_params(iwm);
+	if (ret) {
+		IWM_ERR(iwm, "Config boot parameters failed\n");
+		goto err_disable;
+	}
+
+	ret = iwm_read_mac(iwm, iwm_to_ndev(iwm)->dev_addr);
+	if (ret) {
+		IWM_ERR(iwm, "MAC reading failed\n");
+		goto err_disable;
+	}
+
+	/* We can load the FWs */
+	ret = iwm_load_fw(iwm);
+	if (ret) {
+		IWM_ERR(iwm, "FW loading failed\n");
+		goto err_disable;
+	}
+
+	/* We configure the UMAC and enable the wifi module */
+	ret = iwm_send_umac_config(iwm,
+			cpu_to_le32(UMAC_RST_CTRL_FLG_WIFI_CORE_EN) |
+			cpu_to_le32(UMAC_RST_CTRL_FLG_WIFI_LINK_EN) |
+			cpu_to_le32(UMAC_RST_CTRL_FLG_WIFI_MLME_EN));
+	if (ret) {
+		IWM_ERR(iwm, "UMAC config failed\n");
+		goto err_fw;
+	}
+
+	ret = iwm_notif_handle(iwm, UMAC_NOTIFY_OPCODE_WIFI_CORE_STATUS,
+			       IWM_SRC_UMAC, WAIT_NOTIF_TIMEOUT);
+	if (ret) {
+		IWM_ERR(iwm, "Didn't get a wifi core status notification\n");
+		goto err_fw;
+	}
+
+	if (iwm->core_enabled != (UMAC_NTFY_WIFI_CORE_STATUS_LINK_EN |
+				  UMAC_NTFY_WIFI_CORE_STATUS_MLME_EN)) {
+		IWM_DBG_BOOT(iwm, DBG, "Not all cores enabled:0x%x\n",
+			     iwm->core_enabled);
+		ret = iwm_notif_handle(iwm, UMAC_NOTIFY_OPCODE_WIFI_CORE_STATUS,
+			       IWM_SRC_UMAC, WAIT_NOTIF_TIMEOUT);
+		if (ret) {
+			IWM_ERR(iwm, "Didn't get a core status notification\n");
+			goto err_fw;
+		}
+
+		if (iwm->core_enabled != (UMAC_NTFY_WIFI_CORE_STATUS_LINK_EN |
+					  UMAC_NTFY_WIFI_CORE_STATUS_MLME_EN)) {
+			IWM_ERR(iwm, "Not all cores enabled: 0x%x\n",
+				iwm->core_enabled);
+			goto err_fw;
+		} else {
+			IWM_INFO(iwm, "All cores enabled\n");
+		}
+	}
+
+	iwm->umac_profile = kmalloc(sizeof(struct iwm_umac_profile),
+				    GFP_KERNEL);
+	if (!iwm->umac_profile) {
+		IWM_ERR(iwm, "Couldn't alloc memory for profile\n");
+		goto err_fw;
+	}
+
+	iwm_init_default_profile(iwm, iwm->umac_profile);
+
+	ret = iwm_channels_init(iwm);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't init channels\n");
+		goto err_profile;
+	}
+
+	/* Set the READY bit to indicate interface is brought up successfully */
+	set_bit(IWM_STATUS_READY, &iwm->status);
+
+	return 0;
+
+ err_profile:
+	kfree(iwm->umac_profile);
+	iwm->umac_profile = NULL;
+
+ err_fw:
+	iwm_eeprom_exit(iwm);
+
+ err_disable:
+	ret = iwm_bus_disable(iwm);
+	if (ret < 0)
+		IWM_ERR(iwm, "Couldn't disable function\n");
+
+	return -EIO;
+}
+
+int iwm_down(struct iwm_priv *iwm)
+{
+	int ret;
+
+	/* The interface is already down */
+	if (!test_bit(IWM_STATUS_READY, &iwm->status))
+		return 0;
+
+	if (iwm->scan_request) {
+		cfg80211_scan_done(iwm->scan_request, true);
+		iwm->scan_request = NULL;
+	}
+
+	clear_bit(IWM_STATUS_READY, &iwm->status);
+
+	iwm_eeprom_exit(iwm);
+	kfree(iwm->umac_profile);
+	iwm->umac_profile = NULL;
+	iwm_bss_list_clean(iwm);
+
+	iwm->default_key = NULL;
+	iwm->core_enabled = 0;
+
+	ret = iwm_bus_disable(iwm);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't disable function\n");
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
new file mode 100644
index 0000000..eec7201
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -0,0 +1,172 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+/*
+ * This is the netdev related hooks for iwm.
+ *
+ * Some interesting code paths:
+ *
+ * iwm_open() (Called at netdev interface bringup time)
+ *  -> iwm_up() (main.c)
+ *      -> iwm_bus_enable()
+ *          -> if_sdio_enable() (In case of an SDIO bus)
+ *              -> sdio_enable_func()
+ *      -> iwm_notif_wait(BARKER_REBOOT) (wait for reboot barker)
+ *      -> iwm_notif_wait(ACK_BARKER) (wait for ACK barker)
+ *      -> iwm_load_fw() (fw.c)
+ *          -> iwm_load_umac()
+ *          -> iwm_load_lmac() (Calibration LMAC)
+ *          -> iwm_load_lmac() (Operational LMAC)
+ *      -> iwm_send_umac_config()
+ *
+ * iwm_stop() (Called at netdev interface bringdown time)
+ *  -> iwm_down()
+ *      -> iwm_bus_disable()
+ *          -> if_sdio_disable() (In case of an SDIO bus)
+ *              -> sdio_disable_func()
+ */
+#include <linux/netdevice.h>
+
+#include "iwm.h"
+#include "cfg80211.h"
+#include "debug.h"
+
+static int iwm_open(struct net_device *ndev)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(ndev);
+	int ret = 0;
+
+	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
+		ret = iwm_up(iwm);
+
+	return ret;
+}
+
+static int iwm_stop(struct net_device *ndev)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(ndev);
+	int ret = 0;
+
+	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
+		ret = iwm_down(iwm);
+
+	return ret;
+}
+
+/*
+ * iwm AC to queue mapping
+ *
+ * AC_VO -> queue 3
+ * AC_VI -> queue 2
+ * AC_BE -> queue 1
+ * AC_BK -> queue 0
+ */
+static const u16 iwm_1d_to_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
+
+static u16 iwm_select_queue(struct net_device *dev, struct sk_buff *skb)
+{
+	skb->priority = cfg80211_classify8021d(skb);
+
+	return iwm_1d_to_queue[skb->priority];
+}
+
+static const struct net_device_ops iwm_netdev_ops = {
+	.ndo_open		= iwm_open,
+	.ndo_stop		= iwm_stop,
+	.ndo_start_xmit		= iwm_xmit_frame,
+	.ndo_select_queue	= iwm_select_queue,
+};
+
+void *iwm_if_alloc(int sizeof_bus, struct device *dev,
+		   struct iwm_if_ops *if_ops)
+{
+	struct net_device *ndev;
+	struct wireless_dev *wdev;
+	struct iwm_priv *iwm;
+	int ret = 0;
+
+	wdev = iwm_wdev_alloc(sizeof_bus, dev);
+	if (!wdev) {
+		dev_err(dev, "no memory for wireless device instance\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	iwm = wdev_to_iwm(wdev);
+	iwm->bus_ops = if_ops;
+	iwm->wdev = wdev;
+	iwm_priv_init(iwm);
+	wdev->iftype = iwm_mode_to_nl80211_iftype(iwm->conf.mode);
+
+	ndev = alloc_netdev_mq(0, "wlan%d", ether_setup,
+			       IWM_TX_QUEUES);
+	if (!ndev) {
+		dev_err(dev, "no memory for network device instance\n");
+		goto out_wdev;
+	}
+
+	ndev->netdev_ops = &iwm_netdev_ops;
+	ndev->wireless_handlers = &iwm_iw_handler_def;
+	ndev->ieee80211_ptr = wdev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
+	ret = register_netdev(ndev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to register netdev: %d\n", ret);
+		goto out_ndev;
+	}
+
+	wdev->netdev = ndev;
+
+	ret = iwm_rfkill_init(iwm);
+	if (ret) {
+		dev_err(dev, "Failed to init rfkill\n");
+		goto out_rfkill;
+	}
+
+	return iwm;
+
+ out_rfkill:
+	unregister_netdev(ndev);
+
+ out_ndev:
+	free_netdev(ndev);
+
+ out_wdev:
+	iwm_wdev_free(iwm);
+	return ERR_PTR(ret);
+}
+
+void iwm_if_free(struct iwm_priv *iwm)
+{
+	int i;
+
+	if (!iwm_to_ndev(iwm))
+		return;
+
+	iwm_rfkill_exit(iwm);
+	unregister_netdev(iwm_to_ndev(iwm));
+	free_netdev(iwm_to_ndev(iwm));
+	iwm_wdev_free(iwm);
+	destroy_workqueue(iwm->rx_wq);
+	for (i = 0; i < IWM_TX_QUEUES; i++)
+		destroy_workqueue(iwm->txq[i].wq);
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/rfkill.c b/drivers/net/wireless/iwmc3200wifi/rfkill.c
new file mode 100644
index 0000000..4ca8b49
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/rfkill.c
@@ -0,0 +1,88 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/rfkill.h>
+
+#include "iwm.h"
+
+static int iwm_rfkill_soft_toggle(void *data, enum rfkill_state state)
+{
+	struct iwm_priv *iwm = data;
+
+	switch (state) {
+	case RFKILL_STATE_UNBLOCKED:
+		if (test_bit(IWM_RADIO_RFKILL_HW, &iwm->radio))
+			return -EBUSY;
+
+		if (test_and_clear_bit(IWM_RADIO_RFKILL_SW, &iwm->radio) &&
+		    (iwm_to_ndev(iwm)->flags & IFF_UP))
+			iwm_up(iwm);
+
+		break;
+	case RFKILL_STATE_SOFT_BLOCKED:
+		if (!test_and_set_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
+			iwm_down(iwm);
+
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+int iwm_rfkill_init(struct iwm_priv *iwm)
+{
+	int ret;
+
+	iwm->rfkill = rfkill_allocate(iwm_to_dev(iwm), RFKILL_TYPE_WLAN);
+	if (!iwm->rfkill) {
+		IWM_ERR(iwm, "Unable to allocate rfkill device\n");
+		return -ENOMEM;
+	}
+
+	iwm->rfkill->name = KBUILD_MODNAME;
+	iwm->rfkill->data = iwm;
+	iwm->rfkill->state = RFKILL_STATE_UNBLOCKED;
+	iwm->rfkill->toggle_radio = iwm_rfkill_soft_toggle;
+
+	ret = rfkill_register(iwm->rfkill);
+	if (ret) {
+		IWM_ERR(iwm, "Failed to register rfkill device\n");
+		goto fail;
+	}
+
+	return 0;
+ fail:
+	rfkill_free(iwm->rfkill);
+	return ret;
+}
+
+void iwm_rfkill_exit(struct iwm_priv *iwm)
+{
+	if (iwm->rfkill)
+		rfkill_unregister(iwm->rfkill);
+
+	rfkill_free(iwm->rfkill);
+	iwm->rfkill = NULL;
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
new file mode 100644
index 0000000..d73cf96
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -0,0 +1,1431 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/wireless.h>
+#include <linux/ieee80211.h>
+#include <linux/if_arp.h>
+#include <linux/list.h>
+#include <net/iw_handler.h>
+
+#include "iwm.h"
+#include "debug.h"
+#include "hal.h"
+#include "umac.h"
+#include "lmac.h"
+#include "commands.h"
+#include "rx.h"
+#include "cfg80211.h"
+#include "eeprom.h"
+
+static int iwm_rx_check_udma_hdr(struct iwm_udma_in_hdr *hdr)
+{
+	if ((le32_to_cpu(hdr->cmd) == UMAC_PAD_TERMINAL) ||
+	    (le32_to_cpu(hdr->size) == UMAC_PAD_TERMINAL))
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline int iwm_rx_resp_size(struct iwm_udma_in_hdr *hdr)
+{
+	return ALIGN(le32_to_cpu(hdr->size) + sizeof(struct iwm_udma_in_hdr),
+		     16);
+}
+
+/*
+ * Notification handlers:
+ *
+ * For every possible notification we can receive from the
+ * target, we have a handler.
+ * When we get a target notification, and there is no one
+ * waiting for it, it's just processed through the rx code
+ * path:
+ *
+ * iwm_rx_handle()
+ *  -> iwm_rx_handle_umac()
+ *      -> iwm_rx_handle_wifi()
+ *          -> iwm_rx_handle_resp()
+ *              -> iwm_ntf_*()
+ *
+ *      OR
+ *
+ *      -> iwm_rx_handle_non_wifi()
+ *
+ * If there are processes waiting for this notification, then
+ * iwm_rx_handle_wifi() just wakes those processes up and they
+ * grab the pending notification.
+ */
+static int iwm_ntf_error(struct iwm_priv *iwm, u8 *buf,
+			 unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_error *error;
+	struct iwm_fw_error_hdr *fw_err;
+
+	error = (struct iwm_umac_notif_error *)buf;
+	fw_err = &error->err;
+
+
+	IWM_ERR(iwm, "%cMAC FW ERROR:\n",
+	 (le32_to_cpu(fw_err->category) == UMAC_SYS_ERR_CAT_LMAC) ? 'L' : 'U');
+	IWM_ERR(iwm, "\tCategory:    %d\n", le32_to_cpu(fw_err->category));
+	IWM_ERR(iwm, "\tStatus:      0x%x\n", le32_to_cpu(fw_err->status));
+	IWM_ERR(iwm, "\tPC:          0x%x\n", le32_to_cpu(fw_err->pc));
+	IWM_ERR(iwm, "\tblink1:      %d\n", le32_to_cpu(fw_err->blink1));
+	IWM_ERR(iwm, "\tblink2:      %d\n", le32_to_cpu(fw_err->blink2));
+	IWM_ERR(iwm, "\tilink1:      %d\n", le32_to_cpu(fw_err->ilink1));
+	IWM_ERR(iwm, "\tilink2:      %d\n", le32_to_cpu(fw_err->ilink2));
+	IWM_ERR(iwm, "\tData1:       0x%x\n", le32_to_cpu(fw_err->data1));
+	IWM_ERR(iwm, "\tData2:       0x%x\n", le32_to_cpu(fw_err->data2));
+	IWM_ERR(iwm, "\tLine number: %d\n", le32_to_cpu(fw_err->line_num));
+	IWM_ERR(iwm, "\tUMAC status: 0x%x\n", le32_to_cpu(fw_err->umac_status));
+	IWM_ERR(iwm, "\tLMAC status: 0x%x\n", le32_to_cpu(fw_err->lmac_status));
+	IWM_ERR(iwm, "\tSDIO status: 0x%x\n", le32_to_cpu(fw_err->sdio_status));
+
+	return 0;
+}
+
+static int iwm_ntf_umac_alive(struct iwm_priv *iwm, u8 *buf,
+			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_alive *alive_resp =
+			(struct iwm_umac_notif_alive *)(buf);
+	u16 status = le16_to_cpu(alive_resp->status);
+
+	if (status == UMAC_NTFY_ALIVE_STATUS_ERR) {
+		IWM_ERR(iwm, "Receive error UMAC_ALIVE\n");
+		return -EIO;
+	}
+
+	iwm_tx_credit_init_pools(iwm, alive_resp);
+
+	return 0;
+}
+
+static int iwm_ntf_init_complete(struct iwm_priv *iwm, u8 *buf,
+				 unsigned long buf_size,
+				 struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_init_complete *init_complete =
+			(struct iwm_umac_notif_init_complete *)(buf);
+	u16 status = le16_to_cpu(init_complete->status);
+
+	if (status == UMAC_NTFY_INIT_COMPLETE_STATUS_ERR) {
+		IWM_DBG_NTF(iwm, DBG, "Hardware rf kill is on (radio off)\n");
+		set_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
+	} else {
+		IWM_DBG_NTF(iwm, DBG, "Hardware rf kill is off (radio on)\n");
+		clear_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
+	}
+
+	return 0;
+}
+
+static int iwm_ntf_tx_credit_update(struct iwm_priv *iwm, u8 *buf,
+				    unsigned long buf_size,
+				    struct iwm_wifi_cmd *cmd)
+{
+	int pool_nr, total_freed_pages;
+	unsigned long pool_map;
+	int i, id;
+	struct iwm_umac_notif_page_dealloc *dealloc =
+			(struct iwm_umac_notif_page_dealloc *)buf;
+
+	pool_nr = GET_VAL32(dealloc->changes, UMAC_DEALLOC_NTFY_CHANGES_CNT);
+	pool_map = GET_VAL32(dealloc->changes, UMAC_DEALLOC_NTFY_CHANGES_MSK);
+
+	IWM_DBG_TX(iwm, DBG, "UMAC dealloc notification: pool nr %d, "
+		   "update map 0x%lx\n", pool_nr, pool_map);
+
+	spin_lock(&iwm->tx_credit.lock);
+
+	for (i = 0; i < pool_nr; i++) {
+		id = GET_VAL32(dealloc->grp_info[i],
+			       UMAC_DEALLOC_NTFY_GROUP_NUM);
+		if (test_bit(id, &pool_map)) {
+			total_freed_pages = GET_VAL32(dealloc->grp_info[i],
+					      UMAC_DEALLOC_NTFY_PAGE_CNT);
+			iwm_tx_credit_inc(iwm, id, total_freed_pages);
+		}
+	}
+
+	spin_unlock(&iwm->tx_credit.lock);
+
+	return 0;
+}
+
+static int iwm_ntf_umac_reset(struct iwm_priv *iwm, u8 *buf,
+			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	IWM_DBG_NTF(iwm, DBG, "UMAC RESET done\n");
+
+	return 0;
+}
+
+static int iwm_ntf_lmac_version(struct iwm_priv *iwm, u8 *buf,
+				unsigned long buf_size,
+				struct iwm_wifi_cmd *cmd)
+{
+	IWM_DBG_NTF(iwm, INFO, "LMAC Version: %x.%x\n", buf[9], buf[8]);
+
+	return 0;
+}
+
+static int iwm_ntf_tx(struct iwm_priv *iwm, u8 *buf,
+		      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_lmac_tx_resp *tx_resp;
+	struct iwm_umac_wifi_in_hdr *hdr;
+
+	tx_resp = (struct iwm_lmac_tx_resp *)
+		(buf + sizeof(struct iwm_umac_wifi_in_hdr));
+	hdr = (struct iwm_umac_wifi_in_hdr *)buf;
+
+	IWM_DBG_NTF(iwm, DBG, "REPLY_TX, buf size: %lu\n", buf_size);
+
+	IWM_DBG_NTF(iwm, DBG, "Seqnum: %d\n",
+		    le16_to_cpu(hdr->sw_hdr.cmd.seq_num));
+	IWM_DBG_NTF(iwm, DBG, "\tFrame cnt: %d\n", tx_resp->frame_cnt);
+	IWM_DBG_NTF(iwm, DBG, "\tRetry cnt: %d\n",
+		    le16_to_cpu(tx_resp->retry_cnt));
+	IWM_DBG_NTF(iwm, DBG, "\tSeq ctl: %d\n", le16_to_cpu(tx_resp->seq_ctl));
+	IWM_DBG_NTF(iwm, DBG, "\tByte cnt: %d\n",
+		    le16_to_cpu(tx_resp->byte_cnt));
+	IWM_DBG_NTF(iwm, DBG, "\tStatus: 0x%x\n", le32_to_cpu(tx_resp->status));
+
+	return 0;
+}
+
+
+static int iwm_ntf_calib_res(struct iwm_priv *iwm, u8 *buf,
+			     unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	u8 opcode;
+	u8 *calib_buf;
+	struct iwm_lmac_calib_hdr *hdr = (struct iwm_lmac_calib_hdr *)
+				(buf + sizeof(struct iwm_umac_wifi_in_hdr));
+
+	opcode = hdr->opcode;
+
+	BUG_ON(opcode >= CALIBRATION_CMD_NUM ||
+	       opcode < PHY_CALIBRATE_OPCODES_NUM);
+
+	IWM_DBG_NTF(iwm, DBG, "Store calibration result for opcode: %d\n",
+		    opcode);
+
+	buf_size -= sizeof(struct iwm_umac_wifi_in_hdr);
+	calib_buf = iwm->calib_res[opcode].buf;
+
+	if (!calib_buf || (iwm->calib_res[opcode].size < buf_size)) {
+		kfree(calib_buf);
+		calib_buf = kzalloc(buf_size, GFP_KERNEL);
+		if (!calib_buf) {
+			IWM_ERR(iwm, "Memory allocation failed: calib_res\n");
+			return -ENOMEM;
+		}
+		iwm->calib_res[opcode].buf = calib_buf;
+		iwm->calib_res[opcode].size = buf_size;
+	}
+
+	memcpy(calib_buf, hdr, buf_size);
+	set_bit(opcode - PHY_CALIBRATE_OPCODES_NUM, &iwm->calib_done_map);
+
+	return 0;
+}
+
+static int iwm_ntf_calib_complete(struct iwm_priv *iwm, u8 *buf,
+				  unsigned long buf_size,
+				  struct iwm_wifi_cmd *cmd)
+{
+	IWM_DBG_NTF(iwm, DBG, "Calibration completed\n");
+
+	return 0;
+}
+
+static int iwm_ntf_calib_cfg(struct iwm_priv *iwm, u8 *buf,
+			     unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_lmac_cal_cfg_resp *cal_resp;
+
+	cal_resp = (struct iwm_lmac_cal_cfg_resp *)
+			(buf + sizeof(struct iwm_umac_wifi_in_hdr));
+
+	IWM_DBG_NTF(iwm, DBG, "Calibration CFG command status: %d\n",
+		    le32_to_cpu(cal_resp->status));
+
+	return 0;
+}
+
+static int iwm_ntf_wifi_status(struct iwm_priv *iwm, u8 *buf,
+			       unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_wifi_status *status =
+		(struct iwm_umac_notif_wifi_status *)buf;
+
+	iwm->core_enabled |= le16_to_cpu(status->status);
+
+	return 0;
+}
+
+static struct iwm_rx_ticket_node *
+iwm_rx_ticket_node_alloc(struct iwm_priv *iwm, struct iwm_rx_ticket *ticket)
+{
+	struct iwm_rx_ticket_node *ticket_node;
+
+	ticket_node = kzalloc(sizeof(struct iwm_rx_ticket_node), GFP_KERNEL);
+	if (!ticket_node) {
+		IWM_ERR(iwm, "Couldn't allocate ticket node\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ticket_node->ticket = kzalloc(sizeof(struct iwm_rx_ticket), GFP_KERNEL);
+	if (!ticket_node->ticket) {
+		IWM_ERR(iwm, "Couldn't allocate RX ticket\n");
+		kfree(ticket_node);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	memcpy(ticket_node->ticket, ticket, sizeof(struct iwm_rx_ticket));
+	INIT_LIST_HEAD(&ticket_node->node);
+
+	return ticket_node;
+}
+
+static void iwm_rx_ticket_node_free(struct iwm_rx_ticket_node *ticket_node)
+{
+	kfree(ticket_node->ticket);
+	kfree(ticket_node);
+}
+
+static struct iwm_rx_packet *iwm_rx_packet_get(struct iwm_priv *iwm, u16 id)
+{
+	u8 id_hash = IWM_RX_ID_GET_HASH(id);
+	struct list_head *packet_list;
+	struct iwm_rx_packet *packet, *next;
+
+	packet_list = &iwm->rx_packets[id_hash];
+
+	list_for_each_entry_safe(packet, next, packet_list, node)
+		if (packet->id == id)
+			return packet;
+
+	return NULL;
+}
+
+static struct iwm_rx_packet *iwm_rx_packet_alloc(struct iwm_priv *iwm, u8 *buf,
+						 u32 size, u16 id)
+{
+	struct iwm_rx_packet *packet;
+
+	packet = kzalloc(sizeof(struct iwm_rx_packet), GFP_KERNEL);
+	if (!packet) {
+		IWM_ERR(iwm, "Couldn't allocate packet\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	packet->skb = dev_alloc_skb(size);
+	if (!packet->skb) {
+		IWM_ERR(iwm, "Couldn't allocate packet SKB\n");
+		kfree(packet);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	packet->pkt_size = size;
+
+	skb_put(packet->skb, size);
+	memcpy(packet->skb->data, buf, size);
+	INIT_LIST_HEAD(&packet->node);
+	packet->id = id;
+
+	return packet;
+}
+
+void iwm_rx_free(struct iwm_priv *iwm)
+{
+	struct iwm_rx_ticket_node *ticket, *nt;
+	struct iwm_rx_packet *packet, *np;
+	int i;
+
+	list_for_each_entry_safe(ticket, nt, &iwm->rx_tickets, node) {
+		list_del(&ticket->node);
+		iwm_rx_ticket_node_free(ticket);
+	}
+
+	for (i = 0; i < IWM_RX_ID_HASH; i++) {
+		list_for_each_entry_safe(packet, np, &iwm->rx_packets[i],
+					 node) {
+			list_del(&packet->node);
+			kfree_skb(packet->skb);
+			kfree(packet);
+		}
+	}
+}
+
+static int iwm_ntf_rx_ticket(struct iwm_priv *iwm, u8 *buf,
+			     unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_rx_ticket *ntf_rx_ticket =
+		(struct iwm_umac_notif_rx_ticket *)buf;
+	struct iwm_rx_ticket *ticket =
+		(struct iwm_rx_ticket *)ntf_rx_ticket->tickets;
+	int i, schedule_rx = 0;
+
+	for (i = 0; i < ntf_rx_ticket->num_tickets; i++) {
+		struct iwm_rx_ticket_node *ticket_node;
+
+		switch (le16_to_cpu(ticket->action)) {
+		case IWM_RX_TICKET_RELEASE:
+		case IWM_RX_TICKET_DROP:
+			/* We can push the packet to the stack */
+			ticket_node = iwm_rx_ticket_node_alloc(iwm, ticket);
+			if (IS_ERR(ticket_node))
+				return PTR_ERR(ticket_node);
+
+			IWM_DBG_NTF(iwm, DBG, "TICKET RELEASE(%d)\n",
+				    ticket->id);
+			list_add_tail(&ticket_node->node, &iwm->rx_tickets);
+
+			/*
+			 * We received an Rx ticket, most likely there's
+			 * a packet pending for it, it's not worth going
+			 * through the packet hash list to double check.
+			 * Let's just fire the rx worker..
+			 */
+			schedule_rx = 1;
+
+			break;
+
+		default:
+			IWM_ERR(iwm, "Invalid RX ticket action: 0x%x\n",
+				ticket->action);
+		}
+
+		ticket++;
+	}
+
+	if (schedule_rx)
+		queue_work(iwm->rx_wq, &iwm->rx_worker);
+
+	return 0;
+}
+
+static int iwm_ntf_rx_packet(struct iwm_priv *iwm, u8 *buf,
+			     unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_wifi_in_hdr *wifi_hdr;
+	struct iwm_rx_packet *packet;
+	u16 id, buf_offset;
+	u32 packet_size;
+
+	IWM_DBG_NTF(iwm, DBG, "\n");
+
+	wifi_hdr = (struct iwm_umac_wifi_in_hdr *)buf;
+	id = le16_to_cpu(wifi_hdr->sw_hdr.cmd.seq_num);
+	buf_offset = sizeof(struct iwm_umac_wifi_in_hdr);
+	packet_size = buf_size - sizeof(struct iwm_umac_wifi_in_hdr);
+
+	IWM_DBG_NTF(iwm, DBG, "CMD:0x%x, seqnum: %d, packet size: %d\n",
+		    wifi_hdr->sw_hdr.cmd.cmd, id, packet_size);
+	IWM_DBG_RX(iwm, DBG, "Packet id: %d\n", id);
+	IWM_HEXDUMP(iwm, DBG, RX, "PACKET: ", buf + buf_offset, packet_size);
+
+	packet = iwm_rx_packet_alloc(iwm, buf + buf_offset, packet_size, id);
+	if (IS_ERR(packet))
+		return PTR_ERR(packet);
+
+	list_add_tail(&packet->node, &iwm->rx_packets[IWM_RX_ID_GET_HASH(id)]);
+
+	/* We might (unlikely) have received the packet _after_ the ticket */
+	queue_work(iwm->rx_wq, &iwm->rx_worker);
+
+	return 0;
+}
+
+/* MLME handlers */
+static int iwm_mlme_assoc_start(struct iwm_priv *iwm, u8 *buf,
+				unsigned long buf_size,
+				struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_assoc_start *start;
+
+	start = (struct iwm_umac_notif_assoc_start *)buf;
+
+	set_bit(IWM_STATUS_ASSOCIATING, &iwm->status);
+
+	IWM_DBG_MLME(iwm, INFO, "Association with %pM Started, reason: %d\n",
+		     start->bssid, le32_to_cpu(start->roam_reason));
+
+	wake_up_interruptible(&iwm->mlme_queue);
+
+	return 0;
+}
+
+static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
+				   unsigned long buf_size,
+				   struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_assoc_complete *complete =
+		(struct iwm_umac_notif_assoc_complete *)buf;
+	union iwreq_data wrqu;
+
+	IWM_DBG_MLME(iwm, INFO, "Association with %pM completed, status: %d\n",
+		     complete->bssid, complete->status);
+
+	memset(&wrqu, 0, sizeof(wrqu));
+
+	clear_bit(IWM_STATUS_ASSOCIATING, &iwm->status);
+
+	switch (le32_to_cpu(complete->status)) {
+	case UMAC_ASSOC_COMPLETE_SUCCESS:
+		set_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
+		memcpy(iwm->bssid, complete->bssid, ETH_ALEN);
+		iwm->channel = complete->channel;
+
+		iwm_link_on(iwm);
+
+		memcpy(wrqu.ap_addr.sa_data, complete->bssid, ETH_ALEN);
+		break;
+	case UMAC_ASSOC_COMPLETE_FAILURE:
+		clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
+		memset(iwm->bssid, 0, ETH_ALEN);
+		iwm->channel = 0;
+
+		iwm_link_off(iwm);
+	default:
+		break;
+	}
+
+	if (iwm->conf.mode == UMAC_MODE_IBSS) {
+		cfg80211_ibss_joined(iwm_to_ndev(iwm), iwm->bssid, GFP_KERNEL);
+		return 0;
+	}
+
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(iwm_to_ndev(iwm), SIOCGIWAP, &wrqu, NULL);
+
+	return 0;
+}
+
+static int iwm_mlme_profile_invalidate(struct iwm_priv *iwm, u8 *buf,
+				       unsigned long buf_size,
+				       struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_profile_invalidate *invalid;
+
+	invalid = (struct iwm_umac_notif_profile_invalidate *)buf;
+
+	IWM_DBG_MLME(iwm, INFO, "Profile Invalidated. Reason: %d\n",
+		     le32_to_cpu(invalid->reason));
+
+	clear_bit(IWM_STATUS_ASSOCIATING, &iwm->status);
+	clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
+
+	iwm->umac_profile_active = 0;
+	memset(iwm->bssid, 0, ETH_ALEN);
+	iwm->channel = 0;
+
+	iwm_link_off(iwm);
+
+	wake_up_interruptible(&iwm->mlme_queue);
+
+	return 0;
+}
+
+static int iwm_mlme_scan_complete(struct iwm_priv *iwm, u8 *buf,
+				  unsigned long buf_size,
+				  struct iwm_wifi_cmd *cmd)
+{
+	int ret;
+	struct iwm_umac_notif_scan_complete *scan_complete =
+		(struct iwm_umac_notif_scan_complete *)buf;
+	u32 result = le32_to_cpu(scan_complete->result);
+
+	IWM_DBG_MLME(iwm, INFO, "type:0x%x result:0x%x seq:%d\n",
+		     le32_to_cpu(scan_complete->type),
+		     le32_to_cpu(scan_complete->result),
+		     scan_complete->seq_num);
+
+	if (!test_and_clear_bit(IWM_STATUS_SCANNING, &iwm->status)) {
+		IWM_ERR(iwm, "Scan complete while device not scanning\n");
+		return -EIO;
+	}
+	if (!iwm->scan_request)
+		return 0;
+
+	ret = iwm_cfg80211_inform_bss(iwm);
+
+	cfg80211_scan_done(iwm->scan_request,
+			   (result & UMAC_SCAN_RESULT_ABORTED) ? 1 : !!ret);
+	iwm->scan_request = NULL;
+
+	return ret;
+}
+
+static int iwm_mlme_update_sta_table(struct iwm_priv *iwm, u8 *buf,
+				     unsigned long buf_size,
+				     struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_sta_info *umac_sta =
+			(struct iwm_umac_notif_sta_info *)buf;
+	struct iwm_sta_info *sta;
+	int i;
+
+	switch (le32_to_cpu(umac_sta->opcode)) {
+	case UMAC_OPCODE_ADD_MODIFY:
+		sta = &iwm->sta_table[GET_VAL8(umac_sta->sta_id, LMAC_STA_ID)];
+
+		IWM_DBG_MLME(iwm, INFO, "%s STA: ID = %d, Color = %d, "
+			     "addr = %pM, qos = %d\n",
+			     sta->valid ? "Modify" : "Add",
+			     GET_VAL8(umac_sta->sta_id, LMAC_STA_ID),
+			     GET_VAL8(umac_sta->sta_id, LMAC_STA_COLOR),
+			     umac_sta->mac_addr,
+			     umac_sta->flags & UMAC_STA_FLAG_QOS);
+
+		sta->valid = 1;
+		sta->qos = umac_sta->flags & UMAC_STA_FLAG_QOS;
+		sta->color = GET_VAL8(umac_sta->sta_id, LMAC_STA_COLOR);
+		memcpy(sta->addr, umac_sta->mac_addr, ETH_ALEN);
+		break;
+	case UMAC_OPCODE_REMOVE:
+		IWM_DBG_MLME(iwm, INFO, "Remove STA: ID = %d, Color = %d, "
+			     "addr = %pM\n",
+			     GET_VAL8(umac_sta->sta_id, LMAC_STA_ID),
+			     GET_VAL8(umac_sta->sta_id, LMAC_STA_COLOR),
+			     umac_sta->mac_addr);
+
+		sta = &iwm->sta_table[GET_VAL8(umac_sta->sta_id, LMAC_STA_ID)];
+
+		if (!memcmp(sta->addr, umac_sta->mac_addr, ETH_ALEN))
+			sta->valid = 0;
+
+		break;
+	case UMAC_OPCODE_CLEAR_ALL:
+		for (i = 0; i < IWM_STA_TABLE_NUM; i++)
+			iwm->sta_table[i].valid = 0;
+
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int iwm_mlme_update_bss_table(struct iwm_priv *iwm, u8 *buf,
+				     unsigned long buf_size,
+				     struct iwm_wifi_cmd *cmd)
+{
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+	struct ieee80211_mgmt *mgmt;
+	struct iwm_umac_notif_bss_info *umac_bss =
+			(struct iwm_umac_notif_bss_info *)buf;
+	struct ieee80211_channel *channel;
+	struct ieee80211_supported_band *band;
+	struct iwm_bss_info *bss, *next;
+	s32 signal;
+	int freq;
+	u16 frame_len = le16_to_cpu(umac_bss->frame_len);
+	size_t bss_len = sizeof(struct iwm_umac_notif_bss_info) + frame_len;
+
+	mgmt = (struct ieee80211_mgmt *)(umac_bss->frame_buf);
+
+	IWM_DBG_MLME(iwm, DBG, "New BSS info entry: %pM\n", mgmt->bssid);
+	IWM_DBG_MLME(iwm, DBG, "\tType: 0x%x\n", le32_to_cpu(umac_bss->type));
+	IWM_DBG_MLME(iwm, DBG, "\tTimestamp: %d\n",
+		     le32_to_cpu(umac_bss->timestamp));
+	IWM_DBG_MLME(iwm, DBG, "\tTable Index: %d\n",
+		     le16_to_cpu(umac_bss->table_idx));
+	IWM_DBG_MLME(iwm, DBG, "\tBand: %d\n", umac_bss->band);
+	IWM_DBG_MLME(iwm, DBG, "\tChannel: %d\n", umac_bss->channel);
+	IWM_DBG_MLME(iwm, DBG, "\tRSSI: %d\n", umac_bss->rssi);
+	IWM_DBG_MLME(iwm, DBG, "\tFrame Length: %d\n", frame_len);
+
+	list_for_each_entry_safe(bss, next, &iwm->bss_list, node)
+		if (bss->bss->table_idx == umac_bss->table_idx)
+			break;
+
+	if (&bss->node != &iwm->bss_list) {
+		/* Remove the old BSS entry, we will add it back later. */
+		list_del(&bss->node);
+		kfree(bss->bss);
+	} else {
+		/* New BSS entry */
+
+		bss = kzalloc(sizeof(struct iwm_bss_info), GFP_KERNEL);
+		if (!bss) {
+			IWM_ERR(iwm, "Couldn't allocate bss_info\n");
+			return -ENOMEM;
+		}
+	}
+
+	bss->bss = kzalloc(bss_len, GFP_KERNEL);
+	if (!bss) {
+		kfree(bss);
+		IWM_ERR(iwm, "Couldn't allocate bss\n");
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&bss->node);
+	memcpy(bss->bss, umac_bss, bss_len);
+
+	if (umac_bss->band == UMAC_BAND_2GHZ)
+		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+	else if (umac_bss->band == UMAC_BAND_5GHZ)
+		band = wiphy->bands[IEEE80211_BAND_5GHZ];
+	else {
+		IWM_ERR(iwm, "Invalid band: %d\n", umac_bss->band);
+		goto err;
+	}
+
+	freq = ieee80211_channel_to_frequency(umac_bss->channel);
+	channel = ieee80211_get_channel(wiphy, freq);
+	signal = umac_bss->rssi * 100;
+
+	bss->cfg_bss = cfg80211_inform_bss_frame(wiphy, channel,
+						 mgmt, frame_len,
+						 signal, GFP_KERNEL);
+	if (!bss->cfg_bss)
+		goto err;
+
+	list_add_tail(&bss->node, &iwm->bss_list);
+
+	return 0;
+ err:
+	kfree(bss->bss);
+	kfree(bss);
+
+	return -EINVAL;
+}
+
+static int iwm_mlme_remove_bss(struct iwm_priv *iwm, u8 *buf,
+			       unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_bss_removed *bss_rm =
+		(struct iwm_umac_notif_bss_removed *)buf;
+	struct iwm_bss_info *bss, *next;
+	u16 table_idx;
+	int i;
+
+	for (i = 0; i < le32_to_cpu(bss_rm->count); i++) {
+		table_idx = (le16_to_cpu(bss_rm->entries[i])
+			     & IWM_BSS_REMOVE_INDEX_MSK);
+		list_for_each_entry_safe(bss, next, &iwm->bss_list, node)
+			if (bss->bss->table_idx == cpu_to_le16(table_idx)) {
+				struct ieee80211_mgmt *mgmt;
+
+				mgmt = (struct ieee80211_mgmt *)
+					(bss->bss->frame_buf);
+				IWM_DBG_MLME(iwm, ERR,
+					     "BSS removed: %pM\n",
+					     mgmt->bssid);
+				list_del(&bss->node);
+				kfree(bss->bss);
+				kfree(bss);
+			}
+	}
+
+	return 0;
+}
+
+static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
+			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_mgt_frame *mgt_frame =
+	(struct iwm_umac_notif_mgt_frame *)buf;
+	struct ieee80211_mgmt *mgt = (struct ieee80211_mgmt *)mgt_frame->frame;
+	u8 *ie;
+	unsigned int event;
+	union iwreq_data wrqu;
+
+	IWM_HEXDUMP(iwm, DBG, MLME, "MGT: ", mgt_frame->frame,
+		    le16_to_cpu(mgt_frame->len));
+
+	if (ieee80211_is_assoc_req(mgt->frame_control)) {
+		ie = mgt->u.assoc_req.variable;;
+		event = IWEVASSOCREQIE;
+	} else if (ieee80211_is_reassoc_req(mgt->frame_control)) {
+		ie = mgt->u.reassoc_req.variable;;
+		event = IWEVASSOCREQIE;
+	} else if (ieee80211_is_assoc_resp(mgt->frame_control)) {
+		ie = mgt->u.assoc_resp.variable;;
+		event = IWEVASSOCRESPIE;
+	} else if (ieee80211_is_reassoc_resp(mgt->frame_control)) {
+		ie = mgt->u.reassoc_resp.variable;;
+		event = IWEVASSOCRESPIE;
+	} else {
+		IWM_ERR(iwm, "Unsupported management frame");
+		return 0;
+	}
+
+	wrqu.data.length = le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+
+	IWM_HEXDUMP(iwm, DBG, MLME, "EVT: ", ie, wrqu.data.length);
+	wireless_send_event(iwm_to_ndev(iwm), event, &wrqu, ie);
+
+	return 0;
+}
+
+static int iwm_ntf_mlme(struct iwm_priv *iwm, u8 *buf,
+			unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_wifi_if *notif =
+		(struct iwm_umac_notif_wifi_if *)buf;
+
+	switch (notif->status) {
+	case WIFI_IF_NTFY_ASSOC_START:
+		return iwm_mlme_assoc_start(iwm, buf, buf_size, cmd);
+	case WIFI_IF_NTFY_ASSOC_COMPLETE:
+		return iwm_mlme_assoc_complete(iwm, buf, buf_size, cmd);
+	case WIFI_IF_NTFY_PROFILE_INVALIDATE_COMPLETE:
+		return iwm_mlme_profile_invalidate(iwm, buf, buf_size, cmd);
+	case WIFI_IF_NTFY_CONNECTION_TERMINATED:
+		IWM_DBG_MLME(iwm, DBG, "Connection terminated\n");
+		break;
+	case WIFI_IF_NTFY_SCAN_COMPLETE:
+		return iwm_mlme_scan_complete(iwm, buf, buf_size, cmd);
+	case WIFI_IF_NTFY_STA_TABLE_CHANGE:
+		return iwm_mlme_update_sta_table(iwm, buf, buf_size, cmd);
+	case WIFI_IF_NTFY_EXTENDED_IE_REQUIRED:
+		IWM_DBG_MLME(iwm, DBG, "Extended IE required\n");
+		break;
+	case WIFI_IF_NTFY_BSS_TRK_TABLE_CHANGED:
+		return iwm_mlme_update_bss_table(iwm, buf, buf_size, cmd);
+	case WIFI_IF_NTFY_BSS_TRK_ENTRIES_REMOVED:
+		return iwm_mlme_remove_bss(iwm, buf, buf_size, cmd);
+		break;
+	case WIFI_IF_NTFY_MGMT_FRAME:
+		return iwm_mlme_mgt_frame(iwm, buf, buf_size, cmd);
+	case WIFI_DBG_IF_NTFY_SCAN_SUPER_JOB_START:
+	case WIFI_DBG_IF_NTFY_SCAN_SUPER_JOB_COMPLETE:
+	case WIFI_DBG_IF_NTFY_SCAN_CHANNEL_START:
+	case WIFI_DBG_IF_NTFY_SCAN_CHANNEL_RESULT:
+	case WIFI_DBG_IF_NTFY_SCAN_MINI_JOB_START:
+	case WIFI_DBG_IF_NTFY_SCAN_MINI_JOB_COMPLETE:
+	case WIFI_DBG_IF_NTFY_CNCT_ATC_START:
+	case WIFI_DBG_IF_NTFY_COEX_NOTIFICATION:
+	case WIFI_DBG_IF_NTFY_COEX_HANDLE_ENVELOP:
+	case WIFI_DBG_IF_NTFY_COEX_HANDLE_RELEASE_ENVELOP:
+		IWM_DBG_MLME(iwm, DBG, "MLME debug notification: 0x%x\n",
+			     notif->status);
+		break;
+	default:
+		IWM_ERR(iwm, "Unhandled notification: 0x%x\n", notif->status);
+		break;
+	}
+
+	return 0;
+}
+
+#define IWM_STATS_UPDATE_INTERVAL		(2 * HZ)
+
+static int iwm_ntf_statistics(struct iwm_priv *iwm, u8 *buf,
+			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_stats *stats = (struct iwm_umac_notif_stats *)buf;
+	struct iw_statistics *wstats = &iwm->wstats;
+	u16 max_rate = 0;
+	int i;
+
+	IWM_DBG_MLME(iwm, DBG, "Statistics notification received\n");
+
+	if (test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
+		for (i = 0; i < UMAC_NTF_RATE_SAMPLE_NR; i++) {
+			max_rate = max_t(u16, max_rate,
+					 max(le16_to_cpu(stats->tx_rate[i]),
+					     le16_to_cpu(stats->rx_rate[i])));
+		}
+		/* UMAC passes rate info multiplies by 2 */
+		iwm->rate = max_rate >> 1;
+	}
+
+	wstats->status = 0;
+
+	wstats->discard.nwid = le32_to_cpu(stats->rx_drop_other_bssid);
+	wstats->discard.code = le32_to_cpu(stats->rx_drop_decode);
+	wstats->discard.fragment = le32_to_cpu(stats->rx_drop_reassembly);
+	wstats->discard.retries = le32_to_cpu(stats->tx_drop_max_retry);
+
+	wstats->miss.beacon = le32_to_cpu(stats->missed_beacons);
+
+	/* according to cfg80211 */
+	if (stats->rssi_dbm < -110)
+		wstats->qual.qual = 0;
+	else if (stats->rssi_dbm > -40)
+		wstats->qual.qual = 70;
+	else
+		wstats->qual.qual = stats->rssi_dbm + 110;
+
+	wstats->qual.level = stats->rssi_dbm;
+	wstats->qual.noise = stats->noise_dbm;
+	wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
+
+	schedule_delayed_work(&iwm->stats_request, IWM_STATS_UPDATE_INTERVAL);
+
+	mod_timer(&iwm->watchdog, round_jiffies(jiffies + IWM_WATCHDOG_PERIOD));
+
+	return 0;
+}
+
+static int iwm_ntf_eeprom_proxy(struct iwm_priv *iwm, u8 *buf,
+				unsigned long buf_size,
+				struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_cmd_eeprom_proxy *eeprom_proxy =
+		(struct iwm_umac_cmd_eeprom_proxy *)
+		(buf + sizeof(struct iwm_umac_wifi_in_hdr));
+	struct iwm_umac_cmd_eeprom_proxy_hdr *hdr = &eeprom_proxy->hdr;
+	u32 hdr_offset = le32_to_cpu(hdr->offset);
+	u32 hdr_len = le32_to_cpu(hdr->len);
+	u32 hdr_type = le32_to_cpu(hdr->type);
+
+	IWM_DBG_NTF(iwm, DBG, "type: 0x%x, len: %d, offset: 0x%x\n",
+		    hdr_type, hdr_len, hdr_offset);
+
+	if ((hdr_offset + hdr_len) > IWM_EEPROM_LEN)
+		return -EINVAL;
+
+#ifdef CONFIG_IWM_B0_HW_SUPPORT
+	if (hdr_offset == IWM_EEPROM_SKU_CAP_OFF) {
+		if (eeprom_proxy->buf[0] == 0xff)
+			iwm->conf.hw_b0 = 1;
+	}
+#endif
+
+	switch (hdr_type) {
+	case IWM_UMAC_CMD_EEPROM_TYPE_READ:
+		memcpy(iwm->eeprom + hdr_offset, eeprom_proxy->buf, hdr_len);
+		break;
+	case IWM_UMAC_CMD_EEPROM_TYPE_WRITE:
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static int iwm_ntf_channel_info_list(struct iwm_priv *iwm, u8 *buf,
+				     unsigned long buf_size,
+				     struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_cmd_get_channel_list *ch_list =
+			(struct iwm_umac_cmd_get_channel_list *)
+			(buf + sizeof(struct iwm_umac_wifi_in_hdr));
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+	struct ieee80211_supported_band *band;
+	int i;
+
+	band = wiphy->bands[IEEE80211_BAND_2GHZ];
+
+	for (i = 0; i < band->n_channels; i++) {
+		unsigned long ch_mask_0 =
+			le32_to_cpu(ch_list->ch[0].channels_mask);
+		unsigned long ch_mask_2 =
+			le32_to_cpu(ch_list->ch[2].channels_mask);
+
+		if (!test_bit(i, &ch_mask_0))
+			band->channels[i].flags |= IEEE80211_CHAN_DISABLED;
+
+		if (!test_bit(i, &ch_mask_2))
+			band->channels[i].flags |= IEEE80211_CHAN_NO_IBSS;
+	}
+
+	band = wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	for (i = 0; i < min(band->n_channels, 32); i++) {
+		unsigned long ch_mask_1 =
+			le32_to_cpu(ch_list->ch[1].channels_mask);
+		unsigned long ch_mask_3 =
+			le32_to_cpu(ch_list->ch[3].channels_mask);
+
+		if (!test_bit(i, &ch_mask_1))
+			band->channels[i].flags |= IEEE80211_CHAN_DISABLED;
+
+		if (!test_bit(i, &ch_mask_3))
+			band->channels[i].flags |= IEEE80211_CHAN_NO_IBSS;
+	}
+
+	return 0;
+}
+
+static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
+				   unsigned long buf_size,
+				   struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_wifi_if *hdr =
+			(struct iwm_umac_wifi_if *)cmd->buf.payload;
+
+	IWM_DBG_NTF(iwm, DBG, "WIFI_IF_WRAPPER cmd is delivered to UMAC: "
+		    "oid is %d\n", hdr->oid);
+
+	switch (hdr->oid) {
+	case UMAC_WIFI_IF_CMD_SET_PROFILE:
+		iwm->umac_profile_active = 1;
+		wake_up_interruptible(&iwm->mlme_queue);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int iwm_ntf_card_state(struct iwm_priv *iwm, u8 *buf,
+			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_lmac_card_state *state = (struct iwm_lmac_card_state *)
+				(buf + sizeof(struct iwm_umac_wifi_in_hdr));
+	u32 flags = le32_to_cpu(state->flags);
+
+	IWM_INFO(iwm, "HW RF Kill %s, CT Kill %s\n",
+		 flags & IWM_CARD_STATE_HW_DISABLED ? "ON" : "OFF",
+		 flags & IWM_CARD_STATE_CTKILL_DISABLED ? "ON" : "OFF");
+
+	if (flags & IWM_CARD_STATE_HW_DISABLED)
+		set_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
+	else
+		clear_bit(IWM_RADIO_RFKILL_HW, &iwm->radio);
+
+	return 0;
+}
+
+static int iwm_rx_handle_wifi(struct iwm_priv *iwm, u8 *buf,
+			      unsigned long buf_size)
+{
+	struct iwm_umac_wifi_in_hdr *wifi_hdr;
+	struct iwm_wifi_cmd *cmd;
+	u8 source, cmd_id;
+	u16 seq_num;
+	u32 count;
+	u8 resp;
+
+	wifi_hdr = (struct iwm_umac_wifi_in_hdr *)buf;
+	cmd_id = wifi_hdr->sw_hdr.cmd.cmd;
+
+	source = GET_VAL32(wifi_hdr->hw_hdr.cmd, UMAC_HDI_IN_CMD_SOURCE);
+	if (source >= IWM_SRC_NUM) {
+		IWM_CRIT(iwm, "invalid source %d\n", source);
+		return -EINVAL;
+	}
+
+	count = (GET_VAL32(wifi_hdr->sw_hdr.meta_data, UMAC_FW_CMD_BYTE_COUNT));
+	count += sizeof(struct iwm_umac_wifi_in_hdr) -
+		 sizeof(struct iwm_dev_cmd_hdr);
+	if (count > buf_size) {
+		IWM_CRIT(iwm, "count %d, buf size:%ld\n", count, buf_size);
+		return -EINVAL;
+	}
+
+	resp = GET_VAL32(wifi_hdr->sw_hdr.meta_data, UMAC_FW_CMD_STATUS);
+
+	seq_num = le16_to_cpu(wifi_hdr->sw_hdr.cmd.seq_num);
+
+	IWM_DBG_RX(iwm, DBG, "CMD:0x%x, source: 0x%x, seqnum: %d\n",
+		   cmd_id, source, seq_num);
+
+	/*
+	 * If this is a response to a previously sent command, there must
+	 * be a pending command for this sequence number.
+	 */
+	cmd = iwm_get_pending_wifi_cmd(iwm, seq_num);
+
+	/* Notify the caller only for sync commands. */
+	switch (source) {
+	case UMAC_HDI_IN_SOURCE_FHRX:
+		if (iwm->lmac_handlers[cmd_id] &&
+		    test_bit(cmd_id, &iwm->lmac_handler_map[0]))
+			return iwm_notif_send(iwm, cmd, cmd_id, source,
+					      buf, count);
+		break;
+	case UMAC_HDI_IN_SOURCE_FW:
+		if (iwm->umac_handlers[cmd_id] &&
+		    test_bit(cmd_id, &iwm->umac_handler_map[0]))
+			return iwm_notif_send(iwm, cmd, cmd_id, source,
+					      buf, count);
+		break;
+	case UMAC_HDI_IN_SOURCE_UDMA:
+		break;
+	}
+
+	return iwm_rx_handle_resp(iwm, buf, count, cmd);
+}
+
+int iwm_rx_handle_resp(struct iwm_priv *iwm, u8 *buf, unsigned long buf_size,
+		       struct iwm_wifi_cmd *cmd)
+{
+	u8 source, cmd_id;
+	struct iwm_umac_wifi_in_hdr *wifi_hdr;
+	int ret = 0;
+
+	wifi_hdr = (struct iwm_umac_wifi_in_hdr *)buf;
+	cmd_id = wifi_hdr->sw_hdr.cmd.cmd;
+
+	source = GET_VAL32(wifi_hdr->hw_hdr.cmd, UMAC_HDI_IN_CMD_SOURCE);
+
+	IWM_DBG_RX(iwm, DBG, "CMD:0x%x, source: 0x%x\n", cmd_id, source);
+
+	switch (source) {
+	case UMAC_HDI_IN_SOURCE_FHRX:
+		if (iwm->lmac_handlers[cmd_id])
+			ret = iwm->lmac_handlers[cmd_id]
+					(iwm, buf, buf_size, cmd);
+		break;
+	case UMAC_HDI_IN_SOURCE_FW:
+		if (iwm->umac_handlers[cmd_id])
+			ret = iwm->umac_handlers[cmd_id]
+					(iwm, buf, buf_size, cmd);
+		break;
+	case UMAC_HDI_IN_SOURCE_UDMA:
+		ret = -EINVAL;
+		break;
+	}
+
+	kfree(cmd);
+
+	return ret;
+}
+
+static int iwm_rx_handle_nonwifi(struct iwm_priv *iwm, u8 *buf,
+				 unsigned long buf_size)
+{
+	u8 seq_num;
+	struct iwm_udma_in_hdr *hdr = (struct iwm_udma_in_hdr *)buf;
+	struct iwm_nonwifi_cmd *cmd, *next;
+
+	seq_num = GET_VAL32(hdr->cmd, UDMA_HDI_IN_CMD_NON_WIFI_HW_SEQ_NUM);
+
+	/*
+	 * We received a non wifi answer.
+	 * Let's check if there's a pending command for it, and if so
+	 * replace the command payload with the buffer, and then wake the
+	 * callers up.
+	 * That means we only support synchronised non wifi command response
+	 * schemes.
+	 */
+	list_for_each_entry_safe(cmd, next, &iwm->nonwifi_pending_cmd, pending)
+		if (cmd->seq_num == seq_num) {
+			cmd->resp_received = 1;
+			cmd->buf.len = buf_size;
+			memcpy(cmd->buf.hdr, buf, buf_size);
+			wake_up_interruptible(&iwm->nonwifi_queue);
+		}
+
+	return 0;
+}
+
+static int iwm_rx_handle_umac(struct iwm_priv *iwm, u8 *buf,
+			      unsigned long buf_size)
+{
+	int ret = 0;
+	u8 op_code;
+	unsigned long buf_offset = 0;
+	struct iwm_udma_in_hdr *hdr;
+
+	/*
+	 * To allow for a more efficient bus usage, UMAC
+	 * messages are encapsulated into UDMA ones. This
+	 * way we can have several UMAC messages in one bus
+	 * transfer.
+	 * A UDMA frame size is always aligned on 16 bytes,
+	 * and a UDMA frame must not start with a UMAC_PAD_TERMINAL
+	 * word. This is how we parse a bus frame into several
+	 * UDMA ones.
+	 */
+	while (buf_offset < buf_size) {
+
+		hdr = (struct iwm_udma_in_hdr *)(buf + buf_offset);
+
+		if (iwm_rx_check_udma_hdr(hdr) < 0) {
+			IWM_DBG_RX(iwm, DBG, "End of frame\n");
+			break;
+		}
+
+		op_code = GET_VAL32(hdr->cmd, UMAC_HDI_IN_CMD_OPCODE);
+
+		IWM_DBG_RX(iwm, DBG, "Op code: 0x%x\n", op_code);
+
+		if (op_code == UMAC_HDI_IN_OPCODE_WIFI) {
+			ret |= iwm_rx_handle_wifi(iwm, buf + buf_offset,
+						  buf_size - buf_offset);
+		} else if (op_code < UMAC_HDI_IN_OPCODE_NONWIFI_MAX) {
+			if (GET_VAL32(hdr->cmd,
+				      UDMA_HDI_IN_CMD_NON_WIFI_HW_SIG) !=
+			    UDMA_HDI_IN_CMD_NON_WIFI_HW_SIG) {
+				IWM_ERR(iwm, "Incorrect hw signature\n");
+				return -EINVAL;
+			}
+			ret |= iwm_rx_handle_nonwifi(iwm, buf + buf_offset,
+						     buf_size - buf_offset);
+		} else {
+			IWM_ERR(iwm, "Invalid RX opcode: 0x%x\n", op_code);
+			ret |= -EINVAL;
+		}
+
+		buf_offset += iwm_rx_resp_size(hdr);
+	}
+
+	return ret;
+}
+
+int iwm_rx_handle(struct iwm_priv *iwm, u8 *buf, unsigned long buf_size)
+{
+	struct iwm_udma_in_hdr *hdr;
+
+	hdr = (struct iwm_udma_in_hdr *)buf;
+
+	switch (le32_to_cpu(hdr->cmd)) {
+	case UMAC_REBOOT_BARKER:
+		return iwm_notif_send(iwm, NULL, IWM_BARKER_REBOOT_NOTIFICATION,
+				      IWM_SRC_UDMA, buf, buf_size);
+	case UMAC_ACK_BARKER:
+		return iwm_notif_send(iwm, NULL, IWM_ACK_BARKER_NOTIFICATION,
+				      IWM_SRC_UDMA, NULL, 0);
+	default:
+		IWM_DBG_RX(iwm, DBG, "Received cmd: 0x%x\n", hdr->cmd);
+		return iwm_rx_handle_umac(iwm, buf, buf_size);
+	}
+
+	return 0;
+}
+
+static const iwm_handler iwm_umac_handlers[] =
+{
+	[UMAC_NOTIFY_OPCODE_ERROR]		= iwm_ntf_error,
+	[UMAC_NOTIFY_OPCODE_ALIVE]		= iwm_ntf_umac_alive,
+	[UMAC_NOTIFY_OPCODE_INIT_COMPLETE]	= iwm_ntf_init_complete,
+	[UMAC_NOTIFY_OPCODE_WIFI_CORE_STATUS]	= iwm_ntf_wifi_status,
+	[UMAC_NOTIFY_OPCODE_WIFI_IF_WRAPPER]	= iwm_ntf_mlme,
+	[UMAC_NOTIFY_OPCODE_PAGE_DEALLOC]	= iwm_ntf_tx_credit_update,
+	[UMAC_NOTIFY_OPCODE_RX_TICKET]		= iwm_ntf_rx_ticket,
+	[UMAC_CMD_OPCODE_RESET]			= iwm_ntf_umac_reset,
+	[UMAC_NOTIFY_OPCODE_STATS]		= iwm_ntf_statistics,
+	[UMAC_CMD_OPCODE_EEPROM_PROXY]		= iwm_ntf_eeprom_proxy,
+	[UMAC_CMD_OPCODE_GET_CHAN_INFO_LIST]	= iwm_ntf_channel_info_list,
+	[REPLY_RX_MPDU_CMD]			= iwm_ntf_rx_packet,
+	[UMAC_CMD_OPCODE_WIFI_IF_WRAPPER]	= iwm_ntf_wifi_if_wrapper,
+};
+
+static const iwm_handler iwm_lmac_handlers[] =
+{
+	[REPLY_TX]				= iwm_ntf_tx,
+	[REPLY_ALIVE]				= iwm_ntf_lmac_version,
+	[CALIBRATION_RES_NOTIFICATION]		= iwm_ntf_calib_res,
+	[CALIBRATION_COMPLETE_NOTIFICATION]	= iwm_ntf_calib_complete,
+	[CALIBRATION_CFG_CMD]			= iwm_ntf_calib_cfg,
+	[REPLY_RX_MPDU_CMD]			= iwm_ntf_rx_packet,
+	[CARD_STATE_NOTIFICATION]		= iwm_ntf_card_state,
+};
+
+void iwm_rx_setup_handlers(struct iwm_priv *iwm)
+{
+	iwm->umac_handlers = (iwm_handler *) iwm_umac_handlers;
+	iwm->lmac_handlers = (iwm_handler *) iwm_lmac_handlers;
+}
+
+static void iwm_remove_iv(struct sk_buff *skb, u32 hdr_total_len)
+{
+	struct ieee80211_hdr *hdr;
+	unsigned int hdr_len;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_has_protected(hdr->frame_control))
+		return;
+
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	if (hdr_total_len <= hdr_len)
+		return;
+
+	memmove(skb->data + (hdr_total_len - hdr_len), skb->data, hdr_len);
+	skb_pull(skb, (hdr_total_len - hdr_len));
+}
+
+static void iwm_rx_adjust_packet(struct iwm_priv *iwm,
+				 struct iwm_rx_packet *packet,
+				 struct iwm_rx_ticket_node *ticket_node)
+{
+	u32 payload_offset = 0, payload_len;
+	struct iwm_rx_ticket *ticket = ticket_node->ticket;
+	struct iwm_rx_mpdu_hdr *mpdu_hdr;
+	struct ieee80211_hdr *hdr;
+
+	mpdu_hdr = (struct iwm_rx_mpdu_hdr *)packet->skb->data;
+	payload_offset += sizeof(struct iwm_rx_mpdu_hdr);
+	/* Padding is 0 or 2 bytes */
+	payload_len = le16_to_cpu(mpdu_hdr->len) +
+		(le16_to_cpu(ticket->flags) & IWM_RX_TICKET_PAD_SIZE_MSK);
+	payload_len -= ticket->tail_len;
+
+	IWM_DBG_RX(iwm, DBG, "Packet adjusted, len:%d, offset:%d, "
+		   "ticket offset:%d ticket tail len:%d\n",
+		   payload_len, payload_offset, ticket->payload_offset,
+		   ticket->tail_len);
+
+	IWM_HEXDUMP(iwm, DBG, RX, "RAW: ", packet->skb->data, packet->skb->len);
+
+	skb_pull(packet->skb, payload_offset);
+	skb_trim(packet->skb, payload_len);
+
+	iwm_remove_iv(packet->skb, ticket->payload_offset);
+
+	hdr = (struct ieee80211_hdr *) packet->skb->data;
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		/* UMAC handed QOS_DATA frame with 2 padding bytes appended
+		 * to the qos_ctl field in IEEE 802.11 headers. */
+		memmove(packet->skb->data + IEEE80211_QOS_CTL_LEN + 2,
+			packet->skb->data,
+			ieee80211_hdrlen(hdr->frame_control) -
+			IEEE80211_QOS_CTL_LEN);
+		hdr = (struct ieee80211_hdr *) skb_pull(packet->skb,
+				IEEE80211_QOS_CTL_LEN + 2);
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+	}
+
+	IWM_HEXDUMP(iwm, DBG, RX, "ADJUSTED: ",
+		    packet->skb->data, packet->skb->len);
+}
+
+static void classify8023(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
+		/* frame has qos control */
+		skb->priority = *qc & IEEE80211_QOS_CTL_TID_MASK;
+	} else {
+		skb->priority = 0;
+	}
+}
+
+static void iwm_rx_process_packet(struct iwm_priv *iwm,
+				  struct iwm_rx_packet *packet,
+				  struct iwm_rx_ticket_node *ticket_node)
+{
+	int ret;
+	struct sk_buff *skb = packet->skb;
+	struct wireless_dev *wdev = iwm_to_wdev(iwm);
+	struct net_device *ndev = iwm_to_ndev(iwm);
+
+	IWM_DBG_RX(iwm, DBG, "Processing packet ID %d\n", packet->id);
+
+	switch (le16_to_cpu(ticket_node->ticket->action)) {
+	case IWM_RX_TICKET_RELEASE:
+		IWM_DBG_RX(iwm, DBG, "RELEASE packet\n");
+		classify8023(skb);
+		iwm_rx_adjust_packet(iwm, packet, ticket_node);
+		ret = ieee80211_data_to_8023(skb, ndev->dev_addr, wdev->iftype);
+		if (ret < 0) {
+			IWM_DBG_RX(iwm, DBG, "Couldn't convert 802.11 header - "
+				   "%d\n", ret);
+			break;
+		}
+
+		IWM_HEXDUMP(iwm, DBG, RX, "802.3: ", skb->data, skb->len);
+
+		skb->dev = iwm_to_ndev(iwm);
+		skb->protocol = eth_type_trans(skb, ndev);
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		memset(skb->cb, 0, sizeof(skb->cb));
+
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += skb->len;
+
+		if (netif_rx(skb) == NET_RX_DROP) {
+			IWM_ERR(iwm, "Packet dropped\n");
+			ndev->stats.rx_dropped++;
+		}
+		break;
+	case IWM_RX_TICKET_DROP:
+		IWM_DBG_RX(iwm, DBG, "DROP packet\n");
+		kfree_skb(packet->skb);
+		break;
+	default:
+		IWM_ERR(iwm, "Unknow ticket action: %d\n",
+			le16_to_cpu(ticket_node->ticket->action));
+		kfree_skb(packet->skb);
+	}
+
+	kfree(packet);
+	iwm_rx_ticket_node_free(ticket_node);
+}
+
+/*
+ * Rx data processing:
+ *
+ * We're receiving Rx packet from the LMAC, and Rx ticket from
+ * the UMAC.
+ * To forward a target data packet upstream (i.e. to the
+ * kernel network stack), we must have received an Rx ticket
+ * that tells us we're allowed to release this packet (ticket
+ * action is IWM_RX_TICKET_RELEASE). The Rx ticket also indicates,
+ * among other things, where valid data actually starts in the Rx
+ * packet.
+ */
+void iwm_rx_worker(struct work_struct *work)
+{
+	struct iwm_priv *iwm;
+	struct iwm_rx_ticket_node *ticket, *next;
+
+	iwm = container_of(work, struct iwm_priv, rx_worker);
+
+	/*
+	 * We go through the tickets list and if there is a pending
+	 * packet for it, we push it upstream.
+	 * We stop whenever a ticket is missing its packet, as we're
+	 * supposed to send the packets in order.
+	 */
+	list_for_each_entry_safe(ticket, next, &iwm->rx_tickets, node) {
+		struct iwm_rx_packet *packet =
+			iwm_rx_packet_get(iwm, le16_to_cpu(ticket->ticket->id));
+
+		if (!packet) {
+			IWM_DBG_RX(iwm, DBG, "Skip rx_work: Wait for ticket %d "
+				   "to be handled first\n",
+				   le16_to_cpu(ticket->ticket->id));
+			return;
+		}
+
+		list_del(&ticket->node);
+		list_del(&packet->node);
+		iwm_rx_process_packet(iwm, packet, ticket);
+	}
+}
+
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.h b/drivers/net/wireless/iwmc3200wifi/rx.h
new file mode 100644
index 0000000..da0db91
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/rx.h
@@ -0,0 +1,60 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_RX_H__
+#define __IWM_RX_H__
+
+#include <linux/skbuff.h>
+
+#include "umac.h"
+
+struct iwm_rx_ticket_node {
+	struct list_head node;
+	struct iwm_rx_ticket *ticket;
+};
+
+struct iwm_rx_packet {
+	struct list_head node;
+	u16 id;
+	struct sk_buff *skb;
+	unsigned long pkt_size;
+};
+
+void iwm_rx_worker(struct work_struct *work);
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
new file mode 100644
index 0000000..edc0a00
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -0,0 +1,516 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+/*
+ * This is the SDIO bus specific hooks for iwm.
+ * It also is the module's entry point.
+ *
+ * Interesting code paths:
+ * iwm_sdio_probe() (Called by an SDIO bus scan)
+ *  -> iwm_if_alloc() (netdev.c)
+ *      -> iwm_wdev_alloc() (cfg80211.c, allocates and register our wiphy)
+ *          -> wiphy_new()
+ *          -> wiphy_register()
+ *      -> alloc_netdev_mq()
+ *      -> register_netdev()
+ *
+ * iwm_sdio_remove()
+ *  -> iwm_if_free() (netdev.c)
+ *      -> unregister_netdev()
+ *      -> iwm_wdev_free() (cfg80211.c)
+ *          -> wiphy_unregister()
+ *          -> wiphy_free()
+ *
+ * iwm_sdio_isr() (called in process context from the SDIO core code)
+ *  -> queue_work(.., isr_worker)
+ *      -- [async] --> iwm_sdio_isr_worker()
+ *                      -> iwm_rx_handle()
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/debugfs.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_func.h>
+
+#include "iwm.h"
+#include "debug.h"
+#include "bus.h"
+#include "sdio.h"
+
+static void iwm_sdio_isr_worker(struct work_struct *work)
+{
+	struct iwm_sdio_priv *hw;
+	struct iwm_priv *iwm;
+	struct iwm_rx_info *rx_info;
+	struct sk_buff *skb;
+	u8 *rx_buf;
+	unsigned long rx_size;
+
+	hw = container_of(work, struct iwm_sdio_priv, isr_worker);
+	iwm = hw_to_iwm(hw);
+
+	while (!skb_queue_empty(&iwm->rx_list)) {
+		skb = skb_dequeue(&iwm->rx_list);
+		rx_info = skb_to_rx_info(skb);
+		rx_size = rx_info->rx_size;
+		rx_buf = skb->data;
+
+		IWM_HEXDUMP(iwm, DBG, SDIO, "RX: ", rx_buf, rx_size);
+		if (iwm_rx_handle(iwm, rx_buf, rx_size) < 0)
+			IWM_WARN(iwm, "RX error\n");
+
+		kfree_skb(skb);
+	}
+}
+
+static void iwm_sdio_isr(struct sdio_func *func)
+{
+	struct iwm_priv *iwm;
+	struct iwm_sdio_priv *hw;
+	struct iwm_rx_info *rx_info;
+	struct sk_buff *skb;
+	unsigned long buf_size, read_size;
+	int ret;
+	u8 val;
+
+	hw = sdio_get_drvdata(func);
+	iwm = hw_to_iwm(hw);
+
+	buf_size = hw->blk_size;
+
+	/* We're checking the status */
+	val = sdio_readb(func, IWM_SDIO_INTR_STATUS_ADDR, &ret);
+	if (val == 0 || ret < 0) {
+		IWM_ERR(iwm, "Wrong INTR_STATUS\n");
+		return;
+	}
+
+	/* See if we have free buffers */
+	if (skb_queue_len(&iwm->rx_list) > IWM_RX_LIST_SIZE) {
+		IWM_ERR(iwm, "No buffer for more Rx frames\n");
+		return;
+	}
+
+	/* We first read the transaction size */
+	read_size = sdio_readb(func, IWM_SDIO_INTR_GET_SIZE_ADDR + 1, &ret);
+	read_size = read_size << 8;
+
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't read the xfer size\n");
+		return;
+	}
+
+	/* We need to clear the INT register */
+	sdio_writeb(func, 1, IWM_SDIO_INTR_CLEAR_ADDR, &ret);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't clear the INT register\n");
+		return;
+	}
+
+	while (buf_size < read_size)
+		buf_size <<= 1;
+
+	skb = dev_alloc_skb(buf_size);
+	if (!skb) {
+		IWM_ERR(iwm, "Couldn't alloc RX skb\n");
+		return;
+	}
+	rx_info = skb_to_rx_info(skb);
+	rx_info->rx_size = read_size;
+	rx_info->rx_buf_size = buf_size;
+
+	/* Now we can read the actual buffer */
+	ret = sdio_memcpy_fromio(func, skb_put(skb, read_size),
+				 IWM_SDIO_DATA_ADDR, read_size);
+
+	/* The skb is put on a driver's specific Rx SKB list */
+	skb_queue_tail(&iwm->rx_list, skb);
+
+	/* We can now schedule the actual worker */
+	queue_work(hw->isr_wq, &hw->isr_worker);
+}
+
+static void iwm_sdio_rx_free(struct iwm_sdio_priv *hw)
+{
+	struct iwm_priv *iwm = hw_to_iwm(hw);
+
+	flush_workqueue(hw->isr_wq);
+
+	skb_queue_purge(&iwm->rx_list);
+}
+
+/* Bus ops */
+static int if_sdio_enable(struct iwm_priv *iwm)
+{
+	struct iwm_sdio_priv *hw = iwm_to_if_sdio(iwm);
+	int ret;
+
+	sdio_claim_host(hw->func);
+
+	ret = sdio_enable_func(hw->func);
+	if (ret) {
+		IWM_ERR(iwm, "Couldn't enable the device: is TOP driver "
+			"loaded and functional?\n");
+		goto release_host;
+	}
+
+	iwm_reset(iwm);
+
+	ret = sdio_claim_irq(hw->func, iwm_sdio_isr);
+	if (ret) {
+		IWM_ERR(iwm, "Failed to claim irq: %d\n", ret);
+		goto release_host;
+	}
+
+	sdio_writeb(hw->func, 1, IWM_SDIO_INTR_ENABLE_ADDR, &ret);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't enable INTR: %d\n", ret);
+		goto release_irq;
+	}
+
+	sdio_release_host(hw->func);
+
+	IWM_DBG_SDIO(iwm, INFO, "IWM SDIO enable\n");
+
+	return 0;
+
+ release_irq:
+	sdio_release_irq(hw->func);
+ release_host:
+	sdio_release_host(hw->func);
+
+	return ret;
+}
+
+static int if_sdio_disable(struct iwm_priv *iwm)
+{
+	struct iwm_sdio_priv *hw = iwm_to_if_sdio(iwm);
+	int ret;
+
+	iwm_reset(iwm);
+
+	sdio_claim_host(hw->func);
+	sdio_writeb(hw->func, 0, IWM_SDIO_INTR_ENABLE_ADDR, &ret);
+	if (ret < 0)
+		IWM_WARN(iwm, "Couldn't disable INTR: %d\n", ret);
+
+	sdio_release_irq(hw->func);
+	sdio_disable_func(hw->func);
+	sdio_release_host(hw->func);
+
+	iwm_sdio_rx_free(hw);
+
+	IWM_DBG_SDIO(iwm, INFO, "IWM SDIO disable\n");
+
+	return 0;
+}
+
+static int if_sdio_send_chunk(struct iwm_priv *iwm, u8 *buf, int count)
+{
+	struct iwm_sdio_priv *hw = iwm_to_if_sdio(iwm);
+	int aligned_count = ALIGN(count, hw->blk_size);
+	int ret;
+
+	if ((unsigned long)buf & 0x3) {
+		IWM_ERR(iwm, "buf <%p> is not dword aligned\n", buf);
+		/* TODO: Is this a hardware limitation? use get_unligned */
+		return -EINVAL;
+	}
+
+	sdio_claim_host(hw->func);
+	ret = sdio_memcpy_toio(hw->func, IWM_SDIO_DATA_ADDR, buf,
+			       aligned_count);
+	sdio_release_host(hw->func);
+
+	return ret;
+}
+
+/* debugfs hooks */
+static int iwm_debugfs_sdio_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t iwm_debugfs_sdio_read(struct file *filp, char __user *buffer,
+				     size_t count, loff_t *ppos)
+{
+	struct iwm_priv *iwm = filp->private_data;
+	struct iwm_sdio_priv *hw = iwm_to_if_sdio(iwm);
+	char *buf;
+	u8 cccr;
+	int buf_len = 4096, ret;
+	size_t len = 0;
+
+	if (*ppos != 0)
+		return 0;
+	if (count < sizeof(buf))
+		return -ENOSPC;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	sdio_claim_host(hw->func);
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_IOEx, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_IOEx\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_IOEx:  0x%x\n", cccr);
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_IORx, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_IORx\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_IORx:  0x%x\n", cccr);
+
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_IENx, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_IENx\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_IENx:  0x%x\n", cccr);
+
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_INTx, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_INTx\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_INTx:  0x%x\n", cccr);
+
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_ABORT, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_ABORTx\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_ABORT: 0x%x\n", cccr);
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_IF, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_IF\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_IF:    0x%x\n", cccr);
+
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_CAPS, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_CAPS\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_CAPS:  0x%x\n", cccr);
+
+	cccr =  sdio_f0_readb(hw->func, SDIO_CCCR_CIS, &ret);
+	if (ret) {
+		IWM_ERR(iwm, "Could not read SDIO_CCCR_CIS\n");
+		goto err;
+	}
+	len += snprintf(buf + len, buf_len - len, "CCCR_CIS:   0x%x\n", cccr);
+
+	ret = simple_read_from_buffer(buffer, len, ppos, buf, buf_len);
+err:
+	sdio_release_host(hw->func);
+
+	kfree(buf);
+
+	return ret;
+}
+
+static const struct file_operations iwm_debugfs_sdio_fops = {
+	.owner =	THIS_MODULE,
+	.open =		iwm_debugfs_sdio_open,
+	.read =		iwm_debugfs_sdio_read,
+};
+
+static int if_sdio_debugfs_init(struct iwm_priv *iwm, struct dentry *parent_dir)
+{
+	int result;
+	struct iwm_sdio_priv *hw = iwm_to_if_sdio(iwm);
+
+	hw->cccr_dentry = debugfs_create_file("cccr", 0200,
+					      parent_dir, iwm,
+					      &iwm_debugfs_sdio_fops);
+	result = PTR_ERR(hw->cccr_dentry);
+	if (IS_ERR(hw->cccr_dentry) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create CCCR entry: %d\n", result);
+		return result;
+	}
+
+	return 0;
+}
+
+static void if_sdio_debugfs_exit(struct iwm_priv *iwm)
+{
+	struct iwm_sdio_priv *hw = iwm_to_if_sdio(iwm);
+
+	debugfs_remove(hw->cccr_dentry);
+}
+
+static struct iwm_if_ops if_sdio_ops = {
+	.enable = if_sdio_enable,
+	.disable = if_sdio_disable,
+	.send_chunk = if_sdio_send_chunk,
+	.debugfs_init = if_sdio_debugfs_init,
+	.debugfs_exit = if_sdio_debugfs_exit,
+	.umac_name = "iwmc3200wifi-umac-sdio.bin",
+	.calib_lmac_name = "iwmc3200wifi-lmac-calib-sdio.bin",
+	.lmac_name = "iwmc3200wifi-lmac-sdio.bin",
+};
+
+static int iwm_sdio_probe(struct sdio_func *func,
+			  const struct sdio_device_id *id)
+{
+	struct iwm_priv *iwm;
+	struct iwm_sdio_priv *hw;
+	struct device *dev = &func->dev;
+	int ret;
+
+	/* check if TOP has already initialized the card */
+	sdio_claim_host(func);
+	ret = sdio_enable_func(func);
+	if (ret) {
+		dev_err(dev, "wait for TOP to enable the device\n");
+		sdio_release_host(func);
+		return ret;
+	}
+
+	ret = sdio_set_block_size(func, IWM_SDIO_BLK_SIZE);
+
+	sdio_disable_func(func);
+	sdio_release_host(func);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to set block size: %d\n", ret);
+		return ret;
+	}
+
+	iwm = iwm_if_alloc(sizeof(struct iwm_sdio_priv), dev, &if_sdio_ops);
+	if (IS_ERR(iwm)) {
+		dev_err(dev, "allocate SDIO interface failed\n");
+		return PTR_ERR(iwm);
+	}
+
+	hw = iwm_private(iwm);
+	hw->iwm = iwm;
+
+	ret = iwm_debugfs_init(iwm);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Debugfs registration failed\n");
+		goto if_free;
+	}
+
+	sdio_set_drvdata(func, hw);
+
+	hw->func = func;
+	hw->blk_size = IWM_SDIO_BLK_SIZE;
+
+	hw->isr_wq = create_singlethread_workqueue(KBUILD_MODNAME "_sdio");
+	if (!hw->isr_wq) {
+		ret = -ENOMEM;
+		goto debugfs_exit;
+	}
+
+	INIT_WORK(&hw->isr_worker, iwm_sdio_isr_worker);
+
+	dev_info(dev, "IWM SDIO probe\n");
+
+	return 0;
+
+ debugfs_exit:
+	iwm_debugfs_exit(iwm);
+ if_free:
+	iwm_if_free(iwm);
+	return ret;
+}
+
+static void iwm_sdio_remove(struct sdio_func *func)
+{
+	struct iwm_sdio_priv *hw = sdio_get_drvdata(func);
+	struct iwm_priv *iwm = hw_to_iwm(hw);
+	struct device *dev = &func->dev;
+
+	iwm_debugfs_exit(iwm);
+	iwm_if_free(iwm);
+	destroy_workqueue(hw->isr_wq);
+
+	sdio_set_drvdata(func, NULL);
+
+	dev_info(dev, "IWM SDIO remove\n");
+
+	return;
+}
+
+static const struct sdio_device_id iwm_sdio_ids[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_INTEL, SDIO_DEVICE_ID_IWM) },
+	{ /* end: all zeroes */	},
+};
+MODULE_DEVICE_TABLE(sdio, iwm_sdio_ids);
+
+static struct sdio_driver iwm_sdio_driver = {
+	.name		= "iwm_sdio",
+	.id_table	= iwm_sdio_ids,
+	.probe		= iwm_sdio_probe,
+	.remove		= iwm_sdio_remove,
+};
+
+static int __init iwm_sdio_init_module(void)
+{
+	int ret;
+
+	ret = sdio_register_driver(&iwm_sdio_driver);
+
+	return ret;
+}
+
+static void __exit iwm_sdio_exit_module(void)
+{
+	sdio_unregister_driver(&iwm_sdio_driver);
+}
+
+module_init(iwm_sdio_init_module);
+module_exit(iwm_sdio_exit_module);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(IWM_COPYRIGHT " " IWM_AUTHOR);
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.h b/drivers/net/wireless/iwmc3200wifi/sdio.h
new file mode 100644
index 0000000..b3c156b
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.h
@@ -0,0 +1,67 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_SDIO_H__
+#define __IWM_SDIO_H__
+
+#define SDIO_VENDOR_ID_INTEL 0x89
+#define SDIO_DEVICE_ID_IWM   0x1403
+
+#define IWM_SDIO_DATA_ADDR           0x0
+#define IWM_SDIO_INTR_ENABLE_ADDR    0x14
+#define IWM_SDIO_INTR_STATUS_ADDR    0x13
+#define IWM_SDIO_INTR_CLEAR_ADDR     0x13
+#define IWM_SDIO_INTR_GET_SIZE_ADDR  0x2C
+
+#define IWM_SDIO_BLK_SIZE       256
+
+#define iwm_to_if_sdio(i) (struct iwm_sdio_priv *)(iwm->private)
+
+struct iwm_sdio_priv {
+	struct sdio_func *func;
+	struct iwm_priv *iwm;
+
+	struct workqueue_struct *isr_wq;
+	struct work_struct isr_worker;
+
+	struct dentry *cccr_dentry;
+
+	unsigned int blk_size;
+};
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/tx.c b/drivers/net/wireless/iwmc3200wifi/tx.c
new file mode 100644
index 0000000..e3b4f79
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/tx.c
@@ -0,0 +1,492 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+/*
+ * iwm Tx theory of operation:
+ *
+ * 1) We receive a 802.3 frame from the stack
+ * 2) We convert it to a 802.11 frame [iwm_xmit_frame]
+ * 3) We queue it to its corresponding tx queue [iwm_xmit_frame]
+ * 4) We schedule the tx worker. There is one worker per tx
+ *    queue. [iwm_xmit_frame]
+ * 5) The tx worker is scheduled
+ * 6) We go through every queued skb on the tx queue, and for each
+ *    and every one of them: [iwm_tx_worker]
+ *    a) We check if we have enough Tx credits (see below for a Tx
+ *       credits description) for the frame length. [iwm_tx_worker]
+ *    b) If we do, we aggregate the Tx frame into a UDMA one, by
+ *       concatenating one REPLY_TX command per Tx frame. [iwm_tx_worker]
+ *    c) When we run out of credits, or when we reach the maximum
+ *       concatenation size, we actually send the concatenated UDMA
+ *       frame. [iwm_tx_worker]
+ *
+ * When we run out of Tx credits, the skbs are filling the tx queue,
+ * and eventually we will stop the netdev queue. [iwm_tx_worker]
+ * The tx queue is emptied as we're getting new tx credits, by
+ * scheduling the tx_worker. [iwm_tx_credit_inc]
+ * The netdev queue is started again when we have enough tx credits,
+ * and when our tx queue has some reasonable amout of space available
+ * (i.e. half of the max size). [iwm_tx_worker]
+ */
+
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/ieee80211.h>
+
+#include "iwm.h"
+#include "debug.h"
+#include "commands.h"
+#include "hal.h"
+#include "umac.h"
+#include "bus.h"
+
+#define IWM_UMAC_PAGE_ALLOC_WRAP 0xffff
+
+#define BYTES_TO_PAGES(n)	 (1 + ((n) >> ilog2(IWM_UMAC_PAGE_SIZE)) - \
+				 (((n) & (IWM_UMAC_PAGE_SIZE - 1)) == 0))
+
+#define pool_id_to_queue(id)	 ((id < IWM_TX_CMD_QUEUE) ? id : id - 1)
+#define queue_to_pool_id(q)	 ((q < IWM_TX_CMD_QUEUE) ? q : q + 1)
+
+/* require to hold tx_credit lock */
+static int iwm_tx_credit_get(struct iwm_tx_credit *tx_credit, int id)
+{
+	struct pool_entry *pool = &tx_credit->pools[id];
+	struct spool_entry *spool = &tx_credit->spools[pool->sid];
+	int spool_pages;
+
+	/* number of pages can be taken from spool by this pool */
+	spool_pages = spool->max_pages - spool->alloc_pages +
+		      max(pool->min_pages - pool->alloc_pages, 0);
+
+	return min(pool->max_pages - pool->alloc_pages, spool_pages);
+}
+
+static bool iwm_tx_credit_ok(struct iwm_priv *iwm, int id, int nb)
+{
+	u32 npages = BYTES_TO_PAGES(nb);
+
+	if (npages <= iwm_tx_credit_get(&iwm->tx_credit, id))
+		return 1;
+
+	set_bit(id, &iwm->tx_credit.full_pools_map);
+
+	IWM_DBG_TX(iwm, DBG, "LINK: stop txq[%d], available credit: %d\n",
+		   pool_id_to_queue(id),
+		   iwm_tx_credit_get(&iwm->tx_credit, id));
+
+	return 0;
+}
+
+void iwm_tx_credit_inc(struct iwm_priv *iwm, int id, int total_freed_pages)
+{
+	struct pool_entry *pool;
+	struct spool_entry *spool;
+	int freed_pages;
+	int queue;
+
+	BUG_ON(id >= IWM_MACS_OUT_GROUPS);
+
+	pool = &iwm->tx_credit.pools[id];
+	spool = &iwm->tx_credit.spools[pool->sid];
+
+	freed_pages = total_freed_pages - pool->total_freed_pages;
+	IWM_DBG_TX(iwm, DBG, "Free %d pages for pool[%d]\n", freed_pages, id);
+
+	if (!freed_pages) {
+		IWM_DBG_TX(iwm, DBG, "No pages are freed by UMAC\n");
+		return;
+	} else if (freed_pages < 0)
+		freed_pages += IWM_UMAC_PAGE_ALLOC_WRAP + 1;
+
+	if (pool->alloc_pages > pool->min_pages) {
+		int spool_pages = pool->alloc_pages - pool->min_pages;
+		spool_pages = min(spool_pages, freed_pages);
+		spool->alloc_pages -= spool_pages;
+	}
+
+	pool->alloc_pages -= freed_pages;
+	pool->total_freed_pages = total_freed_pages;
+
+	IWM_DBG_TX(iwm, DBG, "Pool[%d] pages alloc: %d, total_freed: %d, "
+		   "Spool[%d] pages alloc: %d\n", id, pool->alloc_pages,
+		   pool->total_freed_pages, pool->sid, spool->alloc_pages);
+
+	if (test_bit(id, &iwm->tx_credit.full_pools_map) &&
+	    (pool->alloc_pages < pool->max_pages / 2)) {
+		clear_bit(id, &iwm->tx_credit.full_pools_map);
+
+		queue = pool_id_to_queue(id);
+
+		IWM_DBG_TX(iwm, DBG, "LINK: start txq[%d], available "
+			   "credit: %d\n", queue,
+			   iwm_tx_credit_get(&iwm->tx_credit, id));
+		queue_work(iwm->txq[queue].wq, &iwm->txq[queue].worker);
+	}
+}
+
+static void iwm_tx_credit_dec(struct iwm_priv *iwm, int id, int alloc_pages)
+{
+	struct pool_entry *pool;
+	struct spool_entry *spool;
+	int spool_pages;
+
+	IWM_DBG_TX(iwm, DBG, "Allocate %d pages for pool[%d]\n",
+		   alloc_pages, id);
+
+	BUG_ON(id >= IWM_MACS_OUT_GROUPS);
+
+	pool = &iwm->tx_credit.pools[id];
+	spool = &iwm->tx_credit.spools[pool->sid];
+
+	spool_pages = pool->alloc_pages + alloc_pages - pool->min_pages;
+
+	if (pool->alloc_pages >= pool->min_pages)
+		spool->alloc_pages += alloc_pages;
+	else if (spool_pages > 0)
+		spool->alloc_pages += spool_pages;
+
+	pool->alloc_pages += alloc_pages;
+
+	IWM_DBG_TX(iwm, DBG, "Pool[%d] pages alloc: %d, total_freed: %d, "
+		   "Spool[%d] pages alloc: %d\n", id, pool->alloc_pages,
+		   pool->total_freed_pages, pool->sid, spool->alloc_pages);
+}
+
+int iwm_tx_credit_alloc(struct iwm_priv *iwm, int id, int nb)
+{
+	u32 npages = BYTES_TO_PAGES(nb);
+	int ret = 0;
+
+	spin_lock(&iwm->tx_credit.lock);
+
+	if (!iwm_tx_credit_ok(iwm, id, nb)) {
+		IWM_DBG_TX(iwm, DBG, "No credit avaliable for pool[%d]\n", id);
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	iwm_tx_credit_dec(iwm, id, npages);
+
+ out:
+	spin_unlock(&iwm->tx_credit.lock);
+	return ret;
+}
+
+/*
+ * Since we're on an SDIO or USB bus, we are not sharing memory
+ * for storing to be transmitted frames. The host needs to push
+ * them upstream. As a consequence there needs to be a way for
+ * the target to let us know if it can actually take more TX frames
+ * or not. This is what Tx credits are for.
+ *
+ * For each Tx HW queue, we have a Tx pool, and then we have one
+ * unique super pool (spool), which is actually a global pool of
+ * all the UMAC pages.
+ * For each Tx pool we have a min_pages, a max_pages fields, and a
+ * alloc_pages fields. The alloc_pages tracks the number of pages
+ * currently allocated from the tx pool.
+ * Here are the rules to check if given a tx frame we have enough
+ * tx credits for it:
+ * 1) We translate the frame length into a number of UMAC pages.
+ *    Let's call them n_pages.
+ * 2) For the corresponding tx pool, we check if n_pages +
+ *    pool->alloc_pages is higher than pool->min_pages. min_pages
+ *    represent a set of pre-allocated pages on the tx pool. If
+ *    that's the case, then we need to allocate those pages from
+ *    the spool. We can do so until we reach spool->max_pages.
+ * 3) Each tx pool is not allowed to allocate more than pool->max_pages
+ *    from the spool, so once we're over min_pages, we can allocate
+ *    pages from the spool, but not more than max_pages.
+ *
+ * When the tx code path needs to send a tx frame, it checks first
+ * if it has enough tx credits, following those rules. [iwm_tx_credit_get]
+ * If it does, it then updates the pool and spool counters and
+ * then send the frame. [iwm_tx_credit_alloc and iwm_tx_credit_dec]
+ * On the other side, when the UMAC is done transmitting frames, it
+ * will send a credit update notification to the host. This is when
+ * the pool and spool counters gets to be decreased. [iwm_tx_credit_inc,
+ * called from rx.c:iwm_ntf_tx_credit_update]
+ *
+ */
+void iwm_tx_credit_init_pools(struct iwm_priv *iwm,
+			      struct iwm_umac_notif_alive *alive)
+{
+	int i, sid, pool_pages;
+
+	spin_lock(&iwm->tx_credit.lock);
+
+	iwm->tx_credit.pool_nr = le16_to_cpu(alive->page_grp_count);
+	iwm->tx_credit.full_pools_map = 0;
+	memset(&iwm->tx_credit.spools[0], 0, sizeof(struct spool_entry));
+
+	IWM_DBG_TX(iwm, DBG, "Pools number is %d\n", iwm->tx_credit.pool_nr);
+
+	for (i = 0; i < iwm->tx_credit.pool_nr; i++) {
+		__le32 page_grp_state = alive->page_grp_state[i];
+
+		iwm->tx_credit.pools[i].id = GET_VAL32(page_grp_state,
+				UMAC_ALIVE_PAGE_STS_GRP_NUM);
+		iwm->tx_credit.pools[i].sid = GET_VAL32(page_grp_state,
+				UMAC_ALIVE_PAGE_STS_SGRP_NUM);
+		iwm->tx_credit.pools[i].min_pages = GET_VAL32(page_grp_state,
+				UMAC_ALIVE_PAGE_STS_GRP_MIN_SIZE);
+		iwm->tx_credit.pools[i].max_pages = GET_VAL32(page_grp_state,
+				UMAC_ALIVE_PAGE_STS_GRP_MAX_SIZE);
+		iwm->tx_credit.pools[i].alloc_pages = 0;
+		iwm->tx_credit.pools[i].total_freed_pages = 0;
+
+		sid = iwm->tx_credit.pools[i].sid;
+		pool_pages = iwm->tx_credit.pools[i].min_pages;
+
+		if (iwm->tx_credit.spools[sid].max_pages == 0) {
+			iwm->tx_credit.spools[sid].id = sid;
+			iwm->tx_credit.spools[sid].max_pages =
+				GET_VAL32(page_grp_state,
+					  UMAC_ALIVE_PAGE_STS_SGRP_MAX_SIZE);
+			iwm->tx_credit.spools[sid].alloc_pages = 0;
+		}
+
+		iwm->tx_credit.spools[sid].alloc_pages += pool_pages;
+
+		IWM_DBG_TX(iwm, DBG, "Pool idx: %d, id: %d, sid: %d, capacity "
+			   "min: %d, max: %d, pool alloc: %d, total_free: %d, "
+			   "super poll alloc: %d\n",
+			   i, iwm->tx_credit.pools[i].id,
+			   iwm->tx_credit.pools[i].sid,
+			   iwm->tx_credit.pools[i].min_pages,
+			   iwm->tx_credit.pools[i].max_pages,
+			   iwm->tx_credit.pools[i].alloc_pages,
+			   iwm->tx_credit.pools[i].total_freed_pages,
+			   iwm->tx_credit.spools[sid].alloc_pages);
+	}
+
+	spin_unlock(&iwm->tx_credit.lock);
+}
+
+#define IWM_UDMA_HDR_LEN	sizeof(struct iwm_umac_wifi_out_hdr)
+
+static int iwm_tx_build_packet(struct iwm_priv *iwm, struct sk_buff *skb,
+			       int pool_id, u8 *buf)
+{
+	struct iwm_umac_wifi_out_hdr *hdr = (struct iwm_umac_wifi_out_hdr *)buf;
+	struct iwm_udma_wifi_cmd udma_cmd;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_tx_info *tx_info = skb_to_tx_info(skb);
+
+	udma_cmd.count = cpu_to_le16(skb->len +
+				     sizeof(struct iwm_umac_fw_cmd_hdr));
+	/* set EOP to 0 here. iwm_udma_wifi_hdr_set_eop() will be
+	 * called later to set EOP for the last packet. */
+	udma_cmd.eop = 0;
+	udma_cmd.credit_group = pool_id;
+	udma_cmd.ra_tid = tx_info->sta << 4 | tx_info->tid;
+	udma_cmd.lmac_offset = 0;
+
+	umac_cmd.id = REPLY_TX;
+	umac_cmd.count = cpu_to_le16(skb->len);
+	umac_cmd.color = tx_info->color;
+	umac_cmd.resp = 0;
+	umac_cmd.seq_num = cpu_to_le16(iwm_alloc_wifi_cmd_seq(iwm));
+
+	iwm_build_udma_wifi_hdr(iwm, &hdr->hw_hdr, &udma_cmd);
+	iwm_build_umac_hdr(iwm, &hdr->sw_hdr, &umac_cmd);
+
+	memcpy(buf + sizeof(*hdr), skb->data, skb->len);
+
+	return 0;
+}
+
+static int iwm_tx_send_concat_packets(struct iwm_priv *iwm,
+				      struct iwm_tx_queue *txq)
+{
+	int ret;
+
+	if (!txq->concat_count)
+		return 0;
+
+	IWM_DBG_TX(iwm, DBG, "Send concatenated Tx: queue %d, %d bytes\n",
+		   txq->id, txq->concat_count);
+
+	/* mark EOP for the last packet */
+	iwm_udma_wifi_hdr_set_eop(iwm, txq->concat_ptr, 1);
+
+	ret = iwm_bus_send_chunk(iwm, txq->concat_buf, txq->concat_count);
+
+	txq->concat_count = 0;
+	txq->concat_ptr = txq->concat_buf;
+
+	return ret;
+}
+
+#define CONFIG_IWM_TX_CONCATENATED 1
+
+void iwm_tx_worker(struct work_struct *work)
+{
+	struct iwm_priv *iwm;
+	struct iwm_tx_info *tx_info = NULL;
+	struct sk_buff *skb;
+	int cmdlen, ret;
+	struct iwm_tx_queue *txq;
+	int pool_id;
+
+	txq = container_of(work, struct iwm_tx_queue, worker);
+	iwm = container_of(txq, struct iwm_priv, txq[txq->id]);
+
+	pool_id = queue_to_pool_id(txq->id);
+
+	while (!test_bit(pool_id, &iwm->tx_credit.full_pools_map) &&
+	       !skb_queue_empty(&txq->queue)) {
+
+		skb = skb_dequeue(&txq->queue);
+		tx_info = skb_to_tx_info(skb);
+		cmdlen = IWM_UDMA_HDR_LEN + skb->len;
+
+		IWM_DBG_TX(iwm, DBG, "Tx frame on queue %d: skb: 0x%p, sta: "
+			   "%d, color: %d\n", txq->id, skb, tx_info->sta,
+			   tx_info->color);
+
+#if !CONFIG_IWM_TX_CONCATENATED
+		/* temporarily keep this to comparing the performance */
+		ret = iwm_send_packet(iwm, skb, pool_id);
+#else
+
+		if (txq->concat_count + cmdlen > IWM_HAL_CONCATENATE_BUF_SIZE)
+			iwm_tx_send_concat_packets(iwm, txq);
+
+		ret = iwm_tx_credit_alloc(iwm, pool_id, cmdlen);
+		if (ret) {
+			IWM_DBG_TX(iwm, DBG, "not enough tx_credit for queue "
+				   "%d, Tx worker stopped\n", txq->id);
+			skb_queue_head(&txq->queue, skb);
+			break;
+		}
+
+		txq->concat_ptr = txq->concat_buf + txq->concat_count;
+		iwm_tx_build_packet(iwm, skb, pool_id, txq->concat_ptr);
+		txq->concat_count += ALIGN(cmdlen, 16);
+#endif
+		kfree_skb(skb);
+	}
+
+	iwm_tx_send_concat_packets(iwm, txq);
+
+	if (__netif_subqueue_stopped(iwm_to_ndev(iwm), txq->id) &&
+	    !test_bit(pool_id, &iwm->tx_credit.full_pools_map) &&
+	    (skb_queue_len(&txq->queue) < IWM_TX_LIST_SIZE / 2)) {
+		IWM_DBG_TX(iwm, DBG, "LINK: start netif_subqueue[%d]", txq->id);
+		netif_wake_subqueue(iwm_to_ndev(iwm), txq->id);
+	}
+}
+
+int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(netdev);
+	struct net_device *ndev = iwm_to_ndev(iwm);
+	struct wireless_dev *wdev = iwm_to_wdev(iwm);
+	u8 *dst_addr;
+	struct iwm_tx_info *tx_info;
+	struct iwm_tx_queue *txq;
+	struct iwm_sta_info *sta_info;
+	u8 sta_id;
+	u16 queue;
+	int ret;
+
+	if (!test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
+		IWM_DBG_TX(iwm, DBG, "LINK: stop netif_all_queues: "
+			   "not associated\n");
+		netif_tx_stop_all_queues(netdev);
+		goto drop;
+	}
+
+	queue = skb_get_queue_mapping(skb);
+	BUG_ON(queue >= IWM_TX_DATA_QUEUES); /* no iPAN yet */
+
+	txq = &iwm->txq[queue];
+
+	/* No free space for Tx, tx_worker is too slow */
+	if (skb_queue_len(&txq->queue) > IWM_TX_LIST_SIZE) {
+		IWM_DBG_TX(iwm, DBG, "LINK: stop netif_subqueue[%d]\n", queue);
+		netif_stop_subqueue(netdev, queue);
+		return NETDEV_TX_BUSY;
+	}
+
+	ret = ieee80211_data_from_8023(skb, netdev->dev_addr, wdev->iftype,
+				       iwm->bssid, 0);
+	if (ret) {
+		IWM_ERR(iwm, "build wifi header failed\n");
+		goto drop;
+	}
+
+	dst_addr = ((struct ieee80211_hdr *)(skb->data))->addr1;
+
+	for (sta_id = 0; sta_id < IWM_STA_TABLE_NUM; sta_id++) {
+		sta_info = &iwm->sta_table[sta_id];
+		if (sta_info->valid &&
+		    !memcmp(dst_addr, sta_info->addr, ETH_ALEN))
+			break;
+	}
+
+	if (sta_id == IWM_STA_TABLE_NUM) {
+		IWM_ERR(iwm, "STA %pM not found in sta_table, Tx ignored\n",
+			dst_addr);
+		goto drop;
+	}
+
+	tx_info = skb_to_tx_info(skb);
+	tx_info->sta = sta_id;
+	tx_info->color = sta_info->color;
+	/* UMAC uses TID 8 (vs. 0) for non QoS packets */
+	if (sta_info->qos)
+		tx_info->tid = skb->priority;
+	else
+		tx_info->tid = IWM_UMAC_MGMT_TID;
+
+	skb_queue_tail(&iwm->txq[queue].queue, skb);
+
+	queue_work(iwm->txq[queue].wq, &iwm->txq[queue].worker);
+
+	ndev->stats.tx_packets++;
+	ndev->stats.tx_bytes += skb->len;
+	return NETDEV_TX_OK;
+
+ drop:
+	ndev->stats.tx_dropped++;
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/umac.h b/drivers/net/wireless/iwmc3200wifi/umac.h
new file mode 100644
index 0000000..4a95cce
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/umac.h
@@ -0,0 +1,744 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ */
+
+#ifndef __IWM_UMAC_H__
+#define __IWM_UMAC_H__
+
+struct iwm_udma_in_hdr {
+	__le32 cmd;
+	__le32 size;
+} __attribute__ ((packed));
+
+struct iwm_udma_out_nonwifi_hdr {
+	__le32 cmd;
+	__le32 addr;
+	__le32 op1_sz;
+	__le32 op2;
+} __attribute__ ((packed));
+
+struct iwm_udma_out_wifi_hdr {
+	__le32 cmd;
+	__le32 meta_data;
+} __attribute__ ((packed));
+
+/* Sequence numbering */
+#define UMAC_WIFI_SEQ_NUM_BASE		1
+#define UMAC_WIFI_SEQ_NUM_MAX		0x4000
+#define UMAC_NONWIFI_SEQ_NUM_BASE	1
+#define UMAC_NONWIFI_SEQ_NUM_MAX	0x10
+
+/* MAC address address */
+#define WICO_MAC_ADDRESS_ADDR               0x604008F8
+
+/* RA / TID */
+#define UMAC_HDI_ACT_TBL_IDX_TID_POS                  0
+#define UMAC_HDI_ACT_TBL_IDX_TID_SEED                 0xF
+
+#define UMAC_HDI_ACT_TBL_IDX_RA_POS                   4
+#define UMAC_HDI_ACT_TBL_IDX_RA_SEED                  0xF
+
+#define UMAC_HDI_ACT_TBL_IDX_RA_UMAC                  0xF
+#define UMAC_HDI_ACT_TBL_IDX_TID_UMAC                 0x9
+#define UMAC_HDI_ACT_TBL_IDX_TID_LMAC                 0xA
+
+#define UMAC_HDI_ACT_TBL_IDX_HOST_CMD \
+	((UMAC_HDI_ACT_TBL_IDX_RA_UMAC << UMAC_HDI_ACT_TBL_IDX_RA_POS) |\
+	 (UMAC_HDI_ACT_TBL_IDX_TID_UMAC << UMAC_HDI_ACT_TBL_IDX_TID_POS))
+#define UMAC_HDI_ACT_TBL_IDX_UMAC_CMD \
+	((UMAC_HDI_ACT_TBL_IDX_RA_UMAC << UMAC_HDI_ACT_TBL_IDX_RA_POS) |\
+	(UMAC_HDI_ACT_TBL_IDX_TID_LMAC << UMAC_HDI_ACT_TBL_IDX_TID_POS))
+
+/* iwm_umac_notif_alive.page_grp_state Group number -- bits [3:0] */
+#define UMAC_ALIVE_PAGE_STS_GRP_NUM_POS		0
+#define UMAC_ALIVE_PAGE_STS_GRP_NUM_SEED	0xF
+
+/* iwm_umac_notif_alive.page_grp_state Super group number -- bits [7:4] */
+#define UMAC_ALIVE_PAGE_STS_SGRP_NUM_POS	4
+#define UMAC_ALIVE_PAGE_STS_SGRP_NUM_SEED	0xF
+
+/* iwm_umac_notif_alive.page_grp_state Group min size -- bits [15:8] */
+#define UMAC_ALIVE_PAGE_STS_GRP_MIN_SIZE_POS	8
+#define UMAC_ALIVE_PAGE_STS_GRP_MIN_SIZE_SEED	0xFF
+
+/* iwm_umac_notif_alive.page_grp_state Group max size -- bits [23:16] */
+#define UMAC_ALIVE_PAGE_STS_GRP_MAX_SIZE_POS	16
+#define UMAC_ALIVE_PAGE_STS_GRP_MAX_SIZE_SEED	0xFF
+
+/* iwm_umac_notif_alive.page_grp_state Super group max size -- bits [31:24] */
+#define UMAC_ALIVE_PAGE_STS_SGRP_MAX_SIZE_POS	24
+#define UMAC_ALIVE_PAGE_STS_SGRP_MAX_SIZE_SEED	0xFF
+
+/* Barkers */
+#define UMAC_REBOOT_BARKER		0xdeadbeef
+#define UMAC_ACK_BARKER			0xfeedbabe
+#define UMAC_PAD_TERMINAL		0xadadadad
+
+/* UMAC JMP address */
+#define UMAC_MU_FW_INST_DATA_12_ADDR    0xBF0000
+
+/* iwm_umac_hdi_out_hdr.cmd OP code -- bits [3:0] */
+#define UMAC_HDI_OUT_CMD_OPCODE_POS	0
+#define UMAC_HDI_OUT_CMD_OPCODE_SEED	0xF
+
+/* iwm_umac_hdi_out_hdr.cmd End-Of-Transfer -- bits [10:10] */
+#define UMAC_HDI_OUT_CMD_EOT_POS	10
+#define UMAC_HDI_OUT_CMD_EOT_SEED	0x1
+
+/* iwm_umac_hdi_out_hdr.cmd UTFD only usage -- bits [11:11] */
+#define UMAC_HDI_OUT_CMD_UTFD_ONLY_POS	11
+#define UMAC_HDI_OUT_CMD_UTFD_ONLY_SEED	0x1
+
+/* iwm_umac_hdi_out_hdr.cmd Non-WiFi HW sequence number -- bits [12:15] */
+#define UDMA_HDI_OUT_CMD_NON_WIFI_HW_SEQ_NUM_POS   12
+#define UDMA_HDI_OUT_CMD_NON_WIFI_HW_SEQ_NUM_SEED  0xF
+
+/* iwm_umac_hdi_out_hdr.cmd Signature -- bits [31:16] */
+#define UMAC_HDI_OUT_CMD_SIGNATURE_POS	16
+#define UMAC_HDI_OUT_CMD_SIGNATURE_SEED	0xFFFF
+
+/* iwm_umac_hdi_out_hdr.meta_data Byte count -- bits [11:0] */
+#define UMAC_HDI_OUT_BYTE_COUNT_POS	0
+#define UMAC_HDI_OUT_BYTE_COUNT_SEED	0xFFF
+
+/* iwm_umac_hdi_out_hdr.meta_data Credit group -- bits [15:12] */
+#define UMAC_HDI_OUT_CREDIT_GRP_POS	12
+#define UMAC_HDI_OUT_CREDIT_GRP_SEED	0xF
+
+/* iwm_umac_hdi_out_hdr.meta_data RA/TID -- bits [23:16] */
+#define UMAC_HDI_OUT_RATID_POS		16
+#define UMAC_HDI_OUT_RATID_SEED		0xFF
+
+/* iwm_umac_hdi_out_hdr.meta_data LMAC offset -- bits [31:24] */
+#define UMAC_HDI_OUT_LMAC_OFFSET_POS	24
+#define UMAC_HDI_OUT_LMAC_OFFSET_SEED	0xFF
+
+/* Signature */
+#define UMAC_HDI_OUT_SIGNATURE		0xCBBC
+
+/* buffer alignment */
+#define UMAC_HDI_BUF_ALIGN_MSK		0xF
+
+/*  iwm_umac_hdi_in_hdr.cmd OP code -- bits [3:0] */
+#define UMAC_HDI_IN_CMD_OPCODE_POS                0
+#define UMAC_HDI_IN_CMD_OPCODE_SEED               0xF
+
+/*  iwm_umac_hdi_in_hdr.cmd Non-WiFi API response -- bits [6:4] */
+#define UMAC_HDI_IN_CMD_NON_WIFI_RESP_POS         4
+#define UMAC_HDI_IN_CMD_NON_WIFI_RESP_SEED        0x7
+
+/* iwm_umac_hdi_in_hdr.cmd WiFi API source -- bits [5:4] */
+#define UMAC_HDI_IN_CMD_SOURCE_POS                4
+#define UMAC_HDI_IN_CMD_SOURCE_SEED               0x3
+
+/* iwm_umac_hdi_in_hdr.cmd WiFi API EOT -- bits [6:6] */
+#define UMAC_HDI_IN_CMD_EOT_POS                   6
+#define UMAC_HDI_IN_CMD_EOT_SEED                  0x1
+
+/* iwm_umac_hdi_in_hdr.cmd timestamp present -- bits [7:7] */
+#define UMAC_HDI_IN_CMD_TIME_STAMP_PRESENT_POS    7
+#define UMAC_HDI_IN_CMD_TIME_STAMP_PRESENT_SEED   0x1
+
+/* iwm_umac_hdi_in_hdr.cmd WiFi Non-last AMSDU -- bits [8:8] */
+#define UMAC_HDI_IN_CMD_NON_LAST_AMSDU_POS        8
+#define UMAC_HDI_IN_CMD_NON_LAST_AMSDU_SEED       0x1
+
+/* iwm_umac_hdi_in_hdr.cmd WiFi HW sequence number -- bits [31:9] */
+#define UMAC_HDI_IN_CMD_HW_SEQ_NUM_POS            9
+#define UMAC_HDI_IN_CMD_HW_SEQ_NUM_SEED           0x7FFFFF
+
+/* iwm_umac_hdi_in_hdr.cmd Non-WiFi HW sequence number -- bits [12:15] */
+#define UDMA_HDI_IN_CMD_NON_WIFI_HW_SEQ_NUM_POS   12
+#define UDMA_HDI_IN_CMD_NON_WIFI_HW_SEQ_NUM_SEED  0xF
+
+/* iwm_umac_hdi_in_hdr.cmd Non-WiFi HW signature -- bits [16:31] */
+#define UDMA_HDI_IN_CMD_NON_WIFI_HW_SIG_POS       16
+#define UDMA_HDI_IN_CMD_NON_WIFI_HW_SIG_SEED      0xFFFF
+
+/* Fixed Non-WiFi signature */
+#define UDMA_HDI_IN_CMD_NON_WIFI_HW_SIG           0xCBBC
+
+/* IN NTFY op-codes */
+#define UMAC_NOTIFY_OPCODE_ALIVE		0xA1
+#define UMAC_NOTIFY_OPCODE_INIT_COMPLETE	0xA2
+#define UMAC_NOTIFY_OPCODE_WIFI_CORE_STATUS	0xA3
+#define UMAC_NOTIFY_OPCODE_ERROR		0xA4
+#define UMAC_NOTIFY_OPCODE_DEBUG		0xA5
+#define UMAC_NOTIFY_OPCODE_WIFI_IF_WRAPPER	0xB0
+#define UMAC_NOTIFY_OPCODE_STATS		0xB1
+#define UMAC_NOTIFY_OPCODE_PAGE_DEALLOC		0xB3
+#define UMAC_NOTIFY_OPCODE_RX_TICKET		0xB4
+#define UMAC_NOTIFY_OPCODE_MAX		        (UMAC_NOTIFY_OPCODE_RX_TICKET -\
+						UMAC_NOTIFY_OPCODE_ALIVE + 1)
+#define UMAC_NOTIFY_OPCODE_FIRST		(UMAC_NOTIFY_OPCODE_ALIVE)
+
+/* HDI OUT OP CODE */
+#define UMAC_HDI_OUT_OPCODE_PING		0x0
+#define UMAC_HDI_OUT_OPCODE_READ		0x1
+#define UMAC_HDI_OUT_OPCODE_WRITE		0x2
+#define UMAC_HDI_OUT_OPCODE_JUMP		0x3
+#define UMAC_HDI_OUT_OPCODE_REBOOT		0x4
+#define UMAC_HDI_OUT_OPCODE_WRITE_PERSISTENT	0x5
+#define UMAC_HDI_OUT_OPCODE_READ_PERSISTENT	0x6
+#define UMAC_HDI_OUT_OPCODE_READ_MODIFY_WRITE	0x7
+/* #define UMAC_HDI_OUT_OPCODE_RESERVED		0x8..0xA */
+#define UMAC_HDI_OUT_OPCODE_WRITE_AUX_REG	0xB
+#define UMAC_HDI_OUT_OPCODE_WIFI		0xF
+
+/* HDI IN OP CODE -- Non WiFi*/
+#define UMAC_HDI_IN_OPCODE_PING			0x0
+#define UMAC_HDI_IN_OPCODE_READ			0x1
+#define UMAC_HDI_IN_OPCODE_WRITE		0x2
+#define UMAC_HDI_IN_OPCODE_WRITE_PERSISTENT	0x5
+#define UMAC_HDI_IN_OPCODE_READ_PERSISTENT	0x6
+#define UMAC_HDI_IN_OPCODE_READ_MODIFY_WRITE	0x7
+#define UMAC_HDI_IN_OPCODE_EP_MGMT		0x8
+#define UMAC_HDI_IN_OPCODE_CREDIT_CHANGE	0x9
+#define UMAC_HDI_IN_OPCODE_CTRL_DATABASE	0xA
+#define UMAC_HDI_IN_OPCODE_WRITE_AUX_REG	0xB
+#define UMAC_HDI_IN_OPCODE_NONWIFI_MAX \
+		(UMAC_HDI_IN_OPCODE_WRITE_AUX_REG + 1)
+#define UMAC_HDI_IN_OPCODE_WIFI			0xF
+
+/* HDI IN SOURCE */
+#define UMAC_HDI_IN_SOURCE_FHRX			0x0
+#define UMAC_HDI_IN_SOURCE_UDMA			0x1
+#define UMAC_HDI_IN_SOURCE_FW			0x2
+#define UMAC_HDI_IN_SOURCE_RESERVED		0x3
+
+/* OUT CMD op-codes */
+#define UMAC_CMD_OPCODE_ECHO                    0x01
+#define UMAC_CMD_OPCODE_HALT                    0x02
+#define UMAC_CMD_OPCODE_RESET                   0x03
+#define UMAC_CMD_OPCODE_BULK_EP_INACT_TIMEOUT   0x09
+#define UMAC_CMD_OPCODE_URB_CANCEL_ACK          0x0A
+#define UMAC_CMD_OPCODE_DCACHE_FLUSH            0x0B
+#define UMAC_CMD_OPCODE_EEPROM_PROXY            0x0C
+#define UMAC_CMD_OPCODE_TX_ECHO                 0x0D
+#define UMAC_CMD_OPCODE_DBG_MON                 0x0E
+#define UMAC_CMD_OPCODE_INTERNAL_TX             0x0F
+#define UMAC_CMD_OPCODE_SET_PARAM_FIX           0x10
+#define UMAC_CMD_OPCODE_SET_PARAM_VAR           0x11
+#define UMAC_CMD_OPCODE_GET_PARAM               0x12
+#define UMAC_CMD_OPCODE_DBG_EVENT_WRAPPER       0x13
+#define UMAC_CMD_OPCODE_TARGET                  0x14
+#define UMAC_CMD_OPCODE_STATISTIC_REQUEST       0x15
+#define UMAC_CMD_OPCODE_GET_CHAN_INFO_LIST	0x16
+#define UMAC_CMD_OPCODE_SET_PARAM_LIST		0x17
+#define UMAC_CMD_OPCODE_GET_PARAM_LIST		0x18
+#define UMAC_CMD_OPCODE_BASE_WRAPPER            0xFA
+#define UMAC_CMD_OPCODE_LMAC_WRAPPER            0xFB
+#define UMAC_CMD_OPCODE_HW_TEST_WRAPPER         0xFC
+#define UMAC_CMD_OPCODE_WIFI_IF_WRAPPER         0xFD
+#define UMAC_CMD_OPCODE_WIFI_WRAPPER            0xFE
+#define UMAC_CMD_OPCODE_WIFI_PASS_THROUGH       0xFF
+
+/* UMAC WiFi interface op-codes */
+#define UMAC_WIFI_IF_CMD_SET_PROFILE                     0x11
+#define UMAC_WIFI_IF_CMD_INVALIDATE_PROFILE              0x12
+#define UMAC_WIFI_IF_CMD_SET_EXCLUDE_LIST                0x13
+#define UMAC_WIFI_IF_CMD_SCAN_REQUEST                    0x14
+#define UMAC_WIFI_IF_CMD_SCAN_CONFIG                     0x15
+#define UMAC_WIFI_IF_CMD_ADD_WEP40_KEY                   0x16
+#define UMAC_WIFI_IF_CMD_ADD_WEP104_KEY                  0x17
+#define UMAC_WIFI_IF_CMD_ADD_TKIP_KEY                    0x18
+#define UMAC_WIFI_IF_CMD_ADD_CCMP_KEY                    0x19
+#define UMAC_WIFI_IF_CMD_REMOVE_KEY                      0x1A
+#define UMAC_WIFI_IF_CMD_GLOBAL_TX_KEY_ID                0x1B
+#define UMAC_WIFI_IF_CMD_SET_HOST_EXTENDED_IE            0x1C
+#define UMAC_WIFI_IF_CMD_GET_SUPPORTED_CHANNELS          0x1E
+#define UMAC_WIFI_IF_CMD_TX_PWR_TRIGGER                  0x20
+
+/* UMAC WiFi interface ports */
+#define UMAC_WIFI_IF_FLG_PORT_DEF                        0x00
+#define UMAC_WIFI_IF_FLG_PORT_PAN                        0x01
+#define UMAC_WIFI_IF_FLG_PORT_PAN_INVALID                WIFI_IF_FLG_PORT_DEF
+
+/* UMAC WiFi interface actions */
+#define UMAC_WIFI_IF_FLG_ACT_GET                         0x10
+#define UMAC_WIFI_IF_FLG_ACT_SET                         0x20
+
+/* iwm_umac_fw_cmd_hdr.meta_data byte count -- bits [11:0] */
+#define UMAC_FW_CMD_BYTE_COUNT_POS            0
+#define UMAC_FW_CMD_BYTE_COUNT_SEED           0xFFF
+
+/* iwm_umac_fw_cmd_hdr.meta_data status -- bits [15:12] */
+#define UMAC_FW_CMD_STATUS_POS                12
+#define UMAC_FW_CMD_STATUS_SEED               0xF
+
+/* iwm_umac_fw_cmd_hdr.meta_data full TX command by Driver -- bits [16:16] */
+#define UMAC_FW_CMD_TX_DRV_FULL_CMD_POS       16
+#define UMAC_FW_CMD_TX_DRV_FULL_CMD_SEED      0x1
+
+/* iwm_umac_fw_cmd_hdr.meta_data TX command by FW -- bits [17:17] */
+#define UMAC_FW_CMD_TX_FW_CMD_POS             17
+#define UMAC_FW_CMD_TX_FW_CMD_SEED            0x1
+
+/* iwm_umac_fw_cmd_hdr.meta_data TX plaintext mode -- bits [18:18] */
+#define UMAC_FW_CMD_TX_PLAINTEXT_POS          18
+#define UMAC_FW_CMD_TX_PLAINTEXT_SEED         0x1
+
+/* iwm_umac_fw_cmd_hdr.meta_data STA color -- bits [22:20] */
+#define UMAC_FW_CMD_TX_STA_COLOR_POS          20
+#define UMAC_FW_CMD_TX_STA_COLOR_SEED         0x7
+
+/* iwm_umac_fw_cmd_hdr.meta_data TX life time (TU) -- bits [31:24] */
+#define UMAC_FW_CMD_TX_LIFETIME_TU_POS        24
+#define UMAC_FW_CMD_TX_LIFETIME_TU_SEED       0xFF
+
+/* iwm_dev_cmd_hdr.flags Response required -- bits [5:5] */
+#define UMAC_DEV_CMD_FLAGS_RESP_REQ_POS		5
+#define UMAC_DEV_CMD_FLAGS_RESP_REQ_SEED	0x1
+
+/* iwm_dev_cmd_hdr.flags Aborted command -- bits [6:6] */
+#define UMAC_DEV_CMD_FLAGS_ABORT_POS		6
+#define UMAC_DEV_CMD_FLAGS_ABORT_SEED		0x1
+
+/* iwm_dev_cmd_hdr.flags Internal command -- bits [7:7] */
+#define DEV_CMD_FLAGS_FLD_INTERNAL_POS		7
+#define DEV_CMD_FLAGS_FLD_INTERNAL_SEED		0x1
+
+/* Rx */
+/* Rx actions */
+#define IWM_RX_TICKET_DROP           0x0
+#define IWM_RX_TICKET_RELEASE        0x1
+#define IWM_RX_TICKET_SNIFFER        0x2
+#define IWM_RX_TICKET_ENQUEUE        0x3
+
+/* Rx flags */
+#define IWM_RX_TICKET_PAD_SIZE_MSK        0x2
+#define IWM_RX_TICKET_SPECIAL_SNAP_MSK    0x4
+#define IWM_RX_TICKET_AMSDU_MSK           0x8
+#define IWM_RX_TICKET_DROP_REASON_POS       4
+#define IWM_RX_TICKET_DROP_REASON_MSK (0x1F << RX_TICKET_FLAGS_DROP_REASON_POS)
+
+#define IWM_RX_DROP_NO_DROP                          0x0
+#define IWM_RX_DROP_BAD_CRC                          0x1
+/* L2P no address match */
+#define IWM_RX_DROP_LMAC_ADDR_FILTER                 0x2
+/* Multicast address not in list */
+#define IWM_RX_DROP_MCAST_ADDR_FILTER                0x3
+/* Control frames are not sent to the driver */
+#define IWM_RX_DROP_CTL_FRAME                        0x4
+/* Our frame is back */
+#define IWM_RX_DROP_OUR_TX                           0x5
+/* Association class filtering */
+#define IWM_RX_DROP_CLASS_FILTER                     0x6
+/* Duplicated frame */
+#define IWM_RX_DROP_DUPLICATE_FILTER                 0x7
+/* Decryption error */
+#define IWM_RX_DROP_SEC_ERR                          0x8
+/* Unencrypted frame while encryption is on */
+#define IWM_RX_DROP_SEC_NO_ENCRYPTION                0x9
+/* Replay check failure */
+#define IWM_RX_DROP_SEC_REPLAY_ERR                   0xa
+/* uCode and FW key color mismatch, check before replay */
+#define IWM_RX_DROP_SEC_KEY_COLOR_MISMATCH           0xb
+#define IWM_RX_DROP_SEC_TKIP_COUNTER_MEASURE         0xc
+/* No fragmentations Db is found */
+#define IWM_RX_DROP_FRAG_NO_RESOURCE                 0xd
+/* Fragmention Db has seqCtl mismatch Vs. non-1st frag */
+#define IWM_RX_DROP_FRAG_ERR                         0xe
+#define IWM_RX_DROP_FRAG_LOST                        0xf
+#define IWM_RX_DROP_FRAG_COMPLETE                    0x10
+/* Should be handled by UMAC */
+#define IWM_RX_DROP_MANAGEMENT                       0x11
+/* STA not found by UMAC */
+#define IWM_RX_DROP_NO_STATION                       0x12
+/* NULL or QoS NULL */
+#define IWM_RX_DROP_NULL_DATA                        0x13
+#define IWM_RX_DROP_BA_REORDER_OLD_SEQCTL            0x14
+#define IWM_RX_DROP_BA_REORDER_DUPLICATE             0x15
+
+struct iwm_rx_ticket {
+	__le16 action;
+	__le16 id;
+	__le16 flags;
+	u8 payload_offset; /* includes: MAC header, pad, IV */
+	u8 tail_len; /* includes: MIC, ICV, CRC (w/o STATUS) */
+} __attribute__ ((packed));
+
+struct iwm_rx_mpdu_hdr {
+	__le16 len;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/* UMAC SW WIFI API */
+
+struct iwm_dev_cmd_hdr {
+	u8 cmd;
+	u8 flags;
+	__le16 seq_num;
+} __attribute__ ((packed));
+
+struct iwm_umac_fw_cmd_hdr {
+	__le32 meta_data;
+	struct iwm_dev_cmd_hdr cmd;
+} __attribute__ ((packed));
+
+struct iwm_umac_wifi_out_hdr {
+	struct iwm_udma_out_wifi_hdr hw_hdr;
+	struct iwm_umac_fw_cmd_hdr sw_hdr;
+} __attribute__ ((packed));
+
+struct iwm_umac_nonwifi_out_hdr {
+	struct iwm_udma_out_nonwifi_hdr hw_hdr;
+} __attribute__ ((packed));
+
+struct iwm_umac_wifi_in_hdr {
+	struct iwm_udma_in_hdr hw_hdr;
+	struct iwm_umac_fw_cmd_hdr sw_hdr;
+} __attribute__ ((packed));
+
+struct iwm_umac_nonwifi_in_hdr {
+	struct iwm_udma_in_hdr hw_hdr;
+	__le32 time_stamp;
+} __attribute__ ((packed));
+
+#define IWM_UMAC_PAGE_SIZE	0x200
+
+/* Notify structures */
+struct iwm_fw_version {
+	u8 minor;
+	u8 major;
+	__le16 id;
+};
+
+struct iwm_fw_build {
+	u8 type;
+	u8 subtype;
+	u8 platform;
+	u8 opt;
+};
+
+struct iwm_fw_alive_hdr {
+	struct iwm_fw_version ver;
+	struct iwm_fw_build build;
+	__le32 os_build;
+	__le32 log_hdr_addr;
+	__le32 log_buf_addr;
+	__le32 sys_timer_addr;
+};
+
+#define WAIT_NOTIF_TIMEOUT     (2 * HZ)
+#define SCAN_COMPLETE_TIMEOUT  (3 * HZ)
+
+#define UMAC_NTFY_ALIVE_STATUS_ERR		0xDEAD
+#define UMAC_NTFY_ALIVE_STATUS_OK		0xCAFE
+
+#define UMAC_NTFY_INIT_COMPLETE_STATUS_ERR	0xDEAD
+#define UMAC_NTFY_INIT_COMPLETE_STATUS_OK	0xCAFE
+
+#define UMAC_NTFY_WIFI_CORE_STATUS_LINK_EN      0x40
+#define UMAC_NTFY_WIFI_CORE_STATUS_MLME_EN      0x80
+
+#define IWM_MACS_OUT_GROUPS	6
+#define IWM_MACS_OUT_SGROUPS	1
+
+
+#define WIFI_IF_NTFY_ASSOC_START			0x80
+#define WIFI_IF_NTFY_ASSOC_COMPLETE			0x81
+#define WIFI_IF_NTFY_PROFILE_INVALIDATE_COMPLETE	0x82
+#define WIFI_IF_NTFY_CONNECTION_TERMINATED		0x83
+#define WIFI_IF_NTFY_SCAN_COMPLETE			0x84
+#define WIFI_IF_NTFY_STA_TABLE_CHANGE			0x85
+#define WIFI_IF_NTFY_EXTENDED_IE_REQUIRED		0x86
+#define WIFI_IF_NTFY_RADIO_PREEMPTION			0x87
+#define WIFI_IF_NTFY_BSS_TRK_TABLE_CHANGED		0x88
+#define WIFI_IF_NTFY_BSS_TRK_ENTRIES_REMOVED		0x89
+#define WIFI_IF_NTFY_LINK_QUALITY_STATISTICS		0x8A
+#define WIFI_IF_NTFY_MGMT_FRAME				0x8B
+
+/* DEBUG INDICATIONS */
+#define WIFI_DBG_IF_NTFY_SCAN_SUPER_JOB_START		0xE0
+#define WIFI_DBG_IF_NTFY_SCAN_SUPER_JOB_COMPLETE	0xE1
+#define WIFI_DBG_IF_NTFY_SCAN_CHANNEL_START		0xE2
+#define WIFI_DBG_IF_NTFY_SCAN_CHANNEL_RESULT		0xE3
+#define WIFI_DBG_IF_NTFY_SCAN_MINI_JOB_START		0xE4
+#define WIFI_DBG_IF_NTFY_SCAN_MINI_JOB_COMPLETE		0xE5
+#define WIFI_DBG_IF_NTFY_CNCT_ATC_START			0xE6
+#define WIFI_DBG_IF_NTFY_COEX_NOTIFICATION		0xE7
+#define WIFI_DBG_IF_NTFY_COEX_HANDLE_ENVELOP		0xE8
+#define WIFI_DBG_IF_NTFY_COEX_HANDLE_RELEASE_ENVELOP	0xE9
+
+/* Notification structures */
+struct iwm_umac_notif_wifi_if {
+	struct iwm_umac_wifi_in_hdr hdr;
+	u8 status;
+	u8 flags;
+	__le16 buf_size;
+} __attribute__ ((packed));
+
+#define UMAC_ROAM_REASON_FIRST_SELECTION	0x1
+#define UMAC_ROAM_REASON_AP_DEAUTH		0x2
+#define UMAC_ROAM_REASON_AP_CONNECT_LOST	0x3
+#define UMAC_ROAM_REASON_RSSI			0x4
+#define UMAC_ROAM_REASON_AP_ASSISTED_ROAM	0x5
+#define UMAC_ROAM_REASON_IBSS_COALESCING	0x6
+
+struct iwm_umac_notif_assoc_start {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le32 roam_reason;
+	u8 bssid[ETH_ALEN];
+	u8 reserved[2];
+} __attribute__ ((packed));
+
+#define UMAC_ASSOC_COMPLETE_SUCCESS		0x0
+#define UMAC_ASSOC_COMPLETE_FAILURE		0x1
+
+struct iwm_umac_notif_assoc_complete {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le32 status;
+	u8 bssid[ETH_ALEN];
+	u8 band;
+	u8 channel;
+} __attribute__ ((packed));
+
+#define UMAC_PROFILE_INVALID_ASSOC_TIMEOUT	0x0
+#define UMAC_PROFILE_INVALID_ROAM_TIMEOUT	0x1
+#define UMAC_PROFILE_INVALID_REQUEST		0x2
+#define UMAC_PROFILE_INVALID_RF_PREEMPTED	0x3
+
+struct iwm_umac_notif_profile_invalidate {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le32 reason;
+} __attribute__ ((packed));
+
+#define UMAC_SCAN_RESULT_SUCCESS  0x0
+#define UMAC_SCAN_RESULT_ABORTED  0x1
+#define UMAC_SCAN_RESULT_REJECTED 0x2
+#define UMAC_SCAN_RESULT_FAILED   0x3
+
+struct iwm_umac_notif_scan_complete {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le32 type;
+	__le32 result;
+	u8 seq_num;
+} __attribute__ ((packed));
+
+#define UMAC_OPCODE_ADD_MODIFY	0x0
+#define UMAC_OPCODE_REMOVE	0x1
+#define UMAC_OPCODE_CLEAR_ALL	0x2
+
+#define UMAC_STA_FLAG_QOS	0x1
+
+struct iwm_umac_notif_sta_info {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le32 opcode;
+	u8 mac_addr[ETH_ALEN];
+	u8 sta_id; /* bits 0-3: station ID, bits 4-7: station color */
+	u8 flags;
+} __attribute__ ((packed));
+
+#define UMAC_BAND_2GHZ 0
+#define UMAC_BAND_5GHZ 1
+
+#define UMAC_CHANNEL_WIDTH_20MHZ 0
+#define UMAC_CHANNEL_WIDTH_40MHZ 1
+
+struct iwm_umac_notif_bss_info {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le32 type;
+	__le32 timestamp;
+	__le16 table_idx;
+	__le16 frame_len;
+	u8 band;
+	u8 channel;
+	s8 rssi;
+	u8 reserved;
+	u8 frame_buf[1];
+} __attribute__ ((packed));
+
+#define IWM_BSS_REMOVE_INDEX_MSK           0x0fff
+#define IWM_BSS_REMOVE_FLAGS_MSK           0xfc00
+
+#define IWM_BSS_REMOVE_FLG_AGE             0x1000
+#define IWM_BSS_REMOVE_FLG_TIMEOUT         0x2000
+#define IWM_BSS_REMOVE_FLG_TABLE_FULL      0x4000
+
+struct iwm_umac_notif_bss_removed {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le32 count;
+	__le16 entries[0];
+} __attribute__ ((packed));
+
+struct iwm_umac_notif_mgt_frame {
+	struct iwm_umac_notif_wifi_if mlme_hdr;
+	__le16 len;
+	u8 frame[1];
+} __attribute__ ((packed));
+
+struct iwm_umac_notif_alive {
+	struct iwm_umac_wifi_in_hdr hdr;
+	__le16 status;
+	__le16 reserved1;
+	struct iwm_fw_alive_hdr alive_data;
+	__le16 reserved2;
+	__le16 page_grp_count;
+	__le32 page_grp_state[IWM_MACS_OUT_GROUPS];
+} __attribute__ ((packed));
+
+struct iwm_umac_notif_init_complete {
+	__le16 status;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/* error categories */
+enum {
+	UMAC_SYS_ERR_CAT_NONE = 0,
+	UMAC_SYS_ERR_CAT_BOOT,
+	UMAC_SYS_ERR_CAT_UMAC,
+	UMAC_SYS_ERR_CAT_UAXM,
+	UMAC_SYS_ERR_CAT_LMAC,
+	UMAC_SYS_ERR_CAT_MAX
+};
+
+struct iwm_fw_error_hdr {
+	__le32 category;
+	__le32 status;
+	__le32 pc;
+	__le32 blink1;
+	__le32 blink2;
+	__le32 ilink1;
+	__le32 ilink2;
+	__le32 data1;
+	__le32 data2;
+	__le32 line_num;
+	__le32 umac_status;
+	__le32 lmac_status;
+	__le32 sdio_status;
+} __attribute__ ((packed));
+
+struct iwm_umac_notif_error {
+	struct iwm_umac_wifi_in_hdr hdr;
+	struct iwm_fw_error_hdr err;
+} __attribute__ ((packed));
+
+#define UMAC_DEALLOC_NTFY_CHANGES_CNT_POS	0
+#define UMAC_DEALLOC_NTFY_CHANGES_CNT_SEED	0xff
+#define UMAC_DEALLOC_NTFY_CHANGES_MSK_POS	8
+#define UMAC_DEALLOC_NTFY_CHANGES_MSK_SEED	0xffffff
+#define UMAC_DEALLOC_NTFY_PAGE_CNT_POS		0
+#define UMAC_DEALLOC_NTFY_PAGE_CNT_SEED		0xffffff
+#define UMAC_DEALLOC_NTFY_GROUP_NUM_POS		24
+#define UMAC_DEALLOC_NTFY_GROUP_NUM_SEED	0xf
+
+struct iwm_umac_notif_page_dealloc {
+	struct iwm_umac_wifi_in_hdr hdr;
+	__le32 changes;
+	__le32 grp_info[IWM_MACS_OUT_GROUPS];
+} __attribute__ ((packed));
+
+struct iwm_umac_notif_wifi_status {
+	struct iwm_umac_wifi_in_hdr hdr;
+	__le16 status;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwm_umac_notif_rx_ticket {
+	struct iwm_umac_wifi_in_hdr hdr;
+	u8 num_tickets;
+	u8 reserved[3];
+	struct iwm_rx_ticket tickets[1];
+} __attribute__ ((packed));
+
+/* Tx/Rx rates window (number of max of last update window per second) */
+#define UMAC_NTF_RATE_SAMPLE_NR	4
+
+#define IWM_UMAC_MGMT_TID	8
+#define IWM_UMAC_TID_NR		8
+
+struct iwm_umac_notif_stats {
+	struct iwm_umac_wifi_in_hdr hdr;
+	__le32 flags;
+	__le32 timestamp;
+	__le16 tid_load[IWM_UMAC_TID_NR + 2]; /* 1 non-QoS + 1 dword align */
+	__le16 tx_rate[UMAC_NTF_RATE_SAMPLE_NR];
+	__le16 rx_rate[UMAC_NTF_RATE_SAMPLE_NR];
+	s32 rssi_dbm;
+	s32 noise_dbm;
+	__le32 supp_rates;
+	__le32 missed_beacons;
+	__le32 rx_beacons;
+	__le32 rx_dir_pkts;
+	__le32 rx_nondir_pkts;
+	__le32 rx_multicast;
+	__le32 rx_errors;
+	__le32 rx_drop_other_bssid;
+	__le32 rx_drop_decode;
+	__le32 rx_drop_reassembly;
+	__le32 rx_drop_bad_len;
+	__le32 rx_drop_overflow;
+	__le32 rx_drop_crc;
+	__le32 rx_drop_missed;
+	__le32 tx_dir_pkts;
+	__le32 tx_nondir_pkts;
+	__le32 tx_failure;
+	__le32 tx_errors;
+	__le32 tx_drop_max_retry;
+	__le32 tx_err_abort;
+	__le32 tx_err_carrier;
+	__le32 rx_bytes;
+	__le32 tx_bytes;
+	__le32 tx_power;
+	__le32 tx_max_power;
+	__le32 roam_threshold;
+	__le32 ap_assoc_nr;
+	__le32 scan_full;
+	__le32 scan_abort;
+	__le32 ap_nr;
+	__le32 roam_nr;
+	__le32 roam_missed_beacons;
+	__le32 roam_rssi;
+	__le32 roam_unassoc;
+	__le32 roam_deauth;
+	__le32 roam_ap_loadblance;
+} __attribute__ ((packed));
+
+/* WiFi interface wrapper header */
+struct iwm_umac_wifi_if {
+	u8 oid;
+	u8 flags;
+	__le16 buf_size;
+} __attribute__ ((packed));
+
+#define IWM_SEQ_NUM_HOST_MSK	0x0000
+#define IWM_SEQ_NUM_UMAC_MSK	0x4000
+#define IWM_SEQ_NUM_LMAC_MSK	0x8000
+#define IWM_SEQ_NUM_MSK		0xC000
+
+#endif
diff --git a/drivers/net/wireless/iwmc3200wifi/wext.c b/drivers/net/wireless/iwmc3200wifi/wext.c
new file mode 100644
index 0000000..584c94d
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/wext.c
@@ -0,0 +1,723 @@
+/*
+ * Intel Wireless Multicomm 3200 WiFi driver
+ *
+ * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ * Samuel Ortiz <samuel.ortiz@intel.com>
+ * Zhu Yi <yi.zhu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <net/cfg80211.h>
+#include <net/iw_handler.h>
+
+#include "iwm.h"
+#include "umac.h"
+#include "commands.h"
+#include "debug.h"
+
+static struct iw_statistics *iwm_get_wireless_stats(struct net_device *dev)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	struct iw_statistics *wstats = &iwm->wstats;
+
+	if (!test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
+		memset(wstats, 0, sizeof(struct iw_statistics));
+		wstats->qual.updated = IW_QUAL_ALL_INVALID;
+	}
+
+	return wstats;
+}
+
+static int iwm_wext_siwfreq(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct iw_freq *freq, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+
+	if (freq->flags == IW_FREQ_AUTO)
+		return 0;
+
+	/* frequency/channel can only be set in IBSS mode */
+	if (iwm->conf.mode != UMAC_MODE_IBSS)
+		return -EOPNOTSUPP;
+
+	return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
+}
+
+static int iwm_wext_giwfreq(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct iw_freq *freq, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+
+	if (iwm->conf.mode == UMAC_MODE_IBSS)
+		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
+
+	freq->e = 0;
+	freq->m = iwm->channel;
+
+	return 0;
+}
+
+static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info *info,
+			  struct sockaddr *ap_addr, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+
+	if (iwm->conf.mode == UMAC_MODE_IBSS)
+		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
+
+	if (!test_bit(IWM_STATUS_READY, &iwm->status))
+		return -EIO;
+
+	if (is_zero_ether_addr(ap_addr->sa_data) ||
+	    is_broadcast_ether_addr(ap_addr->sa_data)) {
+		IWM_DBG_WEXT(iwm, DBG, "clear mandatory bssid %pM\n",
+			     iwm->umac_profile->bssid[0]);
+		memset(&iwm->umac_profile->bssid[0], 0, ETH_ALEN);
+		iwm->umac_profile->bss_num = 0;
+	} else {
+		IWM_DBG_WEXT(iwm, DBG, "add mandatory bssid %pM\n",
+			     ap_addr->sa_data);
+		memcpy(&iwm->umac_profile->bssid[0], ap_addr->sa_data,
+		       ETH_ALEN);
+		iwm->umac_profile->bss_num = 1;
+	}
+
+	if (iwm->umac_profile_active) {
+		if (!memcmp(&iwm->umac_profile->bssid[0], iwm->bssid, ETH_ALEN))
+			return 0;
+
+		iwm_invalidate_mlme_profile(iwm);
+	}
+
+	if (iwm->umac_profile->ssid.ssid_len)
+		return iwm_send_mlme_profile(iwm);
+
+	return 0;
+}
+
+static int iwm_wext_giwap(struct net_device *dev, struct iw_request_info *info,
+			  struct sockaddr *ap_addr, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+
+	switch (iwm->conf.mode) {
+	case UMAC_MODE_IBSS:
+		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
+	case UMAC_MODE_BSS:
+		if (test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
+			ap_addr->sa_family = ARPHRD_ETHER;
+			memcpy(&ap_addr->sa_data, iwm->bssid, ETH_ALEN);
+		} else
+			memset(&ap_addr->sa_data, 0, ETH_ALEN);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int iwm_wext_siwessid(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_point *data, char *ssid)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	size_t len = data->length;
+	int ret;
+
+	if (iwm->conf.mode == UMAC_MODE_IBSS)
+		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
+
+	if (!test_bit(IWM_STATUS_READY, &iwm->status))
+		return -EIO;
+
+	if (len > 0 && ssid[len - 1] == '\0')
+		len--;
+
+	if (iwm->umac_profile_active) {
+		if (iwm->umac_profile->ssid.ssid_len == len &&
+		    !memcmp(iwm->umac_profile->ssid.ssid, ssid, len))
+			return 0;
+
+		ret = iwm_invalidate_mlme_profile(iwm);
+		if (ret < 0) {
+			IWM_ERR(iwm, "Couldn't invalidate profile\n");
+			return ret;
+		}
+	}
+
+	iwm->umac_profile->ssid.ssid_len = len;
+	memcpy(iwm->umac_profile->ssid.ssid, ssid, len);
+
+	return iwm_send_mlme_profile(iwm);
+}
+
+static int iwm_wext_giwessid(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_point *data, char *ssid)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+
+	if (iwm->conf.mode == UMAC_MODE_IBSS)
+		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
+
+	if (!test_bit(IWM_STATUS_READY, &iwm->status))
+		return -EIO;
+
+	data->length = iwm->umac_profile->ssid.ssid_len;
+	if (data->length) {
+		memcpy(ssid, iwm->umac_profile->ssid.ssid, data->length);
+		data->flags = 1;
+	} else
+		data->flags = 0;
+
+	return 0;
+}
+
+static struct iwm_key *
+iwm_key_init(struct iwm_priv *iwm, u8 key_idx, bool in_use,
+	     struct iw_encode_ext *ext, u8 alg)
+{
+	struct iwm_key *key = &iwm->keys[key_idx];
+
+	memset(key, 0, sizeof(struct iwm_key));
+	memcpy(key->hdr.mac, ext->addr.sa_data, ETH_ALEN);
+	key->hdr.key_idx = key_idx;
+	if (is_broadcast_ether_addr(ext->addr.sa_data))
+		key->hdr.multicast = 1;
+
+	key->in_use = in_use;
+	key->flags = ext->ext_flags;
+	key->alg = alg;
+	key->key_len = ext->key_len;
+	memcpy(key->key, ext->key, ext->key_len);
+
+	return key;
+}
+
+static int iwm_wext_giwrate(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct iw_param *rate, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+
+	rate->value = iwm->rate * 1000000;
+
+	return 0;
+}
+
+static int iwm_wext_siwencode(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *erq, char *key_buf)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	struct iwm_key *uninitialized_var(key);
+	int idx, i, uninitialized_var(alg), remove = 0, ret;
+
+	IWM_DBG_WEXT(iwm, DBG, "key len: %d\n", erq->length);
+	IWM_DBG_WEXT(iwm, DBG, "flags: 0x%x\n", erq->flags);
+
+	if (!iwm->umac_profile) {
+		IWM_ERR(iwm, "UMAC profile not allocated yet\n");
+		return -ENODEV;
+	}
+
+	if (erq->length == WLAN_KEY_LEN_WEP40) {
+		alg = UMAC_CIPHER_TYPE_WEP_40;
+		iwm->umac_profile->sec.ucast_cipher = UMAC_CIPHER_TYPE_WEP_40;
+		iwm->umac_profile->sec.mcast_cipher = UMAC_CIPHER_TYPE_WEP_40;
+	} else if (erq->length == WLAN_KEY_LEN_WEP104) {
+		alg = UMAC_CIPHER_TYPE_WEP_104;
+		iwm->umac_profile->sec.ucast_cipher = UMAC_CIPHER_TYPE_WEP_104;
+		iwm->umac_profile->sec.mcast_cipher = UMAC_CIPHER_TYPE_WEP_104;
+	}
+
+	if (erq->flags & IW_ENCODE_RESTRICTED)
+		iwm->umac_profile->sec.auth_type = UMAC_AUTH_TYPE_LEGACY_PSK;
+	else
+		iwm->umac_profile->sec.auth_type = UMAC_AUTH_TYPE_OPEN;
+
+	idx = erq->flags & IW_ENCODE_INDEX;
+	if (idx == 0) {
+		if (iwm->default_key)
+			for (i = 0; i < IWM_NUM_KEYS; i++) {
+				if (iwm->default_key == &iwm->keys[i]) {
+					idx = i;
+					break;
+				}
+			}
+		else
+			iwm->default_key = &iwm->keys[idx];
+	} else if (idx < 1 || idx > 4) {
+		return -EINVAL;
+	} else
+		idx--;
+
+	if (erq->flags & IW_ENCODE_DISABLED)
+		remove = 1;
+	else if (erq->length == 0) {
+		if (!iwm->keys[idx].in_use)
+			return -EINVAL;
+		iwm->default_key = &iwm->keys[idx];
+	}
+
+	if (erq->length) {
+		key = &iwm->keys[idx];
+		memset(key, 0, sizeof(struct iwm_key));
+		memset(key->hdr.mac, 0xff, ETH_ALEN);
+		key->hdr.key_idx = idx;
+		key->hdr.multicast = 1;
+		key->in_use = !remove;
+		key->alg = alg;
+		key->key_len = erq->length;
+		memcpy(key->key, key_buf, erq->length);
+
+		IWM_DBG_WEXT(iwm, DBG, "Setting key %d, default: %d\n",
+			     idx, !!iwm->default_key);
+	}
+
+	if (remove) {
+		if ((erq->flags & IW_ENCODE_NOKEY) || (erq->length == 0)) {
+			int j;
+			for (j = 0; j < IWM_NUM_KEYS; j++)
+				if (iwm->keys[j].in_use) {
+					struct iwm_key *k = &iwm->keys[j];
+
+					k->in_use = 0;
+					ret = iwm_set_key(iwm, remove, 0, k);
+					if (ret < 0)
+						return ret;
+				}
+
+			iwm->umac_profile->sec.ucast_cipher =
+							UMAC_CIPHER_TYPE_NONE;
+			iwm->umac_profile->sec.mcast_cipher =
+							UMAC_CIPHER_TYPE_NONE;
+			iwm->umac_profile->sec.auth_type =
+							UMAC_AUTH_TYPE_OPEN;
+
+			return 0;
+		} else {
+			key->in_use = 0;
+			return iwm_set_key(iwm, remove, 0, key);
+		}
+	}
+
+	/*
+	 * If we havent set a profile yet, we cant set keys.
+	 * Keys will be pushed after we're associated.
+	 */
+	if (!iwm->umac_profile_active)
+		return 0;
+
+	/*
+	 * If there is a current active profile, but no
+	 * default key, it's not worth trying to associate again.
+	 */
+	if (!iwm->default_key)
+		return 0;
+
+	/*
+	 * Here we have an active profile, but a key setting changed.
+	 * We thus have to invalidate the current profile, and push the
+	 * new one. Keys will be pushed when association takes place.
+	 */
+	ret = iwm_invalidate_mlme_profile(iwm);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't invalidate profile\n");
+		return ret;
+	}
+
+	return iwm_send_mlme_profile(iwm);
+}
+
+static int iwm_wext_giwencode(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *erq, char *key)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	int idx, i;
+
+	idx = erq->flags & IW_ENCODE_INDEX;
+	if (idx < 1 || idx > 4) {
+		idx = -1;
+		if (!iwm->default_key) {
+			erq->length = 0;
+			erq->flags |= IW_ENCODE_NOKEY;
+			return 0;
+		} else
+			for (i = 0; i < IWM_NUM_KEYS; i++) {
+				if (iwm->default_key == &iwm->keys[i]) {
+					idx = i;
+					break;
+				}
+			}
+		if (idx < 0)
+			return -EINVAL;
+	} else
+		idx--;
+
+	erq->flags = idx + 1;
+
+	if (!iwm->keys[idx].in_use) {
+		erq->length = 0;
+		erq->flags |= IW_ENCODE_DISABLED;
+		return 0;
+	}
+
+	memcpy(key, iwm->keys[idx].key,
+	       min_t(int, erq->length, iwm->keys[idx].key_len));
+	erq->length = iwm->keys[idx].key_len;
+	erq->flags |= IW_ENCODE_ENABLED;
+
+	if (iwm->umac_profile->mode == UMAC_MODE_BSS) {
+		switch (iwm->umac_profile->sec.auth_type) {
+		case UMAC_AUTH_TYPE_OPEN:
+			erq->flags |= IW_ENCODE_OPEN;
+			break;
+		default:
+			erq->flags |= IW_ENCODE_RESTRICTED;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int iwm_set_wpa_version(struct iwm_priv *iwm, u8 wpa_version)
+{
+	if (wpa_version & IW_AUTH_WPA_VERSION_WPA2)
+		iwm->umac_profile->sec.flags = UMAC_SEC_FLG_RSNA_ON_MSK;
+	else if (wpa_version & IW_AUTH_WPA_VERSION_WPA)
+		iwm->umac_profile->sec.flags = UMAC_SEC_FLG_WPA_ON_MSK;
+	else
+		iwm->umac_profile->sec.flags = UMAC_SEC_FLG_LEGACY_PROFILE;
+
+	return 0;
+}
+
+static int iwm_wext_siwpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *wrq, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	u32 power_index;
+
+	if (wrq->disabled) {
+		power_index = IWM_POWER_INDEX_MIN;
+		goto set;
+	} else
+		power_index = IWM_POWER_INDEX_DEFAULT;
+
+	switch (wrq->flags & IW_POWER_MODE) {
+	case IW_POWER_ON:
+	case IW_POWER_MODE:
+	case IW_POWER_ALL_R:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+ set:
+	if (power_index == iwm->conf.power_index)
+		return 0;
+
+	iwm->conf.power_index = power_index;
+
+	return iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				       CFG_POWER_INDEX, iwm->conf.power_index);
+}
+
+static int iwm_wext_giwpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *wrqu, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+
+	wrqu->power.disabled = (iwm->conf.power_index == IWM_POWER_INDEX_MIN);
+
+	return 0;
+}
+
+static int iwm_set_key_mgt(struct iwm_priv *iwm, u8 key_mgt)
+{
+	u8 *auth_type = &iwm->umac_profile->sec.auth_type;
+
+	if (key_mgt == IW_AUTH_KEY_MGMT_802_1X)
+		*auth_type = UMAC_AUTH_TYPE_8021X;
+	else if (key_mgt == IW_AUTH_KEY_MGMT_PSK) {
+		if (iwm->umac_profile->sec.flags &
+		    (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK))
+			*auth_type = UMAC_AUTH_TYPE_RSNA_PSK;
+		else
+			*auth_type = UMAC_AUTH_TYPE_LEGACY_PSK;
+	} else {
+		IWM_ERR(iwm, "Invalid key mgt: 0x%x\n", key_mgt);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int iwm_set_cipher(struct iwm_priv *iwm, u8 cipher, u8 ucast)
+{
+	u8 *profile_cipher = ucast ? &iwm->umac_profile->sec.ucast_cipher :
+		&iwm->umac_profile->sec.mcast_cipher;
+
+	switch (cipher) {
+	case IW_AUTH_CIPHER_NONE:
+		*profile_cipher = UMAC_CIPHER_TYPE_NONE;
+		break;
+	case IW_AUTH_CIPHER_WEP40:
+		*profile_cipher = UMAC_CIPHER_TYPE_WEP_40;
+		break;
+	case IW_AUTH_CIPHER_TKIP:
+		*profile_cipher = UMAC_CIPHER_TYPE_TKIP;
+		break;
+	case IW_AUTH_CIPHER_CCMP:
+		*profile_cipher = UMAC_CIPHER_TYPE_CCMP;
+		break;
+	case IW_AUTH_CIPHER_WEP104:
+		*profile_cipher = UMAC_CIPHER_TYPE_WEP_104;
+		break;
+	default:
+		IWM_ERR(iwm, "Unsupported cipher: 0x%x\n", cipher);
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static int iwm_set_auth_alg(struct iwm_priv *iwm, u8 auth_alg)
+{
+	u8 *auth_type = &iwm->umac_profile->sec.auth_type;
+
+	switch (auth_alg) {
+	case IW_AUTH_ALG_OPEN_SYSTEM:
+		*auth_type = UMAC_AUTH_TYPE_OPEN;
+		break;
+	case IW_AUTH_ALG_SHARED_KEY:
+		if (iwm->umac_profile->sec.flags &
+		    (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK)) {
+			if (*auth_type == UMAC_AUTH_TYPE_8021X)
+				return -EINVAL;
+			*auth_type = UMAC_AUTH_TYPE_RSNA_PSK;
+		} else {
+			*auth_type = UMAC_AUTH_TYPE_LEGACY_PSK;
+		}
+		break;
+	case IW_AUTH_ALG_LEAP:
+	default:
+		IWM_ERR(iwm, "Unsupported auth alg: 0x%x\n", auth_alg);
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static int iwm_wext_siwauth(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct iw_param *data, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	int ret;
+
+	if ((data->flags) &
+	    (IW_AUTH_WPA_VERSION | IW_AUTH_KEY_MGMT |
+	     IW_AUTH_WPA_ENABLED | IW_AUTH_80211_AUTH_ALG)) {
+		/* We need to invalidate the current profile */
+		if (iwm->umac_profile_active) {
+			ret = iwm_invalidate_mlme_profile(iwm);
+			if (ret < 0) {
+				IWM_ERR(iwm, "Couldn't invalidate profile\n");
+				return ret;
+			}
+		}
+	}
+
+	switch (data->flags & IW_AUTH_INDEX) {
+	case IW_AUTH_WPA_VERSION:
+		return iwm_set_wpa_version(iwm, data->value);
+		break;
+	case IW_AUTH_CIPHER_PAIRWISE:
+		return iwm_set_cipher(iwm, data->value, 1);
+		break;
+	case IW_AUTH_CIPHER_GROUP:
+		return iwm_set_cipher(iwm, data->value, 0);
+		break;
+	case IW_AUTH_KEY_MGMT:
+		return iwm_set_key_mgt(iwm, data->value);
+		break;
+	case IW_AUTH_80211_AUTH_ALG:
+		return iwm_set_auth_alg(iwm, data->value);
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static int iwm_wext_giwauth(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct iw_param *data, char *extra)
+{
+	return 0;
+}
+
+static int iwm_wext_siwencodeext(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_point *erq, char *extra)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	struct iwm_key *key;
+	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
+	int uninitialized_var(alg), idx, i, remove = 0;
+
+	IWM_DBG_WEXT(iwm, DBG, "alg: 0x%x\n", ext->alg);
+	IWM_DBG_WEXT(iwm, DBG, "key len: %d\n", ext->key_len);
+	IWM_DBG_WEXT(iwm, DBG, "ext_flags: 0x%x\n", ext->ext_flags);
+	IWM_DBG_WEXT(iwm, DBG, "flags: 0x%x\n", erq->flags);
+	IWM_DBG_WEXT(iwm, DBG, "length: 0x%x\n", erq->length);
+
+	switch (ext->alg) {
+	case IW_ENCODE_ALG_NONE:
+		remove = 1;
+		break;
+	case IW_ENCODE_ALG_WEP:
+		if (ext->key_len == WLAN_KEY_LEN_WEP40)
+			alg = UMAC_CIPHER_TYPE_WEP_40;
+		else if (ext->key_len == WLAN_KEY_LEN_WEP104)
+			alg = UMAC_CIPHER_TYPE_WEP_104;
+		else {
+			IWM_ERR(iwm, "Invalid key length: %d\n", ext->key_len);
+			return -EINVAL;
+		}
+
+		break;
+	case IW_ENCODE_ALG_TKIP:
+		alg = UMAC_CIPHER_TYPE_TKIP;
+		break;
+	case IW_ENCODE_ALG_CCMP:
+		alg = UMAC_CIPHER_TYPE_CCMP;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	idx = erq->flags & IW_ENCODE_INDEX;
+
+	if (idx == 0) {
+		if (iwm->default_key)
+			for (i = 0; i < IWM_NUM_KEYS; i++) {
+				if (iwm->default_key == &iwm->keys[i]) {
+					idx = i;
+					break;
+				}
+			}
+	} else if (idx < 1 || idx > 4) {
+		return -EINVAL;
+	} else
+		idx--;
+
+	if (erq->flags & IW_ENCODE_DISABLED)
+		remove = 1;
+	else if ((erq->length == 0) ||
+		 (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)) {
+		iwm->default_key = &iwm->keys[idx];
+		if (iwm->umac_profile_active && ext->alg == IW_ENCODE_ALG_WEP)
+			return iwm_set_tx_key(iwm, idx);
+	}
+
+	key = iwm_key_init(iwm, idx, !remove, ext, alg);
+
+	return iwm_set_key(iwm, remove, !iwm->default_key, key);
+}
+
+static const iw_handler iwm_handlers[] =
+{
+	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
+	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
+	(iw_handler) NULL,				/* SIOCSIWNWID */
+	(iw_handler) NULL,				/* SIOCGIWNWID */
+	(iw_handler) iwm_wext_siwfreq,			/* SIOCSIWFREQ */
+	(iw_handler) iwm_wext_giwfreq,			/* SIOCGIWFREQ */
+	(iw_handler) cfg80211_wext_siwmode,		/* SIOCSIWMODE */
+	(iw_handler) cfg80211_wext_giwmode,		/* SIOCGIWMODE */
+	(iw_handler) NULL,				/* SIOCSIWSENS */
+	(iw_handler) NULL,				/* SIOCGIWSENS */
+	(iw_handler) NULL /* not used */,		/* SIOCSIWRANGE */
+	(iw_handler) cfg80211_wext_giwrange,		/* SIOCGIWRANGE */
+	(iw_handler) NULL /* not used */,		/* SIOCSIWPRIV */
+	(iw_handler) NULL /* kernel code */,		/* SIOCGIWPRIV */
+	(iw_handler) NULL /* not used */,		/* SIOCSIWSTATS */
+	(iw_handler) NULL /* kernel code */,		/* SIOCGIWSTATS */
+	(iw_handler) NULL,				/* SIOCSIWSPY */
+	(iw_handler) NULL,				/* SIOCGIWSPY */
+	(iw_handler) NULL,				/* SIOCSIWTHRSPY */
+	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
+	(iw_handler) iwm_wext_siwap,	                /* SIOCSIWAP */
+	(iw_handler) iwm_wext_giwap,			/* SIOCGIWAP */
+	(iw_handler) NULL,			        /* SIOCSIWMLME */
+	(iw_handler) NULL,				/* SIOCGIWAPLIST */
+	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
+	(iw_handler) cfg80211_wext_giwscan,		/* SIOCGIWSCAN */
+	(iw_handler) iwm_wext_siwessid,			/* SIOCSIWESSID */
+	(iw_handler) iwm_wext_giwessid,			/* SIOCGIWESSID */
+	(iw_handler) NULL,				/* SIOCSIWNICKN */
+	(iw_handler) NULL,				/* SIOCGIWNICKN */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) NULL,				/* SIOCSIWRATE */
+	(iw_handler) iwm_wext_giwrate,			/* SIOCGIWRATE */
+	(iw_handler) cfg80211_wext_siwrts,		/* SIOCSIWRTS */
+	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
+	(iw_handler) cfg80211_wext_siwfrag,	        /* SIOCSIWFRAG */
+	(iw_handler) cfg80211_wext_giwfrag,		/* SIOCGIWFRAG */
+	(iw_handler) NULL,				/* SIOCSIWTXPOW */
+	(iw_handler) NULL,				/* SIOCGIWTXPOW */
+	(iw_handler) NULL,				/* SIOCSIWRETRY */
+	(iw_handler) NULL,				/* SIOCGIWRETRY */
+	(iw_handler) iwm_wext_siwencode,		/* SIOCSIWENCODE */
+	(iw_handler) iwm_wext_giwencode,		/* SIOCGIWENCODE */
+	(iw_handler) iwm_wext_siwpower,			/* SIOCSIWPOWER */
+	(iw_handler) iwm_wext_giwpower,			/* SIOCGIWPOWER */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) NULL,                              /* SIOCSIWGENIE */
+	(iw_handler) NULL,				/* SIOCGIWGENIE */
+	(iw_handler) iwm_wext_siwauth,			/* SIOCSIWAUTH */
+	(iw_handler) iwm_wext_giwauth,			/* SIOCGIWAUTH */
+	(iw_handler) iwm_wext_siwencodeext,	        /* SIOCSIWENCODEEXT */
+	(iw_handler) NULL,				/* SIOCGIWENCODEEXT */
+	(iw_handler) NULL,				/* SIOCSIWPMKSA */
+	(iw_handler) NULL,				/* -- hole -- */
+};
+
+const struct iw_handler_def iwm_iw_handler_def = {
+	.num_standard	= ARRAY_SIZE(iwm_handlers),
+	.standard	= (iw_handler *) iwm_handlers,
+	.get_wireless_stats = iwm_get_wireless_stats,
+};
+
-- 
1.6.0.4

