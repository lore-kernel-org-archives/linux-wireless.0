Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:50542 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1BYARI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 19:17:08 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: replace pseudo-kerneldoc comments.
Date: Thu, 24 Feb 2011 16:19:41 -0800
Message-Id: <1298593181-22766-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

replace "/** comment **/" by "/* comment */"

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   12 +-
 drivers/net/wireless/mwifiex/11n.h           |    4 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |    8 +-
 drivers/net/wireless/mwifiex/11n_aggr.h      |    4 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    4 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    4 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |   14 ++--
 drivers/net/wireless/mwifiex/cfg80211.h      |    4 +-
 drivers/net/wireless/mwifiex/cfp.c           |   16 ++--
 drivers/net/wireless/mwifiex/cmdevt.c        |    4 +-
 drivers/net/wireless/mwifiex/debugfs.c       |    4 +-
 drivers/net/wireless/mwifiex/decl.h          |    4 +-
 drivers/net/wireless/mwifiex/fw.h            |   43 +++------
 drivers/net/wireless/mwifiex/ieee.h          |   10 +-
 drivers/net/wireless/mwifiex/init.c          |    4 +-
 drivers/net/wireless/mwifiex/ioctl.h         |    6 +-
 drivers/net/wireless/mwifiex/join.c          |   26 +++---
 drivers/net/wireless/mwifiex/main.c          |   12 +-
 drivers/net/wireless/mwifiex/main.h          |    4 +-
 drivers/net/wireless/mwifiex/scan.c          |   32 +++----
 drivers/net/wireless/mwifiex/sdio.c          |    8 +-
 drivers/net/wireless/mwifiex/sdio.h          |  132 +++++++++++++-------------
 drivers/net/wireless/mwifiex/sta_cmd.c       |   20 ++---
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   12 +--
 drivers/net/wireless/mwifiex/sta_event.c     |    4 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |    7 +-
 drivers/net/wireless/mwifiex/sta_rx.c        |    4 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |    4 +-
 drivers/net/wireless/mwifiex/txrx.c          |    4 +-
 drivers/net/wireless/mwifiex/util.c          |    4 +-
 drivers/net/wireless/mwifiex/util.h          |    4 +-
 drivers/net/wireless/mwifiex/wmm.c           |   16 ++--
 drivers/net/wireless/mwifiex/wmm.h           |    4 +-
 33 files changed, 204 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index c93a5c3..6413853 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: 802.11n
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -466,10 +466,10 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 		if (tx_ba_tbl)
 			mwifiex_send_addba(priv, tx_ba_tbl->tid,
 					   tx_ba_tbl->ra);
