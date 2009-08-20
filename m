Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49372 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZHTTxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 15:53:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libipw: switch from ieee80211_* to libipw_* naming policy
Date: Thu, 20 Aug 2009 14:48:03 -0400
Message-Id: <1250794083-8779-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This eliminates the dual definition of ieee80211_channel (and possibly
others), further clarifying who defines what and paving the way for
inclusion of cfg80211.h.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/ieee80211.h     | 1087 --------------------------
 drivers/net/wireless/ipw2x00/ipw2100.c       |  198 +++---
 drivers/net/wireless/ipw2x00/ipw2100.h       |   14 +-
 drivers/net/wireless/ipw2x00/ipw2200.c       |  902 +++++++++++-----------
 drivers/net/wireless/ipw2x00/ipw2200.h       |   14 +-
 drivers/net/wireless/ipw2x00/libipw.h        | 1087 ++++++++++++++++++++++++++
 drivers/net/wireless/ipw2x00/libipw_geo.c    |   80 +-
 drivers/net/wireless/ipw2x00/libipw_module.c |   80 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c     |  403 +++++-----
 drivers/net/wireless/ipw2x00/libipw_tx.c     |   68 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c     |   92 ++--
 include/net/iw_handler.h                     |    6 +-
 12 files changed, 2016 insertions(+), 2015 deletions(-)
 delete mode 100644 drivers/net/wireless/ipw2x00/ieee80211.h
 create mode 100644 drivers/net/wireless/ipw2x00/libipw.h

diff --git a/drivers/net/wireless/ipw2x00/ieee80211.h b/drivers/net/wireless/ipw2x00/ieee80211.h
deleted file mode 100644
index 70755c1..0000000
--- a/drivers/net/wireless/ipw2x00/ieee80211.h
+++ /dev/null
@@ -1,1087 +0,0 @@
-/*
- * Merged with mainline ieee80211.h in Aug 2004.  Original ieee802_11
- * remains copyright by the original authors
- *
- * Portions of the merged code are based on Host AP (software wireless
- * LAN access point) driver for Intersil Prism2/2.5/3.
- *
- * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <j@w1.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
- *
- * Adaption to a generic IEEE 802.11 stack by James Ketrenos
- * <jketreno@linux.intel.com>
- * Copyright (c) 2004-2005, Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation. See README and COPYING for
- * more details.
- *
- * API Version History
- * 1.0.x -- Initial version
- * 1.1.x -- Added radiotap, QoS, TIM, ieee80211_geo APIs,
- *          various structure changes, and crypto API init method
- */
-#ifndef IEEE80211_H
-#define IEEE80211_H
-#include <linux/if_ether.h>	/* ETH_ALEN */
-#include <linux/kernel.h>	/* ARRAY_SIZE */
-#include <linux/wireless.h>
-#include <linux/ieee80211.h>
-
-#include <net/lib80211.h>
-
-#define IEEE80211_VERSION "git-1.1.13"
-
-#define IEEE80211_DATA_LEN		2304
-/* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
-   6.2.1.1.2.
-
-   The figure in section 7.1.2 suggests a body size of up to 2312
-   bytes is allowed, which is a bit confusing, I suspect this
-   represents the 2304 bytes of real data, plus a possible 8 bytes of
-   WEP IV and ICV. (this interpretation suggested by Ramiro Barreiro) */
-
-#define IEEE80211_1ADDR_LEN 10
-#define IEEE80211_2ADDR_LEN 16
-#define IEEE80211_3ADDR_LEN 24
-#define IEEE80211_4ADDR_LEN 30
-#define IEEE80211_FCS_LEN    4
-#define IEEE80211_HLEN			(IEEE80211_4ADDR_LEN)
-#define IEEE80211_FRAME_LEN		(IEEE80211_DATA_LEN + IEEE80211_HLEN)
-
-#define MIN_FRAG_THRESHOLD     256U
-#define	MAX_FRAG_THRESHOLD     2346U
-
-/* QOS control */
-#define IEEE80211_QCTL_TID		0x000F
-
-/* debug macros */
-
-#ifdef CONFIG_LIBIPW_DEBUG
-extern u32 ieee80211_debug_level;
-#define IEEE80211_DEBUG(level, fmt, args...) \
-do { if (ieee80211_debug_level & (level)) \
-  printk(KERN_DEBUG "ieee80211: %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
-static inline bool ieee80211_ratelimit_debug(u32 level)
-{
-	return (ieee80211_debug_level & level) && net_ratelimit();
-}
-#else
-#define IEEE80211_DEBUG(level, fmt, args...) do {} while (0)
-static inline bool ieee80211_ratelimit_debug(u32 level)
-{
-	return false;
-}
-#endif				/* CONFIG_LIBIPW_DEBUG */
-
-/*
- * To use the debug system:
- *
- * If you are defining a new debug classification, simply add it to the #define
- * list here in the form of:
- *
- * #define IEEE80211_DL_xxxx VALUE
- *
- * shifting value to the left one bit from the previous entry.  xxxx should be
- * the name of the classification (for example, WEP)
- *
- * You then need to either add a IEEE80211_xxxx_DEBUG() macro definition for your
- * classification, or use IEEE80211_DEBUG(IEEE80211_DL_xxxx, ...) whenever you want
- * to send output to that classification.
- *
- * To add your debug level to the list of levels seen when you perform
- *
- * % cat /proc/net/ieee80211/debug_level
- *
- * you simply need to add your entry to the ieee80211_debug_level array.
- *
- * If you do not see debug_level in /proc/net/ieee80211 then you do not have
- * CONFIG_LIBIPW_DEBUG defined in your kernel configuration
- *
- */
-
-#define IEEE80211_DL_INFO          (1<<0)
-#define IEEE80211_DL_WX            (1<<1)
-#define IEEE80211_DL_SCAN          (1<<2)
-#define IEEE80211_DL_STATE         (1<<3)
-#define IEEE80211_DL_MGMT          (1<<4)
-#define IEEE80211_DL_FRAG          (1<<5)
-#define IEEE80211_DL_DROP          (1<<7)
-
-#define IEEE80211_DL_TX            (1<<8)
-#define IEEE80211_DL_RX            (1<<9)
-#define IEEE80211_DL_QOS           (1<<31)
-
-#define IEEE80211_ERROR(f, a...) printk(KERN_ERR "ieee80211: " f, ## a)
-#define IEEE80211_WARNING(f, a...) printk(KERN_WARNING "ieee80211: " f, ## a)
-#define IEEE80211_DEBUG_INFO(f, a...)   IEEE80211_DEBUG(IEEE80211_DL_INFO, f, ## a)
-
-#define IEEE80211_DEBUG_WX(f, a...)     IEEE80211_DEBUG(IEEE80211_DL_WX, f, ## a)
-#define IEEE80211_DEBUG_SCAN(f, a...)   IEEE80211_DEBUG(IEEE80211_DL_SCAN, f, ## a)
-#define IEEE80211_DEBUG_STATE(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_STATE, f, ## a)
-#define IEEE80211_DEBUG_MGMT(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_MGMT, f, ## a)
-#define IEEE80211_DEBUG_FRAG(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_FRAG, f, ## a)
-#define IEEE80211_DEBUG_DROP(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_DROP, f, ## a)
-#define IEEE80211_DEBUG_TX(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_TX, f, ## a)
-#define IEEE80211_DEBUG_RX(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_RX, f, ## a)
-#define IEEE80211_DEBUG_QOS(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_QOS, f, ## a)
-#include <linux/netdevice.h>
-#include <linux/if_arp.h>	/* ARPHRD_ETHER */
-
-#ifndef WIRELESS_SPY
-#define WIRELESS_SPY		/* enable iwspy support */
-#endif
-#include <net/iw_handler.h>	/* new driver API */
-
-#define ETH_P_PREAUTH 0x88C7	/* IEEE 802.11i pre-authentication */
-
-#ifndef ETH_P_80211_RAW
-#define ETH_P_80211_RAW (ETH_P_ECONET + 1)
-#endif
-
-/* IEEE 802.11 defines */
-
-#define P80211_OUI_LEN 3
-
-struct ieee80211_snap_hdr {
-
-	u8 dsap;		/* always 0xAA */
-	u8 ssap;		/* always 0xAA */
-	u8 ctrl;		/* always 0x03 */
-	u8 oui[P80211_OUI_LEN];	/* organizational universal id */
-
-} __attribute__ ((packed));
-
-#define SNAP_SIZE sizeof(struct ieee80211_snap_hdr)
-
-#define WLAN_FC_GET_VERS(fc) ((fc) & IEEE80211_FCTL_VERS)
-#define WLAN_FC_GET_TYPE(fc) ((fc) & IEEE80211_FCTL_FTYPE)
-#define WLAN_FC_GET_STYPE(fc) ((fc) & IEEE80211_FCTL_STYPE)
-
-#define WLAN_GET_SEQ_FRAG(seq) ((seq) & IEEE80211_SCTL_FRAG)
-#define WLAN_GET_SEQ_SEQ(seq)  (((seq) & IEEE80211_SCTL_SEQ) >> 4)
-
-#define IEEE80211_STATMASK_SIGNAL (1<<0)
-#define IEEE80211_STATMASK_RSSI (1<<1)
-#define IEEE80211_STATMASK_NOISE (1<<2)
-#define IEEE80211_STATMASK_RATE (1<<3)
-#define IEEE80211_STATMASK_WEMASK 0x7
-
-#define IEEE80211_CCK_MODULATION    (1<<0)
-#define IEEE80211_OFDM_MODULATION   (1<<1)
-
-#define IEEE80211_24GHZ_BAND     (1<<0)
-#define IEEE80211_52GHZ_BAND     (1<<1)
-
-#define IEEE80211_CCK_RATE_1MB		        0x02
-#define IEEE80211_CCK_RATE_2MB		        0x04
-#define IEEE80211_CCK_RATE_5MB		        0x0B
-#define IEEE80211_CCK_RATE_11MB		        0x16
-#define IEEE80211_OFDM_RATE_6MB		        0x0C
-#define IEEE80211_OFDM_RATE_9MB		        0x12
-#define IEEE80211_OFDM_RATE_12MB		0x18
-#define IEEE80211_OFDM_RATE_18MB		0x24
-#define IEEE80211_OFDM_RATE_24MB		0x30
-#define IEEE80211_OFDM_RATE_36MB		0x48
-#define IEEE80211_OFDM_RATE_48MB		0x60
-#define IEEE80211_OFDM_RATE_54MB		0x6C
-#define IEEE80211_BASIC_RATE_MASK		0x80
-
-#define IEEE80211_CCK_RATE_1MB_MASK		(1<<0)
-#define IEEE80211_CCK_RATE_2MB_MASK		(1<<1)
-#define IEEE80211_CCK_RATE_5MB_MASK		(1<<2)
-#define IEEE80211_CCK_RATE_11MB_MASK		(1<<3)
-#define IEEE80211_OFDM_RATE_6MB_MASK		(1<<4)
-#define IEEE80211_OFDM_RATE_9MB_MASK		(1<<5)
-#define IEEE80211_OFDM_RATE_12MB_MASK		(1<<6)
-#define IEEE80211_OFDM_RATE_18MB_MASK		(1<<7)
-#define IEEE80211_OFDM_RATE_24MB_MASK		(1<<8)
-#define IEEE80211_OFDM_RATE_36MB_MASK		(1<<9)
-#define IEEE80211_OFDM_RATE_48MB_MASK		(1<<10)
-#define IEEE80211_OFDM_RATE_54MB_MASK		(1<<11)
-
-#define IEEE80211_CCK_RATES_MASK	        0x0000000F
-#define IEEE80211_CCK_BASIC_RATES_MASK	(IEEE80211_CCK_RATE_1MB_MASK | \
-	IEEE80211_CCK_RATE_2MB_MASK)
-#define IEEE80211_CCK_DEFAULT_RATES_MASK	(IEEE80211_CCK_BASIC_RATES_MASK | \
-        IEEE80211_CCK_RATE_5MB_MASK | \
-        IEEE80211_CCK_RATE_11MB_MASK)
-
-#define IEEE80211_OFDM_RATES_MASK		0x00000FF0
-#define IEEE80211_OFDM_BASIC_RATES_MASK	(IEEE80211_OFDM_RATE_6MB_MASK | \
-	IEEE80211_OFDM_RATE_12MB_MASK | \
-	IEEE80211_OFDM_RATE_24MB_MASK)
-#define IEEE80211_OFDM_DEFAULT_RATES_MASK	(IEEE80211_OFDM_BASIC_RATES_MASK | \
-	IEEE80211_OFDM_RATE_9MB_MASK  | \
-	IEEE80211_OFDM_RATE_18MB_MASK | \
-	IEEE80211_OFDM_RATE_36MB_MASK | \
-	IEEE80211_OFDM_RATE_48MB_MASK | \
-	IEEE80211_OFDM_RATE_54MB_MASK)
-#define IEEE80211_DEFAULT_RATES_MASK (IEEE80211_OFDM_DEFAULT_RATES_MASK | \
-                                IEEE80211_CCK_DEFAULT_RATES_MASK)
-
-#define IEEE80211_NUM_OFDM_RATES	    8
-#define IEEE80211_NUM_CCK_RATES	            4
-#define IEEE80211_OFDM_SHIFT_MASK_A         4
-
-/* NOTE: This data is for statistical purposes; not all hardware provides this
- *       information for frames received.
- *       For ieee80211_rx_mgt, you need to set at least the 'len' parameter.
- */
-struct ieee80211_rx_stats {
-	u32 mac_time;
-	s8 rssi;
-	u8 signal;
-	u8 noise;
-	u16 rate;		/* in 100 kbps */
-	u8 received_channel;
-	u8 control;
-	u8 mask;
-	u8 freq;
-	u16 len;
-	u64 tsf;
-	u32 beacon_time;
-};
-
-/* IEEE 802.11 requires that STA supports concurrent reception of at least
- * three fragmented frames. This define can be increased to support more
- * concurrent frames, but it should be noted that each entry can consume about
- * 2 kB of RAM and increasing cache size will slow down frame reassembly. */
-#define IEEE80211_FRAG_CACHE_LEN 4
-
-struct ieee80211_frag_entry {
-	unsigned long first_frag_time;
-	unsigned int seq;
-	unsigned int last_frag;
-	struct sk_buff *skb;
-	u8 src_addr[ETH_ALEN];
-	u8 dst_addr[ETH_ALEN];
-};
-
-struct ieee80211_stats {
-	unsigned int tx_unicast_frames;
-	unsigned int tx_multicast_frames;
-	unsigned int tx_fragments;
-	unsigned int tx_unicast_octets;
-	unsigned int tx_multicast_octets;
-	unsigned int tx_deferred_transmissions;
-	unsigned int tx_single_retry_frames;
-	unsigned int tx_multiple_retry_frames;
-	unsigned int tx_retry_limit_exceeded;
-	unsigned int tx_discards;
-	unsigned int rx_unicast_frames;
-	unsigned int rx_multicast_frames;
-	unsigned int rx_fragments;
-	unsigned int rx_unicast_octets;
-	unsigned int rx_multicast_octets;
-	unsigned int rx_fcs_errors;
-	unsigned int rx_discards_no_buffer;
-	unsigned int tx_discards_wrong_sa;
-	unsigned int rx_discards_undecryptable;
-	unsigned int rx_message_in_msg_fragments;
-	unsigned int rx_message_in_bad_msg_fragments;
-};
-
-struct ieee80211_device;
-
-#define SEC_KEY_1		(1<<0)
-#define SEC_KEY_2		(1<<1)
-#define SEC_KEY_3		(1<<2)
-#define SEC_KEY_4		(1<<3)
-#define SEC_ACTIVE_KEY		(1<<4)
-#define SEC_AUTH_MODE		(1<<5)
-#define SEC_UNICAST_GROUP	(1<<6)
-#define SEC_LEVEL		(1<<7)
-#define SEC_ENABLED		(1<<8)
-#define SEC_ENCRYPT		(1<<9)
-
-#define SEC_LEVEL_0		0	/* None */
-#define SEC_LEVEL_1		1	/* WEP 40 and 104 bit */
-#define SEC_LEVEL_2		2	/* Level 1 + TKIP */
-#define SEC_LEVEL_2_CKIP	3	/* Level 1 + CKIP */
-#define SEC_LEVEL_3		4	/* Level 2 + CCMP */
-
-#define SEC_ALG_NONE		0
-#define SEC_ALG_WEP		1
-#define SEC_ALG_TKIP		2
-#define SEC_ALG_CCMP		3
-
-#define WEP_KEYS		4
-#define WEP_KEY_LEN		13
-#define SCM_KEY_LEN		32
-#define SCM_TEMPORAL_KEY_LENGTH	16
-
-struct ieee80211_security {
-	u16 active_key:2, enabled:1, unicast_uses_group:1, encrypt:1;
-	u8 auth_mode;
-	u8 encode_alg[WEP_KEYS];
-	u8 key_sizes[WEP_KEYS];
-	u8 keys[WEP_KEYS][SCM_KEY_LEN];
-	u8 level;
-	u16 flags;
-} __attribute__ ((packed));
-
-/*
-
- 802.11 data frame from AP
-
-      ,-------------------------------------------------------------------.
-Bytes |  2   |  2   |    6    |    6    |    6    |  2   | 0..2312 |   4  |
-      |------|------|---------|---------|---------|------|---------|------|
-Desc. | ctrl | dura |  DA/RA  |   TA    |    SA   | Sequ |  frame  |  fcs |
-      |      | tion | (BSSID) |         |         | ence |  data   |      |
-      `-------------------------------------------------------------------'
-
-Total: 28-2340 bytes
-
-*/
-
-#define BEACON_PROBE_SSID_ID_POSITION 12
-
-struct ieee80211_hdr_1addr {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 payload[0];
-} __attribute__ ((packed));
-
-struct ieee80211_hdr_2addr {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 payload[0];
-} __attribute__ ((packed));
-
-struct ieee80211_hdr_3addr {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
-	__le16 seq_ctl;
-	u8 payload[0];
-} __attribute__ ((packed));
-
-struct ieee80211_hdr_4addr {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
-	__le16 seq_ctl;
-	u8 addr4[ETH_ALEN];
-	u8 payload[0];
-} __attribute__ ((packed));
-
-struct ieee80211_hdr_3addrqos {
-	__le16 frame_ctl;
-	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
-	__le16 seq_ctl;
-	u8 payload[0];
-	__le16 qos_ctl;
-} __attribute__ ((packed));
-
-struct ieee80211_info_element {
-	u8 id;
-	u8 len;
-	u8 data[0];
-} __attribute__ ((packed));
-
-/*
- * These are the data types that can make up management packets
- *
-	u16 auth_algorithm;
-	u16 auth_sequence;
-	u16 beacon_interval;
-	u16 capability;
-	u8 current_ap[ETH_ALEN];
-	u16 listen_interval;
-	struct {
-		u16 association_id:14, reserved:2;
-	} __attribute__ ((packed));
-	u32 time_stamp[2];
-	u16 reason;
-	u16 status;
-*/
-
-struct ieee80211_auth {
-	struct ieee80211_hdr_3addr header;
-	__le16 algorithm;
-	__le16 transaction;
-	__le16 status;
-	/* challenge */
-	struct ieee80211_info_element info_element[0];
-} __attribute__ ((packed));
-
-struct ieee80211_channel_switch {
-	u8 id;
-	u8 len;
-	u8 mode;
-	u8 channel;
-	u8 count;
-} __attribute__ ((packed));
-
-struct ieee80211_action {
-	struct ieee80211_hdr_3addr header;
-	u8 category;
-	u8 action;
-	union {
-		struct ieee80211_action_exchange {
-			u8 token;
-			struct ieee80211_info_element info_element[0];
-		} exchange;
-		struct ieee80211_channel_switch channel_switch;
-
-	} format;
-} __attribute__ ((packed));
-
-struct ieee80211_disassoc {
-	struct ieee80211_hdr_3addr header;
-	__le16 reason;
-} __attribute__ ((packed));
-
-/* Alias deauth for disassoc */
-#define ieee80211_deauth ieee80211_disassoc
-
-struct ieee80211_probe_request {
-	struct ieee80211_hdr_3addr header;
-	/* SSID, supported rates */
-	struct ieee80211_info_element info_element[0];
-} __attribute__ ((packed));
-
-struct ieee80211_probe_response {
-	struct ieee80211_hdr_3addr header;
-	__le32 time_stamp[2];
-	__le16 beacon_interval;
-	__le16 capability;
-	/* SSID, supported rates, FH params, DS params,
-	 * CF params, IBSS params, TIM (if beacon), RSN */
-	struct ieee80211_info_element info_element[0];
-} __attribute__ ((packed));
-
-/* Alias beacon for probe_response */
-#define ieee80211_beacon ieee80211_probe_response
-
-struct ieee80211_assoc_request {
-	struct ieee80211_hdr_3addr header;
-	__le16 capability;
-	__le16 listen_interval;
-	/* SSID, supported rates, RSN */
-	struct ieee80211_info_element info_element[0];
-} __attribute__ ((packed));
-
-struct ieee80211_reassoc_request {
-	struct ieee80211_hdr_3addr header;
-	__le16 capability;
-	__le16 listen_interval;
-	u8 current_ap[ETH_ALEN];
-	struct ieee80211_info_element info_element[0];
-} __attribute__ ((packed));
-
-struct ieee80211_assoc_response {
-	struct ieee80211_hdr_3addr header;
-	__le16 capability;
-	__le16 status;
-	__le16 aid;
-	/* supported rates */
-	struct ieee80211_info_element info_element[0];
-} __attribute__ ((packed));
-
-struct ieee80211_txb {
-	u8 nr_frags;
-	u8 encrypted;
-	u8 rts_included;
-	u8 reserved;
-	u16 frag_size;
-	u16 payload_size;
-	struct sk_buff *fragments[0];
-};
-
-/* SWEEP TABLE ENTRIES NUMBER */
-#define MAX_SWEEP_TAB_ENTRIES		  42
-#define MAX_SWEEP_TAB_ENTRIES_PER_PACKET  7
-/* MAX_RATES_LENGTH needs to be 12.  The spec says 8, and many APs
- * only use 8, and then use extended rates for the remaining supported
- * rates.  Other APs, however, stick all of their supported rates on the
- * main rates information element... */
-#define MAX_RATES_LENGTH                  ((u8)12)
-#define MAX_RATES_EX_LENGTH               ((u8)16)
-#define MAX_NETWORK_COUNT                  128
-
-#define CRC_LENGTH                 4U
-
-#define MAX_WPA_IE_LEN 64
-
-#define NETWORK_HAS_OFDM       (1<<1)
-#define NETWORK_HAS_CCK        (1<<2)
-
-/* QoS structure */
-#define NETWORK_HAS_QOS_PARAMETERS      (1<<3)
-#define NETWORK_HAS_QOS_INFORMATION     (1<<4)
-#define NETWORK_HAS_QOS_MASK            (NETWORK_HAS_QOS_PARAMETERS | \
-					 NETWORK_HAS_QOS_INFORMATION)
-
-/* 802.11h */
-#define NETWORK_HAS_POWER_CONSTRAINT    (1<<5)
-#define NETWORK_HAS_CSA                 (1<<6)
-#define NETWORK_HAS_QUIET               (1<<7)
-#define NETWORK_HAS_IBSS_DFS            (1<<8)
-#define NETWORK_HAS_TPC_REPORT          (1<<9)
-
-#define NETWORK_HAS_ERP_VALUE           (1<<10)
-
-#define QOS_QUEUE_NUM                   4
-#define QOS_OUI_LEN                     3
-#define QOS_OUI_TYPE                    2
-#define QOS_ELEMENT_ID                  221
-#define QOS_OUI_INFO_SUB_TYPE           0
-#define QOS_OUI_PARAM_SUB_TYPE          1
-#define QOS_VERSION_1                   1
-#define QOS_AIFSN_MIN_VALUE             2
-
-struct ieee80211_qos_information_element {
-	u8 elementID;
-	u8 length;
-	u8 qui[QOS_OUI_LEN];
-	u8 qui_type;
-	u8 qui_subtype;
-	u8 version;
-	u8 ac_info;
-} __attribute__ ((packed));
-
-struct ieee80211_qos_ac_parameter {
-	u8 aci_aifsn;
-	u8 ecw_min_max;
-	__le16 tx_op_limit;
-} __attribute__ ((packed));
-
-struct ieee80211_qos_parameter_info {
-	struct ieee80211_qos_information_element info_element;
-	u8 reserved;
-	struct ieee80211_qos_ac_parameter ac_params_record[QOS_QUEUE_NUM];
-} __attribute__ ((packed));
-
-struct ieee80211_qos_parameters {
-	__le16 cw_min[QOS_QUEUE_NUM];
-	__le16 cw_max[QOS_QUEUE_NUM];
-	u8 aifs[QOS_QUEUE_NUM];
-	u8 flag[QOS_QUEUE_NUM];
-	__le16 tx_op_limit[QOS_QUEUE_NUM];
-} __attribute__ ((packed));
-
-struct ieee80211_qos_data {
-	struct ieee80211_qos_parameters parameters;
-	int active;
-	int supported;
-	u8 param_count;
-	u8 old_param_count;
-};
-
-struct ieee80211_tim_parameters {
-	u8 tim_count;
-	u8 tim_period;
-} __attribute__ ((packed));
-
-/*******************************************************/
-
-enum {				/* ieee80211_basic_report.map */
-	IEEE80211_BASIC_MAP_BSS = (1 << 0),
-	IEEE80211_BASIC_MAP_OFDM = (1 << 1),
-	IEEE80211_BASIC_MAP_UNIDENTIFIED = (1 << 2),
-	IEEE80211_BASIC_MAP_RADAR = (1 << 3),
-	IEEE80211_BASIC_MAP_UNMEASURED = (1 << 4),
-	/* Bits 5-7 are reserved */
-
-};
-struct ieee80211_basic_report {
-	u8 channel;
-	__le64 start_time;
-	__le16 duration;
-	u8 map;
-} __attribute__ ((packed));
-
-enum {				/* ieee80211_measurement_request.mode */
-	/* Bit 0 is reserved */
-	IEEE80211_MEASUREMENT_ENABLE = (1 << 1),
-	IEEE80211_MEASUREMENT_REQUEST = (1 << 2),
-	IEEE80211_MEASUREMENT_REPORT = (1 << 3),
-	/* Bits 4-7 are reserved */
-};
-
-enum {
-	IEEE80211_REPORT_BASIC = 0,	/* required */
-	IEEE80211_REPORT_CCA = 1,	/* optional */
-	IEEE80211_REPORT_RPI = 2,	/* optional */
-	/* 3-255 reserved */
-};
-
-struct ieee80211_measurement_params {
-	u8 channel;
-	__le64 start_time;
-	__le16 duration;
-} __attribute__ ((packed));
-
-struct ieee80211_measurement_request {
-	struct ieee80211_info_element ie;
-	u8 token;
-	u8 mode;
-	u8 type;
-	struct ieee80211_measurement_params params[0];
-} __attribute__ ((packed));
-
-struct ieee80211_measurement_report {
-	struct ieee80211_info_element ie;
-	u8 token;
-	u8 mode;
-	u8 type;
-	union {
-		struct ieee80211_basic_report basic[0];
-	} u;
-} __attribute__ ((packed));
-
-struct ieee80211_tpc_report {
-	u8 transmit_power;
-	u8 link_margin;
-} __attribute__ ((packed));
-
-struct ieee80211_channel_map {
-	u8 channel;
-	u8 map;
-} __attribute__ ((packed));
-
-struct ieee80211_ibss_dfs {
-	struct ieee80211_info_element ie;
-	u8 owner[ETH_ALEN];
-	u8 recovery_interval;
-	struct ieee80211_channel_map channel_map[0];
-};
-
-struct ieee80211_csa {
-	u8 mode;
-	u8 channel;
-	u8 count;
-} __attribute__ ((packed));
-
-struct ieee80211_quiet {
-	u8 count;
-	u8 period;
-	u8 duration;
-	u8 offset;
-} __attribute__ ((packed));
-
-struct ieee80211_network {
-	/* These entries are used to identify a unique network */
-	u8 bssid[ETH_ALEN];
-	u8 channel;
-	/* Ensure null-terminated for any debug msgs */
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 ssid_len;
-
-	struct ieee80211_qos_data qos_data;
-
-	/* These are network statistics */
-	struct ieee80211_rx_stats stats;
-	u16 capability;
-	u8 rates[MAX_RATES_LENGTH];
-	u8 rates_len;
-	u8 rates_ex[MAX_RATES_EX_LENGTH];
-	u8 rates_ex_len;
-	unsigned long last_scanned;
-	u8 mode;
-	u32 flags;
-	u32 last_associate;
-	u32 time_stamp[2];
-	u16 beacon_interval;
-	u16 listen_interval;
-	u16 atim_window;
-	u8 erp_value;
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	size_t wpa_ie_len;
-	u8 rsn_ie[MAX_WPA_IE_LEN];
-	size_t rsn_ie_len;
-	struct ieee80211_tim_parameters tim;
-
-	/* 802.11h info */
-
-	/* Power Constraint - mandatory if spctrm mgmt required */
-	u8 power_constraint;
-
-	/* TPC Report - mandatory if spctrm mgmt required */
-	struct ieee80211_tpc_report tpc_report;
-
-	/* IBSS DFS - mandatory if spctrm mgmt required and IBSS
-	 * NOTE: This is variable length and so must be allocated dynamically */
-	struct ieee80211_ibss_dfs *ibss_dfs;
-
-	/* Channel Switch Announcement - optional if spctrm mgmt required */
-	struct ieee80211_csa csa;
-
-	/* Quiet - optional if spctrm mgmt required */
-	struct ieee80211_quiet quiet;
-
-	struct list_head list;
-};
-
-enum ieee80211_state {
-	IEEE80211_UNINITIALIZED = 0,
-	IEEE80211_INITIALIZED,
-	IEEE80211_ASSOCIATING,
-	IEEE80211_ASSOCIATED,
-	IEEE80211_AUTHENTICATING,
-	IEEE80211_AUTHENTICATED,
-	IEEE80211_SHUTDOWN
-};
-
-#define DEFAULT_MAX_SCAN_AGE (15 * HZ)
-#define DEFAULT_FTS 2346
-
-#define CFG_IEEE80211_RESERVE_FCS (1<<0)
-#define CFG_IEEE80211_COMPUTE_FCS (1<<1)
-#define CFG_IEEE80211_RTS (1<<2)
-
-#define IEEE80211_24GHZ_MIN_CHANNEL 1
-#define IEEE80211_24GHZ_MAX_CHANNEL 14
-#define IEEE80211_24GHZ_CHANNELS (IEEE80211_24GHZ_MAX_CHANNEL - \
-				  IEEE80211_24GHZ_MIN_CHANNEL + 1)
-
-#define IEEE80211_52GHZ_MIN_CHANNEL 34
-#define IEEE80211_52GHZ_MAX_CHANNEL 165
-#define IEEE80211_52GHZ_CHANNELS (IEEE80211_52GHZ_MAX_CHANNEL - \
-				  IEEE80211_52GHZ_MIN_CHANNEL + 1)
-
-enum {
-	IEEE80211_CH_PASSIVE_ONLY = (1 << 0),
-	IEEE80211_CH_80211H_RULES = (1 << 1),
-	IEEE80211_CH_B_ONLY = (1 << 2),
-	IEEE80211_CH_NO_IBSS = (1 << 3),
-	IEEE80211_CH_UNIFORM_SPREADING = (1 << 4),
-	IEEE80211_CH_RADAR_DETECT = (1 << 5),
-	IEEE80211_CH_INVALID = (1 << 6),
-};
-
-struct ieee80211_channel {
-	u32 freq;	/* in MHz */
-	u8 channel;
-	u8 flags;
-	u8 max_power;	/* in dBm */
-};
-
-struct ieee80211_geo {
-	u8 name[4];
-	u8 bg_channels;
-	u8 a_channels;
-	struct ieee80211_channel bg[IEEE80211_24GHZ_CHANNELS];
-	struct ieee80211_channel a[IEEE80211_52GHZ_CHANNELS];
-};
-
-struct ieee80211_device {
-	struct net_device *dev;
-	struct ieee80211_security sec;
-
-	/* Bookkeeping structures */
-	struct ieee80211_stats ieee_stats;
-
-	struct ieee80211_geo geo;
-
-	/* Probe / Beacon management */
-	struct list_head network_free_list;
-	struct list_head network_list;
-	struct ieee80211_network *networks;
-	int scans;
-	int scan_age;
-
-	int iw_mode;		/* operating mode (IW_MODE_*) */
-	struct iw_spy_data spy_data;	/* iwspy support */
-
-	spinlock_t lock;
-
-	int tx_headroom;	/* Set to size of any additional room needed at front
-				 * of allocated Tx SKBs */
-	u32 config;
-
-	/* WEP and other encryption related settings at the device level */
-	int open_wep;		/* Set to 1 to allow unencrypted frames */
-
-	int reset_on_keychange;	/* Set to 1 if the HW needs to be reset on
-				 * WEP key changes */
-
-	/* If the host performs {en,de}cryption, then set to 1 */
-	int host_encrypt;
-	int host_encrypt_msdu;
-	int host_decrypt;
-	/* host performs multicast decryption */
-	int host_mc_decrypt;
-
-	/* host should strip IV and ICV from protected frames */
-	/* meaningful only when hardware decryption is being used */
-	int host_strip_iv_icv;
-
-	int host_open_frag;
-	int host_build_iv;
-	int ieee802_1x;		/* is IEEE 802.1X used */
-
-	/* WPA data */
-	int wpa_enabled;
-	int drop_unencrypted;
-	int privacy_invoked;
-	size_t wpa_ie_len;
-	u8 *wpa_ie;
-
-	struct lib80211_crypt_info crypt_info;
-
-	int bcrx_sta_key;	/* use individual keys to override default keys even
-				 * with RX of broad/multicast frames */
-
-	/* Fragmentation structures */
-	struct ieee80211_frag_entry frag_cache[IEEE80211_FRAG_CACHE_LEN];
-	unsigned int frag_next_idx;
-	u16 fts;		/* Fragmentation Threshold */
-	u16 rts;		/* RTS threshold */
-
-	/* Association info */
-	u8 bssid[ETH_ALEN];
-
-	enum ieee80211_state state;
-
-	int mode;		/* A, B, G */
-	int modulation;		/* CCK, OFDM */
-	int freq_band;		/* 2.4Ghz, 5.2Ghz, Mixed */
-	int abg_true;		/* ABG flag              */
-
-	int perfect_rssi;
-	int worst_rssi;
-
-	u16 prev_seq_ctl;	/* used to drop duplicate frames */
-
-	/* Callback functions */
-	void (*set_security) (struct net_device * dev,
-			      struct ieee80211_security * sec);
-	int (*hard_start_xmit) (struct ieee80211_txb * txb,
-				struct net_device * dev, int pri);
-	int (*reset_port) (struct net_device * dev);
-	int (*is_queue_full) (struct net_device * dev, int pri);
-
-	int (*handle_management) (struct net_device * dev,
-				  struct ieee80211_network * network, u16 type);
-	int (*is_qos_active) (struct net_device *dev, struct sk_buff *skb);
-
-	/* Typical STA methods */
-	int (*handle_auth) (struct net_device * dev,
-			    struct ieee80211_auth * auth);
-	int (*handle_deauth) (struct net_device * dev,
-			      struct ieee80211_deauth * auth);
-	int (*handle_action) (struct net_device * dev,
-			      struct ieee80211_action * action,
-			      struct ieee80211_rx_stats * stats);
-	int (*handle_disassoc) (struct net_device * dev,
-				struct ieee80211_disassoc * assoc);
-	int (*handle_beacon) (struct net_device * dev,
-			      struct ieee80211_beacon * beacon,
-			      struct ieee80211_network * network);
-	int (*handle_probe_response) (struct net_device * dev,
-				      struct ieee80211_probe_response * resp,
-				      struct ieee80211_network * network);
-	int (*handle_probe_request) (struct net_device * dev,
-				     struct ieee80211_probe_request * req,
-				     struct ieee80211_rx_stats * stats);
-	int (*handle_assoc_response) (struct net_device * dev,
-				      struct ieee80211_assoc_response * resp,
-				      struct ieee80211_network * network);
-
-	/* Typical AP methods */
-	int (*handle_assoc_request) (struct net_device * dev);
-	int (*handle_reassoc_request) (struct net_device * dev,
-				       struct ieee80211_reassoc_request * req);
-
-	/* This must be the last item so that it points to the data
-	 * allocated beyond this structure by alloc_ieee80211 */
-	u8 priv[0];
-};
-
-#define IEEE_A            (1<<0)
-#define IEEE_B            (1<<1)
-#define IEEE_G            (1<<2)
-#define IEEE_MODE_MASK    (IEEE_A|IEEE_B|IEEE_G)
-
-static inline void *ieee80211_priv(struct net_device *dev)
-{
-	return ((struct ieee80211_device *)netdev_priv(dev))->priv;
-}
-
-static inline int ieee80211_is_valid_mode(struct ieee80211_device *ieee,
-					  int mode)
-{
-	/*
-	 * It is possible for both access points and our device to support
-	 * combinations of modes, so as long as there is one valid combination
-	 * of ap/device supported modes, then return success
-	 *
-	 */
-	if ((mode & IEEE_A) &&
-	    (ieee->modulation & IEEE80211_OFDM_MODULATION) &&
-	    (ieee->freq_band & IEEE80211_52GHZ_BAND))
-		return 1;
-
-	if ((mode & IEEE_G) &&
-	    (ieee->modulation & IEEE80211_OFDM_MODULATION) &&
-	    (ieee->freq_band & IEEE80211_24GHZ_BAND))
-		return 1;
-
-	if ((mode & IEEE_B) &&
-	    (ieee->modulation & IEEE80211_CCK_MODULATION) &&
-	    (ieee->freq_band & IEEE80211_24GHZ_BAND))
-		return 1;
-
-	return 0;
-}
-
-static inline int ieee80211_get_hdrlen(u16 fc)
-{
-	int hdrlen = IEEE80211_3ADDR_LEN;
-	u16 stype = WLAN_FC_GET_STYPE(fc);
-
-	switch (WLAN_FC_GET_TYPE(fc)) {
-	case IEEE80211_FTYPE_DATA:
-		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
-			hdrlen = IEEE80211_4ADDR_LEN;
-		if (stype & IEEE80211_STYPE_QOS_DATA)
-			hdrlen += 2;
-		break;
-	case IEEE80211_FTYPE_CTL:
-		switch (WLAN_FC_GET_STYPE(fc)) {
-		case IEEE80211_STYPE_CTS:
-		case IEEE80211_STYPE_ACK:
-			hdrlen = IEEE80211_1ADDR_LEN;
-			break;
-		default:
-			hdrlen = IEEE80211_2ADDR_LEN;
-			break;
-		}
-		break;
-	}
-
-	return hdrlen;
-}
-
-static inline u8 *ieee80211_get_payload(struct ieee80211_hdr *hdr)
-{
-	switch (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control))) {
-	case IEEE80211_1ADDR_LEN:
-		return ((struct ieee80211_hdr_1addr *)hdr)->payload;
-	case IEEE80211_2ADDR_LEN:
-		return ((struct ieee80211_hdr_2addr *)hdr)->payload;
-	case IEEE80211_3ADDR_LEN:
-		return ((struct ieee80211_hdr_3addr *)hdr)->payload;
-	case IEEE80211_4ADDR_LEN:
-		return ((struct ieee80211_hdr_4addr *)hdr)->payload;
-	}
-	return NULL;
-}
-
-static inline int ieee80211_is_ofdm_rate(u8 rate)
-{
-	switch (rate & ~IEEE80211_BASIC_RATE_MASK) {
-	case IEEE80211_OFDM_RATE_6MB:
-	case IEEE80211_OFDM_RATE_9MB:
-	case IEEE80211_OFDM_RATE_12MB:
-	case IEEE80211_OFDM_RATE_18MB:
-	case IEEE80211_OFDM_RATE_24MB:
-	case IEEE80211_OFDM_RATE_36MB:
-	case IEEE80211_OFDM_RATE_48MB:
-	case IEEE80211_OFDM_RATE_54MB:
-		return 1;
-	}
-	return 0;
-}
-
-static inline int ieee80211_is_cck_rate(u8 rate)
-{
-	switch (rate & ~IEEE80211_BASIC_RATE_MASK) {
-	case IEEE80211_CCK_RATE_1MB:
-	case IEEE80211_CCK_RATE_2MB:
-	case IEEE80211_CCK_RATE_5MB:
-	case IEEE80211_CCK_RATE_11MB:
-		return 1;
-	}
-	return 0;
-}
-
-/* ieee80211.c */
-extern void free_ieee80211(struct net_device *dev);
-extern struct net_device *alloc_ieee80211(int sizeof_priv);
-extern int ieee80211_change_mtu(struct net_device *dev, int new_mtu);
-
-extern void ieee80211_networks_age(struct ieee80211_device *ieee,
-				   unsigned long age_secs);
-
-extern int ieee80211_set_encryption(struct ieee80211_device *ieee);
-
-/* ieee80211_tx.c */
-extern int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev);
-extern void ieee80211_txb_free(struct ieee80211_txb *);
-
-/* ieee80211_rx.c */
-extern void ieee80211_rx_any(struct ieee80211_device *ieee,
-		     struct sk_buff *skb, struct ieee80211_rx_stats *stats);
-extern int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
-			struct ieee80211_rx_stats *rx_stats);
-/* make sure to set stats->len */
-extern void ieee80211_rx_mgt(struct ieee80211_device *ieee,
-			     struct ieee80211_hdr_4addr *header,
-			     struct ieee80211_rx_stats *stats);
-extern void ieee80211_network_reset(struct ieee80211_network *network);
-
-/* ieee80211_geo.c */
-extern const struct ieee80211_geo *ieee80211_get_geo(struct ieee80211_device
-						     *ieee);
-extern int ieee80211_set_geo(struct ieee80211_device *ieee,
-			     const struct ieee80211_geo *geo);
-
-extern int ieee80211_is_valid_channel(struct ieee80211_device *ieee,
-				      u8 channel);
-extern int ieee80211_channel_to_index(struct ieee80211_device *ieee,
-				      u8 channel);
-extern u8 ieee80211_freq_to_channel(struct ieee80211_device *ieee, u32 freq);
-extern u8 ieee80211_get_channel_flags(struct ieee80211_device *ieee,
-				      u8 channel);
-extern const struct ieee80211_channel *ieee80211_get_channel(struct
-							     ieee80211_device
-							     *ieee, u8 channel);
-extern u32 ieee80211_channel_to_freq(struct ieee80211_device * ieee,
-				      u8 channel);
-
-/* ieee80211_wx.c */
-extern int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
-				 struct iw_request_info *info,
-				 union iwreq_data *wrqu, char *key);
-extern int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
-				   struct iw_request_info *info,
-				   union iwreq_data *wrqu, char *key);
-extern int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
-				   struct iw_request_info *info,
-				   union iwreq_data *wrqu, char *key);
-extern int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
-				      struct iw_request_info *info,
-				      union iwreq_data *wrqu, char *extra);
-extern int ieee80211_wx_get_encodeext(struct ieee80211_device *ieee,
-				      struct iw_request_info *info,
-				      union iwreq_data *wrqu, char *extra);
-
-static inline void ieee80211_increment_scans(struct ieee80211_device *ieee)
-{
-	ieee->scans++;
-}
-
-static inline int ieee80211_get_scans(struct ieee80211_device *ieee)
-{
-	return ieee->scans;
-}
-
-#endif				/* IEEE80211_H */
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index dee50ed..33bdb20 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1673,7 +1673,7 @@ static int ipw2100_start_scan(struct ipw2100_priv *priv)
 	return err;
 }
 
