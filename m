Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56836 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894Ab2JaNBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 09:01:08 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3 1/2] wireless: Driver for 60GHz card wil6210
Date: Wed, 31 Oct 2012 15:00:42 +0200
Message-ID: <1351688443-23254-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121031_140120_854637_767E8737)
In-Reply-To: <1351688443-23254-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1351688443-23254-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Card wil6210 by Wilocity supports operation on the 60GHz band

This development snapshot supports:

- STA, PCP and monitor modes
- security works for STA mode, not integrated yet for PCP mode
- PCP limited to 1 connected STA

In the STA and PCP mode, one can assemble fully functional BSS.
throughput of 1.2Gbps achieved with iperf

In the monitor mode, card is able to capture either control or non-control frames
(due to hardware limitation).

Wil6210 card have on-board flash memory for the firmware, card comes pre-flushed
and no firmware download required on the run time.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Kconfig     |   47 ++
 drivers/net/wireless/ath/wil6210/Makefile    |   15 +
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  821 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c   |  506 ++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  342 +++++++++
 drivers/net/wireless/ath/wil6210/main.c      |  400 +++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |  159 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  239 +++++++
 drivers/net/wireless/ath/wil6210/sysfs.c     |  134 ++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  821 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h      |  352 ++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  370 ++++++++++
 drivers/net/wireless/ath/wil6210/wmi.c       |  964 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h       |  928 +++++++++++++++++++++++++
 14 files changed, 6098 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/Kconfig
 create mode 100644 drivers/net/wireless/ath/wil6210/Makefile
 create mode 100644 drivers/net/wireless/ath/wil6210/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/wil6210/debugfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/interrupt.c
 create mode 100644 drivers/net/wireless/ath/wil6210/main.c
 create mode 100644 drivers/net/wireless/ath/wil6210/netdev.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pcie_bus.c
 create mode 100644 drivers/net/wireless/ath/wil6210/sysfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil6210.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.h

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
new file mode 100644
index 0000000..b927adc
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -0,0 +1,47 @@
+config WIL6210
+	tristate "Wilocity 60g WiFi card wil6210 support"
+	depends on CFG80211
+	depends on PCI
+	depends on EXPERIMENTAL
+	default n
+	---help---
+	  This module adds support for wireless adapter based on
+	  wil6210 chip by Wilocity. It supports operation on the
+	  60g band, covered by the IEEE802.11ad standard.
+	  If you choose to build it as a module, it will be called
+	  wil6210
+
+config WIL6210_ISR_COR
+	bool "Use Clear-On-Read mode for ISR registers for wil6210"
+	depends on WIL6210
+	default y
+	---help---
+	  ISR registers on wil6210 chip may operate in either
+	  COR (Clear-On-Read) or W1C (Write-1-to-Clear) mode.
+	  For production code, use COR (say y); is default since
+	  it saves extra target transaction;
+	  For ISR debug, use W1C (say n); is allows to monitor ISR
+	  registers with debugfs. If COR were used, ISR would
+	  self-clear when accessed for debug purposes, it makes
+	  such monitoring impossible.
+	  Say y unless you debug interrupts
+
+config WIL6210_DEBUG_TXRX
+	bool "Debug Tx/Rx path for wil6210"
+	depends on WIL6210
+	default n
+	---help---
+	  Enables Tx/Rx path debug. It will emitt lots of messages.
+	  Every Tx and Rx frame will be dumped, with some
+	  auxiliary information.
+	  Use with care.
+
+config WIL6210_DEBUG_IRQ
+	bool "Debug IRQ flows for wil6210"
+	depends on WIL6210
+	default n
+	---help---
+	  Enables IRQ debug. It will emitt lots of messages.
+	  For every IRQ its ISR bits will be printed, with
+	  some extra analysis.
+	  Use with care.
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
new file mode 100644
index 0000000..960b2b3
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -0,0 +1,15 @@
+obj-$(CONFIG_WIL6210) += wil6210.o
+
+wil6210-objs := main.o
+wil6210-objs += netdev.o
+wil6210-objs += cfg80211.o
+wil6210-objs += pcie_bus.o
+wil6210-objs += debugfs.o
+wil6210-objs += wmi.o
+wil6210-objs += interrupt.o
+wil6210-objs += txrx.o
+wil6210-objs += sysfs.o
+
+subdir-ccflags-y += -Werror
+subdir-ccflags-y += -D__CHECK_ENDIAN__
+
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
new file mode 100644
index 0000000..7321f0c
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -0,0 +1,821 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/etherdevice.h>
+#include <linux/wireless.h>
+#include <linux/ieee80211.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <net/cfg80211.h>
+
+#include "wil6210.h"
+#include "wmi.h"
+
+#define CHAN60G(_channel, _flags) {				\
+	.band			= IEEE80211_BAND_60GHZ,		\
+	.center_freq		= 56160 + (2160 * (_channel)),	\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 40,				\
+}
+
+static struct ieee80211_channel wil_60ghz_channels[] = {
+	CHAN60G(1, 0),
+	CHAN60G(2, 0),
+	CHAN60G(3, 0),
+/* channel 4 not supported yet */
+};
+
+static struct ieee80211_supported_band wil_band_60ghz = {
+	.channels = wil_60ghz_channels,
+	.n_channels = ARRAY_SIZE(wil_60ghz_channels),
+	.ht_cap = {
+		.ht_supported = true,
+		.cap = 0, /* TODO */
+		.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K, /* TODO */
+		.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8, /* TODO */
+		.mcs = {
+				/* MCS 1..12 - SC PHY */
+			.rx_mask = {0xfe, 0x1f}, /* 1..12 */
+			.tx_params = IEEE80211_HT_MCS_TX_DEFINED, /* TODO */
+		},
+	},
+};
+
+static const struct ieee80211_txrx_stypes
+wil_mgmt_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_GO] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+};
+
+static const u32 wil_cipher_suites[] = {
+	WLAN_CIPHER_SUITE_GCMP,
+};
+
+static void wil_print_channels(struct wil6210_priv *wil)
+{
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+	int i;
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		int j;
+		struct ieee80211_supported_band *band = wiphy->bands[i];
+
+		if (!band)
+			continue;
+
+		for (j = 0; j < band->n_channels; j++) {
+			struct ieee80211_channel *ch = &band->channels[j];
+			wil_info(wil, "ch[%d] : freq %d flags 0x%08x\n",
+				 ch->hw_value, ch->center_freq,
+				 ch->flags);
+		}
+	}
+}
+
+int wil_iftype_nl2wmi(enum nl80211_iftype type)
+{
+	static const struct {
+		enum nl80211_iftype nl;
+		enum wmi_network_type wmi;
+	} __nl2wmi[] = {
+		{NL80211_IFTYPE_ADHOC,		WMI_NETTYPE_ADHOC},
+		{NL80211_IFTYPE_STATION,	WMI_NETTYPE_INFRA},
+		{NL80211_IFTYPE_AP,		WMI_NETTYPE_AP},
+		{NL80211_IFTYPE_P2P_CLIENT,	WMI_NETTYPE_P2P},
+		{NL80211_IFTYPE_P2P_GO,		WMI_NETTYPE_P2P},
+		{NL80211_IFTYPE_MONITOR,	WMI_NETTYPE_ADHOC}, /* FIXME */
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(__nl2wmi); i++) {
+		if (__nl2wmi[i].nl == type)
+			return __nl2wmi[i].wmi;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int wil_cfg80211_get_station(struct wiphy *wiphy,
+				    struct net_device *ndev,
+				    u8 *mac, struct station_info *sinfo)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+	struct wmi_notify_req_cmd cmd = {
+		.cid = 0,
+		.interval_usec = 0,
+	};
+
+	wil_info(wil, "%s(%pM)\n", __func__, mac);
+
+	if (memcmp(mac, wil->dst_addr[0], ETH_ALEN))
+		return -ENOENT;
+	rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
+		      WMI_NOTIFY_REQ_DONE_EVENTID, NULL, 0, 20);
+	if (rc)
+		return rc;
+
+	sinfo->filled |= STATION_INFO_TX_BITRATE;
+	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
+	sinfo->txrate.mcs = wil->stats.bf_mcs;
+	sinfo->filled |= STATION_INFO_RX_BITRATE;
+	sinfo->rxrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
+	sinfo->rxrate.mcs = wil->stats.last_mcs_rx;
+
+	if (test_bit(wil_status_fwconnected, &wil->status)) {
+		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->signal = 12; /* TODO: provide real value */
+	}
+
+	return 0;
+}
+
+static int wil_cfg80211_change_iface(struct wiphy *wiphy,
+				     struct net_device *ndev,
+				     enum nl80211_iftype type, u32 *flags,
+				     struct vif_params *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = wil->wdev;
+	wil_info(wil, "%s()\n", __func__);
+
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+		wil_info(wil, "type: STATION\n");
+		break;
+	case NL80211_IFTYPE_AP:
+		wil_info(wil, "type: AP\n");
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		wil_info(wil, "type: P2P_CLIENT\n");
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		wil_info(wil, "type: P2P_GO\n");
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		wil_info(wil, "type: Monitor\n");
+		if (flags) {
+			wil_info(wil, "Monitor flags: 0x%08x\n", *flags);
+			wil->monitor_flags = *flags;
+		} else {
+			wil->monitor_flags = 0;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	wdev->iftype = type;
+
+	return 0;
+}
+
+static int wil_cfg80211_scan(struct wiphy *wiphy,
+			     struct cfg80211_scan_request *request)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = wil->wdev;
+	struct {
+		struct wmi_start_scan_cmd cmd;
+		u16 chnl[4];
+	} __packed cmd;
+	int i, n;
+
+	wil_info(wil, "%s(%d channels, %d SSIDs)\n", __func__,
+		 request->n_channels, request->n_ssids);
+
+	for (i = 0; i < request->n_ssids; i++) {
+		char prefix[20];
+		struct cfg80211_ssid *ssid = &request->ssids[i];
+		snprintf(prefix, sizeof(prefix), "SSID[%d] : ", i);
+		print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
+			       ssid->ssid, ssid->ssid_len, true);
+	}
+	if (request->ie && request->ie_len)
+		print_hex_dump(KERN_INFO, "IE : ", DUMP_PREFIX_NONE, 16, 1,
+			       request->ie, request->ie_len, true);
+	wil_print_channels(wil);
+
+	if (wil->scan_request) {
+		wil_err(wil, "Already scanning\n");
+		return -EAGAIN;
+	}
+
+	/* check we are client side */
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		break;
+	default:
+		return -EOPNOTSUPP;
+
+	}
+
+	/* FW don't support scan after connection attempt */
+	if (test_bit(wil_status_dontscan, &wil->status)) {
+		wil_err(wil, "Scan after connect attempt not supported\n");
+		return -EBUSY;
+	}
+
+	wil->scan_request = request;
+	cmd.cmd.numChannels = 0;
+	n = min(request->n_channels, 4U);
+	for (i = 0; i < n; i++) {
+		int ch = request->channels[i]->hw_value;
+		if (ch == 0) {
+			wil_err(wil,
+				"Scan requested for unknown frequency %dMhz\n",
+				request->channels[i]->center_freq);
+			continue;
+		}
+		/* 0-based channel indexes */
+		cmd.chnl[cmd.cmd.numChannels++] = ch - 1;
+		wil_info(wil, "Scan for ch %d  : %d MHz\n", ch,
+			 request->channels[i]->center_freq);
+	}
+
+	return wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
+			 cmd.cmd.numChannels * sizeof(cmd.chnl[0]));
+}
+
+static int wil_cfg80211_connect(struct wiphy *wiphy,
+				struct net_device *ndev,
+				struct cfg80211_connect_params *sme)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = wil->wdev;
+	struct cfg80211_bss *bss;
+	struct wmi_connect_cmd conn;
+	const u8 *ssid_eid;
+	const u8 *rsn_eid;
+	int ch;
+	int rc = 0;
+
+	wil_info(wil, "%s()\n", __func__);
+	wil_info(wil, "SME {\n"
+			"  bssid        : %pM\n"
+			"  freq         : %d MHz\n"
+			"  privacy      : %d\n"
+			"  auth_type    : %d\n"
+			"  key_idx      : %d\n"
+			"  flags        : 0x%08x\n"
+			"  wpa_versions : 0x%08x\n"
+			"  cipher_group : 0x%08x\n"
+			"}\n",
+			sme->bssid,
+			sme->channel ? sme->channel->center_freq : 0,
+			sme->privacy,
+			sme->auth_type,
+			sme->key_idx,
+			sme->flags,
+			sme->crypto.wpa_versions,
+			sme->crypto.cipher_group);
+	if (sme->ssid && sme->ssid_len)
+		print_hex_dump(KERN_INFO, "SSID : ", DUMP_PREFIX_NONE, 16, 1,
+			       sme->ssid, sme->ssid_len, true);
+	if (sme->ie && sme->ie_len)
+		print_hex_dump(KERN_INFO, "IE : ", DUMP_PREFIX_NONE, 16, 1,
+			       sme->ie, sme->ie_len, true);
+	if (sme->key && sme->key_len)
+		print_hex_dump(KERN_INFO, "KEY : ", DUMP_PREFIX_NONE, 16, 1,
+			       sme->key, sme->key_len, true);
+	if (wdev->connect_keys)
+		print_hex_dump(KERN_INFO, "CONNKEYS : ", DUMP_PREFIX_NONE,
+			       16, 1, wdev->connect_keys,
+			       sizeof(wdev->connect_keys), true);
+
+	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
+			       sme->ssid, sme->ssid_len,
+			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	if (!bss) {
+		wil_err(wil, "Unable to find BSS\n");
+		return -ENOENT;
+	}
+	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
+	if (!ssid_eid) {
+		wil_err(wil, "No SSID\n");
+		rc = -ENOENT;
+		goto out;
+	}
+	rsn_eid = sme->ie ?
+			cfg80211_find_ie(WLAN_EID_RSN, sme->ie, sme->ie_len) :
+			NULL;
+	if (rsn_eid) {
+		print_hex_dump(KERN_INFO, "RSN IE : ", DUMP_PREFIX_NONE, 16, 1,
+			       rsn_eid, rsn_eid[1] + 2, true);
+		if (sme->ie_len > WMI_MAX_IE_LEN) {
+			rc = -ERANGE;
+			wil_err(wil, "IE too large (%td bytes)\n",
+				sme->ie_len);
+			goto out;
+		}
+		/*
+		 * For secure assoc, send:
+		 * (1) WMI_DELETE_CIPHER_KEY_CMD
+		 * (2) WMI_SET_APPIE_CMD
+		 */
+		rc = wmi_del_cipher_key(wil, 0, bss->bssid);
+		if (rc) {
+			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD failed\n");
+			goto out;
+		}
+		/* WMI_SET_APPIE_CMD */
+		rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_REQ, sme->ie_len, sme->ie);
+		if (rc) {
+			wil_err(wil, "WMI_SET_APPIE_CMD failed\n");
+			goto out;
+		}
+	}
+
+	/* WMI_CONNECT_CMD */
+	conn.networkType = wil_iftype_nl2wmi(wdev->iftype);
+	/* FIXME Firmware works now in PBSS mode(ToDS=0, FromDS=0) */
+	conn.networkType = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
+	if (rsn_eid) {
+		conn.dot11AuthMode = WMI_AUTH11_SHARED;
+		conn.authMode = WMI_AUTH_WPA2_PSK;
+		conn.pairwiseCryptoType = WMI_CRYPT_AES_GCMP;
+		conn.pairwiseCryptoLen = 16;
+	} else {
+		conn.dot11AuthMode = WMI_AUTH11_OPEN;
+		conn.authMode = WMI_AUTH_NONE;
+	}
+
+	conn.ssidLength = min_t(u8, ssid_eid[1], 32);
+	memcpy(conn.ssid, ssid_eid+2, conn.ssidLength);
+
+	ch = bss->channel->hw_value;
+	if (ch == 0) {
+		wil_err(wil, "BSS at unknown frequency %dMhz\n",
+			bss->channel->center_freq);
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+	conn.channel = ch - 1;
+
+	memcpy(conn.bssid, bss->bssid, 6);
+	memcpy(conn.destMacAddr, bss->bssid, 6);
+	/*
+	 * FW don't support scan after connection attempt
+	 */
+	set_bit(wil_status_dontscan, &wil->status);
+
+	rc = wmi_send(wil, WMI_CONNECT_CMDID, &conn, sizeof(conn));
+	if (rc == 0) {
+		/* Connect can take lots of time */
+		mod_timer(&wil->connect_timer,
+			  jiffies + msecs_to_jiffies(2000));
+	}
+ out:
+	cfg80211_put_bss(bss);
+
+	return rc;
+}
+
+static int wil_cfg80211_disconnect(struct wiphy *wiphy,
+				   struct net_device *ndev,
+				   u16 reason_code)
+{
+	int rc;
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	rc = wmi_send(wil, WMI_DISCONNECT_CMDID, NULL, 0);
+
+	return rc;
+}
+
+static int wil_cfg80211_set_txpower(struct wiphy *wiphy,
+				    enum nl80211_tx_power_setting type,
+				    int mbm)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	return 0;
+}
+
+static int wil_cfg80211_get_txpower(struct wiphy *wiphy, int *dbm)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	*dbm = 43; /* TODO: provide real value */
+
+	return 0;
+}
+
+static int wil_cfg80211_mgmt_tx(struct wiphy *wiphy,
+				struct wireless_dev *wdev,
+				struct ieee80211_channel *chan, bool offchan,
+				enum nl80211_channel_type channel_type,
+				bool channel_type_valid, unsigned int wait,
+				const u8 *buf, size_t len, bool no_cck,
+				bool dont_wait_for_ack,	u64 *cookie)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	if (chan)
+		wil_info(wil, "Freq %d\n", chan->center_freq);
+
+	print_hex_dump(KERN_INFO, "mgmt_tx ", DUMP_PREFIX_OFFSET, 16, 1,
+		       buf, len, true);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static void wil_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
+					     struct wireless_dev *wdev,
+					     u16 frame_type, bool reg)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+	wil_info(wil, "frame_type = 0x%04x, reg = %d\n", frame_type, reg);
+	/* TODO: implement */
+}
+
+static int wil_cfg80211_set_channel(struct wiphy *wiphy,
+				    struct ieee80211_channel *chan,
+				    enum nl80211_channel_type channel_type)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+	wil_info(wil, "freq = %d\n", chan->center_freq);
+
+	wil->channel = chan;
+
+	return 0;
+}
+
+static void wil_print_ie(const char *name, const void *data, size_t len)
+{
+	print_hex_dump(KERN_INFO, name, DUMP_PREFIX_OFFSET, 16, 1,
+		       data, len, true);
+}
+
+static void wil_print_bcon_data(struct cfg80211_beacon_data *b)
+{
+	wil_print_ie("head     ", b->head, b->head_len);
+	wil_print_ie("tail     ", b->tail, b->tail_len);
+	wil_print_ie("BCON IE  ", b->beacon_ies, b->beacon_ies_len);
+	wil_print_ie("PROBE    ", b->probe_resp, b->probe_resp_len);
+	wil_print_ie("PROBE IE ", b->proberesp_ies, b->proberesp_ies_len);
+	wil_print_ie("ASSOC IE ", b->assocresp_ies, b->assocresp_ies_len);
+}
+
+static int wil_cfg80211_start_ap(struct wiphy *wiphy,
+				 struct net_device *ndev,
+				 struct cfg80211_ap_settings *info)
+{
+	int rc = 0;
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct ieee80211_channel *channel = info->channel;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	if (!channel) {
+		wil_err(wil, "No channel???\n");
+		return -EINVAL;
+	}
+
+	wil_info(wil, "Channel %d %d MHz\n", channel->hw_value,
+		 channel->center_freq);
+	wil_info(wil, "BI %d DTIM %d\n", info->beacon_interval,
+		 info->dtim_period);
+	wil_print_ie("SSID     ", info->ssid, info->ssid_len);
+	wil_print_bcon_data(&info->beacon);
+
+	rc = wmi_set_ssid(wil, info->ssid_len, info->ssid);
+	if (rc)
+		return rc;
+
+	rc = wmi_set_channel(wil, channel->hw_value);
+	if (rc)
+		return rc;
+
+	/* TODO: complete implementation */
+
+	return 0;
+}
+
+static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
+				      struct net_device *ndev,
+				      struct cfg80211_beacon_data *beacon)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+	wil_print_bcon_data(beacon);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
+				struct net_device *ndev)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_del_station(struct wiphy *wiphy,
+				    struct net_device *ndev,
+				    u8 *mac)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s(%pM)\n", __func__, mac);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_change_station(struct wiphy *wiphy,
+				       struct net_device *ndev,
+				       u8 *mac,
+				       struct station_parameters *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s(%pM) AID %d\n", __func__, mac, params->aid);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_probe_client(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     const u8 *peer, u64 *cookie)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_set_pmksa(struct wiphy *wiphy,
+				  struct net_device *netdev,
+				  struct cfg80211_pmksa *pmksa)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s(%pM)\n", __func__, pmksa->bssid);
+	print_hex_dump(KERN_INFO, "PMK : ", DUMP_PREFIX_NONE, 16, 1,
+		       pmksa->pmkid, WLAN_PMKID_LEN, true);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_del_pmksa(struct wiphy *wiphy,
+				  struct net_device *netdev,
+				  struct cfg80211_pmksa *pmksa)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s(%pM)\n", __func__, pmksa->bssid);
+	print_hex_dump(KERN_INFO, "PMK : ", DUMP_PREFIX_NONE, 16, 1,
+		       pmksa->pmkid, WLAN_PMKID_LEN, true);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_flush_pmksa(struct wiphy *wiphy,
+				    struct net_device *netdev)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s()\n", __func__);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static int wil_cfg80211_add_key(struct wiphy *wiphy,
+				struct net_device *ndev,
+				u8 key_index, bool pairwise,
+				const u8 *mac_addr,
+				struct key_params *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s(%pM, %s cipher 0x%08x)[%d]\n", __func__,
+		 mac_addr, (pairwise ? "PW" : "GR"),
+		 params->cipher, key_index);
+	print_hex_dump(KERN_INFO, "KEY : ", DUMP_PREFIX_NONE, 16, 1,
+		       params->key, params->key_len, true);
+	print_hex_dump(KERN_INFO, "SEQ : ", DUMP_PREFIX_NONE, 16, 1,
+		       params->seq, params->seq_len, true);
+
+	/* group key is not used */
+	if (!pairwise)
+		return 0;
+
+	return wmi_add_cipher_key(wil, key_index, mac_addr,
+				  params->key_len, params->key);
+}
+
+static int wil_cfg80211_del_key(struct wiphy *wiphy,
+				struct net_device *ndev,
+				u8 key_index, bool pairwise,
+				const u8 *mac_addr)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s(%pM, %s)[%d]\n", __func__,
+		 mac_addr, (pairwise ? "PW" : "GR"), key_index);
+
+	/* group key is not used */
+	if (!pairwise)
+		return 0;
+
+	return wmi_del_cipher_key(wil, key_index, mac_addr);
+}
+
+static int wil_cfg80211_get_key(struct wiphy *wiphy,
+				struct net_device *ndev,
+				u8 key_index, bool pairwise,
+				const u8 *mac_addr, void *cookie,
+				void (*callback) (void *cookie,
+						  struct key_params *))
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s(%pM, %s)[%d]\n", __func__,
+		 mac_addr, (pairwise ? "PW" : "GR"), key_index);
+	/* TODO: implement */
+
+	return -ENOENT;
+}
+
+static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
+					struct net_device *ndev,
+					u8 key_index, bool unicast,
+					bool multicast)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_info(wil, "%s([%d])\n", __func__, key_index);
+	/* TODO: implement */
+
+	return 0;
+}
+
+static struct cfg80211_ops wil_cfg80211_ops = {
+	.scan = wil_cfg80211_scan,
+	.connect = wil_cfg80211_connect,
+	.disconnect = wil_cfg80211_disconnect,
+	.set_tx_power = wil_cfg80211_set_txpower,
+	.get_tx_power = wil_cfg80211_get_txpower,
+	.change_virtual_intf = wil_cfg80211_change_iface,
+	.get_station = wil_cfg80211_get_station,
+	.mgmt_tx = wil_cfg80211_mgmt_tx,
+	.mgmt_frame_register = wil_cfg80211_mgmt_frame_register,
+	.set_monitor_channel = wil_cfg80211_set_channel,
+	.start_ap = wil_cfg80211_start_ap,
+	.change_beacon = wil_cfg80211_change_beacon,
+	.stop_ap = wil_cfg80211_stop_ap,
+	.del_station = wil_cfg80211_del_station,
+	.change_station = wil_cfg80211_change_station,
+	.set_pmksa = wil_cfg80211_set_pmksa,
+	.del_pmksa = wil_cfg80211_del_pmksa,
+	.flush_pmksa = wil_cfg80211_flush_pmksa,
+	.add_key = wil_cfg80211_add_key,
+	.get_key = wil_cfg80211_get_key,
+	.del_key = wil_cfg80211_del_key,
+	.set_default_key = wil_cfg80211_set_default_key,
+	.probe_client = wil_cfg80211_probe_client,
+};
+
+static void wil_wiphy_init(struct wiphy *wiphy)
+{
+	/* TODO: set real value */
+	wiphy->max_scan_ssids = 10;
+	wiphy->max_num_pmkids = 0 /* TODO: */;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_MONITOR);
+	/* TODO: enable P2P when integrated with supplicant:
+	 * BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO)
+	 */
+	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
+			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+	dev_warn(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
+		 __func__, wiphy->flags);
+	wiphy->probe_resp_offload =
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
+
+	wiphy->bands[IEEE80211_BAND_60GHZ] = &wil_band_60ghz;
+
+	/* TODO: figure this out */
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	wiphy->cipher_suites = wil_cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(wil_cipher_suites);
+	wiphy->mgmt_stypes = wil_mgmt_stypes;
+}
+
+struct wireless_dev *wil_cfg80211_init(struct device *dev)
+{
+	int rc = 0;
+	struct wireless_dev *wdev;
+
+	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!wdev)
+		return ERR_PTR(-ENOMEM);
+
+	wdev->wiphy = wiphy_new(&wil_cfg80211_ops,
+				sizeof(struct wil6210_priv));
+	if (!wdev->wiphy) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	set_wiphy_dev(wdev->wiphy, dev);
+	wil_wiphy_init(wdev->wiphy);
+
+	rc = wiphy_register(wdev->wiphy);
+	if (rc < 0)
+		goto out_failed_reg;
+
+	return wdev;
+
+out_failed_reg:
+	wiphy_free(wdev->wiphy);
+out:
+	kfree(wdev);
+
+	return ERR_PTR(rc);
+}
+
+void wil_wdev_free(struct wil6210_priv *wil)
+{
+	struct wireless_dev *wdev = wil_to_wdev(wil);
+	struct device *dev = wil_to_dev(wil);
+
+	dev_info(dev, "%s()\n", __func__);
+
+	if (!wdev)
+		return;
+
+	wiphy_unregister(wdev->wiphy);
+	wiphy_free(wdev->wiphy);
+	kfree(wdev);
+}
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
new file mode 100644
index 0000000..608eddd
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -0,0 +1,506 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pci.h>
+#include <linux/rtnetlink.h>
+
+#include "wil6210.h"
+#include "txrx.h"
+
+/* Nasty hack. Better have per device instances */
+static u32 mem_addr;
+static u32 dbg_txdesc_index;
+
+static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
+			    const char *name, struct vring *vring)
+{
+	void __iomem *x = wmi_addr(wil, vring->hwtail);
+
+	seq_printf(s, "VRING %s = {\n", name);
+	seq_printf(s, "  pa     = 0x%016llx\n", (unsigned long long)vring->pa);
+	seq_printf(s, "  va     = 0x%p\n", vring->va);
+	seq_printf(s, "  size   = %d\n", vring->size);
+	seq_printf(s, "  swtail = %d\n", vring->swtail);
+	seq_printf(s, "  swhead = %d\n", vring->swhead);
+	seq_printf(s, "  hwtail = [0x%08x] -> ", vring->hwtail);
+	if (x)
+		seq_printf(s, "0x%08x\n", ioread32(x));
+	else
+		seq_printf(s, "???\n");
+
+	if (vring->va && (vring->size < 1025)) {
+		int i;
+		for (i = 0; i < vring->size; i++) {
+			struct vring_tx_desc *d = &vring->va[i].tx;
+			if ((i % 64) == 0 && (i != 0))
+				seq_printf(s, "\n");
+			seq_printf(s, "%s", (d->dma.status & BIT(0)) ?
+					"S" : (vring->ctx[i] ? "H" : "h"));
+		}
+		seq_printf(s, "\n");
+	}
+	seq_printf(s, "}\n");
+}
+
+static int wil_vring_debugfs_show(struct seq_file *s, void *data)
+{
+	int i;
+	struct wil6210_priv *wil = s->private;
+
+	wil_print_vring(s, wil, "rx", &wil->vring_rx);
+
+	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
+		struct vring *vring = &(wil->vring_tx[i]);
+		if (vring->va) {
+			char name[10];
+			snprintf(name, sizeof(name), "tx_%2d", i);
+			wil_print_vring(s, wil, name, vring);
+		}
+	}
+
+	return 0;
+}
+
+static int wil_vring_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_vring_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_vring = {
+	.open		= wil_vring_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static void wil_print_ring(struct seq_file *s, const char *prefix,
+			   void __iomem *off)
+{
+	struct wil6210_priv *wil = s->private;
+	struct wil6210_mbox_ring r;
+	int rsize;
+	int i;
+
+	wil_memcpy_fromio_32(&r, off, sizeof(r));
+	/*
+	 * we just read memory block from NIC. This memory may be
+	 * garbage. Check validity before using it.
+	 */
+	rsize = r.size / sizeof(struct wil6210_mbox_ring_desc);
+
+	seq_printf(s, "ring %s = {\n", prefix);
+	seq_printf(s, "  base = 0x%08x\n", r.base);
+	seq_printf(s, "  size = 0x%04x bytes -> %d entries\n", r.size, rsize);
+	seq_printf(s, "  tail = 0x%08x\n", r.tail);
+	seq_printf(s, "  head = 0x%08x\n", r.head);
+	seq_printf(s, "  entry size = %d\n", r.entry_size);
+
+	if (r.size % sizeof(struct wil6210_mbox_ring_desc)) {
+		seq_printf(s, "  ??? size is not multiple of %zd, garbage?\n",
+			   sizeof(struct wil6210_mbox_ring_desc));
+		goto out;
+	}
+
+	if (!wmi_addr(wil, r.base) ||
+	    !wmi_addr(wil, r.tail) ||
+	    !wmi_addr(wil, r.head)) {
+		seq_printf(s, "  ??? pointers are garbage?\n");
+		goto out;
+	}
+
+	for (i = 0; i < rsize; i++) {
+		struct wil6210_mbox_ring_desc d;
+		struct wil6210_mbox_hdr hdr;
+		size_t delta = i * sizeof(d);
+		void __iomem *x = wil->csr + HOSTADDR(r.base) + delta;
+
+		wil_memcpy_fromio_32(&d, x, sizeof(d));
+
+		seq_printf(s, "  [%2x] %s %s%s 0x%08x", i,
+			   d.sync ? "F" : "E",
+			   (r.tail - r.base == delta) ? "t" : " ",
+			   (r.head - r.base == delta) ? "h" : " ",
+			   d.addr);
+		if (0 == wmi_read_hdr(wil, d.addr, &hdr)) {
+			seq_printf(s, " -> %04x %04x %04x %02x\n",
+				   hdr.seq, hdr.len, hdr.type, hdr.flags);
+			if (hdr.len <= MAX_MBOXITEM_SIZE) {
+				int n = 0;
+				unsigned char printbuf[16 * 3 + 2];
+				unsigned char databuf[MAX_MBOXITEM_SIZE];
+				void __iomem *src = wmi_buffer(wil, d.addr)
+					+ sizeof(struct wil6210_mbox_hdr);
+				/*
+				 * No need to check @src for validity -
+				 * we already validated @d.addr while
+				 * reading header
+				 */
+				wil_memcpy_fromio_32(databuf, src, hdr.len);
+				while (n < hdr.len) {
+					int l = min(hdr.len - n, 16);
+					hex_dump_to_buffer(databuf + n, l,
+							   16, 1, printbuf,
+							   sizeof(printbuf),
+							   false);
+					seq_printf(s, "      : %s\n", printbuf);
+					n += l;
+				}
+			}
+		} else {
+			seq_printf(s, "\n");
+		}
+	}
+ out:
+	seq_printf(s, "}\n");
+}
+
+static int wil_mbox_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+
+	wil_print_ring(s, "tx", wil->csr + HOST_MBOX +
+		   offsetof(struct wil6210_mbox_ctl, tx));
+	wil_print_ring(s, "rx", wil->csr + HOST_MBOX +
+		   offsetof(struct wil6210_mbox_ctl, rx));
+
+	return 0;
+}
+
+static int wil_mbox_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_mbox_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_mbox = {
+	.open		= wil_mbox_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static int wil_debugfs_iomem_x32_set(void *data, u64 val)
+{
+	iowrite32(val, (void __iomem *)data);
+	wmb(); /* make sure write propagated to HW */
+
+	return 0;
+}
+
+static int wil_debugfs_iomem_x32_get(void *data, u64 *val)
+{
+	*val = ioread32((void __iomem *)data);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_iomem_x32, wil_debugfs_iomem_x32_get,
+			wil_debugfs_iomem_x32_set, "0x%08llx\n");
+
+static struct dentry *wil_debugfs_create_iomem_x32(const char *name,
+						   mode_t mode,
+						   struct dentry *parent,
+						   void __iomem *value)
+{
+	return debugfs_create_file(name, mode, parent, (void * __force)value,
+				   &fops_iomem_x32);
+}
+
+static int wil6210_debugfs_create_ISR(struct wil6210_priv *wil,
+				      const char *name,
+				      struct dentry *parent, u32 off)
+{
+	struct dentry *d = debugfs_create_dir(name, parent);
+
+	if (IS_ERR_OR_NULL(d))
+		return -ENODEV;
+
+	wil_debugfs_create_iomem_x32("ICC", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off);
+	wil_debugfs_create_iomem_x32("ICR", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off + 4);
+	wil_debugfs_create_iomem_x32("ICM", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off + 8);
+	wil_debugfs_create_iomem_x32("ICS", S_IWUSR, d,
+				     wil->csr + off + 12);
+	wil_debugfs_create_iomem_x32("IMV", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off + 16);
+	wil_debugfs_create_iomem_x32("IMS", S_IWUSR, d,
+				     wil->csr + off + 20);
+	wil_debugfs_create_iomem_x32("IMC", S_IWUSR, d,
+				     wil->csr + off + 24);
+
+	return 0;
+}
+
+static int wil6210_debugfs_create_pseudo_ISR(struct wil6210_priv *wil,
+					     struct dentry *parent)
+{
+	struct dentry *d = debugfs_create_dir("PSEUDO_ISR", parent);
+
+	if (IS_ERR_OR_NULL(d))
+		return -ENODEV;
+
+	wil_debugfs_create_iomem_x32("CAUSE", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE));
+	wil_debugfs_create_iomem_x32("MASK_SW", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
+	wil_debugfs_create_iomem_x32("MASK_FW", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_FW));
+
+	return 0;
+}
+
+static int wil_memread_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	void __iomem *a = wmi_buffer(wil, mem_addr);
+
+	if (a)
+		seq_printf(s, "[0x%08x] = 0x%08x\n", mem_addr, ioread32(a));
+	else
+		seq_printf(s, "[0x%08x] = INVALID\n", mem_addr);
+
+	return 0;
+}
+
+static int wil_memread_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_memread_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_memread = {
+	.open		= wil_memread_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static int wil_default_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	enum { max_count = 4096 };
+	struct debugfs_blob_wrapper *blob = file->private_data;
+	loff_t pos = *ppos;
+	size_t available = blob->size;
+	void *buf;
+	size_t ret;
+
+	if (pos < 0)
+		return -EINVAL;
+
+	if (pos >= available || !count)
+		return 0;
+
+	if (count > available - pos)
+		count = available - pos;
+	if (count > max_count)
+		count = max_count;
+
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	wil_memcpy_fromio_32(buf, (const volatile void __iomem *)blob->data +
+			     pos, count);
+
+	ret = copy_to_user(user_buf, buf, count);
+	kfree(buf);
+	if (ret == count)
+		return -EFAULT;
+
+	count -= ret;
+	*ppos = pos + count;
+
+	return count;
+}
+
+static const struct file_operations fops_ioblob = {
+	.read =		wil_read_file_ioblob,
+	.open =		wil_default_open,
+	.llseek =	default_llseek,
+};
+
+static
+struct dentry *wil_debugfs_create_ioblob(const char *name,
+					 mode_t mode,
+					 struct dentry *parent,
+					 struct debugfs_blob_wrapper *blob)
+{
+	return debugfs_create_file(name, mode, parent, blob, &fops_ioblob);
+}
+/*---reset---*/
+static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
+				    size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	/**
+	 * BUG:
+	 * this code does NOT sync device state with the rest of system
+	 * use with care, debug only!!!
+	 */
+	rtnl_lock();
+	dev_close(ndev);
+	ndev->flags &= ~IFF_UP;
+	rtnl_unlock();
+	wil_reset(wil);
+
+	return len;
+}
+
+static const struct file_operations fops_reset = {
+	.write = wil_write_file_reset,
+	.open  = wil_default_open,
+};
+/*---------Tx descriptor------------*/
+
+static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	struct vring *vring = &(wil->vring_tx[0]);
+
+	if (!vring->va) {
+		seq_printf(s, "No Tx VRING\n");
+		return 0;
+	}
+
+	if (dbg_txdesc_index < vring->size) {
+		struct vring_tx_desc *d = &(vring->va[dbg_txdesc_index].tx);
+		u32 *u = (u32 *)d;
+		struct sk_buff *skb = vring->ctx[dbg_txdesc_index];
+
+		seq_printf(s, "Tx[%3d] = {\n", dbg_txdesc_index);
+		seq_printf(s, "  MAC = 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			   u[0], u[1], u[2], u[3]);
+		seq_printf(s, "  DMA = 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			   u[4], u[5], u[6], u[7]);
+		seq_printf(s, "  SKB = %p\n", skb);
+
+		if (skb) {
+			unsigned char printbuf[16 * 3 + 2];
+			int i = 0;
+			int len = skb_headlen(skb);
+			void *p = skb->data;
+
+			seq_printf(s, "    len = %d\n", len);
+
+			while (i < len) {
+				int l = min(len - i, 16);
+				hex_dump_to_buffer(p + i, l, 16, 1, printbuf,
+						   sizeof(printbuf), false);
+				seq_printf(s, "      : %s\n", printbuf);
+				i += l;
+			}
+		}
+		seq_printf(s, "}\n");
+	} else {
+		seq_printf(s, "TxDesc index (%d) >= size (%d)\n",
+			   dbg_txdesc_index, vring->size);
+	}
+
+	return 0;
+}
+
+static int wil_txdesc_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_txdesc_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_txdesc = {
+	.open		= wil_txdesc_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+/*----------------*/
+int wil6210_debugfs_init(struct wil6210_priv *wil)
+{
+	struct dentry *dbg = wil->debug = debugfs_create_dir(WIL_NAME,
+			wil_to_wiphy(wil)->debugfsdir);
+
+	if (IS_ERR_OR_NULL(dbg))
+		return -ENODEV;
+
+	debugfs_create_file("mbox", S_IRUGO, dbg, wil, &fops_mbox);
+	debugfs_create_file("vrings", S_IRUGO, dbg, wil, &fops_vring);
+	debugfs_create_file("txdesc", S_IRUGO, dbg, wil, &fops_txdesc);
+	debugfs_create_u32("txdesc_index", S_IRUGO | S_IWUSR, dbg,
+			   &dbg_txdesc_index);
+
+	wil6210_debugfs_create_ISR(wil, "USER_ICR", dbg,
+				   HOSTADDR(RGF_USER_USER_ICR));
+	wil6210_debugfs_create_ISR(wil, "DMA_EP_TX_ICR", dbg,
+				   HOSTADDR(RGF_DMA_EP_TX_ICR));
+	wil6210_debugfs_create_ISR(wil, "DMA_EP_RX_ICR", dbg,
+				   HOSTADDR(RGF_DMA_EP_RX_ICR));
+	wil6210_debugfs_create_ISR(wil, "DMA_EP_MISC_ICR", dbg,
+				   HOSTADDR(RGF_DMA_EP_MISC_ICR));
+	wil6210_debugfs_create_pseudo_ISR(wil, dbg);
+
+	debugfs_create_u32("mem_addr", S_IRUGO | S_IWUSR, dbg, &mem_addr);
+	debugfs_create_file("mem_val", S_IRUGO, dbg, wil, &fops_memread);
+
+	debugfs_create_file("reset", S_IWUSR, dbg, wil, &fops_reset);
+
+	wil->rgf_blob.data = (void * __force)wil->csr + 0;
+	wil->rgf_blob.size = 0xa000;
+	wil_debugfs_create_ioblob("blob_rgf", S_IRUGO, dbg, &wil->rgf_blob);
+
+	wil->fw_code_blob.data = (void * __force)wil->csr + 0x40000;
+	wil->fw_code_blob.size = 0x40000;
+	wil_debugfs_create_ioblob("blob_fw_code", S_IRUGO, dbg,
+				  &wil->fw_code_blob);
+
+	wil->fw_data_blob.data = (void * __force)wil->csr + 0x80000;
+	wil->fw_data_blob.size = 0x8000;
+	wil_debugfs_create_ioblob("blob_fw_data", S_IRUGO, dbg,
+				  &wil->fw_data_blob);
+
+	wil->fw_peri_blob.data = (void * __force)wil->csr + 0x88000;
+	wil->fw_peri_blob.size = 0x18000;
+	wil_debugfs_create_ioblob("blob_fw_peri", S_IRUGO, dbg,
+				  &wil->fw_peri_blob);
+
+	wil->uc_code_blob.data = (void * __force)wil->csr + 0xa0000;
+	wil->uc_code_blob.size = 0x10000;
+	wil_debugfs_create_ioblob("blob_uc_code", S_IRUGO, dbg,
+				  &wil->uc_code_blob);
+
+	wil->uc_data_blob.data = (void * __force)wil->csr + 0xb0000;
+	wil->uc_data_blob.size = 0x4000;
+	wil_debugfs_create_ioblob("blob_uc_data", S_IRUGO, dbg,
+				  &wil->uc_data_blob);
+
+	return 0;
+}
+
+void wil6210_debugfs_remove(struct wil6210_priv *wil)
+{
+	debugfs_remove_recursive(wil->debug);
+	wil->debug = NULL;
+}
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
new file mode 100644
index 0000000..fb9cd04
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/interrupt.h>
+
+#include "wil6210.h"
+
+/**
+ * Theory of operation:
+ *
+ * There is ISR pseudo-cause register,
+ * dma_rgf->DMA_RGF.PSEUDO_CAUSE.PSEUDO_CAUSE
+ * Its bits represents OR'ed bits from 3 real ISR registers:
+ * TX, RX, and MISC.
+ *
+ * Registers may be configured to either "write 1 to clear" or
+ * "clear on read" mode
+ *
+ * When handling interrupt, one have to mask/unmask interrupts for the
+ * real ISR registers, or hardware may malfunction.
+ *
+ */
+
+#define WIL6210_IRQ_DISABLE	(0xFFFFFFFFUL)
+#define WIL6210_IMC_RX		BIT_DMA_EP_RX_ICR_RX_DONE
+#define WIL6210_IMC_TX		(BIT_DMA_EP_TX_ICR_TX_DONE | \
+				BIT_DMA_EP_TX_ICR_TX_DONE_N(0))
+#define WIL6210_IMC_MISC	(ISR_MISC_FW_READY | ISR_MISC_MBOX_EVT)
+
+static inline u32 wil_ioread32_and_clear(void __iomem *addr)
+{
+	u32 x = ioread32(addr);
+
+#if !defined(CONFIG_WIL6210_ISR_COR)
+	iowrite32(x, addr);
+#endif
+
+	return x;
+}
+
+static void wil6210_mask_irq(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+	clear_bit(wil_status_irqen, &wil->status);
+
+	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		  offsetof(struct RGF_ICR, IMS));
+	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		  offsetof(struct RGF_ICR, IMS));
+	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		  offsetof(struct RGF_ICR, IMS));
+}
+
+static void wil6210_unmask_irq(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+	iowrite32(WIL6210_IMC_RX, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		  offsetof(struct RGF_ICR, IMC));
+	iowrite32(WIL6210_IMC_TX, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		  offsetof(struct RGF_ICR, IMC));
+	iowrite32(WIL6210_IMC_MISC, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		  offsetof(struct RGF_ICR, IMC));
+
+	set_bit(wil_status_irqen, &wil->status);
+}
+
+void wil6210_disable_irq(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+	wil6210_mask_irq(wil);
+}
+
+void wil6210_enable_irq(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+#if defined(CONFIG_WIL6210_ISR_COR)
+	/* configure to Clear-On-Read */
+	iowrite32(0xFFFFFFFFUL, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+	iowrite32(0xFFFFFFFFUL, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+	iowrite32(0xFFFFFFFFUL, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+#else
+	iowrite32(0, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+	iowrite32(0, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+	iowrite32(0, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+#endif
+
+	wil6210_unmask_irq(wil);
+}
+
+static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+	u32 isr = wil->isr_rx;
+
+	wil_dbg_IRQ(wil, "ISR RX 0x%08x\n", isr);
+
+	if (isr & BIT_DMA_EP_RX_ICR_RX_DONE) {
+		wil_dbg_IRQ(wil, "RX done\n");
+		isr &= ~BIT_DMA_EP_RX_ICR_RX_DONE;
+		wil_rx_handle(wil);
+	}
+
+	if (isr)
+		wil_err(wil, "un-handled RX ISR bits 0x%08x\n", isr);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+	u32 isr = wil->isr_tx;
+
+	wil_dbg_IRQ(wil, "ISR TX 0x%08x\n", isr);
+
+	if (isr & BIT_DMA_EP_TX_ICR_TX_DONE) {
+		int i;
+		wil_dbg_IRQ(wil, "TX done\n");
+		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
+		for (i = 0; i < 24; i++) {
+			u32 mask = BIT_DMA_EP_TX_ICR_TX_DONE_N(i);
+			if (isr & mask) {
+				isr &= ~mask;
+				wil_dbg_IRQ(wil, "TX done(%i)\n", i);
+				wil_tx_complete(wil, i);
+			}
+		}
+	}
+
+	if (isr)
+		wil_err(wil, "un-handled TX ISR bits 0x%08x\n", isr);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+	u32 isr = wil->isr_misc;
+
+	wil_dbg_IRQ(wil, "ISR MISC 0x%08x\n", isr);
+
+	if (isr & ISR_MISC_FW_READY) {
+		wil_info(wil, "IRQ: FW ready\n");
+		/**
+		 * Actual FW ready indicated by the
+		 * WMI_FW_READY_EVENTID
+		 */
+		isr &= ~ISR_MISC_FW_READY;
+	}
+
+	if (isr & ISR_MISC_MBOX_EVT) {
+		wil_dbg_IRQ(wil, "MBOX event\n");
+		wmi_recv_cmd(wil);
+		isr &= ~ISR_MISC_MBOX_EVT;
+	}
+
+	if (isr)
+		wil_err(wil, "un-handled MISC ISR bits 0x%08x\n", isr);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * thread IRQ handler
+ */
+static irqreturn_t wil6210_thread_irq(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+
+	wil_dbg_IRQ(wil, "Thread IRQ\n");
+	/* Discover real IRQ cause */
+	if (wil->isr_misc) {
+		wil6210_irq_misc(irq, cookie);
+		wil->isr_misc = 0;
+	}
+
+	wil6210_unmask_irq(wil);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t wil6210_hardirq(int irq, void *cookie)
+{
+	irqreturn_t rc = IRQ_HANDLED;
+	struct wil6210_priv *wil = cookie;
+	u32 pseudo_cause = ioread32(wil->csr +
+			HOSTADDR(RGF_DMA_PSEUDO_CAUSE));
+
+	/**
+	 * pseudo_cause is Clear-On-Read, no need to ACK
+	 */
+	if ((pseudo_cause == 0) || ((pseudo_cause & 0xff) == 0xff))
+		return IRQ_NONE;
+
+	/* FIXME: IRQ mask debug */
+	if (!test_bit(wil_status_irqen, &wil->status)) {
+		u32 icm_rx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				offsetof(struct RGF_ICR, ICM));
+		u32 icr_rx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+		u32 imv_rx = ioread32(wil->csr +
+				HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				offsetof(struct RGF_ICR, IMV));
+		u32 icm_tx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				offsetof(struct RGF_ICR, ICM));
+		u32 icr_tx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+		u32 imv_tx = ioread32(wil->csr +
+				HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				offsetof(struct RGF_ICR, IMV));
+		u32 icm_misc = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				offsetof(struct RGF_ICR, ICM));
+		u32 icr_misc = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+		u32 imv_misc = ioread32(wil->csr +
+				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				offsetof(struct RGF_ICR, IMV));
+		wil_err(wil, "IRQ when it should be masked: pseudo 0x%08x\n"
+				"Rx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
+				"Tx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
+				"Misc icm:icr:imv 0x%08x 0x%08x 0x%08x\n",
+				pseudo_cause,
+				icm_rx, icr_rx, imv_rx,
+				icm_tx, icr_tx, imv_tx,
+				icm_misc, icr_misc, imv_misc);
+		return IRQ_NONE;
+	}
+
+	wil6210_mask_irq(wil);
+
+	/* Discover real IRQ cause */
+	/* All ISR regs configured Clear-On-Read, no need to ACK */
+	if (pseudo_cause & BIT_DMA_PSEUDO_CAUSE_RX) {
+		wil->isr_rx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+	}
+
+	if (pseudo_cause & BIT_DMA_PSEUDO_CAUSE_TX) {
+		wil->isr_tx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+	}
+
+	if (pseudo_cause & BIT_DMA_PSEUDO_CAUSE_MISC) {
+		wil->isr_misc = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+		rc = IRQ_WAKE_THREAD;
+	}
+
+	/* process what to be done right in hard IRQ */
+	if (wil->isr_rx) {
+		if (wil6210_irq_rx(irq, cookie) == IRQ_WAKE_THREAD)
+			rc = IRQ_WAKE_THREAD;
+		else
+			wil->isr_rx = 0;
+	}
+
+	if (wil->isr_tx) {
+		if (wil6210_irq_tx(irq, cookie) == IRQ_WAKE_THREAD)
+			rc = IRQ_WAKE_THREAD;
+		else
+			wil->isr_tx = 0;
+	}
+
+	/* if thread is requested, it will unmask IRQ */
+	if (rc != IRQ_WAKE_THREAD)
+		wil6210_unmask_irq(wil);
+
+	wil_dbg_IRQ(wil, "Hard IRQ 0x%08x\n", pseudo_cause);
+
+	return rc;
+}
+
+int wil6210_init_irq(struct wil6210_priv *wil, int irq)
+{
+	int rc;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	/* TODO: handle multiple MSI */
+	rc = request_threaded_irq(irq, wil6210_hardirq, wil6210_thread_irq,
+				  wil->n_msi ? 0 : IRQF_SHARED,
+				  WIL_NAME, wil);
+	if (rc)
+		return rc;
+
+	wil6210_enable_irq(wil);
+
+	return 0;
+}
+
+void wil6210_fini_irq(struct wil6210_priv *wil, int irq)
+{
+	wil_info(wil, "%s()\n", __func__);
+
+	wil6210_disable_irq(wil);
+	free_irq(irq, wil);
+}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
new file mode 100644
index 0000000..4d5ff8b
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -0,0 +1,400 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/ieee80211.h>
+#include <linux/wireless.h>
+#include <linux/slab.h>
+#include <linux/moduleparam.h>
+#include <linux/if_arp.h>
+
+#include "wil6210.h"
+
+/*
+ * Due to a hardware issue,
+ * one has to read/write to/from NIC in 32-bit chunks;
+ * regular memcpy_fromio and siblings will
+ * not work on 64-bit platform - it uses 64-bit transactions
+ *
+ * Force 32-bit transactions to enable NIC on 64-bit platforms
+ */
+void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
+			  size_t count)
+{
+	u32 *d = dst;
+	const volatile u32 __iomem *s = src;
+
+	/* size_t is unsigned, if (count%4 != 0) it will wrap */
+	for (count += 4; count > 4; count -= 4)
+		*d++ = readl(s++);
+}
+
+void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
+			size_t count)
+{
+	volatile u32 __iomem *d = dst;
+	const u32 *s = src;
+
+	for (count += 4; count > 4; count -= 4)
+		writel(*s++, d++);
+}
+
+static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
+{
+	int i;
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	wil_link_off(wil);
+	clear_bit(wil_status_fwconnected, &wil->status);
+
+	switch (wdev->sme_state) {
+	case CFG80211_SME_CONNECTED:
+		cfg80211_disconnected(ndev, WLAN_STATUS_UNSPECIFIED_FAILURE,
+				      NULL, 0, GFP_KERNEL);
+		break;
+	case CFG80211_SME_CONNECTING:
+		cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
+		break;
+	default:
+		;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++)
+		wil_vring_fini_tx(wil, i);
+}
+
+static void wil_disconnect_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work,
+			struct wil6210_priv, disconnect_worker);
+
+	_wil6210_disconnect(wil, NULL);
+}
+
+static void wil_connect_timer_fn(ulong x)
+{
+	struct wil6210_priv *wil = (void *)x;
+
+	wil_info(wil, "Connect timeout\n");
+
+	/* reschedule to thread context - disconnect won't
+	 * run from atomic context
+	 */
+	schedule_work(&wil->disconnect_worker);
+}
+
+int wil_priv_init(struct wil6210_priv *wil)
+{
+	wil_info(wil, "%s()\n", __func__);
+
+	mutex_init(&wil->mutex);
+	mutex_init(&wil->wmi_mutex);
+
+	init_completion(&wil->wmi_ready);
+
+	wil->pending_connect_cid = -1;
+	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
+
+	INIT_WORK(&wil->wmi_connect_worker, wmi_connect_worker);
+	INIT_WORK(&wil->disconnect_worker, wil_disconnect_worker);
+	INIT_WORK(&wil->wmi_event_worker, wmi_event_worker);
+
+	INIT_LIST_HEAD(&wil->pending_wmi_ev);
+	spin_lock_init(&wil->wmi_ev_lock);
+
+	wil->wmi_wq = create_singlethread_workqueue(WIL_NAME"_wmi");
+	if (!wil->wmi_wq)
+		return -EAGAIN;
+
+	wil->wmi_wq_conn = create_singlethread_workqueue(WIL_NAME"_connect");
+	if (!wil->wmi_wq_conn) {
+		destroy_workqueue(wil->wmi_wq);
+		return -EAGAIN;
+	}
+
+	/* make shadow copy of registers that should not change on run time */
+	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
+			     sizeof(struct wil6210_mbox_ctl));
+
+	return 0;
+}
+
+void wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
+{
+	del_timer_sync(&wil->connect_timer);
+	_wil6210_disconnect(wil, bssid);
+}
+
+void wil_priv_deinit(struct wil6210_priv *wil)
+{
+	cancel_work_sync(&wil->disconnect_worker);
+	wil6210_disconnect(wil, NULL);
+	wmi_event_flush(wil);
+	destroy_workqueue(wil->wmi_wq_conn);
+	destroy_workqueue(wil->wmi_wq);
+}
+
+static void wil_target_reset(struct wil6210_priv *wil)
+{
+	wil_info(wil, "Resetting...\n");
+
+	/* register write */
+#define W(a, v) iowrite32(v, wil->csr + HOSTADDR(a))
+	/* register set = read, OR, write */
+#define S(a, v) iowrite32(ioread32(wil->csr + HOSTADDR(a)) | v, \
+		wil->csr + HOSTADDR(a))
+
+	/* hpal_perst_from_pad_src_n_mask */
+	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(6));
+	/* car_perst_rst_src_n_mask */
+	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(7));
+
+	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
+	W(RGF_USER_USER_CPU_0, BIT(1)); /* user_cpu_man_rst */
+
+	msleep(100);
+
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000170);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FC00);
+
+	msleep(100);
+
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+
+	msleep(2000);
+
+	W(RGF_USER_USER_CPU_0, BIT(0)); /* user_cpu_man_de_rst */
+
+	msleep(2000);
+
+	wil_info(wil, "Reset completed\n");
+
+#undef W
+#undef S
+}
+
+/*
+ * We reset all the structures, and we reset the UMAC.
+ * After calling this routine, you're expected to reload
+ * the firmware.
+ */
+int wil_reset(struct wil6210_priv *wil)
+{
+	wil_info(wil, "%s()\n", __func__);
+
+	cancel_work_sync(&wil->disconnect_worker);
+	wil6210_disconnect(wil, NULL);
+
+	wmi_event_flush(wil);
+
+	flush_workqueue(wil->wmi_wq);
+	flush_workqueue(wil->wmi_wq_conn);
+
+	wil6210_disable_irq(wil);
+	wil->status = 0;
+
+	/* TODO: put MAC in reset */
+	wil_target_reset(wil);
+
+	/* init after reset */
+	wil->pending_connect_cid = -1;
+	INIT_COMPLETION(wil->wmi_ready);
+
+	/* make shadow copy of registers that should not change on run time */
+	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
+			     sizeof(struct wil6210_mbox_ctl));
+
+	/* TODO: release MAC reset */
+	wil6210_enable_irq(wil);
+
+	/* we just started MAC, wait for FW ready */
+	{
+		ulong to = msecs_to_jiffies(1000);
+		ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
+		if (0 == left) {
+			wil_err(wil, "Firmware not ready\n");
+			return -ETIME;
+		} else {
+			wil_info(wil, "FW ready after %d ms\n",
+				 jiffies_to_msecs(to-left));
+		}
+	}
+
+	if (!wil->ssid_len && wmi_get_ssid(wil, &wil->ssid_len, wil->ssid))
+		wil_err(wil, "Failed to get SSID\n");
+
+	{
+		int channel;
+		int rc = wmi_get_channel(wil, &channel);
+		if (rc)
+			return rc;
+		/* TODO: find channel for index */
+	}
+
+	return 0;
+}
+
+
+void wil_link_on(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	netif_carrier_on(ndev);
+	netif_tx_wake_all_queues(ndev);
+}
+
+void wil_link_off(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	netif_tx_stop_all_queues(ndev);
+	netif_carrier_off(ndev);
+}
+
+static int __wil_up(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	int rc;
+	int bi;
+	u16 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
+
+	rc = wil_reset(wil);
+	if (rc)
+		return rc;
+
+	/* FIXME Firmware works now in PBSS mode(ToDS=0, FromDS=0) */
+	wmi_nettype = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		wil_info(wil, "type: STATION\n");
+		bi = 0;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_AP:
+		wil_info(wil, "type: AP\n");
+		bi = 100;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		wil_info(wil, "type: P2P_CLIENT\n");
+		bi = 0;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		wil_info(wil, "type: P2P_GO\n");
+		bi = 100;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		wil_info(wil, "type: Monitor\n");
+		bi = 0;
+		ndev->type = ARPHRD_IEEE80211_RADIOTAP;
+		/* ARPHRD_IEEE80211 or ARPHRD_IEEE80211_RADIOTAP ? */
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* Apply profile in the following order: */
+	/* SSID and channel for the AP */
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		if (wil->ssid_len == 0) {
+			wil_err(wil, "SSID not set\n");
+			return -EINVAL;
+		}
+		wmi_set_ssid(wil, wil->ssid_len, wil->ssid);
+		if (wil->channel)
+			wmi_set_channel(wil, wil->channel->hw_value);
+		break;
+	default:
+		;
+	}
+
+	/* MAC address - pre-requisite for other commands */
+	wmi_set_mac_address(wil, ndev->dev_addr);
+
+	/* Set up beaconing if required. */
+	rc = wmi_set_bcon(wil, bi, wmi_nettype);
+	if (rc)
+		return rc;
+
+	/* Rx VRING. After MAC and beacon */
+	wil_rx_init(wil);
+
+	return 0;
+}
+
+int wil_up(struct wil6210_priv *wil)
+{
+	int rc;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	mutex_lock(&wil->mutex);
+	rc = __wil_up(wil);
+	mutex_unlock(&wil->mutex);
+
+	return rc;
+}
+
+static int __wil_down(struct wil6210_priv *wil)
+{
+	if (wil->scan_request) {
+		cfg80211_scan_done(wil->scan_request, true);
+		wil->scan_request = NULL;
+	}
+
+	wil6210_disconnect(wil, NULL);
+	wil_rx_fini(wil);
+
+	return 0;
+}
+
+int wil_down(struct wil6210_priv *wil)
+{
+	int rc;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	mutex_lock(&wil->mutex);
+	rc = __wil_down(wil);
+	mutex_unlock(&wil->mutex);
+
+	return rc;
+}
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
new file mode 100644
index 0000000..60f7efb
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -0,0 +1,159 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/slab.h>
+
+#include "wil6210.h"
+
+static int wil_open(struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	return wil_up(wil);
+}
+
+static int wil_stop(struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	return wil_down(wil);
+}
+
+/*
+ * AC to queue mapping
+ *
+ * AC_VO -> queue 3
+ * AC_VI -> queue 2
+ * AC_BE -> queue 1
+ * AC_BK -> queue 0
+ */
+static u16 wil_select_queue(struct net_device *ndev, struct sk_buff *skb)
+{
+	static const u16 wil_1d_to_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	u16 rc;
+
+	skb->priority = cfg80211_classify8021d(skb);
+
+	rc = wil_1d_to_queue[skb->priority];
+
+	wil_dbg_TXRX(wil, "%s() %d -> %d\n", __func__, (int)skb->priority,
+		     (int)rc);
+
+	return rc;
+}
+
+static const struct net_device_ops wil_netdev_ops = {
+	.ndo_open		= wil_open,
+	.ndo_stop		= wil_stop,
+	.ndo_start_xmit		= wil_start_xmit,
+	.ndo_select_queue	= wil_select_queue,
+	.ndo_set_mac_address    = eth_mac_addr,
+	.ndo_validate_addr      = eth_validate_addr,
+};
+
+void *wil_if_alloc(struct device *dev, void __iomem *csr)
+{
+	struct net_device *ndev;
+	struct wireless_dev *wdev;
+	struct wil6210_priv *wil;
+	int rc = 0;
+
+	wdev = wil_cfg80211_init(dev);
+	if (IS_ERR(wdev)) {
+		dev_err(dev, "wil_cfg80211_init failed\n");
+		return wdev;
+	}
+
+	wil = wdev_to_wil(wdev);
+	wil->csr = csr;
+	wil->wdev = wdev;
+
+	rc = wil_priv_init(wil);
+	if (rc) {
+		dev_err(dev, "wil_priv_init failed\n");
+		goto out_wdev;
+	}
+
+	wdev->iftype = NL80211_IFTYPE_STATION; /* TODO */
+	/* default monitor channel */
+	wil->channel = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
+
+	ndev = alloc_netdev_mqs(0, "wlan%d", ether_setup, WIL6210_TX_QUEUES, 1);
+	if (!ndev) {
+		dev_err(dev, "alloc_netdev_mqs failed\n");
+		rc = -ENOMEM;
+		goto out_priv;
+	}
+
+	ndev->netdev_ops = &wil_netdev_ops;
+	ndev->ieee80211_ptr = wdev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
+	wdev->netdev = ndev;
+
+	wil_link_off(wil);
+
+	return wil;
+
+ out_priv:
+	wil_priv_deinit(wil);
+
+ out_wdev:
+	wil_wdev_free(wil);
+
+	return ERR_PTR(rc);
+}
+
+void wil_if_free(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	if (!ndev)
+		return;
+
+	free_netdev(ndev);
+	wil_priv_deinit(wil);
+	wil_wdev_free(wil);
+}
+
+int wil_if_add(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	int rc;
+
+	rc = register_netdev(ndev);
+	if (rc < 0) {
+		dev_err(&ndev->dev, "Failed to register netdev: %d\n", rc);
+		return rc;
+	}
+
+	wil_link_off(wil);
+
+	return 0;
+}
+
+void wil_if_remove(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	unregister_netdev(ndev);
+}
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
new file mode 100644
index 0000000..066eef9
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -0,0 +1,239 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include <linux/debugfs.h>
+#include <linux/pci.h>
+#include <linux/moduleparam.h>
+
+#include "wil6210.h"
+
+static int use_msi = 1;
+module_param(use_msi, int, S_IRUGO);
+MODULE_PARM_DESC(use_msi,
+		 " Use MSI interrupt: "
+		 "0 - don't, 1 - (default) - single, or 3");
+
+/* Bus ops */
+static int wil_if_pcie_enable(struct wil6210_priv *wil)
+{
+	struct pci_dev *pdev = wil->pdev;
+	int rc;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	pci_set_master(pdev);
+	/*
+	 * how many MSI interrupts to request?
+	 */
+	wil->n_msi = use_msi;
+	/* TODO: how to deal with 3 MSI? */
+	if (wil->n_msi) {
+		wil_info(wil, "Setup %d MSI interrupts\n", use_msi);
+		rc = pci_enable_msi_block(pdev, wil->n_msi);
+		if (rc) {
+			wil_err(wil, "pci_enable_msi failed, use INTx\n");
+			wil->n_msi = 0;
+		}
+	} else {
+		wil_info(wil, "MSI interrupts disabled, use INTx\n");
+	}
+
+	rc = wil6210_init_irq(wil, pdev->irq);
+	if (rc)
+		goto stop_master;
+
+	/* need reset here to obtain MAC */
+	rc = wil_reset(wil);
+	if (rc)
+		goto release_irq;
+
+	return 0;
+
+ release_irq:
+	wil6210_fini_irq(wil, pdev->irq);
+	/* safe to call if no MSI */
+	pci_disable_msi(pdev);
+ stop_master:
+	pci_clear_master(pdev);
+	return rc;
+}
+
+static int wil_if_pcie_disable(struct wil6210_priv *wil)
+{
+	struct pci_dev *pdev = wil->pdev;
+	struct device *dev = wil_to_dev(wil);
+
+	dev_info(dev, "%s()\n", __func__);
+
+	pci_clear_master(pdev);
+	/* disable and release IRQ */
+	wil6210_fini_irq(wil, pdev->irq);
+	/* safe to call if no MSI */
+	pci_disable_msi(pdev);
+	/* TODO: disable HW */
+
+	return 0;
+}
+
+static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct wil6210_priv *wil;
+	struct device *dev = &pdev->dev;
+	void __iomem *csr;
+	int rc;
+
+	dev_info(dev, "%s()\n", __func__);
+
+	/* check HW */
+	dev_info(&pdev->dev, WIL_NAME " device found [%04x:%04x] (rev %x)\n",
+		 (int)pdev->vendor, (int)pdev->device, (int)pdev->revision);
+
+	if (pci_resource_len(pdev, 0) != WIL6210_MEM_SIZE) {
+		dev_err(&pdev->dev, "Not " WIL_NAME "? "
+			"BAR0 size is %lu while expecting %lu\n",
+			(ulong)pci_resource_len(pdev, 0), WIL6210_MEM_SIZE);
+		return -ENODEV;
+	}
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "pci_enable_device failed\n");
+		return -ENODEV;
+	}
+	/* rollback to err_disable_pdev */
+
+	rc = pci_request_region(pdev, 0, WIL_NAME);
+	if (rc) {
+		dev_err(&pdev->dev, "pci_request_region failed\n");
+		goto err_disable_pdev;
+	}
+	/* rollback to err_release_reg */
+
+	csr = pci_ioremap_bar(pdev, 0);
+	if (!csr) {
+		dev_err(&pdev->dev, "pci_ioremap_bar failed\n");
+		rc = -ENODEV;
+		goto err_release_reg;
+	}
+	/* rollback to err_iounmap */
+	dev_info(&pdev->dev, "CSR at %pR -> %p\n", &pdev->resource[0], csr);
+
+	wil = wil_if_alloc(dev, csr);
+	if (IS_ERR(wil)) {
+		rc = (int)PTR_ERR(wil);
+		dev_err(dev, "wil_if_alloc failed: %d\n", rc);
+		goto err_iounmap;
+	}
+	/* rollback to if_free */
+
+	pci_set_drvdata(pdev, wil);
+	wil->pdev = pdev;
+
+	/* FW should raise IRQ when ready */
+	rc = wil_if_pcie_enable(wil);
+	if (rc) {
+		wil_err(wil, "Enable device failed\n");
+		goto if_free;
+	}
+	/* rollback to bus_disable */
+
+	rc = wil_if_add(wil);
+	if (rc) {
+		wil_err(wil, "wil_if_add failed: %d\n", rc);
+		goto bus_disable;
+	}
+	/* rollback to if_remove */
+
+	rc = wil6210_sysfs_init(wil);
+	if (rc)
+		goto if_remove;
+	/* rollback to sysfs_fini */
+
+	wil6210_debugfs_init(wil);
+	/* rollback to debugfs_exit */
+
+	/* check FW is alive */
+	wmi_echo(wil);
+
+	return 0;
+
+ if_remove:
+	wil_if_remove(wil);
+ bus_disable:
+	wil_if_pcie_disable(wil);
+ if_free:
+	wil_if_free(wil);
+ err_iounmap:
+	pci_iounmap(pdev, csr);
+ err_release_reg:
+	pci_release_region(pdev, 0);
+ err_disable_pdev:
+	pci_disable_device(pdev);
+
+	return rc;
+}
+
+static void wil_pcie_remove(struct pci_dev *pdev)
+{
+	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	wil6210_debugfs_remove(wil);
+	wil6210_sysfs_fini(wil);
+	wil_if_pcie_disable(wil);
+	wil_if_remove(wil);
+	wil_if_free(wil);
+	pci_iounmap(pdev, wil->csr);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(wil6210_pcie_ids) = {
+	{ PCI_DEVICE(0x1ae9, 0x0301) },
+	{ /* end: all zeroes */	},
+};
+MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
+
+static struct pci_driver wil_driver = {
+	.probe		= wil_pcie_probe,
+	.remove		= __devexit_p(wil_pcie_remove),
+	.id_table	= wil6210_pcie_ids,
+	.name		= WIL_NAME,
+};
+
+
+static int __init wil_init_module(void)
+{
+	return pci_register_driver(&wil_driver);
+}
+
+static void __exit wil_exit_module(void)
+{
+	pci_unregister_driver(&wil_driver);
+}
+
+module_init(wil_init_module);
+module_exit(wil_exit_module);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Qualcomm Atheros <wil6210@qca.qualcomm.com>");
+MODULE_DESCRIPTION("Driver for 60g WiFi WIL6210 card");
diff --git a/drivers/net/wireless/ath/wil6210/sysfs.c b/drivers/net/wireless/ath/wil6210/sysfs.c
new file mode 100644
index 0000000..f2d548a
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/sysfs.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/device.h>
+#include <linux/stat.h>
+
+#include "wil6210.h"
+
+/* attribute: SSID */
+static ssize_t wil_show_ssid(struct device *d, struct device_attribute *attr,
+			     char *buf)
+{
+	struct wil6210_priv *wil = dev_get_drvdata(d);
+
+	memcpy(buf, wil->ssid, wil->ssid_len);
+
+	return wil->ssid_len;
+}
+
+static ssize_t wil_store_ssid(struct device *d, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct wil6210_priv *wil = dev_get_drvdata(d);
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	if (count > sizeof(wil->ssid)) {
+		wil_err(wil, "SSID too long, len = %d\n", (int)count);
+		return -EINVAL;
+	}
+	if (netif_running(ndev)) {
+		wil_err(wil, "Unable to change SSID on running interface\n");
+		return -EINVAL;
+	}
+
+	wil->ssid_len = count;
+	memcpy(wil->ssid, buf, wil->ssid_len);
+
+	return wil->ssid_len;
+}
+
+static DEVICE_ATTR(ssid, S_IRUGO | S_IWUSR, wil_show_ssid, wil_store_ssid);
+
+/* attribute: bf */
+static ssize_t wil_show_bf(struct device *d, struct device_attribute *attr,
+			   char *buf)
+{
+	struct wil6210_priv *wil = dev_get_drvdata(d);
+
+	return snprintf(buf, PAGE_SIZE,
+			"TSF : 0x%016llx\n"
+			"TxMCS : %d\n"
+			"Sectors(rx:tx) my %2d:%2d peer %2d:%2d\n",
+			wil->stats.tsf, wil->stats.bf_mcs,
+			wil->stats.my_rx_sector, wil->stats.my_tx_sector,
+			wil->stats.peer_rx_sector, wil->stats.peer_tx_sector);
+}
+
+static DEVICE_ATTR(bf, S_IRUGO, wil_show_bf, NULL);
+
+/* attribute: secure_pcp */
+static ssize_t wil_show_secure_pcp(struct device *d,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct wil6210_priv *wil = dev_get_drvdata(d);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", wil->secure_pcp);
+}
+
+static ssize_t wil_store_secure_pcp(struct device *d,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct wil6210_priv *wil = dev_get_drvdata(d);
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	if (netif_running(ndev)) {
+		wil_err(wil,
+			"Unable to change secure_pcp on running interface\n");
+		return -EINVAL;
+	}
+
+	if (1 == sscanf(buf, "%d", &wil->secure_pcp))
+		return count;
+	else
+		return -EINVAL;
+
+}
+
+static DEVICE_ATTR(secure_pcp, S_IRUGO | S_IWUSR,
+		   wil_show_secure_pcp, wil_store_secure_pcp);
+
+static struct attribute *wil6210_sysfs_entries[] = {
+	&dev_attr_ssid.attr,
+	&dev_attr_bf.attr,
+	&dev_attr_secure_pcp.attr,
+	NULL
+};
+
+static struct attribute_group wil6210_attribute_group = {
+	.name = "attrs",
+	.attrs = wil6210_sysfs_entries,
+};
+
+int wil6210_sysfs_init(struct wil6210_priv *wil)
+{
+	struct device *dev = wil_to_dev(wil);
+
+	int rc = sysfs_create_group(&dev->kobj, &wil6210_attribute_group);
+	if (rc)
+		wil_err(wil, "sysfs_create_group failed : %d\n", rc);
+
+	return rc;
+}
+
+void wil6210_sysfs_fini(struct wil6210_priv *wil)
+{
+	struct device *dev = wil_to_dev(wil);
+
+	sysfs_remove_group(&dev->kobj, &wil6210_attribute_group);
+}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
new file mode 100644
index 0000000..752311f
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -0,0 +1,821 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/hardirq.h>
+#include <net/ieee80211_radiotap.h>
+#include <linux/if_arp.h>
+#include <linux/moduleparam.h>
+
+#include "wil6210.h"
+#include "wmi.h"
+#include "txrx.h"
+
+static bool rtap_include_phy_info;
+module_param(rtap_include_phy_info, bool, S_IRUGO);
+MODULE_PARM_DESC(rtap_include_phy_info,
+		 " Include PHY info in the radiotap header, default - no");
+
+static inline int wil_vring_is_empty(struct vring *vring)
+{
+	return vring->swhead == vring->swtail;
+}
+
+static inline u32 wil_vring_next_tail(struct vring *vring)
+{
+	return (vring->swtail + 1) % vring->size;
+}
+
+static inline void wil_vring_advance_head(struct vring *vring, int n)
+{
+	vring->swhead = (vring->swhead + n) % vring->size;
+}
+
+static inline int wil_vring_is_full(struct vring *vring)
+{
+	return wil_vring_next_tail(vring) == vring->swhead;
+}
+/*
+ * Available space in Tx Vring
+ */
+static inline int wil_vring_avail_tx(struct vring *vring)
+{
+	u32 swhead = vring->swhead;
+	u32 swtail = vring->swtail;
+	int used = (vring->size + swhead - swtail) % vring->size;
+
+	return vring->size - used - 1;
+}
+
+static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
+{
+	struct device *dev = wil_to_dev(wil);
+	size_t sz = vring->size * sizeof(vring->va[0]);
+	int i;
+
+	BUILD_BUG_ON(sizeof(vring->va[0]) != 32);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	vring->swhead = 0;
+	vring->swtail = 0;
+	vring->ctx = kzalloc(vring->size * sizeof(vring->ctx[0]), GFP_KERNEL);
+	if (!vring->ctx) {
+		wil_err(wil, "vring_alloc [%d] failed to alloc ctx mem\n",
+			vring->size);
+		vring->va = NULL;
+		return -ENOMEM;
+	}
+	/*
+	 * vring->va should be aligned on its size rounded up to power of 2
+	 * This is granted by the dma_alloc_coherent
+	 */
+	vring->va = dma_alloc_coherent(dev, sz, &vring->pa, GFP_KERNEL);
+	if (!vring->va) {
+		wil_err(wil, "vring_alloc [%d] failed to alloc DMA mem\n",
+			vring->size);
+		kfree(vring->ctx);
+		vring->ctx = NULL;
+		return -ENOMEM;
+	}
+	/* initially, all descriptors are SW owned
+	 * For Tx and Rx, ownership bit is at the same location, thus
+	 * we can use any
+	 */
+	for (i = 0; i < vring->size; i++) {
+		struct vring_tx_desc *d = &(vring->va[i].tx);
+		d->dma.status = TX_DMA_STATUS_DU;
+	}
+
+	wil_info(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
+		 vring->va, (unsigned long long)vring->pa, vring->ctx);
+
+	return 0;
+}
+
+static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
+			   int tx)
+{
+	struct device *dev = wil_to_dev(wil);
+	size_t sz = vring->size * sizeof(vring->va[0]);
+
+	wil_info(wil, "%s()\n", __func__);
+
+	while (!wil_vring_is_empty(vring)) {
+		if (tx) {
+			struct vring_tx_desc *d = &vring->va[vring->swtail].tx;
+			dma_addr_t pa = d->dma.addr_low |
+					((u64)d->dma.addr_high << 32);
+			struct sk_buff *skb = vring->ctx[vring->swtail];
+			if (skb) {
+				dma_unmap_single(dev, pa, d->dma.length,
+						 DMA_TO_DEVICE);
+				dev_kfree_skb_any(skb);
+				vring->ctx[vring->swtail] = NULL;
+			} else {
+				dma_unmap_page(dev, pa, d->dma.length,
+					       DMA_TO_DEVICE);
+			}
+			vring->swtail = wil_vring_next_tail(vring);
+		} else { /* rx */
+			struct vring_rx_desc *d = &vring->va[vring->swtail].rx;
+			dma_addr_t pa = d->dma.addr_low |
+					((u64)d->dma.addr_high << 32);
+			struct sk_buff *skb = vring->ctx[vring->swhead];
+			dma_unmap_single(dev, pa, d->dma.length,
+					 DMA_FROM_DEVICE);
+			kfree_skb(skb);
+			wil_vring_advance_head(vring, 1);
+		}
+	}
+	dma_free_coherent(dev, sz, vring->va, vring->pa);
+	kfree(vring->ctx);
+	vring->pa = 0;
+	vring->va = NULL;
+	vring->ctx = NULL;
+}
+
+/**
+ * Allocate one skb for Rx VRING
+ *
+ * Safe to call from IRQ
+ */
+static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
+			       u32 i, int headroom)
+{
+	struct device *dev = wil_to_dev(wil);
+	unsigned int sz = RX_BUF_LEN;
+	struct vring_rx_desc *d = &(vring->va[i].rx);
+	dma_addr_t pa;
+
+	/* TODO align */
+	struct sk_buff *skb = dev_alloc_skb(sz + headroom);
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	skb_reserve(skb, headroom);
+	skb_put(skb, sz);
+
+	pa = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, pa))) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	d->dma.d0 = BIT(9) | RX_DMA_D0_CMD_DMA_IT;
+	d->dma.addr_low = lower_32_bits(pa);
+	d->dma.addr_high = (u16)upper_32_bits(pa);
+	/* ip_length don't care */
+	/* b11 don't care */
+	/* error don't care */
+	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
+	d->dma.length = sz;
+	vring->ctx[i] = skb;
+
+	return 0;
+}
+
+/**
+ * Adds radiotap header
+ *
+ * Any error indicated as "Bad FCS"
+ *
+ * Vendor data for 04:ce:14-1 (Wilocity-1) consists of:
+ *  - Rx descriptor: 32 bytes
+ *  - Phy info
+ */
+static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
+				       struct sk_buff *skb,
+				       struct vring_rx_desc *d)
+{
+	struct wil6210_rtap {
+		struct ieee80211_radiotap_header rthdr;
+		/* fields should be in the order of bits in rthdr.it_present */
+		/* flags */
+		u8 flags;
+		/* channel */
+		__le16 chnl_freq __aligned(2);
+		__le16 chnl_flags;
+		/* MCS */
+		u8 mcs_present;
+		u8 mcs_flags;
+		u8 mcs_index;
+	} __packed;
+	struct wil6210_rtap_vendor {
+		struct wil6210_rtap rtap;
+		/* vendor */
+		u8 vendor_oui[3] __aligned(2);
+		u8 vendor_ns;
+		__le16 vendor_skip;
+		u8 vendor_data[0];
+	} __packed;
+	struct wil6210_rtap_vendor *rtap_vendor;
+	int rtap_len = sizeof(struct wil6210_rtap);
+	int phy_length = 0; /* phy info header size, bytes */
+	static char phy_data[128];
+
+	if (rtap_include_phy_info) {
+		rtap_len = sizeof(*rtap_vendor) + sizeof(*d);
+		/* calculate additional length */
+		if (d->dma.status & RX_DMA_STATUS_PHY_INFO) {
+			/**
+			 * PHY info starts from 8-byte boundary
+			 * there are 8-byte lines, last line may be partially
+			 * written (HW bug), thus FW configures for last line
+			 * to be excessive. Driver skips this last line.
+			 */
+			int len = min_t(int, 8 + sizeof(phy_data),
+					wil_rxdesc_phy_length(d));
+			if (len > 8) {
+				void *p = skb_tail_pointer(skb);
+				void *pa = PTR_ALIGN(p, 8);
+				if (skb_tailroom(skb) >= len + (pa - p)) {
+					phy_length = len - 8;
+					memcpy(phy_data, pa, phy_length);
+				}
+			}
+		}
+		rtap_len += phy_length;
+	}
+
+	if (skb_headroom(skb) < rtap_len &&
+	    pskb_expand_head(skb, rtap_len, 0, GFP_ATOMIC)) {
+		wil_err(wil, "Unable to expand headrom to %d\n", rtap_len);
+		return;
+	}
+
+	rtap_vendor = (void *)skb_push(skb, rtap_len);
+	memset(rtap_vendor, 0, rtap_len);
+
+	rtap_vendor->rtap.rthdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	rtap_vendor->rtap.rthdr.it_len = cpu_to_le16(rtap_len);
+	rtap_vendor->rtap.rthdr.it_present = cpu_to_le32(
+			(1 << IEEE80211_RADIOTAP_FLAGS) |
+			(1 << IEEE80211_RADIOTAP_CHANNEL) |
+			(1 << IEEE80211_RADIOTAP_MCS));
+	if (d->dma.status & RX_DMA_STATUS_ERROR)
+		rtap_vendor->rtap.flags |= IEEE80211_RADIOTAP_F_BADFCS;
+
+	rtap_vendor->rtap.chnl_freq = cpu_to_le16(wil->channel ?
+			wil->channel->center_freq : 58320);
+	rtap_vendor->rtap.chnl_flags = cpu_to_le16(0);
+
+	rtap_vendor->rtap.mcs_present = IEEE80211_RADIOTAP_MCS_HAVE_MCS;
+	rtap_vendor->rtap.mcs_flags = 0;
+	rtap_vendor->rtap.mcs_index = wil_rxdesc_mcs(d);
+
+	if (rtap_include_phy_info) {
+		rtap_vendor->rtap.rthdr.it_present |= cpu_to_le32(1 <<
+				IEEE80211_RADIOTAP_VENDOR_NAMESPACE);
+		/* OUI for Wilocity 04:ce:14 */
+		rtap_vendor->vendor_oui[0] = 0x04;
+		rtap_vendor->vendor_oui[1] = 0xce;
+		rtap_vendor->vendor_oui[2] = 0x14;
+		rtap_vendor->vendor_ns = 1;
+		/* Rx descriptor + PHY data  */
+		rtap_vendor->vendor_skip = cpu_to_le16(sizeof(*d) +
+						       phy_length);
+		memcpy(rtap_vendor->vendor_data, d, sizeof(*d));
+		memcpy(rtap_vendor->vendor_data + sizeof(*d), phy_data,
+		       phy_length);
+	}
+}
+
+/**
+ * reap 1 frame from @swhead
+ *
+ * Safe to call from IRQ
+ */
+static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
+					 struct vring *vring)
+{
+	struct device *dev = wil_to_dev(wil);
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct vring_rx_desc *d;
+	struct sk_buff *skb;
+	dma_addr_t pa;
+	unsigned int sz = RX_BUF_LEN;
+
+	if (wil_vring_is_empty(vring))
+		return NULL;
+
+	d = &(vring->va[vring->swhead].rx);
+	if (!(d->dma.status & RX_DMA_STATUS_DU)) {
+		/* it is not error, we just reached end of Rx done area */
+		return NULL;
+	}
+
+	pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+	skb = vring->ctx[vring->swhead];
+	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
+	skb_trim(skb, d->dma.length);
+	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d);
+	/* use radiotap header only if required */
+	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
+		wil_rx_add_radiotap_header(wil, skb, d);
+
+	wil_dbg_TXRX(wil, "Rx[%3d] : %d bytes\n", vring->swhead, d->dma.length);
+	wil_hex_dump_TXRX("Rx ", DUMP_PREFIX_NONE, 32, 4, d, sizeof(*d), false);
+
+	wil_vring_advance_head(vring, 1);
+
+	return skb;
+}
+
+/**
+ * allocate and fill up to @count buffers in rx ring
+ * buffers posted at @swtail
+ */
+static int wil_rx_refill(struct wil6210_priv *wil, int count)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct vring *v = &wil->vring_rx;
+	u32 next_tail;
+	int rc = 0;
+	int headroom = ndev->type == ARPHRD_IEEE80211_RADIOTAP ?
+			WIL6210_RTAP_SIZE : 0;
+
+	for (; next_tail = wil_vring_next_tail(v),
+			(next_tail != v->swhead) && (count-- > 0);
+			v->swtail = next_tail) {
+		rc = wil_vring_alloc_skb(wil, v, v->swtail, headroom);
+		if (rc) {
+			wil_err(wil, "Error %d in wil_rx_refill[%d]\n",
+				rc, v->swtail);
+			break;
+		}
+	}
+	iowrite32(v->swtail, wil->csr + HOSTADDR(v->hwtail));
+
+	return rc;
+}
+
+static int wil_netif_rx_any(struct sk_buff *skb)
+{
+	if (in_interrupt())
+		return netif_rx(skb);
+	else
+		return netif_rx_ni(skb);
+}
+
+/**
+ * Proceed all completed skb's from Rx VRING
+ *
+ * Safe to call from IRQ
+ */
+void wil_rx_handle(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct vring *v = &wil->vring_rx;
+	struct sk_buff *skb;
+
+	if (!v->va) {
+		wil_err(wil, "Rx IRQ while Rx not yet initialized\n");
+		return;
+	}
+	wil_dbg_TXRX(wil, "%s()\n", __func__);
+	while (NULL != (skb = wil_vring_reap_rx(wil, v))) {
+		wil_hex_dump_TXRX("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
+				  skb->data, skb_headlen(skb), false);
+
+		skb_orphan(skb);
+
+		if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
+			skb->dev = ndev;
+			skb_reset_mac_header(skb);
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb->pkt_type = PACKET_OTHERHOST;
+			skb->protocol = htons(ETH_P_802_2);
+
+		} else {
+			skb->protocol = eth_type_trans(skb, ndev);
+		}
+		if (likely(wil_netif_rx_any(skb) == NET_RX_SUCCESS)) {
+			ndev->stats.rx_packets++;
+			ndev->stats.rx_bytes += skb->len;
+
+		} else {
+			ndev->stats.rx_dropped++;
+		}
+	}
+	wil_rx_refill(wil, v->size);
+}
+
+int wil_rx_init(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	struct vring *vring = &wil->vring_rx;
+	int rc;
+	struct wmi_cfg_rx_chain_cmd cmd = {
+		.action = WMI_RX_CHAIN_ADD,
+		.sw_ring = {
+			.max_mpdu_size = RX_BUF_LEN,
+		},
+		.mid = 0, /* TODO - what is it? */
+		.decap_trans_type = WMI_DECAP_TYPE_802_3,
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_cfg_rx_chain_done_event evt;
+	} __packed evt;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	vring->size = WIL6210_RX_RING_SIZE;
+	rc = wil_vring_alloc(wil, vring);
+	if (rc)
+		return rc;
+
+	cmd.sw_ring.ring_mem_base = vring->pa;
+	cmd.sw_ring.ring_size = vring->size;
+	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		cmd.sniffer_mode = 1;
+		if (wil->channel)
+			cmd.sniffer_channel = wil->channel->hw_value - 1;
+		cmd.sniffer_phy_info =
+				(ndev->type == ARPHRD_IEEE80211_RADIOTAP);
+		/* 0 - CP, 1 - DP */
+		cmd.sniffer_phy =
+				(wil->monitor_flags & MONITOR_FLAG_CONTROL) ?
+						0 : 1;
+	}
+	/* typical time for secure PCP is 840ms */
+	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
+		      WMI_CFG_RX_CHAIN_DONE_EVENTID, &evt, sizeof(evt), 2000);
+	if (rc)
+		goto err_free;
+
+	vring->hwtail = evt.evt.rx_ring_tail_ptr;
+	wil_info(wil, "Rx init: status %d tail 0x%08x\n",
+		 evt.evt.status, vring->hwtail);
+	rc = wil_rx_refill(wil, vring->size);
+	if (rc)
+		goto err_free;
+
+	return 0;
+ err_free:
+	wil_vring_free(wil, vring, 0);
+
+	return rc;
+}
+
+void wil_rx_fini(struct wil6210_priv *wil)
+{
+	struct vring *vring = &wil->vring_rx;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	if (vring->va) {
+		int rc;
+		struct wmi_cfg_rx_chain_cmd cmd = {
+			.action = WMI_RX_CHAIN_DEL,
+			.sw_ring = {
+				.max_mpdu_size = RX_BUF_LEN,
+			},
+		};
+		struct {
+			struct wil6210_mbox_hdr_wmi wmi;
+			struct wmi_cfg_rx_chain_done_event cfg;
+		} __packed wmi_rx_cfg_reply;
+		rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
+			      WMI_CFG_RX_CHAIN_DONE_EVENTID,
+			      &wmi_rx_cfg_reply, sizeof(wmi_rx_cfg_reply),
+			      100);
+		wil_vring_free(wil, vring, 0);
+	}
+}
+
+int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
+		      int cid, int tid)
+{
+	struct wireless_dev *wdev = wil->wdev;
+	int rc;
+	struct wmi_vring_cfg_cmd cmd = {
+		.action = WMI_VRING_CMD_ADD,
+		.sw_ring = {
+			.max_mpdu_size = TX_BUF_LEN,
+		},
+		.ringid = id,
+		.cidxtid = (cid & 0xf) | ((tid & 0xf) << 4),
+		.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
+		.mac_ctrl = 0,
+		.to_resolution = 0,
+		.agg_max_wsize = 0,
+		.priority = 0,
+		.timeslot_us = 0xfff,
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_vring_cfg_done_event cmd;
+	} __packed reply;
+	struct vring *vring = &wil->vring_tx[id];
+
+	wil_info(wil, "%s(%d)\n", __func__, id);
+
+	if (vring->va) {
+		wil_err(wil, "Tx ring [%d] already allocated\n", id);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	vring->size = size;
+	rc = wil_vring_alloc(wil, vring);
+	if (rc)
+		goto out;
+
+	cmd.sw_ring.ring_mem_base = vring->pa;
+	cmd.sw_ring.ring_size = vring->size;
+	/* FIXME Firmware works now in PBSS mode(ToDS=0, FromDS=0) */
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		cmd.ds_cfg = WMI_VRING_DS_PBSS; /* TODO: WMI_VRING_DS_STATION */
+		break;
+	case NL80211_IFTYPE_AP:
+		cmd.ds_cfg = WMI_VRING_DS_PBSS; /* TODO: WMI_VRING_DS_AP */
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		cmd.ds_cfg = WMI_VRING_DS_STATION;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		cmd.ds_cfg = WMI_VRING_DS_AP;
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+		goto out_free;
+
+	}
+	rc = wmi_call(wil, WMI_VRING_CFG_CMDID, &cmd, sizeof(cmd),
+		      WMI_VRING_CFG_DONE_EVENTID, &reply, sizeof(reply), 100);
+	if (rc)
+		goto out_free;
+
+	if (reply.cmd.status != WMI_VRING_CFG_SUCCESS) {
+		wil_err(wil, "Tx config failed, status 0x%02x\n",
+			reply.cmd.status);
+		goto out_free;
+	}
+	vring->hwtail = reply.cmd.tx_vring_tail_ptr;
+
+	return 0;
+ out_free:
+	wil_vring_free(wil, vring, 1);
+ out:
+
+	return rc;
+}
+
+void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
+{
+	struct vring *vring = &wil->vring_tx[id];
+
+	if (!vring->va)
+		return;
+
+	wil_info(wil, "%s(%d)\n", __func__, id);
+
+	wil_vring_free(wil, vring, 1);
+}
+
+static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
+				       struct sk_buff *skb)
+{
+	struct vring *v = &wil->vring_tx[0];
+
+	if (v->va)
+		return v;
+
+	return NULL;
+}
+
+static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len)
+{
+	d->dma.addr_low = lower_32_bits(pa);
+	d->dma.addr_high = (u16)upper_32_bits(pa);
+	d->dma.ip_length = 0;
+	/* 0..6: mac_length; 7:ip_version 0-IP6 1-IP4*/
+	d->dma.b11 = 0/*14 | BIT(7)*/;
+	d->dma.error = 0;
+	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
+	d->dma.length = len;
+	d->dma.d0 = 0;
+	d->mac.d[0] = 0;
+	d->mac.d[1] = 0;
+	d->mac.d[2] = 0;
+	d->mac.ucode_cmd = 0;
+	/* use dst index 0 */
+	d->mac.d[1] |= BIT(MAC_CFG_DESC_TX_1_DST_INDEX_EN_POS) |
+		       (0 << MAC_CFG_DESC_TX_1_DST_INDEX_POS);
+	/* translation type:  0 - bypass; 1 - 802.3; 2 - native wifi */
+	d->mac.d[2] = BIT(MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_POS) |
+		      (1 << MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_POS);
+
+	return 0;
+}
+
+static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
+			struct sk_buff *skb)
+{
+	struct device *dev = wil_to_dev(wil);
+	struct vring_tx_desc *d;
+	u32 swhead = vring->swhead;
+	int avail = wil_vring_avail_tx(vring);
+	int nr_frags = skb_shinfo(skb)->nr_frags;
+	int f;
+	int vring_index = vring - wil->vring_tx;
+	int i = swhead;
+	dma_addr_t pa;
+
+	wil_dbg_TXRX(wil, "%s()\n", __func__);
+
+	if (avail < vring->size/8)
+		netif_tx_stop_all_queues(wil_to_ndev(wil));
+	if (avail < 1 + nr_frags) {
+		wil_err(wil, "Tx ring full. No space for %d fragments\n",
+			1 + nr_frags);
+		return -ENOMEM;
+	}
+	d = &(vring->va[i].tx);
+
+	/* FIXME FW can accept only unicast frames for the peer */
+	memcpy(skb->data, wil->dst_addr[vring_index], ETH_ALEN);
+
+	pa = dma_map_single(dev, skb->data,
+			skb_headlen(skb), DMA_TO_DEVICE);
+
+	wil_dbg_TXRX(wil, "Tx skb %d bytes %p -> %#08llx\n", skb_headlen(skb),
+		     skb->data, (unsigned long long)pa);
+	wil_hex_dump_TXRX("Tx ", DUMP_PREFIX_OFFSET, 16, 1,
+			  skb->data, skb_headlen(skb), false);
+
+	if (unlikely(dma_mapping_error(dev, pa)))
+		return -EINVAL;
+	/* 1-st segment */
+	wil_tx_desc_map(d, pa, skb_headlen(skb));
+	d->mac.d[2] |= ((nr_frags + 1) <<
+		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+	/* middle segments */
+	for (f = 0; f < nr_frags; f++) {
+		const struct skb_frag_struct *frag =
+				&skb_shinfo(skb)->frags[f];
+		int len = skb_frag_size(frag);
+		i = (swhead + f + 1) % vring->size;
+		d = &(vring->va[i].tx);
+		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
+				DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, pa)))
+			goto dma_error;
+		wil_tx_desc_map(d, pa, len);
+		vring->ctx[i] = NULL;
+	}
+	/* for the last seg only */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
+	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
+	d->dma.d0 |= (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
+
+	wil_hex_dump_TXRX("Tx ", DUMP_PREFIX_NONE, 32, 4, d, sizeof(*d), false);
+
+	/* advance swhead */
+	wil_vring_advance_head(vring, nr_frags + 1);
+	wil_dbg_TXRX(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
+	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
+	/* hold reference to skb
+	 * to prevent skb release before accounting
+	 * in case of immediate "tx done"
+	 */
+	vring->ctx[i] = skb_get(skb);
+
+	return 0;
+ dma_error:
+	/* unmap what we have mapped */
+	for (; f > -1; f--) {
+		i = (swhead + f + 1) % vring->size;
+		d = &(vring->va[i].tx);
+		d->dma.status = TX_DMA_STATUS_DU;
+		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		if (vring->ctx[i])
+			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
+		else
+			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+	}
+
+	return -EINVAL;
+}
+
+
+netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	struct vring *vring;
+	int rc;
+
+	wil_dbg_TXRX(wil, "%s()\n", __func__);
+	if (!test_bit(wil_status_fwready, &wil->status)) {
+		wil_err(wil, "FW not ready\n");
+		goto drop;
+	}
+	if (!test_bit(wil_status_fwconnected, &wil->status)) {
+		wil_err(wil, "FW not connected\n");
+		goto drop;
+	}
+	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		wil_err(wil, "Xmit in monitor mode not supported\n");
+		goto drop;
+	}
+	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+		rc = wmi_tx_eapol(wil, skb);
+	} else {
+		/* find vring */
+		vring = wil_find_tx_vring(wil, skb);
+		if (!vring) {
+			wil_err(wil, "No Tx VRING available\n");
+			goto drop;
+		}
+		/* set up vring entry */
+		rc = wil_tx_vring(wil, vring, skb);
+	}
+	switch (rc) {
+	case 0:
+		ndev->stats.tx_packets++;
+		ndev->stats.tx_bytes += skb->len;
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	case -ENOMEM:
+		return NETDEV_TX_BUSY;
+	default:
+		; /* goto drop; */
+		break;
+	}
+ drop:
+	netif_tx_stop_all_queues(ndev);
+	ndev->stats.tx_dropped++;
+	dev_kfree_skb_any(skb);
+
+	return NET_XMIT_DROP;
+}
+
+/**
+ * Clean up transmitted skb's from the Tx VRING
+ *
+ * Safe to call from IRQ
+ */
+void wil_tx_complete(struct wil6210_priv *wil, int ringid)
+{
+	struct device *dev = wil_to_dev(wil);
+	struct vring *vring = &wil->vring_tx[ringid];
+
+	if (!vring->va) {
+		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
+		return;
+	}
+
+	wil_dbg_TXRX(wil, "%s(%d)\n", __func__, ringid);
+
+	while (!wil_vring_is_empty(vring)) {
+		struct vring_tx_desc *d = &vring->va[vring->swtail].tx;
+		dma_addr_t pa;
+		struct sk_buff *skb;
+		if (!(d->dma.status & TX_DMA_STATUS_DU))
+			break;
+
+		wil_dbg_TXRX(wil,
+			     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
+			     vring->swtail, d->dma.length, d->dma.status,
+			     d->dma.error);
+		wil_hex_dump_TXRX("TxC ", DUMP_PREFIX_NONE, 32, 4,
+				  d, sizeof(*d), false);
+
+		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		skb = vring->ctx[vring->swtail];
+		if (skb) {
+			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
+			dev_kfree_skb_any(skb);
+			vring->ctx[vring->swtail] = NULL;
+		} else {
+			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+		}
+		d->dma.addr_low = 0;
+		d->dma.addr_high = 0;
+		d->dma.length = 0;
+		d->dma.status = TX_DMA_STATUS_DU;
+		vring->swtail = wil_vring_next_tail(vring);
+	}
+	if (wil_vring_avail_tx(vring) > vring->size/4)
+		netif_tx_wake_all_queues(wil_to_ndev(wil));
+}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
new file mode 100644
index 0000000..8c2717b
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -0,0 +1,352 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef WIL6210_TXRX_H
+#define WIL6210_TXRX_H
+
+#define BUF_SW_OWNED    (1)
+#define BUF_HW_OWNED    (0)
+
+/* size of max. Rx packet */
+#define RX_BUF_LEN      (2048)
+#define TX_BUF_LEN      (2048)
+/* how many bytes to reserve for rtap header? */
+#define WIL6210_RTAP_SIZE (128)
+
+/* Tx/Rx path */
+/*
+ * Tx descriptor - MAC part
+ * [dword 0]
+ * bit  0.. 9 : lifetime_expiry_value:10
+ * bit     10 : interrup_en:1
+ * bit     11 : status_en:1
+ * bit 12..13 : txss_override:2
+ * bit     14 : timestamp_insertion:1
+ * bit     15 : duration_preserve:1
+ * bit 16..21 : reserved0:6
+ * bit 22..26 : mcs_index:5
+ * bit     27 : mcs_en:1
+ * bit 28..29 : reserved1:2
+ * bit     30 : reserved2:1
+ * bit     31 : sn_preserved:1
+ * [dword 1]
+ * bit  0.. 3 : pkt_mode:4
+ * bit      4 : pkt_mode_en:1
+ * bit  5.. 7 : reserved0:3
+ * bit  8..13 : reserved1:6
+ * bit     14 : reserved2:1
+ * bit     15 : ack_policy_en:1
+ * bit 16..19 : dst_index:4
+ * bit     20 : dst_index_en:1
+ * bit 21..22 : ack_policy:2
+ * bit     23 : lifetime_en:1
+ * bit 24..30 : max_retry:7
+ * bit     31 : max_retry_en:1
+ * [dword 2]
+ * bit  0.. 7 : num_of_descriptors:8
+ * bit  8..17 : reserved:10
+ * bit 18..19 : l2_translation_type:2
+ * bit     20 : snap_hdr_insertion_en:1
+ * bit     21 : vlan_removal_en:1
+ * bit 22..31 : reserved0:10
+ * [dword 3]
+ * bit  0.. 31: ucode_cmd:32
+ */
+struct vring_tx_mac {
+	u32 d[3];
+	u32 ucode_cmd;
+} __packed;
+
+/* TX MAC Dword 0 */
+#define MAC_CFG_DESC_TX_0_LIFETIME_EXPIRY_VALUE_POS 0
+#define MAC_CFG_DESC_TX_0_LIFETIME_EXPIRY_VALUE_LEN 10
+#define MAC_CFG_DESC_TX_0_LIFETIME_EXPIRY_VALUE_MSK 0x3FF
+
+#define MAC_CFG_DESC_TX_0_INTERRUP_EN_POS 10
+#define MAC_CFG_DESC_TX_0_INTERRUP_EN_LEN 1
+#define MAC_CFG_DESC_TX_0_INTERRUP_EN_MSK 0x400
+
+#define MAC_CFG_DESC_TX_0_STATUS_EN_POS 11
+#define MAC_CFG_DESC_TX_0_STATUS_EN_LEN 1
+#define MAC_CFG_DESC_TX_0_STATUS_EN_MSK 0x800
+
+#define MAC_CFG_DESC_TX_0_TXSS_OVERRIDE_POS 12
+#define MAC_CFG_DESC_TX_0_TXSS_OVERRIDE_LEN 2
+#define MAC_CFG_DESC_TX_0_TXSS_OVERRIDE_MSK 0x3000
+
+#define MAC_CFG_DESC_TX_0_TIMESTAMP_INSERTION_POS 14
+#define MAC_CFG_DESC_TX_0_TIMESTAMP_INSERTION_LEN 1
+#define MAC_CFG_DESC_TX_0_TIMESTAMP_INSERTION_MSK 0x4000
+
+#define MAC_CFG_DESC_TX_0_DURATION_PRESERVE_POS 15
+#define MAC_CFG_DESC_TX_0_DURATION_PRESERVE_LEN 1
+#define MAC_CFG_DESC_TX_0_DURATION_PRESERVE_MSK 0x8000
+
+#define MAC_CFG_DESC_TX_0_MCS_INDEX_POS 22
+#define MAC_CFG_DESC_TX_0_MCS_INDEX_LEN 5
+#define MAC_CFG_DESC_TX_0_MCS_INDEX_MSK 0x7C00000
+
+#define MAC_CFG_DESC_TX_0_MCS_EN_POS 27
+#define MAC_CFG_DESC_TX_0_MCS_EN_LEN 1
+#define MAC_CFG_DESC_TX_0_MCS_EN_MSK 0x8000000
+
+#define MAC_CFG_DESC_TX_0_SN_PRESERVED_POS 31
+#define MAC_CFG_DESC_TX_0_SN_PRESERVED_LEN 1
+#define MAC_CFG_DESC_TX_0_SN_PRESERVED_MSK 0x80000000
+
+/* TX MAC Dword 1 */
+#define MAC_CFG_DESC_TX_1_PKT_MODE_POS 0
+#define MAC_CFG_DESC_TX_1_PKT_MODE_LEN 4
+#define MAC_CFG_DESC_TX_1_PKT_MODE_MSK 0xF
+
+#define MAC_CFG_DESC_TX_1_PKT_MODE_EN_POS 4
+#define MAC_CFG_DESC_TX_1_PKT_MODE_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_PKT_MODE_EN_MSK 0x10
+
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_EN_POS 15
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_EN_MSK 0x8000
+
+#define MAC_CFG_DESC_TX_1_DST_INDEX_POS 16
+#define MAC_CFG_DESC_TX_1_DST_INDEX_LEN 4
+#define MAC_CFG_DESC_TX_1_DST_INDEX_MSK 0xF0000
+
+#define MAC_CFG_DESC_TX_1_DST_INDEX_EN_POS 20
+#define MAC_CFG_DESC_TX_1_DST_INDEX_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_DST_INDEX_EN_MSK 0x100000
+
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_POS 21
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_LEN 2
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_MSK 0x600000
+
+#define MAC_CFG_DESC_TX_1_LIFETIME_EN_POS 23
+#define MAC_CFG_DESC_TX_1_LIFETIME_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_LIFETIME_EN_MSK 0x800000
+
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_POS 24
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_LEN 7
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_MSK 0x7F000000
+
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_EN_POS 31
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_EN_MSK 0x80000000
+
+/* TX MAC Dword 2 */
+#define MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS 0
+#define MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_LEN 8
+#define MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_MSK 0xFF
+
+#define MAC_CFG_DESC_TX_2_RESERVED_POS 8
+#define MAC_CFG_DESC_TX_2_RESERVED_LEN 10
+#define MAC_CFG_DESC_TX_2_RESERVED_MSK 0x3FF00
+
+#define MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_POS 18
+#define MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_LEN 2
+#define MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_MSK 0xC0000
+
+#define MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_POS 20
+#define MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_LEN 1
+#define MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_MSK 0x100000
+
+#define MAC_CFG_DESC_TX_2_VLAN_REMOVAL_EN_POS 21
+#define MAC_CFG_DESC_TX_2_VLAN_REMOVAL_EN_LEN 1
+#define MAC_CFG_DESC_TX_2_VLAN_REMOVAL_EN_MSK 0x200000
+
+/* TX MAC Dword 3 */
+#define MAC_CFG_DESC_TX_3_UCODE_CMD_POS 0
+#define MAC_CFG_DESC_TX_3_UCODE_CMD_LEN 32
+#define MAC_CFG_DESC_TX_3_UCODE_CMD_MSK 0xFFFFFFFF
+
+/* TX DMA Dword 0 */
+#define DMA_CFG_DESC_TX_0_L4_LENGTH_POS 0
+#define DMA_CFG_DESC_TX_0_L4_LENGTH_LEN 8
+#define DMA_CFG_DESC_TX_0_L4_LENGTH_MSK 0xFF
+
+#define DMA_CFG_DESC_TX_0_CMD_EOP_POS 8
+#define DMA_CFG_DESC_TX_0_CMD_EOP_LEN 1
+#define DMA_CFG_DESC_TX_0_CMD_EOP_MSK 0x100
+
+#define DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS 10
+#define DMA_CFG_DESC_TX_0_CMD_DMA_IT_LEN 1
+#define DMA_CFG_DESC_TX_0_CMD_DMA_IT_MSK 0x400
+
+#define DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_POS 11
+#define DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_LEN 2
+#define DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_MSK 0x1800
+
+#define DMA_CFG_DESC_TX_0_TCP_SEG_EN_POS 13
+#define DMA_CFG_DESC_TX_0_TCP_SEG_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_TCP_SEG_EN_MSK 0x2000
+
+#define DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_POS 14
+#define DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_MSK 0x4000
+
+#define DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS 15
+#define DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_MSK 0x8000
+
+#define DMA_CFG_DESC_TX_0_QID_POS 16
+#define DMA_CFG_DESC_TX_0_QID_LEN 5
+#define DMA_CFG_DESC_TX_0_QID_MSK 0x1F0000
+
+#define DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS 21
+#define DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_MSK 0x200000
+
+#define DMA_CFG_DESC_TX_0_L4_TYPE_POS 30
+#define DMA_CFG_DESC_TX_0_L4_TYPE_LEN 2
+#define DMA_CFG_DESC_TX_0_L4_TYPE_MSK 0xC0000000
+
+
+#define TX_DMA_STATUS_DU         BIT(0)
+
+struct vring_tx_dma {
+	u32 d0;
+	u32 addr_low;
+	u16 addr_high;
+	u8  ip_length;
+	u8  b11;       /* 0..6: mac_length; 7:ip_version */
+	u8  error;     /* 0..2: err; 3..7: reserved; */
+	u8  status;    /* 0: used; 1..7; reserved */
+	u16 length;
+} __packed;
+
+/*
+ * Rx descriptor - MAC part
+ * [dword 0]
+ * bit  0.. 3 : tid:4 The QoS (b3-0) TID Field
+ * bit  4.. 6 : connection_id:3 :The Source index that  was found during
+ *  Parsing the TA.  This field is used to  define the source of the packet
+ * bit      7 : reserved:1
+ * bit  8.. 9 : mac_id:2 : The MAC virtual  Ring number (always zero)
+ * bit 10..11 : frame_type:2 : The FC Control  (b3-2) -  MPDU Type
+ *              (management, data, control  and extension)
+ * bit 12..15 : frame_subtype:4 : The FC Control  (b7-4) -  Frame Subtype
+ * bit 16..27 : seq_number:12 The received Sequence number field
+ * bit 28..31 : extended:4 extended subtype
+ * [dword 1]
+ * bit  0.. 3 : reserved
+ * bit  4.. 5 : key_id:2
+ * bit      6 : decrypt_bypass:1
+ * bit      7 : security:1
+ * bit  8.. 9 : ds_bits:2
+ * bit     10 : a_msdu_present:1  from qos header
+ * bit     11 : a_msdu_type:1  from qos header
+ * bit     12 : a_mpdu:1  part of AMPDU aggregation
+ * bit     13 : broadcast:1
+ * bit     14 : mutlicast:1
+ * bit     15 : reserved:1
+ * bit 16..20 : rx_mac_qid:5   The Queue Identifier that the packet
+ *                             is received from
+ * bit 21..24 : mcs:4
+ * bit 25..28 : mic_icr:4
+ * bit 29..31 : reserved:3
+ * [dword 2]
+ * bit  0.. 2 : time_slot:3 The timeslot that the MPDU is received
+ * bit      3 : fc_protocol_ver:1 The FC Control  (b0) - Protocol  Version
+ * bit      4 : fc_order:1 The FC Control (b15) -Order
+ * bit  5.. 7 : qos_ack_policy:3  The QoS (b6-5) ack policy Field
+ * bit      8 : esop:1 The QoS (b4) ESOP field
+ * bit      9 : qos_rdg_more_ppdu:1 The QoS (b9) RDG  field
+ * bit 10..14 : qos_reserved:5 The QoS (b14-10) Reserved  field
+ * bit     15 : qos_ac_constraint:1
+ * bit 16..31 : pn_15_0:16 low 2 bytes of PN
+ * [dword 3]
+ * bit  0..31 : pn_47_16:32 high 4 bytes of PN
+ */
+struct vring_rx_mac {
+	u32 d0;
+	u32 d1;
+	u16 w4;
+	u16 pn_15_0;
+	u32 pn_47_16;
+} __packed;
+
+/*
+ * Rx descriptor - DMA part
+ * [dword 0]
+ * bit  0.. 7 : l4_length:8 layer 4 length
+ * bit  8.. 9 : reserved:2
+ * bit     10 : cmd_dma_it:1
+ * bit 11..15 : reserved:5
+ * bit 16..29 : phy_info_length:14
+ * bit 30..31 : l4_type:2 valid if the L4I bit is set in the status field
+ * [dword 1]
+ * bit  0..31 : addr_low:32 The payload buffer low address
+ * [dword 2]
+ * bit  0..15 : addr_high:16 The payload buffer high address
+ * bit 16..23 : ip_length:8
+ * bit 24..30 : mac_length:7
+ * bit     31 : ip_version:1
+ * [dword 3]
+ *  [byte 12] error
+ *  [byte 13] status
+ * bit      0 : du:1
+ * bit      1 : eop:1
+ * bit      2 : error:1
+ * bit      3 : mi:1
+ * bit      4 : l3_identified:1
+ * bit      5 : l4_identified:1
+ * bit      6 : phy_info_included:1
+ * bit      7 : reserved:1
+ *  [word 7] length
+ *
+ */
+
+#define RX_DMA_D0_CMD_DMA_IT     BIT(10)
+
+#define RX_DMA_STATUS_DU         BIT(0)
+#define RX_DMA_STATUS_ERROR      BIT(2)
+#define RX_DMA_STATUS_PHY_INFO   BIT(6)
+
+struct vring_rx_dma {
+	u32 d0;
+	u32 addr_low;
+	u16 addr_high;
+	u8  ip_length;
+	u8  b11;
+	u8  error;
+	u8  status;
+	u16 length;
+} __packed;
+
+struct vring_tx_desc {
+	struct vring_tx_mac mac;
+	struct vring_tx_dma dma;
+} __packed;
+
+struct vring_rx_desc {
+	struct vring_rx_mac mac;
+	struct vring_rx_dma dma;
+} __packed;
+
+union vring_desc {
+	struct vring_tx_desc tx;
+	struct vring_rx_desc rx;
+} __packed;
+
+static inline int wil_rxdesc_phy_length(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->dma.d0, 16, 29);
+}
+
+static inline int wil_rxdesc_mcs(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 21, 24);
+}
+
+#endif /* WIL6210_TXRX_H */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
new file mode 100644
index 0000000..13b5800
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -0,0 +1,370 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __WIL6210_H__
+#define __WIL6210_H__
+
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <net/cfg80211.h>
+
+#define WIL_NAME "wil6210"
+
+/**
+ * extract bits [@b0:@b1] (inclusive) from the value @x
+ * it should be @b0 <= @b1, or result is incorrect
+ */
+static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
+{
+	return (x >> b0) & ((1 << (b1 - b0 + 1)) - 1);
+}
+
+/* Candidate to merge into printk.h and dynamic_debug.h */
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)		\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, prefix_str);	\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+		print_hex_dump(KERN_DEBUG, prefix_str,		\
+			       prefix_type, rowsize, groupsize,	\
+			       buf, len, ascii);		\
+} while (0)
+
+#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)		\
+		       dynamic_hex_dump(prefix_str, prefix_type,\
+					rowsize, groupsize, buf,\
+					len, ascii)
+#else
+#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)		\
+		       print_hex_dump(KERN_DEBUG, prefix_str,	\
+				      prefix_type, rowsize,	\
+				      groupsize, buf, len, ascii)
+#endif
+
+#define WIL6210_MEM_SIZE (2*1024*1024UL)
+
+#define WIL6210_TX_QUEUES (4)
+
+#define WIL6210_RX_RING_SIZE (128)
+#define WIL6210_TX_RING_SIZE (128)
+#define WIL6210_MAX_TX_RINGS (24)
+
+/* Hardware definitions begin */
+
+/*
+ * Mapping
+ * RGF File      | Host addr    |  FW addr
+ *               |              |
+ * user_rgf      | 0x000000     | 0x880000
+ *  dma_rgf      | 0x001000     | 0x881000
+ * pcie_rgf      | 0x002000     | 0x882000
+ *               |              |
+ */
+
+/* Where various structures placed in host address space */
+#define WIL6210_FW_HOST_OFF      (0x880000UL)
+
+#define HOSTADDR(fwaddr)        (fwaddr - WIL6210_FW_HOST_OFF)
+
+/*
+ * Interrupt control registers block
+ *
+ * each interrupt controlled by the same bit in all registers
+ */
+struct RGF_ICR {
+	u32 ICC; /* Cause Control, RW: 0 - W1C, 1 - COR */
+	u32 ICR; /* Cause, W1C/COR depending on ICC */
+	u32 ICM; /* Cause masked (ICR & ~IMV), W1C/COR depending on ICC */
+	u32 ICS; /* Cause Set, WO */
+	u32 IMV; /* Mask, RW+S/C */
+	u32 IMS; /* Mask Set, write 1 to set */
+	u32 IMC; /* Mask Clear, write 1 to clear */
+} __packed;
+
+/* registers - FW addresses */
+#define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
+#define RGF_USER_USER_ICR		(0x880b4c) /* struct RGF_ICR */
+	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
+#define RGF_USER_CLKS_CTL_SW_RST_MASK_0	(0x880b14)
+#define RGF_USER_MAC_CPU_0		(0x8801fc)
+#define RGF_USER_USER_CPU_0		(0x8801e0)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_0	(0x880b04)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_1	(0x880b08)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_2	(0x880b0c)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_3	(0x880b10)
+
+#define RGF_DMA_PSEUDO_CAUSE		(0x881c68)
+#define RGF_DMA_PSEUDO_CAUSE_MASK_SW	(0x881c6c)
+#define RGF_DMA_PSEUDO_CAUSE_MASK_FW	(0x881c70)
+	#define BIT_DMA_PSEUDO_CAUSE_RX		BIT(0)
+	#define BIT_DMA_PSEUDO_CAUSE_TX		BIT(1)
+	#define BIT_DMA_PSEUDO_CAUSE_MISC	BIT(2)
+
+#define RGF_DMA_EP_TX_ICR		(0x881bb4) /* struct RGF_ICR */
+	#define BIT_DMA_EP_TX_ICR_TX_DONE	BIT(0)
+	#define BIT_DMA_EP_TX_ICR_TX_DONE_N(n)	BIT(n+1) /* n = [0..23] */
+#define RGF_DMA_EP_RX_ICR		(0x881bd0) /* struct RGF_ICR */
+	#define BIT_DMA_EP_RX_ICR_RX_DONE	BIT(0)
+#define RGF_DMA_EP_MISC_ICR		(0x881bec) /* struct RGF_ICR */
+	#define BIT_DMA_EP_MISC_ICR_FW_INT0	BIT(28)
+	#define BIT_DMA_EP_MISC_ICR_FW_INT1	BIT(29)
+
+/* popular locations */
+#define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
+#define HOST_SW_INT (HOSTADDR(RGF_USER_USER_ICR) + \
+	offsetof(struct RGF_ICR, ICS))
+#define SW_INT_MBOX BIT_USER_USER_ICR_SW_INT_2
+
+/* ISR register bits */
+#define ISR_MISC_FW_READY BIT_DMA_EP_MISC_ICR_FW_INT0
+#define ISR_MISC_MBOX_EVT BIT_DMA_EP_MISC_ICR_FW_INT1
+
+/* Hardware definitions end */
+
+struct wil6210_mbox_ring {
+	u32 base;
+	u16 entry_size; /* max. size of mbox entry, incl. all headers */
+	u16 size;
+	u32 tail;
+	u32 head;
+} __packed;
+
+struct wil6210_mbox_ring_desc {
+	u32 sync;
+	u32 addr;
+} __packed;
+
+/* at HOST_OFF_WIL6210_MBOX_CTL */
+struct wil6210_mbox_ctl {
+	struct wil6210_mbox_ring tx;
+	struct wil6210_mbox_ring rx;
+} __packed;
+
+struct wil6210_mbox_hdr {
+	u16 seq;
+	u16 len; /* payload, bytes after this header */
+	u16 type;
+	u8 flags;
+	u8 reserved;
+} __packed;
+
+/* max. value for wil6210_mbox_hdr.len */
+#define MAX_MBOXITEM_SIZE   (240)
+
+struct wil6210_mbox_hdr_wmi {
+	u16 reserved0;
+	u16 id;
+	u16 info1; /* bits [0..3] - device_id, rest - unused */
+	u16 reserved1;
+} __packed;
+
+struct pending_wmi_event {
+	struct list_head list;
+	struct {
+		struct wil6210_mbox_hdr hdr;
+		struct wil6210_mbox_hdr_wmi wmi;
+		u8 data[0];
+	} __packed event;
+};
+
+union vring_desc;
+
+struct vring {
+	dma_addr_t pa;
+	union vring_desc *va; /* vring_desc[size] */
+	u16 size; /* number of vring_desc elements */
+	u32 swtail;
+	u32 swhead;
+	u32 hwtail; /* write here to inform hw */
+	void **ctx; /* void *ctx[size] - software context */
+};
+
+enum { /* for wil6210_priv.status */
+	wil_status_fwready = 0,
+	wil_status_fwconnected,
+	wil_status_dontscan,
+	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
+};
+
+struct pci_dev;
+
+struct wil6210_stats {
+	u64 tsf;
+	u16 last_mcs_rx;
+	u16 bf_mcs; /* last BF, used for Tx */
+	u16 my_rx_sector;
+	u16 my_tx_sector;
+	u16 peer_rx_sector;
+	u16 peer_tx_sector;
+};
+
+struct wil6210_priv {
+	struct pci_dev *pdev;
+	int n_msi;
+	struct wireless_dev *wdev;
+	void __iomem *csr;
+	ulong status;
+	/* profile */
+	u32 monitor_flags;
+	struct ieee80211_channel *channel;
+	u8 ssid[32]; /* for AP/P2P-GO */
+	u8 ssid_len;
+	int secure_pcp; /* create secure PCP? */
+	/* cached ISR registers */
+	u32 isr_rx;
+	u32 isr_tx;
+	u32 isr_misc;
+	/* mailbox related */
+	struct mutex wmi_mutex;
+	struct wil6210_mbox_ctl mbox_ctl;
+	struct completion wmi_ready;
+	u16 wmi_seq;
+	u16 reply_id; /**< wait for this WMI event */
+	void *reply_buf;
+	u16 reply_size;
+	struct workqueue_struct *wmi_wq; /* for deferred calls */
+	struct work_struct wmi_event_worker;
+	struct workqueue_struct *wmi_wq_conn; /* for connect worker */
+	struct work_struct wmi_connect_worker;
+	struct work_struct disconnect_worker;
+	struct timer_list connect_timer;
+	int pending_connect_cid;
+	struct list_head pending_wmi_ev;
+	/*
+	 * protect pending_wmi_ev
+	 * - fill in IRQ from wil6210_irq_misc,
+	 * - consumed in thread by wmi_event_worker
+	 */
+	spinlock_t wmi_ev_lock;
+	/* DMA related */
+	struct vring vring_rx;
+	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
+	u8 dst_addr[WIL6210_MAX_TX_RINGS][ETH_ALEN];
+	/* scan */
+	struct cfg80211_scan_request *scan_request;
+
+	struct mutex mutex; /* for wil6210_priv access in wil_{up|down} */
+	/* statistics */
+	struct wil6210_stats stats;
+	/* debugfs */
+	struct dentry *debug;
+	struct debugfs_blob_wrapper fw_code_blob;
+	struct debugfs_blob_wrapper fw_data_blob;
+	struct debugfs_blob_wrapper fw_peri_blob;
+	struct debugfs_blob_wrapper uc_code_blob;
+	struct debugfs_blob_wrapper uc_data_blob;
+	struct debugfs_blob_wrapper rgf_blob;
+};
+
+#define wil_to_wiphy(i) (i->wdev->wiphy)
+#define wil_to_dev(i) (wiphy_dev(wil_to_wiphy(i)))
+#define wiphy_to_wil(w) (struct wil6210_priv *)(wiphy_priv(w))
+#define wil_to_wdev(i) (i->wdev)
+#define wdev_to_wil(w) (struct wil6210_priv *)(wdev_priv(w))
+#define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
+#define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
+
+#define wil_dbg(wil, fmt, arg...) netdev_dbg(wil_to_ndev(wil), fmt, ##arg)
+#define wil_info(wil, fmt, arg...) netdev_info(wil_to_ndev(wil), fmt, ##arg)
+#define wil_err(wil, fmt, arg...) netdev_err(wil_to_ndev(wil), fmt, ##arg)
+
+#define wil_dbg_IRQ(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
+#define wil_dbg_TXRX(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
+
+#define wil_hex_dump_TXRX(prefix_str, prefix_type, rowsize,	\
+			  groupsize, buf, len, ascii)		\
+			  debug_hex_dump("DBG[TXRX]" prefix_str,\
+					 prefix_type, rowsize,	\
+					 groupsize, buf, len, ascii)
+
+void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
+			  size_t count);
+void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
+			size_t count);
+
+void *wil_if_alloc(struct device *dev, void __iomem *csr);
+void wil_if_free(struct wil6210_priv *wil);
+int wil_if_add(struct wil6210_priv *wil);
+void wil_if_remove(struct wil6210_priv *wil);
+int wil_priv_init(struct wil6210_priv *wil);
+void wil_priv_deinit(struct wil6210_priv *wil);
+int wil_reset(struct wil6210_priv *wil);
+void wil_link_on(struct wil6210_priv *wil);
+void wil_link_off(struct wil6210_priv *wil);
+int wil_up(struct wil6210_priv *wil);
+int wil_down(struct wil6210_priv *wil);
+
+void __iomem *wmi_buffer(struct wil6210_priv *wil, u32 ptr);
+void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr);
+int wmi_read_hdr(struct wil6210_priv *wil, u32 ptr,
+		 struct wil6210_mbox_hdr *hdr);
+int wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len);
+void wmi_recv_cmd(struct wil6210_priv *wil);
+int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
+	     u16 reply_id, void *reply, u8 reply_size, int to_msec);
+void wmi_connect_worker(struct work_struct *work);
+void wmi_event_worker(struct work_struct *work);
+void wmi_event_flush(struct wil6210_priv *wil);
+int wmi_set_ssid(struct wil6210_priv *wil, u8 ssid_len, const void *ssid);
+int wmi_get_ssid(struct wil6210_priv *wil, u8 *ssid_len, void *ssid);
+int wmi_set_channel(struct wil6210_priv *wil, int channel);
+int wmi_get_channel(struct wil6210_priv *wil, int *channel);
+int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb);
+int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr);
+int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr, int key_len, const void *key);
+int wmi_echo(struct wil6210_priv *wil);
+int wmi_set_ie(struct wil6210_priv *wil, u8 type, int ie_len, const void *ie);
+
+int wil6210_init_irq(struct wil6210_priv *wil, int irq);
+void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
+void wil6210_disable_irq(struct wil6210_priv *wil);
+void wil6210_enable_irq(struct wil6210_priv *wil);
+
+int wil6210_debugfs_init(struct wil6210_priv *wil);
+void wil6210_debugfs_remove(struct wil6210_priv *wil);
+
+int wil6210_sysfs_init(struct wil6210_priv *wil);
+void wil6210_sysfs_fini(struct wil6210_priv *wil);
+
+struct wireless_dev *wil_cfg80211_init(struct device *dev);
+void wil_wdev_free(struct wil6210_priv *wil);
+
+int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
+int wmi_set_bcon(struct wil6210_priv *wil, int bi, u16 wmi_nettype);
+void wil6210_disconnect(struct wil6210_priv *wil, void *bssid);
+
+int wil_rx_init(struct wil6210_priv *wil);
+void wil_rx_fini(struct wil6210_priv *wil);
+
+/* TX API */
+int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
+		      int cid, int tid);
+void wil_vring_fini_tx(struct wil6210_priv *wil, int id);
+
+netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev);
+void wil_tx_complete(struct wil6210_priv *wil, int ringid);
+
+/* RX API */
+void wil_rx_handle(struct wil6210_priv *wil);
+
+int wil_iftype_nl2wmi(enum nl80211_iftype type);
+
+#endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
new file mode 100644
index 0000000..8c3171e
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -0,0 +1,964 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/etherdevice.h>
+
+#include "wil6210.h"
+#include "wmi.h"
+
+/**
+ * WMI event receiving - theory of operations
+ *
+ * When firmware about to report WMI event, it fills memory area
+ * in the mailbox and raises misc. IRQ. Thread interrupt handler invoked for
+ * the misc IRQ, function @wmi_recv_cmd called by thread IRQ handler.
+ *
+ * @wmi_recv_cmd reads event, allocates memory chunk  and attaches it to the
+ * event list @wil->pending_wmi_ev. Then, work queue @wil->wmi_wq wakes up
+ * and handles events within the @wmi_event_worker. Every event get detached
+ * from list, processed and deleted.
+ *
+ * Purpose for this mechanism is to release IRQ thread; otherwise,
+ * if WMI event handling involves another WMI command flow, this 2-nd flow
+ * won't be completed because of blocked IRQ thread.
+ */
+
+/**
+ * Addressing - theory of operations
+ *
+ * There are several buses present on the WIL6210 card.
+ * Same memory areas are visible at different address on
+ * the different busses. There are 3 main bus masters:
+ *  - MAC CPU (ucode)
+ *  - User CPU (firmware)
+ *  - AHB (host)
+ *
+ * On the PCI bus, there is one BAR (BAR0) of 2Mb size, exposing
+ * AHB addresses starting from 0x880000
+ *
+ * Internally, firmware uses addresses that allows faster access but
+ * are invisible from the host. To read from these addresses, alternative
+ * AHB address must be used.
+ *
+ * Memory mapping
+ * Linker address         PCI/Host address
+ *                        0x880000 .. 0xa80000  2Mb BAR0
+ * 0x800000 .. 0x807000   0x900000 .. 0x907000  28k DCCM
+ * 0x840000 .. 0x857000   0x908000 .. 0x91f000  92k PERIPH
+ */
+
+/**
+ * @fw_mapping provides memory remapping table
+ */
+static const struct {
+	u32 from; /* linker address - from, inclusive */
+	u32 to;   /* linker address - to, exclusive */
+	u32 host; /* PCI/Host address - BAR0 + 0x880000 */
+} fw_mapping[] = {
+	{0x000000, 0x040000, 0x8c0000}, /* FW code RAM 256k */
+	{0x800000, 0x808000, 0x900000}, /* FW data RAM 32k */
+	{0x840000, 0x860000, 0x908000}, /* peripheral data RAM 128k/96k used */
+	{0x880000, 0x88a000, 0x880000}, /* various RGF */
+	{0x8c0000, 0x932000, 0x8c0000}, /* trivial mapping for upper area */
+	/*
+	 * 920000..930000 ucode code RAM
+	 * 930000..932000 ucode data RAM
+	 */
+};
+
+/**
+ * return AHB address for given firmware/ucode internal (linker) address
+ * @x - internal address
+ * If address have no valid AHB mapping, return 0
+ */
+static u32 wmi_addr_remap(u32 x)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fw_mapping); i++) {
+		if ((x >= fw_mapping[i].from) && (x < fw_mapping[i].to))
+			return x + fw_mapping[i].host - fw_mapping[i].from;
+	}
+
+	return 0;
+}
+
+/**
+ * Check address validity for WMI buffer; remap if needed
+ * @ptr - internal (linker) fw/ucode address
+ *
+ * Valid buffer should be DWORD aligned
+ *
+ * return address for accessing buffer from the host;
+ * if buffer is not valid, return NULL.
+ */
+void __iomem *wmi_buffer(struct wil6210_priv *wil, u32 ptr)
+{
+	u32 off;
+
+	if (ptr % 4)
+		return NULL;
+
+	ptr = wmi_addr_remap(ptr);
+	if (ptr < WIL6210_FW_HOST_OFF)
+		return NULL;
+
+	off = HOSTADDR(ptr);
+	if (off > WIL6210_MEM_SIZE - 4)
+		return NULL;
+
+	return wil->csr + off;
+}
+
+/**
+ * Check address validity
+ */
+void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr)
+{
+	u32 off;
+
+	if (ptr % 4)
+		return NULL;
+
+	if (ptr < WIL6210_FW_HOST_OFF)
+		return NULL;
+
+	off = HOSTADDR(ptr);
+	if (off > WIL6210_MEM_SIZE - 4)
+		return NULL;
+
+	return wil->csr + off;
+}
+
+int wmi_read_hdr(struct wil6210_priv *wil, u32 ptr,
+		 struct wil6210_mbox_hdr *hdr)
+{
+	void __iomem *src = wmi_buffer(wil, ptr);
+	if (!src)
+		return -EINVAL;
+
+	wil_memcpy_fromio_32(hdr, src, sizeof(*hdr));
+
+	return 0;
+}
+
+static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
+{
+	struct {
+		struct wil6210_mbox_hdr hdr;
+		struct wil6210_mbox_hdr_wmi wmi;
+	} __packed cmd = {
+		.hdr = {
+			.type = 0,
+			.flags = 0,
+			.len = sizeof(cmd.wmi) + len,
+		},
+		.wmi = {
+			.id = cmdid,
+			.info1 = 0,
+		},
+	};
+	struct wil6210_mbox_ring *r = &wil->mbox_ctl.tx;
+	struct wil6210_mbox_ring_desc d_head;
+	u32 next_head;
+	void __iomem *dst;
+	void __iomem *head = wmi_addr(wil, r->head);
+	int retry;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	if (sizeof(cmd) + len > r->entry_size) {
+		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
+			(int)(sizeof(cmd) + len), r->entry_size);
+		return -ERANGE;
+
+	}
+
+	might_sleep();
+
+	if (!test_bit(wil_status_fwready, &wil->status)) {
+		wil_err(wil, "FW not ready\n");
+		return -EAGAIN;
+	}
+
+	if (!head) {
+		wil_err(wil, "WMI head is garbage: 0x%08x\n", r->head);
+		return -EINVAL;
+	}
+	/* read Tx head till it is not busy */
+	for (retry = 5; retry > 0; retry--) {
+		wil_memcpy_fromio_32(&d_head, head, sizeof(d_head));
+		if (d_head.sync == 0)
+			break;
+		msleep(20);
+	}
+	if (d_head.sync != 0) {
+		wil_err(wil, "WMI head busy\n");
+		return -EBUSY;
+	}
+	/* next head */
+	next_head = r->base + ((r->head - r->base + sizeof(d_head)) % r->size);
+	wil_info(wil, "Head 0x%08x -> 0x%08x\n", r->head, next_head);
+	/* wait till FW finish with previous command */
+	for (retry = 5; retry > 0; retry--) {
+		r->tail = ioread32(wil->csr + HOST_MBOX +
+				   offsetof(struct wil6210_mbox_ctl, tx.tail));
+		if (next_head != r->tail)
+			break;
+		msleep(20);
+	}
+	if (next_head == r->tail) {
+		wil_err(wil, "WMI ring full\n");
+		return -EBUSY;
+	}
+	dst = wmi_buffer(wil, d_head.addr);
+	if (!dst) {
+		wil_err(wil, "invalid WMI buffer: 0x%08x\n", d_head.addr);
+		return -EINVAL;
+	}
+	cmd.hdr.seq = ++wil->wmi_seq;
+	/* set command */
+	wil_info(wil, "WMI command 0x%04x [%d]\n", cmdid, len);
+	print_hex_dump(KERN_INFO, "Cmd ", DUMP_PREFIX_OFFSET, 16, 1, &cmd,
+		       sizeof(cmd), true);
+	print_hex_dump(KERN_INFO, "cmd ", DUMP_PREFIX_OFFSET, 16, 1, buf,
+		       len, true);
+	wil_memcpy_toio_32(dst, &cmd, sizeof(cmd));
+	wil_memcpy_toio_32(dst + sizeof(cmd), buf, len);
+	/* mark entry as full */
+	iowrite32(1, wil->csr + HOSTADDR(r->head) +
+		  offsetof(struct wil6210_mbox_ring_desc, sync));
+	/* advance next ptr */
+	iowrite32(r->head = next_head, wil->csr + HOST_MBOX +
+		  offsetof(struct wil6210_mbox_ctl, tx.head));
+
+	/* interrupt to FW */
+	iowrite32(SW_INT_MBOX, wil->csr + HOST_SW_INT);
+
+	return 0;
+}
+
+int wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
+{
+	int rc;
+
+	mutex_lock(&wil->wmi_mutex);
+	rc = __wmi_send(wil, cmdid, buf, len);
+	mutex_unlock(&wil->wmi_mutex);
+
+	return rc;
+}
+
+/*=== Event handlers ===*/
+static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	struct wmi_ready_event *evt = d;
+	u32 ver = evt->sw_version;
+
+	wil_info(wil, "FW ver. %d; MAC %pM\n", ver, evt->macaddr);
+
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		memcpy(ndev->dev_addr, evt->macaddr, ETH_ALEN);
+		memcpy(ndev->perm_addr, evt->macaddr, ETH_ALEN);
+	}
+	snprintf(wdev->wiphy->fw_version, sizeof(wdev->wiphy->fw_version),
+		 "%d", ver);
+}
+
+static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
+			     int len)
+{
+	wil_info(wil, "WMI: FW ready\n");
+
+	set_bit(wil_status_fwready, &wil->status);
+	/* reuse wmi_ready for the firmware ready indication */
+	complete(&wil->wmi_ready);
+}
+
+static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct wmi_rx_mgmt_packet_event *data = d;
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+	struct ieee80211_mgmt *rx_mgmt_frame =
+			(struct ieee80211_mgmt *)data->payload;
+	int ch_no = data->channel+1;
+	u32 freq = ieee80211_channel_to_frequency(ch_no,
+			IEEE80211_BAND_60GHZ);
+	struct ieee80211_channel *channel = ieee80211_get_channel(wiphy, freq);
+	/* TODO convert LE to CPU */
+	s32 signal = 0; /* TODO */
+	__le16 fc = rx_mgmt_frame->frame_control;
+
+	wil_info(wil, "MGMT: channel %d MCS %d stype %02x\n",
+		 data->channel, data->mcs, data->stype);
+	wil_info(wil, "status 0x%08x len %d\n", data->status, data->length);
+	wil_info(wil, "qid %d mid %d cid %d\n",
+		 data->qid, data->mid, data->cid);
+
+	if (!channel) {
+		wil_err(wil, "Frame on unsupported channel\n");
+		return;
+	}
+
+	if (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)) {
+		struct cfg80211_bss *bss;
+		u64 tsf = le64_to_cpu(rx_mgmt_frame->u.beacon.timestamp);
+		u16 cap = le16_to_cpu(rx_mgmt_frame->u.beacon.capab_info);
+		u16 bi = le16_to_cpu(rx_mgmt_frame->u.beacon.beacon_int);
+		const u8 *ie_buf = rx_mgmt_frame->u.beacon.variable;
+		size_t ie_len = data->length -
+				offsetof(struct ieee80211_mgmt,
+					 u.beacon.variable);
+		wil_info(wil, "Capability info : 0x%04x\n", cap);
+		/* Hack to work around wrong cap. info TODO: remove when fixed*/
+		if (!(cap & WLAN_CAPABILITY_ESS)) {
+			wil_info(wil, "No ESS bit in capabitity. Set it.\n");
+			cap |= WLAN_CAPABILITY_ESS;
+		}
+		if (cap & WLAN_CAPABILITY_IBSS) {
+			wil_info(wil, "IBSS bit in capabitity. Clear it.\n");
+			cap &= ~WLAN_CAPABILITY_IBSS;
+		}
+		/* FIXME: remove when fixed in FW
+		 * Set "privacy" capability if RSN IE present
+		 */
+		if (cfg80211_find_ie(WLAN_EID_RSN, ie_buf, ie_len))
+			cap |= WLAN_CAPABILITY_PRIVACY;
+
+		bss = cfg80211_inform_bss(wiphy, channel, rx_mgmt_frame->bssid,
+					  tsf, cap, bi, ie_buf, ie_len,
+					  signal, GFP_KERNEL);
+		if (bss) {
+			wil_info(wil, "Added BSS %pM\n", rx_mgmt_frame->bssid);
+			cfg80211_put_bss(bss);
+		} else {
+			wil_err(wil, "cfg80211_inform_bss() failed\n");
+		}
+	}
+}
+
+static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
+				  void *d, int len)
+{
+	if (wil->scan_request) {
+		struct wmi_scan_complete_event *data = d;
+		bool aborted = (data->status != 0);
+		wil_info(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
+		cfg80211_scan_done(wil->scan_request, aborted);
+		wil->scan_request = NULL;
+	} else {
+		wil_err(wil, "SCAN_COMPLETE while not scanning\n");
+	}
+}
+
+static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	struct wmi_connect_event *evt = d;
+	int ch; /* channel number */
+
+	if (len < sizeof(*evt)) {
+		wil_err(wil, "Connect event too short : %d bytes\n", len);
+		return;
+	}
+	if (len != sizeof(*evt) + evt->beaconIeLen + evt->assocReqLen +
+		   evt->assocRespLen) {
+		wil_err(wil,
+			"Connect event corrupted : %d != %d + %d + %d + %d\n",
+			len, (int)sizeof(*evt), evt->beaconIeLen,
+			evt->assocReqLen, evt->assocRespLen);
+		return;
+	}
+	ch = evt->channel + 1;
+	wil_info(wil, "Connect %pM channel [%d] cid %d\n",
+		 evt->bssid, ch, evt->cid);
+	print_hex_dump(KERN_INFO, "connect AI : ", DUMP_PREFIX_OFFSET, 16, 1,
+		       evt->assocInfo, len - sizeof(*evt), true);
+	if ((wdev->iftype == NL80211_IFTYPE_STATION) ||
+	    (wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)) {
+		/* capinfo + listen interval */
+		u8 assoc_req_ie_offset = sizeof(u16) + sizeof(u16);
+		/* capinfo + status code +  associd */
+		u8 assoc_resp_ie_offset = sizeof(u16) + sizeof(u16) +
+				sizeof(u16);
+		u8 *assoc_req_ie = &evt->assocInfo[evt->beaconIeLen +
+				   assoc_req_ie_offset];
+		u8 *assoc_resp_ie = &evt->assocInfo[evt->beaconIeLen +
+				    evt->assocReqLen + assoc_resp_ie_offset];
+		u8 assoc_req_ielen = evt->assocReqLen - assoc_req_ie_offset;
+		u8 assoc_resp_ielen = evt->assocRespLen - assoc_resp_ie_offset;
+
+		if (wdev->sme_state != CFG80211_SME_CONNECTING) {
+			wil_err(wil, "Not in connecting state\n");
+			return;
+		}
+		if (evt->assocReqLen < assoc_req_ie_offset) {
+			wil_info(wil, "No Assoc. Req. info\n");
+			assoc_req_ie = NULL;
+			assoc_req_ielen = 0;
+		}
+		if (evt->assocRespLen < assoc_resp_ie_offset) {
+			wil_info(wil, "No Assoc. Resp. info\n");
+			assoc_resp_ie = NULL;
+			assoc_resp_ielen = 0;
+		}
+		del_timer_sync(&wil->connect_timer);
+		cfg80211_connect_result(ndev, evt->bssid,
+					assoc_req_ie, assoc_req_ielen,
+					assoc_resp_ie, assoc_resp_ielen,
+					WLAN_STATUS_SUCCESS, GFP_KERNEL);
+
+	}
+	set_bit(wil_status_fwconnected, &wil->status);
+
+	/* FIXME FW can transmit only ucast frames to peer */
+	/* FIXME real ring_id instead of hard coded 0 */
+	memcpy(wil->dst_addr[0], evt->bssid, ETH_ALEN);
+
+	wil->pending_connect_cid = evt->cid;
+	queue_work(wil->wmi_wq_conn, &wil->wmi_connect_worker);
+}
+
+static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
+			       void *d, int len)
+{
+	struct wmi_disconnect_event *evt = d;
+
+	wil_info(wil, "Disconnect %pM reason %d proto %d wmi\n",
+		 evt->bssid,
+		 evt->protocolReasonStatus, evt->disconnectReason);
+	wil6210_disconnect(wil, evt->bssid);
+	clear_bit(wil_status_dontscan, &wil->status);
+}
+
+static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct wmi_notify_req_done_event *evt = d;
+
+	if (len < sizeof(*evt)) {
+		wil_err(wil, "Short NOTIFY event\n");
+		return;
+	}
+
+	wil->stats.tsf = evt->tsf;
+	wil->stats.bf_mcs = evt->bf_mcs;
+	wil->stats.my_rx_sector = evt->my_rx_sector;
+	wil->stats.my_tx_sector = evt->my_tx_sector;
+	wil->stats.peer_rx_sector = evt->other_rx_sector;
+	wil->stats.peer_tx_sector = evt->other_tx_sector;
+	wil_info(wil, "Link status, MCS %d TSF 0x%016llx\n"
+		 "BF status 0x%08x metric 0x%08x\n"
+		 "Tx Tpt %d goodput %d Rx goodput %d\n"
+		 "Sectors(rx:tx) my %d:%d peer %d:%d\n",
+		 wil->stats.bf_mcs, wil->stats.tsf, evt->status,
+		 evt->bf_metric, evt->tx_tpt, evt->tx_goodput, evt->rx_goodput,
+		 wil->stats.my_rx_sector, wil->stats.my_tx_sector,
+		 wil->stats.peer_rx_sector, wil->stats.peer_tx_sector);
+}
+
+/*
+ * Firmware reports EAPOL frame using WME event.
+ * Reconstruct Ethernet frame and deliver it via normal Rx
+ */
+static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
+			     void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wmi_eapol_rx_event *evt = d;
+	int sz = evt->eapol_len + ETH_HLEN;
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+
+	wil_info(wil, "EAPOL len %d from %pM\n", evt->eapol_len, evt->src_mac);
+
+	if (evt->eapol_len > 196) { /* TODO: revisit size limit */
+		wil_err(wil, "EAPOL too large\n");
+		return;
+	}
+
+	skb = alloc_skb(sz, GFP_KERNEL);
+	if (!skb) {
+		wil_err(wil, "Failed to allocate skb\n");
+		return;
+	}
+	eth = (struct ethhdr *)skb_put(skb, ETH_HLEN);
+	memcpy(eth->h_dest, ndev->dev_addr, ETH_ALEN);
+	memcpy(eth->h_source, evt->src_mac, ETH_ALEN);
+	eth->h_proto = cpu_to_be16(ETH_P_PAE);
+	memcpy(skb_put(skb, evt->eapol_len), evt->eapol, evt->eapol_len);
+	skb->protocol = eth_type_trans(skb, ndev);
+	if (likely(netif_rx_ni(skb) == NET_RX_SUCCESS)) {
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += skb->len;
+	} else {
+		ndev->stats.rx_dropped++;
+	}
+}
+
+static const struct {
+	int eventid;
+	void (*handler)(struct wil6210_priv *wil, int eventid,
+			void *data, int data_len);
+} wmi_evt_handlers[] = {
+	{WMI_READY_EVENTID,		wmi_evt_ready},
+	{WMI_FW_READY_EVENTID,		wmi_evt_fw_ready},
+	{WMI_RX_MGMT_PACKET_EVENTID,	wmi_evt_rx_mgmt},
+	{WMI_SCAN_COMPLETE_EVENTID,	wmi_evt_scan_complete},
+	{WMI_CONNECT_EVENTID,		wmi_evt_connect},
+	{WMI_DISCONNECT_EVENTID,	wmi_evt_disconnect},
+	{WMI_NOTIFY_REQ_DONE_EVENTID,	wmi_evt_notify},
+	{WMI_EAPOL_RX_EVENTID,		wmi_evt_eapol_rx},
+};
+
+/*
+ * Run in IRQ context
+ * Extract WMI command from mailbox. Queue it to the @wil->pending_wmi_ev
+ * that will be eventually handled by the @wmi_event_worker in the thread
+ * context of thread "wil6210_wmi"
+ */
+void wmi_recv_cmd(struct wil6210_priv *wil)
+{
+	struct wil6210_mbox_ring_desc d_tail;
+	struct wil6210_mbox_hdr hdr;
+	struct wil6210_mbox_ring *r = &wil->mbox_ctl.rx;
+	struct pending_wmi_event *evt;
+	u8 *cmd;
+	void __iomem *src;
+	ulong flags;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	for (;;) {
+		u16 len;
+
+		r->head = ioread32(wil->csr + HOST_MBOX +
+				   offsetof(struct wil6210_mbox_ctl, rx.head));
+		if (r->tail == r->head)
+			return;
+
+		/* read cmd from tail */
+		wil_memcpy_fromio_32(&d_tail, wil->csr + HOSTADDR(r->tail),
+				     sizeof(struct wil6210_mbox_ring_desc));
+		if (d_tail.sync == 0) {
+			wil_err(wil, "Mbox evt not owned by FW?\n");
+			return;
+		}
+
+		if (0 != wmi_read_hdr(wil, d_tail.addr, &hdr)) {
+			wil_err(wil, "Mbox evt at 0x%08x?\n", d_tail.addr);
+			return;
+		}
+
+		len = hdr.len;
+		src = wmi_buffer(wil, d_tail.addr) +
+		      sizeof(struct wil6210_mbox_hdr);
+		evt = kmalloc(ALIGN(offsetof(struct pending_wmi_event,
+					     event.wmi) + len, 4),
+			      GFP_KERNEL);
+		if (!evt) {
+			wil_err(wil, "kmalloc for WMI event (%d) failed\n",
+				len);
+			return;
+		}
+		evt->event.hdr = hdr;
+		cmd = (void *)&evt->event.wmi;
+		wil_memcpy_fromio_32(cmd, src, len);
+		/* mark entry as empty */
+		iowrite32(0, wil->csr + HOSTADDR(r->tail) +
+			  offsetof(struct wil6210_mbox_ring_desc, sync));
+		/* indicate */
+		wil_info(wil, "Mbox evt %04x %04x %04x %02x\n",
+			 hdr.seq, len, hdr.type, hdr.flags);
+		if ((hdr.type == 0) &&  /* TODO: #define */
+		    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
+			wil_info(wil, "WMI event 0x%04x\n",
+				 evt->event.wmi.id);
+		}
+		print_hex_dump(KERN_INFO, "evt ", DUMP_PREFIX_OFFSET, 16, 1,
+			       &evt->event.hdr, sizeof(hdr) + len, true);
+
+		/* advance tail */
+		r->tail = r->base + ((r->tail - r->base +
+			  sizeof(struct wil6210_mbox_ring_desc)) % r->size);
+		iowrite32(r->tail, wil->csr + HOST_MBOX +
+			  offsetof(struct wil6210_mbox_ctl, rx.tail));
+
+		/* add to the pending list */
+		spin_lock_irqsave(&wil->wmi_ev_lock, flags);
+		list_add_tail(&evt->list, &wil->pending_wmi_ev);
+		spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
+		{
+			int q =	queue_work(wil->wmi_wq,
+					   &wil->wmi_event_worker);
+			wil_info(wil, "queue_work -> %d\n", q);
+		}
+	}
+}
+
+int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
+	     u16 reply_id, void *reply, u8 reply_size, int to_msec)
+{
+	int rc;
+	int remain;
+
+	mutex_lock(&wil->wmi_mutex);
+
+	rc = __wmi_send(wil, cmdid, buf, len);
+	if (rc)
+		goto out;
+
+	wil->reply_id = reply_id;
+	wil->reply_buf = reply;
+	wil->reply_size = reply_size;
+	remain = wait_for_completion_timeout(&wil->wmi_ready,
+			msecs_to_jiffies(to_msec));
+	if (0 == remain) {
+		wil_err(wil, "wmi_call(0x%04x->0x%04x) timeout %d msec\n",
+			cmdid, reply_id, to_msec);
+		rc = -ETIME;
+	} else {
+		wil_info(wil,
+			 "wmi_call(0x%04x->0x%04x) completed in %d msec\n",
+			 cmdid, reply_id, to_msec - jiffies_to_msecs(remain));
+	}
+	wil->reply_id = 0;
+	wil->reply_buf = NULL;
+	wil->reply_size = 0;
+ out:
+	mutex_unlock(&wil->wmi_mutex);
+
+	return rc;
+}
+
+int wmi_echo(struct wil6210_priv *wil)
+{
+	struct wmi_echo_cmd cmd = {
+		.value = 0x12345678,
+	};
+
+	return wmi_call(wil, WMI_ECHO_CMDID, &cmd, sizeof(cmd),
+			 WMI_ECHO_RSP_EVENTID, NULL, 0, 20);
+}
+
+int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
+{
+	struct wmi_set_mac_address_cmd cmd;
+
+	memcpy(cmd.macaddr, addr, ETH_ALEN);
+
+	wil_info(wil, "Set MAC %pM\n", addr);
+
+	return wmi_send(wil, WMI_SET_MAC_ADDRESS_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_set_bcon(struct wil6210_priv *wil, int bi, u16 wmi_nettype)
+{
+	struct wmi_bcon_ctrl_cmd cmd = {
+		.bcon_interval = bi,
+		.network_type = wmi_nettype,
+	};
+
+	if (!wil->secure_pcp)
+		cmd.disable_sec = 1;
+
+	return wmi_send(wil, WMI_BCON_CTRL_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_set_ssid(struct wil6210_priv *wil, u8 ssid_len, const void *ssid)
+{
+	struct wmi_set_ssid_cmd cmd = {
+		.ssid_len = ssid_len,
+	};
+
+	if (ssid_len > sizeof(cmd.ssid))
+		return -EINVAL;
+
+	memcpy(cmd.ssid, ssid, ssid_len);
+
+	return wmi_send(wil, WMI_SET_SSID_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_get_ssid(struct wil6210_priv *wil, u8 *ssid_len, void *ssid)
+{
+	int rc;
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_set_ssid_cmd cmd;
+	} __packed reply;
+	int len; /* reply.cmd.ssid_len in CPU order */
+
+	rc = wmi_call(wil, WMI_GET_SSID_CMDID, NULL, 0, WMI_GET_SSID_EVENTID,
+		      &reply, sizeof(reply), 20);
+	if (rc)
+		return rc;
+
+	len = reply.cmd.ssid_len;
+	if (len > sizeof(reply.cmd.ssid))
+		return -EINVAL;
+
+	*ssid_len = len;
+	memcpy(ssid, reply.cmd.ssid, len);
+
+	return 0;
+}
+
+int wmi_set_channel(struct wil6210_priv *wil, int channel)
+{
+	struct wmi_set_pcp_channel_cmd cmd = {
+		.channel_index = channel - 1,
+	};
+
+	return wmi_send(wil, WMI_SET_PCP_CHANNEL_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_get_channel(struct wil6210_priv *wil, int *channel)
+{
+	int rc;
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_set_pcp_channel_cmd cmd;
+	} __packed reply;
+
+	rc = wmi_call(wil, WMI_GET_PCP_CHANNEL_CMDID, NULL, 0,
+		      WMI_GET_PCP_CHANNEL_EVENTID, &reply, sizeof(reply), 20);
+	if (rc)
+		return rc;
+
+	if (reply.cmd.channel_index > 3)
+		return -EINVAL;
+
+	*channel = reply.cmd.channel_index + 1;
+
+	return 0;
+}
+
+int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb)
+{
+	struct wmi_eapol_tx_cmd *cmd;
+	struct ethhdr *eth;
+	u16 eapol_len = skb->len - ETH_HLEN;
+	void *eapol = skb->data + ETH_HLEN;
+	int i;
+	int rc;
+
+	skb_set_mac_header(skb, 0);
+	eth = eth_hdr(skb);
+	wil_info(wil, "EAPOL %d bytes to %pM\n", eapol_len, eth->h_dest);
+	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
+		if (memcmp(wil->dst_addr[i], eth->h_dest, ETH_ALEN) == 0)
+			goto found_dest;
+	}
+
+	return -EINVAL;
+
+ found_dest:
+	/* find out eapol data & len */
+	cmd = kzalloc(sizeof(*cmd) + eapol_len, GFP_KERNEL);
+	if (!cmd)
+		return -EINVAL;
+
+	memcpy(cmd->dst_mac, eth->h_dest, ETH_ALEN);
+	cmd->eapol_len = eapol_len;
+	memcpy(cmd->eapol, eapol, eapol_len);
+	rc = wmi_send(wil, WMI_EAPOL_TX_CMDID, cmd, sizeof(*cmd) + eapol_len);
+	kfree(cmd);
+
+	return rc;
+}
+
+int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr)
+{
+	struct wmi_delete_cipher_key_cmd cmd = {
+		.keyIndex = key_index,
+	};
+
+	if (mac_addr)
+		memcpy(cmd.key_macaddr, mac_addr, WMI_MAC_LEN);
+
+	return wmi_send(wil, WMI_DELETE_CIPHER_KEY_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr, int key_len, const void *key)
+{
+	struct wmi_add_cipher_key_cmd cmd = {
+		.keyIndex = key_index,
+		.keyUsage = WMI_KEY_USE_PAIRWISE,
+		.keyLength = key_len,
+	};
+
+	if (!key || (key_len > sizeof(cmd.key)))
+		return -EINVAL;
+
+	memcpy(cmd.key, key, key_len);
+	if (mac_addr)
+		memcpy(cmd.key_macaddr, mac_addr, WMI_MAC_LEN);
+
+	return wmi_send(wil, WMI_ADD_CIPHER_KEY_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_set_ie(struct wil6210_priv *wil, u8 type, int ie_len, const void *ie)
+{
+	int rc;
+	u16 len = sizeof(struct wmi_set_appie_cmd) + ie_len;
+	struct wmi_set_appie_cmd *cmd = kmalloc(len, GFP_KERNEL);
+	if (!cmd) {
+		wil_err(wil, "kmalloc(%d) failed\n", len);
+		return -ENOMEM;
+	}
+
+	cmd->mgmtFrmType = type;
+	/* BUG: FW API define ieLen as u8. Will fix FW */
+	cmd->ieLen = ie_len;
+	memcpy(cmd->ieInfo, ie, ie_len);
+	rc = wmi_send(wil, WMI_SET_APPIE_CMDID, &cmd, len);
+	kfree(cmd);
+
+	return rc;
+}
+
+void wmi_event_flush(struct wil6210_priv *wil)
+{
+	struct pending_wmi_event *evt, *t;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	list_for_each_entry_safe(evt, t, &wil->pending_wmi_ev, list) {
+		list_del(&evt->list);
+		kfree(evt);
+	}
+}
+
+static bool wmi_evt_call_handler(struct wil6210_priv *wil, int id,
+				 void *d, int len)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wmi_evt_handlers); i++) {
+		if (wmi_evt_handlers[i].eventid == id) {
+			wmi_evt_handlers[i].handler(wil, id, d, len);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static void wmi_event_handle(struct wil6210_priv *wil,
+			     struct wil6210_mbox_hdr *hdr)
+{
+	u16 len = hdr->len;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	if ((hdr->type == 0) &&  /* TODO: define */
+	    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
+		struct wil6210_mbox_hdr_wmi *wmi = (void *)(&hdr[1]);
+		void *evt_data = (void *)(&wmi[1]);
+		/* check if someone waits for this event */
+		if (wil->reply_id && wil->reply_id == wmi->id) {
+			if (wil->reply_buf) {
+				memcpy(wil->reply_buf, wmi,
+				       min(len, wil->reply_size));
+			} else {
+				wmi_evt_call_handler(wil, wmi->id, evt_data,
+						     len - sizeof(*wmi));
+			}
+			wil_info(wil, "Complete WMI 0x%04x\n", wmi->id);
+			complete(&wil->wmi_ready);
+			return;
+		}
+		/* unsolicited event */
+		/* search for handler */
+		if (!wmi_evt_call_handler(wil, wmi->id, evt_data,
+					  len - sizeof(*wmi))) {
+			wil_err(wil, "Unhandled event 0x%04x\n", wmi->id);
+		}
+	} else {
+		wil_err(wil, "Unknown event type\n");
+		print_hex_dump(KERN_INFO, "evt?? ", DUMP_PREFIX_OFFSET, 16, 1,
+			       hdr, sizeof(*hdr) + len, true);
+	}
+}
+
+/*
+ * Retrieve next WMI event from the pending list
+ */
+static struct list_head *next_wmi_ev(struct wil6210_priv *wil)
+{
+	ulong flags;
+	struct list_head *ret = NULL;
+
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
+
+	if (!list_empty(&wil->pending_wmi_ev)) {
+		ret = wil->pending_wmi_ev.next;
+		list_del(ret);
+	}
+
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
+
+	return ret;
+}
+
+/*
+ * Handler for the WMI events
+ */
+void wmi_event_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						 wmi_event_worker);
+	struct pending_wmi_event *evt;
+	struct list_head *lh;
+
+	wil_info(wil, "%s()\n", __func__);
+
+	while ((lh = next_wmi_ev(wil)) != NULL) {
+		evt = list_entry(lh, struct pending_wmi_event, list);
+		wmi_event_handle(wil, &evt->event.hdr);
+		kfree(evt);
+	}
+
+	wil_info(wil, "%s() done\n", __func__);
+}
+
+void wmi_connect_worker(struct work_struct *work)
+{
+	int rc;
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						wmi_connect_worker);
+
+	if (wil->pending_connect_cid < 0) {
+		wil_err(wil, "No connection pending\n");
+		return;
+	}
+
+	wil_info(wil, "Configure for connection CID %d\n",
+		 wil->pending_connect_cid);
+
+	rc = wil_vring_init_tx(wil, 0, WIL6210_TX_RING_SIZE,
+			   wil->pending_connect_cid, 0);
+	wil->pending_connect_cid = -1;
+	if (rc == 0)
+		wil_link_on(wil);
+}
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
new file mode 100644
index 0000000..4aa50ca
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -0,0 +1,928 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __WIL6210_WMI_H__
+#define __WIL6210_WMI_H__
+/* WMI API */
+
+/*
+ * To not depend on other includes
+ */
+#define WMI_MAX_SSID_LEN	(32)
+#define WMI_MAC_LEN		 (6)
+
+/*
+ * List of Commnands
+ */
+enum wmi_command_id {
+	WMI_CONNECT_CMDID		= 0x0001,
+	WMI_DISCONNECT_CMDID		= 0x0003,
+	WMI_START_SCAN_CMDID		= 0x0007,
+	WMI_SET_BSS_FILTER_CMDID	= 0x0009,
+	WMI_SET_PROBED_SSID_CMDID	= 0x000a,
+	WMI_SET_LISTEN_INT_CMDID	= 0x000b,
+	WMI_BCON_CTRL_CMDID		= 0x000f,
+	WMI_ADD_CIPHER_KEY_CMDID	= 0x0016,
+	WMI_DELETE_CIPHER_KEY_CMDID	= 0x0017,
+	WMI_SET_APPIE_CMDID		= 0x003f,
+	WMI_GET_APPIE_CMDID		= 0x0040,
+	WMI_SET_WSC_STATUS_CMDID	= 0x0041,
+	/* WILOCITY types */
+	WMI_FAST_MEM_ACC_MODE_CMDID	= 0x0300,
+	WMI_MEM_READ_CMDID		= 0x0800,
+	WMI_MEM_WR_CMDID		= 0x0801,
+	WMI_ECHO_CMDID			= 0x0803,
+	WMI_DEEP_ECHO_CMDID		= 0x0804,
+	WMI_CONFIG_MAC_CMDID		= 0x0805,
+	WMI_CONFIG_PHY_DEBUG_CMDID	= 0x0806,
+	WMI_ADD_STATION_CMDID		= 0x0807,
+	WMI_ADD_DEBUG_TX_PCKT_CMDID	= 0x0808,
+	WMI_PHY_GET_STATISTICS_CMDID	= 0x0809,
+	WMI_FS_TUNE_CMDID		= 0x080A,
+	WMI_CORR_MEASURE_CMDID		= 0x080B,
+	WMI_TEMP_SENSE_CMDID		= 0x080E,
+	WMI_DC_CALIB_CMDID		= 0x080F,
+	WMI_SEND_TONE_CMDID		= 0x0810,
+	WMI_IQ_TX_CALIB_CMDID		= 0x0811,
+	WMI_IQ_RX_CALIB_CMDID		= 0x0812,
+	WMI_SET_UCODE_IDLE_CMDID	= 0x0813,
+	WMI_SET_CHANNEL_IND_CMDID	= 0x0814,
+	WMI_SET_WORK_MODE_CMDID		= 0x0815,
+	WMI_LO_LEAKAGE_CALIB_CMDID	= 0x0816,
+	WMI_MARLON_R_ACTIVATE_CMDID	= 0x0817,
+	WMI_MARLON_R_READ_CMDID		= 0x0818,
+	WMI_MARLON_R_WRITE_CMDID	= 0x0819,
+	WMI_MARLON_R_TXRX_SEL_CMDID	= 0x081A,
+	MAC_IO_STATIC_PARAMS_CMDID	= 0x081B,
+	MAC_IO_DYNAMIC_PARAMS_CMDID	= 0x081C,
+	WMI_SILENT_RSSI_CALIB_CMDID	= 0x081D,
+	WMI_CFG_RX_CHAIN_CMDID		= 0x0820,
+	WMI_VRING_CFG_CMDID		= 0x0821,
+	WMI_RN_ON_CMDID			= 0x0822,
+	WMI_VRING_BA_EN_CMDID		= 0x0823,
+	WMI_VRING_BA_DIS_CMDID		= 0x0824,
+	WMI_RCP_ADDBA_RESP_CMDID	= 0x0825,
+	WMI_RCP_DELBA_CMDID		= 0x0826,
+	WMI_SET_SSID_CMDID		= 0x0827,
+	WMI_GET_SSID_CMDID		= 0x0828,
+	WMI_SET_PCP_CHANNEL_CMDID	= 0x0829,
+	WMI_GET_PCP_CHANNEL_CMDID	= 0x082a,
+	WMI_READ_MAC_RXQ_CMDID		= 0x0830,
+	WMI_READ_MAC_TXQ_CMDID		= 0x0831,
+	WMI_WRITE_MAC_RXQ_CMDID		= 0x0832,
+	WMI_WRITE_MAC_TXQ_CMDID		= 0x0833,
+	WMI_WRITE_MAC_XQ_FIELD_CMDID	= 0x0834,
+	WMI_MLME_PUSH_CMDID		= 0x0835,
+	WMI_BEAMFORMING_MGMT_CMDID	= 0x0836,
+	WMI_BF_TXSS_MGMT_CMDID		= 0x0837,
+	WMI_BF_SM_MGMT_CMDID		= 0x0838,
+	WMI_BF_RXSS_MGMT_CMDID		= 0x0839,
+	WMI_SET_SECTORS_CMDID		= 0x0849,
+	WMI_MAINTAIN_PAUSE_CMDID	= 0x0850,
+	WMI_MAINTAIN_RESUME_CMDID	= 0x0851,
+	WMI_RS_MGMT_CMDID		= 0x0852,
+	WMI_RF_MGMT_CMDID		= 0x0853,
+	/* Performance monitoring commands */
+	WMI_BF_CTRL_CMDID		= 0x0862,
+	WMI_NOTIFY_REQ_CMDID		= 0x0863,
+	WMI_GET_STATUS_CMDID		= 0x0864,
+	WMI_UNIT_TEST_CMDID		= 0x0900,
+	WMI_HICCUP_CMDID		= 0x0901,
+	WMI_FLASH_READ_CMDID		= 0x0902,
+	WMI_FLASH_WRITE_CMDID		= 0x0903,
+	WMI_SECURITY_UNIT_TEST_CMDID	= 0x0904,
+
+	WMI_SET_MAC_ADDRESS_CMDID	= 0xF003,
+	WMI_ABORT_SCAN_CMDID		= 0xF007,
+	WMI_SET_PMK_CMDID		= 0xF028,
+	WMI_SET_PROMISCUOUS_MODE_CMDID	= 0xF041,
+	WMI_GET_PMK_CMDID		= 0xF048,
+	WMI_SET_PASSPHRASE_CMDID	= 0xF049,
+	WMI_SEND_ASSOC_RES_CMDID	= 0xF04a,
+	WMI_SET_ASSOC_REQ_RELAY_CMDID	= 0xF04b,
+	WMI_EAPOL_TX_CMDID		= 0xF04c,
+	WMI_MAC_ADDR_REQ_CMDID		= 0xF04d,
+	WMI_FW_VER_CMDID		= 0xF04e,
+};
+
+/*
+ * List of Events (target to host)
+ */
+enum wmi_event_id {
+	WMI_IMM_RSP_EVENTID			= 0x0000,
+	WMI_READY_EVENTID			= 0x1001,
+	WMI_CONNECT_EVENTID			= 0x1002,
+	WMI_DISCONNECT_EVENTID			= 0x1003,
+	WMI_SCAN_COMPLETE_EVENTID		= 0x100a,
+	WMI_REPORT_STATISTICS_EVENTID		= 0x100b,
+	/* WILOCITY types */
+	WMI_RD_MEM_RSP_EVENTID			= 0x1800,
+	WMI_FW_READY_EVENTID			= 0x1801,
+	WMI_EXIT_FAST_MEM_ACC_MODE_EVENTID	= 0x0200,
+	WMI_ECHO_RSP_EVENTID			= 0x1803,
+	WMI_CONFIG_MAC_DONE_EVENTID		= 0x1805,
+	WMI_CONFIG_PHY_DEBUG_DONE_EVENTID	= 0x1806,
+	WMI_ADD_STATION_DONE_EVENTID		= 0x1807,
+	WMI_ADD_DEBUG_TX_PCKT_DONE_EVENTID	= 0x1808,
+	WMI_PHY_GET_STATISTICS_EVENTID		= 0x1809,
+	WMI_FS_TUNE_DONE_EVENTID		= 0x180A,
+	WMI_CORR_MEASURE_DONE_EVENTID		= 0x180B,
+	WMI_TEMP_SENSE_DONE_EVENTID		= 0x180E,
+	WMI_DC_CALIB_DONE_EVENTID		= 0x180F,
+	WMI_IQ_TX_CALIB_DONE_EVENTID		= 0x1811,
+	WMI_IQ_RX_CALIB_DONE_EVENTID		= 0x1812,
+	WMI_SET_WORK_MODE_DONE_EVENTID		= 0x1815,
+	WMI_LO_LEAKAGE_CALIB_DONE_EVENTID	= 0x1816,
+	WMI_MARLON_R_ACTIVATE_DONE_EVENTID	= 0x1817,
+	WMI_MARLON_R_READ_DONE_EVENTID		= 0x1818,
+	WMI_MARLON_R_WRITE_DONE_EVENTID		= 0x1819,
+	WMI_MARLON_R_TXRX_SEL_DONE_EVENTID	= 0x181A,
+	WMI_SILENT_RSSI_CALIB_DONE_EVENTID	= 0x181D,
+
+	WMI_CFG_RX_CHAIN_DONE_EVENTID		= 0x1820,
+	WMI_VRING_CFG_DONE_EVENTID		= 0x1821,
+	WMI_RX_ON_EVENTID			= 0x1822,
+	WMI_BA_STATUS_EVENTID			= 0x1823,
+	WMI_RCP_ADDBA_REQ_EVENTID		= 0x1824,
+	WMI_ADDBA_RESP_SENT_EVENTID		= 0x1825,
+	WMI_DELBA_EVENTID			= 0x1826,
+	WMI_GET_SSID_EVENTID			= 0x1828,
+	WMI_GET_PCP_CHANNEL_EVENTID		= 0x182a,
+
+	WMI_READ_MAC_RXQ_EVENTID		= 0x1830,
+	WMI_READ_MAC_TXQ_EVENTID		= 0x1831,
+	WMI_WRITE_MAC_RXQ_EVENTID		= 0x1832,
+	WMI_WRITE_MAC_TXQ_EVENTID		= 0x1833,
+	WMI_WRITE_MAC_XQ_FIELD_EVENTID		= 0x1834,
+
+	WMI_BEAFORMING_MGMT_DONE_EVENTID	= 0x1836,
+	WMI_BF_TXSS_MGMT_DONE_EVENTID		= 0x1837,
+	WMI_BF_RXSS_MGMT_DONE_EVENTID		= 0x1839,
+	WMI_RS_MGMT_DONE_EVENTID		= 0x1852,
+	WMI_RF_MGMT_STATUS_EVENTID		= 0x1853,
+	WMI_BF_SM_MGMT_DONE_EVENTID		= 0x1838,
+	WMI_RX_MGMT_PACKET_EVENTID		= 0x1840,
+	/* Performance monitoring events */
+	WMI_WBE_LINKUP_EVENTID			= 0x1860,
+	WMI_WBE_LINKDOWN_EVENTID		= 0x1861,
+
+	WMI_BF_CTRL_DONE_EVENTID		= 0x1862,
+	WMI_NOTIFY_REQ_DONE_EVENTID		= 0x1863,
+	WMI_GET_STATUS_DONE_EVENTID		= 0x1864,
+
+	WMI_UNIT_TEST_EVENTID			= 0x1900,
+	WMI_FLASH_READ_DONE_EVENTID		= 0x1902,
+	WMI_FLASH_WRITE_DONE_EVENTID		= 0x1903,
+
+	WMI_SET_CHANNEL_EVENTID			= 0x9000,
+	WMI_ASSOC_REQ_EVENTID			= 0x9001,
+	WMI_EAPOL_RX_EVENTID			= 0x9002,
+	WMI_MAC_ADDR_RESP_EVENTID		= 0x9003,
+	WMI_FW_VER_EVENTID			= 0x9004,
+};
+
+/*
+ * WMI_ECHO_CMDID
+ *
+ * Check FW is alive
+ *
+ * WMI_DEEP_ECHO_CMDID
+ *
+ * Check FW and ucode are alive
+ *
+ * Returned event: WMI_ECHO_RSP_EVENTID
+ * same event for both commands
+ */
+struct wmi_echo_cmd {
+	u32 value; /* to be returned in event */
+} __packed;
+
+struct wmi_echo_rsp_event {
+	u32 value;
+} __packed;
+
+/*=== For WMI_READY_EVENTID ===*/
+/* TODO: what bits are used? */
+enum wmi_phy_capability {
+	WMI_11A_CAPABILITY	= 1,
+	WMI_11G_CAPABILITY	= 2,
+	WMI_11AG_CAPABILITY	= 3,
+	WMI_11NA_CAPABILITY	= 4,
+	WMI_11NG_CAPABILITY	= 5,
+	WMI_11NAG_CAPABILITY	= 6,
+	WMI_11AD_CAPABILITY	= 7,
+	WMI_11N_CAPABILITY_OFFSET = WMI_11NA_CAPABILITY - WMI_11A_CAPABILITY,
+};
+
+/*
+ * WMI_READY_EVENTID
+ */
+struct wmi_ready_event {
+	u32 sw_version;
+	u32 abi_version;
+	u8 macaddr[WMI_MAC_LEN];
+	u8 phyCapability; /* WMI_PHY_CAPABILITY */
+	u8 reserved;
+} __packed;
+
+/*
+ * WMI_START_SCAN_CMDID
+ *
+ * Start L1 scan operation
+ *
+ * Returned events:
+ * - WMI_RX_MGMT_PACKET_EVENTID - for every probe resp.
+ * - WMI_SCAN_COMPLETE_EVENTID
+ */
+struct wmi_start_scan_cmd {
+	u32 forceFgScan;	/* reserved */
+	u32 isLegacy;		/* reserved */
+	u32 homeDwellTime;	/* reserved */
+	u32 forceScanInterval;	/* reserved */
+	u8 scanType;		/* reserved */
+	u8 numChannels;		/* how many channels follow, 1..4 */
+	u16 channelList[0];	/* channels ID's */
+	/* 0 - 58320 MHz */
+	/* 1 - 60480 MHz */
+	/* 2 - 62640 MHz */
+} __packed;
+
+/*=== For WMI_CONNECT_CMDID ===*/
+enum wmi_network_type {
+	WMI_NETTYPE_INFRA	= 0x01,
+	WMI_NETTYPE_ADHOC	= 0x02,
+	WMI_NETTYPE_ADHOC_CREATOR	= 0x04,
+	WMI_NETTYPE_AP		= 0x10,
+	WMI_NETTYPE_P2P		= 0x20,
+	WMI_NETTYPE_WBE		= 0x40, /* PCIE over 60g */
+};
+
+enum wmi_dot11_auth_mode {
+	WMI_AUTH11_OPEN		= 0x01,
+	WMI_AUTH11_SHARED	= 0x02,
+	WMI_AUTH11_LEAP		= 0x04, /* different from IEEE_AUTH_MODE defs */
+	WMI_AUTH11_WSC		= 0x08,
+};
+
+enum wmi_auth_mode {
+	WMI_AUTH_NONE		= 0x01,
+	WMI_AUTH_WPA		= 0x02,
+	WMI_AUTH_WPA2		= 0x04,
+	WMI_AUTH_WPA_PSK	= 0x08,
+	WMI_AUTH_WPA2_PSK	= 0x10,
+	WMI_AUTH_WPA_CCKM	= 0x20,
+	WMI_AUTH_WPA2_CCKM	= 0x40,
+};
+
+enum wmi_crypto_type {
+	WMI_CRYPT_NONE		= 0x01,
+	WMI_CRYPT_WEP		= 0x02,
+	WMI_CRYPT_TKIP		= 0x04,
+	WMI_CRYPT_AES		= 0x08,
+	WMI_CRYPT_AES_GCMP	= 0x20,
+};
+
+#define WMI_MIN_KEY_INDEX	 (0)
+#define WMI_MAX_KEY_INDEX	 (3)
+#define WMI_MAX_KEY_LEN		(32)
+#define WMI_PASSPHRASE_LEN	(64)
+#define WMI_PMK_LEN		(32)
+
+enum wmi_connect_ctrl_flags_bits {
+	WMI_CONNECT_DO_WPA_OFFLOAD	= 0x0040,
+};
+
+/*
+ * WMI_CONNECT_CMDID
+ *
+ * Attempt to establish L1 link to PCP
+ *
+ * Returned events:
+ * - WMI_CONNECT_EVENTID - if connect succeeds
+ * - WMI_DISCONNECT_EVENTID - if connect fails
+ */
+struct wmi_connect_cmd {
+	u8 networkType;		/* enum wmi_network_type */
+	u8 dot11AuthMode;	/* enum wmi_dot11_auth_mode */
+	u8 authMode;		/* enum wmi_auth_mode */
+	u8 pairwiseCryptoType;	/* enum wmi_crypto_type */
+	u8 pairwiseCryptoLen;	/* Crypto key length - 16 for GCMP */
+	u8 groupCryptoType;	/* unused */
+	u8 groupCryptoLen;	/* unused */
+	u8 ssidLength;
+	u8 ssid[WMI_MAX_SSID_LEN];
+	u16 channel;		/* 0-based channel index */
+	u8 bssid[WMI_MAC_LEN];
+	u32 ctrl_flags;		/* enum wmi_connect_ctrl_flags_bits */
+	u8 destMacAddr[WMI_MAC_LEN];
+	u16 reserved;
+} __packed;
+
+/*
+ * WMI_CONNECT_EVENTID
+ */
+struct wmi_connect_event {
+	u16 channel;		/* 0-based channel index */
+	u8 bssid[WMI_MAC_LEN];
+	u16 listenInterval;	/* always 0 - ignore */
+	u16 beaconInterval;
+	u32 networkType;	/* enum wmi_network_type */
+	u8 beaconIeLen;		/* always 0 - ignore */
+	u8 assocReqLen;
+	u8 assocRespLen;
+	u8 cid;
+	u8 reserved0;
+	u16 reserved1;
+	u8 assocInfo[0];
+	/*
+	 * AssocReq: (used on PCP side)
+	 *	u16 cap_info
+	 *	u16 listen_interval
+	 *	IE's
+	 * AssocResp: (used on client side)
+	 *	u16 cap_info
+	 *	u16 status_code
+	 *	u16 assoc_id
+	 *	IE's
+	 */
+} __packed;
+
+/*
+ * WMI_DISCONNECT_EVENTID
+ */
+enum wmi_disconnect_reason {
+	WMI_DIS_REASON_NO_NETWORK_AVAIL		= 0x01,
+	WMI_DIS_REASON_LOST_LINK		= 0x02, /* bmiss */
+	WMI_DIS_REASON_DISCONNECT_CMD		= 0x03,
+	WMI_DIS_REASON_BSS_DISCONNECTED		= 0x04,
+	WMI_DIS_REASON_AUTH_FAILED		= 0x05,
+	WMI_DIS_REASON_ASSOC_FAILED		= 0x06,
+	WMI_DIS_REASON_NO_RESOURCES_AVAIL	= 0x07,
+	WMI_DIS_REASON_CSERV_DISCONNECT		= 0x08,
+	WMI_DIS_REASON_INVALID_PROFILE		= 0x0a,
+	WMI_DIS_REASON_DOT11H_CHANNEL_SWITCH	= 0x0b,
+	WMI_DIS_REASON_PROFILE_MISMATCH		= 0x0c,
+	WMI_DIS_REASON_CONNECTION_EVICTED	= 0x0d,
+	WMI_DIS_REASON_IBSS_MERGE		= 0x0e,
+};
+
+struct wmi_disconnect_event {
+	u16 protocolReasonStatus; /* reason code, see 802.11 spec. */
+	u8 bssid[WMI_MAC_LEN]; /* set if known */
+	u8 disconnectReason; /* see WMI_DISCONNECT_REASON */
+	u8 assocRespLen;
+	u8 assocInfo[0];
+} __packed;
+
+/*
+ * WMI_SET_BSS_FILTER_CMDID
+ */
+enum wmi_bss_filter {
+	WMI_BSS_FILTER_NONE = 0x0, /* no beacons forwarded */
+	WMI_BSS_FILTER_ALL, /* all beacons forwarded */
+	WMI_BSS_FILTER_PROFILE, /* only beacons matching profile */
+	WMI_BSS_FILTER_ALL_BUT_PROFILE, /* all but beacons matching profile */
+	WMI_BSS_FILTER_CURRENT_BSS, /* only beacons matching current BSS */
+	WMI_BSS_FILTER_ALL_BUT_BSS, /* all but beacons matching BSS */
+	WMI_BSS_FILTER_PROBED_SSID, /* beacons matching probed ssid */
+	WMI_BSS_FILTER_LAST, /* marker only */
+};
+
+struct wmi_set_bss_filter_cmd {
+	u8 bssFilter; /* enum wmi_bss_filter */
+	u8 reserved[3];
+	u32 ieMask;
+} __packed;
+
+/*
+ * WMI_SET_PROBED_SSID_CMDID
+ */
+#define MAX_PROBED_SSID_INDEX	(15)
+
+enum wmi_ssid_flag {
+	WMI_SSID_FLAG_DISABLE	= 0x00, /* disables entry */
+	WMI_SSID_FLAG_SPECIFIC	= 0x01, /* probes specified ssid */
+	WMI_SSID_FLAG_ANY	= 0x02, /* probes for any ssid */
+};
+
+struct wmi_probed_ssid_cmd {
+	u8 entryIndex;        /* 0 to MAX_PROBED_SSID_INDEX */
+	u8 flag;              /* enum WMI_SSID_FLAG */
+	u8 ssidLength;
+	u8 ssid[WMI_MAX_SSID_LEN];
+} __packed;
+
+/*
+ * Frame Types
+ */
+enum wmi_mgmt_frame_type {
+	WMI_FRAME_BEACON	= 0,
+	WMI_FRAME_PROBE_REQ	= 1,
+	WMI_FRAME_PROBE_RESP	= 2,
+	WMI_FRAME_ASSOC_REQ	= 3,
+	WMI_FRAME_ASSOC_RESP	= 4,
+	WMI_NUM_MGMT_FRAME,
+};
+
+/*
+ * WMI_SET_APPIE_CMDID
+ * Add Application specified IE to a management frame
+ */
+struct wmi_set_appie_cmd {
+	u8 mgmtFrmType;  /* one of enum wmi_mgmt_frame_type */
+	u8 ieLen;        /* Length of the IE to be added to the MGMT frame */
+	u8 ieInfo[0];    /* up to WMI_MAX_IE_LEN bytes */
+} __packed;
+
+#define WMI_MAX_IE_LEN (MAX_MBOXITEM_SIZE - \
+			 sizeof(struct wil6210_mbox_hdr_wmi) -\
+			 sizeof(struct wmi_set_appie_cmd))
+
+/*
+ * WMI_SET_PMK_CMDID
+ */
+struct wmi_set_pmk_cmd {
+	u8 pmk[WMI_PMK_LEN];
+} __packed;
+
+/*
+ * WMI_SCAN_COMPLETE_EVENTID - status parameter
+ */
+struct wmi_scan_complete_event {
+	u32 status;
+} __packed;
+
+/*
+ * WMI_RX_MGMT_PACKET_EVENTID
+ */
+struct wmi_rx_mgmt_packet_event {
+	u16 mcs;
+	u16 stype;
+	u32 status;
+	u32 length;
+	u8  qid; /* Not resolved when == 0xFFFFFFFF  ==> Bcast to all MIDS */
+	u8  mid; /* Not resolved when == 0xFFFFFFFF  ==> Bcast to all MIDS */
+	u8  cid;
+	u8  channel; /* From Radio MNGR */
+	u8  payload[0]; /* struct ieee80211_mgmt */
+} __packed;
+
+/* DMA rings */
+
+struct wmi_sw_ring_cfg {
+	u64 ring_mem_base; /* 48 bit; upper 16 bits reserved */
+	u16 ring_size;
+	u16 max_mpdu_size;
+} __packed;
+
+enum wmi_cfg_rx_chain_cmd_action {
+	WMI_RX_CHAIN_ADD = 0x0, WMI_RX_CHAIN_DEL = 0x1,
+};
+
+enum wmi_cfg_rx_chain_cmd_decap_trans_type {
+	WMI_DECAP_TYPE_802_3 = 0x0, WMI_DECAP_TYPE_NATIVE_WIFI = 0x1,
+};
+
+enum wmi_cfg_rx_chain_cmd_nwifi_ds_trans_type {
+	WMI_NWIFI_RX_TRANS_MODE_NO		= 0x0,
+	WMI_NWIFI_RX_TRANS_MODE_PBSS2AP		= 0x1,
+	WMI_NWIFI_RX_TRANS_MODE_PBSS2STA	= 0x2,
+};
+
+/*
+ * WMI_CFG_RX_CHAIN_CMDID
+ *
+ * Opens Rx data path and configures DMA
+ */
+struct wmi_cfg_rx_chain_cmd {
+	u32 action;		/* enum wmi_cfg_rx_chain_cmd_action */
+	struct wmi_sw_ring_cfg sw_ring;
+	u8 mid;			/* TODO: what is it? */
+	u8 decap_trans_type;	/* enum wmi_cfg_rx_chain_cmd_decap_trans_type */
+	u8 l2_802_3_offload_ctrl;/* TODO: what is it? */
+	u8 l2_nwifi_offload_ctrl;/* TODO: what is it? */
+	u8 vlan_id;
+	u8 nwifi_ds_trans_type;
+	/* ^ enum wmi_cfg_rx_chain_cmd_nwifi_ds_trans_type */
+	u8 l3_l4_ctrl;
+	u8 ring_ctrl;
+	u16 prefetch_thrsh;
+	u16 wb_thrsh;
+	u32 itr_value;
+	u16 host_thrsh;
+	u16 reserved;
+	/* added for sniffer mode */
+	u32 sniffer_mode; /* 0/1, other sniffer fields ignored if 0 */
+	u32 sniffer_phy_info; /* 0/1, should phy_info be included? */
+	u32 sniffer_phy; /* 0 - CP; 1 - DP */
+	u32 sniffer_channel; /* channel index 0..2 */
+} __packed;
+
+enum wmi_cfg_rx_chain_done_event_status {
+	WMI_CFG_RX_CHAIN_SUCCESS = 0x1,
+};
+
+/*
+ * WMI_CFG_RX_CHAIN_DONE_EVENTID
+ */
+struct wmi_cfg_rx_chain_done_event {
+	u32 rx_ring_tail_ptr; /* Rx V-Ring Tail pointer */
+	u32 status; /* enum wmi_cfg_rx_chain_done_event_status */
+} __packed;
+
+/*
+ * WMI_VRING_CFG_CMDID
+ */
+enum wmi_vring_cfg_cmd_action {
+	WMI_VRING_CMD_ADD	= 0x0,
+	WMI_VRING_CMD_MODIFY	= 0x1,
+	WMI_VRING_CMD_DELETE	= 0x2,
+};
+
+enum wmi_vring_cfg_encap_trans_type {
+	WMI_VRING_ENC_TYPE_802_3	= 0x0,
+	WMI_VRING_ENC_TYPE_NATIVE_WIFI	= 0x1,
+};
+
+enum wmi_vring_cfg_ds_cfg {
+	WMI_VRING_DS_PBSS	= 0x0,
+	WMI_VRING_DS_STATION	= 0x1,
+	WMI_VRING_DS_AP		= 0x2,
+	WMI_VRING_DS_ADDR4	= 0x3,
+};
+
+enum wmi_vring_cfg_nwifi_ds_trans_type {
+	WMI_NWIFI_TX_TRANS_MODE_NO		= 0x0,
+	WMI_NWIFI_TX_TRANS_MODE_AP2PBSS		= 0x1,
+	WMI_NWIFI_TX_TRANS_MODE_STA2PBSS	= 0x2,
+};
+
+enum wmi_vring_cfg_schd_params_priority {
+	WMI_SCH_PRIO_REGULAR	= 0x0,
+	WMI_SCH_PRIO_HIGH	= 0x1,
+};
+
+struct wmi_vring_cfg_cmd {
+	u32 action; /* enum wmi_vring_cfg_cmd_action */
+	struct wmi_sw_ring_cfg sw_ring;
+	u8  ringid; /* 0-23 */
+	u8  cidxtid; /* 0..3: cid; 4..7: tid */
+	u8  encap_trans_type; /* enum wmi_vring_cfg_encap_trans_type */
+	u8  ds_cfg; /* enum wmi_vring_cfg_ds_cfg - 802.3 DS cfg */
+	u8  nwifi_ds_trans_type; /* enum wmi_vring_cfg_nwifi_ds_trans_type */
+	u8  mac_ctrl; /* 0: lifetime_en; 1: aggr_en */
+#define VRING_CFG_MAC_CTRL_LIFETIME_EN BIT(0)
+#define VRING_CFG_MAC_CTRL_AGGR_EN     BIT(1)
+	u8  to_resolution; /* 0..5: value; 6..7: reserved */
+	u8  agg_max_wsize;
+	/* schd_params */
+	u16 priority; /* enum wmi_vring_cfg_schd_params_priority */
+	u16 timeslot_us;
+} __packed;
+
+/*
+ * WMI_VRING_CFG_DONE_EVENTID
+ */
+enum wmi_vring_cfg_done_event_status {
+	WMI_VRING_CFG_SUCCESS = 0x0, WMI_VRING_CFG_FAILURE = 0x1,
+};
+
+struct wmi_vring_cfg_done_event {
+	u8  ringid;
+	u8  status;
+	u16 reserved;
+	u32 tx_vring_tail_ptr; /* Tx vring tail pointer */
+} __packed;
+
+/*
+ * WMI_SET_MAC_ADDRESS_CMDID
+ */
+struct wmi_set_mac_address_cmd {
+	u8  macaddr[WMI_MAC_LEN];
+	u16 reserved;
+} __packed;
+
+/*
+ * WMI_BCON_CTRL_CMDID
+ *
+ * Sets bcon interval and starts PCP
+ *
+ * No returning event
+ */
+struct wmi_bcon_ctrl_cmd {
+	u16 bcon_interval;	/* msec; 0 to stop */
+	u16 frag_num;		/* reserved */
+	u64 ss_mask;
+	u8 network_type;	/* enum wmi_network_type */
+	u8 reserved;
+	u8 disable_sec_offload;	/* 1 to non-offload */
+	u8 disable_sec;		/* 1 to disable security */
+} __packed;
+
+/*
+ * WMI_NOTIFY_REQ_CMDID
+ */
+struct wmi_notify_req_cmd {
+	u32 cid;
+	u32 interval_usec;
+} __packed;
+
+/*
+ * WMI_NOTIFY_REQ_DONE_EVENTID
+ */
+struct wmi_notify_req_done_event {
+	u32 status;
+	u64 tsf;
+	u32 bf_metric;
+	u32 tx_tpt;
+	u32 tx_goodput;
+	u32 rx_goodput;
+	u16 bf_mcs;
+	u16 my_rx_sector;
+	u16 my_tx_sector;
+	u16 other_rx_sector;
+	u16 other_tx_sector;
+	u16 reserved;
+} __packed;
+
+/*
+ * WMI_SET_SSID_CMDID
+ * WMI_GET_SSID_EVENTID
+ */
+struct wmi_set_ssid_cmd {
+	u32 ssid_len;
+	u8 ssid[WMI_MAX_SSID_LEN];
+} __packed;
+
+/*
+ * WMI_SET_PCP_CHANNEL_CMDID
+ * WMI_GET_PCP_CHANNEL_EVENTID
+ */
+struct wmi_set_pcp_channel_cmd {
+	u8 channel_index;
+	u8 reserved[3];
+} __packed;
+
+/*
+* WMI_EAPOL_TX_CMDID
+*/
+struct wmi_eapol_tx_cmd {
+	u8 dst_mac[WMI_MAC_LEN];
+	u16 eapol_len;
+	u8 eapol[0]; /* Up tp 196 bytes */
+} __packed;
+
+/*
+ * WMI_SET_PMK_CMDID
+ * WMI_GET_PMK_CMDID TODO: is it correct?
+ */
+struct wmi_set_get_pmk_cmd {
+	u8 pmk[WMI_PMK_LEN];
+} __packed;
+
+/*
+ * WMI_SET_PASSPHRASE_CMDID
+ */
+struct wmi_set_passphrase_cmd {
+	u8 ssid[WMI_MAX_SSID_LEN];
+	u8 passphrase[WMI_PASSPHRASE_LEN];
+	u8 ssid_len;
+	u8 passphrase_len;
+} __packed;
+
+enum wmi_key_usage {
+	WMI_KEY_USE_PAIRWISE	= 0x00,
+	WMI_KEY_USE_GROUP	= 0x01,
+	WMI_KEY_USE_TX		= 0x02,  /* default Tx Key - Static WEP only */
+};
+
+/*
+ * WMI_ADD_CIPHER_KEY_CMDID
+ */
+struct wmi_add_cipher_key_cmd {
+	u8 keyIndex;
+	u8 keyType;
+	u8 keyUsage;           /* enum wmi_key_usage */
+	u8 keyLength;
+	u8 keyRSC[8];          /* key replay sequence counter */
+	u8 key[WMI_MAX_KEY_LEN];
+	u8 key_op_ctrl;       /* Additional Key Control information */
+	u8 key_macaddr[WMI_MAC_LEN];
+} __packed;
+
+/*
+ * WMI_DELETE_CIPHER_KEY_CMDID
+ */
+struct wmi_delete_cipher_key_cmd {
+	u8 keyIndex;
+	u8 key_macaddr[WMI_MAC_LEN];
+} __packed;
+
+/*
+ * WMI_RF_MGMT_CMDID
+ */
+enum wmi_rf_mgmt_type {
+	WMI_RF_MGMT_W_DISABLE	= 0x0,
+	WMI_RF_MGMT_W_ENABLE	= 0x1,
+	WMI_RF_MGMT_GET_STATUS	= 0x2
+};
+
+struct wmi_rf_mgmt_cmd {
+	u32 rf_mgmt_type;
+} __packed;
+
+/*
+ * WMI_RF_MGMT_STATUS_EVENTID
+ */
+enum wmi_rf_status {
+	WMI_RF_ENABLED		= 0x0,
+	WMI_RF_DISABLED_HW	= 0x1,
+	WMI_RF_DISABLED_SW	= 0x2,
+	WMI_RF_DISABLED_HW_SW	= 0x3
+};
+
+struct wmi_rf_mgmt_status_event {
+	u32 rf_status;
+} __packed;
+
+/*
+ * WMI_GET_STATUS_DONE_EVENTID
+ */
+struct wmi_get_status_done_event {
+	u32 is_associated;
+	u32 cid;
+	u8 bssid[WMI_MAC_LEN];
+	u16 channel;
+	u32 network_type;
+	u32 ssid_len;
+	u8 ssid[WMI_MAX_SSID_LEN];
+	u32 rf_status;
+} __packed;
+
+/*
+ * WMI_VRING_BA_EN_CMDID
+ */
+struct wmi_vring_ba_en_cmd {
+	u8 ringid;
+	u8 agg_max_wsize;
+	u16 ba_timeout;
+} __packed;
+
+
+/*
+ * WMI_VRING_BA_DIS_CMDID
+ */
+struct wmi_vring_ba_dis_cmd {
+	u8 ringid;
+	u8 reserved;
+	u16 reason;
+} __packed;
+
+/*
+ * WMI_RCP_ADDBA_RESP_CMDID
+ */
+struct wmi_rcp_addba_resp_cmd {
+	u8 cidxtid; /* 0..3: cid; 4..7: tid */
+	u8 dialog_token;
+	u16 status_code;
+	u16 ba_param_set; /* ieee80211_ba_parameterset field to send */
+	u16 ba_timeout;
+} __packed;
+
+/*
+ * WMI_RCP_DELBA_CMDID
+ */
+struct wmi_rcp_delba_cmd {
+	u8 cidxtid; /* 0..3: cid; 4..7: tid */
+	u8 rsvd;
+	u16 reason;
+} __packed;
+
+/*
+ * WMI_RCP_ADDBA_REQ_CMDID
+ */
+struct wmi_rcp_addba_req_cmd {
+	u8 cidxtid; /* 0..3: cid; 4..7: tid */
+	u8 dialog_token;
+	u16 ba_param_set;  /* ieee80211_ba_parameterset field as it rcvd */
+	u16 ba_timeout;
+	u16 ba_seq_ctrl;   /* ieee80211_ba_seqstrl field as it received */
+} __packed;
+
+/*
+ * WMI_DELBA_EVENTID
+ */
+struct wmi_delba_event {
+	u8 cidxtid; /* 0..3: cid; 4..7: tid */
+	u8 from_initiator;
+	u16 reason;
+} __packed;
+
+/*
+ * WMI_ADDBA_RESP_SENT_EVENTID
+ */
+enum wmi_rcp_addba_resp_sent_event_status {
+	WMI_ADDBA_SUCCESS	= 0x0,
+	WMI_ADDBA_FAIL	= 0x1,
+};
+
+struct wmi_rcp_addba_resp_sent_event {
+	u8 cidxtid; /* 0..3: cid; 4..7: tid */
+	u8 rsvd;
+	u16 status;
+} __packed;
+
+/*
+ * WMI_RCP_ADDBA_REQ_EVENTID
+ */
+struct wmi_rcp_addba_req_event {
+	u8 cidxtid; /* 0..3: cid; 4..7: tid */
+	u8 dialog_token;
+	u16 ba_param_set;  /* ieee80211_ba_parameterset field as it received */
+	u16 ba_timeout;
+	u16 ba_seq_ctrl;   /* ieee80211_ba_seqstrl field as it received */
+} __packed;
+
+/**
+ * WMI_FW_VER_EVENTID
+ */
+struct wmi_fw_ver_event {
+	u8 major;
+	u8 minor;
+	u16 subminor;
+	u16 build;
+} __packed;
+
+/*
+* WMI_MAC_ADDR_RESP_EVENTID
+*/
+struct wmi_mac_addr_resp_event {
+	u8 mac_addr[WMI_MAC_LEN];
+	u8 auth_mode;
+	u8 crypt_mode;
+	u32 offload_mode; /* 0/1 */
+} __packed;
+
+
+/*
+* WMI_EAPOL_RX_EVENTID
+*/
+struct wmi_eapol_rx_event {
+	u8 src_mac[WMI_MAC_LEN];
+	u16 eapol_len;
+	u8 eapol[0]; /* Up tp 196 bytes */
+} __packed;
+
+/*
+ * WMI_BA_STATUS_EVENTID
+ */
+enum wmi_vring_ba_status {
+	WMI_BA_AGREED		= 0x0,
+	WMI_BA_NON_AGREED	= 0x1,
+};
+
+struct wmi_vring_ba_status_event {
+	u16 status; /* enum wmi_vring_ba_status */
+	u16 reserved0;
+	u8 ringid;
+	u8 agg_wsize;
+	u16 ba_timeout;
+} __packed;
+
+/*
+ * WMI_WBE_LINKDOWN_EVENTID
+ */
+enum wmi_wbe_link_down_event_reason {
+	WMI_WBE_REASON_USER_REQUEST	= 0x0,
+	WMI_WBE_REASON_RX_DISASSOC	= 0x1,
+	WMI_WBE_REASON_BAD_PHY_LINK	= 0x2,
+};
+
+struct wmi_wbe_link_down_event {
+	u8 cid;
+	u8 reserved[3];
+	u32 reason;
+} __packed;
+
+/*
+ * WMI_WBE_LINKUP_EVENTID
+ */
+struct wmi_wbe_link_up_event {
+	u8 cid;
+	u8 reserved0[3];
+} __packed;
+
+#endif /* __WIL6210_WMI_H__ */
-- 
1.7.10.4