-	} else {		/*
-				 * In case of failure, recreate the deleted
-				 * stream in case we initiated the ADDBA
-				 */
+	} else { /*
+		  * In case of failure, recreate the deleted stream in case
+		  * we initiated the ADDBA
+		  */
 		if (INITIATOR_BIT(del_ba_param_set)) {
 			mwifiex_11n_create_tx_ba_stream_tbl(priv,
 					del_ba->
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 0fe1b37..0bd8bb9 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: 802.11n
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_11N_H_
 #define _MWIFIEX_11N_H_
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 33e8e46..a9353be 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: 802.11n Aggregation
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -111,9 +111,7 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 	local_tx_pd = (struct txpd *) skb->data;
 	memset(local_tx_pd, 0, sizeof(struct txpd));
 
-	/*
-	 * Original priority has been overwritten
-	 */
+	/* Original priority has been overwritten */
 	local_tx_pd->priority = (u8) skb->priority;
 	local_tx_pd->pkt_delay_2ms =
 		mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 8dcc2b5..8898aa6 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: 802.11n Aggregation
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_11N_AGGR_H_
 #define _MWIFIEX_11N_AGGR_H_
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 7465598..11a5ddf 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: 802.11n RX Re-ordering
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 1638543..cc8d4e0 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: 802.11n RX Re-ordering
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_11N_RXREORDER_H_
 #define _MWIFIEX_11N_RXREORDER_H_
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 995975b..105543b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: CFG80211
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "cfg80211.h"
 #include "main.h"
@@ -371,7 +371,7 @@ static int mwifiex_reg_notifier(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_USER:
 		break;
 		/* Todo: apply driver specific changes in channel flags based
-		on the request initiator if necessory. **/
+		   on the request initiator if necessary. */
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		break;
 	}
@@ -691,7 +691,7 @@ mwifiex_cfg80211_get_station(struct wiphy *wiphy,
 	return ret;
 }
 
-/** Supported rates to be advertised to the cfg80211 */
+/* Supported rates to be advertised to the cfg80211 */
 
 static struct ieee80211_rate mwifiex_rates[] = {
 	{.bitrate = 10, .hw_value = 2, },
@@ -710,7 +710,7 @@ static struct ieee80211_rate mwifiex_rates[] = {
 	{.bitrate = 720, .hw_value = 144, },
 };
 
-/** Channel definitions to be advertised to cfg80211 */
+/* Channel definitions to be advertised to cfg80211 */
 
 static struct ieee80211_channel mwifiex_channels_2ghz[] = {
 	{.center_freq = 2412, .hw_value = 1, },
@@ -1350,7 +1350,7 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 }
 
-/** station cfg80211 operations */
+/* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.change_virtual_intf = mwifiex_cfg80211_change_virtual_intf,
 	.scan = mwifiex_cfg80211_scan,
@@ -1419,7 +1419,7 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 
 	wdev->wiphy->reg_notifier = mwifiex_reg_notifier;
 
-	/** Set struct mwifiex_private pointer in wiphy_priv */
+	/* Set struct mwifiex_private pointer in wiphy_priv */
 	wdev_priv = wiphy_priv(wdev->wiphy);
 
 	*(unsigned long *) wdev_priv = (unsigned long) priv;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.h b/drivers/net/wireless/mwifiex/cfg80211.h
index 6468739..34f6322 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.h
+++ b/drivers/net/wireless/mwifiex/cfg80211.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: CFG80211
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef __MWIFIEX_CFG80211__
 #define __MWIFIEX_CFG80211__
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 2bd8071..43e2fb8 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: Channel, Frequence and Power
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -25,17 +25,17 @@
 #include "main.h"
 #include "cfg80211.h"
 
-/** 100mW */
+/* 100mW */
 #define MWIFIEX_TX_PWR_DEFAULT     20
-/** 100mW */
+/* 100mW */
 #define MWIFIEX_TX_PWR_US_DEFAULT      20
-/** 50mW */
+/* 50mW */
 #define MWIFIEX_TX_PWR_JP_DEFAULT      16
-/** 100mW */
+/* 100mW */
 #define MWIFIEX_TX_PWR_FR_100MW        20
-/** 10mW */
+/* 10mW */
 #define MWIFIEX_TX_PWR_FR_10MW         10
-/** 100mW */
+/* 100mW */
 #define MWIFIEX_TX_PWR_EMEA_DEFAULT    20
 
 u8 adhoc_rates_b[B_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96, 0 };
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index ef063d1..45e1bf2 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: commands and events
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index e440376..1a1cb47 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: debugfs
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include <linux/debugfs.h>
 
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index b9d6535..0085bce 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: generic data structures and APIs
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_DECL_H_
 #define _MWIFIEX_DECL_H_
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6c82673..50f6df6 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: Firmware specific macros & structures
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_FW_H_
 #define _MWIFIEX_FW_H_
@@ -517,7 +517,7 @@ struct rxpd {
 	u8 rx_rate;
 	s8 snr;
 	s8 nf;
-	/** Ht Info [Bit 0] RxRate format: LG=0, HT=1
+	/* Ht Info [Bit 0] RxRate format: LG=0, HT=1
 	 * [Bit 1]  HT Bandwidth: BW20 = 0, BW40 = 1
 	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
 	u8 ht_info;
@@ -864,7 +864,7 @@ struct host_cmd_ds_802_11_get_log {
 
 struct host_cmd_ds_tx_rate_query {
 	u8 tx_rate;
-	/** Ht Info [Bit 0] RxRate format: LG=0, HT=1
+	/* Ht Info [Bit 0] RxRate format: LG=0, HT=1
 	 * [Bit 1]  HT Bandwidth: BW20 = 0, BW40 = 1
 	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
 	u8 ht_info;
@@ -962,7 +962,7 @@ struct host_cmd_ds_txpwr_cfg {
 #define MWIFIEX_MAX_SSID_LIST_LENGTH         10
 
 struct mwifiex_scan_cmd_config {
-	/**
+	/*
 	 *  BSS Type to be sent in the firmware command
 	 *
 	 *  Field can be used to restrict the types of networks returned in the
@@ -974,17 +974,13 @@ struct mwifiex_scan_cmd_config {
 	 */
 	u8 bss_mode;
 
-	/**
-	 *  Specific BSSID used to filter scan results in the firmware
-	 */
+	/* Specific BSSID used to filter scan results in the firmware */
 	u8 specific_bssid[MWIFIEX_MAC_ADDR_LENGTH];
 
-	/**
-	 *  Length of TLVs sent in command starting at tlvBuffer
-	 */
+	/* Length of TLVs sent in command starting at tlvBuffer */
 	u32 tlv_buf_len;
 
-	/**
+	/*
 	 *  SSID TLV(s) and ChanList TLVs to be sent in the firmware command
 	 *
 	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
@@ -1008,14 +1004,14 @@ struct mwifiex_user_scan_ssid {
 } __packed;
 
 struct mwifiex_user_scan_cfg {
-	/**
+	/*
 	 *  Flag set to keep the previous scan table intact
 	 *
 	 *  If set, the scan results will accumulate, replacing any previous
 	 *   matched entries for a BSS with the new scan data
 	 */
 	u8 keep_previous_scan;
-	/**
+	/*
 	 *  BSS mode to be sent in the firmware command
 	 *
 	 *  Field can be used to restrict the types of networks returned in the
@@ -1026,25 +1022,14 @@ struct mwifiex_user_scan_cfg {
 	 *   - MWIFIEX_SCAN_MODE_ANY  (unrestricted, adhoc and infrastructure)
 	 */
 	u8 bss_mode;
-	/**
-	 *  Configure the number of probe requests for active chan scans
-	 */
+	/* Configure the number of probe requests for active chan scans */
 	u8 num_probes;
-	/**
-	 *  @brief Reserved
-	 */
 	u8 reserved;
-	/**
-	 *  @brief BSSID filter sent in the firmware command to limit the results
-	 */
+	/* BSSID filter sent in the firmware command to limit the results */
 	u8 specific_bssid[MWIFIEX_MAC_ADDR_LENGTH];
-	/**
-	 *  SSID filter list used in the to limit the scan results
-	 */
+	/* SSID filter list used in the to limit the scan results */
 	struct mwifiex_user_scan_ssid ssid_list[MWIFIEX_MAX_SSID_LIST_LENGTH];
-	/**
-	 *  Variable number (fixed maximum) of channels to scan up
-	 */
+	/* Variable number (fixed maximum) of channels to scan up */
 	struct mwifiex_user_scan_chan chan_list[MWIFIEX_USER_SCAN_CHAN_MAX];
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 755b518..c9f0964 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: IEEE Information Element
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_IEEE_H_
 #define _MWIFIEX_IEEE_H_
@@ -119,7 +119,7 @@ struct ieee_types_wmm_ac_parameters {
 
 struct ieee_types_wmm_info {
 
-	/**
+	/*
 	 * WMM Info IE - Vendor Specific Header:
 	 *   element_id  [221/0xdd]
 	 *   Len         [7]
@@ -134,7 +134,7 @@ struct ieee_types_wmm_info {
 } __packed;
 
 struct ieee_types_wmm_parameter {
-	/**
+	/*
 	 * WMM Parameter IE - Vendor Specific Header:
 	 *   element_id  [221/0xdd]
 	 *   Len         [24]
@@ -189,7 +189,7 @@ struct mwifiex_bssdescriptor {
 	u32 bss_mode;
 	u8 supported_rates[MWIFIEX_SUPPORTED_RATES];
 	u8 data_rates[MWIFIEX_SUPPORTED_RATES];
-	/** Network band.
+	/* Network band.
 	 * BAND_B(0x01): 'b' band
 	 * BAND_G(0x02): 'g' band
 	 * BAND_A(0X04): 'a' band
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 9a23bfd..7055973 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: HW/FW Initialization
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index e79f8bc..06d1b45 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: ioctl data structures & APIs
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_IOCTL_H_
 #define _MWIFIEX_IOCTL_H_
@@ -363,7 +363,7 @@ struct mwifiex_power_cfg {
 
 struct mwifiex_ds_hs_cfg {
 	u32 is_invoke_hostcmd;
-	/** Bit0: non-unicast data
+	/*  Bit0: non-unicast data
 	 *  Bit1: unicast data
 	 *  Bit2: mac events
 	 *  Bit3: magic packet
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 23b4f1f..1a9e868 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: association and ad-hoc start/join
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -566,7 +566,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		|| priv->adapter->config_bands & BAND_AN))
 		mwifiex_cmd_append_11n_tlv(priv, bss_desc, &pos);
 
-	/** Append vendor specific IE TLV */
+	/* Append vendor specific IE TLV */
 	mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_ASSOC, &pos);
 
 	mwifiex_wmm_process_association_req(priv, &pos, &bss_desc->wmm_ie,
@@ -893,9 +893,9 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	bss_desc->beacon_period = priv->beacon_period;
 
 	/* Set Physical param set */
-/** Parameter IE Id */
+/* Parameter IE Id */
 #define DS_PARA_IE_ID   3
-/** Parameter IE length */
+/* Parameter IE length */
 #define DS_PARA_IE_LEN  1
 
 	adhoc_start->phy_param_set.ds_param_set.element_id = DS_PARA_IE_ID;
@@ -932,9 +932,9 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	       sizeof(union ieee_types_phy_param_set));
 
 	/* Set IBSS param set */
-/** IBSS parameter IE Id */
+/* IBSS parameter IE Id */
 #define IBSS_PARA_IE_ID   6
-/** IBSS parameter IE length */
+/* IBSS parameter IE length */
 #define IBSS_PARA_IE_LEN  2
 
 	adhoc_start->ss_param_set.ibss_param_set.element_id = IBSS_PARA_IE_ID;
@@ -956,7 +956,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
 			|| priv->sec_info.wpa_enabled
 			|| priv->sec_info.ewpa_enabled) {
-		/** Ad-Hoc capability privacy on */
+		/* Ad-Hoc capability privacy on */
 		PRINTM(MINFO, "ADHOC_S_CMD: wep_status set, Privacy to WEP\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
 		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
@@ -1036,7 +1036,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			sizeof(struct mwifiex_chan_scan_param_set);
 	}
 
-	/** Append vendor specific IE TLV */
+	/* Append vendor specific IE TLV */
 	cmd_append_size +=
 		mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_ADHOC,
 					    &pos);
@@ -1180,7 +1180,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		(u8 *) adhoc_join +
 		sizeof(struct host_cmd_ds_802_11_ad_hoc_join);
 
-/** Use G protection */
+/* Use G protection */
 #define USE_G_PROTECTION        0x02
 	if (bss_desc->erp_flags & USE_G_PROTECTION) {
 		curr_pkt_filter =
@@ -1390,7 +1390,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		cmd_append_size +=
 			mwifiex_cmd_append_11n_tlv(priv, bss_desc, &pos);
 
-	/** Append vendor specific IE TLV */
+	/* Append vendor specific IE TLV */
 	cmd_append_size +=
 		mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_ADHOC,
 					    &pos);
@@ -1429,9 +1429,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 	bss_desc = priv->attempted_bss_desc;
 
-	/*
-	 * Join result code 0 --> SUCCESS
-	 */
+	/* Join result code 0 --> SUCCESS */
 	if (result) {
 		PRINTM(MERROR, "ADHOC_RESP Failed\n");
 		if (priv->media_connected)
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index e3118aa..e08b7a0 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: major functions
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "main.h"
 #include "wmm.h"
@@ -37,7 +37,7 @@ static int drv_mode = DRV_MODE_STA;
 
 static char fw_name[32] = DEFAULT_FW_NAME;
 
-/** Supported drv_mode table */
+/* Supported drv_mode table */
 static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
 	{
 	 /* drv_mode */
@@ -504,7 +504,7 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 	default:
 		break;
 	}
-/** Offset for TOS field in the IP header */
+/* Offset for TOS field in the IP header */
 #define IPTOS_OFFSET 5
 	tid = (tid >> IPTOS_OFFSET);
 	skb->priority = tid;
@@ -663,7 +663,7 @@ static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 	return &priv->stats;
 }
 
-/** Network device handlers */
+/* Network device handlers */
 static const struct net_device_ops mwifiex_netdev_ops = {
 	.ndo_open = mwifiex_open,
 	.ndo_stop = mwifiex_close,
@@ -1064,7 +1064,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->hs_activated = false;
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
 
-	/** Create workqueue */
+	/* Create workqueue */
 	adapter->workqueue = create_workqueue("MWIFIEX_WORK_QUEUE");
 	if (!adapter->workqueue)
 		goto err_kmalloc;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e5fd6e0..0211942 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: major data structures and prototypes
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_MAIN_H_
 #define _MWIFIEX_MAIN_H_
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 42ef23a..924d035 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: scan ioctl and command handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -26,27 +26,27 @@
 #include "11n.h"
 #include "cfg80211.h"
 
-/** The maximum number of channels the firmware can scan per command */
+/* The maximum number of channels the firmware can scan per command */
 #define MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN   14
 
 #define MWIFIEX_CHANNELS_PER_SCAN_CMD            4
 
-/** Memory needed to store a max sized Channel List TLV for a firmware scan */
+/* Memory needed to store a max sized Channel List TLV for a firmware scan */
 #define CHAN_TLV_MAX_SIZE  (sizeof(struct mwifiex_ie_types_header)         \
 				+ (MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN     \
 				*sizeof(struct mwifiex_chan_scan_param_set)))
 
-/** Memory needed to store supported rate */
+/* Memory needed to store supported rate */
 #define RATE_TLV_MAX_SIZE   (sizeof(struct mwifiex_ie_types_rates_param_set) \
 				+ HOSTCMD_SUPPORTED_RATES)
 
-/** Memory needed to store a max number/size WildCard SSID TLV for a firmware
+/* Memory needed to store a max number/size WildCard SSID TLV for a firmware
 	scan */
 #define WILDCARD_SSID_TLV_MAX_SIZE  \
 		(MWIFIEX_MAX_SSID_LIST_LENGTH  * (sizeof(struct \
 		mwifiex_ie_types_wildcard_ssid_params) + IW_ESSID_MAX_SIZE))
 
-/** Maximum memory needed for a mwifiex_scan_cmd_config with all TLVs at max */
+/* Maximum memory needed for a mwifiex_scan_cmd_config with all TLVs at max */
 #define MAX_SCAN_CFG_ALLOC (sizeof(struct mwifiex_scan_cmd_config)        \
 				+ sizeof(struct mwifiex_ie_types_num_probes)   \
 				+ sizeof(struct mwifiex_ie_types_htcap)       \
@@ -56,9 +56,9 @@
 
 
 union mwifiex_scan_cmd_config_tlv {
-	/** Scan configuration (variable length) */
+	/* Scan configuration (variable length) */
 	struct mwifiex_scan_cmd_config config;
-	/** Max allocated block */
+	/* Max allocated block */
 	u8 config_alloc_buf[MAX_SCAN_CFG_ALLOC];
 };
 
@@ -1079,7 +1079,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		tlv_pos += sizeof(struct mwifiex_ie_types_htcap);
 	}
 
-	/** Append vendor specific IE TLV */
+	/* Append vendor specific IE TLV */
 	mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_SCAN, &tlv_pos);
 
 	/*
@@ -1617,7 +1617,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		/* Need to account for IE ID and IE Len */
 		bytes_left_for_current_beacon -= (element_len + 2);
 
-	}			/* while (bytes_left_for_current_beacon > 2) */
+	}	/* while (bytes_left_for_current_beacon > 2) */
 	return ret;
 }
 