-static const struct ieee80211_geo ipw_geos[] = {
+static const struct libipw_geo ipw_geos[] = {
 	{			/* Restricted */
 	 "---",
 	 .bg_channels = 14,
@@ -1694,7 +1694,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 
 	/* Age scan list entries found before suspend */
 	if (priv->suspend_time) {
-		ieee80211_networks_age(priv->ieee, priv->suspend_time);
+		libipw_networks_age(priv->ieee, priv->suspend_time);
 		priv->suspend_time = 0;
 	}
 
@@ -1752,11 +1752,11 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	}
 
 	/* Initialize the geo */
-	if (ieee80211_set_geo(priv->ieee, &ipw_geos[0])) {
+	if (libipw_set_geo(priv->ieee, &ipw_geos[0])) {
 		printk(KERN_WARNING DRV_NAME "Could not set geo\n");
 		return 0;
 	}
-	priv->ieee->freq_band = IEEE80211_24GHZ_BAND;
+	priv->ieee->freq_band = LIBIPW_24GHZ_BAND;
 
 	lock = LOCK_NONE;
 	if (ipw2100_set_ordinal(priv, IPW_ORD_PERS_DB_LOCK, &lock, &ord_len)) {
@@ -1817,7 +1817,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 /* Called by register_netdev() */
 static int ipw2100_net_init(struct net_device *dev)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	return ipw2100_up(priv, 1);
 }
 
@@ -2340,8 +2340,8 @@ static u32 ipw2100_match_buf(struct ipw2100_priv *priv, u8 * in_buf,
  *
  * When packet is provided by the firmware, it contains the following:
  *
- * .  ieee80211_hdr
- * .  ieee80211_snap_hdr
+ * .  libipw_hdr
+ * .  libipw_snap_hdr
  *
  * The size of the constructed ethernet
  *
@@ -2396,7 +2396,7 @@ static void ipw2100_corruption_detected(struct ipw2100_priv *priv, int i)
 }
 
 static void isr_rx(struct ipw2100_priv *priv, int i,
-			  struct ieee80211_rx_stats *stats)
+			  struct libipw_rx_stats *stats)
 {
 	struct net_device *dev = priv->net_dev;
 	struct ipw2100_status *status = &priv->status_queue.drv[i];
@@ -2435,13 +2435,13 @@ static void isr_rx(struct ipw2100_priv *priv, int i,
 
 #ifdef IPW2100_RX_DEBUG
 	/* Make a copy of the frame so we can dump it to the logs if
-	 * ieee80211_rx fails */
+	 * libipw_rx fails */
 	skb_copy_from_linear_data(packet->skb, packet_data,
 				  min_t(u32, status->frame_size,
 					     IPW_RX_NIC_BUFFER_LENGTH));
 #endif
 
-	if (!ieee80211_rx(priv->ieee, packet->skb, stats)) {
+	if (!libipw_rx(priv->ieee, packet->skb, stats)) {
 #ifdef IPW2100_RX_DEBUG
 		IPW_DEBUG_DROP("%s: Non consumed packet:\n",
 			       dev->name);
@@ -2449,7 +2449,7 @@ static void isr_rx(struct ipw2100_priv *priv, int i,
 #endif
 		dev->stats.rx_errors++;
 
-		/* ieee80211_rx failed, so it didn't free the SKB */
+		/* libipw_rx failed, so it didn't free the SKB */
 		dev_kfree_skb_any(packet->skb);
 		packet->skb = NULL;
 	}
@@ -2470,7 +2470,7 @@ static void isr_rx(struct ipw2100_priv *priv, int i,
 #ifdef CONFIG_IPW2100_MONITOR
 
 static void isr_rx_monitor(struct ipw2100_priv *priv, int i,
-		   struct ieee80211_rx_stats *stats)
+		   struct libipw_rx_stats *stats)
 {
 	struct net_device *dev = priv->net_dev;
 	struct ipw2100_status *status = &priv->status_queue.drv[i];
@@ -2528,10 +2528,10 @@ static void isr_rx_monitor(struct ipw2100_priv *priv, int i,
 
 	skb_put(packet->skb, status->frame_size + sizeof(struct ipw_rt_hdr));
 
-	if (!ieee80211_rx(priv->ieee, packet->skb, stats)) {
+	if (!libipw_rx(priv->ieee, packet->skb, stats)) {
 		dev->stats.rx_errors++;
 
-		/* ieee80211_rx failed, so it didn't free the SKB */
+		/* libipw_rx failed, so it didn't free the SKB */
 		dev_kfree_skb_any(packet->skb);
 		packet->skb = NULL;
 	}
@@ -2615,7 +2615,7 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 	u16 frame_type;
 	u32 r, w, i, s;
 	struct ipw2100_rx *u;
-	struct ieee80211_rx_stats stats = {
+	struct libipw_rx_stats stats = {
 		.mac_time = jiffies,
 	};
 
@@ -2661,8 +2661,8 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 
 		stats.mask = 0;
 		if (stats.rssi != 0)
-			stats.mask |= IEEE80211_STATMASK_RSSI;
-		stats.freq = IEEE80211_24GHZ_BAND;
+			stats.mask |= LIBIPW_STATMASK_RSSI;
+		stats.freq = LIBIPW_24GHZ_BAND;
 
 		IPW_DEBUG_RX("%s: '%s' frame type received (%d).\n",
 			     priv->net_dev->name, frame_types[frame_type],
@@ -2686,11 +2686,11 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 				break;
 			}
 #endif
-			if (stats.len < sizeof(struct ieee80211_hdr_3addr))
+			if (stats.len < sizeof(struct libipw_hdr_3addr))
 				break;
 			switch (WLAN_FC_GET_TYPE(le16_to_cpu(u->rx_data.header.frame_ctl))) {
 			case IEEE80211_FTYPE_MGMT:
-				ieee80211_rx_mgt(priv->ieee,
+				libipw_rx_mgt(priv->ieee,
 						 &u->rx_data.header, &stats);
 				break;
 
@@ -2884,7 +2884,7 @@ static int __ipw2100_tx_process(struct ipw2100_priv *priv)
 					 tbd->buf_length, PCI_DMA_TODEVICE);
 		}
 
-		ieee80211_txb_free(packet->info.d_struct.txb);
+		libipw_txb_free(packet->info.d_struct.txb);
 		packet->info.d_struct.txb = NULL;
 
 		list_add_tail(element, &priv->tx_free_list);
@@ -3028,7 +3028,7 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 	int next = txq->next;
 	int i = 0;
 	struct ipw2100_data_header *ipw_hdr;
-	struct ieee80211_hdr_3addr *hdr;
+	struct libipw_hdr_3addr *hdr;
 
 	while (!list_empty(&priv->tx_pend_list)) {
 		/* if there isn't enough space in TBD queue, then
@@ -3062,7 +3062,7 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 		packet->index = txq->next;
 
 		ipw_hdr = packet->info.d_struct.data;
-		hdr = (struct ieee80211_hdr_3addr *)packet->info.d_struct.txb->
+		hdr = (struct libipw_hdr_3addr *)packet->info.d_struct.txb->
 		    fragments[0]->data;
 
 		if (priv->ieee->iw_mode == IW_MODE_INFRA) {
@@ -3086,7 +3086,7 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 		if (packet->info.d_struct.txb->nr_frags > 1)
 			ipw_hdr->fragment_size =
 			    packet->info.d_struct.txb->frag_size -
-			    IEEE80211_3ADDR_LEN;
+			    LIBIPW_3ADDR_LEN;
 		else
 			ipw_hdr->fragment_size = 0;
 
@@ -3119,13 +3119,13 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 				    IPW_BD_STATUS_TX_FRAME_NOT_LAST_FRAGMENT;
 
 			tbd->buf_length = packet->info.d_struct.txb->
-			    fragments[i]->len - IEEE80211_3ADDR_LEN;
+			    fragments[i]->len - LIBIPW_3ADDR_LEN;
 
 			tbd->host_addr = pci_map_single(priv->pci_dev,
 							packet->info.d_struct.
 							txb->fragments[i]->
 							data +
-							IEEE80211_3ADDR_LEN,
+							LIBIPW_3ADDR_LEN,
 							tbd->buf_length,
 							PCI_DMA_TODEVICE);
 
@@ -3330,10 +3330,10 @@ static irqreturn_t ipw2100_interrupt(int irq, void *data)
 	return IRQ_NONE;
 }
 
-static int ipw2100_tx(struct ieee80211_txb *txb, struct net_device *dev,
+static int ipw2100_tx(struct libipw_txb *txb, struct net_device *dev,
 		      int pri)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	struct list_head *element;
 	struct ipw2100_tx_packet *packet;
 	unsigned long flags;
@@ -4488,7 +4488,7 @@ static void ipw2100_tx_initialize(struct ipw2100_priv *priv)
 		/* We simply drop any SKBs that have been queued for
 		 * transmit */
 		if (priv->tx_buffers[i].info.d_struct.txb) {
-			ieee80211_txb_free(priv->tx_buffers[i].info.d_struct.
+			libipw_txb_free(priv->tx_buffers[i].info.d_struct.
 					   txb);
 			priv->tx_buffers[i].info.d_struct.txb = NULL;
 		}
@@ -4527,7 +4527,7 @@ static void ipw2100_tx_free(struct ipw2100_priv *priv)
 
 	for (i = 0; i < TX_PENDED_QUEUE_LENGTH; i++) {
 		if (priv->tx_buffers[i].info.d_struct.txb) {
-			ieee80211_txb_free(priv->tx_buffers[i].info.d_struct.
+			libipw_txb_free(priv->tx_buffers[i].info.d_struct.
 					   txb);
 			priv->tx_buffers[i].info.d_struct.txb = NULL;
 		}
@@ -5558,9 +5558,9 @@ static void ipw2100_security_work(struct work_struct *work)
 }
 
 static void shim__set_security(struct net_device *dev,
-			       struct ieee80211_security *sec)
+			       struct libipw_security *sec)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int i, force_update = 0;
 
 	mutex_lock(&priv->action_mutex);
@@ -5753,7 +5753,7 @@ static int ipw2100_adapter_setup(struct ipw2100_priv *priv)
  * method as well) to talk to the firmware */
 static int ipw2100_set_address(struct net_device *dev, void *p)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	struct sockaddr *addr = p;
 	int err = 0;
 
@@ -5781,7 +5781,7 @@ static int ipw2100_set_address(struct net_device *dev, void *p)
 
 static int ipw2100_open(struct net_device *dev)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	unsigned long flags;
 	IPW_DEBUG_INFO("dev->open\n");
 
@@ -5797,7 +5797,7 @@ static int ipw2100_open(struct net_device *dev)
 
 static int ipw2100_close(struct net_device *dev)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	unsigned long flags;
 	struct list_head *element;
 	struct ipw2100_tx_packet *packet;
@@ -5818,7 +5818,7 @@ static int ipw2100_close(struct net_device *dev)
 		list_del(element);
 		DEC_STAT(&priv->tx_pend_stat);
 
-		ieee80211_txb_free(packet->info.d_struct.txb);
+		libipw_txb_free(packet->info.d_struct.txb);
 		packet->info.d_struct.txb = NULL;
 
 		list_add_tail(element, &priv->tx_free_list);
@@ -5836,7 +5836,7 @@ static int ipw2100_close(struct net_device *dev)
  */
 static void ipw2100_tx_timeout(struct net_device *dev)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	dev->stats.tx_errors++;
 
@@ -5861,8 +5861,8 @@ static int ipw2100_wpa_enable(struct ipw2100_priv *priv, int value)
 static int ipw2100_wpa_set_auth_algs(struct ipw2100_priv *priv, int value)
 {
 
-	struct ieee80211_device *ieee = priv->ieee;
-	struct ieee80211_security sec = {
+	struct libipw_device *ieee = priv->ieee;
+	struct libipw_security sec = {
 		.flags = SEC_AUTH_MODE,
 	};
 	int ret = 0;
@@ -5907,7 +5907,7 @@ static void ipw2100_wpa_assoc_frame(struct ipw2100_priv *priv,
 static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *info)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	char fw_ver[64], ucode_ver[64];
 
 	strcpy(info->driver, DRV_NAME);
@@ -5924,7 +5924,7 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 
 static u32 ipw2100_ethtool_get_link(struct net_device *dev)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	return (priv->status & STATUS_ASSOCIATED) ? 1 : 0;
 }
 
@@ -6011,8 +6011,8 @@ static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
 static const struct net_device_ops ipw2100_netdev_ops = {
 	.ndo_open		= ipw2100_open,
 	.ndo_stop		= ipw2100_close,
-	.ndo_start_xmit		= ieee80211_xmit,
-	.ndo_change_mtu		= ieee80211_change_mtu,
+	.ndo_start_xmit		= libipw_xmit,
+	.ndo_change_mtu		= libipw_change_mtu,
 	.ndo_init		= ipw2100_net_init,
 	.ndo_tx_timeout		= ipw2100_tx_timeout,
 	.ndo_set_mac_address	= ipw2100_set_address,
@@ -6032,7 +6032,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	dev = alloc_ieee80211(sizeof(struct ipw2100_priv));
 	if (!dev)
 		return NULL;
-	priv = ieee80211_priv(dev);
+	priv = libipw_priv(dev);
 	priv->ieee = netdev_priv(dev);
 	priv->pci_dev = pci_dev;
 	priv->net_dev = dev;
@@ -6046,7 +6046,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	dev->netdev_ops = &ipw2100_netdev_ops;
 	dev->ethtool_ops = &ipw2100_ethtool_ops;
 	dev->wireless_handlers = &ipw2100_wx_handler_def;
-	priv->wireless_data.ieee80211 = priv->ieee;
+	priv->wireless_data.libipw = priv->ieee;
 	dev->wireless_data = &priv->wireless_data;
 	dev->watchdog_timeo = 3 * HZ;
 	dev->irq = 0;
@@ -6202,7 +6202,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		return err;
 	}
 
-	priv = ieee80211_priv(dev);
+	priv = libipw_priv(dev);
 
 	pci_set_master(pci_dev);
 	pci_set_drvdata(pci_dev, priv);
@@ -6629,7 +6629,7 @@ static int ipw2100_wx_get_name(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	if (!(priv->status & STATUS_ASSOCIATED))
 		strcpy(wrqu->name, "unassociated");
 	else
@@ -6643,7 +6643,7 @@ static int ipw2100_wx_set_freq(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	struct iw_freq *fwrq = &wrqu->freq;
 	int err = 0;
 
@@ -6693,7 +6693,7 @@ static int ipw2100_wx_get_freq(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	wrqu->freq.e = 0;
 
@@ -6714,7 +6714,7 @@ static int ipw2100_wx_set_mode(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	IPW_DEBUG_WX("SET Mode -> %d \n", wrqu->mode);
@@ -6757,7 +6757,7 @@ static int ipw2100_wx_get_mode(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	wrqu->mode = priv->ieee->iw_mode;
 	IPW_DEBUG_WX("GET Mode -> %d\n", wrqu->mode);
@@ -6792,7 +6792,7 @@ static int ipw2100_wx_get_range(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	struct iw_range *range = (struct iw_range *)extra;
 	u16 val;
 	int i, level;
@@ -6913,7 +6913,7 @@ static int ipw2100_wx_set_wap(struct net_device *dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	static const unsigned char any[] = {
@@ -6962,7 +6962,7 @@ static int ipw2100_wx_get_wap(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	/* If we are associated, trying to associate, or have a statically
 	 * configured BSSID then return that; otherwise return ANY */
@@ -6980,7 +6980,7 @@ static int ipw2100_wx_set_essid(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	char *essid = "";	/* ANY */
 	int length = 0;
 	int err = 0;
@@ -7035,7 +7035,7 @@ static int ipw2100_wx_get_essid(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	DECLARE_SSID_BUF(ssid);
 
 	/* If we are associated, trying to associate, or have a statically
@@ -7063,7 +7063,7 @@ static int ipw2100_wx_set_nick(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	if (wrqu->data.length > IW_ESSID_MAX_SIZE)
 		return -E2BIG;
@@ -7085,7 +7085,7 @@ static int ipw2100_wx_get_nick(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	wrqu->data.length = strlen(priv->nick);
 	memcpy(extra, priv->nick, wrqu->data.length);
@@ -7100,7 +7100,7 @@ static int ipw2100_wx_set_rate(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	u32 target_rate = wrqu->bitrate.value;
 	u32 rate;
 	int err = 0;
@@ -7140,7 +7140,7 @@ static int ipw2100_wx_get_rate(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int val;
 	unsigned int len = sizeof(val);
 	int err = 0;
@@ -7192,7 +7192,7 @@ static int ipw2100_wx_set_rts(struct net_device *dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int value, err;
 
 	/* Auto RTS not yet supported */
@@ -7231,7 +7231,7 @@ static int ipw2100_wx_get_rts(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	wrqu->rts.value = priv->rts_threshold & ~RTS_DISABLED;
 	wrqu->rts.fixed = 1;	/* no auto select */
@@ -7248,7 +7248,7 @@ static int ipw2100_wx_set_txpow(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0, value;
 	
 	if (ipw_radio_kill_sw(priv, wrqu->txpower.disabled))
@@ -7293,7 +7293,7 @@ static int ipw2100_wx_get_txpow(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	wrqu->txpower.disabled = (priv->status & STATUS_RF_KILL_MASK) ? 1 : 0;
 
@@ -7320,7 +7320,7 @@ static int ipw2100_wx_set_frag(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	if (!wrqu->frag.fixed)
 		return -EINVAL;
@@ -7350,7 +7350,7 @@ static int ipw2100_wx_get_frag(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	wrqu->frag.value = priv->frag_threshold & ~FRAG_DISABLED;
 	wrqu->frag.fixed = 0;	/* no auto select */
 	wrqu->frag.disabled = (priv->frag_threshold & FRAG_DISABLED) ? 1 : 0;
@@ -7364,7 +7364,7 @@ static int ipw2100_wx_set_retry(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	if (wrqu->retry.flags & IW_RETRY_LIFETIME || wrqu->retry.disabled)
@@ -7412,7 +7412,7 @@ static int ipw2100_wx_get_retry(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	wrqu->retry.disabled = 0;	/* can't be disabled */
 
@@ -7440,7 +7440,7 @@ static int ipw2100_wx_set_scan(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	mutex_lock(&priv->action_mutex);
@@ -7472,8 +7472,8 @@ static int ipw2100_wx_get_scan(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_scan(priv->ieee, info, wrqu, extra);
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	return libipw_wx_get_scan(priv->ieee, info, wrqu, extra);
 }
 
 /*
@@ -7487,8 +7487,8 @@ static int ipw2100_wx_set_encode(struct net_device *dev,
 	 * No check of STATUS_INITIALIZED required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_set_encode(priv->ieee, info, wrqu, key);
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	return libipw_wx_set_encode(priv->ieee, info, wrqu, key);
 }
 
 static int ipw2100_wx_get_encode(struct net_device *dev,
@@ -7499,15 +7499,15 @@ static int ipw2100_wx_get_encode(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_encode(priv->ieee, info, wrqu, key);
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	return libipw_wx_get_encode(priv->ieee, info, wrqu, key);
 }
 
 static int ipw2100_wx_set_power(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	mutex_lock(&priv->action_mutex);
@@ -7556,7 +7556,7 @@ static int ipw2100_wx_get_power(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	if (!(priv->power_mode & IPW_POWER_ENABLED))
 		wrqu->power.disabled = 1;
@@ -7580,8 +7580,8 @@ static int ipw2100_wx_set_genie(struct net_device *dev,
 				union iwreq_data *wrqu, char *extra)
 {
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 	u8 *buf;
 
 	if (!ieee->wpa_enabled)
@@ -7615,8 +7615,8 @@ static int ipw2100_wx_get_genie(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 
 	if (ieee->wpa_ie_len == 0 || ieee->wpa_ie == NULL) {
 		wrqu->data.length = 0;
@@ -7637,8 +7637,8 @@ static int ipw2100_wx_set_auth(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 	struct iw_param *param = &wrqu->param;
 	struct lib80211_crypt_data *crypt;
 	unsigned long flags;
@@ -7682,7 +7682,7 @@ static int ipw2100_wx_set_auth(struct net_device *dev,
 			 * can use this to determine if the CAP_PRIVACY_ON bit should
 			 * be set.
 			 */
-			struct ieee80211_security sec = {
+			struct libipw_security sec = {
 				.flags = SEC_ENABLED,
 				.enabled = param->value,
 			};
@@ -7730,8 +7730,8 @@ static int ipw2100_wx_get_auth(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 	struct lib80211_crypt_data *crypt;
 	struct iw_param *param = &wrqu->param;
 	int ret = 0;
@@ -7792,8 +7792,8 @@ static int ipw2100_wx_set_encodeext(struct net_device *dev,
 				    struct iw_request_info *info,
 				    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_set_encodeext(priv->ieee, info, wrqu, extra);
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	return libipw_wx_set_encodeext(priv->ieee, info, wrqu, extra);
 }
 
 /* SIOCGIWENCODEEXT */
@@ -7801,8 +7801,8 @@ static int ipw2100_wx_get_encodeext(struct net_device *dev,
 				    struct iw_request_info *info,
 				    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_encodeext(priv->ieee, info, wrqu, extra);
+	struct ipw2100_priv *priv = libipw_priv(dev);
+	return libipw_wx_get_encodeext(priv->ieee, info, wrqu, extra);
 }
 
 /* SIOCSIWMLME */
@@ -7810,7 +7810,7 @@ static int ipw2100_wx_set_mlme(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	__le16 reason;
 
@@ -7841,7 +7841,7 @@ static int ipw2100_wx_set_promisc(struct net_device *dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int *parms = (int *)extra;
 	int enable = (parms[0] > 0);
 	int err = 0;
@@ -7872,7 +7872,7 @@ static int ipw2100_wx_reset(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	if (priv->status & STATUS_INITIALIZED)
 		schedule_reset(priv);
 	return 0;
@@ -7884,7 +7884,7 @@ static int ipw2100_wx_set_powermode(struct net_device *dev,
 				    struct iw_request_info *info,
 				    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0, mode = *(int *)extra;
 
 	mutex_lock(&priv->action_mutex);
@@ -7912,7 +7912,7 @@ static int ipw2100_wx_get_powermode(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int level = IPW_POWER_LEVEL(priv->power_mode);
 	s32 timeout, period;
 
@@ -7948,7 +7948,7 @@ static int ipw2100_wx_set_preamble(struct net_device *dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err, mode = *(int *)extra;
 
 	mutex_lock(&priv->action_mutex);
@@ -7981,7 +7981,7 @@ static int ipw2100_wx_get_preamble(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	if (priv->config & CFG_LONG_PREAMBLE)
 		snprintf(wrqu->name, IFNAMSIZ, "long (1)");
@@ -7996,7 +7996,7 @@ static int ipw2100_wx_set_crc_check(struct net_device *dev,
 				    struct iw_request_info *info,
 				    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err, mode = *(int *)extra;
 
 	mutex_lock(&priv->action_mutex);
@@ -8028,7 +8028,7 @@ static int ipw2100_wx_get_crc_check(struct net_device *dev,
 	 * This can be called at any time.  No action lock required
 	 */
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 
 	if (priv->config & CFG_CRC_CHECK)
 		snprintf(wrqu->name, IFNAMSIZ, "CRC checked (1)");
@@ -8181,7 +8181,7 @@ static struct iw_statistics *ipw2100_wx_wireless_stats(struct net_device *dev)
 	int beacon_qual;
 	int quality;
 
-	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	struct iw_statistics *wstats;
 	u32 rssi, tx_retries, missed_beacons, tx_failures;
 	u32 ord_len = sizeof(u32);
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
index f183d95..af175bd 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/ipw2x00/ipw2100.h
@@ -46,7 +46,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 
-#include "ieee80211.h"
+#include "libipw.h"
 
 struct ipw2100_priv;
 struct ipw2100_tx_packet;
@@ -343,7 +343,7 @@ struct ipw2100_tx_packet {
 		struct {	/* DATA */
 			struct ipw2100_data_header *data;
 			dma_addr_t data_phys;
-			struct ieee80211_txb *txb;
+			struct libipw_txb *txb;
 		} d_struct;
 	} info;
 	int jiffy_start;
@@ -492,7 +492,7 @@ struct ipw2100_priv {
 	int stop_hang_check;	/* Set 1 when shutting down to kill hang_check */
 	int stop_rf_kill;	/* Set 1 when shutting down to kill rf_kill */
 
-	struct ieee80211_device *ieee;
+	struct libipw_device *ieee;
 	unsigned long status;
 	unsigned long config;
 	unsigned long capability;
@@ -788,7 +788,7 @@ struct ipw2100_priv {
 #define IPW_CARD_DISABLE_PHY_OFF_COMPLETE_WAIT	    100	// 100 milli
 #define IPW_PREPARE_POWER_DOWN_COMPLETE_WAIT	    100	// 100 milli
 
-#define IPW_HEADER_802_11_SIZE		 sizeof(struct ieee80211_hdr_3addr)
+#define IPW_HEADER_802_11_SIZE		 sizeof(struct libipw_hdr_3addr)
 #define IPW_MAX_80211_PAYLOAD_SIZE              2304U
 #define IPW_MAX_802_11_PAYLOAD_LENGTH		2312
 #define IPW_MAX_ACCEPTABLE_TX_FRAME_LENGTH	1536
@@ -803,13 +803,13 @@ struct ipw2100_priv {
 		IPW_802_11_FCS_LENGTH)
 
 #define IPW_802_11_PAYLOAD_OFFSET \
-        (sizeof(struct ieee80211_hdr_3addr) + \
-         sizeof(struct ieee80211_snap_hdr))
+        (sizeof(struct libipw_hdr_3addr) + \
+         sizeof(struct libipw_snap_hdr))
 
 struct ipw2100_rx {
 	union {
 		unsigned char payload[IPW_RX_NIC_BUFFER_LENGTH];
-		struct ieee80211_hdr_4addr header;
+		struct libipw_hdr_4addr header;
 		u32 status;
 		struct ipw2100_notification notification;
 		struct ipw2100_cmd_header command;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 8e18d53..3617e3c 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -111,7 +111,7 @@ static int qos_no_ack_mask = 0;
 static int burst_duration_CCK = 0;
 static int burst_duration_OFDM = 0;
 
-static struct ieee80211_qos_parameters def_qos_parameters_OFDM = {
+static struct libipw_qos_parameters def_qos_parameters_OFDM = {
 	{QOS_TX0_CW_MIN_OFDM, QOS_TX1_CW_MIN_OFDM, QOS_TX2_CW_MIN_OFDM,
 	 QOS_TX3_CW_MIN_OFDM},
 	{QOS_TX0_CW_MAX_OFDM, QOS_TX1_CW_MAX_OFDM, QOS_TX2_CW_MAX_OFDM,
@@ -122,7 +122,7 @@ static struct ieee80211_qos_parameters def_qos_parameters_OFDM = {
 	 QOS_TX2_TXOP_LIMIT_OFDM, QOS_TX3_TXOP_LIMIT_OFDM}
 };
 
-static struct ieee80211_qos_parameters def_qos_parameters_CCK = {
+static struct libipw_qos_parameters def_qos_parameters_CCK = {
 	{QOS_TX0_CW_MIN_CCK, QOS_TX1_CW_MIN_CCK, QOS_TX2_CW_MIN_CCK,
 	 QOS_TX3_CW_MIN_CCK},
 	{QOS_TX0_CW_MAX_CCK, QOS_TX1_CW_MAX_CCK, QOS_TX2_CW_MAX_CCK,
@@ -133,7 +133,7 @@ static struct ieee80211_qos_parameters def_qos_parameters_CCK = {
 	 QOS_TX3_TXOP_LIMIT_CCK}
 };
 
-static struct ieee80211_qos_parameters def_parameters_OFDM = {
+static struct libipw_qos_parameters def_parameters_OFDM = {
 	{DEF_TX0_CW_MIN_OFDM, DEF_TX1_CW_MIN_OFDM, DEF_TX2_CW_MIN_OFDM,
 	 DEF_TX3_CW_MIN_OFDM},
 	{DEF_TX0_CW_MAX_OFDM, DEF_TX1_CW_MAX_OFDM, DEF_TX2_CW_MAX_OFDM,
@@ -144,7 +144,7 @@ static struct ieee80211_qos_parameters def_parameters_OFDM = {
 	 DEF_TX2_TXOP_LIMIT_OFDM, DEF_TX3_TXOP_LIMIT_OFDM}
 };
 
-static struct ieee80211_qos_parameters def_parameters_CCK = {
+static struct libipw_qos_parameters def_parameters_CCK = {
 	{DEF_TX0_CW_MIN_CCK, DEF_TX1_CW_MIN_CCK, DEF_TX2_CW_MIN_CCK,
 	 DEF_TX3_CW_MIN_CCK},
 	{DEF_TX0_CW_MAX_CCK, DEF_TX1_CW_MAX_CCK, DEF_TX2_CW_MAX_CCK,
@@ -164,9 +164,9 @@ static int from_priority_to_tx_queue[] = {
 
 static u32 ipw_qos_get_burst_duration(struct ipw_priv *priv);
 
-static int ipw_send_qos_params_command(struct ipw_priv *priv, struct ieee80211_qos_parameters
+static int ipw_send_qos_params_command(struct ipw_priv *priv, struct libipw_qos_parameters
 				       *qos_param);
-static int ipw_send_qos_info_command(struct ipw_priv *priv, struct ieee80211_qos_information_element
+static int ipw_send_qos_info_command(struct ipw_priv *priv, struct libipw_qos_information_element
 				     *qos_param);
 #endif				/* CONFIG_IPW2200_QOS */
 
@@ -1830,7 +1830,7 @@ static ssize_t store_speed_scan(struct device *d, struct device_attribute *attr,
 			break;
 		}
 
-		if (ieee80211_is_valid_channel(priv->ieee, channel))
+		if (libipw_is_valid_channel(priv->ieee, channel))
 			priv->speed_scan[pos++] = channel;
 		else
 			IPW_WARNING("Skipping invalid channel request: %d\n",
@@ -1882,7 +1882,7 @@ static ssize_t show_channels(struct device *d,
 			     char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
-	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
+	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	int len = 0, i;
 
 	len = sprintf(&buf[len],
@@ -1892,14 +1892,14 @@ static ssize_t show_channels(struct device *d,
 	for (i = 0; i < geo->bg_channels; i++) {
 		len += sprintf(&buf[len], "%d: BSS%s%s, %s, Band %s.\n",
 			       geo->bg[i].channel,
-			       geo->bg[i].flags & IEEE80211_CH_RADAR_DETECT ?
+			       geo->bg[i].flags & LIBIPW_CH_RADAR_DETECT ?
 			       " (radar spectrum)" : "",
-			       ((geo->bg[i].flags & IEEE80211_CH_NO_IBSS) ||
-				(geo->bg[i].flags & IEEE80211_CH_RADAR_DETECT))
+			       ((geo->bg[i].flags & LIBIPW_CH_NO_IBSS) ||
+				(geo->bg[i].flags & LIBIPW_CH_RADAR_DETECT))
 			       ? "" : ", IBSS",
-			       geo->bg[i].flags & IEEE80211_CH_PASSIVE_ONLY ?
+			       geo->bg[i].flags & LIBIPW_CH_PASSIVE_ONLY ?
 			       "passive only" : "active/passive",
-			       geo->bg[i].flags & IEEE80211_CH_B_ONLY ?
+			       geo->bg[i].flags & LIBIPW_CH_B_ONLY ?
 			       "B" : "B/G");
 	}
 
@@ -1909,12 +1909,12 @@ static ssize_t show_channels(struct device *d,
 	for (i = 0; i < geo->a_channels; i++) {
 		len += sprintf(&buf[len], "%d: BSS%s%s, %s.\n",
 			       geo->a[i].channel,
-			       geo->a[i].flags & IEEE80211_CH_RADAR_DETECT ?
+			       geo->a[i].flags & LIBIPW_CH_RADAR_DETECT ?
 			       " (radar spectrum)" : "",
-			       ((geo->a[i].flags & IEEE80211_CH_NO_IBSS) ||
-				(geo->a[i].flags & IEEE80211_CH_RADAR_DETECT))
+			       ((geo->a[i].flags & LIBIPW_CH_NO_IBSS) ||
+				(geo->a[i].flags & LIBIPW_CH_RADAR_DETECT))
 			       ? "" : ", IBSS",
-			       geo->a[i].flags & IEEE80211_CH_PASSIVE_ONLY ?
+			       geo->a[i].flags & LIBIPW_CH_PASSIVE_ONLY ?
 			       "passive only" : "active/passive");
 	}
 
@@ -2429,7 +2429,7 @@ static int ipw_send_tx_power(struct ipw_priv *priv, struct ipw_tx_power *power)
 
 static int ipw_set_tx_power(struct ipw_priv *priv)
 {
-	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
+	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	struct ipw_tx_power tx_power;
 	s8 max_power;
 	int i;
@@ -2960,12 +2960,12 @@ static int ipw_fw_dma_wait(struct ipw_priv *priv)
 static void ipw_remove_current_network(struct ipw_priv *priv)
 {
 	struct list_head *element, *safe;
-	struct ieee80211_network *network = NULL;
+	struct libipw_network *network = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->ieee->lock, flags);
 	list_for_each_safe(element, safe, &priv->ieee->network_list) {
-		network = list_entry(element, struct ieee80211_network, list);
+		network = list_entry(element, struct libipw_network, list);
 		if (!memcmp(network->bssid, priv->bssid, ETH_ALEN)) {
 			list_del(element);
 			list_add_tail(&network->list,
@@ -3751,7 +3751,7 @@ static void ipw_queue_tx_free_tfd(struct ipw_priv *priv,
 				 le16_to_cpu(bd->u.data.chunk_len[i]),
 				 PCI_DMA_TODEVICE);
 		if (txq->txb[txq->q.last_used]) {
-			ieee80211_txb_free(txq->txb[txq->q.last_used]);
+			libipw_txb_free(txq->txb[txq->q.last_used]);
 			txq->txb[txq->q.last_used] = NULL;
 		}
 	}
@@ -4070,7 +4070,7 @@ static u32 ipw_get_max_rate(struct ipw_priv *priv)
 	/* If currently associated in B mode, restrict the maximum
 	 * rate match to B rates */
 	if (priv->assoc_request.ieee_mode == IPW_B_MODE)
-		mask &= IEEE80211_CCK_RATES_MASK;
+		mask &= LIBIPW_CCK_RATES_MASK;
 
 	/* TODO: Verify that the rate is supported by the current rates
 	 * list. */
@@ -4078,29 +4078,29 @@ static u32 ipw_get_max_rate(struct ipw_priv *priv)
 	while (i && !(mask & i))
 		i >>= 1;
 	switch (i) {
-	case IEEE80211_CCK_RATE_1MB_MASK:
+	case LIBIPW_CCK_RATE_1MB_MASK:
 		return 1000000;
-	case IEEE80211_CCK_RATE_2MB_MASK:
+	case LIBIPW_CCK_RATE_2MB_MASK:
 		return 2000000;
-	case IEEE80211_CCK_RATE_5MB_MASK:
+	case LIBIPW_CCK_RATE_5MB_MASK:
 		return 5500000;
-	case IEEE80211_OFDM_RATE_6MB_MASK:
+	case LIBIPW_OFDM_RATE_6MB_MASK:
 		return 6000000;
-	case IEEE80211_OFDM_RATE_9MB_MASK:
+	case LIBIPW_OFDM_RATE_9MB_MASK:
 		return 9000000;
-	case IEEE80211_CCK_RATE_11MB_MASK:
+	case LIBIPW_CCK_RATE_11MB_MASK:
 		return 11000000;
-	case IEEE80211_OFDM_RATE_12MB_MASK:
+	case LIBIPW_OFDM_RATE_12MB_MASK:
 		return 12000000;
-	case IEEE80211_OFDM_RATE_18MB_MASK:
+	case LIBIPW_OFDM_RATE_18MB_MASK:
 		return 18000000;
-	case IEEE80211_OFDM_RATE_24MB_MASK:
+	case LIBIPW_OFDM_RATE_24MB_MASK:
 		return 24000000;
-	case IEEE80211_OFDM_RATE_36MB_MASK:
+	case LIBIPW_OFDM_RATE_36MB_MASK:
 		return 36000000;
-	case IEEE80211_OFDM_RATE_48MB_MASK:
+	case LIBIPW_OFDM_RATE_48MB_MASK:
 		return 48000000;
-	case IEEE80211_OFDM_RATE_54MB_MASK:
+	case LIBIPW_OFDM_RATE_54MB_MASK:
 		return 54000000;
 	}
 
@@ -4466,11 +4466,11 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 					     == IEEE80211_STYPE_ASSOC_RESP)) {
 						if ((sizeof
 						     (struct
-						      ieee80211_assoc_response)
+						      libipw_assoc_response)
 						     <= size)
 						    && (size <= 2314)) {
 							struct
-							ieee80211_rx_stats
+							libipw_rx_stats
 							    stats = {
 								.len = size - 1,
 							};
@@ -4478,10 +4478,10 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 							IPW_DEBUG_QOS
 							    ("QoS Associate "
 							     "size %d\n", size);
-							ieee80211_rx_mgt(priv->
+							libipw_rx_mgt(priv->
 									 ieee,
 									 (struct
-									  ieee80211_hdr_4addr
+									  libipw_hdr_4addr
 									  *)
 									 &notif->u.raw, &stats);
 						}
@@ -4537,11 +4537,11 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 			case CMAS_INIT:{
 					if (priv->status & STATUS_AUTH) {
 						struct
-						    ieee80211_assoc_response
+						    libipw_assoc_response
 						*resp;
 						resp =
 						    (struct
-						     ieee80211_assoc_response
+						     libipw_assoc_response
 						     *)&notif->u.raw;
 						IPW_DEBUG(IPW_DL_NOTIF |
 							  IPW_DL_STATE |
@@ -5227,33 +5227,33 @@ static struct ipw_rx_queue *ipw_rx_queue_alloc(struct ipw_priv *priv)
 
 static int ipw_is_rate_in_mask(struct ipw_priv *priv, int ieee_mode, u8 rate)
 {
-	rate &= ~IEEE80211_BASIC_RATE_MASK;
+	rate &= ~LIBIPW_BASIC_RATE_MASK;
 	if (ieee_mode == IEEE_A) {
 		switch (rate) {
-		case IEEE80211_OFDM_RATE_6MB:
-			return priv->rates_mask & IEEE80211_OFDM_RATE_6MB_MASK ?
+		case LIBIPW_OFDM_RATE_6MB:
+			return priv->rates_mask & LIBIPW_OFDM_RATE_6MB_MASK ?
 			    1 : 0;
-		case IEEE80211_OFDM_RATE_9MB:
-			return priv->rates_mask & IEEE80211_OFDM_RATE_9MB_MASK ?
+		case LIBIPW_OFDM_RATE_9MB:
+			return priv->rates_mask & LIBIPW_OFDM_RATE_9MB_MASK ?
 			    1 : 0;
-		case IEEE80211_OFDM_RATE_12MB:
+		case LIBIPW_OFDM_RATE_12MB:
 			return priv->
-			    rates_mask & IEEE80211_OFDM_RATE_12MB_MASK ? 1 : 0;
-		case IEEE80211_OFDM_RATE_18MB:
+			    rates_mask & LIBIPW_OFDM_RATE_12MB_MASK ? 1 : 0;
+		case LIBIPW_OFDM_RATE_18MB:
 			return priv->
-			    rates_mask & IEEE80211_OFDM_RATE_18MB_MASK ? 1 : 0;
-		case IEEE80211_OFDM_RATE_24MB:
+			    rates_mask & LIBIPW_OFDM_RATE_18MB_MASK ? 1 : 0;
+		case LIBIPW_OFDM_RATE_24MB:
 			return priv->
-			    rates_mask & IEEE80211_OFDM_RATE_24MB_MASK ? 1 : 0;
-		case IEEE80211_OFDM_RATE_36MB:
+			    rates_mask & LIBIPW_OFDM_RATE_24MB_MASK ? 1 : 0;
+		case LIBIPW_OFDM_RATE_36MB:
 			return priv->
-			    rates_mask & IEEE80211_OFDM_RATE_36MB_MASK ? 1 : 0;
-		case IEEE80211_OFDM_RATE_48MB:
+			    rates_mask & LIBIPW_OFDM_RATE_36MB_MASK ? 1 : 0;
+		case LIBIPW_OFDM_RATE_48MB:
 			return priv->
-			    rates_mask & IEEE80211_OFDM_RATE_48MB_MASK ? 1 : 0;
-		case IEEE80211_OFDM_RATE_54MB:
+			    rates_mask & LIBIPW_OFDM_RATE_48MB_MASK ? 1 : 0;
+		case LIBIPW_OFDM_RATE_54MB:
 			return priv->
-			    rates_mask & IEEE80211_OFDM_RATE_54MB_MASK ? 1 : 0;
+			    rates_mask & LIBIPW_OFDM_RATE_54MB_MASK ? 1 : 0;
 		default:
 			return 0;
 		}
@@ -5261,14 +5261,14 @@ static int ipw_is_rate_in_mask(struct ipw_priv *priv, int ieee_mode, u8 rate)
 
 	/* B and G mixed */
 	switch (rate) {
-	case IEEE80211_CCK_RATE_1MB:
-		return priv->rates_mask & IEEE80211_CCK_RATE_1MB_MASK ? 1 : 0;
-	case IEEE80211_CCK_RATE_2MB:
-		return priv->rates_mask & IEEE80211_CCK_RATE_2MB_MASK ? 1 : 0;
-	case IEEE80211_CCK_RATE_5MB:
-		return priv->rates_mask & IEEE80211_CCK_RATE_5MB_MASK ? 1 : 0;
-	case IEEE80211_CCK_RATE_11MB:
-		return priv->rates_mask & IEEE80211_CCK_RATE_11MB_MASK ? 1 : 0;
+	case LIBIPW_CCK_RATE_1MB:
+		return priv->rates_mask & LIBIPW_CCK_RATE_1MB_MASK ? 1 : 0;
+	case LIBIPW_CCK_RATE_2MB:
+		return priv->rates_mask & LIBIPW_CCK_RATE_2MB_MASK ? 1 : 0;
+	case LIBIPW_CCK_RATE_5MB:
+		return priv->rates_mask & LIBIPW_CCK_RATE_5MB_MASK ? 1 : 0;
+	case LIBIPW_CCK_RATE_11MB:
+		return priv->rates_mask & LIBIPW_CCK_RATE_11MB_MASK ? 1 : 0;
 	}
 
 	/* If we are limited to B modulations, bail at this point */
@@ -5277,29 +5277,29 @@ static int ipw_is_rate_in_mask(struct ipw_priv *priv, int ieee_mode, u8 rate)
 
 	/* G */
 	switch (rate) {
-	case IEEE80211_OFDM_RATE_6MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_6MB_MASK ? 1 : 0;
-	case IEEE80211_OFDM_RATE_9MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_9MB_MASK ? 1 : 0;
-	case IEEE80211_OFDM_RATE_12MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_12MB_MASK ? 1 : 0;
-	case IEEE80211_OFDM_RATE_18MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_18MB_MASK ? 1 : 0;
-	case IEEE80211_OFDM_RATE_24MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_24MB_MASK ? 1 : 0;
-	case IEEE80211_OFDM_RATE_36MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_36MB_MASK ? 1 : 0;
-	case IEEE80211_OFDM_RATE_48MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_48MB_MASK ? 1 : 0;
-	case IEEE80211_OFDM_RATE_54MB:
-		return priv->rates_mask & IEEE80211_OFDM_RATE_54MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_6MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_6MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_9MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_9MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_12MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_12MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_18MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_18MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_24MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_24MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_36MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_36MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_48MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_48MB_MASK ? 1 : 0;
+	case LIBIPW_OFDM_RATE_54MB:
+		return priv->rates_mask & LIBIPW_OFDM_RATE_54MB_MASK ? 1 : 0;
 	}
 
 	return 0;
 }
 
 static int ipw_compatible_rates(struct ipw_priv *priv,
-				const struct ieee80211_network *network,
+				const struct libipw_network *network,
 				struct ipw_supported_rates *rates)
 {
 	int num_rates, i;
@@ -5311,7 +5311,7 @@ static int ipw_compatible_rates(struct ipw_priv *priv,
 		if (!ipw_is_rate_in_mask(priv, network->mode,
 					 network->rates[i])) {
 
-			if (network->rates[i] & IEEE80211_BASIC_RATE_MASK) {
+			if (network->rates[i] & LIBIPW_BASIC_RATE_MASK) {
 				IPW_DEBUG_SCAN("Adding masked mandatory "
 					       "rate %02X\n",
 					       network->rates[i]);
@@ -5333,7 +5333,7 @@ static int ipw_compatible_rates(struct ipw_priv *priv,
 	for (i = 0; i < num_rates; i++) {
 		if (!ipw_is_rate_in_mask(priv, network->mode,
 					 network->rates_ex[i])) {
-			if (network->rates_ex[i] & IEEE80211_BASIC_RATE_MASK) {
+			if (network->rates_ex[i] & LIBIPW_BASIC_RATE_MASK) {
 				IPW_DEBUG_SCAN("Adding masked mandatory "
 					       "rate %02X\n",
 					       network->rates_ex[i]);
@@ -5369,73 +5369,73 @@ static void ipw_copy_rates(struct ipw_supported_rates *dest,
 static void ipw_add_cck_scan_rates(struct ipw_supported_rates *rates,
 				   u8 modulation, u32 rate_mask)
 {
-	u8 basic_mask = (IEEE80211_OFDM_MODULATION == modulation) ?
-	    IEEE80211_BASIC_RATE_MASK : 0;
+	u8 basic_mask = (LIBIPW_OFDM_MODULATION == modulation) ?
+	    LIBIPW_BASIC_RATE_MASK : 0;
 
-	if (rate_mask & IEEE80211_CCK_RATE_1MB_MASK)
+	if (rate_mask & LIBIPW_CCK_RATE_1MB_MASK)
 		rates->supported_rates[rates->num_rates++] =
-		    IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
+		    LIBIPW_BASIC_RATE_MASK | LIBIPW_CCK_RATE_1MB;
 
-	if (rate_mask & IEEE80211_CCK_RATE_2MB_MASK)
+	if (rate_mask & LIBIPW_CCK_RATE_2MB_MASK)
 		rates->supported_rates[rates->num_rates++] =
-		    IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
+		    LIBIPW_BASIC_RATE_MASK | LIBIPW_CCK_RATE_2MB;
 
-	if (rate_mask & IEEE80211_CCK_RATE_5MB_MASK)
+	if (rate_mask & LIBIPW_CCK_RATE_5MB_MASK)
 		rates->supported_rates[rates->num_rates++] = basic_mask |
-		    IEEE80211_CCK_RATE_5MB;
+		    LIBIPW_CCK_RATE_5MB;
 
-	if (rate_mask & IEEE80211_CCK_RATE_11MB_MASK)
+	if (rate_mask & LIBIPW_CCK_RATE_11MB_MASK)
 		rates->supported_rates[rates->num_rates++] = basic_mask |
-		    IEEE80211_CCK_RATE_11MB;
+		    LIBIPW_CCK_RATE_11MB;
 }
 
 static void ipw_add_ofdm_scan_rates(struct ipw_supported_rates *rates,
 				    u8 modulation, u32 rate_mask)
 {
-	u8 basic_mask = (IEEE80211_OFDM_MODULATION == modulation) ?
-	    IEEE80211_BASIC_RATE_MASK : 0;
+	u8 basic_mask = (LIBIPW_OFDM_MODULATION == modulation) ?
+	    LIBIPW_BASIC_RATE_MASK : 0;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_6MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_6MB_MASK)
 		rates->supported_rates[rates->num_rates++] = basic_mask |
-		    IEEE80211_OFDM_RATE_6MB;
+		    LIBIPW_OFDM_RATE_6MB;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_9MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_9MB_MASK)
 		rates->supported_rates[rates->num_rates++] =
-		    IEEE80211_OFDM_RATE_9MB;
+		    LIBIPW_OFDM_RATE_9MB;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_12MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_12MB_MASK)
 		rates->supported_rates[rates->num_rates++] = basic_mask |
-		    IEEE80211_OFDM_RATE_12MB;
+		    LIBIPW_OFDM_RATE_12MB;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_18MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_18MB_MASK)
 		rates->supported_rates[rates->num_rates++] =
-		    IEEE80211_OFDM_RATE_18MB;
+		    LIBIPW_OFDM_RATE_18MB;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_24MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_24MB_MASK)
 		rates->supported_rates[rates->num_rates++] = basic_mask |
-		    IEEE80211_OFDM_RATE_24MB;
+		    LIBIPW_OFDM_RATE_24MB;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_36MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_36MB_MASK)
 		rates->supported_rates[rates->num_rates++] =
-		    IEEE80211_OFDM_RATE_36MB;
+		    LIBIPW_OFDM_RATE_36MB;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_48MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_48MB_MASK)
 		rates->supported_rates[rates->num_rates++] =
-		    IEEE80211_OFDM_RATE_48MB;
+		    LIBIPW_OFDM_RATE_48MB;
 
-	if (rate_mask & IEEE80211_OFDM_RATE_54MB_MASK)
+	if (rate_mask & LIBIPW_OFDM_RATE_54MB_MASK)
 		rates->supported_rates[rates->num_rates++] =
-		    IEEE80211_OFDM_RATE_54MB;
+		    LIBIPW_OFDM_RATE_54MB;
 }
 
 struct ipw_network_match {
-	struct ieee80211_network *network;
+	struct libipw_network *network;
 	struct ipw_supported_rates rates;
 };
 
 static int ipw_find_adhoc_network(struct ipw_priv *priv,
 				  struct ipw_network_match *match,
-				  struct ieee80211_network *network,
+				  struct libipw_network *network,
 				  int roaming)
 {
 	struct ipw_supported_rates rates;
@@ -5556,7 +5556,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	}
 
 	/* Filter out any incompatible freq / mode combinations */
-	if (!ieee80211_is_valid_mode(priv->ieee, network->mode)) {
+	if (!libipw_is_valid_mode(priv->ieee, network->mode)) {
 		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
 				"because of invalid frequency/mode "
 				"combination.\n",
@@ -5606,7 +5606,7 @@ static void ipw_merge_adhoc_network(struct work_struct *work)
 	DECLARE_SSID_BUF(ssid);
 	struct ipw_priv *priv =
 		container_of(work, struct ipw_priv, merge_networks);
-	struct ieee80211_network *network = NULL;
+	struct libipw_network *network = NULL;
 	struct ipw_network_match match = {
 		.network = priv->assoc_network
 	};
@@ -5648,7 +5648,7 @@ static void ipw_merge_adhoc_network(struct work_struct *work)
 
 static int ipw_best_network(struct ipw_priv *priv,
 			    struct ipw_network_match *match,
-			    struct ieee80211_network *network, int roaming)
+			    struct libipw_network *network, int roaming)
 {
 	struct ipw_supported_rates rates;
 	DECLARE_SSID_BUF(ssid);
@@ -5782,7 +5782,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	}
 
 	/* Filter out any incompatible freq / mode combinations */
-	if (!ieee80211_is_valid_mode(priv->ieee, network->mode)) {
+	if (!libipw_is_valid_mode(priv->ieee, network->mode)) {
 		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
 				"because of invalid frequency/mode "
 				"combination.\n",
@@ -5793,7 +5793,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	}
 
 	/* Filter out invalid channel in current GEO */
-	if (!ieee80211_is_valid_channel(priv->ieee, network->channel)) {
+	if (!libipw_is_valid_channel(priv->ieee, network->channel)) {
 		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
 				"because of invalid channel in current GEO\n",
 				print_ssid(ssid, network->ssid,
@@ -5839,9 +5839,9 @@ static int ipw_best_network(struct ipw_priv *priv,
 }
 
 static void ipw_adhoc_create(struct ipw_priv *priv,
-			     struct ieee80211_network *network)
+			     struct libipw_network *network)
 {
-	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
+	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	int i;
 
 	/*
@@ -5856,25 +5856,25 @@ static void ipw_adhoc_create(struct ipw_priv *priv,
 	 * FW fatal error.
 	 *
 	 */
-	switch (ieee80211_is_valid_channel(priv->ieee, priv->channel)) {
-	case IEEE80211_52GHZ_BAND:
+	switch (libipw_is_valid_channel(priv->ieee, priv->channel)) {
+	case LIBIPW_52GHZ_BAND:
 		network->mode = IEEE_A;
-		i = ieee80211_channel_to_index(priv->ieee, priv->channel);
+		i = libipw_channel_to_index(priv->ieee, priv->channel);
 		BUG_ON(i == -1);
-		if (geo->a[i].flags & IEEE80211_CH_PASSIVE_ONLY) {
+		if (geo->a[i].flags & LIBIPW_CH_PASSIVE_ONLY) {
 			IPW_WARNING("Overriding invalid channel\n");
 			priv->channel = geo->a[0].channel;
 		}
 		break;
 
-	case IEEE80211_24GHZ_BAND:
+	case LIBIPW_24GHZ_BAND:
 		if (priv->ieee->mode & IEEE_G)
 			network->mode = IEEE_G;
 		else
 			network->mode = IEEE_B;
-		i = ieee80211_channel_to_index(priv->ieee, priv->channel);
+		i = libipw_channel_to_index(priv->ieee, priv->channel);
 		BUG_ON(i == -1);
-		if (geo->bg[i].flags & IEEE80211_CH_PASSIVE_ONLY) {
+		if (geo->bg[i].flags & LIBIPW_CH_PASSIVE_ONLY) {
 			IPW_WARNING("Overriding invalid channel\n");
 			priv->channel = geo->bg[0].channel;
 		}
@@ -6110,9 +6110,9 @@ static void ipw_set_fixed_rate(struct ipw_priv *priv, int mode)
 	 * Tx rates */
 
 	switch (priv->ieee->freq_band) {
-	case IEEE80211_52GHZ_BAND:	/* A only */
+	case LIBIPW_52GHZ_BAND:	/* A only */
 		/* IEEE_A */
-		if (priv->rates_mask & ~IEEE80211_OFDM_RATES_MASK) {
+		if (priv->rates_mask & ~LIBIPW_OFDM_RATES_MASK) {
 			/* Invalid fixed rate mask */
 			IPW_DEBUG_WX
 			    ("invalid fixed rate mask in ipw_set_fixed_rate\n");
@@ -6120,13 +6120,13 @@ static void ipw_set_fixed_rate(struct ipw_priv *priv, int mode)
 			break;
 		}
 
-		new_tx_rates >>= IEEE80211_OFDM_SHIFT_MASK_A;
+		new_tx_rates >>= LIBIPW_OFDM_SHIFT_MASK_A;
 		break;
 
 	default:		/* 2.4Ghz or Mixed */
 		/* IEEE_B */
 		if (mode == IEEE_B) {
-			if (new_tx_rates & ~IEEE80211_CCK_RATES_MASK) {
+			if (new_tx_rates & ~LIBIPW_CCK_RATES_MASK) {
 				/* Invalid fixed rate mask */
 				IPW_DEBUG_WX
 				    ("invalid fixed rate mask in ipw_set_fixed_rate\n");
@@ -6136,8 +6136,8 @@ static void ipw_set_fixed_rate(struct ipw_priv *priv, int mode)
 		}
 
 		/* IEEE_G */
-		if (new_tx_rates & ~(IEEE80211_CCK_RATES_MASK |
-				    IEEE80211_OFDM_RATES_MASK)) {
+		if (new_tx_rates & ~(LIBIPW_CCK_RATES_MASK |
+				    LIBIPW_OFDM_RATES_MASK)) {
 			/* Invalid fixed rate mask */
 			IPW_DEBUG_WX
 			    ("invalid fixed rate mask in ipw_set_fixed_rate\n");
@@ -6145,19 +6145,19 @@ static void ipw_set_fixed_rate(struct ipw_priv *priv, int mode)
 			break;
 		}
 
-		if (IEEE80211_OFDM_RATE_6MB_MASK & new_tx_rates) {
-			mask |= (IEEE80211_OFDM_RATE_6MB_MASK >> 1);
-			new_tx_rates &= ~IEEE80211_OFDM_RATE_6MB_MASK;
+		if (LIBIPW_OFDM_RATE_6MB_MASK & new_tx_rates) {
+			mask |= (LIBIPW_OFDM_RATE_6MB_MASK >> 1);
+			new_tx_rates &= ~LIBIPW_OFDM_RATE_6MB_MASK;
 		}
 
-		if (IEEE80211_OFDM_RATE_9MB_MASK & new_tx_rates) {
-			mask |= (IEEE80211_OFDM_RATE_9MB_MASK >> 1);
-			new_tx_rates &= ~IEEE80211_OFDM_RATE_9MB_MASK;
+		if (LIBIPW_OFDM_RATE_9MB_MASK & new_tx_rates) {
+			mask |= (LIBIPW_OFDM_RATE_9MB_MASK >> 1);
+			new_tx_rates &= ~LIBIPW_OFDM_RATE_9MB_MASK;
 		}
 
-		if (IEEE80211_OFDM_RATE_12MB_MASK & new_tx_rates) {
-			mask |= (IEEE80211_OFDM_RATE_12MB_MASK >> 1);
-			new_tx_rates &= ~IEEE80211_OFDM_RATE_12MB_MASK;
+		if (LIBIPW_OFDM_RATE_12MB_MASK & new_tx_rates) {
+			mask |= (LIBIPW_OFDM_RATE_12MB_MASK >> 1);
+			new_tx_rates &= ~LIBIPW_OFDM_RATE_12MB_MASK;
 		}
 
 		new_tx_rates |= mask;
@@ -6190,12 +6190,12 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 				  int scan_type)
 {
 	int channel_index = 0;
-	const struct ieee80211_geo *geo;
+	const struct libipw_geo *geo;
 	int i;
 
-	geo = ieee80211_get_geo(priv->ieee);
+	geo = libipw_get_geo(priv->ieee);
 
-	if (priv->ieee->freq_band & IEEE80211_52GHZ_BAND) {
+	if (priv->ieee->freq_band & LIBIPW_52GHZ_BAND) {
 		int start = channel_index;
 		for (i = 0; i < geo->a_channels; i++) {
 			if ((priv->status & STATUS_ASSOCIATED) &&
@@ -6205,7 +6205,7 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 			scan->channels_list[channel_index] = geo->a[i].channel;
 			ipw_set_scan_type(scan, channel_index,
 					  geo->a[i].
-					  flags & IEEE80211_CH_PASSIVE_ONLY ?
+					  flags & LIBIPW_CH_PASSIVE_ONLY ?
 					  IPW_SCAN_PASSIVE_FULL_DWELL_SCAN :
 					  scan_type);
 		}
@@ -6217,11 +6217,11 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 		}
 	}
 
-	if (priv->ieee->freq_band & IEEE80211_24GHZ_BAND) {
+	if (priv->ieee->freq_band & LIBIPW_24GHZ_BAND) {
 		int start = channel_index;
 		if (priv->config & CFG_SPEED_SCAN) {
 			int index;
-			u8 channels[IEEE80211_24GHZ_CHANNELS] = {
+			u8 channels[LIBIPW_24GHZ_CHANNELS] = {
 				/* nop out the list */
 				[0] = 0
 			};
@@ -6253,11 +6253,11 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 				channel_index++;
 				scan->channels_list[channel_index] = channel;
 				index =
-				    ieee80211_channel_to_index(priv->ieee, channel);
+				    libipw_channel_to_index(priv->ieee, channel);
 				ipw_set_scan_type(scan, channel_index,
 						  geo->bg[index].
 						  flags &
-						  IEEE80211_CH_PASSIVE_ONLY ?
+						  LIBIPW_CH_PASSIVE_ONLY ?
 						  IPW_SCAN_PASSIVE_FULL_DWELL_SCAN
 						  : scan_type);
 			}
@@ -6272,7 +6272,7 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 				ipw_set_scan_type(scan, channel_index,
 						  geo->bg[i].
 						  flags &
-						  IEEE80211_CH_PASSIVE_ONLY ?
+						  LIBIPW_CH_PASSIVE_ONLY ?
 						  IPW_SCAN_PASSIVE_FULL_DWELL_SCAN
 						  : scan_type);
 			}
@@ -6339,7 +6339,7 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 	}
 
 	memset(&scan, 0, sizeof(scan));
-	scan.full_scan_index = cpu_to_le32(ieee80211_get_scans(priv->ieee));
+	scan.full_scan_index = cpu_to_le32(libipw_get_scans(priv->ieee));
 
 	if (type == IW_SCAN_TYPE_PASSIVE) {
 		IPW_DEBUG_WX("use passive scanning\n");
@@ -6370,13 +6370,13 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 		u8 channel;
 		u8 band = 0;
 
-		switch (ieee80211_is_valid_channel(priv->ieee, priv->channel)) {
-		case IEEE80211_52GHZ_BAND:
+		switch (libipw_is_valid_channel(priv->ieee, priv->channel)) {
+		case LIBIPW_52GHZ_BAND:
 			band = (u8) (IPW_A_MODE << 6) | 1;
 			channel = priv->channel;
 			break;
 
-		case IEEE80211_24GHZ_BAND:
+		case LIBIPW_24GHZ_BAND:
 			band = (u8) (IPW_B_MODE << 6) | 1;
 			channel = priv->channel;
 			break;
@@ -6497,8 +6497,8 @@ static int ipw_wpa_enable(struct ipw_priv *priv, int value)
 
 static int ipw_wpa_set_auth_algs(struct ipw_priv *priv, int value)
 {
-	struct ieee80211_device *ieee = priv->ieee;
-	struct ieee80211_security sec = {
+	struct libipw_device *ieee = priv->ieee;
+	struct libipw_security sec = {
 		.flags = SEC_AUTH_MODE,
 	};
 	int ret = 0;
@@ -6548,8 +6548,8 @@ static int ipw_wx_set_genie(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 	u8 *buf;
 	int err = 0;
 
@@ -6584,8 +6584,8 @@ static int ipw_wx_get_genie(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 	int err = 0;
 
 	if (ieee->wpa_ie_len == 0 || ieee->wpa_ie == NULL) {
@@ -6627,8 +6627,8 @@ static int ipw_wx_set_auth(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 	struct iw_param *param = &wrqu->param;
 	struct lib80211_crypt_data *crypt;
 	unsigned long flags;
@@ -6679,7 +6679,7 @@ static int ipw_wx_set_auth(struct net_device *dev,
 			 * can use this to determine if the CAP_PRIVACY_ON bit should
 			 * be set.
 			 */
-			struct ieee80211_security sec = {
+			struct libipw_security sec = {
 				.flags = SEC_ENABLED,
 				.enabled = param->value,
 			};
@@ -6727,8 +6727,8 @@ static int ipw_wx_get_auth(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee = priv->ieee;
+	struct ipw_priv *priv = libipw_priv(dev);
+	struct libipw_device *ieee = priv->ieee;
 	struct lib80211_crypt_data *crypt;
 	struct iw_param *param = &wrqu->param;
 	int ret = 0;
@@ -6786,7 +6786,7 @@ static int ipw_wx_set_encodeext(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 
 	if (hwcrypto) {
@@ -6808,7 +6808,7 @@ static int ipw_wx_set_encodeext(struct net_device *dev,
 		}
 	}
 
-	return ieee80211_wx_set_encodeext(priv->ieee, info, wrqu, extra);
+	return libipw_wx_set_encodeext(priv->ieee, info, wrqu, extra);
 }
 
 /* SIOCGIWENCODEEXT */
@@ -6816,8 +6816,8 @@ static int ipw_wx_get_encodeext(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_encodeext(priv->ieee, info, wrqu, extra);
+	struct ipw_priv *priv = libipw_priv(dev);
+	return libipw_wx_get_encodeext(priv->ieee, info, wrqu, extra);
 }
 
 /* SIOCSIWMLME */
@@ -6825,7 +6825,7 @@ static int ipw_wx_set_mlme(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	__le16 reason;
 
@@ -6875,9 +6875,9 @@ static u8 ipw_qos_current_mode(struct ipw_priv * priv)
 */
 static int ipw_qos_handle_probe_response(struct ipw_priv *priv,
 					 int active_network,
-					 struct ieee80211_network *network)
+					 struct libipw_network *network)
 {
-	u32 size = sizeof(struct ieee80211_qos_parameters);
+	u32 size = sizeof(struct libipw_qos_parameters);
 
 	if (network->capability & WLAN_CAPABILITY_IBSS)
 		network->qos_data.active = network->qos_data.supported;
@@ -6935,12 +6935,12 @@ static int ipw_qos_handle_probe_response(struct ipw_priv *priv,
 * IPW_CMD_QOS_PARAMETERS and IPW_CMD_WME_INFO
 */
 static int ipw_qos_activate(struct ipw_priv *priv,
-			    struct ieee80211_qos_data *qos_network_data)
+			    struct libipw_qos_data *qos_network_data)
 {
 	int err;
-	struct ieee80211_qos_parameters qos_parameters[QOS_QOS_SETS];
-	struct ieee80211_qos_parameters *active_one = NULL;
-	u32 size = sizeof(struct ieee80211_qos_parameters);
+	struct libipw_qos_parameters qos_parameters[QOS_QOS_SETS];
+	struct libipw_qos_parameters *active_one = NULL;
+	u32 size = sizeof(struct libipw_qos_parameters);
 	u32 burst_duration;
 	int i;
 	u8 type;
@@ -7001,7 +7001,7 @@ static int ipw_qos_activate(struct ipw_priv *priv,
 
 	IPW_DEBUG_QOS("QoS sending IPW_CMD_QOS_PARAMETERS\n");
 	err = ipw_send_qos_params_command(priv,
-					  (struct ieee80211_qos_parameters *)
+					  (struct libipw_qos_parameters *)
 					  &(qos_parameters[0]));
 	if (err)
 		IPW_DEBUG_QOS("QoS IPW_CMD_QOS_PARAMETERS failed\n");
@@ -7015,13 +7015,13 @@ static int ipw_qos_activate(struct ipw_priv *priv,
 static int ipw_qos_set_info_element(struct ipw_priv *priv)
 {
 	int ret = 0;
-	struct ieee80211_qos_information_element qos_info;
+	struct libipw_qos_information_element qos_info;
 
 	if (priv == NULL)
 		return -1;
 
 	qos_info.elementID = QOS_ELEMENT_ID;
-	qos_info.length = sizeof(struct ieee80211_qos_information_element) - 2;
+	qos_info.length = sizeof(struct libipw_qos_information_element) - 2;
 
 	qos_info.version = QOS_VERSION_1;
 	qos_info.ac_info = 0;
@@ -7041,11 +7041,11 @@ static int ipw_qos_set_info_element(struct ipw_priv *priv)
 * Set the QoS parameter with the association request structure
 */
 static int ipw_qos_association(struct ipw_priv *priv,
-			       struct ieee80211_network *network)
+			       struct libipw_network *network)
 {
 	int err = 0;
-	struct ieee80211_qos_data *qos_data = NULL;
-	struct ieee80211_qos_data ibss_data = {
+	struct libipw_qos_data *qos_data = NULL;
+	struct libipw_qos_data ibss_data = {
 		.supported = 1,
 		.active = 1,
 	};
@@ -7087,11 +7087,11 @@ static int ipw_qos_association(struct ipw_priv *priv,
 * setting
 */
 static int ipw_qos_association_resp(struct ipw_priv *priv,
-				    struct ieee80211_network *network)
+				    struct libipw_network *network)
 {
 	int ret = 0;
 	unsigned long flags;
-	u32 size = sizeof(struct ieee80211_qos_parameters);
+	u32 size = sizeof(struct libipw_qos_parameters);
 	int set_qos_param = 0;
 
 	if ((priv == NULL) || (network == NULL) ||
@@ -7107,7 +7107,7 @@ static int ipw_qos_association_resp(struct ipw_priv *priv,
 	spin_lock_irqsave(&priv->ieee->lock, flags);
 	if (network->flags & NETWORK_HAS_QOS_PARAMETERS) {
 		memcpy(&priv->assoc_network->qos_data, &network->qos_data,
-		       sizeof(struct ieee80211_qos_data));
+		       sizeof(struct libipw_qos_data));
 		priv->assoc_network->qos_data.active = 1;
 		if ((network->qos_data.old_param_count !=
 		     network->qos_data.param_count)) {
@@ -7143,7 +7143,7 @@ static u32 ipw_qos_get_burst_duration(struct ipw_priv *priv)
 	if ((priv == NULL))
 		return 0;
 
-	if (!(priv->ieee->modulation & IEEE80211_OFDM_MODULATION))
+	if (!(priv->ieee->modulation & LIBIPW_OFDM_MODULATION))
 		ret = priv->qos_data.burst_duration_CCK;
 	else
 		ret = priv->qos_data.burst_duration_OFDM;
@@ -7195,8 +7195,8 @@ static int ipw_get_tx_queue_number(struct ipw_priv *priv, u16 priority)
 static int ipw_is_qos_active(struct net_device *dev,
 			     struct sk_buff *skb)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_qos_data *qos_data = NULL;
+	struct ipw_priv *priv = libipw_priv(dev);
+	struct libipw_qos_data *qos_data = NULL;
 	int active, supported;
 	u8 *daddr = skb->data + ETH_ALEN;
 	int unicast = !is_multicast_ether_addr(daddr);
@@ -7260,10 +7260,10 @@ static void ipw_bg_qos_activate(struct work_struct *work)
 }
 
 static int ipw_handle_probe_response(struct net_device *dev,
-				     struct ieee80211_probe_response *resp,
-				     struct ieee80211_network *network)
+				     struct libipw_probe_response *resp,
+				     struct libipw_network *network)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int active_network = ((priv->status & STATUS_ASSOCIATED) &&
 			      (network == priv->assoc_network));
 
@@ -7273,10 +7273,10 @@ static int ipw_handle_probe_response(struct net_device *dev,
 }
 
 static int ipw_handle_beacon(struct net_device *dev,
-			     struct ieee80211_beacon *resp,
-			     struct ieee80211_network *network)
+			     struct libipw_beacon *resp,
+			     struct libipw_network *network)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int active_network = ((priv->status & STATUS_ASSOCIATED) &&
 			      (network == priv->assoc_network));
 
@@ -7286,22 +7286,22 @@ static int ipw_handle_beacon(struct net_device *dev,
 }
 
 static int ipw_handle_assoc_response(struct net_device *dev,
-				     struct ieee80211_assoc_response *resp,
-				     struct ieee80211_network *network)
+				     struct libipw_assoc_response *resp,
+				     struct libipw_network *network)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	ipw_qos_association_resp(priv, network);
 	return 0;
 }
 
-static int ipw_send_qos_params_command(struct ipw_priv *priv, struct ieee80211_qos_parameters
+static int ipw_send_qos_params_command(struct ipw_priv *priv, struct libipw_qos_parameters
 				       *qos_param)
 {
 	return ipw_send_cmd_pdu(priv, IPW_CMD_QOS_PARAMETERS,
 				sizeof(*qos_param) * 3, qos_param);
 }
 
-static int ipw_send_qos_info_command(struct ipw_priv *priv, struct ieee80211_qos_information_element
+static int ipw_send_qos_info_command(struct ipw_priv *priv, struct libipw_qos_information_element
 				     *qos_param)
 {
 	return ipw_send_cmd_pdu(priv, IPW_CMD_WME_INFO, sizeof(*qos_param),
@@ -7311,7 +7311,7 @@ static int ipw_send_qos_info_command(struct ipw_priv *priv, struct ieee80211_qos
 #endif				/* CONFIG_IPW2200_QOS */
 
 static int ipw_associate_network(struct ipw_priv *priv,
-				 struct ieee80211_network *network,
+				 struct libipw_network *network,
 				 struct ipw_supported_rates *rates, int roaming)
 {
 	int err;
@@ -7493,7 +7493,7 @@ static int ipw_associate_network(struct ipw_priv *priv,
 static void ipw_roam(void *data)
 {
 	struct ipw_priv *priv = data;
-	struct ieee80211_network *network = NULL;
+	struct libipw_network *network = NULL;
 	struct ipw_network_match match = {
 		.network = priv->assoc_network
 	};
@@ -7568,7 +7568,7 @@ static int ipw_associate(void *data)
 {
 	struct ipw_priv *priv = data;
 
-	struct ieee80211_network *network = NULL;
+	struct libipw_network *network = NULL;
 	struct ipw_network_match match = {
 		.network = NULL
 	};
@@ -7622,8 +7622,8 @@ static int ipw_associate(void *data)
 	    priv->config & CFG_STATIC_CHANNEL) {
 		/* Use oldest network if the free list is empty */
 		if (list_empty(&priv->ieee->network_free_list)) {
-			struct ieee80211_network *oldest = NULL;
-			struct ieee80211_network *target;
+			struct libipw_network *oldest = NULL;
+			struct libipw_network *target;
 
 			list_for_each_entry(target, &priv->ieee->network_list, list) {
 				if ((oldest == NULL) ||
@@ -7644,7 +7644,7 @@ static int ipw_associate(void *data)
 		}
 
 		element = priv->ieee->network_free_list.next;
-		network = list_entry(element, struct ieee80211_network, list);
+		network = list_entry(element, struct libipw_network, list);
 		ipw_adhoc_create(priv, network);
 		rates = &priv->rates;
 		list_del(element);
@@ -7700,18 +7700,18 @@ static void ipw_rebuild_decrypted_skb(struct ipw_priv *priv,
 	switch (priv->ieee->sec.level) {
 	case SEC_LEVEL_3:
 		/* Remove CCMP HDR */
-		memmove(skb->data + IEEE80211_3ADDR_LEN,
-			skb->data + IEEE80211_3ADDR_LEN + 8,
-			skb->len - IEEE80211_3ADDR_LEN - 8);
+		memmove(skb->data + LIBIPW_3ADDR_LEN,
+			skb->data + LIBIPW_3ADDR_LEN + 8,
+			skb->len - LIBIPW_3ADDR_LEN - 8);
 		skb_trim(skb, skb->len - 16);	/* CCMP_HDR_LEN + CCMP_MIC_LEN */
 		break;
 	case SEC_LEVEL_2:
 		break;
 	case SEC_LEVEL_1:
 		/* Remove IV */
-		memmove(skb->data + IEEE80211_3ADDR_LEN,
-			skb->data + IEEE80211_3ADDR_LEN + 4,
-			skb->len - IEEE80211_3ADDR_LEN - 4);
+		memmove(skb->data + LIBIPW_3ADDR_LEN,
+			skb->data + LIBIPW_3ADDR_LEN + 4,
+			skb->len - LIBIPW_3ADDR_LEN - 4);
 		skb_trim(skb, skb->len - 8);	/* IV + ICV */
 		break;
 	case SEC_LEVEL_0:
@@ -7725,10 +7725,10 @@ static void ipw_rebuild_decrypted_skb(struct ipw_priv *priv,
 
 static void ipw_handle_data_packet(struct ipw_priv *priv,
 				   struct ipw_rx_mem_buffer *rxb,
-				   struct ieee80211_rx_stats *stats)
+				   struct libipw_rx_stats *stats)
 {
 	struct net_device *dev = priv->net_dev;
-	struct ieee80211_hdr_4addr *hdr;
+	struct libipw_hdr_4addr *hdr;
 	struct ipw_rx_packet *pkt = (struct ipw_rx_packet *)rxb->skb->data;
 
 	/* We received data from the HW, so stop the watchdog */
@@ -7758,15 +7758,15 @@ static void ipw_handle_data_packet(struct ipw_priv *priv,
 	IPW_DEBUG_RX("Rx packet of %d bytes.\n", rxb->skb->len);
 
 	/* HW decrypt will not clear the WEP bit, MIC, PN, etc. */
-	hdr = (struct ieee80211_hdr_4addr *)rxb->skb->data;
+	hdr = (struct libipw_hdr_4addr *)rxb->skb->data;
 	if (priv->ieee->iw_mode != IW_MODE_MONITOR &&
 	    (is_multicast_ether_addr(hdr->addr1) ?
 	     !priv->ieee->host_mc_decrypt : !priv->ieee->host_decrypt))
 		ipw_rebuild_decrypted_skb(priv, rxb->skb);
 
-	if (!ieee80211_rx(priv->ieee, rxb->skb, stats))
+	if (!libipw_rx(priv->ieee, rxb->skb, stats))
 		dev->stats.rx_errors++;
-	else {			/* ieee80211_rx succeeded, so it now owns the SKB */
+	else {			/* libipw_rx succeeded, so it now owns the SKB */
 		rxb->skb = NULL;
 		__ipw_led_activity_on(priv);
 	}
@@ -7775,7 +7775,7 @@ static void ipw_handle_data_packet(struct ipw_priv *priv,
 #ifdef CONFIG_IPW2200_RADIOTAP
 static void ipw_handle_data_packet_monitor(struct ipw_priv *priv,
 					   struct ipw_rx_mem_buffer *rxb,
-					   struct ieee80211_rx_stats *stats)
+					   struct libipw_rx_stats *stats)
 {
 	struct net_device *dev = priv->net_dev;
 	struct ipw_rx_packet *pkt = (struct ipw_rx_packet *)rxb->skb->data;
@@ -7921,9 +7921,9 @@ static void ipw_handle_data_packet_monitor(struct ipw_priv *priv,
 
 	IPW_DEBUG_RX("Rx packet of %d bytes.\n", rxb->skb->len);
 
-	if (!ieee80211_rx(priv->ieee, rxb->skb, stats))
+	if (!libipw_rx(priv->ieee, rxb->skb, stats))
 		dev->stats.rx_errors++;
-	else {			/* ieee80211_rx succeeded, so it now owns the SKB */
+	else {			/* libipw_rx succeeded, so it now owns the SKB */
 		rxb->skb = NULL;
 		/* no LED during capture */
 	}
@@ -7931,28 +7931,28 @@ static void ipw_handle_data_packet_monitor(struct ipw_priv *priv,
 #endif
 
 #ifdef CONFIG_IPW2200_PROMISCUOUS
-#define ieee80211_is_probe_response(fc) \
+#define libipw_is_probe_response(fc) \
    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT && \
     (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP )
 
-#define ieee80211_is_management(fc) \
+#define libipw_is_management(fc) \
    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
 
-#define ieee80211_is_control(fc) \
+#define libipw_is_control(fc) \
    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL)
 
-#define ieee80211_is_data(fc) \
+#define libipw_is_data(fc) \
    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
 
-#define ieee80211_is_assoc_request(fc) \
+#define libipw_is_assoc_request(fc) \
    ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ)
 
-#define ieee80211_is_reassoc_request(fc) \
+#define libipw_is_reassoc_request(fc) \
    ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
 
 static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 				      struct ipw_rx_mem_buffer *rxb,
-				      struct ieee80211_rx_stats *stats)
+				      struct libipw_rx_stats *stats)
 {
 	struct net_device *dev = priv->prom_net_dev;
 	struct ipw_rx_packet *pkt = (struct ipw_rx_packet *)rxb->skb->data;
@@ -8002,17 +8002,17 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 	}
 
 	hdr = (void *)rxb->skb->data + IPW_RX_FRAME_SIZE;
-	if (ieee80211_is_management(le16_to_cpu(hdr->frame_control))) {
+	if (libipw_is_management(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_MGMT)
 			return;
 		if (filter & IPW_PROM_MGMT_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_control(le16_to_cpu(hdr->frame_control))) {
+	} else if (libipw_is_control(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_CTL)
 			return;
 		if (filter & IPW_PROM_CTL_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_data(le16_to_cpu(hdr->frame_control))) {
+	} else if (libipw_is_data(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_DATA)
 			return;
 		if (filter & IPW_PROM_DATA_HEADER_ONLY)
@@ -8030,7 +8030,7 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 	ipw_rt = (void *)skb->data;
 
 	if (hdr_only)
-		len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+		len = libipw_get_hdrlen(le16_to_cpu(hdr->frame_control));
 
 	memcpy(ipw_rt->payload, hdr, len);
 
@@ -8127,7 +8127,7 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 
 	IPW_DEBUG_RX("Rx packet of %d bytes.\n", skb->len);
 
-	if (!ieee80211_rx(priv->prom_priv->ieee, skb, stats)) {
+	if (!libipw_rx(priv->prom_priv->ieee, skb, stats)) {
 		dev->stats.rx_errors++;
 		dev_kfree_skb_any(skb);
 	}
@@ -8135,7 +8135,7 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 #endif
 
 static int is_network_packet(struct ipw_priv *priv,
-				    struct ieee80211_hdr_4addr *header)
+				    struct libipw_hdr_4addr *header)
 {
 	/* Filter incoming packets to determine if they are targetted toward
 	 * this network, discarding packets coming from ourselves */
@@ -8173,7 +8173,7 @@ static int is_network_packet(struct ipw_priv *priv,
 #define IPW_PACKET_RETRY_TIME HZ
 
 static  int is_duplicate_packet(struct ipw_priv *priv,
-				      struct ieee80211_hdr_4addr *header)
+				      struct libipw_hdr_4addr *header)
 {
 	u16 sc = le16_to_cpu(header->seq_ctl);
 	u16 seq = WLAN_GET_SEQ_SEQ(sc);
@@ -8247,14 +8247,14 @@ static  int is_duplicate_packet(struct ipw_priv *priv,
 
 static void ipw_handle_mgmt_packet(struct ipw_priv *priv,
 				   struct ipw_rx_mem_buffer *rxb,
-				   struct ieee80211_rx_stats *stats)
+				   struct libipw_rx_stats *stats)
 {
 	struct sk_buff *skb = rxb->skb;
 	struct ipw_rx_packet *pkt = (struct ipw_rx_packet *)skb->data;
-	struct ieee80211_hdr_4addr *header = (struct ieee80211_hdr_4addr *)
+	struct libipw_hdr_4addr *header = (struct libipw_hdr_4addr *)
 	    (skb->data + IPW_RX_FRAME_SIZE);
 
-	ieee80211_rx_mgt(priv->ieee, header, stats);
+	libipw_rx_mgt(priv->ieee, header, stats);
 
 	if (priv->ieee->iw_mode == IW_MODE_ADHOC &&
 	    ((WLAN_FC_GET_STYPE(le16_to_cpu(header->frame_ctl)) ==
@@ -8276,12 +8276,12 @@ static void ipw_handle_mgmt_packet(struct ipw_priv *priv,
 		/* Advance past the ipw packet header to the 802.11 frame */
 		skb_pull(skb, IPW_RX_FRAME_SIZE);
 
-		/* Push the ieee80211_rx_stats before the 802.11 frame */
+		/* Push the libipw_rx_stats before the 802.11 frame */
 		memcpy(skb_push(skb, sizeof(*stats)), stats, sizeof(*stats));
 
 		skb->dev = priv->ieee->dev;
 
-		/* Point raw at the ieee80211_stats */
+		/* Point raw at the libipw_stats */
 		skb_reset_mac_header(skb);
 
 		skb->pkt_type = PACKET_OTHERHOST;
@@ -8301,7 +8301,7 @@ static void ipw_rx(struct ipw_priv *priv)
 {
 	struct ipw_rx_mem_buffer *rxb;
 	struct ipw_rx_packet *pkt;
-	struct ieee80211_hdr_4addr *header;
+	struct libipw_hdr_4addr *header;
 	u32 r, w, i;
 	u8 network_packet;
 	u8 fill_rx = 0;
@@ -8332,7 +8332,7 @@ static void ipw_rx(struct ipw_priv *priv)
 
 		switch (pkt->header.message_type) {
 		case RX_FRAME_TYPE:	/* 802.11 frame */  {
-				struct ieee80211_rx_stats stats = {
+				struct libipw_rx_stats stats = {
 					.rssi = pkt->u.frame.rssi_dbm -
 					    IPW_RSSI_TO_DBM,
 					.signal =
@@ -8347,19 +8347,19 @@ static void ipw_rx(struct ipw_priv *priv)
 					.freq =
 					    (pkt->u.frame.
 					     control & (1 << 0)) ?
-					    IEEE80211_24GHZ_BAND :
-					    IEEE80211_52GHZ_BAND,
+					    LIBIPW_24GHZ_BAND :
+					    LIBIPW_52GHZ_BAND,
 					.len = le16_to_cpu(pkt->u.frame.length),
 				};
 
 				if (stats.rssi != 0)
-					stats.mask |= IEEE80211_STATMASK_RSSI;
+					stats.mask |= LIBIPW_STATMASK_RSSI;
 				if (stats.signal != 0)
-					stats.mask |= IEEE80211_STATMASK_SIGNAL;
+					stats.mask |= LIBIPW_STATMASK_SIGNAL;
 				if (stats.noise != 0)
-					stats.mask |= IEEE80211_STATMASK_NOISE;
+					stats.mask |= LIBIPW_STATMASK_NOISE;
 				if (stats.rate != 0)
-					stats.mask |= IEEE80211_STATMASK_RATE;
+					stats.mask |= LIBIPW_STATMASK_RATE;
 
 				priv->rx_packets++;
 
@@ -8384,7 +8384,7 @@ static void ipw_rx(struct ipw_priv *priv)
 #endif
 
 				header =
-				    (struct ieee80211_hdr_4addr *)(rxb->skb->
+				    (struct libipw_hdr_4addr *)(rxb->skb->
 								   data +
 								   IPW_RX_FRAME_SIZE);
 				/* TODO: Check Ad-Hoc dest/source and make sure
@@ -8407,7 +8407,7 @@ static void ipw_rx(struct ipw_priv *priv)
 					     le16_to_cpu(pkt->u.frame.length));
 
 				if (le16_to_cpu(pkt->u.frame.length) <
-				    ieee80211_get_hdrlen(le16_to_cpu(
+				    libipw_get_hdrlen(le16_to_cpu(
 						    header->frame_ctl))) {
 					IPW_DEBUG_DROP
 					    ("Received packet is too small. "
@@ -8592,9 +8592,9 @@ static int ipw_sw_reset(struct ipw_priv *priv, int option)
 			       ": Detected Intel PRO/Wireless 2915ABG Network "
 			       "Connection\n");
 		priv->ieee->abg_true = 1;
-		band = IEEE80211_52GHZ_BAND | IEEE80211_24GHZ_BAND;
-		modulation = IEEE80211_OFDM_MODULATION |
-		    IEEE80211_CCK_MODULATION;
+		band = LIBIPW_52GHZ_BAND | LIBIPW_24GHZ_BAND;
+		modulation = LIBIPW_OFDM_MODULATION |
+		    LIBIPW_CCK_MODULATION;
 		priv->adapter = IPW_2915ABG;
 		priv->ieee->mode = IEEE_A | IEEE_G | IEEE_B;
 	} else {
@@ -8604,9 +8604,9 @@ static int ipw_sw_reset(struct ipw_priv *priv, int option)
 			       "Connection\n");
 
 		priv->ieee->abg_true = 0;
-		band = IEEE80211_24GHZ_BAND;
-		modulation = IEEE80211_OFDM_MODULATION |
-		    IEEE80211_CCK_MODULATION;
+		band = LIBIPW_24GHZ_BAND;
+		modulation = LIBIPW_OFDM_MODULATION |
+		    LIBIPW_CCK_MODULATION;
 		priv->adapter = IPW_2200BG;
 		priv->ieee->mode = IEEE_G | IEEE_B;
 	}
@@ -8614,7 +8614,7 @@ static int ipw_sw_reset(struct ipw_priv *priv, int option)
 	priv->ieee->freq_band = band;
 	priv->ieee->modulation = modulation;
 
-	priv->rates_mask = IEEE80211_DEFAULT_RATES_MASK;
+	priv->rates_mask = LIBIPW_DEFAULT_RATES_MASK;
 
 	priv->disassociate_threshold = IPW_MB_DISASSOCIATE_THRESHOLD_DEFAULT;
 	priv->roaming_threshold = IPW_MB_ROAMING_THRESHOLD_DEFAULT;
@@ -8644,7 +8644,7 @@ static int ipw_wx_get_name(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	if (priv->status & STATUS_RF_KILL_MASK)
 		strcpy(wrqu->name, "radio off");
@@ -8714,8 +8714,8 @@ static int ipw_wx_set_freq(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
+	struct ipw_priv *priv = libipw_priv(dev);
+	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	struct iw_freq *fwrq = &wrqu->freq;
 	int ret = 0, i;
 	u8 channel, flags;
@@ -8730,23 +8730,23 @@ static int ipw_wx_set_freq(struct net_device *dev,
 	}
 	/* if setting by freq convert to channel */
 	if (fwrq->e == 1) {
-		channel = ieee80211_freq_to_channel(priv->ieee, fwrq->m);
+		channel = libipw_freq_to_channel(priv->ieee, fwrq->m);
 		if (channel == 0)
 			return -EINVAL;
 	} else
 		channel = fwrq->m;
 
-	if (!(band = ieee80211_is_valid_channel(priv->ieee, channel)))
+	if (!(band = libipw_is_valid_channel(priv->ieee, channel)))
 		return -EINVAL;
 
 	if (priv->ieee->iw_mode == IW_MODE_ADHOC) {
-		i = ieee80211_channel_to_index(priv->ieee, channel);
+		i = libipw_channel_to_index(priv->ieee, channel);
 		if (i == -1)
 			return -EINVAL;
 
-		flags = (band == IEEE80211_24GHZ_BAND) ?
+		flags = (band == LIBIPW_24GHZ_BAND) ?
 		    geo->bg[i].flags : geo->a[i].flags;
-		if (flags & IEEE80211_CH_PASSIVE_ONLY) {
+		if (flags & LIBIPW_CH_PASSIVE_ONLY) {
 			IPW_DEBUG_WX("Invalid Ad-Hoc channel for 802.11a\n");
 			return -EINVAL;
 		}
@@ -8763,7 +8763,7 @@ static int ipw_wx_get_freq(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 
 	wrqu->freq.e = 0;
 
@@ -8774,16 +8774,16 @@ static int ipw_wx_get_freq(struct net_device *dev,
 	    priv->status & (STATUS_ASSOCIATING | STATUS_ASSOCIATED)) {
 		int i;
 
-		i = ieee80211_channel_to_index(priv->ieee, priv->channel);
+		i = libipw_channel_to_index(priv->ieee, priv->channel);
 		BUG_ON(i == -1);
 		wrqu->freq.e = 1;
 
-		switch (ieee80211_is_valid_channel(priv->ieee, priv->channel)) {
-		case IEEE80211_52GHZ_BAND:
+		switch (libipw_is_valid_channel(priv->ieee, priv->channel)) {
+		case LIBIPW_52GHZ_BAND:
 			wrqu->freq.m = priv->ieee->geo.a[i].freq * 100000;
 			break;
 
-		case IEEE80211_24GHZ_BAND:
+		case LIBIPW_24GHZ_BAND:
 			wrqu->freq.m = priv->ieee->geo.bg[i].freq * 100000;
 			break;
 
@@ -8802,7 +8802,7 @@ static int ipw_wx_set_mode(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	IPW_DEBUG_WX("Set MODE: %d\n", wrqu->mode);
@@ -8854,7 +8854,7 @@ static int ipw_wx_get_mode(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	wrqu->mode = priv->ieee->iw_mode;
 	IPW_DEBUG_WX("Get MODE -> %d\n", wrqu->mode);
@@ -8883,9 +8883,9 @@ static int ipw_wx_get_range(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	struct iw_range *range = (struct iw_range *)extra;
-	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
+	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	int i = 0, j;
 
 	wrqu->data.length = sizeof(*range);
@@ -8929,7 +8929,7 @@ static int ipw_wx_get_range(struct net_device *dev,
 	if (priv->ieee->mode & (IEEE_B | IEEE_G)) {
 		for (j = 0; j < geo->bg_channels && i < IW_MAX_FREQUENCIES; j++) {
 			if ((priv->ieee->iw_mode == IW_MODE_ADHOC) &&
-			    (geo->bg[j].flags & IEEE80211_CH_PASSIVE_ONLY))
+			    (geo->bg[j].flags & LIBIPW_CH_PASSIVE_ONLY))
 				continue;
 
 			range->freq[i].i = geo->bg[j].channel;
@@ -8942,7 +8942,7 @@ static int ipw_wx_get_range(struct net_device *dev,
 	if (priv->ieee->mode & IEEE_A) {
 		for (j = 0; j < geo->a_channels && i < IW_MAX_FREQUENCIES; j++) {
 			if ((priv->ieee->iw_mode == IW_MODE_ADHOC) &&
-			    (geo->a[j].flags & IEEE80211_CH_PASSIVE_ONLY))
+			    (geo->a[j].flags & LIBIPW_CH_PASSIVE_ONLY))
 				continue;
 
 			range->freq[i].i = geo->a[j].channel;
@@ -8977,7 +8977,7 @@ static int ipw_wx_set_wap(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 
 	static const unsigned char any[] = {
 		0xff, 0xff, 0xff, 0xff, 0xff, 0xff
@@ -9026,7 +9026,7 @@ static int ipw_wx_get_wap(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 
 	/* If we are associated, trying to associate, or have a statically
 	 * configured BSSID then return that; otherwise return ANY */
@@ -9048,7 +9048,7 @@ static int ipw_wx_set_essid(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
         int length;
 	DECLARE_SSID_BUF(ssid);
 
@@ -9094,7 +9094,7 @@ static int ipw_wx_get_essid(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	DECLARE_SSID_BUF(ssid);
 
 	/* If we are associated, trying to associate, or have a statically
@@ -9120,7 +9120,7 @@ static int ipw_wx_set_nick(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 
 	IPW_DEBUG_WX("Setting nick to '%s'\n", extra);
 	if (wrqu->data.length > IW_ESSID_MAX_SIZE)
@@ -9139,7 +9139,7 @@ static int ipw_wx_get_nick(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	IPW_DEBUG_WX("Getting nick\n");
 	mutex_lock(&priv->mutex);
 	wrqu->data.length = strlen(priv->nick);
@@ -9153,7 +9153,7 @@ static int ipw_wx_set_sens(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	IPW_DEBUG_WX("Setting roaming threshold to %d\n", wrqu->sens.value);
@@ -9183,7 +9183,7 @@ static int ipw_wx_get_sens(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	wrqu->sens.fixed = 1;
 	wrqu->sens.value = priv->roaming_threshold;
@@ -9200,7 +9200,7 @@ static int ipw_wx_set_rate(struct net_device *dev,
 			   union iwreq_data *wrqu, char *extra)
 {
 	/* TODO: We should use semaphores or locks for access to priv */
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	u32 target_rate = wrqu->bitrate.value;
 	u32 fixed, mask;
 
@@ -9210,7 +9210,7 @@ static int ipw_wx_set_rate(struct net_device *dev,
 
 	if (target_rate == -1) {
 		fixed = 0;
-		mask = IEEE80211_DEFAULT_RATES_MASK;
+		mask = LIBIPW_DEFAULT_RATES_MASK;
 		/* Now we should reassociate */
 		goto apply;
 	}
@@ -9219,62 +9219,62 @@ static int ipw_wx_set_rate(struct net_device *dev,
 	fixed = wrqu->bitrate.fixed;
 
 	if (target_rate == 1000000 || !fixed)
-		mask |= IEEE80211_CCK_RATE_1MB_MASK;
+		mask |= LIBIPW_CCK_RATE_1MB_MASK;
 	if (target_rate == 1000000)
 		goto apply;
 
 	if (target_rate == 2000000 || !fixed)
-		mask |= IEEE80211_CCK_RATE_2MB_MASK;
+		mask |= LIBIPW_CCK_RATE_2MB_MASK;
 	if (target_rate == 2000000)
 		goto apply;
 
 	if (target_rate == 5500000 || !fixed)
-		mask |= IEEE80211_CCK_RATE_5MB_MASK;
+		mask |= LIBIPW_CCK_RATE_5MB_MASK;
 	if (target_rate == 5500000)
 		goto apply;
 
 	if (target_rate == 6000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_6MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_6MB_MASK;
 	if (target_rate == 6000000)
 		goto apply;
 
 	if (target_rate == 9000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_9MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_9MB_MASK;
 	if (target_rate == 9000000)
 		goto apply;
 
 	if (target_rate == 11000000 || !fixed)
-		mask |= IEEE80211_CCK_RATE_11MB_MASK;
+		mask |= LIBIPW_CCK_RATE_11MB_MASK;
 	if (target_rate == 11000000)
 		goto apply;
 
 	if (target_rate == 12000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_12MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_12MB_MASK;
 	if (target_rate == 12000000)
 		goto apply;
 
 	if (target_rate == 18000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_18MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_18MB_MASK;
 	if (target_rate == 18000000)
 		goto apply;
 
 	if (target_rate == 24000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_24MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_24MB_MASK;
 	if (target_rate == 24000000)
 		goto apply;
 
 	if (target_rate == 36000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_36MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_36MB_MASK;
 	if (target_rate == 36000000)
 		goto apply;
 
 	if (target_rate == 48000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_48MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_48MB_MASK;
 	if (target_rate == 48000000)
 		goto apply;
 
 	if (target_rate == 54000000 || !fixed)
-		mask |= IEEE80211_OFDM_RATE_54MB_MASK;
+		mask |= LIBIPW_OFDM_RATE_54MB_MASK;
 	if (target_rate == 54000000)
 		goto apply;
 
@@ -9285,7 +9285,7 @@ static int ipw_wx_set_rate(struct net_device *dev,
 	IPW_DEBUG_WX("Setting rate mask to 0x%08X [%s]\n",
 		     mask, fixed ? "fixed" : "sub-rates");
 	mutex_lock(&priv->mutex);
-	if (mask == IEEE80211_DEFAULT_RATES_MASK) {
+	if (mask == LIBIPW_DEFAULT_RATES_MASK) {
 		priv->config &= ~CFG_FIXED_RATE;
 		ipw_set_fixed_rate(priv, priv->ieee->mode);
 	} else
@@ -9312,7 +9312,7 @@ static int ipw_wx_get_rate(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	wrqu->bitrate.value = priv->last_rate;
 	wrqu->bitrate.fixed = (priv->config & CFG_FIXED_RATE) ? 1 : 0;
@@ -9325,7 +9325,7 @@ static int ipw_wx_set_rts(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	if (wrqu->rts.disabled || !wrqu->rts.fixed)
 		priv->rts_threshold = DEFAULT_RTS_THRESHOLD;
@@ -9348,7 +9348,7 @@ static int ipw_wx_get_rts(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	wrqu->rts.value = priv->rts_threshold;
 	wrqu->rts.fixed = 0;	/* no auto select */
@@ -9362,7 +9362,7 @@ static int ipw_wx_set_txpow(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int err = 0;
 
 	mutex_lock(&priv->mutex);
@@ -9396,7 +9396,7 @@ static int ipw_wx_get_txpow(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	wrqu->power.value = priv->tx_power;
 	wrqu->power.fixed = 1;
@@ -9414,7 +9414,7 @@ static int ipw_wx_set_frag(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	if (wrqu->frag.disabled || !wrqu->frag.fixed)
 		priv->ieee->fts = DEFAULT_FTS;
@@ -9438,7 +9438,7 @@ static int ipw_wx_get_frag(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	wrqu->frag.value = priv->ieee->fts;
 	wrqu->frag.fixed = 0;	/* no auto select */
@@ -9453,7 +9453,7 @@ static int ipw_wx_set_retry(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 
 	if (wrqu->retry.flags & IW_RETRY_LIFETIME || wrqu->retry.disabled)
 		return -EINVAL;
@@ -9486,7 +9486,7 @@ static int ipw_wx_get_retry(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 
 	mutex_lock(&priv->mutex);
 	wrqu->retry.disabled = 0;
@@ -9517,7 +9517,7 @@ static int ipw_wx_set_scan(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 	struct delayed_work *work = NULL;
 
@@ -9553,20 +9553,20 @@ static int ipw_wx_get_scan(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_scan(priv->ieee, info, wrqu, extra);
+	struct ipw_priv *priv = libipw_priv(dev);
+	return libipw_wx_get_scan(priv->ieee, info, wrqu, extra);
 }
 
 static int ipw_wx_set_encode(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *key)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int ret;
 	u32 cap = priv->capability;
 
 	mutex_lock(&priv->mutex);
-	ret = ieee80211_wx_set_encode(priv->ieee, info, wrqu, key);
+	ret = libipw_wx_set_encode(priv->ieee, info, wrqu, key);
 
 	/* In IBSS mode, we need to notify the firmware to update
 	 * the beacon info after we changed the capability. */
@@ -9583,15 +9583,15 @@ static int ipw_wx_get_encode(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *key)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_encode(priv->ieee, info, wrqu, key);
+	struct ipw_priv *priv = libipw_priv(dev);
+	return libipw_wx_get_encode(priv->ieee, info, wrqu, key);
 }
 
 static int ipw_wx_set_power(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int err;
 	mutex_lock(&priv->mutex);
 	if (wrqu->power.disabled) {
@@ -9642,7 +9642,7 @@ static int ipw_wx_get_power(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	if (!(priv->power_mode & IPW_POWER_ENABLED))
 		wrqu->power.disabled = 1;
@@ -9659,7 +9659,7 @@ static int ipw_wx_set_powermode(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int mode = *(int *)extra;
 	int err;
 
@@ -9685,7 +9685,7 @@ static int ipw_wx_get_powermode(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int level = IPW_POWER_LEVEL(priv->power_mode);
 	char *p = extra;
 
@@ -9717,7 +9717,7 @@ static int ipw_wx_set_wireless_mode(struct net_device *dev,
 				    struct iw_request_info *info,
 				    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int mode = *(int *)extra;
 	u8 band = 0, modulation = 0;
 
@@ -9729,8 +9729,8 @@ static int ipw_wx_set_wireless_mode(struct net_device *dev,
 	if (priv->adapter == IPW_2915ABG) {
 		priv->ieee->abg_true = 1;
 		if (mode & IEEE_A) {
-			band |= IEEE80211_52GHZ_BAND;
-			modulation |= IEEE80211_OFDM_MODULATION;
+			band |= LIBIPW_52GHZ_BAND;
+			modulation |= LIBIPW_OFDM_MODULATION;
 		} else
 			priv->ieee->abg_true = 0;
 	} else {
@@ -9745,14 +9745,14 @@ static int ipw_wx_set_wireless_mode(struct net_device *dev,
 	}
 
 	if (mode & IEEE_B) {
-		band |= IEEE80211_24GHZ_BAND;
-		modulation |= IEEE80211_CCK_MODULATION;
+		band |= LIBIPW_24GHZ_BAND;
+		modulation |= LIBIPW_CCK_MODULATION;
 	} else
 		priv->ieee->abg_true = 0;
 
 	if (mode & IEEE_G) {
-		band |= IEEE80211_24GHZ_BAND;
-		modulation |= IEEE80211_OFDM_MODULATION;
+		band |= LIBIPW_24GHZ_BAND;
+		modulation |= LIBIPW_OFDM_MODULATION;
 	} else
 		priv->ieee->abg_true = 0;
 
@@ -9782,7 +9782,7 @@ static int ipw_wx_get_wireless_mode(struct net_device *dev,
 				    struct iw_request_info *info,
 				    union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	switch (priv->ieee->mode) {
 	case IEEE_A:
@@ -9823,7 +9823,7 @@ static int ipw_wx_set_preamble(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int mode = *(int *)extra;
 	mutex_lock(&priv->mutex);
 	/* Switching from SHORT -> LONG requires a disassociation */
@@ -9856,7 +9856,7 @@ static int ipw_wx_get_preamble(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 	if (priv->config & CFG_PREAMBLE_LONG)
 		snprintf(wrqu->name, IFNAMSIZ, "long (1)");
@@ -9871,7 +9871,7 @@ static int ipw_wx_set_monitor(struct net_device *dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int *parms = (int *)extra;
 	int enable = (parms[0] > 0);
 	mutex_lock(&priv->mutex);
@@ -9905,7 +9905,7 @@ static int ipw_wx_reset(struct net_device *dev,
 			struct iw_request_info *info,
 			union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	IPW_DEBUG_WX("RESET\n");
 	queue_work(priv->workqueue, &priv->adapter_restart);
 	return 0;
@@ -9915,7 +9915,7 @@ static int ipw_wx_sw_reset(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	union iwreq_data wrqu_sec = {
 		.encoding = {
 			     .flags = IW_ENCODE_DISABLED,
@@ -9938,7 +9938,7 @@ static int ipw_wx_sw_reset(struct net_device *dev,
 	ipw_radio_kill_sw(priv, priv->status & STATUS_RF_KILL_SW);
 
 	mutex_unlock(&priv->mutex);
-	ieee80211_wx_set_encode(priv->ieee, info, &wrqu_sec, NULL);
+	libipw_wx_set_encode(priv->ieee, info, &wrqu_sec, NULL);
 	mutex_lock(&priv->mutex);
 
 	if (!(priv->status & STATUS_RF_KILL_MASK)) {
@@ -10083,7 +10083,7 @@ static struct iw_handler_def ipw_wx_handler_def = {
  */
 static struct iw_statistics *ipw_get_wireless_stats(struct net_device *dev)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	struct iw_statistics *wstats;
 
 	wstats = &priv->wstats;
@@ -10164,13 +10164,13 @@ static int ipw_net_stop(struct net_device *dev)
 todo:
 
 modify to send one tfd per fragment instead of using chunking.  otherwise
-we need to heavily modify the ieee80211_skb_to_txb.
+we need to heavily modify the libipw_skb_to_txb.
 */
 
-static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
+static int ipw_tx_skb(struct ipw_priv *priv, struct libipw_txb *txb,
 			     int pri)
 {
-	struct ieee80211_hdr_3addrqos *hdr = (struct ieee80211_hdr_3addrqos *)
+	struct libipw_hdr_3addrqos *hdr = (struct libipw_hdr_3addrqos *)
 	    txb->fragments[0]->data;
 	int i = 0;
 	struct tfd_frame *tfd;
@@ -10187,7 +10187,7 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 	if (!(priv->status & STATUS_ASSOCIATED))
 		goto drop;
 
-	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
+	hdr_len = libipw_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 	switch (priv->ieee->iw_mode) {
 	case IW_MODE_ADHOC:
 		unicast = !is_multicast_ether_addr(hdr->addr1);
@@ -10356,13 +10356,13 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 
       drop:
 	IPW_DEBUG_DROP("Silently dropping Tx packet.\n");
-	ieee80211_txb_free(txb);
+	libipw_txb_free(txb);
 	return NETDEV_TX_OK;
 }
 
 static int ipw_net_is_queue_full(struct net_device *dev, int pri)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 #ifdef CONFIG_IPW2200_QOS
 	int tx_id = ipw_get_tx_queue_number(priv, pri);
 	struct clx2_tx_queue *txq = &priv->txq[tx_id];
@@ -10378,9 +10378,9 @@ static int ipw_net_is_queue_full(struct net_device *dev, int pri)
 
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
-				      struct ieee80211_txb *txb)
+				      struct libipw_txb *txb)
 {
-	struct ieee80211_rx_stats dummystats;
+	struct libipw_rx_stats dummystats;
 	struct ieee80211_hdr *hdr;
 	u8 n;
 	u16 filter = priv->prom_priv->filter;
@@ -10393,17 +10393,17 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 
 	/* Filtering of fragment chains is done agains the first fragment */
 	hdr = (void *)txb->fragments[0]->data;
-	if (ieee80211_is_management(le16_to_cpu(hdr->frame_control))) {
+	if (libipw_is_management(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_MGMT)
 			return;
 		if (filter & IPW_PROM_MGMT_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_control(le16_to_cpu(hdr->frame_control))) {
+	} else if (libipw_is_control(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_CTL)
 			return;
 		if (filter & IPW_PROM_CTL_HEADER_ONLY)
 			hdr_only = 1;
-	} else if (ieee80211_is_data(le16_to_cpu(hdr->frame_control))) {
+	} else if (libipw_is_data(le16_to_cpu(hdr->frame_control))) {
 		if (filter & IPW_PROM_NO_DATA)
 			return;
 		if (filter & IPW_PROM_DATA_HEADER_ONLY)
@@ -10418,7 +10418,7 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 
 		if (hdr_only) {
 			hdr = (void *)src->data;
-			len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+			len = libipw_get_hdrlen(le16_to_cpu(hdr->frame_control));
 		} else
 			len = src->len;
 
@@ -10452,16 +10452,16 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 
 		skb_copy_from_linear_data(src, skb_put(dst, len), len);
 
-		if (!ieee80211_rx(priv->prom_priv->ieee, dst, &dummystats))
+		if (!libipw_rx(priv->prom_priv->ieee, dst, &dummystats))
 			dev_kfree_skb_any(dst);
 	}
 }
 #endif
 
-static int ipw_net_hard_start_xmit(struct ieee80211_txb *txb,
+static int ipw_net_hard_start_xmit(struct libipw_txb *txb,
 				   struct net_device *dev, int pri)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	unsigned long flags;
 	int ret;
 
@@ -10488,7 +10488,7 @@ static void ipw_net_set_multicast_list(struct net_device *dev)
 
 static int ipw_net_set_mac_address(struct net_device *dev, void *p)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	struct sockaddr *addr = p;
 
 	if (!is_valid_ether_addr(addr->sa_data))
@@ -10506,7 +10506,7 @@ static int ipw_net_set_mac_address(struct net_device *dev, void *p)
 static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 				    struct ethtool_drvinfo *info)
 {
-	struct ipw_priv *p = ieee80211_priv(dev);
+	struct ipw_priv *p = libipw_priv(dev);
 	char vers[64];
 	char date[32];
 	u32 len;
@@ -10527,7 +10527,7 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 
 static u32 ipw_ethtool_get_link(struct net_device *dev)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	return (priv->status & STATUS_ASSOCIATED) != 0;
 }
 
@@ -10539,7 +10539,7 @@ static int ipw_ethtool_get_eeprom_len(struct net_device *dev)
 static int ipw_ethtool_get_eeprom(struct net_device *dev,
 				  struct ethtool_eeprom *eeprom, u8 * bytes)
 {
-	struct ipw_priv *p = ieee80211_priv(dev);
+	struct ipw_priv *p = libipw_priv(dev);
 
 	if (eeprom->offset + eeprom->len > IPW_EEPROM_IMAGE_SIZE)
 		return -EINVAL;
@@ -10552,7 +10552,7 @@ static int ipw_ethtool_get_eeprom(struct net_device *dev,
 static int ipw_ethtool_set_eeprom(struct net_device *dev,
 				  struct ethtool_eeprom *eeprom, u8 * bytes)
 {
-	struct ipw_priv *p = ieee80211_priv(dev);
+	struct ipw_priv *p = libipw_priv(dev);
 	int i;
 
 	if (eeprom->offset + eeprom->len > IPW_EEPROM_IMAGE_SIZE)
@@ -10768,9 +10768,9 @@ static int __devinit ipw_setup_deferred_work(struct ipw_priv *priv)
 }
 
 static void shim__set_security(struct net_device *dev,
-			       struct ieee80211_security *sec)
+			       struct libipw_security *sec)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	int i;
 	for (i = 0; i < 4; i++) {
 		if (sec->flags & (1 << i)) {
@@ -10855,21 +10855,21 @@ static int init_supported_rates(struct ipw_priv *priv,
 	memset(rates, 0, sizeof(*rates));
 	/* configure supported rates */
 	switch (priv->ieee->freq_band) {
-	case IEEE80211_52GHZ_BAND:
+	case LIBIPW_52GHZ_BAND:
 		rates->ieee_mode = IPW_A_MODE;
 		rates->purpose = IPW_RATE_CAPABILITIES;
-		ipw_add_ofdm_scan_rates(rates, IEEE80211_CCK_MODULATION,
-					IEEE80211_OFDM_DEFAULT_RATES_MASK);
+		ipw_add_ofdm_scan_rates(rates, LIBIPW_CCK_MODULATION,
+					LIBIPW_OFDM_DEFAULT_RATES_MASK);
 		break;
 
 	default:		/* Mixed or 2.4Ghz */
 		rates->ieee_mode = IPW_G_MODE;
 		rates->purpose = IPW_RATE_CAPABILITIES;
-		ipw_add_cck_scan_rates(rates, IEEE80211_CCK_MODULATION,
-				       IEEE80211_CCK_DEFAULT_RATES_MASK);
-		if (priv->ieee->modulation & IEEE80211_OFDM_MODULATION) {
-			ipw_add_ofdm_scan_rates(rates, IEEE80211_CCK_MODULATION,
-						IEEE80211_OFDM_DEFAULT_RATES_MASK);
+		ipw_add_cck_scan_rates(rates, LIBIPW_CCK_MODULATION,
+				       LIBIPW_CCK_DEFAULT_RATES_MASK);
+		if (priv->ieee->modulation & LIBIPW_OFDM_MODULATION) {
+			ipw_add_ofdm_scan_rates(rates, LIBIPW_CCK_MODULATION,
+						LIBIPW_OFDM_DEFAULT_RATES_MASK);
 		}
 		break;
 	}
@@ -10975,7 +10975,7 @@ static int ipw_config(struct ipw_priv *priv)
  * table.
  *
  */
-static const struct ieee80211_geo ipw_geos[] = {
+static const struct libipw_geo ipw_geos[] = {
 	{			/* Restricted */
 	 "---",
 	 .bg_channels = 11,
@@ -10997,10 +10997,10 @@ static const struct ieee80211_geo ipw_geos[] = {
 	       {5200, 40},
 	       {5220, 44},
 	       {5240, 48},
-	       {5260, 52, IEEE80211_CH_PASSIVE_ONLY},
-	       {5280, 56, IEEE80211_CH_PASSIVE_ONLY},
-	       {5300, 60, IEEE80211_CH_PASSIVE_ONLY},
-	       {5320, 64, IEEE80211_CH_PASSIVE_ONLY}},
+	       {5260, 52, LIBIPW_CH_PASSIVE_ONLY},
+	       {5280, 56, LIBIPW_CH_PASSIVE_ONLY},
+	       {5300, 60, LIBIPW_CH_PASSIVE_ONLY},
+	       {5320, 64, LIBIPW_CH_PASSIVE_ONLY}},
 	 },
 
 	{			/* Rest of World */
@@ -11025,10 +11025,10 @@ static const struct ieee80211_geo ipw_geos[] = {
 	       {5200, 40},
 	       {5220, 44},
 	       {5240, 48},
-	       {5260, 52, IEEE80211_CH_PASSIVE_ONLY},
-	       {5280, 56, IEEE80211_CH_PASSIVE_ONLY},
-	       {5300, 60, IEEE80211_CH_PASSIVE_ONLY},
-	       {5320, 64, IEEE80211_CH_PASSIVE_ONLY},
+	       {5260, 52, LIBIPW_CH_PASSIVE_ONLY},
+	       {5280, 56, LIBIPW_CH_PASSIVE_ONLY},
+	       {5300, 60, LIBIPW_CH_PASSIVE_ONLY},
+	       {5320, 64, LIBIPW_CH_PASSIVE_ONLY},
 	       {5745, 149},
 	       {5765, 153},
 	       {5785, 157},
@@ -11048,15 +11048,15 @@ static const struct ieee80211_geo ipw_geos[] = {
 	       {5200, 40},
 	       {5220, 44},
 	       {5240, 48},
-	       {5260, 52, IEEE80211_CH_PASSIVE_ONLY},
-	       {5280, 56, IEEE80211_CH_PASSIVE_ONLY},
-	       {5300, 60, IEEE80211_CH_PASSIVE_ONLY},
-	       {5320, 64, IEEE80211_CH_PASSIVE_ONLY},
-	       {5745, 149, IEEE80211_CH_PASSIVE_ONLY},
-	       {5765, 153, IEEE80211_CH_PASSIVE_ONLY},
-	       {5785, 157, IEEE80211_CH_PASSIVE_ONLY},
-	       {5805, 161, IEEE80211_CH_PASSIVE_ONLY},
-	       {5825, 165, IEEE80211_CH_PASSIVE_ONLY}},
+	       {5260, 52, LIBIPW_CH_PASSIVE_ONLY},
+	       {5280, 56, LIBIPW_CH_PASSIVE_ONLY},
+	       {5300, 60, LIBIPW_CH_PASSIVE_ONLY},
+	       {5320, 64, LIBIPW_CH_PASSIVE_ONLY},
+	       {5745, 149, LIBIPW_CH_PASSIVE_ONLY},
+	       {5765, 153, LIBIPW_CH_PASSIVE_ONLY},
+	       {5785, 157, LIBIPW_CH_PASSIVE_ONLY},
+	       {5805, 161, LIBIPW_CH_PASSIVE_ONLY},
+	       {5825, 165, LIBIPW_CH_PASSIVE_ONLY}},
 	 },
 
 	{			/* Custom Japan */
@@ -11093,21 +11093,21 @@ static const struct ieee80211_geo ipw_geos[] = {
 	       {5200, 40},
 	       {5220, 44},
 	       {5240, 48},
-	       {5260, 52, IEEE80211_CH_PASSIVE_ONLY},
-	       {5280, 56, IEEE80211_CH_PASSIVE_ONLY},
-	       {5300, 60, IEEE80211_CH_PASSIVE_ONLY},
-	       {5320, 64, IEEE80211_CH_PASSIVE_ONLY},
-	       {5500, 100, IEEE80211_CH_PASSIVE_ONLY},
-	       {5520, 104, IEEE80211_CH_PASSIVE_ONLY},
-	       {5540, 108, IEEE80211_CH_PASSIVE_ONLY},
-	       {5560, 112, IEEE80211_CH_PASSIVE_ONLY},
-	       {5580, 116, IEEE80211_CH_PASSIVE_ONLY},
-	       {5600, 120, IEEE80211_CH_PASSIVE_ONLY},
-	       {5620, 124, IEEE80211_CH_PASSIVE_ONLY},
-	       {5640, 128, IEEE80211_CH_PASSIVE_ONLY},
-	       {5660, 132, IEEE80211_CH_PASSIVE_ONLY},
-	       {5680, 136, IEEE80211_CH_PASSIVE_ONLY},
-	       {5700, 140, IEEE80211_CH_PASSIVE_ONLY}},
+	       {5260, 52, LIBIPW_CH_PASSIVE_ONLY},
+	       {5280, 56, LIBIPW_CH_PASSIVE_ONLY},
+	       {5300, 60, LIBIPW_CH_PASSIVE_ONLY},
+	       {5320, 64, LIBIPW_CH_PASSIVE_ONLY},
+	       {5500, 100, LIBIPW_CH_PASSIVE_ONLY},
+	       {5520, 104, LIBIPW_CH_PASSIVE_ONLY},
+	       {5540, 108, LIBIPW_CH_PASSIVE_ONLY},
+	       {5560, 112, LIBIPW_CH_PASSIVE_ONLY},
+	       {5580, 116, LIBIPW_CH_PASSIVE_ONLY},
+	       {5600, 120, LIBIPW_CH_PASSIVE_ONLY},
+	       {5620, 124, LIBIPW_CH_PASSIVE_ONLY},
+	       {5640, 128, LIBIPW_CH_PASSIVE_ONLY},
+	       {5660, 132, LIBIPW_CH_PASSIVE_ONLY},
+	       {5680, 136, LIBIPW_CH_PASSIVE_ONLY},
+	       {5700, 140, LIBIPW_CH_PASSIVE_ONLY}},
 	 },
 
 	{			/* Custom Japan */
@@ -11117,7 +11117,7 @@ static const struct ieee80211_geo ipw_geos[] = {
 		{2427, 4}, {2432, 5}, {2437, 6},
 		{2442, 7}, {2447, 8}, {2452, 9},
 		{2457, 10}, {2462, 11}, {2467, 12},
-		{2472, 13}, {2484, 14, IEEE80211_CH_B_ONLY}},
+		{2472, 13}, {2484, 14, LIBIPW_CH_B_ONLY}},
 	 .a_channels = 4,
 	 .a = {{5170, 34}, {5190, 38},
 	       {5210, 42}, {5230, 46}},
@@ -11130,8 +11130,8 @@ static const struct ieee80211_geo ipw_geos[] = {
 		{2427, 4}, {2432, 5}, {2437, 6},
 		{2442, 7}, {2447, 8}, {2452, 9},
 		{2457, 10}, {2462, 11}, {2467, 12},
-		{2472, 13}, {2484, 14, IEEE80211_CH_B_ONLY |
-			     IEEE80211_CH_PASSIVE_ONLY}},
+		{2472, 13}, {2484, 14, LIBIPW_CH_B_ONLY |
+			     LIBIPW_CH_PASSIVE_ONLY}},
 	 },
 
 	{			/* High Band */
@@ -11141,8 +11141,8 @@ static const struct ieee80211_geo ipw_geos[] = {
 		{2427, 4}, {2432, 5}, {2437, 6},
 		{2442, 7}, {2447, 8}, {2452, 9},
 		{2457, 10}, {2462, 11},
-		{2467, 12, IEEE80211_CH_PASSIVE_ONLY},
-		{2472, 13, IEEE80211_CH_PASSIVE_ONLY}},
+		{2467, 12, LIBIPW_CH_PASSIVE_ONLY},
+		{2472, 13, LIBIPW_CH_PASSIVE_ONLY}},
 	 .a_channels = 4,
 	 .a = {{5745, 149}, {5765, 153},
 	       {5785, 157}, {5805, 161}},
@@ -11168,33 +11168,33 @@ static const struct ieee80211_geo ipw_geos[] = {
 		{2427, 4}, {2432, 5}, {2437, 6},
 		{2442, 7}, {2447, 8}, {2452, 9},
 		{2457, 10}, {2462, 11},
-		{2467, 12, IEEE80211_CH_PASSIVE_ONLY},
-		{2472, 13, IEEE80211_CH_PASSIVE_ONLY}},
+		{2467, 12, LIBIPW_CH_PASSIVE_ONLY},
+		{2472, 13, LIBIPW_CH_PASSIVE_ONLY}},
 	 .a_channels = 24,
-	 .a = {{5180, 36, IEEE80211_CH_PASSIVE_ONLY},
-	       {5200, 40, IEEE80211_CH_PASSIVE_ONLY},
-	       {5220, 44, IEEE80211_CH_PASSIVE_ONLY},
-	       {5240, 48, IEEE80211_CH_PASSIVE_ONLY},
-	       {5260, 52, IEEE80211_CH_PASSIVE_ONLY},
-	       {5280, 56, IEEE80211_CH_PASSIVE_ONLY},
-	       {5300, 60, IEEE80211_CH_PASSIVE_ONLY},
-	       {5320, 64, IEEE80211_CH_PASSIVE_ONLY},
-	       {5500, 100, IEEE80211_CH_PASSIVE_ONLY},
-	       {5520, 104, IEEE80211_CH_PASSIVE_ONLY},
-	       {5540, 108, IEEE80211_CH_PASSIVE_ONLY},
-	       {5560, 112, IEEE80211_CH_PASSIVE_ONLY},
-	       {5580, 116, IEEE80211_CH_PASSIVE_ONLY},
-	       {5600, 120, IEEE80211_CH_PASSIVE_ONLY},
-	       {5620, 124, IEEE80211_CH_PASSIVE_ONLY},
-	       {5640, 128, IEEE80211_CH_PASSIVE_ONLY},
-	       {5660, 132, IEEE80211_CH_PASSIVE_ONLY},
-	       {5680, 136, IEEE80211_CH_PASSIVE_ONLY},
-	       {5700, 140, IEEE80211_CH_PASSIVE_ONLY},
-	       {5745, 149, IEEE80211_CH_PASSIVE_ONLY},
-	       {5765, 153, IEEE80211_CH_PASSIVE_ONLY},
-	       {5785, 157, IEEE80211_CH_PASSIVE_ONLY},
-	       {5805, 161, IEEE80211_CH_PASSIVE_ONLY},
-	       {5825, 165, IEEE80211_CH_PASSIVE_ONLY}},
+	 .a = {{5180, 36, LIBIPW_CH_PASSIVE_ONLY},
+	       {5200, 40, LIBIPW_CH_PASSIVE_ONLY},
+	       {5220, 44, LIBIPW_CH_PASSIVE_ONLY},
+	       {5240, 48, LIBIPW_CH_PASSIVE_ONLY},
+	       {5260, 52, LIBIPW_CH_PASSIVE_ONLY},
+	       {5280, 56, LIBIPW_CH_PASSIVE_ONLY},
+	       {5300, 60, LIBIPW_CH_PASSIVE_ONLY},
+	       {5320, 64, LIBIPW_CH_PASSIVE_ONLY},
+	       {5500, 100, LIBIPW_CH_PASSIVE_ONLY},
+	       {5520, 104, LIBIPW_CH_PASSIVE_ONLY},
+	       {5540, 108, LIBIPW_CH_PASSIVE_ONLY},
+	       {5560, 112, LIBIPW_CH_PASSIVE_ONLY},
+	       {5580, 116, LIBIPW_CH_PASSIVE_ONLY},
+	       {5600, 120, LIBIPW_CH_PASSIVE_ONLY},
+	       {5620, 124, LIBIPW_CH_PASSIVE_ONLY},
+	       {5640, 128, LIBIPW_CH_PASSIVE_ONLY},
+	       {5660, 132, LIBIPW_CH_PASSIVE_ONLY},
+	       {5680, 136, LIBIPW_CH_PASSIVE_ONLY},
+	       {5700, 140, LIBIPW_CH_PASSIVE_ONLY},
+	       {5745, 149, LIBIPW_CH_PASSIVE_ONLY},
+	       {5765, 153, LIBIPW_CH_PASSIVE_ONLY},
+	       {5785, 157, LIBIPW_CH_PASSIVE_ONLY},
+	       {5805, 161, LIBIPW_CH_PASSIVE_ONLY},
+	       {5825, 165, LIBIPW_CH_PASSIVE_ONLY}},
 	 },
 
 	{			/* Europe */
@@ -11205,19 +11205,19 @@ static const struct ieee80211_geo ipw_geos[] = {
 		{2442, 7}, {2447, 8}, {2452, 9},
 		{2457, 10}, {2462, 11}},
 	 .a_channels = 13,
-	 .a = {{5180, 36, IEEE80211_CH_PASSIVE_ONLY},
-	       {5200, 40, IEEE80211_CH_PASSIVE_ONLY},
-	       {5220, 44, IEEE80211_CH_PASSIVE_ONLY},
-	       {5240, 48, IEEE80211_CH_PASSIVE_ONLY},
-	       {5260, 52, IEEE80211_CH_PASSIVE_ONLY},
-	       {5280, 56, IEEE80211_CH_PASSIVE_ONLY},
-	       {5300, 60, IEEE80211_CH_PASSIVE_ONLY},
-	       {5320, 64, IEEE80211_CH_PASSIVE_ONLY},
-	       {5745, 149, IEEE80211_CH_PASSIVE_ONLY},
-	       {5765, 153, IEEE80211_CH_PASSIVE_ONLY},
-	       {5785, 157, IEEE80211_CH_PASSIVE_ONLY},
-	       {5805, 161, IEEE80211_CH_PASSIVE_ONLY},
-	       {5825, 165, IEEE80211_CH_PASSIVE_ONLY}},
+	 .a = {{5180, 36, LIBIPW_CH_PASSIVE_ONLY},
+	       {5200, 40, LIBIPW_CH_PASSIVE_ONLY},
+	       {5220, 44, LIBIPW_CH_PASSIVE_ONLY},
+	       {5240, 48, LIBIPW_CH_PASSIVE_ONLY},
+	       {5260, 52, LIBIPW_CH_PASSIVE_ONLY},
+	       {5280, 56, LIBIPW_CH_PASSIVE_ONLY},
+	       {5300, 60, LIBIPW_CH_PASSIVE_ONLY},
+	       {5320, 64, LIBIPW_CH_PASSIVE_ONLY},
+	       {5745, 149, LIBIPW_CH_PASSIVE_ONLY},
+	       {5765, 153, LIBIPW_CH_PASSIVE_ONLY},
+	       {5785, 157, LIBIPW_CH_PASSIVE_ONLY},
+	       {5805, 161, LIBIPW_CH_PASSIVE_ONLY},
+	       {5825, 165, LIBIPW_CH_PASSIVE_ONLY}},
 	 }
 };
 
@@ -11228,7 +11228,7 @@ static int ipw_up(struct ipw_priv *priv)
 
 	/* Age scan list entries found before suspend */
 	if (priv->suspend_time) {
-		ieee80211_networks_age(priv->ieee, priv->suspend_time);
+		libipw_networks_age(priv->ieee, priv->suspend_time);
 		priv->suspend_time = 0;
 	}
 
@@ -11273,7 +11273,7 @@ static int ipw_up(struct ipw_priv *priv)
 				    priv->eeprom[EEPROM_COUNTRY_CODE + 2]);
 			j = 0;
 		}
-		if (ieee80211_set_geo(priv->ieee, &ipw_geos[j])) {
+		if (libipw_set_geo(priv->ieee, &ipw_geos[j])) {
 			IPW_WARNING("Could not set geography.");
 			return 0;
 		}
@@ -11401,7 +11401,7 @@ static void ipw_bg_down(struct work_struct *work)
 /* Called by register_netdev() */
 static int ipw_net_init(struct net_device *dev)
 {
-	struct ipw_priv *priv = ieee80211_priv(dev);
+	struct ipw_priv *priv = libipw_priv(dev);
 	mutex_lock(&priv->mutex);
 
 	if (ipw_up(priv)) {
@@ -11480,7 +11480,7 @@ static struct attribute_group ipw_attribute_group = {
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 static int ipw_prom_open(struct net_device *dev)
 {
-	struct ipw_prom_priv *prom_priv = ieee80211_priv(dev);
+	struct ipw_prom_priv *prom_priv = libipw_priv(dev);
 	struct ipw_priv *priv = prom_priv->priv;
 
 	IPW_DEBUG_INFO("prom dev->open\n");
@@ -11500,7 +11500,7 @@ static int ipw_prom_open(struct net_device *dev)
 
 static int ipw_prom_stop(struct net_device *dev)
 {
-	struct ipw_prom_priv *prom_priv = ieee80211_priv(dev);
+	struct ipw_prom_priv *prom_priv = libipw_priv(dev);
 	struct ipw_priv *priv = prom_priv->priv;
 
 	IPW_DEBUG_INFO("prom dev->stop\n");
@@ -11528,7 +11528,7 @@ static const struct net_device_ops ipw_prom_netdev_ops = {
 	.ndo_open 		= ipw_prom_open,
 	.ndo_stop		= ipw_prom_stop,
 	.ndo_start_xmit		= ipw_prom_hard_start_xmit,
-	.ndo_change_mtu		= ieee80211_change_mtu,
+	.ndo_change_mtu		= libipw_change_mtu,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -11544,7 +11544,7 @@ static int ipw_prom_alloc(struct ipw_priv *priv)
 	if (priv->prom_net_dev == NULL)
 		return -ENOMEM;
 
-	priv->prom_priv = ieee80211_priv(priv->prom_net_dev);
+	priv->prom_priv = libipw_priv(priv->prom_net_dev);
 	priv->prom_priv->ieee = netdev_priv(priv->prom_net_dev);
 	priv->prom_priv->priv = priv;
 
@@ -11586,8 +11586,8 @@ static const struct net_device_ops ipw_netdev_ops = {
 	.ndo_stop		= ipw_net_stop,
 	.ndo_set_multicast_list	= ipw_net_set_multicast_list,
 	.ndo_set_mac_address	= ipw_net_set_mac_address,
-	.ndo_start_xmit		= ieee80211_xmit,
-	.ndo_change_mtu		= ieee80211_change_mtu,
+	.ndo_start_xmit		= libipw_xmit,
+	.ndo_change_mtu		= libipw_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -11607,7 +11607,7 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 		goto out;
 	}
 
-	priv = ieee80211_priv(net_dev);
+	priv = libipw_priv(net_dev);
 	priv->ieee = netdev_priv(net_dev);
 
 	priv->net_dev = net_dev;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index 05e8ccf..4448bad 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -55,7 +55,7 @@
 
 #include <linux/workqueue.h>
 
-#include "ieee80211.h"
+#include "libipw.h"
 
 /* Authentication  and Association States */
 enum connection_manager_assoc_states {
@@ -365,8 +365,8 @@ enum connection_manager_assoc_states {
 /* QoS sturctures */
 struct ipw_qos_info {
 	int qos_enable;
-	struct ieee80211_qos_parameters *def_qos_parm_OFDM;
-	struct ieee80211_qos_parameters *def_qos_parm_CCK;
+	struct libipw_qos_parameters *def_qos_parm_OFDM;
+	struct libipw_qos_parameters *def_qos_parm_CCK;
 	u32 burst_duration_CCK;
 	u32 burst_duration_OFDM;
 	u16 qos_no_ack_mask;
@@ -534,7 +534,7 @@ typedef void destructor_func(const void *);
 struct clx2_tx_queue {
 	struct clx2_queue q;
 	struct tfd_frame *bd;
-	struct ieee80211_txb **txb;
+	struct libipw_txb **txb;
 };
 
 /*
@@ -1144,7 +1144,7 @@ enum ipw_prom_filter {
 struct ipw_priv;
 struct ipw_prom_priv {
 	struct ipw_priv *priv;
-	struct ieee80211_device *ieee;
+	struct libipw_device *ieee;
 	enum ipw_prom_filter filter;
 	int tx_packets;
 	int rx_packets;
@@ -1175,7 +1175,7 @@ struct ipw_rt_hdr {
 
 struct ipw_priv {
 	/* ieee device used by generic ieee processing code */
-	struct ieee80211_device *ieee;
+	struct libipw_device *ieee;
 
 	spinlock_t lock;
 	spinlock_t irq_lock;
@@ -1222,7 +1222,7 @@ struct ipw_priv {
 	u32 roaming_threshold;
 
 	struct ipw_associate assoc_request;
-	struct ieee80211_network *assoc_network;
+	struct libipw_network *assoc_network;
 
 	unsigned long ts_scan_abort;
 	struct ipw_supported_rates rates;
diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
new file mode 100644
index 0000000..cefb942
--- /dev/null
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -0,0 +1,1087 @@
+/*
+ * Merged with mainline ieee80211.h in Aug 2004.  Original ieee802_11
+ * remains copyright by the original authors
+ *
+ * Portions of the merged code are based on Host AP (software wireless
+ * LAN access point) driver for Intersil Prism2/2.5/3.
+ *
+ * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
+ *
+ * Adaption to a generic IEEE 802.11 stack by James Ketrenos
+ * <jketreno@linux.intel.com>
+ * Copyright (c) 2004-2005, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation. See README and COPYING for
+ * more details.
+ *
+ * API Version History
+ * 1.0.x -- Initial version
+ * 1.1.x -- Added radiotap, QoS, TIM, libipw_geo APIs,
+ *          various structure changes, and crypto API init method
+ */
+#ifndef LIBIPW_H
+#define LIBIPW_H
+#include <linux/if_ether.h>	/* ETH_ALEN */
+#include <linux/kernel.h>	/* ARRAY_SIZE */
+#include <linux/wireless.h>
+#include <linux/ieee80211.h>
+
+#include <net/lib80211.h>
+
+#define LIBIPW_VERSION "git-1.1.13"
+
+#define LIBIPW_DATA_LEN		2304
+/* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
+   6.2.1.1.2.
+
+   The figure in section 7.1.2 suggests a body size of up to 2312
+   bytes is allowed, which is a bit confusing, I suspect this
+   represents the 2304 bytes of real data, plus a possible 8 bytes of
+   WEP IV and ICV. (this interpretation suggested by Ramiro Barreiro) */
+
+#define LIBIPW_1ADDR_LEN 10
+#define LIBIPW_2ADDR_LEN 16
+#define LIBIPW_3ADDR_LEN 24
+#define LIBIPW_4ADDR_LEN 30
+#define LIBIPW_FCS_LEN    4
+#define LIBIPW_HLEN			(LIBIPW_4ADDR_LEN)
+#define LIBIPW_FRAME_LEN		(LIBIPW_DATA_LEN + LIBIPW_HLEN)
+
+#define MIN_FRAG_THRESHOLD     256U
+#define	MAX_FRAG_THRESHOLD     2346U
+
+/* QOS control */
+#define LIBIPW_QCTL_TID		0x000F
+
+/* debug macros */
+
+#ifdef CONFIG_LIBIPW_DEBUG
+extern u32 libipw_debug_level;
+#define LIBIPW_DEBUG(level, fmt, args...) \
+do { if (libipw_debug_level & (level)) \
+  printk(KERN_DEBUG "ieee80211: %c %s " fmt, \
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
+static inline bool libipw_ratelimit_debug(u32 level)
+{
+	return (libipw_debug_level & level) && net_ratelimit();
+}
+#else
+#define LIBIPW_DEBUG(level, fmt, args...) do {} while (0)
+static inline bool libipw_ratelimit_debug(u32 level)
+{
+	return false;
+}
+#endif				/* CONFIG_LIBIPW_DEBUG */
+
+/*
+ * To use the debug system:
+ *
+ * If you are defining a new debug classification, simply add it to the #define
+ * list here in the form of:
+ *
+ * #define LIBIPW_DL_xxxx VALUE
+ *
+ * shifting value to the left one bit from the previous entry.  xxxx should be
+ * the name of the classification (for example, WEP)
+ *
+ * You then need to either add a LIBIPW_xxxx_DEBUG() macro definition for your
+ * classification, or use LIBIPW_DEBUG(LIBIPW_DL_xxxx, ...) whenever you want
+ * to send output to that classification.
+ *
+ * To add your debug level to the list of levels seen when you perform
+ *
+ * % cat /proc/net/ieee80211/debug_level
+ *
+ * you simply need to add your entry to the libipw_debug_level array.
+ *
+ * If you do not see debug_level in /proc/net/ieee80211 then you do not have
+ * CONFIG_LIBIPW_DEBUG defined in your kernel configuration
+ *
+ */
+
+#define LIBIPW_DL_INFO          (1<<0)
+#define LIBIPW_DL_WX            (1<<1)
+#define LIBIPW_DL_SCAN          (1<<2)
+#define LIBIPW_DL_STATE         (1<<3)
+#define LIBIPW_DL_MGMT          (1<<4)
+#define LIBIPW_DL_FRAG          (1<<5)
+#define LIBIPW_DL_DROP          (1<<7)
+
+#define LIBIPW_DL_TX            (1<<8)
+#define LIBIPW_DL_RX            (1<<9)
+#define LIBIPW_DL_QOS           (1<<31)
+
+#define LIBIPW_ERROR(f, a...) printk(KERN_ERR "ieee80211: " f, ## a)
+#define LIBIPW_WARNING(f, a...) printk(KERN_WARNING "ieee80211: " f, ## a)
+#define LIBIPW_DEBUG_INFO(f, a...)   LIBIPW_DEBUG(LIBIPW_DL_INFO, f, ## a)
+
+#define LIBIPW_DEBUG_WX(f, a...)     LIBIPW_DEBUG(LIBIPW_DL_WX, f, ## a)
+#define LIBIPW_DEBUG_SCAN(f, a...)   LIBIPW_DEBUG(LIBIPW_DL_SCAN, f, ## a)
+#define LIBIPW_DEBUG_STATE(f, a...)  LIBIPW_DEBUG(LIBIPW_DL_STATE, f, ## a)
+#define LIBIPW_DEBUG_MGMT(f, a...)  LIBIPW_DEBUG(LIBIPW_DL_MGMT, f, ## a)
+#define LIBIPW_DEBUG_FRAG(f, a...)  LIBIPW_DEBUG(LIBIPW_DL_FRAG, f, ## a)
+#define LIBIPW_DEBUG_DROP(f, a...)  LIBIPW_DEBUG(LIBIPW_DL_DROP, f, ## a)
+#define LIBIPW_DEBUG_TX(f, a...)  LIBIPW_DEBUG(LIBIPW_DL_TX, f, ## a)
+#define LIBIPW_DEBUG_RX(f, a...)  LIBIPW_DEBUG(LIBIPW_DL_RX, f, ## a)
+#define LIBIPW_DEBUG_QOS(f, a...)  LIBIPW_DEBUG(LIBIPW_DL_QOS, f, ## a)
+#include <linux/netdevice.h>
+#include <linux/if_arp.h>	/* ARPHRD_ETHER */
+
+#ifndef WIRELESS_SPY
+#define WIRELESS_SPY		/* enable iwspy support */
+#endif
+#include <net/iw_handler.h>	/* new driver API */
+
+#define ETH_P_PREAUTH 0x88C7	/* IEEE 802.11i pre-authentication */
+
+#ifndef ETH_P_80211_RAW
+#define ETH_P_80211_RAW (ETH_P_ECONET + 1)
+#endif
+
+/* IEEE 802.11 defines */
+
+#define P80211_OUI_LEN 3
+
+struct libipw_snap_hdr {
+
+	u8 dsap;		/* always 0xAA */
+	u8 ssap;		/* always 0xAA */
+	u8 ctrl;		/* always 0x03 */
+	u8 oui[P80211_OUI_LEN];	/* organizational universal id */
+
+} __attribute__ ((packed));
+
+#define SNAP_SIZE sizeof(struct libipw_snap_hdr)
+
+#define WLAN_FC_GET_VERS(fc) ((fc) & IEEE80211_FCTL_VERS)
+#define WLAN_FC_GET_TYPE(fc) ((fc) & IEEE80211_FCTL_FTYPE)
+#define WLAN_FC_GET_STYPE(fc) ((fc) & IEEE80211_FCTL_STYPE)
+
+#define WLAN_GET_SEQ_FRAG(seq) ((seq) & IEEE80211_SCTL_FRAG)
+#define WLAN_GET_SEQ_SEQ(seq)  (((seq) & IEEE80211_SCTL_SEQ) >> 4)
+
+#define LIBIPW_STATMASK_SIGNAL (1<<0)
+#define LIBIPW_STATMASK_RSSI (1<<1)
+#define LIBIPW_STATMASK_NOISE (1<<2)
+#define LIBIPW_STATMASK_RATE (1<<3)
+#define LIBIPW_STATMASK_WEMASK 0x7
+
+#define LIBIPW_CCK_MODULATION    (1<<0)
+#define LIBIPW_OFDM_MODULATION   (1<<1)
+
+#define LIBIPW_24GHZ_BAND     (1<<0)
+#define LIBIPW_52GHZ_BAND     (1<<1)
+
+#define LIBIPW_CCK_RATE_1MB		        0x02
+#define LIBIPW_CCK_RATE_2MB		        0x04
+#define LIBIPW_CCK_RATE_5MB		        0x0B
+#define LIBIPW_CCK_RATE_11MB		        0x16
+#define LIBIPW_OFDM_RATE_6MB		        0x0C
+#define LIBIPW_OFDM_RATE_9MB		        0x12
+#define LIBIPW_OFDM_RATE_12MB		0x18
+#define LIBIPW_OFDM_RATE_18MB		0x24
+#define LIBIPW_OFDM_RATE_24MB		0x30
+#define LIBIPW_OFDM_RATE_36MB		0x48
+#define LIBIPW_OFDM_RATE_48MB		0x60
+#define LIBIPW_OFDM_RATE_54MB		0x6C
+#define LIBIPW_BASIC_RATE_MASK		0x80
+
+#define LIBIPW_CCK_RATE_1MB_MASK		(1<<0)
+#define LIBIPW_CCK_RATE_2MB_MASK		(1<<1)
+#define LIBIPW_CCK_RATE_5MB_MASK		(1<<2)
+#define LIBIPW_CCK_RATE_11MB_MASK		(1<<3)
+#define LIBIPW_OFDM_RATE_6MB_MASK		(1<<4)
+#define LIBIPW_OFDM_RATE_9MB_MASK		(1<<5)
+#define LIBIPW_OFDM_RATE_12MB_MASK		(1<<6)
+#define LIBIPW_OFDM_RATE_18MB_MASK		(1<<7)
+#define LIBIPW_OFDM_RATE_24MB_MASK		(1<<8)
+#define LIBIPW_OFDM_RATE_36MB_MASK		(1<<9)
+#define LIBIPW_OFDM_RATE_48MB_MASK		(1<<10)
+#define LIBIPW_OFDM_RATE_54MB_MASK		(1<<11)
+
+#define LIBIPW_CCK_RATES_MASK	        0x0000000F
+#define LIBIPW_CCK_BASIC_RATES_MASK	(LIBIPW_CCK_RATE_1MB_MASK | \
+	LIBIPW_CCK_RATE_2MB_MASK)
+#define LIBIPW_CCK_DEFAULT_RATES_MASK	(LIBIPW_CCK_BASIC_RATES_MASK | \
+        LIBIPW_CCK_RATE_5MB_MASK | \
+        LIBIPW_CCK_RATE_11MB_MASK)
+
+#define LIBIPW_OFDM_RATES_MASK		0x00000FF0
+#define LIBIPW_OFDM_BASIC_RATES_MASK	(LIBIPW_OFDM_RATE_6MB_MASK | \
+	LIBIPW_OFDM_RATE_12MB_MASK | \
+	LIBIPW_OFDM_RATE_24MB_MASK)
+#define LIBIPW_OFDM_DEFAULT_RATES_MASK	(LIBIPW_OFDM_BASIC_RATES_MASK | \
+	LIBIPW_OFDM_RATE_9MB_MASK  | \
+	LIBIPW_OFDM_RATE_18MB_MASK | \
+	LIBIPW_OFDM_RATE_36MB_MASK | \
+	LIBIPW_OFDM_RATE_48MB_MASK | \
+	LIBIPW_OFDM_RATE_54MB_MASK)
+#define LIBIPW_DEFAULT_RATES_MASK (LIBIPW_OFDM_DEFAULT_RATES_MASK | \
+                                LIBIPW_CCK_DEFAULT_RATES_MASK)
+
+#define LIBIPW_NUM_OFDM_RATES	    8
+#define LIBIPW_NUM_CCK_RATES	            4
+#define LIBIPW_OFDM_SHIFT_MASK_A         4
+
+/* NOTE: This data is for statistical purposes; not all hardware provides this
+ *       information for frames received.
+ *       For libipw_rx_mgt, you need to set at least the 'len' parameter.
+ */
+struct libipw_rx_stats {
+	u32 mac_time;
+	s8 rssi;
+	u8 signal;
+	u8 noise;
+	u16 rate;		/* in 100 kbps */
+	u8 received_channel;
+	u8 control;
+	u8 mask;
+	u8 freq;
+	u16 len;
+	u64 tsf;
+	u32 beacon_time;
+};
+
+/* IEEE 802.11 requires that STA supports concurrent reception of at least
+ * three fragmented frames. This define can be increased to support more
+ * concurrent frames, but it should be noted that each entry can consume about
+ * 2 kB of RAM and increasing cache size will slow down frame reassembly. */
+#define LIBIPW_FRAG_CACHE_LEN 4
+
+struct libipw_frag_entry {
+	unsigned long first_frag_time;
+	unsigned int seq;
+	unsigned int last_frag;
+	struct sk_buff *skb;
+	u8 src_addr[ETH_ALEN];
+	u8 dst_addr[ETH_ALEN];
+};
+
+struct libipw_stats {
+	unsigned int tx_unicast_frames;
+	unsigned int tx_multicast_frames;
+	unsigned int tx_fragments;
+	unsigned int tx_unicast_octets;
+	unsigned int tx_multicast_octets;
+	unsigned int tx_deferred_transmissions;
+	unsigned int tx_single_retry_frames;
+	unsigned int tx_multiple_retry_frames;
+	unsigned int tx_retry_limit_exceeded;
+	unsigned int tx_discards;
+	unsigned int rx_unicast_frames;
+	unsigned int rx_multicast_frames;
+	unsigned int rx_fragments;
+	unsigned int rx_unicast_octets;
+	unsigned int rx_multicast_octets;
+	unsigned int rx_fcs_errors;
+	unsigned int rx_discards_no_buffer;
+	unsigned int tx_discards_wrong_sa;
+	unsigned int rx_discards_undecryptable;
+	unsigned int rx_message_in_msg_fragments;
+	unsigned int rx_message_in_bad_msg_fragments;
+};
+
+struct libipw_device;
+
+#define SEC_KEY_1		(1<<0)
+#define SEC_KEY_2		(1<<1)
+#define SEC_KEY_3		(1<<2)
+#define SEC_KEY_4		(1<<3)
+#define SEC_ACTIVE_KEY		(1<<4)
+#define SEC_AUTH_MODE		(1<<5)
+#define SEC_UNICAST_GROUP	(1<<6)
+#define SEC_LEVEL		(1<<7)
+#define SEC_ENABLED		(1<<8)
+#define SEC_ENCRYPT		(1<<9)
+
+#define SEC_LEVEL_0		0	/* None */
+#define SEC_LEVEL_1		1	/* WEP 40 and 104 bit */
+#define SEC_LEVEL_2		2	/* Level 1 + TKIP */
+#define SEC_LEVEL_2_CKIP	3	/* Level 1 + CKIP */
+#define SEC_LEVEL_3		4	/* Level 2 + CCMP */
+
+#define SEC_ALG_NONE		0
+#define SEC_ALG_WEP		1
+#define SEC_ALG_TKIP		2
+#define SEC_ALG_CCMP		3
+
+#define WEP_KEYS		4
+#define WEP_KEY_LEN		13
+#define SCM_KEY_LEN		32
+#define SCM_TEMPORAL_KEY_LENGTH	16
+
+struct libipw_security {
+	u16 active_key:2, enabled:1, unicast_uses_group:1, encrypt:1;
+	u8 auth_mode;
+	u8 encode_alg[WEP_KEYS];
+	u8 key_sizes[WEP_KEYS];
+	u8 keys[WEP_KEYS][SCM_KEY_LEN];
+	u8 level;
+	u16 flags;
+} __attribute__ ((packed));
+
+/*
+
+ 802.11 data frame from AP
+
+      ,-------------------------------------------------------------------.
+Bytes |  2   |  2   |    6    |    6    |    6    |  2   | 0..2312 |   4  |
+      |------|------|---------|---------|---------|------|---------|------|
+Desc. | ctrl | dura |  DA/RA  |   TA    |    SA   | Sequ |  frame  |  fcs |
+      |      | tion | (BSSID) |         |         | ence |  data   |      |
+      `-------------------------------------------------------------------'
+
+Total: 28-2340 bytes
+
+*/
+
+#define BEACON_PROBE_SSID_ID_POSITION 12
+
+struct libipw_hdr_1addr {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct libipw_hdr_2addr {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct libipw_hdr_3addr {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctl;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct libipw_hdr_4addr {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctl;
+	u8 addr4[ETH_ALEN];
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct libipw_hdr_3addrqos {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctl;
+	u8 payload[0];
+	__le16 qos_ctl;
+} __attribute__ ((packed));
+
+struct libipw_info_element {
+	u8 id;
+	u8 len;
+	u8 data[0];
+} __attribute__ ((packed));
+
+/*
+ * These are the data types that can make up management packets
+ *
+	u16 auth_algorithm;
+	u16 auth_sequence;
+	u16 beacon_interval;
+	u16 capability;
+	u8 current_ap[ETH_ALEN];
+	u16 listen_interval;
+	struct {
+		u16 association_id:14, reserved:2;
+	} __attribute__ ((packed));
+	u32 time_stamp[2];
+	u16 reason;
+	u16 status;
+*/
+
+struct libipw_auth {
+	struct libipw_hdr_3addr header;
+	__le16 algorithm;
+	__le16 transaction;
+	__le16 status;
+	/* challenge */
+	struct libipw_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct libipw_channel_switch {
+	u8 id;
+	u8 len;
+	u8 mode;
+	u8 channel;
+	u8 count;
+} __attribute__ ((packed));
+
+struct libipw_action {
+	struct libipw_hdr_3addr header;
+	u8 category;
+	u8 action;
+	union {
+		struct libipw_action_exchange {
+			u8 token;
+			struct libipw_info_element info_element[0];
+		} exchange;
+		struct libipw_channel_switch channel_switch;
+
+	} format;
+} __attribute__ ((packed));
+
+struct libipw_disassoc {
+	struct libipw_hdr_3addr header;
+	__le16 reason;
+} __attribute__ ((packed));
+
+/* Alias deauth for disassoc */
+#define libipw_deauth libipw_disassoc
+
+struct libipw_probe_request {
+	struct libipw_hdr_3addr header;
+	/* SSID, supported rates */
+	struct libipw_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct libipw_probe_response {
+	struct libipw_hdr_3addr header;
+	__le32 time_stamp[2];
+	__le16 beacon_interval;
+	__le16 capability;
+	/* SSID, supported rates, FH params, DS params,
+	 * CF params, IBSS params, TIM (if beacon), RSN */
+	struct libipw_info_element info_element[0];
+} __attribute__ ((packed));
+
+/* Alias beacon for probe_response */
+#define libipw_beacon libipw_probe_response
+
+struct libipw_assoc_request {
+	struct libipw_hdr_3addr header;
+	__le16 capability;
+	__le16 listen_interval;
+	/* SSID, supported rates, RSN */
+	struct libipw_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct libipw_reassoc_request {
+	struct libipw_hdr_3addr header;
+	__le16 capability;
+	__le16 listen_interval;
+	u8 current_ap[ETH_ALEN];
+	struct libipw_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct libipw_assoc_response {
+	struct libipw_hdr_3addr header;
+	__le16 capability;
+	__le16 status;
+	__le16 aid;
+	/* supported rates */
+	struct libipw_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct libipw_txb {
+	u8 nr_frags;
+	u8 encrypted;
+	u8 rts_included;
+	u8 reserved;
+	u16 frag_size;
+	u16 payload_size;
+	struct sk_buff *fragments[0];
+};
+
+/* SWEEP TABLE ENTRIES NUMBER */
+#define MAX_SWEEP_TAB_ENTRIES		  42
+#define MAX_SWEEP_TAB_ENTRIES_PER_PACKET  7
+/* MAX_RATES_LENGTH needs to be 12.  The spec says 8, and many APs
+ * only use 8, and then use extended rates for the remaining supported
+ * rates.  Other APs, however, stick all of their supported rates on the
+ * main rates information element... */
+#define MAX_RATES_LENGTH                  ((u8)12)
+#define MAX_RATES_EX_LENGTH               ((u8)16)
+#define MAX_NETWORK_COUNT                  128
+
+#define CRC_LENGTH                 4U
+
+#define MAX_WPA_IE_LEN 64
+
+#define NETWORK_HAS_OFDM       (1<<1)
+#define NETWORK_HAS_CCK        (1<<2)
+
+/* QoS structure */
+#define NETWORK_HAS_QOS_PARAMETERS      (1<<3)
+#define NETWORK_HAS_QOS_INFORMATION     (1<<4)
+#define NETWORK_HAS_QOS_MASK            (NETWORK_HAS_QOS_PARAMETERS | \
+					 NETWORK_HAS_QOS_INFORMATION)
+
+/* 802.11h */
+#define NETWORK_HAS_POWER_CONSTRAINT    (1<<5)
+#define NETWORK_HAS_CSA                 (1<<6)
+#define NETWORK_HAS_QUIET               (1<<7)
+#define NETWORK_HAS_IBSS_DFS            (1<<8)
+#define NETWORK_HAS_TPC_REPORT          (1<<9)
+
+#define NETWORK_HAS_ERP_VALUE           (1<<10)
+
+#define QOS_QUEUE_NUM                   4
+#define QOS_OUI_LEN                     3
+#define QOS_OUI_TYPE                    2
+#define QOS_ELEMENT_ID                  221
+#define QOS_OUI_INFO_SUB_TYPE           0
+#define QOS_OUI_PARAM_SUB_TYPE          1
+#define QOS_VERSION_1                   1
+#define QOS_AIFSN_MIN_VALUE             2
+
+struct libipw_qos_information_element {
+	u8 elementID;
+	u8 length;
+	u8 qui[QOS_OUI_LEN];
+	u8 qui_type;
+	u8 qui_subtype;
+	u8 version;
+	u8 ac_info;
+} __attribute__ ((packed));
+
+struct libipw_qos_ac_parameter {
+	u8 aci_aifsn;
+	u8 ecw_min_max;
+	__le16 tx_op_limit;
+} __attribute__ ((packed));
+
+struct libipw_qos_parameter_info {
+	struct libipw_qos_information_element info_element;
+	u8 reserved;
+	struct libipw_qos_ac_parameter ac_params_record[QOS_QUEUE_NUM];
+} __attribute__ ((packed));
+
+struct libipw_qos_parameters {
+	__le16 cw_min[QOS_QUEUE_NUM];
+	__le16 cw_max[QOS_QUEUE_NUM];
+	u8 aifs[QOS_QUEUE_NUM];
+	u8 flag[QOS_QUEUE_NUM];
+	__le16 tx_op_limit[QOS_QUEUE_NUM];
+} __attribute__ ((packed));
+
+struct libipw_qos_data {
+	struct libipw_qos_parameters parameters;
+	int active;
+	int supported;
+	u8 param_count;
+	u8 old_param_count;
+};
+
+struct libipw_tim_parameters {
+	u8 tim_count;
+	u8 tim_period;
+} __attribute__ ((packed));
+
+/*******************************************************/
+
+enum {				/* libipw_basic_report.map */
+	LIBIPW_BASIC_MAP_BSS = (1 << 0),
+	LIBIPW_BASIC_MAP_OFDM = (1 << 1),
+	LIBIPW_BASIC_MAP_UNIDENTIFIED = (1 << 2),
+	LIBIPW_BASIC_MAP_RADAR = (1 << 3),
+	LIBIPW_BASIC_MAP_UNMEASURED = (1 << 4),
+	/* Bits 5-7 are reserved */
+
+};
+struct libipw_basic_report {
+	u8 channel;
+	__le64 start_time;
+	__le16 duration;
+	u8 map;
+} __attribute__ ((packed));
+
+enum {				/* libipw_measurement_request.mode */
+	/* Bit 0 is reserved */
+	LIBIPW_MEASUREMENT_ENABLE = (1 << 1),
+	LIBIPW_MEASUREMENT_REQUEST = (1 << 2),
+	LIBIPW_MEASUREMENT_REPORT = (1 << 3),
+	/* Bits 4-7 are reserved */
+};
+
+enum {
+	LIBIPW_REPORT_BASIC = 0,	/* required */
+	LIBIPW_REPORT_CCA = 1,	/* optional */
+	LIBIPW_REPORT_RPI = 2,	/* optional */
+	/* 3-255 reserved */
+};
+
+struct libipw_measurement_params {
+	u8 channel;
+	__le64 start_time;
+	__le16 duration;
+} __attribute__ ((packed));
+
+struct libipw_measurement_request {
+	struct libipw_info_element ie;
+	u8 token;
+	u8 mode;
+	u8 type;
+	struct libipw_measurement_params params[0];
+} __attribute__ ((packed));
+
+struct libipw_measurement_report {
+	struct libipw_info_element ie;
+	u8 token;
+	u8 mode;
+	u8 type;
+	union {
+		struct libipw_basic_report basic[0];
+	} u;
+} __attribute__ ((packed));
+
+struct libipw_tpc_report {
+	u8 transmit_power;
+	u8 link_margin;
+} __attribute__ ((packed));
+
+struct libipw_channel_map {
+	u8 channel;
+	u8 map;
+} __attribute__ ((packed));
+
+struct libipw_ibss_dfs {
+	struct libipw_info_element ie;
+	u8 owner[ETH_ALEN];
+	u8 recovery_interval;
+	struct libipw_channel_map channel_map[0];
+};
+
+struct libipw_csa {
+	u8 mode;
+	u8 channel;
+	u8 count;
+} __attribute__ ((packed));
+
+struct libipw_quiet {
+	u8 count;
+	u8 period;
+	u8 duration;
+	u8 offset;
+} __attribute__ ((packed));
+
+struct libipw_network {
+	/* These entries are used to identify a unique network */
+	u8 bssid[ETH_ALEN];
+	u8 channel;
+	/* Ensure null-terminated for any debug msgs */
+	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid_len;
+
+	struct libipw_qos_data qos_data;
+
+	/* These are network statistics */
+	struct libipw_rx_stats stats;
+	u16 capability;
+	u8 rates[MAX_RATES_LENGTH];
+	u8 rates_len;
+	u8 rates_ex[MAX_RATES_EX_LENGTH];
+	u8 rates_ex_len;
+	unsigned long last_scanned;
+	u8 mode;
+	u32 flags;
+	u32 last_associate;
+	u32 time_stamp[2];
+	u16 beacon_interval;
+	u16 listen_interval;
+	u16 atim_window;
+	u8 erp_value;
+	u8 wpa_ie[MAX_WPA_IE_LEN];
+	size_t wpa_ie_len;
+	u8 rsn_ie[MAX_WPA_IE_LEN];
+	size_t rsn_ie_len;
+	struct libipw_tim_parameters tim;
+
+	/* 802.11h info */
+
+	/* Power Constraint - mandatory if spctrm mgmt required */
+	u8 power_constraint;
+
+	/* TPC Report - mandatory if spctrm mgmt required */
+	struct libipw_tpc_report tpc_report;
+
+	/* IBSS DFS - mandatory if spctrm mgmt required and IBSS
+	 * NOTE: This is variable length and so must be allocated dynamically */
+	struct libipw_ibss_dfs *ibss_dfs;
+
+	/* Channel Switch Announcement - optional if spctrm mgmt required */
+	struct libipw_csa csa;
+
+	/* Quiet - optional if spctrm mgmt required */
+	struct libipw_quiet quiet;
+
+	struct list_head list;
+};
+
+enum libipw_state {
+	LIBIPW_UNINITIALIZED = 0,
+	LIBIPW_INITIALIZED,
+	LIBIPW_ASSOCIATING,
+	LIBIPW_ASSOCIATED,
+	LIBIPW_AUTHENTICATING,
+	LIBIPW_AUTHENTICATED,
+	LIBIPW_SHUTDOWN
+};
+
+#define DEFAULT_MAX_SCAN_AGE (15 * HZ)
+#define DEFAULT_FTS 2346
+
+#define CFG_LIBIPW_RESERVE_FCS (1<<0)
+#define CFG_LIBIPW_COMPUTE_FCS (1<<1)
+#define CFG_LIBIPW_RTS (1<<2)
+
+#define LIBIPW_24GHZ_MIN_CHANNEL 1
+#define LIBIPW_24GHZ_MAX_CHANNEL 14
+#define LIBIPW_24GHZ_CHANNELS (LIBIPW_24GHZ_MAX_CHANNEL - \
+				  LIBIPW_24GHZ_MIN_CHANNEL + 1)
+
+#define LIBIPW_52GHZ_MIN_CHANNEL 34
+#define LIBIPW_52GHZ_MAX_CHANNEL 165
+#define LIBIPW_52GHZ_CHANNELS (LIBIPW_52GHZ_MAX_CHANNEL - \
+				  LIBIPW_52GHZ_MIN_CHANNEL + 1)
+
+enum {
+	LIBIPW_CH_PASSIVE_ONLY = (1 << 0),
+	LIBIPW_CH_80211H_RULES = (1 << 1),
+	LIBIPW_CH_B_ONLY = (1 << 2),
+	LIBIPW_CH_NO_IBSS = (1 << 3),
+	LIBIPW_CH_UNIFORM_SPREADING = (1 << 4),
+	LIBIPW_CH_RADAR_DETECT = (1 << 5),
+	LIBIPW_CH_INVALID = (1 << 6),
+};
+
+struct libipw_channel {
+	u32 freq;	/* in MHz */
+	u8 channel;
+	u8 flags;
+	u8 max_power;	/* in dBm */
+};
+
+struct libipw_geo {
+	u8 name[4];
+	u8 bg_channels;
+	u8 a_channels;
+	struct libipw_channel bg[LIBIPW_24GHZ_CHANNELS];
+	struct libipw_channel a[LIBIPW_52GHZ_CHANNELS];
+};
+
+struct libipw_device {
+	struct net_device *dev;
+	struct libipw_security sec;
+
+	/* Bookkeeping structures */
+	struct libipw_stats ieee_stats;
+
+	struct libipw_geo geo;
+
+	/* Probe / Beacon management */
+	struct list_head network_free_list;
+	struct list_head network_list;
+	struct libipw_network *networks;
+	int scans;
+	int scan_age;
+
+	int iw_mode;		/* operating mode (IW_MODE_*) */
+	struct iw_spy_data spy_data;	/* iwspy support */
+
+	spinlock_t lock;
+
+	int tx_headroom;	/* Set to size of any additional room needed at front
+				 * of allocated Tx SKBs */
+	u32 config;
+
+	/* WEP and other encryption related settings at the device level */
+	int open_wep;		/* Set to 1 to allow unencrypted frames */
+
+	int reset_on_keychange;	/* Set to 1 if the HW needs to be reset on
+				 * WEP key changes */
+
+	/* If the host performs {en,de}cryption, then set to 1 */
+	int host_encrypt;
+	int host_encrypt_msdu;
+	int host_decrypt;
+	/* host performs multicast decryption */
+	int host_mc_decrypt;
+
+	/* host should strip IV and ICV from protected frames */
+	/* meaningful only when hardware decryption is being used */
+	int host_strip_iv_icv;
+
+	int host_open_frag;
+	int host_build_iv;
+	int ieee802_1x;		/* is IEEE 802.1X used */
+
+	/* WPA data */
+	int wpa_enabled;
+	int drop_unencrypted;
+	int privacy_invoked;
+	size_t wpa_ie_len;
+	u8 *wpa_ie;
+
+	struct lib80211_crypt_info crypt_info;
+
+	int bcrx_sta_key;	/* use individual keys to override default keys even
+				 * with RX of broad/multicast frames */
+
+	/* Fragmentation structures */
+	struct libipw_frag_entry frag_cache[LIBIPW_FRAG_CACHE_LEN];
+	unsigned int frag_next_idx;
+	u16 fts;		/* Fragmentation Threshold */
+	u16 rts;		/* RTS threshold */
+
+	/* Association info */
+	u8 bssid[ETH_ALEN];
+
+	enum libipw_state state;
+
+	int mode;		/* A, B, G */
+	int modulation;		/* CCK, OFDM */
+	int freq_band;		/* 2.4Ghz, 5.2Ghz, Mixed */
+	int abg_true;		/* ABG flag              */
+
+	int perfect_rssi;
+	int worst_rssi;
+
+	u16 prev_seq_ctl;	/* used to drop duplicate frames */
+
+	/* Callback functions */
+	void (*set_security) (struct net_device * dev,
+			      struct libipw_security * sec);
+	int (*hard_start_xmit) (struct libipw_txb * txb,
+				struct net_device * dev, int pri);
+	int (*reset_port) (struct net_device * dev);
+	int (*is_queue_full) (struct net_device * dev, int pri);
+
+	int (*handle_management) (struct net_device * dev,
+				  struct libipw_network * network, u16 type);
+	int (*is_qos_active) (struct net_device *dev, struct sk_buff *skb);
+
+	/* Typical STA methods */
+	int (*handle_auth) (struct net_device * dev,
+			    struct libipw_auth * auth);
+	int (*handle_deauth) (struct net_device * dev,
+			      struct libipw_deauth * auth);
+	int (*handle_action) (struct net_device * dev,
+			      struct libipw_action * action,
+			      struct libipw_rx_stats * stats);
+	int (*handle_disassoc) (struct net_device * dev,
+				struct libipw_disassoc * assoc);
+	int (*handle_beacon) (struct net_device * dev,
+			      struct libipw_beacon * beacon,
+			      struct libipw_network * network);
+	int (*handle_probe_response) (struct net_device * dev,
+				      struct libipw_probe_response * resp,
+				      struct libipw_network * network);
+	int (*handle_probe_request) (struct net_device * dev,
+				     struct libipw_probe_request * req,
+				     struct libipw_rx_stats * stats);
+	int (*handle_assoc_response) (struct net_device * dev,
+				      struct libipw_assoc_response * resp,
+				      struct libipw_network * network);
+
+	/* Typical AP methods */
+	int (*handle_assoc_request) (struct net_device * dev);
+	int (*handle_reassoc_request) (struct net_device * dev,
+				       struct libipw_reassoc_request * req);
+
+	/* This must be the last item so that it points to the data
+	 * allocated beyond this structure by alloc_ieee80211 */
+	u8 priv[0];
+};
+
+#define IEEE_A            (1<<0)
+#define IEEE_B            (1<<1)
+#define IEEE_G            (1<<2)
+#define IEEE_MODE_MASK    (IEEE_A|IEEE_B|IEEE_G)
+
+static inline void *libipw_priv(struct net_device *dev)
+{
+	return ((struct libipw_device *)netdev_priv(dev))->priv;
+}
+
+static inline int libipw_is_valid_mode(struct libipw_device *ieee,
+					  int mode)
+{
+	/*
+	 * It is possible for both access points and our device to support
+	 * combinations of modes, so as long as there is one valid combination
+	 * of ap/device supported modes, then return success
+	 *
+	 */
+	if ((mode & IEEE_A) &&
+	    (ieee->modulation & LIBIPW_OFDM_MODULATION) &&
+	    (ieee->freq_band & LIBIPW_52GHZ_BAND))
+		return 1;
+
+	if ((mode & IEEE_G) &&
+	    (ieee->modulation & LIBIPW_OFDM_MODULATION) &&
+	    (ieee->freq_band & LIBIPW_24GHZ_BAND))
+		return 1;
+
+	if ((mode & IEEE_B) &&
+	    (ieee->modulation & LIBIPW_CCK_MODULATION) &&
+	    (ieee->freq_band & LIBIPW_24GHZ_BAND))
+		return 1;
+
+	return 0;
+}
+
+static inline int libipw_get_hdrlen(u16 fc)
+{
+	int hdrlen = LIBIPW_3ADDR_LEN;
+	u16 stype = WLAN_FC_GET_STYPE(fc);
+
+	switch (WLAN_FC_GET_TYPE(fc)) {
+	case IEEE80211_FTYPE_DATA:
+		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
+			hdrlen = LIBIPW_4ADDR_LEN;
+		if (stype & IEEE80211_STYPE_QOS_DATA)
+			hdrlen += 2;
+		break;
+	case IEEE80211_FTYPE_CTL:
+		switch (WLAN_FC_GET_STYPE(fc)) {
+		case IEEE80211_STYPE_CTS:
+		case IEEE80211_STYPE_ACK:
+			hdrlen = LIBIPW_1ADDR_LEN;
+			break;
+		default:
+			hdrlen = LIBIPW_2ADDR_LEN;
+			break;
+		}
+		break;
+	}
+
+	return hdrlen;
+}
+
+static inline u8 *libipw_get_payload(struct ieee80211_hdr *hdr)
+{
+	switch (libipw_get_hdrlen(le16_to_cpu(hdr->frame_control))) {
+	case LIBIPW_1ADDR_LEN:
+		return ((struct libipw_hdr_1addr *)hdr)->payload;
+	case LIBIPW_2ADDR_LEN:
+		return ((struct libipw_hdr_2addr *)hdr)->payload;
+	case LIBIPW_3ADDR_LEN:
+		return ((struct libipw_hdr_3addr *)hdr)->payload;
+	case LIBIPW_4ADDR_LEN:
+		return ((struct libipw_hdr_4addr *)hdr)->payload;
+	}
+	return NULL;
+}
+
+static inline int libipw_is_ofdm_rate(u8 rate)
+{
+	switch (rate & ~LIBIPW_BASIC_RATE_MASK) {
+	case LIBIPW_OFDM_RATE_6MB:
+	case LIBIPW_OFDM_RATE_9MB:
+	case LIBIPW_OFDM_RATE_12MB:
+	case LIBIPW_OFDM_RATE_18MB:
+	case LIBIPW_OFDM_RATE_24MB:
+	case LIBIPW_OFDM_RATE_36MB:
+	case LIBIPW_OFDM_RATE_48MB:
+	case LIBIPW_OFDM_RATE_54MB:
+		return 1;
+	}
+	return 0;
+}
+
+static inline int libipw_is_cck_rate(u8 rate)
+{
+	switch (rate & ~LIBIPW_BASIC_RATE_MASK) {
+	case LIBIPW_CCK_RATE_1MB:
+	case LIBIPW_CCK_RATE_2MB:
+	case LIBIPW_CCK_RATE_5MB:
+	case LIBIPW_CCK_RATE_11MB:
+		return 1;
+	}
+	return 0;
+}
+
+/* ieee80211.c */
+extern void free_ieee80211(struct net_device *dev);
+extern struct net_device *alloc_ieee80211(int sizeof_priv);
+extern int libipw_change_mtu(struct net_device *dev, int new_mtu);
+
+extern void libipw_networks_age(struct libipw_device *ieee,
+				   unsigned long age_secs);
+
+extern int libipw_set_encryption(struct libipw_device *ieee);
+
+/* libipw_tx.c */
+extern int libipw_xmit(struct sk_buff *skb, struct net_device *dev);
+extern void libipw_txb_free(struct libipw_txb *);
+
+/* libipw_rx.c */
+extern void libipw_rx_any(struct libipw_device *ieee,
+		     struct sk_buff *skb, struct libipw_rx_stats *stats);
+extern int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
+			struct libipw_rx_stats *rx_stats);
+/* make sure to set stats->len */
+extern void libipw_rx_mgt(struct libipw_device *ieee,
+			     struct libipw_hdr_4addr *header,
+			     struct libipw_rx_stats *stats);
+extern void libipw_network_reset(struct libipw_network *network);
+
+/* libipw_geo.c */
+extern const struct libipw_geo *libipw_get_geo(struct libipw_device
+						     *ieee);
+extern int libipw_set_geo(struct libipw_device *ieee,
+			     const struct libipw_geo *geo);
+
+extern int libipw_is_valid_channel(struct libipw_device *ieee,
+				      u8 channel);
+extern int libipw_channel_to_index(struct libipw_device *ieee,
+				      u8 channel);
+extern u8 libipw_freq_to_channel(struct libipw_device *ieee, u32 freq);
+extern u8 libipw_get_channel_flags(struct libipw_device *ieee,
+				      u8 channel);
+extern const struct libipw_channel *libipw_get_channel(struct
+							     libipw_device
+							     *ieee, u8 channel);
+extern u32 libipw_channel_to_freq(struct libipw_device * ieee,
+				      u8 channel);
+
+/* libipw_wx.c */
+extern int libipw_wx_get_scan(struct libipw_device *ieee,
+				 struct iw_request_info *info,
+				 union iwreq_data *wrqu, char *key);
+extern int libipw_wx_set_encode(struct libipw_device *ieee,
+				   struct iw_request_info *info,
+				   union iwreq_data *wrqu, char *key);
+extern int libipw_wx_get_encode(struct libipw_device *ieee,
+				   struct iw_request_info *info,
+				   union iwreq_data *wrqu, char *key);
+extern int libipw_wx_set_encodeext(struct libipw_device *ieee,
+				      struct iw_request_info *info,
+				      union iwreq_data *wrqu, char *extra);
+extern int libipw_wx_get_encodeext(struct libipw_device *ieee,
+				      struct iw_request_info *info,
+				      union iwreq_data *wrqu, char *extra);
+
+static inline void libipw_increment_scans(struct libipw_device *ieee)
+{
+	ieee->scans++;
+}
+
+static inline int libipw_get_scans(struct libipw_device *ieee)
+{
+	return ieee->scans;
+}
+
+#endif				/* LIBIPW_H */
diff --git a/drivers/net/wireless/ipw2x00/libipw_geo.c b/drivers/net/wireless/ipw2x00/libipw_geo.c
index 9dfbb87..d04979b 100644
--- a/drivers/net/wireless/ipw2x00/libipw_geo.c
+++ b/drivers/net/wireless/ipw2x00/libipw_geo.c
@@ -41,9 +41,9 @@
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
 
-#include "ieee80211.h"
+#include "libipw.h"
 
-int ieee80211_is_valid_channel(struct ieee80211_device *ieee, u8 channel)
+int libipw_is_valid_channel(struct libipw_device *ieee, u8 channel)
 {
 	int i;
 
@@ -52,27 +52,27 @@ int ieee80211_is_valid_channel(struct ieee80211_device *ieee, u8 channel)
 	if (ieee->geo.bg_channels == 0 && ieee->geo.a_channels == 0)
 		return 0;
 
-	if (ieee->freq_band & IEEE80211_24GHZ_BAND)
+	if (ieee->freq_band & LIBIPW_24GHZ_BAND)
 		for (i = 0; i < ieee->geo.bg_channels; i++)
 			/* NOTE: If G mode is currently supported but
 			 * this is a B only channel, we don't see it
 			 * as valid. */
 			if ((ieee->geo.bg[i].channel == channel) &&
-			    !(ieee->geo.bg[i].flags & IEEE80211_CH_INVALID) &&
+			    !(ieee->geo.bg[i].flags & LIBIPW_CH_INVALID) &&
 			    (!(ieee->mode & IEEE_G) ||
-			     !(ieee->geo.bg[i].flags & IEEE80211_CH_B_ONLY)))
-				return IEEE80211_24GHZ_BAND;
+			     !(ieee->geo.bg[i].flags & LIBIPW_CH_B_ONLY)))
+				return LIBIPW_24GHZ_BAND;
 
-	if (ieee->freq_band & IEEE80211_52GHZ_BAND)
+	if (ieee->freq_band & LIBIPW_52GHZ_BAND)
 		for (i = 0; i < ieee->geo.a_channels; i++)
 			if ((ieee->geo.a[i].channel == channel) &&
-			    !(ieee->geo.a[i].flags & IEEE80211_CH_INVALID))
-				return IEEE80211_52GHZ_BAND;
+			    !(ieee->geo.a[i].flags & LIBIPW_CH_INVALID))
+				return LIBIPW_52GHZ_BAND;
 
 	return 0;
 }
 
-int ieee80211_channel_to_index(struct ieee80211_device *ieee, u8 channel)
+int libipw_channel_to_index(struct libipw_device *ieee, u8 channel)
 {
 	int i;
 
@@ -81,12 +81,12 @@ int ieee80211_channel_to_index(struct ieee80211_device *ieee, u8 channel)
 	if (ieee->geo.bg_channels == 0 && ieee->geo.a_channels == 0)
 		return -1;
 
-	if (ieee->freq_band & IEEE80211_24GHZ_BAND)
+	if (ieee->freq_band & LIBIPW_24GHZ_BAND)
 		for (i = 0; i < ieee->geo.bg_channels; i++)
 			if (ieee->geo.bg[i].channel == channel)
 				return i;
 
-	if (ieee->freq_band & IEEE80211_52GHZ_BAND)
+	if (ieee->freq_band & LIBIPW_52GHZ_BAND)
 		for (i = 0; i < ieee->geo.a_channels; i++)
 			if (ieee->geo.a[i].channel == channel)
 				return i;
@@ -94,22 +94,22 @@ int ieee80211_channel_to_index(struct ieee80211_device *ieee, u8 channel)
 	return -1;
 }
 
-u32 ieee80211_channel_to_freq(struct ieee80211_device * ieee, u8 channel)
+u32 libipw_channel_to_freq(struct libipw_device * ieee, u8 channel)
 {
-	const struct ieee80211_channel * ch;
+	const struct libipw_channel * ch;
 
 	/* Driver needs to initialize the geography map before using
 	 * these helper functions */
 	if (ieee->geo.bg_channels == 0 && ieee->geo.a_channels == 0)
 		return 0;
 
-	ch = ieee80211_get_channel(ieee, channel);
+	ch = libipw_get_channel(ieee, channel);
 	if (!ch->channel)
 		return 0;
 	return ch->freq;
 }
 
-u8 ieee80211_freq_to_channel(struct ieee80211_device * ieee, u32 freq)
+u8 libipw_freq_to_channel(struct libipw_device * ieee, u32 freq)
 {
 	int i;
 
@@ -120,12 +120,12 @@ u8 ieee80211_freq_to_channel(struct ieee80211_device * ieee, u32 freq)
 
 	freq /= 100000;
 
-	if (ieee->freq_band & IEEE80211_24GHZ_BAND)
+	if (ieee->freq_band & LIBIPW_24GHZ_BAND)
 		for (i = 0; i < ieee->geo.bg_channels; i++)
 			if (ieee->geo.bg[i].freq == freq)
 				return ieee->geo.bg[i].channel;
 
-	if (ieee->freq_band & IEEE80211_52GHZ_BAND)
+	if (ieee->freq_band & LIBIPW_52GHZ_BAND)
 		for (i = 0; i < ieee->geo.a_channels; i++)
 			if (ieee->geo.a[i].freq == freq)
 				return ieee->geo.a[i].channel;
@@ -133,63 +133,63 @@ u8 ieee80211_freq_to_channel(struct ieee80211_device * ieee, u32 freq)
 	return 0;
 }
 
-int ieee80211_set_geo(struct ieee80211_device *ieee,
-		      const struct ieee80211_geo *geo)
+int libipw_set_geo(struct libipw_device *ieee,
+		      const struct libipw_geo *geo)
 {
 	memcpy(ieee->geo.name, geo->name, 3);
 	ieee->geo.name[3] = '\0';
 	ieee->geo.bg_channels = geo->bg_channels;
 	ieee->geo.a_channels = geo->a_channels;
 	memcpy(ieee->geo.bg, geo->bg, geo->bg_channels *
-	       sizeof(struct ieee80211_channel));
+	       sizeof(struct libipw_channel));
 	memcpy(ieee->geo.a, geo->a, ieee->geo.a_channels *
-	       sizeof(struct ieee80211_channel));
+	       sizeof(struct libipw_channel));
 	return 0;
 }
 
-const struct ieee80211_geo *ieee80211_get_geo(struct ieee80211_device *ieee)
+const struct libipw_geo *libipw_get_geo(struct libipw_device *ieee)
 {
 	return &ieee->geo;
 }
 
-u8 ieee80211_get_channel_flags(struct ieee80211_device * ieee, u8 channel)
+u8 libipw_get_channel_flags(struct libipw_device * ieee, u8 channel)
 {
-	int index = ieee80211_channel_to_index(ieee, channel);
+	int index = libipw_channel_to_index(ieee, channel);
 
 	if (index == -1)
-		return IEEE80211_CH_INVALID;
+		return LIBIPW_CH_INVALID;
 
-	if (channel <= IEEE80211_24GHZ_CHANNELS)
+	if (channel <= LIBIPW_24GHZ_CHANNELS)
 		return ieee->geo.bg[index].flags;
 
 	return ieee->geo.a[index].flags;
 }
 
-static const struct ieee80211_channel bad_channel = {
+static const struct libipw_channel bad_channel = {
 	.channel = 0,
-	.flags = IEEE80211_CH_INVALID,
+	.flags = LIBIPW_CH_INVALID,
 	.max_power = 0,
 };
 
-const struct ieee80211_channel *ieee80211_get_channel(struct ieee80211_device
+const struct libipw_channel *libipw_get_channel(struct libipw_device
 						      *ieee, u8 channel)
 {
-	int index = ieee80211_channel_to_index(ieee, channel);
+	int index = libipw_channel_to_index(ieee, channel);
 
 	if (index == -1)
 		return &bad_channel;
 
-	if (channel <= IEEE80211_24GHZ_CHANNELS)
+	if (channel <= LIBIPW_24GHZ_CHANNELS)
 		return &ieee->geo.bg[index];
 
 	return &ieee->geo.a[index];
 }
 
-EXPORT_SYMBOL(ieee80211_get_channel);
-EXPORT_SYMBOL(ieee80211_get_channel_flags);
-EXPORT_SYMBOL(ieee80211_is_valid_channel);
-EXPORT_SYMBOL(ieee80211_freq_to_channel);
-EXPORT_SYMBOL(ieee80211_channel_to_freq);
-EXPORT_SYMBOL(ieee80211_channel_to_index);
-EXPORT_SYMBOL(ieee80211_set_geo);
-EXPORT_SYMBOL(ieee80211_get_geo);
+EXPORT_SYMBOL(libipw_get_channel);
+EXPORT_SYMBOL(libipw_get_channel_flags);
+EXPORT_SYMBOL(libipw_is_valid_channel);
+EXPORT_SYMBOL(libipw_freq_to_channel);
+EXPORT_SYMBOL(libipw_channel_to_freq);
+EXPORT_SYMBOL(libipw_channel_to_index);
+EXPORT_SYMBOL(libipw_set_geo);
+EXPORT_SYMBOL(libipw_get_geo);
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index 8ce6e96..00c3640 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -50,11 +50,11 @@
 #include <net/net_namespace.h>
 #include <net/arp.h>
 
-#include "ieee80211.h"
+#include "libipw.h"
 
 #define DRV_DESCRIPTION "802.11 data/management/control stack"
 #define DRV_NAME        "ieee80211"
-#define DRV_VERSION	IEEE80211_VERSION
+#define DRV_VERSION	LIBIPW_VERSION
 #define DRV_COPYRIGHT   "Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>"
 
 MODULE_VERSION(DRV_VERSION);
@@ -62,13 +62,13 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
-static int ieee80211_networks_allocate(struct ieee80211_device *ieee)
+static int libipw_networks_allocate(struct libipw_device *ieee)
 {
 	if (ieee->networks)
 		return 0;
 
 	ieee->networks =
-	    kzalloc(MAX_NETWORK_COUNT * sizeof(struct ieee80211_network),
+	    kzalloc(MAX_NETWORK_COUNT * sizeof(struct libipw_network),
 		    GFP_KERNEL);
 	if (!ieee->networks) {
 		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
@@ -79,7 +79,7 @@ static int ieee80211_networks_allocate(struct ieee80211_device *ieee)
 	return 0;
 }
 
-void ieee80211_network_reset(struct ieee80211_network *network)
+void libipw_network_reset(struct libipw_network *network)
 {
 	if (!network)
 		return;
@@ -90,7 +90,7 @@ void ieee80211_network_reset(struct ieee80211_network *network)
 	}
 }
 
-static inline void ieee80211_networks_free(struct ieee80211_device *ieee)
+static inline void libipw_networks_free(struct libipw_device *ieee)
 {
 	int i;
 
@@ -105,10 +105,10 @@ static inline void ieee80211_networks_free(struct ieee80211_device *ieee)
 	ieee->networks = NULL;
 }
 
-void ieee80211_networks_age(struct ieee80211_device *ieee,
+void libipw_networks_age(struct libipw_device *ieee,
                             unsigned long age_secs)
 {
-	struct ieee80211_network *network = NULL;
+	struct libipw_network *network = NULL;
 	unsigned long flags;
 	unsigned long age_jiffies = msecs_to_jiffies(age_secs * MSEC_PER_SEC);
 
@@ -118,9 +118,9 @@ void ieee80211_networks_age(struct ieee80211_device *ieee,
 	}
 	spin_unlock_irqrestore(&ieee->lock, flags);
 }
-EXPORT_SYMBOL(ieee80211_networks_age);
+EXPORT_SYMBOL(libipw_networks_age);
 
-static void ieee80211_networks_initialize(struct ieee80211_device *ieee)
+static void libipw_networks_initialize(struct libipw_device *ieee)
 {
 	int i;
 
@@ -131,38 +131,38 @@ static void ieee80211_networks_initialize(struct ieee80211_device *ieee)
 			      &ieee->network_free_list);
 }
 
-int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
+int libipw_change_mtu(struct net_device *dev, int new_mtu)
 {
-	if ((new_mtu < 68) || (new_mtu > IEEE80211_DATA_LEN))
+	if ((new_mtu < 68) || (new_mtu > LIBIPW_DATA_LEN))
 		return -EINVAL;
 	dev->mtu = new_mtu;
 	return 0;
 }
-EXPORT_SYMBOL(ieee80211_change_mtu);
+EXPORT_SYMBOL(libipw_change_mtu);
 
 struct net_device *alloc_ieee80211(int sizeof_priv)
 {
-	struct ieee80211_device *ieee;
+	struct libipw_device *ieee;
 	struct net_device *dev;
 	int err;
 
-	IEEE80211_DEBUG_INFO("Initializing...\n");
+	LIBIPW_DEBUG_INFO("Initializing...\n");
 
-	dev = alloc_etherdev(sizeof(struct ieee80211_device) + sizeof_priv);
+	dev = alloc_etherdev(sizeof(struct libipw_device) + sizeof_priv);
 	if (!dev) {
-		IEEE80211_ERROR("Unable to allocate network device.\n");
+		LIBIPW_ERROR("Unable to allocate network device.\n");
 		goto failed;
 	}
 	ieee = netdev_priv(dev);
 
 	ieee->dev = dev;
 
-	err = ieee80211_networks_allocate(ieee);
+	err = libipw_networks_allocate(ieee);
 	if (err) {
-		IEEE80211_ERROR("Unable to allocate beacon storage: %d\n", err);
+		LIBIPW_ERROR("Unable to allocate beacon storage: %d\n", err);
 		goto failed_free_netdev;
 	}
-	ieee80211_networks_initialize(ieee);
+	libipw_networks_initialize(ieee);
 
 	/* Default fragmentation threshold is maximum payload size */
 	ieee->fts = DEFAULT_FTS;
@@ -201,25 +201,25 @@ failed:
 
 void free_ieee80211(struct net_device *dev)
 {
-	struct ieee80211_device *ieee = netdev_priv(dev);
+	struct libipw_device *ieee = netdev_priv(dev);
 
 	lib80211_crypt_info_free(&ieee->crypt_info);
 
-	ieee80211_networks_free(ieee);
+	libipw_networks_free(ieee);
 	free_netdev(dev);
 }
 
 #ifdef CONFIG_LIBIPW_DEBUG
 
 static int debug = 0;
-u32 ieee80211_debug_level = 0;
-EXPORT_SYMBOL_GPL(ieee80211_debug_level);
-static struct proc_dir_entry *ieee80211_proc = NULL;
+u32 libipw_debug_level = 0;
+EXPORT_SYMBOL_GPL(libipw_debug_level);
+static struct proc_dir_entry *libipw_proc = NULL;
 
 static int show_debug_level(char *page, char **start, off_t offset,
 			    int count, int *eof, void *data)
 {
-	return snprintf(page, count, "0x%08X\n", ieee80211_debug_level);
+	return snprintf(page, count, "0x%08X\n", libipw_debug_level);
 }
 
 static int store_debug_level(struct file *file, const char __user * buffer,
@@ -236,29 +236,29 @@ static int store_debug_level(struct file *file, const char __user * buffer,
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in hex or decimal form.\n", buf);
 	else
-		ieee80211_debug_level = val;
+		libipw_debug_level = val;
 
 	return strnlen(buf, len);
 }
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
-static int __init ieee80211_init(void)
+static int __init libipw_init(void)
 {
 #ifdef CONFIG_LIBIPW_DEBUG
 	struct proc_dir_entry *e;
 
-	ieee80211_debug_level = debug;
-	ieee80211_proc = proc_mkdir(DRV_NAME, init_net.proc_net);
-	if (ieee80211_proc == NULL) {
-		IEEE80211_ERROR("Unable to create " DRV_NAME
+	libipw_debug_level = debug;
+	libipw_proc = proc_mkdir(DRV_NAME, init_net.proc_net);
+	if (libipw_proc == NULL) {
+		LIBIPW_ERROR("Unable to create " DRV_NAME
 				" proc directory\n");
 		return -EIO;
 	}
 	e = create_proc_entry("debug_level", S_IFREG | S_IRUGO | S_IWUSR,
-			      ieee80211_proc);
+			      libipw_proc);
 	if (!e) {
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
-		ieee80211_proc = NULL;
+		libipw_proc = NULL;
 		return -EIO;
 	}
 	e->read_proc = show_debug_level;
@@ -272,13 +272,13 @@ static int __init ieee80211_init(void)
 	return 0;
 }
 
-static void __exit ieee80211_exit(void)
+static void __exit libipw_exit(void)
 {
 #ifdef CONFIG_LIBIPW_DEBUG
-	if (ieee80211_proc) {
-		remove_proc_entry("debug_level", ieee80211_proc);
+	if (libipw_proc) {
+		remove_proc_entry("debug_level", libipw_proc);
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
-		ieee80211_proc = NULL;
+		libipw_proc = NULL;
 	}
 #endif				/* CONFIG_LIBIPW_DEBUG */
 }
@@ -289,8 +289,8 @@ module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
-module_exit(ieee80211_exit);
-module_init(ieee80211_init);
+module_exit(libipw_exit);
+module_init(libipw_init);
 
 EXPORT_SYMBOL(alloc_ieee80211);
 EXPORT_SYMBOL(free_ieee80211);
diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
index dae4b8e..282b1f7 100644
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -34,18 +34,18 @@
 
 #include <net/lib80211.h>
 
-#include "ieee80211.h"
+#include "libipw.h"
 
-static void ieee80211_monitor_rx(struct ieee80211_device *ieee,
+static void libipw_monitor_rx(struct libipw_device *ieee,
 					struct sk_buff *skb,
-					struct ieee80211_rx_stats *rx_stats)
+					struct libipw_rx_stats *rx_stats)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
 	skb->dev = ieee->dev;
 	skb_reset_mac_header(skb);
-	skb_pull(skb, ieee80211_get_hdrlen(fc));
+	skb_pull(skb, libipw_get_hdrlen(fc));
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = htons(ETH_P_80211_RAW);
 	memset(skb->cb, 0, sizeof(skb->cb));
@@ -53,22 +53,22 @@ static void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 }
 
 /* Called only as a tasklet (software IRQ) */
-static struct ieee80211_frag_entry *ieee80211_frag_cache_find(struct
-							      ieee80211_device
+static struct libipw_frag_entry *libipw_frag_cache_find(struct
+							      libipw_device
 							      *ieee,
 							      unsigned int seq,
 							      unsigned int frag,
 							      u8 * src,
 							      u8 * dst)
 {
-	struct ieee80211_frag_entry *entry;
+	struct libipw_frag_entry *entry;
 	int i;
 
-	for (i = 0; i < IEEE80211_FRAG_CACHE_LEN; i++) {
+	for (i = 0; i < LIBIPW_FRAG_CACHE_LEN; i++) {
 		entry = &ieee->frag_cache[i];
 		if (entry->skb != NULL &&
 		    time_after(jiffies, entry->first_frag_time + 2 * HZ)) {
-			IEEE80211_DEBUG_FRAG("expiring fragment cache entry "
+			LIBIPW_DEBUG_FRAG("expiring fragment cache entry "
 					     "seq=%u last_frag=%u\n",
 					     entry->seq, entry->last_frag);
 			dev_kfree_skb_any(entry->skb);
@@ -86,13 +86,13 @@ static struct ieee80211_frag_entry *ieee80211_frag_cache_find(struct
 }
 
 /* Called only as a tasklet (software IRQ) */
-static struct sk_buff *ieee80211_frag_cache_get(struct ieee80211_device *ieee,
-						struct ieee80211_hdr_4addr *hdr)
+static struct sk_buff *libipw_frag_cache_get(struct libipw_device *ieee,
+						struct libipw_hdr_4addr *hdr)
 {
 	struct sk_buff *skb = NULL;
 	u16 sc;
 	unsigned int frag, seq;
-	struct ieee80211_frag_entry *entry;
+	struct libipw_frag_entry *entry;
 
 	sc = le16_to_cpu(hdr->seq_ctl);
 	frag = WLAN_GET_SEQ_FRAG(sc);
@@ -101,7 +101,7 @@ static struct sk_buff *ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 	if (frag == 0) {
 		/* Reserve enough space to fit maximum frame length */
 		skb = dev_alloc_skb(ieee->dev->mtu +
-				    sizeof(struct ieee80211_hdr_4addr) +
+				    sizeof(struct libipw_hdr_4addr) +
 				    8 /* LLC */  +
 				    2 /* alignment */  +
 				    8 /* WEP */  + ETH_ALEN /* WDS */ );
@@ -110,7 +110,7 @@ static struct sk_buff *ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 
 		entry = &ieee->frag_cache[ieee->frag_next_idx];
 		ieee->frag_next_idx++;
-		if (ieee->frag_next_idx >= IEEE80211_FRAG_CACHE_LEN)
+		if (ieee->frag_next_idx >= LIBIPW_FRAG_CACHE_LEN)
 			ieee->frag_next_idx = 0;
 
 		if (entry->skb != NULL)
@@ -125,7 +125,7 @@ static struct sk_buff *ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 	} else {
 		/* received a fragment of a frame for which the head fragment
 		 * should have already been received */
-		entry = ieee80211_frag_cache_find(ieee, seq, frag, hdr->addr2,
+		entry = libipw_frag_cache_find(ieee, seq, frag, hdr->addr2,
 						  hdr->addr1);
 		if (entry != NULL) {
 			entry->last_frag = frag;
@@ -137,21 +137,21 @@ static struct sk_buff *ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 }
 
 /* Called only as a tasklet (software IRQ) */
-static int ieee80211_frag_cache_invalidate(struct ieee80211_device *ieee,
-					   struct ieee80211_hdr_4addr *hdr)
+static int libipw_frag_cache_invalidate(struct libipw_device *ieee,
+					   struct libipw_hdr_4addr *hdr)
 {
 	u16 sc;
 	unsigned int seq;
-	struct ieee80211_frag_entry *entry;
+	struct libipw_frag_entry *entry;
 
 	sc = le16_to_cpu(hdr->seq_ctl);
 	seq = WLAN_GET_SEQ_SEQ(sc);
 
-	entry = ieee80211_frag_cache_find(ieee, seq, -1, hdr->addr2,
+	entry = libipw_frag_cache_find(ieee, seq, -1, hdr->addr2,
 					  hdr->addr1);
 
 	if (entry == NULL) {
-		IEEE80211_DEBUG_FRAG("could not invalidate fragment cache "
+		LIBIPW_DEBUG_FRAG("could not invalidate fragment cache "
 				     "entry (seq=%u)\n", seq);
 		return -1;
 	}
@@ -161,14 +161,14 @@ static int ieee80211_frag_cache_invalidate(struct ieee80211_device *ieee,
 }
 
 #ifdef NOT_YET
-/* ieee80211_rx_frame_mgtmt
+/* libipw_rx_frame_mgtmt
  *
  * Responsible for handling management control frames
  *
- * Called by ieee80211_rx */
+ * Called by libipw_rx */
 static int
-ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
-			struct ieee80211_rx_stats *rx_stats, u16 type,
+libipw_rx_frame_mgmt(struct libipw_device *ieee, struct sk_buff *skb,
+			struct libipw_rx_stats *rx_stats, u16 type,
 			u16 stype)
 {
 	if (ieee->iw_mode == IW_MODE_MASTER) {
@@ -176,7 +176,7 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 		       ieee->dev->name);
 		return 0;
 /*
-  hostap_update_sta_ps(ieee, (struct hostap_ieee80211_hdr_4addr *)
+  hostap_update_sta_ps(ieee, (struct hostap_libipw_hdr_4addr *)
   skb->data);*/
 	}
 
@@ -219,26 +219,27 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
-static unsigned char rfc1042_header[] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+static unsigned char libipw_rfc1042_header[] =
+    { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 /* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
-static unsigned char bridge_tunnel_header[] =
+static unsigned char libipw_bridge_tunnel_header[] =
     { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 /* No encapsulation header if EtherType < 0x600 (=length) */
 
-/* Called by ieee80211_rx_frame_decrypt */
-static int ieee80211_is_eapol_frame(struct ieee80211_device *ieee,
+/* Called by libipw_rx_frame_decrypt */
+static int libipw_is_eapol_frame(struct libipw_device *ieee,
 				    struct sk_buff *skb)
 {
 	struct net_device *dev = ieee->dev;
 	u16 fc, ethertype;
-	struct ieee80211_hdr_3addr *hdr;
+	struct libipw_hdr_3addr *hdr;
 	u8 *pos;
 
 	if (skb->len < 24)
 		return 0;
 
-	hdr = (struct ieee80211_hdr_3addr *)skb->data;
+	hdr = (struct libipw_hdr_3addr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_ctl);
 
 	/* check that the frame is unicast frame to us */
@@ -266,28 +267,28 @@ static int ieee80211_is_eapol_frame(struct ieee80211_device *ieee,
 	return 0;
 }
 
-/* Called only as a tasklet (software IRQ), by ieee80211_rx */
+/* Called only as a tasklet (software IRQ), by libipw_rx */
 static int
-ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
+libipw_rx_frame_decrypt(struct libipw_device *ieee, struct sk_buff *skb,
 			   struct lib80211_crypt_data *crypt)
 {
-	struct ieee80211_hdr_3addr *hdr;
+	struct libipw_hdr_3addr *hdr;
 	int res, hdrlen;
 
 	if (crypt == NULL || crypt->ops->decrypt_mpdu == NULL)
 		return 0;
 
-	hdr = (struct ieee80211_hdr_3addr *)skb->data;
-	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
+	hdr = (struct libipw_hdr_3addr *)skb->data;
+	hdrlen = libipw_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
 	atomic_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_mpdu(skb, hdrlen, crypt->priv);
 	atomic_dec(&crypt->refcnt);
 	if (res < 0) {
-		IEEE80211_DEBUG_DROP("decryption failed (SA=%pM) res=%d\n",
+		LIBIPW_DEBUG_DROP("decryption failed (SA=%pM) res=%d\n",
 				     hdr->addr2, res);
 		if (res == -2)
-			IEEE80211_DEBUG_DROP("Decryption failed ICV "
+			LIBIPW_DEBUG_DROP("Decryption failed ICV "
 					     "mismatch (key %d)\n",
 					     skb->data[hdrlen + 3] >> 6);
 		ieee->ieee_stats.rx_discards_undecryptable++;
@@ -297,20 +298,20 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 	return res;
 }
 
-/* Called only as a tasklet (software IRQ), by ieee80211_rx */
+/* Called only as a tasklet (software IRQ), by libipw_rx */
 static int
-ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device *ieee,
+libipw_rx_frame_decrypt_msdu(struct libipw_device *ieee,
 				struct sk_buff *skb, int keyidx,
 				struct lib80211_crypt_data *crypt)
 {
-	struct ieee80211_hdr_3addr *hdr;
+	struct libipw_hdr_3addr *hdr;
 	int res, hdrlen;
 
 	if (crypt == NULL || crypt->ops->decrypt_msdu == NULL)
 		return 0;
 
-	hdr = (struct ieee80211_hdr_3addr *)skb->data;
-	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
+	hdr = (struct libipw_hdr_3addr *)skb->data;
+	hdrlen = libipw_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
 	atomic_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_msdu(skb, keyidx, hdrlen, crypt->priv);
@@ -328,11 +329,11 @@ ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device *ieee,
 /* All received frames are sent to this function. @skb contains the frame in
  * IEEE 802.11 format, i.e., in the format it was sent over air.
  * This function is called only as a tasklet (software IRQ). */
-int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
-		 struct ieee80211_rx_stats *rx_stats)
+int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
+		 struct libipw_rx_stats *rx_stats)
 {
 	struct net_device *dev = ieee->dev;
-	struct ieee80211_hdr_4addr *hdr;
+	struct libipw_hdr_4addr *hdr;
 	size_t hdrlen;
 	u16 fc, type, stype, sc;
 	unsigned int frag;
@@ -352,7 +353,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	int keyidx = 0;
 	int can_be_decrypted = 0;
 
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct libipw_hdr_4addr *)skb->data;
 	if (skb->len < 10) {
 		printk(KERN_INFO "%s: SKB length < 10\n", dev->name);
 		goto rx_dropped;
@@ -363,7 +364,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	stype = WLAN_FC_GET_STYPE(fc);
 	sc = le16_to_cpu(hdr->seq_ctl);
 	frag = WLAN_GET_SEQ_FRAG(sc);
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = libipw_get_hdrlen(fc);
 
 	if (skb->len < hdrlen) {
 		printk(KERN_INFO "%s: invalid SKB length %d\n",
@@ -380,19 +381,19 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		struct iw_quality wstats;
 
 		wstats.updated = 0;
-		if (rx_stats->mask & IEEE80211_STATMASK_RSSI) {
+		if (rx_stats->mask & LIBIPW_STATMASK_RSSI) {
 			wstats.level = rx_stats->signal;
 			wstats.updated |= IW_QUAL_LEVEL_UPDATED;
 		} else
 			wstats.updated |= IW_QUAL_LEVEL_INVALID;
 
-		if (rx_stats->mask & IEEE80211_STATMASK_NOISE) {
+		if (rx_stats->mask & LIBIPW_STATMASK_NOISE) {
 			wstats.noise = rx_stats->noise;
 			wstats.updated |= IW_QUAL_NOISE_UPDATED;
 		} else
 			wstats.updated |= IW_QUAL_NOISE_INVALID;
 
-		if (rx_stats->mask & IEEE80211_STATMASK_SIGNAL) {
+		if (rx_stats->mask & LIBIPW_STATMASK_SIGNAL) {
 			wstats.qual = rx_stats->signal;
 			wstats.updated |= IW_QUAL_QUAL_UPDATED;
 		} else
@@ -411,7 +412,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		dev->stats.rx_packets++;
 		dev->stats.rx_bytes += skb->len;
-		ieee80211_monitor_rx(ieee, skb, rx_stats);
+		libipw_monitor_rx(ieee, skb, rx_stats);
 		return 1;
 	}
 
@@ -457,7 +458,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 			 * frames from other than current BSS, so just drop the
 			 * frames silently instead of filling system log with
 			 * these reports. */
-			IEEE80211_DEBUG_DROP("Decryption failed (not set)"
+			LIBIPW_DEBUG_DROP("Decryption failed (not set)"
 					     " (SA=%pM)\n", hdr->addr2);
 			ieee->ieee_stats.rx_discards_undecryptable++;
 			goto rx_dropped;
@@ -475,7 +476,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 			goto rx_dropped;
 		}
 
-		if (ieee80211_rx_frame_mgmt(ieee, skb, rx_stats, type, stype))
+		if (libipw_rx_frame_mgmt(ieee, skb, rx_stats, type, stype))
 			goto rx_dropped;
 		else
 			goto rx_exit;
@@ -488,7 +489,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		ieee->prev_seq_ctl = sc;
 
 	/* Data frame - extract src/dst addresses */
-	if (skb->len < IEEE80211_3ADDR_LEN)
+	if (skb->len < LIBIPW_3ADDR_LEN)
 		goto rx_dropped;
 
 	switch (fc & (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
@@ -501,7 +502,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		memcpy(src, hdr->addr2, ETH_ALEN);
 		break;
 	case IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS:
-		if (skb->len < IEEE80211_4ADDR_LEN)
+		if (skb->len < LIBIPW_4ADDR_LEN)
 			goto rx_dropped;
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr4, ETH_ALEN);
@@ -560,7 +561,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	    stype != IEEE80211_STYPE_DATA_CFPOLL &&
 	    stype != IEEE80211_STYPE_DATA_CFACKPOLL) {
 		if (stype != IEEE80211_STYPE_NULLFUNC)
-			IEEE80211_DEBUG_DROP("RX: dropped data frame "
+			LIBIPW_DEBUG_DROP("RX: dropped data frame "
 					     "with no data (type=0x%02x, "
 					     "subtype=0x%02x, len=%d)\n",
 					     type, stype, skb->len);
@@ -570,21 +571,21 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	/* skb: hdr + (possibly fragmented, possibly encrypted) payload */
 
 	if ((fc & IEEE80211_FCTL_PROTECTED) && can_be_decrypted &&
-	    (keyidx = ieee80211_rx_frame_decrypt(ieee, skb, crypt)) < 0)
+	    (keyidx = libipw_rx_frame_decrypt(ieee, skb, crypt)) < 0)
 		goto rx_dropped;
 
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct libipw_hdr_4addr *)skb->data;
 
 	/* skb: hdr + (possibly fragmented) plaintext payload */
 	// PR: FIXME: hostap has additional conditions in the "if" below:
 	// ieee->host_decrypt && (fc & IEEE80211_FCTL_PROTECTED) &&
 	if ((frag != 0) || (fc & IEEE80211_FCTL_MOREFRAGS)) {
 		int flen;
-		struct sk_buff *frag_skb = ieee80211_frag_cache_get(ieee, hdr);
-		IEEE80211_DEBUG_FRAG("Rx Fragment received (%u)\n", frag);
+		struct sk_buff *frag_skb = libipw_frag_cache_get(ieee, hdr);
+		LIBIPW_DEBUG_FRAG("Rx Fragment received (%u)\n", frag);
 
 		if (!frag_skb) {
-			IEEE80211_DEBUG(IEEE80211_DL_RX | IEEE80211_DL_FRAG,
+			LIBIPW_DEBUG(LIBIPW_DL_RX | LIBIPW_DL_FRAG,
 					"Rx cannot get skb from fragment "
 					"cache (morefrag=%d seq=%u frag=%u)\n",
 					(fc & IEEE80211_FCTL_MOREFRAGS) != 0,
@@ -600,7 +601,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 			printk(KERN_WARNING "%s: host decrypted and "
 			       "reassembled frame did not fit skb\n",
 			       dev->name);
-			ieee80211_frag_cache_invalidate(ieee, hdr);
+			libipw_frag_cache_invalidate(ieee, hdr);
 			goto rx_dropped;
 		}
 
@@ -627,24 +628,24 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		/* this was the last fragment and the frame will be
 		 * delivered, so remove skb from fragment cache */
 		skb = frag_skb;
-		hdr = (struct ieee80211_hdr_4addr *)skb->data;
-		ieee80211_frag_cache_invalidate(ieee, hdr);
+		hdr = (struct libipw_hdr_4addr *)skb->data;
+		libipw_frag_cache_invalidate(ieee, hdr);
 	}
 
 	/* skb: hdr + (possible reassembled) full MSDU payload; possibly still
 	 * encrypted/authenticated */
 	if ((fc & IEEE80211_FCTL_PROTECTED) && can_be_decrypted &&
-	    ieee80211_rx_frame_decrypt_msdu(ieee, skb, keyidx, crypt))
+	    libipw_rx_frame_decrypt_msdu(ieee, skb, keyidx, crypt))
 		goto rx_dropped;
 
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct libipw_hdr_4addr *)skb->data;
 	if (crypt && !(fc & IEEE80211_FCTL_PROTECTED) && !ieee->open_wep) {
 		if (		/*ieee->ieee802_1x && */
-			   ieee80211_is_eapol_frame(ieee, skb)) {
+			   libipw_is_eapol_frame(ieee, skb)) {
 			/* pass unencrypted EAPOL frames even if encryption is
 			 * configured */
 		} else {
-			IEEE80211_DEBUG_DROP("encryption configured, but RX "
+			LIBIPW_DEBUG_DROP("encryption configured, but RX "
 					     "frame not encrypted (SA=%pM)\n",
 					     hdr->addr2);
 			goto rx_dropped;
@@ -652,8 +653,8 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	}
 
 	if (crypt && !(fc & IEEE80211_FCTL_PROTECTED) && !ieee->open_wep &&
-	    !ieee80211_is_eapol_frame(ieee, skb)) {
-		IEEE80211_DEBUG_DROP("dropped unencrypted RX data "
+	    !libipw_is_eapol_frame(ieee, skb)) {
+		LIBIPW_DEBUG_DROP("dropped unencrypted RX data "
 				     "frame from %pM (drop_unencrypted=1)\n",
 				     hdr->addr2);
 		goto rx_dropped;
@@ -736,9 +737,9 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 	/* convert hdr + possible LLC headers into Ethernet header */
 	if (skb->len - hdrlen >= 8 &&
-	    ((memcmp(payload, rfc1042_header, SNAP_SIZE) == 0 &&
+	    ((memcmp(payload, libipw_rfc1042_header, SNAP_SIZE) == 0 &&
 	      ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
-	     memcmp(payload, bridge_tunnel_header, SNAP_SIZE) == 0)) {
+	     memcmp(payload, libipw_bridge_tunnel_header, SNAP_SIZE) == 0)) {
 		/* remove RFC1042 or Bridge-Tunnel encapsulation and
 		 * replace EtherType */
 		skb_pull(skb, hdrlen + SNAP_SIZE);
@@ -807,7 +808,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 			/* netif_rx always succeeds, but it might drop
 			 * the packet.  If it drops the packet, we log that
 			 * in our stats. */
-			IEEE80211_DEBUG_DROP
+			LIBIPW_DEBUG_DROP
 			    ("RX: netif_rx dropped the packet\n");
 			dev->stats.rx_dropped++;
 		}
@@ -829,18 +830,18 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	return 0;
 }
 
-/* Filter out unrelated packets, call ieee80211_rx[_mgt]
+/* Filter out unrelated packets, call libipw_rx[_mgt]
  * This function takes over the skb, it should not be used again after calling
  * this function. */
-void ieee80211_rx_any(struct ieee80211_device *ieee,
-		     struct sk_buff *skb, struct ieee80211_rx_stats *stats)
+void libipw_rx_any(struct libipw_device *ieee,
+		     struct sk_buff *skb, struct libipw_rx_stats *stats)
 {
-	struct ieee80211_hdr_4addr *hdr;
+	struct libipw_hdr_4addr *hdr;
 	int is_packet_for_us;
 	u16 fc;
 
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
-		if (!ieee80211_rx(ieee, skb, stats))
+		if (!libipw_rx(ieee, skb, stats))
 			dev_kfree_skb_irq(skb);
 		return;
 	}
@@ -848,7 +849,7 @@ void ieee80211_rx_any(struct ieee80211_device *ieee,
 	if (skb->len < sizeof(struct ieee80211_hdr))
 		goto drop_free;
 
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct libipw_hdr_4addr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_ctl);
 
 	if ((fc & IEEE80211_FCTL_VERS) != 0)
@@ -856,9 +857,9 @@ void ieee80211_rx_any(struct ieee80211_device *ieee,
 
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
-		if (skb->len < sizeof(struct ieee80211_hdr_3addr))
+		if (skb->len < sizeof(struct libipw_hdr_3addr))
 			goto drop_free;
-		ieee80211_rx_mgt(ieee, hdr, stats);
+		libipw_rx_mgt(ieee, hdr, stats);
 		dev_kfree_skb_irq(skb);
 		return;
 	case IEEE80211_FTYPE_DATA:
@@ -910,7 +911,7 @@ void ieee80211_rx_any(struct ieee80211_device *ieee,
 	}
 
 	if (is_packet_for_us)
-		if (!ieee80211_rx(ieee, skb, stats))
+		if (!libipw_rx(ieee, skb, stats))
 			dev_kfree_skb_irq(skb);
 	return;
 
@@ -928,7 +929,7 @@ static u8 qos_oui[QOS_OUI_LEN] = { 0x00, 0x50, 0xF2 };
 * Make ther structure we read from the beacon packet has
 * the right values
 */
-static int ieee80211_verify_qos_info(struct ieee80211_qos_information_element
+static int libipw_verify_qos_info(struct libipw_qos_information_element
 				     *info_element, int sub_type)
 {
 
@@ -947,12 +948,12 @@ static int ieee80211_verify_qos_info(struct ieee80211_qos_information_element
 /*
  * Parse a QoS parameter element
  */
-static int ieee80211_read_qos_param_element(struct ieee80211_qos_parameter_info
-					    *element_param, struct ieee80211_info_element
+static int libipw_read_qos_param_element(struct libipw_qos_parameter_info
+					    *element_param, struct libipw_info_element
 					    *info_element)
 {
 	int ret = 0;
-	u16 size = sizeof(struct ieee80211_qos_parameter_info) - 2;
+	u16 size = sizeof(struct libipw_qos_parameter_info) - 2;
 
 	if ((info_element == NULL) || (element_param == NULL))
 		return -1;
@@ -965,7 +966,7 @@ static int ieee80211_read_qos_param_element(struct ieee80211_qos_parameter_info
 	} else
 		ret = -1;
 	if (ret == 0)
-		ret = ieee80211_verify_qos_info(&element_param->info_element,
+		ret = libipw_verify_qos_info(&element_param->info_element,
 						QOS_OUI_PARAM_SUB_TYPE);
 	return ret;
 }
@@ -973,13 +974,13 @@ static int ieee80211_read_qos_param_element(struct ieee80211_qos_parameter_info
 /*
  * Parse a QoS information element
  */
-static int ieee80211_read_qos_info_element(struct
-					   ieee80211_qos_information_element
-					   *element_info, struct ieee80211_info_element
+static int libipw_read_qos_info_element(struct
+					   libipw_qos_information_element
+					   *element_info, struct libipw_info_element
 					   *info_element)
 {
 	int ret = 0;
-	u16 size = sizeof(struct ieee80211_qos_information_element) - 2;
+	u16 size = sizeof(struct libipw_qos_information_element) - 2;
 
 	if (element_info == NULL)
 		return -1;
@@ -995,7 +996,7 @@ static int ieee80211_read_qos_info_element(struct
 		ret = -1;
 
 	if (ret == 0)
-		ret = ieee80211_verify_qos_info(element_info,
+		ret = libipw_verify_qos_info(element_info,
 						QOS_OUI_INFO_SUB_TYPE);
 	return ret;
 }
@@ -1003,15 +1004,15 @@ static int ieee80211_read_qos_info_element(struct
 /*
  * Write QoS parameters from the ac parameters.
  */
-static int ieee80211_qos_convert_ac_to_parameters(struct
-						  ieee80211_qos_parameter_info
+static int libipw_qos_convert_ac_to_parameters(struct
+						  libipw_qos_parameter_info
 						  *param_elm, struct
-						  ieee80211_qos_parameters
+						  libipw_qos_parameters
 						  *qos_param)
 {
 	int rc = 0;
 	int i;
-	struct ieee80211_qos_ac_parameter *ac_params;
+	struct libipw_qos_ac_parameter *ac_params;
 	u32 txop;
 	u8 cw_min;
 	u8 cw_max;
@@ -1042,27 +1043,27 @@ static int ieee80211_qos_convert_ac_to_parameters(struct
  * parameters element. check the information element length to decide
  * which type to read
  */
-static int ieee80211_parse_qos_info_param_IE(struct ieee80211_info_element
+static int libipw_parse_qos_info_param_IE(struct libipw_info_element
 					     *info_element,
-					     struct ieee80211_network *network)
+					     struct libipw_network *network)
 {
 	int rc = 0;
-	struct ieee80211_qos_parameters *qos_param = NULL;
-	struct ieee80211_qos_information_element qos_info_element;
+	struct libipw_qos_parameters *qos_param = NULL;
+	struct libipw_qos_information_element qos_info_element;
 
-	rc = ieee80211_read_qos_info_element(&qos_info_element, info_element);
+	rc = libipw_read_qos_info_element(&qos_info_element, info_element);
 
 	if (rc == 0) {
 		network->qos_data.param_count = qos_info_element.ac_info & 0x0F;
 		network->flags |= NETWORK_HAS_QOS_INFORMATION;
 	} else {
-		struct ieee80211_qos_parameter_info param_element;
+		struct libipw_qos_parameter_info param_element;
 
-		rc = ieee80211_read_qos_param_element(&param_element,
+		rc = libipw_read_qos_param_element(&param_element,
 						      info_element);
 		if (rc == 0) {
 			qos_param = &(network->qos_data.parameters);
-			ieee80211_qos_convert_ac_to_parameters(&param_element,
+			libipw_qos_convert_ac_to_parameters(&param_element,
 							       qos_param);
 			network->flags |= NETWORK_HAS_QOS_PARAMETERS;
 			network->qos_data.param_count =
@@ -1071,7 +1072,7 @@ static int ieee80211_parse_qos_info_param_IE(struct ieee80211_info_element
 	}
 
 	if (rc == 0) {
-		IEEE80211_DEBUG_QOS("QoS is supported\n");
+		LIBIPW_DEBUG_QOS("QoS is supported\n");
 		network->qos_data.supported = 1;
 	}
 	return rc;
@@ -1116,9 +1117,9 @@ static const char *get_info_element_string(u16 id)
 }
 #endif
 
-static int ieee80211_parse_info_param(struct ieee80211_info_element
+static int libipw_parse_info_param(struct libipw_info_element
 				      *info_element, u16 length,
-				      struct ieee80211_network *network)
+				      struct libipw_network *network)
 {
 	DECLARE_SSID_BUF(ssid);
 	u8 i;
@@ -1129,7 +1130,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 
 	while (length >= sizeof(*info_element)) {
 		if (sizeof(*info_element) + info_element->len > length) {
-			IEEE80211_DEBUG_MGMT("Info elem: parse failed: "
+			LIBIPW_DEBUG_MGMT("Info elem: parse failed: "
 					     "info_element->len + 2 > left : "
 					     "info_element->len+2=%zd left=%d, id=%d.\n",
 					     info_element->len +
@@ -1151,7 +1152,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 				memset(network->ssid + network->ssid_len, 0,
 				       IW_ESSID_MAX_SIZE - network->ssid_len);
 
-			IEEE80211_DEBUG_MGMT("WLAN_EID_SSID: '%s' len=%d.\n",
+			LIBIPW_DEBUG_MGMT("WLAN_EID_SSID: '%s' len=%d.\n",
 					     print_ssid(ssid, network->ssid,
 							network->ssid_len),
 					     network->ssid_len);
@@ -1170,17 +1171,17 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 					      (p - rates_str), "%02X ",
 					      network->rates[i]);
 #endif
-				if (ieee80211_is_ofdm_rate
+				if (libipw_is_ofdm_rate
 				    (info_element->data[i])) {
 					network->flags |= NETWORK_HAS_OFDM;
 					if (info_element->data[i] &
-					    IEEE80211_BASIC_RATE_MASK)
+					    LIBIPW_BASIC_RATE_MASK)
 						network->flags &=
 						    ~NETWORK_HAS_CCK;
 				}
 			}
 
-			IEEE80211_DEBUG_MGMT("WLAN_EID_SUPP_RATES: '%s' (%d)\n",
+			LIBIPW_DEBUG_MGMT("WLAN_EID_SUPP_RATES: '%s' (%d)\n",
 					     rates_str, network->rates_len);
 			break;
 
@@ -1197,61 +1198,61 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 					      (p - rates_str), "%02X ",
 					      network->rates[i]);
 #endif
-				if (ieee80211_is_ofdm_rate
+				if (libipw_is_ofdm_rate
 				    (info_element->data[i])) {
 					network->flags |= NETWORK_HAS_OFDM;
 					if (info_element->data[i] &
-					    IEEE80211_BASIC_RATE_MASK)
+					    LIBIPW_BASIC_RATE_MASK)
 						network->flags &=
 						    ~NETWORK_HAS_CCK;
 				}
 			}
 
-			IEEE80211_DEBUG_MGMT("WLAN_EID_EXT_SUPP_RATES: '%s' (%d)\n",
+			LIBIPW_DEBUG_MGMT("WLAN_EID_EXT_SUPP_RATES: '%s' (%d)\n",
 					     rates_str, network->rates_ex_len);
 			break;
 
 		case WLAN_EID_DS_PARAMS:
-			IEEE80211_DEBUG_MGMT("WLAN_EID_DS_PARAMS: %d\n",
+			LIBIPW_DEBUG_MGMT("WLAN_EID_DS_PARAMS: %d\n",
 					     info_element->data[0]);
 			network->channel = info_element->data[0];
 			break;
 
 		case WLAN_EID_FH_PARAMS:
-			IEEE80211_DEBUG_MGMT("WLAN_EID_FH_PARAMS: ignored\n");
+			LIBIPW_DEBUG_MGMT("WLAN_EID_FH_PARAMS: ignored\n");
 			break;
 
 		case WLAN_EID_CF_PARAMS:
-			IEEE80211_DEBUG_MGMT("WLAN_EID_CF_PARAMS: ignored\n");
+			LIBIPW_DEBUG_MGMT("WLAN_EID_CF_PARAMS: ignored\n");
 			break;
 
 		case WLAN_EID_TIM:
 			network->tim.tim_count = info_element->data[0];
 			network->tim.tim_period = info_element->data[1];
-			IEEE80211_DEBUG_MGMT("WLAN_EID_TIM: partially ignored\n");
+			LIBIPW_DEBUG_MGMT("WLAN_EID_TIM: partially ignored\n");
 			break;
 
 		case WLAN_EID_ERP_INFO:
 			network->erp_value = info_element->data[0];
 			network->flags |= NETWORK_HAS_ERP_VALUE;
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_ERP_SET: %d\n",
+			LIBIPW_DEBUG_MGMT("MFIE_TYPE_ERP_SET: %d\n",
 					     network->erp_value);
 			break;
 
 		case WLAN_EID_IBSS_PARAMS:
 			network->atim_window = info_element->data[0];
-			IEEE80211_DEBUG_MGMT("WLAN_EID_IBSS_PARAMS: %d\n",
+			LIBIPW_DEBUG_MGMT("WLAN_EID_IBSS_PARAMS: %d\n",
 					     network->atim_window);
 			break;
 
 		case WLAN_EID_CHALLENGE:
-			IEEE80211_DEBUG_MGMT("WLAN_EID_CHALLENGE: ignored\n");
+			LIBIPW_DEBUG_MGMT("WLAN_EID_CHALLENGE: ignored\n");
 			break;
 
 		case WLAN_EID_GENERIC:
-			IEEE80211_DEBUG_MGMT("WLAN_EID_GENERIC: %d bytes\n",
+			LIBIPW_DEBUG_MGMT("WLAN_EID_GENERIC: %d bytes\n",
 					     info_element->len);
-			if (!ieee80211_parse_qos_info_param_IE(info_element,
+			if (!libipw_parse_qos_info_param_IE(info_element,
 							       network))
 				break;
 
@@ -1268,7 +1269,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			break;
 
 		case WLAN_EID_RSN:
-			IEEE80211_DEBUG_MGMT("WLAN_EID_RSN: %d bytes\n",
+			LIBIPW_DEBUG_MGMT("WLAN_EID_RSN: %d bytes\n",
 					     info_element->len);
 			network->rsn_ie_len = min(info_element->len + 2,
 						  MAX_WPA_IE_LEN);
@@ -1318,7 +1319,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			break;
 
 		default:
-			IEEE80211_DEBUG_MGMT
+			LIBIPW_DEBUG_MGMT
 			    ("Unsupported info element: %s (%d)\n",
 			     get_info_element_string(info_element->id),
 			     info_element->id);
@@ -1327,20 +1328,20 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 
 		length -= sizeof(*info_element) + info_element->len;
 		info_element =
-		    (struct ieee80211_info_element *)&info_element->
+		    (struct libipw_info_element *)&info_element->
 		    data[info_element->len];
 	}
 
 	return 0;
 }
 
-static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct ieee80211_assoc_response
-				       *frame, struct ieee80211_rx_stats *stats)
+static int libipw_handle_assoc_resp(struct libipw_device *ieee, struct libipw_assoc_response
+				       *frame, struct libipw_rx_stats *stats)
 {
-	struct ieee80211_network network_resp = {
+	struct libipw_network network_resp = {
 		.ibss_dfs = NULL,
 	};
-	struct ieee80211_network *network = &network_resp;
+	struct libipw_network *network = &network_resp;
 	struct net_device *dev = ieee->dev;
 
 	network->flags = 0;
@@ -1361,7 +1362,7 @@ static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct iee
 	network->erp_value =
 	    (network->capability & WLAN_CAPABILITY_IBSS) ? 0x3 : 0x0;
 
-	if (stats->freq == IEEE80211_52GHZ_BAND) {
+	if (stats->freq == LIBIPW_52GHZ_BAND) {
 		/* for A band (No DS info) */
 		network->channel = stats->received_channel;
 	} else
@@ -1370,12 +1371,12 @@ static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct iee
 	network->wpa_ie_len = 0;
 	network->rsn_ie_len = 0;
 
-	if (ieee80211_parse_info_param
+	if (libipw_parse_info_param
 	    (frame->info_element, stats->len - sizeof(*frame), network))
 		return 1;
 
 	network->mode = 0;
-	if (stats->freq == IEEE80211_52GHZ_BAND)
+	if (stats->freq == LIBIPW_52GHZ_BAND)
 		network->mode = IEEE_A;
 	else {
 		if (network->flags & NETWORK_HAS_OFDM)
@@ -1394,10 +1395,10 @@ static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct iee
 
 /***************************************************/
 
-static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee80211_probe_response
+static int libipw_network_init(struct libipw_device *ieee, struct libipw_probe_response
 					 *beacon,
-					 struct ieee80211_network *network,
-					 struct ieee80211_rx_stats *stats)
+					 struct libipw_network *network,
+					 struct libipw_rx_stats *stats)
 {
 	DECLARE_SSID_BUF(ssid);
 
@@ -1423,7 +1424,7 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 	network->erp_value = (network->capability & WLAN_CAPABILITY_IBSS) ?
 	    0x3 : 0x0;
 
-	if (stats->freq == IEEE80211_52GHZ_BAND) {
+	if (stats->freq == LIBIPW_52GHZ_BAND) {
 		/* for A band (No DS info) */
 		network->channel = stats->received_channel;
 	} else
@@ -1432,12 +1433,12 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 	network->wpa_ie_len = 0;
 	network->rsn_ie_len = 0;
 
-	if (ieee80211_parse_info_param
+	if (libipw_parse_info_param
 	    (beacon->info_element, stats->len - sizeof(*beacon), network))
 		return 1;
 
 	network->mode = 0;
-	if (stats->freq == IEEE80211_52GHZ_BAND)
+	if (stats->freq == LIBIPW_52GHZ_BAND)
 		network->mode = IEEE_A;
 	else {
 		if (network->flags & NETWORK_HAS_OFDM)
@@ -1447,7 +1448,7 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 	}
 
 	if (network->mode == 0) {
-		IEEE80211_DEBUG_SCAN("Filtered out '%s (%pM)' "
+		LIBIPW_DEBUG_SCAN("Filtered out '%s (%pM)' "
 				     "network.\n",
 				     print_ssid(ssid, network->ssid,
 						 network->ssid_len),
@@ -1460,8 +1461,8 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 	return 0;
 }
 
-static inline int is_same_network(struct ieee80211_network *src,
-				  struct ieee80211_network *dst)
+static inline int is_same_network(struct libipw_network *src,
+				  struct libipw_network *dst)
 {
 	/* A network is only a duplicate if the channel, BSSID, and ESSID
 	 * all match.  We treat all <hidden> with the same BSSID and channel
@@ -1472,13 +1473,13 @@ static inline int is_same_network(struct ieee80211_network *src,
 		!memcmp(src->ssid, dst->ssid, src->ssid_len));
 }
 
-static void update_network(struct ieee80211_network *dst,
-				  struct ieee80211_network *src)
+static void update_network(struct libipw_network *dst,
+				  struct libipw_network *src)
 {
 	int qos_active;
 	u8 old_param;
 
-	ieee80211_network_reset(dst);
+	libipw_network_reset(dst);
 	dst->ibss_dfs = src->ibss_dfs;
 
 	/* We only update the statistics if they were created by receiving
@@ -1488,9 +1489,9 @@ static void update_network(struct ieee80211_network *dst,
 	 * down the signal level of an AP. */
 	if (dst->channel == src->stats.received_channel)
 		memcpy(&dst->stats, &src->stats,
-		       sizeof(struct ieee80211_rx_stats));
+		       sizeof(struct libipw_rx_stats));
 	else
-		IEEE80211_DEBUG_SCAN("Network %pM info received "
+		LIBIPW_DEBUG_SCAN("Network %pM info received "
 			"off channel (%d vs. %d)\n", src->bssid,
 			dst->channel, src->stats.received_channel);
 
@@ -1521,7 +1522,7 @@ static void update_network(struct ieee80211_network *dst,
 	old_param = dst->qos_data.old_param_count;
 	if (dst->flags & NETWORK_HAS_QOS_MASK)
 		memcpy(&dst->qos_data, &src->qos_data,
-		       sizeof(struct ieee80211_qos_data));
+		       sizeof(struct libipw_qos_data));
 	else {
 		dst->qos_data.supported = src->qos_data.supported;
 		dst->qos_data.param_count = src->qos_data.param_count;
@@ -1529,11 +1530,11 @@ static void update_network(struct ieee80211_network *dst,
 
 	if (dst->qos_data.supported == 1) {
 		if (dst->ssid_len)
-			IEEE80211_DEBUG_QOS
+			LIBIPW_DEBUG_QOS
 			    ("QoS the network %s is QoS supported\n",
 			     dst->ssid);
 		else
-			IEEE80211_DEBUG_QOS
+			LIBIPW_DEBUG_QOS
 			    ("QoS the network is QoS supported\n");
 	}
 	dst->qos_data.active = qos_active;
@@ -1547,25 +1548,25 @@ static inline int is_beacon(__le16 fc)
 	return (WLAN_FC_GET_STYPE(le16_to_cpu(fc)) == IEEE80211_STYPE_BEACON);
 }
 
-static void ieee80211_process_probe_response(struct ieee80211_device
+static void libipw_process_probe_response(struct libipw_device
 						    *ieee, struct
-						    ieee80211_probe_response
-						    *beacon, struct ieee80211_rx_stats
+						    libipw_probe_response
+						    *beacon, struct libipw_rx_stats
 						    *stats)
 {
 	struct net_device *dev = ieee->dev;
-	struct ieee80211_network network = {
+	struct libipw_network network = {
 		.ibss_dfs = NULL,
 	};
-	struct ieee80211_network *target;
-	struct ieee80211_network *oldest = NULL;
+	struct libipw_network *target;
+	struct libipw_network *oldest = NULL;
 #ifdef CONFIG_LIBIPW_DEBUG
-	struct ieee80211_info_element *info_element = beacon->info_element;
+	struct libipw_info_element *info_element = beacon->info_element;
 #endif
 	unsigned long flags;
 	DECLARE_SSID_BUF(ssid);
 
-	IEEE80211_DEBUG_SCAN("'%s' (%pM"
+	LIBIPW_DEBUG_SCAN("'%s' (%pM"
 		     "): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
 		     print_ssid(ssid, info_element->data, info_element->len),
 		     beacon->header.addr3,
@@ -1586,8 +1587,8 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 		     (beacon->capability & cpu_to_le16(1 << 0x1)) ? '1' : '0',
 		     (beacon->capability & cpu_to_le16(1 << 0x0)) ? '1' : '0');
 
-	if (ieee80211_network_init(ieee, beacon, &network, stats)) {
-		IEEE80211_DEBUG_SCAN("Dropped '%s' (%pM) via %s.\n",
+	if (libipw_network_init(ieee, beacon, &network, stats)) {
+		LIBIPW_DEBUG_SCAN("Dropped '%s' (%pM) via %s.\n",
 				     print_ssid(ssid, info_element->data,
 						 info_element->len),
 				     beacon->header.addr3,
@@ -1624,21 +1625,21 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 			/* If there are no more slots, expire the oldest */
 			list_del(&oldest->list);
 			target = oldest;
-			IEEE80211_DEBUG_SCAN("Expired '%s' (%pM) from "
+			LIBIPW_DEBUG_SCAN("Expired '%s' (%pM) from "
 					     "network list.\n",
 					     print_ssid(ssid, target->ssid,
 							 target->ssid_len),
 					     target->bssid);
-			ieee80211_network_reset(target);
+			libipw_network_reset(target);
 		} else {
 			/* Otherwise just pull from the free list */
 			target = list_entry(ieee->network_free_list.next,
-					    struct ieee80211_network, list);
+					    struct libipw_network, list);
 			list_del(ieee->network_free_list.next);
 		}
 
 #ifdef CONFIG_LIBIPW_DEBUG
-		IEEE80211_DEBUG_SCAN("Adding '%s' (%pM) via %s.\n",
+		LIBIPW_DEBUG_SCAN("Adding '%s' (%pM) via %s.\n",
 				     print_ssid(ssid, network.ssid,
 						 network.ssid_len),
 				     network.bssid,
@@ -1649,7 +1650,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 		network.ibss_dfs = NULL;
 		list_add_tail(&target->list, &ieee->network_list);
 	} else {
-		IEEE80211_DEBUG_SCAN("Updating '%s' (%pM) via %s.\n",
+		LIBIPW_DEBUG_SCAN("Updating '%s' (%pM) via %s.\n",
 				     print_ssid(ssid, target->ssid,
 						 target->ssid_len),
 				     target->bssid,
@@ -1670,121 +1671,121 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 	}
 }
 
-void ieee80211_rx_mgt(struct ieee80211_device *ieee,
-		      struct ieee80211_hdr_4addr *header,
-		      struct ieee80211_rx_stats *stats)
+void libipw_rx_mgt(struct libipw_device *ieee,
+		      struct libipw_hdr_4addr *header,
+		      struct libipw_rx_stats *stats)
 {
 	switch (WLAN_FC_GET_STYPE(le16_to_cpu(header->frame_ctl))) {
 	case IEEE80211_STYPE_ASSOC_RESP:
-		IEEE80211_DEBUG_MGMT("received ASSOCIATION RESPONSE (%d)\n",
+		LIBIPW_DEBUG_MGMT("received ASSOCIATION RESPONSE (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
-		ieee80211_handle_assoc_resp(ieee,
-					    (struct ieee80211_assoc_response *)
+		libipw_handle_assoc_resp(ieee,
+					    (struct libipw_assoc_response *)
 					    header, stats);
 		break;
 
 	case IEEE80211_STYPE_REASSOC_RESP:
-		IEEE80211_DEBUG_MGMT("received REASSOCIATION RESPONSE (%d)\n",
+		LIBIPW_DEBUG_MGMT("received REASSOCIATION RESPONSE (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
 		break;
 
 	case IEEE80211_STYPE_PROBE_REQ:
-		IEEE80211_DEBUG_MGMT("received auth (%d)\n",
+		LIBIPW_DEBUG_MGMT("received auth (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
 
 		if (ieee->handle_probe_request != NULL)
 			ieee->handle_probe_request(ieee->dev,
 						   (struct
-						    ieee80211_probe_request *)
+						    libipw_probe_request *)
 						   header, stats);
 		break;
 
 	case IEEE80211_STYPE_PROBE_RESP:
-		IEEE80211_DEBUG_MGMT("received PROBE RESPONSE (%d)\n",
+		LIBIPW_DEBUG_MGMT("received PROBE RESPONSE (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
-		IEEE80211_DEBUG_SCAN("Probe response\n");
-		ieee80211_process_probe_response(ieee,
+		LIBIPW_DEBUG_SCAN("Probe response\n");
+		libipw_process_probe_response(ieee,
 						 (struct
-						  ieee80211_probe_response *)
+						  libipw_probe_response *)
 						 header, stats);
 		break;
 
 	case IEEE80211_STYPE_BEACON:
-		IEEE80211_DEBUG_MGMT("received BEACON (%d)\n",
+		LIBIPW_DEBUG_MGMT("received BEACON (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
-		IEEE80211_DEBUG_SCAN("Beacon\n");
-		ieee80211_process_probe_response(ieee,
+		LIBIPW_DEBUG_SCAN("Beacon\n");
+		libipw_process_probe_response(ieee,
 						 (struct
-						  ieee80211_probe_response *)
+						  libipw_probe_response *)
 						 header, stats);
 		break;
 	case IEEE80211_STYPE_AUTH:
 
-		IEEE80211_DEBUG_MGMT("received auth (%d)\n",
+		LIBIPW_DEBUG_MGMT("received auth (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
 
 		if (ieee->handle_auth != NULL)
 			ieee->handle_auth(ieee->dev,
-					  (struct ieee80211_auth *)header);
+					  (struct libipw_auth *)header);
 		break;
 
 	case IEEE80211_STYPE_DISASSOC:
 		if (ieee->handle_disassoc != NULL)
 			ieee->handle_disassoc(ieee->dev,
-					      (struct ieee80211_disassoc *)
+					      (struct libipw_disassoc *)
 					      header);
 		break;
 
 	case IEEE80211_STYPE_ACTION:
-		IEEE80211_DEBUG_MGMT("ACTION\n");
+		LIBIPW_DEBUG_MGMT("ACTION\n");
 		if (ieee->handle_action)
 			ieee->handle_action(ieee->dev,
-					    (struct ieee80211_action *)
+					    (struct libipw_action *)
 					    header, stats);
 		break;
 
 	case IEEE80211_STYPE_REASSOC_REQ:
-		IEEE80211_DEBUG_MGMT("received reassoc (%d)\n",
+		LIBIPW_DEBUG_MGMT("received reassoc (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
 
-		IEEE80211_DEBUG_MGMT("%s: IEEE80211_REASSOC_REQ received\n",
+		LIBIPW_DEBUG_MGMT("%s: LIBIPW_REASSOC_REQ received\n",
 				     ieee->dev->name);
 		if (ieee->handle_reassoc_request != NULL)
 			ieee->handle_reassoc_request(ieee->dev,
-						    (struct ieee80211_reassoc_request *)
+						    (struct libipw_reassoc_request *)
 						     header);
 		break;
 
 	case IEEE80211_STYPE_ASSOC_REQ:
-		IEEE80211_DEBUG_MGMT("received assoc (%d)\n",
+		LIBIPW_DEBUG_MGMT("received assoc (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
 
-		IEEE80211_DEBUG_MGMT("%s: IEEE80211_ASSOC_REQ received\n",
+		LIBIPW_DEBUG_MGMT("%s: LIBIPW_ASSOC_REQ received\n",
 				     ieee->dev->name);
 		if (ieee->handle_assoc_request != NULL)
 			ieee->handle_assoc_request(ieee->dev);
 		break;
 
 	case IEEE80211_STYPE_DEAUTH:
-		IEEE80211_DEBUG_MGMT("DEAUTH\n");
+		LIBIPW_DEBUG_MGMT("DEAUTH\n");
 		if (ieee->handle_deauth != NULL)
 			ieee->handle_deauth(ieee->dev,
-					    (struct ieee80211_deauth *)
+					    (struct libipw_deauth *)
 					    header);
 		break;
 	default:
-		IEEE80211_DEBUG_MGMT("received UNKNOWN (%d)\n",
+		LIBIPW_DEBUG_MGMT("received UNKNOWN (%d)\n",
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
-		IEEE80211_DEBUG_MGMT("%s: Unknown management packet: %d\n",
+		LIBIPW_DEBUG_MGMT("%s: Unknown management packet: %d\n",
 				     ieee->dev->name,
 				     WLAN_FC_GET_STYPE(le16_to_cpu
 						       (header->frame_ctl)));
@@ -1792,6 +1793,6 @@ void ieee80211_rx_mgt(struct ieee80211_device *ieee,
 	}
 }
 
-EXPORT_SYMBOL_GPL(ieee80211_rx_any);
-EXPORT_SYMBOL(ieee80211_rx_mgt);
-EXPORT_SYMBOL(ieee80211_rx);
+EXPORT_SYMBOL_GPL(libipw_rx_any);
+EXPORT_SYMBOL(libipw_rx_mgt);
+EXPORT_SYMBOL(libipw_rx);
diff --git a/drivers/net/wireless/ipw2x00/libipw_tx.c b/drivers/net/wireless/ipw2x00/libipw_tx.c
index da2ad54..3b807be 100644
--- a/drivers/net/wireless/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_tx.c
@@ -41,7 +41,7 @@
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
 
-#include "ieee80211.h"
+#include "libipw.h"
 
 /*
 
@@ -126,12 +126,12 @@ payload of each frame is reduced to 492 bytes.
 static u8 P802_1H_OUI[P80211_OUI_LEN] = { 0x00, 0x00, 0xf8 };
 static u8 RFC1042_OUI[P80211_OUI_LEN] = { 0x00, 0x00, 0x00 };
 
-static int ieee80211_copy_snap(u8 * data, __be16 h_proto)
+static int libipw_copy_snap(u8 * data, __be16 h_proto)
 {
-	struct ieee80211_snap_hdr *snap;
+	struct libipw_snap_hdr *snap;
 	u8 *oui;
 
-	snap = (struct ieee80211_snap_hdr *)data;
+	snap = (struct libipw_snap_hdr *)data;
 	snap->dsap = 0xaa;
 	snap->ssap = 0xaa;
 	snap->ctrl = 0x03;
@@ -149,7 +149,7 @@ static int ieee80211_copy_snap(u8 * data, __be16 h_proto)
 	return SNAP_SIZE + sizeof(u16);
 }
 
-static int ieee80211_encrypt_fragment(struct ieee80211_device *ieee,
+static int libipw_encrypt_fragment(struct libipw_device *ieee,
 					     struct sk_buff *frag, int hdr_len)
 {
 	struct lib80211_crypt_data *crypt =
@@ -177,7 +177,7 @@ static int ieee80211_encrypt_fragment(struct ieee80211_device *ieee,
 	return 0;
 }
 
-void ieee80211_txb_free(struct ieee80211_txb *txb)
+void libipw_txb_free(struct libipw_txb *txb)
 {
 	int i;
 	if (unlikely(!txb))
@@ -188,17 +188,17 @@ void ieee80211_txb_free(struct ieee80211_txb *txb)
 	kfree(txb);
 }
 
-static struct ieee80211_txb *ieee80211_alloc_txb(int nr_frags, int txb_size,
+static struct libipw_txb *libipw_alloc_txb(int nr_frags, int txb_size,
 						 int headroom, gfp_t gfp_mask)
 {
-	struct ieee80211_txb *txb;
+	struct libipw_txb *txb;
 	int i;
-	txb = kmalloc(sizeof(struct ieee80211_txb) + (sizeof(u8 *) * nr_frags),
+	txb = kmalloc(sizeof(struct libipw_txb) + (sizeof(u8 *) * nr_frags),
 		      gfp_mask);
 	if (!txb)
 		return NULL;
 
-	memset(txb, 0, sizeof(struct ieee80211_txb));
+	memset(txb, 0, sizeof(struct libipw_txb));
 	txb->nr_frags = nr_frags;
 	txb->frag_size = txb_size;
 
@@ -220,7 +220,7 @@ static struct ieee80211_txb *ieee80211_alloc_txb(int nr_frags, int txb_size,
 	return txb;
 }
 
-static int ieee80211_classify(struct sk_buff *skb)
+static int libipw_classify(struct sk_buff *skb)
 {
 	struct ethhdr *eth;
 	struct iphdr *ip;
@@ -252,11 +252,11 @@ static int ieee80211_classify(struct sk_buff *skb)
 
 /* Incoming skb is converted to a txb which consists of
  * a block of 802.11 fragment packets (stored as skbs) */
-int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
+int libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct ieee80211_device *ieee = netdev_priv(dev);
-	struct ieee80211_txb *txb = NULL;
-	struct ieee80211_hdr_3addrqos *frag_hdr;
+	struct libipw_device *ieee = netdev_priv(dev);
+	struct libipw_txb *txb = NULL;
+	struct libipw_hdr_3addrqos *frag_hdr;
 	int i, bytes_per_frag, nr_frags, bytes_last_frag, frag_size,
 	    rts_required;
 	unsigned long flags;
@@ -264,7 +264,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 ether_type;
 	int bytes, fc, hdr_len;
 	struct sk_buff *skb_frag;
-	struct ieee80211_hdr_3addrqos header = {/* Ensure zero initialized */
+	struct libipw_hdr_3addrqos header = {/* Ensure zero initialized */
 		.duration_id = 0,
 		.seq_ctl = 0,
 		.qos_ctl = 0
@@ -331,14 +331,14 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		memcpy(header.addr2, src, ETH_ALEN);
 		memcpy(header.addr3, ieee->bssid, ETH_ALEN);
 	}
-	hdr_len = IEEE80211_3ADDR_LEN;
+	hdr_len = LIBIPW_3ADDR_LEN;
 
 	if (ieee->is_qos_active && ieee->is_qos_active(dev, skb)) {
 		fc |= IEEE80211_STYPE_QOS_DATA;
 		hdr_len += 2;
 
-		skb->priority = ieee80211_classify(skb);
-		header.qos_ctl |= cpu_to_le16(skb->priority & IEEE80211_QCTL_TID);
+		skb->priority = libipw_classify(skb);
+		header.qos_ctl |= cpu_to_le16(skb->priority & LIBIPW_QCTL_TID);
 	}
 	header.frame_ctl = cpu_to_le16(fc);
 
@@ -362,12 +362,12 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		skb_reserve(skb_new, crypt->ops->extra_msdu_prefix_len);
 		memcpy(skb_put(skb_new, hdr_len), &header, hdr_len);
 		snapped = 1;
-		ieee80211_copy_snap(skb_put(skb_new, SNAP_SIZE + sizeof(u16)),
+		libipw_copy_snap(skb_put(skb_new, SNAP_SIZE + sizeof(u16)),
 				    ether_type);
 		skb_copy_from_linear_data(skb, skb_put(skb_new, skb->len), skb->len);
 		res = crypt->ops->encrypt_msdu(skb_new, hdr_len, crypt->priv);
 		if (res < 0) {
-			IEEE80211_ERROR("msdu encryption failed\n");
+			LIBIPW_ERROR("msdu encryption failed\n");
 			dev_kfree_skb_any(skb_new);
 			goto failed;
 		}
@@ -393,8 +393,8 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * for it when determining the amount of payload space. */
 		bytes_per_frag = frag_size - hdr_len;
 		if (ieee->config &
-		    (CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
-			bytes_per_frag -= IEEE80211_FCS_LEN;
+		    (CFG_LIBIPW_COMPUTE_FCS | CFG_LIBIPW_RESERVE_FCS))
+			bytes_per_frag -= LIBIPW_FCS_LEN;
 
 		/* Each fragment may need to have room for encryptiong
 		 * pre/postfix */
@@ -417,14 +417,14 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	rts_required = (frag_size > ieee->rts
-			&& ieee->config & CFG_IEEE80211_RTS);
+			&& ieee->config & CFG_LIBIPW_RTS);
 	if (rts_required)
 		nr_frags++;
 
 	/* When we allocate the TXB we allocate enough space for the reserve
 	 * and full fragment bytes (bytes_per_frag doesn't include prefix,
 	 * postfix, header, FCS, etc.) */
-	txb = ieee80211_alloc_txb(nr_frags, frag_size,
+	txb = libipw_alloc_txb(nr_frags, frag_size,
 				  ieee->tx_headroom, GFP_ATOMIC);
 	if (unlikely(!txb)) {
 		printk(KERN_WARNING "%s: Could not allocate TXB\n",
@@ -441,7 +441,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (rts_required) {
 		skb_frag = txb->fragments[0];
 		frag_hdr =
-		    (struct ieee80211_hdr_3addrqos *)skb_put(skb_frag, hdr_len);
+		    (struct libipw_hdr_3addrqos *)skb_put(skb_frag, hdr_len);
 
 		/*
 		 * Set header frame_ctl to the RTS.
@@ -456,7 +456,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		header.frame_ctl = cpu_to_le16(fc);
 
 		if (ieee->config &
-		    (CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
+		    (CFG_LIBIPW_COMPUTE_FCS | CFG_LIBIPW_RESERVE_FCS))
 			skb_put(skb_frag, 4);
 
 		txb->rts_included = 1;
@@ -472,7 +472,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 				    crypt->ops->extra_mpdu_prefix_len);
 
 		frag_hdr =
-		    (struct ieee80211_hdr_3addrqos *)skb_put(skb_frag, hdr_len);
+		    (struct libipw_hdr_3addrqos *)skb_put(skb_frag, hdr_len);
 		memcpy(frag_hdr, &header, hdr_len);
 
 		/* If this is not the last fragment, then add the MOREFRAGS
@@ -487,7 +487,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		if (i == 0 && !snapped) {
-			ieee80211_copy_snap(skb_put
+			libipw_copy_snap(skb_put
 					    (skb_frag, SNAP_SIZE + sizeof(u16)),
 					    ether_type);
 			bytes -= SNAP_SIZE + sizeof(u16);
@@ -501,7 +501,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* Encryption routine will move the header forward in order
 		 * to insert the IV between the header and the payload */
 		if (host_encrypt)
-			ieee80211_encrypt_fragment(ieee, skb_frag, hdr_len);
+			libipw_encrypt_fragment(ieee, skb_frag, hdr_len);
 		else if (host_build_iv) {
 			atomic_inc(&crypt->refcnt);
 			if (crypt->ops->build_iv)
@@ -513,7 +513,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		if (ieee->config &
-		    (CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
+		    (CFG_LIBIPW_COMPUTE_FCS | CFG_LIBIPW_RESERVE_FCS))
 			skb_put(skb_frag, 4);
 	}
 
@@ -530,7 +530,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 			return 0;
 		}
 
-		ieee80211_txb_free(txb);
+		libipw_txb_free(txb);
 	}
 
 	return 0;
@@ -541,6 +541,6 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_errors++;
 	return NETDEV_TX_BUSY;
 }
-EXPORT_SYMBOL(ieee80211_xmit);
+EXPORT_SYMBOL(libipw_xmit);
 
-EXPORT_SYMBOL(ieee80211_txb_free);
+EXPORT_SYMBOL(libipw_txb_free);
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 3c0812d..f79ce57 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -37,9 +37,9 @@
 #include <net/lib80211.h>
 #include <linux/wireless.h>
 
-#include "ieee80211.h"
+#include "libipw.h"
 
-static const char *ieee80211_modes[] = {
+static const char *libipw_modes[] = {
 	"?", "a", "b", "ab", "g", "ag", "bg", "abg"
 };
 
@@ -54,9 +54,9 @@ static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 }
 
 #define MAX_CUSTOM_LEN 64
-static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
+static char *libipw_translate_scan(struct libipw_device *ieee,
 				      char *start, char *stop,
-				      struct ieee80211_network *network,
+				      struct libipw_network *network,
 				      struct iw_request_info *info)
 {
 	char custom[MAX_CUSTOM_LEN];
@@ -84,7 +84,7 @@ static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
 	snprintf(iwe.u.name, IFNAMSIZ, "IEEE 802.11%s",
-		 ieee80211_modes[network->mode]);
+		 libipw_modes[network->mode]);
 	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_CHAR_LEN);
 
 	/* Add mode */
@@ -102,7 +102,7 @@ static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
 	/* Add channel and frequency */
 	/* Note : userspace automatically computes channel using iwrange */
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ieee80211_channel_to_freq(ieee, network->channel);
+	iwe.u.freq.m = libipw_channel_to_freq(ieee, network->channel);
 	iwe.u.freq.e = 6;
 	iwe.u.freq.i = 0;
 	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_FREQ_LEN);
@@ -155,7 +155,7 @@ static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
 	iwe.u.qual.updated = IW_QUAL_QUAL_UPDATED | IW_QUAL_LEVEL_UPDATED |
 	    IW_QUAL_NOISE_UPDATED;
 
-	if (!(network->stats.mask & IEEE80211_STATMASK_RSSI)) {
+	if (!(network->stats.mask & LIBIPW_STATMASK_RSSI)) {
 		iwe.u.qual.updated |= IW_QUAL_QUAL_INVALID |
 		    IW_QUAL_LEVEL_INVALID;
 		iwe.u.qual.qual = 0;
@@ -180,14 +180,14 @@ static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
 			iwe.u.qual.qual = 0;
 	}
 
-	if (!(network->stats.mask & IEEE80211_STATMASK_NOISE)) {
+	if (!(network->stats.mask & LIBIPW_STATMASK_NOISE)) {
 		iwe.u.qual.updated |= IW_QUAL_NOISE_INVALID;
 		iwe.u.qual.noise = 0;
 	} else {
 		iwe.u.qual.noise = network->stats.noise;
 	}
 
-	if (!(network->stats.mask & IEEE80211_STATMASK_SIGNAL)) {
+	if (!(network->stats.mask & LIBIPW_STATMASK_SIGNAL)) {
 		iwe.u.qual.updated |= IW_QUAL_LEVEL_INVALID;
 		iwe.u.qual.level = 0;
 	} else {
@@ -237,14 +237,14 @@ static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
 	p = custom;
 	p += snprintf(p, MAX_CUSTOM_LEN - (p - custom), " Channel flags: ");
 
-	if (ieee80211_get_channel_flags(ieee, network->channel) &
-	    IEEE80211_CH_INVALID) {
+	if (libipw_get_channel_flags(ieee, network->channel) &
+	    LIBIPW_CH_INVALID) {
 		iwe.cmd = IWEVCUSTOM;
 		p += snprintf(p, MAX_CUSTOM_LEN - (p - custom), "INVALID ");
 	}
 
-	if (ieee80211_get_channel_flags(ieee, network->channel) &
-	    IEEE80211_CH_RADAR_DETECT) {
+	if (libipw_get_channel_flags(ieee, network->channel) &
+	    LIBIPW_CH_RADAR_DETECT) {
 		iwe.cmd = IWEVCUSTOM;
 		p += snprintf(p, MAX_CUSTOM_LEN - (p - custom), "DFS ");
 	}
@@ -259,11 +259,11 @@ static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
 
 #define SCAN_ITEM_SIZE 128
 
-int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
+int libipw_wx_get_scan(struct libipw_device *ieee,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
-	struct ieee80211_network *network;
+	struct libipw_network *network;
 	unsigned long flags;
 	int err = 0;
 
@@ -272,7 +272,7 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 	int i = 0;
 	DECLARE_SSID_BUF(ssid);
 
-	IEEE80211_DEBUG_WX("Getting scan\n");
+	LIBIPW_DEBUG_WX("Getting scan\n");
 
 	spin_lock_irqsave(&ieee->lock, flags);
 
@@ -285,10 +285,10 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 
 		if (ieee->scan_age == 0 ||
 		    time_after(network->last_scanned + ieee->scan_age, jiffies))
-			ev = ieee80211_translate_scan(ieee, ev, stop, network,
+			ev = libipw_translate_scan(ieee, ev, stop, network,
 						      info);
 		else {
-			IEEE80211_DEBUG_SCAN("Not showing network '%s ("
+			LIBIPW_DEBUG_SCAN("Not showing network '%s ("
 					     "%pM)' due to age (%ums).\n",
 					     print_ssid(ssid, network->ssid,
 							 network->ssid_len),
@@ -303,18 +303,18 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 	wrqu->data.length = ev - extra;
 	wrqu->data.flags = 0;
 
-	IEEE80211_DEBUG_WX("exit: %d networks returned.\n", i);
+	LIBIPW_DEBUG_WX("exit: %d networks returned.\n", i);
 
 	return err;
 }
 
-int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
+int libipw_wx_set_encode(struct libipw_device *ieee,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *keybuf)
 {
 	struct iw_point *erq = &(wrqu->encoding);
 	struct net_device *dev = ieee->dev;
-	struct ieee80211_security sec = {
+	struct libipw_security sec = {
 		.flags = 0
 	};
 	int i, key, key_provided, len;
@@ -322,7 +322,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 	int host_crypto = ieee->host_encrypt || ieee->host_decrypt || ieee->host_build_iv;
 	DECLARE_SSID_BUF(ssid);
 
-	IEEE80211_DEBUG_WX("SET_ENCODE\n");
+	LIBIPW_DEBUG_WX("SET_ENCODE\n");
 
 	key = erq->flags & IW_ENCODE_INDEX;
 	if (key) {
@@ -335,18 +335,18 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 		key = ieee->crypt_info.tx_keyidx;
 	}
 
-	IEEE80211_DEBUG_WX("Key: %d [%s]\n", key, key_provided ?
+	LIBIPW_DEBUG_WX("Key: %d [%s]\n", key, key_provided ?
 			   "provided" : "default");
 
 	crypt = &ieee->crypt_info.crypt[key];
 
 	if (erq->flags & IW_ENCODE_DISABLED) {
 		if (key_provided && *crypt) {
-			IEEE80211_DEBUG_WX("Disabling encryption on key %d.\n",
+			LIBIPW_DEBUG_WX("Disabling encryption on key %d.\n",
 					   key);
 			lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
 		} else
-			IEEE80211_DEBUG_WX("Disabling encryption.\n");
+			LIBIPW_DEBUG_WX("Disabling encryption.\n");
 
 		/* Check all the keys to see if any are still configured,
 		 * and if no key index was provided, de-init them all */
@@ -410,7 +410,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 
 	/* If a new key was provided, set it up */
 	if (erq->length > 0) {
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 		DECLARE_SSID_BUF(ssid);
 #endif
 
@@ -419,7 +419,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 		if (len > erq->length)
 			memset(sec.keys[key] + erq->length, 0,
 			       len - erq->length);
-		IEEE80211_DEBUG_WX("Setting key %d to '%s' (%d:%d bytes)\n",
+		LIBIPW_DEBUG_WX("Setting key %d to '%s' (%d:%d bytes)\n",
 				   key, print_ssid(ssid, sec.keys[key], len),
 				   erq->length, len);
 		sec.key_sizes[key] = len;
@@ -438,7 +438,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 						     NULL, (*crypt)->priv);
 			if (len == 0) {
 				/* Set a default key of all 0 */
-				IEEE80211_DEBUG_WX("Setting key %d to all "
+				LIBIPW_DEBUG_WX("Setting key %d to all "
 						   "zero.\n", key);
 				memset(sec.keys[key], 0, 13);
 				(*crypt)->ops->set_key(sec.keys[key], 13, NULL,
@@ -449,7 +449,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 		}
 		/* No key data - just set the default TX key index */
 		if (key_provided) {
-			IEEE80211_DEBUG_WX("Setting key %d to default Tx "
+			LIBIPW_DEBUG_WX("Setting key %d to default Tx "
 					   "key.\n", key);
 			ieee->crypt_info.tx_keyidx = key;
 			sec.active_key = key;
@@ -461,7 +461,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 		sec.auth_mode = ieee->open_wep ? WLAN_AUTH_OPEN :
 		    WLAN_AUTH_SHARED_KEY;
 		sec.flags |= SEC_AUTH_MODE;
-		IEEE80211_DEBUG_WX("Auth: %s\n",
+		LIBIPW_DEBUG_WX("Auth: %s\n",
 				   sec.auth_mode == WLAN_AUTH_OPEN ?
 				   "OPEN" : "SHARED KEY");
 	}
@@ -490,16 +490,16 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 	return 0;
 }
 
-int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
+int libipw_wx_get_encode(struct libipw_device *ieee,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *keybuf)
 {
 	struct iw_point *erq = &(wrqu->encoding);
 	int len, key;
 	struct lib80211_crypt_data *crypt;
-	struct ieee80211_security *sec = &ieee->sec;
+	struct libipw_security *sec = &ieee->sec;
 
-	IEEE80211_DEBUG_WX("GET_ENCODE\n");
+	LIBIPW_DEBUG_WX("GET_ENCODE\n");
 
 	key = erq->flags & IW_ENCODE_INDEX;
 	if (key) {
@@ -532,7 +532,7 @@ int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 	return 0;
 }
 
-int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
+int libipw_wx_set_encodeext(struct libipw_device *ieee,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
@@ -545,7 +545,7 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 	struct lib80211_crypto_ops *ops;
 	struct lib80211_crypt_data **crypt;
 
-	struct ieee80211_security sec = {
+	struct libipw_security sec = {
 		.flags = 0,
 	};
 
@@ -611,7 +611,7 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 		module = "lib80211_crypt_ccmp";
 		break;
 	default:
-		IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
+		LIBIPW_DEBUG_WX("%s: unknown crypto alg %d\n",
 				   dev->name, ext->alg);
 		ret = -EINVAL;
 		goto done;
@@ -623,7 +623,7 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 		ops = lib80211_get_crypto_ops(alg);
 	}
 	if (ops == NULL) {
-		IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
+		LIBIPW_DEBUG_WX("%s: unknown crypto alg %d\n",
 				   dev->name, ext->alg);
 		ret = -EINVAL;
 		goto done;
@@ -653,7 +653,7 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 	if (ext->key_len > 0 && (*crypt)->ops->set_key &&
 	    (*crypt)->ops->set_key(ext->key, ext->key_len, ext->rx_seq,
 				   (*crypt)->priv) < 0) {
-		IEEE80211_DEBUG_WX("%s: key setting failed\n", dev->name);
+		LIBIPW_DEBUG_WX("%s: key setting failed\n", dev->name);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -700,20 +700,20 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 	if (ieee->reset_on_keychange &&
 	    ieee->iw_mode != IW_MODE_INFRA &&
 	    ieee->reset_port && ieee->reset_port(dev)) {
-		IEEE80211_DEBUG_WX("%s: reset_port failed\n", dev->name);
+		LIBIPW_DEBUG_WX("%s: reset_port failed\n", dev->name);
 		return -EINVAL;
 	}
 
 	return ret;
 }
 
-int ieee80211_wx_get_encodeext(struct ieee80211_device *ieee,
+int libipw_wx_get_encodeext(struct libipw_device *ieee,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	struct ieee80211_security *sec = &ieee->sec;
+	struct libipw_security *sec = &ieee->sec;
 	int idx, max_key_len;
 
 	max_key_len = encoding->length - sizeof(*ext);
@@ -763,9 +763,9 @@ int ieee80211_wx_get_encodeext(struct ieee80211_device *ieee,
 	return 0;
 }
 
-EXPORT_SYMBOL(ieee80211_wx_set_encodeext);
-EXPORT_SYMBOL(ieee80211_wx_get_encodeext);
+EXPORT_SYMBOL(libipw_wx_set_encodeext);
+EXPORT_SYMBOL(libipw_wx_get_encodeext);
 
-EXPORT_SYMBOL(ieee80211_wx_get_scan);
-EXPORT_SYMBOL(ieee80211_wx_set_encode);
-EXPORT_SYMBOL(ieee80211_wx_get_encode);
+EXPORT_SYMBOL(libipw_wx_get_scan);
+EXPORT_SYMBOL(libipw_wx_set_encode);
+EXPORT_SYMBOL(libipw_wx_get_encode);
diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index 2b3fbbb..e9054a2 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -416,13 +416,13 @@ struct iw_spy_data
  * data (i.e. valid as long as struct net_device exist, same locking rules).
  */
 /* Forward declaration */
-struct ieee80211_device;
+struct libipw_device;
 /* The struct */
 struct iw_public_data {
 	/* Driver enhanced spy support */
 	struct iw_spy_data *		spy_data;
-	/* Structure managed by the in-kernel IEEE 802.11 layer */
-	struct ieee80211_device *	ieee80211;
+	/* Legacy structure managed by the ipw2x00-specific IEEE 802.11 layer */
+	struct libipw_device *		libipw;
 };
 
 /**************************** PROTOTYPES ****************************/
-- 
1.6.2.5

