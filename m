Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2248 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3K2LZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/19] brcmfmac: move firmware related structures to
 fwil_types.h
Date: Fri, 29 Nov 2013 12:25:19 +0100
Message-ID: <1385724324-6361-15-git-send-email-arend@broadcom.com> (sfid-20131129_122556_568367_B6491F0F)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware control interface is provided by fwil source file, but
a number of structures used to communicate with the firmware still
resided in dhd.h. The patch moves them to fwil_types.h.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  306 --------------------
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  304 +++++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   10 +-
 4 files changed, 310 insertions(+), 311 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 714194c..7806155 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -100,31 +100,11 @@
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
 
-#define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
-
-/* size of brcmf_scan_params not including variable length array */
-#define BRCMF_SCAN_PARAMS_FIXED_SIZE 64
-
-/* masks for channel and ssid count */
-#define BRCMF_SCAN_PARAMS_COUNT_MASK 0x0000ffff
-#define BRCMF_SCAN_PARAMS_NSSID_SHIFT 16
-
-/* primary (ie tx) key */
-#define BRCMF_PRIMARY_KEY	(1 << 1)
-
 /* For supporting multiple interfaces */
 #define BRCMF_MAX_IFS	16
 
-#define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
 
-#define BRCMF_ESCAN_REQ_VERSION 1
-
-#define WLC_BSS_RSSI_ON_CHANNEL		0x0002
-
-#define BRCMF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
-#define BRCMF_STA_ASSOC			0x10		/* Associated */
-
 #define BRCMF_E_STATUS_SUCCESS			0
 #define BRCMF_E_STATUS_FAIL			1
 #define BRCMF_E_STATUS_TIMEOUT			2
@@ -216,292 +196,6 @@
  */
 #define BRCMF_DRIVER_FIRMWARE_VERSION_LEN	32
 