@@ -2074,9 +2074,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				(adapter->bcn_buf_end -
 				 adapter->bcn_buf)));
 		} else {
-			/*
-			 * No space for new beacon
-			 */
+			/* No space for new beacon */
 			PRINTM(MINFO, "AppControl: No space beacon (%d): "
 			       "%02x:%02x:%02x:%02x:%02x:%02x; sz=%03d, "
 			       "left=%03d\n",
@@ -2711,9 +2709,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			       bss_new_entry->mac_address[4],
 			       bss_new_entry->mac_address[5]);
 
-			/*
-			 * Search the scan table for the same bssid
-			 */
+			/* Search the scan table for the same bssid */
 			for (bss_idx = 0; bss_idx < num_in_table; bss_idx++) {
 				if (!memcmp(bss_new_entry->mac_address,
 					    adapter->scan_table[bss_idx].
@@ -3169,7 +3165,7 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
 	if (!(*buffer))
 		return 0;
 
-	/**
+	/*
 	 * Traverse through the saved vendor specific IE array and append
 	 * the selected(scan/assoc/adhoc) IE as TLV to the command
 	 */
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index dbc3837..0144ecf 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: SDIO specific handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include <linux/firmware.h>
 
@@ -219,10 +219,10 @@ static int mwifiex_sdio_resume(struct device *dev)
 	return 0;
 }
 
-/** Device ID for SD8787 */
+/* Device ID for SD8787 */
 #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
 
-/** WLAN IDs */
+/* WLAN IDs */
 static const struct sdio_device_id mwifiex_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8787)},
 	{},
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 03614b3..cf77d11 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: SDIO specific definitions
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef	_MWIFIEX_SDIO_H
 #define	_MWIFIEX_SDIO_H
@@ -54,133 +54,133 @@
 
 #define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (4096)	/* 4K */
 
-/** Multi port RX aggregation buffer size */
+/* Multi port RX aggregation buffer size */
 #define SDIO_MP_RX_AGGR_DEF_BUF_SIZE        (4096)	/* 4K */
 
-/** Misc. Config Register : Auto Re-enable interrupts */
+/* Misc. Config Register : Auto Re-enable interrupts */
 #define AUTO_RE_ENABLE_INT              BIT(4)
 
 /* Host Control Registers */
-/** Host Control Registers : I/O port 0 */
+/* Host Control Registers : I/O port 0 */
 #define IO_PORT_0_REG			0x78
-/** Host Control Registers : I/O port 1 */
+/* Host Control Registers : I/O port 1 */
 #define IO_PORT_1_REG			0x79
-/** Host Control Registers : I/O port 2 */
+/* Host Control Registers : I/O port 2 */
 #define IO_PORT_2_REG			0x7A
 
-/** Host Control Registers : Configuration */
+/* Host Control Registers : Configuration */
 #define CONFIGURATION_REG		0x00
-/** Host Control Registers : Host without Command 53 finish host*/
+/* Host Control Registers : Host without Command 53 finish host*/
 #define HOST_TO_CARD_EVENT       (0x1U << 3)
-/** Host Control Registers : Host without Command 53 finish host */
+/* Host Control Registers : Host without Command 53 finish host */
 #define HOST_WO_CMD53_FINISH_HOST	(0x1U << 2)
-/** Host Control Registers : Host power up */
+/* Host Control Registers : Host power up */
 #define HOST_POWER_UP			(0x1U << 1)
-/** Host Control Registers : Host power down */
+/* Host Control Registers : Host power down */
 #define HOST_POWER_DOWN			(0x1U << 0)
 
-/** Host Control Registers : Host interrupt mask */
+/* Host Control Registers : Host interrupt mask */
 #define HOST_INT_MASK_REG		0x02
-/** Host Control Registers : Upload host interrupt mask */
+/* Host Control Registers : Upload host interrupt mask */
 #define UP_LD_HOST_INT_MASK		(0x1U)
-/** Host Control Registers : Download host interrupt mask */
+/* Host Control Registers : Download host interrupt mask */
 #define DN_LD_HOST_INT_MASK		(0x2U)
-/** Enable Host interrupt mask */
+/* Enable Host interrupt mask */
 #define HOST_INT_ENABLE			(UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK)
-/** Disable Host interrupt mask */
+/* Disable Host interrupt mask */
 #define	HOST_INT_DISABLE		0xff
 
-/** Host Control Registers : Host interrupt status */
+/* Host Control Registers : Host interrupt status */
 #define HOST_INTSTATUS_REG		0x03
-/** Host Control Registers : Upload host interrupt status */
+/* Host Control Registers : Upload host interrupt status */
 #define UP_LD_HOST_INT_STATUS		(0x1U)
-/** Host Control Registers : Download host interrupt status */
+/* Host Control Registers : Download host interrupt status */
 #define DN_LD_HOST_INT_STATUS		(0x2U)
 
-/** Host Control Registers : Host interrupt RSR */
+/* Host Control Registers : Host interrupt RSR */
 #define HOST_INT_RSR_REG		0x01
-/** Host Control Registers : Upload host interrupt RSR */
+/* Host Control Registers : Upload host interrupt RSR */
 #define UP_LD_HOST_INT_RSR		(0x1U)
 #define SDIO_INT_MASK			0x3F
 
-/** Host Control Registers : Host interrupt status */
+/* Host Control Registers : Host interrupt status */
 #define HOST_INT_STATUS_REG		0x28
-/** Host Control Registers : Upload CRC error */
+/* Host Control Registers : Upload CRC error */
 #define UP_LD_CRC_ERR			(0x1U << 2)
-/** Host Control Registers : Upload restart */
+/* Host Control Registers : Upload restart */
 #define UP_LD_RESTART                   (0x1U << 1)
-/** Host Control Registers : Download restart */
+/* Host Control Registers : Download restart */
 #define DN_LD_RESTART                   (0x1U << 0)
 
-/** Card Control Registers : Card status register */
+/* Card Control Registers : Card status register */
 #define CARD_STATUS_REG                 0x30
-/** Card Control Registers : Card I/O ready */
+/* Card Control Registers : Card I/O ready */
 #define CARD_IO_READY                   (0x1U << 3)
-/** Card Control Registers : CIS card ready */
+/* Card Control Registers : CIS card ready */
 #define CIS_CARD_RDY                    (0x1U << 2)
-/** Card Control Registers : Upload card ready */
+/* Card Control Registers : Upload card ready */
 #define UP_LD_CARD_RDY                  (0x1U << 1)
-/** Card Control Registers : Download card ready */
+/* Card Control Registers : Download card ready */
 #define DN_LD_CARD_RDY                  (0x1U << 0)
 
-/** Card Control Registers : Host interrupt mask register */
+/* Card Control Registers : Host interrupt mask register */
 #define HOST_INTERRUPT_MASK_REG         0x34
-/** Card Control Registers : Host power interrupt mask */
+/* Card Control Registers : Host power interrupt mask */
 #define HOST_POWER_INT_MASK             (0x1U << 3)
-/** Card Control Registers : Abort card interrupt mask */
+/* Card Control Registers : Abort card interrupt mask */
 #define ABORT_CARD_INT_MASK             (0x1U << 2)
-/** Card Control Registers : Upload card interrupt mask */
+/* Card Control Registers : Upload card interrupt mask */
 #define UP_LD_CARD_INT_MASK             (0x1U << 1)
-/** Card Control Registers : Download card interrupt mask */
+/* Card Control Registers : Download card interrupt mask */
 #define DN_LD_CARD_INT_MASK             (0x1U << 0)
 
-/** Card Control Registers : Card interrupt status register */
+/* Card Control Registers : Card interrupt status register */
 #define CARD_INTERRUPT_STATUS_REG       0x38
-/** Card Control Registers : Power up interrupt */
+/* Card Control Registers : Power up interrupt */
 #define POWER_UP_INT                    (0x1U << 4)
-/** Card Control Registers : Power down interrupt */
+/* Card Control Registers : Power down interrupt */
 #define POWER_DOWN_INT                  (0x1U << 3)
 
-/** Card Control Registers : Card interrupt RSR register */
+/* Card Control Registers : Card interrupt RSR register */
 #define CARD_INTERRUPT_RSR_REG          0x3c
-/** Card Control Registers : Power up RSR */
+/* Card Control Registers : Power up RSR */
 #define POWER_UP_RSR                    (0x1U << 4)
-/** Card Control Registers : Power down RSR */
+/* Card Control Registers : Power down RSR */
 #define POWER_DOWN_RSR                  (0x1U << 3)
 
-/** Card Control Registers : Miscellaneous Configuration Register */
+/* Card Control Registers : Miscellaneous Configuration Register */
 #define CARD_MISC_CFG_REG               0x6C
 
-/** Host F1 read base 0 */
+/* Host F1 read base 0 */
 #define HOST_F1_RD_BASE_0		0x0040
-/** Host F1 read base 1 */
+/* Host F1 read base 1 */
 #define HOST_F1_RD_BASE_1		0x0041
-/** Host F1 card ready */
+/* Host F1 card ready */
 #define HOST_F1_CARD_RDY		0x0020
 
-/** Firmware status 0 register */
+/* Firmware status 0 register */
 #define CARD_FW_STATUS0_REG		0x60
-/** Firmware status 1 register */
+/* Firmware status 1 register */
 #define CARD_FW_STATUS1_REG		0x61
-/** Rx length register */
+/* Rx length register */
 #define CARD_RX_LEN_REG			0x62
-/** Rx unit register */
+/* Rx unit register */
 #define CARD_RX_UNIT_REG		0x63
 
-/** Event header Len*/
+/* Event header Len*/
 #define MWIFIEX_EVENT_HEADER_LEN           8
 
-/** Max retry number of CMD53 write */
+/* Max retry number of CMD53 write */
 #define MAX_WRITE_IOMEM_RETRY		2
 
-/** SDIO Tx aggregation in progress ? */
+/* SDIO Tx aggregation in progress ? */
 #define MP_TX_AGGR_IN_PROGRESS(a) (a->mpa_tx.pkt_cnt > 0)
 
-/** SDIO Tx aggregation buffer room for next packet ? */
+/* SDIO Tx aggregation buffer room for next packet ? */
 #define MP_TX_AGGR_BUF_HAS_ROOM(a, len) ((a->mpa_tx.buf_len+len) \
 						<= a->mpa_tx.buf_size)
 
-/** Copy current packet (SDIO Tx aggregation buffer) to SDIO buffer */
+/* Copy current packet (SDIO Tx aggregation buffer) to SDIO buffer */
 #define MP_TX_AGGR_BUF_PUT(a, payload, pkt_len, port) do {                   \
 	memmove(&a->mpa_tx.buf[a->mpa_tx.buf_len], \
 			payload, pkt_len);				\
@@ -197,16 +197,16 @@
 	a->mpa_tx.pkt_cnt++;                                        \
 } while (0);
 
-/** SDIO Tx aggregation limit ? */
+/* SDIO Tx aggregation limit ? */
 #define MP_TX_AGGR_PKT_LIMIT_REACHED(a) (a->mpa_tx.pkt_cnt == a->mpa_tx.pkt_aggr_limit)
 
-/** SDIO Tx aggregation port limit ? */
+/* SDIO Tx aggregation port limit ? */
 #define MP_TX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_wr_port < \
 			a->mpa_tx.start_port) && (((MAX_PORT - \
 			a->mpa_tx.start_port) + a->curr_wr_port) >= \
 				SDIO_MP_AGGR_DEF_PKT_LIMIT))
 
-/** Reset SDIO Tx aggregation buffer parameters */
+/* Reset SDIO Tx aggregation buffer parameters */
 #define MP_TX_AGGR_BUF_RESET(a) do {         \
 	a->mpa_tx.pkt_cnt = 0;                   \
 	a->mpa_tx.buf_len = 0;                   \