-/* Pattern matching filter. Specifies an offset within received packets to
- * start matching, the pattern to match, the size of the pattern, and a bitmask
- * that indicates which bits within the pattern should be matched.
- */
-struct brcmf_pkt_filter_pattern_le {
-	/*
-	 * Offset within received packet to start pattern matching.
-	 * Offset '0' is the first byte of the ethernet header.
-	 */
-	__le32 offset;
-	/* Size of the pattern.  Bitmask must be the same size.*/
-	__le32 size_bytes;
-	/*
-	 * Variable length mask and pattern data. mask starts at offset 0.
-	 * Pattern immediately follows mask.
-	 */
-	u8 mask_and_pattern[1];
-};
-
-/* IOVAR "pkt_filter_add" parameter. Used to install packet filters. */
-struct brcmf_pkt_filter_le {
-	__le32 id;		/* Unique filter id, specified by app. */
-	__le32 type;		/* Filter type (WL_PKT_FILTER_TYPE_xxx). */
-	__le32 negate_match;	/* Negate the result of filter matches */
-	union {			/* Filter definitions */
-		struct brcmf_pkt_filter_pattern_le pattern; /* Filter pattern */
-	} u;
-};
-
-/* IOVAR "pkt_filter_enable" parameter. */
-struct brcmf_pkt_filter_enable_le {
-	__le32 id;		/* Unique filter id */
-	__le32 enable;		/* Enable/disable bool */
-};
-
-/* BSS info structure
- * Applications MUST CHECK ie_offset field and length field to access IEs and
- * next bss_info structure in a vector (in struct brcmf_scan_results)
- */
-struct brcmf_bss_info_le {
-	__le32 version;		/* version field */
-	__le32 length;		/* byte length of data in this record,
-				 * starting at version and including IEs
-				 */
-	u8 BSSID[ETH_ALEN];
-	__le16 beacon_period;	/* units are Kusec */
-	__le16 capability;	/* Capability information */
-	u8 SSID_len;
-	u8 SSID[32];
-	struct {
-		__le32 count;   /* # rates in this set */
-		u8 rates[16]; /* rates in 500kbps units w/hi bit set if basic */
-	} rateset;		/* supported rates */
-	__le16 chanspec;	/* chanspec for bss */
-	__le16 atim_window;	/* units are Kusec */
-	u8 dtim_period;	/* DTIM period */
-	__le16 RSSI;		/* receive signal strength (in dBm) */
-	s8 phy_noise;		/* noise (in dBm) */
-
-	u8 n_cap;		/* BSS is 802.11N Capable */
-	/* 802.11N BSS Capabilities (based on HT_CAP_*): */
-	__le32 nbss_cap;
-	u8 ctl_ch;		/* 802.11N BSS control channel number */
-	__le32 reserved32[1];	/* Reserved for expansion of BSS properties */
-	u8 flags;		/* flags */
-	u8 reserved[3];	/* Reserved for expansion of BSS properties */
-	u8 basic_mcs[MCSSET_LEN];	/* 802.11N BSS required MCS set */
-
-	__le16 ie_offset;	/* offset at which IEs start, from beginning */
-	__le32 ie_length;	/* byte length of Information Elements */
-	__le16 SNR;		/* average SNR of during frame reception */
-	/* Add new fields here */
-	/* variable length Information Elements */
-};
-
-struct brcm_rateset_le {
-	/* # rates in this set */
-	__le32 count;
-	/* rates in 500kbps units w/hi bit set if basic */
-	u8 rates[BRCMF_MAXRATES_IN_SET];
-};
-
-struct brcmf_ssid {
-	u32 SSID_len;
-	unsigned char SSID[32];
-};
-
-struct brcmf_ssid_le {
-	__le32 SSID_len;
-	unsigned char SSID[32];
-};
-
-struct brcmf_scan_params_le {
-	struct brcmf_ssid_le ssid_le;	/* default: {0, ""} */
-	u8 bssid[ETH_ALEN];	/* default: bcast */
-	s8 bss_type;		/* default: any,
-				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
-				 */
-	u8 scan_type;	/* flags, 0 use default */
-	__le32 nprobes;	  /* -1 use default, number of probes per channel */
-	__le32 active_time;	/* -1 use default, dwell time per channel for
-				 * active scanning
-				 */
-	__le32 passive_time;	/* -1 use default, dwell time per channel
-				 * for passive scanning
-				 */
-	__le32 home_time;	/* -1 use default, dwell time for the
-				 * home channel between channel scans
-				 */
-	__le32 channel_num;	/* count of channels and ssids that follow
-				 *
-				 * low half is count of channels in
-				 * channel_list, 0 means default (use all
-				 * available channels)
-				 *
-				 * high half is entries in struct brcmf_ssid
-				 * array that follows channel_list, aligned for
-				 * s32 (4 bytes) meaning an odd channel count
-				 * implies a 2-byte pad between end of
-				 * channel_list and first ssid
-				 *
-				 * if ssid count is zero, single ssid in the
-				 * fixed parameter portion is assumed, otherwise
-				 * ssid in the fixed portion is ignored
-				 */
-	__le16 channel_list[1];	/* list of chanspecs */
-};
-
-struct brcmf_scan_results {
-	u32 buflen;
-	u32 version;
-	u32 count;
-	struct brcmf_bss_info_le bss_info_le[];
-};
-
-struct brcmf_escan_params_le {
-	__le32 version;
-	__le16 action;
-	__le16 sync_id;
-	struct brcmf_scan_params_le params_le;
-};
-
-struct brcmf_escan_result_le {
-	__le32 buflen;
-	__le32 version;
-	__le16 sync_id;
-	__le16 bss_count;
-	struct brcmf_bss_info_le bss_info_le;
-};
-
-#define WL_ESCAN_RESULTS_FIXED_SIZE (sizeof(struct brcmf_escan_result_le) - \
-	sizeof(struct brcmf_bss_info_le))
-
-/* used for association with a specific BSSID and chanspec list */
-struct brcmf_assoc_params_le {
-	/* 00:00:00:00:00:00: broadcast scan */
-	u8 bssid[ETH_ALEN];
-	/* 0: all available channels, otherwise count of chanspecs in
-	 * chanspec_list */
-	__le32 chanspec_num;
-	/* list of chanspecs */
-	__le16 chanspec_list[1];
-};
-
-/* used for join with or without a specific bssid and channel list */
-struct brcmf_join_params {
-	struct brcmf_ssid_le ssid_le;
-	struct brcmf_assoc_params_le params_le;
-};
-
-/* scan params for extended join */
-struct brcmf_join_scan_params_le {
-	u8 scan_type;		/* 0 use default, active or passive scan */
-	__le32 nprobes;		/* -1 use default, nr of probes per channel */
-	__le32 active_time;	/* -1 use default, dwell time per channel for
-				 * active scanning
-				 */
-	__le32 passive_time;	/* -1 use default, dwell time per channel
-				 * for passive scanning
-				 */
-	__le32 home_time;	/* -1 use default, dwell time for the home
-				 * channel between channel scans
-				 */
-};
-
-/* extended join params */
-struct brcmf_ext_join_params_le {
-	struct brcmf_ssid_le ssid_le;	/* {0, ""}: wildcard scan */
-	struct brcmf_join_scan_params_le scan_le;
-	struct brcmf_assoc_params_le assoc_le;
-};
-
-struct brcmf_wsec_key {
-	u32 index;		/* key index */
-	u32 len;		/* key length */
-	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
-	u32 pad_1[18];
-	u32 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
-	u32 flags;	/* misc flags */
-	u32 pad_2[3];
-	u32 iv_initialized;	/* has IV been initialized already? */
-	u32 pad_3;
-	/* Rx IV */
-	struct {
-		u32 hi;	/* upper 32 bits of IV */
-		u16 lo;	/* lower 16 bits of IV */
-	} rxiv;
-	u32 pad_4[2];
-	u8 ea[ETH_ALEN];	/* per station */
-};
-
-/*
- * dongle requires same struct as above but with fields in little endian order
- */
-struct brcmf_wsec_key_le {
-	__le32 index;		/* key index */
-	__le32 len;		/* key length */
-	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
-	__le32 pad_1[18];
-	__le32 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
-	__le32 flags;	/* misc flags */
-	__le32 pad_2[3];
-	__le32 iv_initialized;	/* has IV been initialized already? */
-	__le32 pad_3;
-	/* Rx IV */
-	struct {
-		__le32 hi;	/* upper 32 bits of IV */
-		__le16 lo;	/* lower 16 bits of IV */
-	} rxiv;
-	__le32 pad_4[2];
-	u8 ea[ETH_ALEN];	/* per station */
-};
-
-/* Used to get specific STA parameters */
-struct brcmf_scb_val_le {
-	__le32 val;
-	u8 ea[ETH_ALEN];
-};
-
-/* channel encoding */
-struct brcmf_channel_info_le {
-	__le32 hw_channel;
-	__le32 target_channel;
-	__le32 scan_channel;
-};
-
-struct brcmf_sta_info_le {
-	__le16	ver;		/* version of this struct */
-	__le16	len;		/* length in bytes of this structure */
-	__le16	cap;		/* sta's advertised capabilities */
-	__le32	flags;		/* flags defined below */
-	__le32	idle;		/* time since data pkt rx'd from sta */
-	u8	ea[ETH_ALEN];		/* Station address */
-	__le32	count;			/* # rates in this set */
-	u8	rates[BRCMF_MAXRATES_IN_SET];	/* rates in 500kbps units */
-						/* w/hi bit set if basic */
-	__le32	in;		/* seconds elapsed since associated */
-	__le32	listen_interval_inms; /* Min Listen interval in ms for STA */
-	__le32	tx_pkts;	/* # of packets transmitted */
-	__le32	tx_failures;	/* # of packets failed */
-	__le32	rx_ucast_pkts;	/* # of unicast packets received */
-	__le32	rx_mcast_pkts;	/* # of multicast packets received */
-	__le32	tx_rate;	/* Rate of last successful tx frame */
-	__le32	rx_rate;	/* Rate of last successful rx frame */
-	__le32	rx_decrypt_succeeds;	/* # of packet decrypted successfully */
-	__le32	rx_decrypt_failures;	/* # of packet decrypted failed */
-};
-
-struct brcmf_chanspec_list {
-	__le32	count;		/* # of entries */
-	__le32	element[1];	/* variable length uint32 list */
-};
-
-/*
- * WLC_E_PROBRESP_MSG
- * WLC_E_P2P_PROBREQ_MSG
- * WLC_E_ACTION_FRAME_RX
- */
-struct brcmf_rx_mgmt_data {
-	__be16	version;
-	__be16	chanspec;
-	__be32	rssi;
-	__be32	mactime;
-	__be32	rate;
-};
-
 /* Bus independent dongle command */
 struct brcmf_dcmd {
 	uint cmd;		/* common dongle cmd definition */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index d5811a4..548dbb5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -23,6 +23,7 @@
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 #include "fwil.h"
+#include "fwil_types.h"
 #include "tracepoint.h"
 
 #define PKTFILTER_BUF_SIZE		128
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index ecabb04..af17a5b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -29,6 +29,24 @@
 #define BRCMF_ARP_OL_HOST_AUTO_REPLY	0x00000004
 #define BRCMF_ARP_OL_PEER_AUTO_REPLY	0x00000008
 
+#define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
+#define BRCMF_BSS_RSSI_ON_CHANNEL	0x0002
+
+#define BRCMF_STA_ASSOC			0x10		/* Associated */
+
+/* size of brcmf_scan_params not including variable length array */
+#define BRCMF_SCAN_PARAMS_FIXED_SIZE	64
+
+/* masks for channel and ssid count */
+#define BRCMF_SCAN_PARAMS_COUNT_MASK	0x0000ffff
+#define BRCMF_SCAN_PARAMS_NSSID_SHIFT	16
+
+/* primary (ie tx) key */
+#define BRCMF_PRIMARY_KEY		(1 << 1)
+#define DOT11_BSSTYPE_ANY		2
+#define BRCMF_ESCAN_REQ_VERSION		1
+
+#define BRCMF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
 
 enum brcmf_fil_p2p_if_types {
 	BRCMF_FIL_P2P_IF_CLIENT,
@@ -90,4 +108,290 @@ enum brcmf_tdls_manual_ep_ops {
 	BRCMF_TDLS_MANUAL_EP_DISCOVERY = 6
 };
 
+/* Pattern matching filter. Specifies an offset within received packets to
+ * start matching, the pattern to match, the size of the pattern, and a bitmask
+ * that indicates which bits within the pattern should be matched.
+ */
+struct brcmf_pkt_filter_pattern_le {
+	/*
+	 * Offset within received packet to start pattern matching.
+	 * Offset '0' is the first byte of the ethernet header.
+	 */
+	__le32 offset;
+	/* Size of the pattern.  Bitmask must be the same size.*/
+	__le32 size_bytes;
+	/*
+	 * Variable length mask and pattern data. mask starts at offset 0.
+	 * Pattern immediately follows mask.
+	 */
+	u8 mask_and_pattern[1];
+};
+
+/* IOVAR "pkt_filter_add" parameter. Used to install packet filters. */
+struct brcmf_pkt_filter_le {
+	__le32 id;		/* Unique filter id, specified by app. */
+	__le32 type;		/* Filter type (WL_PKT_FILTER_TYPE_xxx). */
+	__le32 negate_match;	/* Negate the result of filter matches */
+	union {			/* Filter definitions */
+		struct brcmf_pkt_filter_pattern_le pattern; /* Filter pattern */
+	} u;
+};
+
+/* IOVAR "pkt_filter_enable" parameter. */
+struct brcmf_pkt_filter_enable_le {
+	__le32 id;		/* Unique filter id */
+	__le32 enable;		/* Enable/disable bool */
+};
+
+/* BSS info structure
+ * Applications MUST CHECK ie_offset field and length field to access IEs and
+ * next bss_info structure in a vector (in struct brcmf_scan_results)
+ */
+struct brcmf_bss_info_le {
+	__le32 version;		/* version field */
+	__le32 length;		/* byte length of data in this record,
+				 * starting at version and including IEs
+				 */
+	u8 BSSID[ETH_ALEN];
+	__le16 beacon_period;	/* units are Kusec */
+	__le16 capability;	/* Capability information */
+	u8 SSID_len;
+	u8 SSID[32];
+	struct {
+		__le32 count;   /* # rates in this set */
+		u8 rates[16]; /* rates in 500kbps units w/hi bit set if basic */
+	} rateset;		/* supported rates */
+	__le16 chanspec;	/* chanspec for bss */
+	__le16 atim_window;	/* units are Kusec */
+	u8 dtim_period;	/* DTIM period */
+	__le16 RSSI;		/* receive signal strength (in dBm) */
+	s8 phy_noise;		/* noise (in dBm) */
+
+	u8 n_cap;		/* BSS is 802.11N Capable */
+	/* 802.11N BSS Capabilities (based on HT_CAP_*): */
+	__le32 nbss_cap;
+	u8 ctl_ch;		/* 802.11N BSS control channel number */
+	__le32 reserved32[1];	/* Reserved for expansion of BSS properties */
+	u8 flags;		/* flags */
+	u8 reserved[3];	/* Reserved for expansion of BSS properties */
+	u8 basic_mcs[MCSSET_LEN];	/* 802.11N BSS required MCS set */
+
+	__le16 ie_offset;	/* offset at which IEs start, from beginning */
+	__le32 ie_length;	/* byte length of Information Elements */
+	__le16 SNR;		/* average SNR of during frame reception */
+	/* Add new fields here */
+	/* variable length Information Elements */
+};
+
+struct brcm_rateset_le {
+	/* # rates in this set */
+	__le32 count;
+	/* rates in 500kbps units w/hi bit set if basic */
+	u8 rates[BRCMF_MAXRATES_IN_SET];
+};
+
+struct brcmf_ssid {
+	u32 SSID_len;
+	unsigned char SSID[32];
+};
+
+struct brcmf_ssid_le {
+	__le32 SSID_len;
+	unsigned char SSID[32];
+};
+
+struct brcmf_scan_params_le {
+	struct brcmf_ssid_le ssid_le;	/* default: {0, ""} */
+	u8 bssid[ETH_ALEN];	/* default: bcast */
+	s8 bss_type;		/* default: any,
+				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
+				 */
+	u8 scan_type;	/* flags, 0 use default */
+	__le32 nprobes;	  /* -1 use default, number of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	__le32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	__le32 home_time;	/* -1 use default, dwell time for the
+				 * home channel between channel scans
+				 */
+	__le32 channel_num;	/* count of channels and ssids that follow
+				 *
+				 * low half is count of channels in
+				 * channel_list, 0 means default (use all
+				 * available channels)
+				 *
+				 * high half is entries in struct brcmf_ssid
+				 * array that follows channel_list, aligned for
+				 * s32 (4 bytes) meaning an odd channel count
+				 * implies a 2-byte pad between end of
+				 * channel_list and first ssid
+				 *
+				 * if ssid count is zero, single ssid in the
+				 * fixed parameter portion is assumed, otherwise
+				 * ssid in the fixed portion is ignored
+				 */
+	__le16 channel_list[1];	/* list of chanspecs */
+};
+
+struct brcmf_scan_results {
+	u32 buflen;
+	u32 version;
+	u32 count;
+	struct brcmf_bss_info_le bss_info_le[];
+};
+
+struct brcmf_escan_params_le {
+	__le32 version;
+	__le16 action;
+	__le16 sync_id;
+	struct brcmf_scan_params_le params_le;
+};
+
+struct brcmf_escan_result_le {
+	__le32 buflen;
+	__le32 version;
+	__le16 sync_id;
+	__le16 bss_count;
+	struct brcmf_bss_info_le bss_info_le;
+};
+
+#define WL_ESCAN_RESULTS_FIXED_SIZE (sizeof(struct brcmf_escan_result_le) - \
+	sizeof(struct brcmf_bss_info_le))
+
+/* used for association with a specific BSSID and chanspec list */
+struct brcmf_assoc_params_le {
+	/* 00:00:00:00:00:00: broadcast scan */
+	u8 bssid[ETH_ALEN];
+	/* 0: all available channels, otherwise count of chanspecs in
+	 * chanspec_list */
+	__le32 chanspec_num;
+	/* list of chanspecs */
+	__le16 chanspec_list[1];
+};
+
+/* used for join with or without a specific bssid and channel list */
+struct brcmf_join_params {
+	struct brcmf_ssid_le ssid_le;
+	struct brcmf_assoc_params_le params_le;
+};
+
+/* scan params for extended join */
+struct brcmf_join_scan_params_le {
+	u8 scan_type;		/* 0 use default, active or passive scan */
+	__le32 nprobes;		/* -1 use default, nr of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	__le32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	__le32 home_time;	/* -1 use default, dwell time for the home
+				 * channel between channel scans
+				 */
+};
+
+/* extended join params */
+struct brcmf_ext_join_params_le {
+	struct brcmf_ssid_le ssid_le;	/* {0, ""}: wildcard scan */
+	struct brcmf_join_scan_params_le scan_le;
+	struct brcmf_assoc_params_le assoc_le;
+};
+
+struct brcmf_wsec_key {
+	u32 index;		/* key index */
+	u32 len;		/* key length */
+	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
+	u32 pad_1[18];
+	u32 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
+	u32 flags;	/* misc flags */
+	u32 pad_2[3];
+	u32 iv_initialized;	/* has IV been initialized already? */
+	u32 pad_3;
+	/* Rx IV */
+	struct {
+		u32 hi;	/* upper 32 bits of IV */
+		u16 lo;	/* lower 16 bits of IV */
+	} rxiv;
+	u32 pad_4[2];
+	u8 ea[ETH_ALEN];	/* per station */
+};
+
+/*
+ * dongle requires same struct as above but with fields in little endian order
+ */
+struct brcmf_wsec_key_le {
+	__le32 index;		/* key index */
+	__le32 len;		/* key length */
+	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
+	__le32 pad_1[18];
+	__le32 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
+	__le32 flags;	/* misc flags */
+	__le32 pad_2[3];
+	__le32 iv_initialized;	/* has IV been initialized already? */
+	__le32 pad_3;
+	/* Rx IV */
+	struct {
+		__le32 hi;	/* upper 32 bits of IV */
+		__le16 lo;	/* lower 16 bits of IV */
+	} rxiv;
+	__le32 pad_4[2];
+	u8 ea[ETH_ALEN];	/* per station */
+};
+
+/* Used to get specific STA parameters */
+struct brcmf_scb_val_le {
+	__le32 val;
+	u8 ea[ETH_ALEN];
+};
+
+/* channel encoding */
+struct brcmf_channel_info_le {
+	__le32 hw_channel;
+	__le32 target_channel;
+	__le32 scan_channel;
+};
+
+struct brcmf_sta_info_le {
+	__le16	ver;		/* version of this struct */
+	__le16	len;		/* length in bytes of this structure */
+	__le16	cap;		/* sta's advertised capabilities */
+	__le32	flags;		/* flags defined below */
+	__le32	idle;		/* time since data pkt rx'd from sta */
+	u8	ea[ETH_ALEN];		/* Station address */
+	__le32	count;			/* # rates in this set */
+	u8	rates[BRCMF_MAXRATES_IN_SET];	/* rates in 500kbps units */
+						/* w/hi bit set if basic */
+	__le32	in;		/* seconds elapsed since associated */
+	__le32	listen_interval_inms; /* Min Listen interval in ms for STA */
+	__le32	tx_pkts;	/* # of packets transmitted */
+	__le32	tx_failures;	/* # of packets failed */
+	__le32	rx_ucast_pkts;	/* # of unicast packets received */
+	__le32	rx_mcast_pkts;	/* # of multicast packets received */
+	__le32	tx_rate;	/* Rate of last successful tx frame */
+	__le32	rx_rate;	/* Rate of last successful rx frame */
+	__le32	rx_decrypt_succeeds;	/* # of packet decrypted successfully */
+	__le32	rx_decrypt_failures;	/* # of packet decrypted failed */
+};
+
+struct brcmf_chanspec_list {
+	__le32	count;		/* # of entries */
+	__le32	element[1];	/* variable length uint32 list */
+};
+
+/*
+ * WLC_E_PROBRESP_MSG
+ * WLC_E_P2P_PROBREQ_MSG
+ * WLC_E_ACTION_FRAME_RX
+ */
+struct brcmf_rx_mgmt_data {
+	__be16	version;
+	__be16	chanspec;
+	__be32	rssi;
+	__be32	mactime;
+	__be32	rate;
+};
+
 #endif /* FWIL_TYPES_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 571f013..470a47f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2556,8 +2556,8 @@ brcmf_compare_update_same_bss(struct brcmf_cfg80211_info *cfg,
 		ch_bss.band == ch_bss_info_le.band &&
 		bss_info_le->SSID_len == bss->SSID_len &&
 		!memcmp(bss_info_le->SSID, bss->SSID, bss_info_le->SSID_len)) {
-		if ((bss->flags & WLC_BSS_RSSI_ON_CHANNEL) ==
-			(bss_info_le->flags & WLC_BSS_RSSI_ON_CHANNEL)) {
+		if ((bss->flags & BRCMF_BSS_RSSI_ON_CHANNEL) ==
+			(bss_info_le->flags & BRCMF_BSS_RSSI_ON_CHANNEL)) {
 			s16 bss_rssi = le16_to_cpu(bss->RSSI);
 			s16 bss_info_rssi = le16_to_cpu(bss_info_le->RSSI);
 
@@ -2566,13 +2566,13 @@ brcmf_compare_update_same_bss(struct brcmf_cfg80211_info *cfg,
 			*/
 			if (bss_info_rssi > bss_rssi)
 				bss->RSSI = bss_info_le->RSSI;
-		} else if ((bss->flags & WLC_BSS_RSSI_ON_CHANNEL) &&
-			(bss_info_le->flags & WLC_BSS_RSSI_ON_CHANNEL) == 0) {
+		} else if ((bss->flags & BRCMF_BSS_RSSI_ON_CHANNEL) &&
+			(bss_info_le->flags & BRCMF_BSS_RSSI_ON_CHANNEL) == 0) {
 			/* preserve the on-channel rssi measurement
 			* if the new measurement is off channel
 			*/
 			bss->RSSI = bss_info_le->RSSI;
-			bss->flags |= WLC_BSS_RSSI_ON_CHANNEL;
+			bss->flags |= BRCMF_BSS_RSSI_ON_CHANNEL;
 		}
 		return 1;
 	}
-- 
1.7.10.4