@@ -214,22 +214,22 @@
 	a->mpa_tx.start_port = 0;                \
 } while (0);
 
-/** SDIO Rx aggregation limit ? */
+/* SDIO Rx aggregation limit ? */
 #define MP_RX_AGGR_PKT_LIMIT_REACHED(a) (a->mpa_rx.pkt_cnt == a->mpa_rx.pkt_aggr_limit)
 
-/** SDIO Tx aggregation port limit ? */
+/* SDIO Tx aggregation port limit ? */
 #define MP_RX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_rd_port < \
 			a->mpa_rx.start_port) && (((MAX_PORT - \
 			a->mpa_rx.start_port) + a->curr_rd_port) >= \
 			SDIO_MP_AGGR_DEF_PKT_LIMIT))
 
-/** SDIO Rx aggregation in progress ? */
+/* SDIO Rx aggregation in progress ? */
 #define MP_RX_AGGR_IN_PROGRESS(a) (a->mpa_rx.pkt_cnt > 0)
 
-/** SDIO Rx aggregation buffer room for next packet ? */
+/* SDIO Rx aggregation buffer room for next packet ? */
 #define MP_RX_AGGR_BUF_HAS_ROOM(a, rx_len)   ((a->mpa_rx.buf_len+rx_len) <= a->mpa_rx.buf_size)
 
-/** Prepare to copy current packet from card to SDIO Rx aggregation buffer */
+/* Prepare to copy current packet from card to SDIO Rx aggregation buffer */
 #define MP_RX_AGGR_SETUP(a, skb, port) do {    \
 	a->mpa_rx.buf_len += skb->len;                       \
 	if (!a->mpa_rx.pkt_cnt) {                            \
@@ -245,7 +245,7 @@
 	a->mpa_rx.pkt_cnt++;                               \
 } while (0);
 
-/** Reset SDIO Rx aggregation buffer parameters */
+/* Reset SDIO Rx aggregation buffer parameters */
 #define MP_RX_AGGR_BUF_RESET(a) do {         \
 	a->mpa_rx.pkt_cnt = 0;                   \
 	a->mpa_rx.buf_len = 0;                   \
@@ -254,9 +254,9 @@
 } while (0);
 
 
-/** data structure for SDIO MPA TX */
+/* data structure for SDIO MPA TX */
 struct mwifiex_sdio_mpa_tx {
-	/** multiport tx aggregation buffer pointer */
+	/* multiport tx aggregation buffer pointer */
 	u8 *buf;
 	u32 buf_len;
 	u32 pkt_cnt;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 6715410..3de93d0 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: station command handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -542,7 +542,7 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 		    (priv->wep_key[i].key_length == WLAN_KEY_LEN_WEP104)) {
 			key_param_set->type =
 				cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
-/** Key_param_set WEP fixed length */
+/* Key_param_set WEP fixed length */
 #define KEYPARAMSET_WEP_FIXED_LEN 8
 			key_param_set->length = cpu_to_le16((u16)
 					(priv->wep_key[i].
@@ -655,14 +655,10 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			key_material->key_param_set.key[1] = 0;
 
 		if (0 != memcmp(enc_key->mac_addr, bc_mac, sizeof(bc_mac)))
-			/* WAPI
-			   pairwise
-			   key:
-			   unicast
-			   */
+			/* WAPI pairwise key: unicast */
 			key_material->key_param_set.key_info |=
 				cpu_to_le16(KEY_INFO_WAPI_UNICAST);
-		else {		/* WAPI group key: multicast */
+		else {	/* WAPI group key: multicast */
 			key_material->key_param_set.key_info |=
 				cpu_to_le16(KEY_INFO_WAPI_MCAST);
 			priv->sec_info.wapi_key_on = true;
@@ -1412,9 +1408,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
 		if (ret)
 			return -1;
-		/*
-		 * Read MAC address from HW
-		 */
+		/* Read MAC address from HW */
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
 					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 		if (ret)
@@ -1496,7 +1490,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (ret)
 		PRINTM(MERROR, "11D: Failed to enable 11D\n");
 
-	/** set last_init_cmd */
+	/* set last_init_cmd */
 	priv->adapter->last_init_cmd = HostCmd_CMD_802_11_SNMP_MIB;
 	ret = -EINPROGRESS;
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index e922d16..7b96c75 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: station command response handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -62,9 +62,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			PRINTM(MERROR, "PS_MODE_ENH command failed: "
 					"result=0x%x action=0x%X\n",
 					resp->result, le16_to_cpu(pm->action));
-			/*
-			 * We do not re-try enter-ps command in ad-hoc mode.
-			 */
+			/* We do not re-try enter-ps command in ad-hoc mode. */
 			if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
 			    (le16_to_cpu(pm->params.auto_ps.ps_bitmap) &
 			     BITMAP_STA_PS)
@@ -103,9 +101,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	default:
 		break;
 	}
-	/*
-	 * Handling errors here
-	 */
+	/* Handling errors here */
 	mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 7238154..d9ace43 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: station event handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 6181198..01abe99 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: functions for station ioctl
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -3545,8 +3545,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		}
 	}
 
-	/* Return 0, or -1 for error
-	   case */
+	/* Return 0, or -1 for error case */
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index d7efd11..3f59cf6 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: station RX data handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index f457e24..9b18c45 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: station TX data handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 7f94cc4..f6629dc 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: generic TX/RX data handling
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 05ae840..2c2198a 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: utility functions
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index db19d19..c446fb4 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: utility functions
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_UTIL_H_
 #define _MWIFIEX_UTIL_H_
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 789632d..ece8f2c 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: WMM
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #include "decl.h"
 #include "ioctl.h"
@@ -27,7 +27,7 @@
 #include "11n.h"
 
 
-/** Maximum value FW can accept for driver delay in packet transmission */
+/* Maximum value FW can accept for driver delay in packet transmission */
 #define DRV_PKT_DELAY_TO_FW_MAX   512
 
 
@@ -35,10 +35,10 @@
 
 #define WMM_QUEUED_PACKET_UPPER_LIMIT   200
 
-/** Offset for TOS field in the IP header */
+/* Offset for TOS field in the IP header */
 #define IPTOS_OFFSET 5
 
-/** WMM information IE */
+/* WMM information IE */
 static const u8 wmm_info_ie[] = { WLAN_EID_VENDOR_SPECIFIC, 0x07,
 	0x00, 0x50, 0xf2, 0x02,
 	0x00, 0x01, 0x00
@@ -62,7 +62,7 @@ static u8 tos_to_tid[] = {
 	0x07			/* 1 1 1 AC_VO */
 };
 
-/**
+/*
  * This table inverses the tos_to_tid operation to get a priority
  * which is in sequential order, and can be compared.
  * Use this to compare the priority of two different TIDs.
@@ -1046,7 +1046,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	status = mwifiex_process_tx(priv, skb, &tx_param);
 
 	if (status == -EBUSY) {
-		/** Queue the packet back at the head */
+		/* Queue the packet back at the head */
 		PRINTM(MDAT_D, "Queuing pkt back to raList %p %p\n",
 		       ptr, skb);
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
@@ -1255,7 +1255,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 				mwifiex_send_delba(priv, tid_del, ra, 1);
 			}
 		}
-/** Minimum number of AMSDU */
+/* Minimum number of AMSDU */
 #define MIN_NUM_AMSDU 2
 		if (mwifiex_is_amsdu_allowed(priv, ptr, tid) &&
 		    (mwifiex_num_pkts_in_txq(priv, ptr,
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index f2fa4e0..24cc472 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell Wireless LAN device driver: WMM
  *
  * Copyright (C) 2010, Marvell International Ltd.
@@ -15,7 +15,7 @@
  * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
  * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
  * this warranty disclaimer.
- **/
+ */
 
 #ifndef _MWIFIEX_WMM_H_
 #define _MWIFIEX_WMM_H_
-- 
1.7.0.2

