Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2233 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161216Ab1FALqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/83] staging: brcm80211: emptied wlioctl.h
Date: Wed, 1 Jun 2011 13:44:54 +0200
Message-ID: <1306928768-7501-9-git-send-email-rvossen@broadcom.com> (sfid-20110601_134636_235521_F3B40E2E)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Broadcom specific ioctl functionality is not necessary
in the Linux world. Deleted unused defines and structs from wlioctl.h.
Moved softmac specific items from wlioctl.h to softmac header files,
same for fullmac items. Moved shared fullmac/softmac definitions to other
header files.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h           |  714 +++++++++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    1 -
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |    1 -
 drivers/staging/brcm80211/brcmfmac/dhdioctl.h      |   80 --
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   20 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    2 -
 drivers/staging/brcm80211/brcmsmac/bcmsrom_tbl.h   |    2 -
 drivers/staging/brcm80211/brcmsmac/d11.h           |   13 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |   40 +-
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h        |    2 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    1 -
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |    4 +
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    9 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_key.h       |    2 +
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |   29 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h  |   55 +
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |  103 ++-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_scb.h       |    2 +
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    1 -
 drivers/staging/brcm80211/include/bcmdefs.h        |   52 +
 drivers/staging/brcm80211/include/bcmwifi.h        |   58 +
 drivers/staging/brcm80211/include/wlioctl.h        | 1345 --------------------
 32 files changed, 993 insertions(+), 1555 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index a726b49..6156062 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -34,15 +34,167 @@
 #include <linux/suspend.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
+#include "bcmdefs.h"
 /* The kernel threading is sdio-specific */
-
-#include <wlioctl.h>
+#include "bcmwifi.h"
+#include "proto/802.11.h"
+#include "proto/bcmeth.h"
+#include "proto/bcmevent.h"
 
 /* Forward decls */
 struct dhd_bus;
 struct dhd_prot;
 struct dhd_info;
 
+#define WLC_UP					2
+#define WLC_SET_PROMISC				10
+#define WLC_GET_RATE				12
+#define WLC_GET_INFRA				19
+#define WLC_SET_INFRA				20
+#define WLC_GET_AUTH				21
+#define WLC_SET_AUTH				22
+#define WLC_GET_BSSID				23
+#define WLC_GET_SSID				25
+#define WLC_SET_SSID				26
+#define WLC_GET_CHANNEL				29
+#define WLC_GET_SRL				31
+#define WLC_GET_LRL				33
+#define WLC_GET_RADIO				37
+#define WLC_SET_RADIO				38
+#define WLC_GET_PHYTYPE				39
+#define WLC_SET_KEY				45
+#define WLC_SET_PASSIVE_SCAN			49
+#define WLC_SCAN				50
+#define WLC_SCAN_RESULTS			51
+#define WLC_DISASSOC				52
+#define WLC_REASSOC				53
+#define WLC_SET_ROAM_TRIGGER			55
+#define WLC_SET_ROAM_DELTA			57
+#define WLC_GET_DTIMPRD				77
+#define WLC_SET_COUNTRY				84
+#define WLC_GET_PM				85
+#define WLC_SET_PM				86
+#define WLC_GET_AP				117
+#define WLC_SET_AP				118
+#define WLC_GET_RSSI				127
+#define WLC_GET_WSEC				133
+#define WLC_SET_WSEC				134
+#define WLC_GET_PHY_NOISE			135
+#define WLC_GET_BSS_INFO			136
+#define WLC_SET_SCAN_CHANNEL_TIME		185
+#define WLC_SET_SCAN_UNASSOC_TIME		187
+#define WLC_SCB_DEAUTHENTICATE_FOR_REASON	201
+#define WLC_GET_VALID_CHANNELS			217
+#define WLC_GET_KEY_PRIMARY			235
+#define WLC_SET_KEY_PRIMARY			236
+#define WLC_SET_SCAN_PASSIVE_TIME		258
+#define WLC_GET_VAR				262	/* get value of named variable */
+#define WLC_SET_VAR				263	/* set named variable to value */
+
+/* phy types (returned by WLC_GET_PHYTPE) */
+#define	WLC_PHY_TYPE_A		0
+#define	WLC_PHY_TYPE_B		1
+#define	WLC_PHY_TYPE_G		2
+#define	WLC_PHY_TYPE_N		4
+#define	WLC_PHY_TYPE_LP		5
+#define	WLC_PHY_TYPE_SSN	6
+#define	WLC_PHY_TYPE_HT		7
+#define	WLC_PHY_TYPE_LCN	8
+#define	WLC_PHY_TYPE_NULL	0xf
+
+#define WL_PKT_FILTER_FIXED_LEN		  offsetof(wl_pkt_filter_t, u)
+#define WL_PKT_FILTER_PATTERN_FIXED_LEN	  offsetof(wl_pkt_filter_pattern_t, mask_and_pattern)
+
+#define WL_EVENTING_MASK_LEN	16
+
+#define TOE_TX_CSUM_OL		0x00000001
+#define TOE_RX_CSUM_OL		0x00000002
+
+/* maximum channels returned by the get valid channels iovar */
+#define WL_NUMCHANNELS		64
+
+#define	WL_BSS_INFO_VERSION	108	/* current ver of wl_bss_info struct */
+
+/* size of wl_scan_params not including variable length array */
+#define WL_SCAN_PARAMS_FIXED_SIZE 64
+
+/* masks for channel and ssid count */
+#define WL_SCAN_PARAMS_COUNT_MASK 0x0000ffff
+#define WL_SCAN_PARAMS_NSSID_SHIFT 16
+
+#define WL_SCAN_ACTION_START      1
+#define WL_SCAN_ACTION_CONTINUE   2
+#define WL_SCAN_ACTION_ABORT      3
+
+#define ISCAN_REQ_VERSION 1
+
+/* wl_iscan_results status values */
+#define WL_SCAN_RESULTS_SUCCESS	0
+#define WL_SCAN_RESULTS_PARTIAL	1
+#define WL_SCAN_RESULTS_PENDING	2
+#define WL_SCAN_RESULTS_ABORTED	3
+#define WL_SCAN_RESULTS_NO_MEM	4
+
+#define MAX_CCA_CHANNELS 38	/* Max number of 20 Mhz wide channels */
+#define MAX_CCA_SECS     60	/* CCA keeps this many seconds history */
+
+#define IBSS_MED        15	/* Mediom in-bss congestion percentage */
+#define IBSS_HI         25	/* Hi in-bss congestion percentage */
+#define OBSS_MED        12
+#define OBSS_HI         25
+#define INTERFER_MED    5
+#define INTERFER_HI     10
+
+#define  CCA_FLAG_2G_ONLY		0x01	/* Return a channel from 2.4 Ghz band */
+#define  CCA_FLAG_5G_ONLY		0x02	/* Return a channel from 2.4 Ghz band */
+#define  CCA_FLAG_IGNORE_DURATION	0x04	/* Ignore dwell time for each channel */
+#define  CCA_FLAGS_PREFER_1_6_11	0x10
+#define  CCA_FLAG_IGNORE_INTERFER 	0x20	/* do not exlude channel based on interfer level */
+
+#define CCA_ERRNO_BAND 		1	/* After filtering for band pref, no choices left */
+#define CCA_ERRNO_DURATION	2	/* After filtering for duration, no choices left */
+#define CCA_ERRNO_PREF_CHAN	3	/* After filtering for chan pref, no choices left */
+#define CCA_ERRNO_INTERFER	4	/* After filtering for interference, no choices left */
+#define CCA_ERRNO_TOO_FEW	5	/* Only 1 channel was input */
+
+#define WL_NUM_RPI_BINS		8
+#define WL_RM_TYPE_BASIC	1
+#define WL_RM_TYPE_CCA		2
+#define WL_RM_TYPE_RPI		3
+
+#define WL_RM_FLAG_PARALLEL	(1<<0)
+
+#define WL_RM_FLAG_LATE		(1<<1)
+#define WL_RM_FLAG_INCAPABLE	(1<<2)
+#define WL_RM_FLAG_REFUSED	(1<<3)
+
+#define WL_SOFT_KEY	(1 << 0)	/* Indicates this key is using soft encrypt */
+#define WL_PRIMARY_KEY	(1 << 1)	/* Indicates this key is the primary (ie tx) key */
+#define WL_KF_RES_4	(1 << 4)	/* Reserved for backward compat */
+#define WL_KF_RES_5	(1 << 5)	/* Reserved for backward compat */
+#define WL_IBSS_PEER_GROUP_KEY	(1 << 6)	/* Indicates a group key for a IBSS PEER */
+
+#define	WLC_IOCTL_SMLEN			256	/* "small" length ioctl buffer required */
+#define WLC_IOCTL_MEDLEN		1536	/* "med" length ioctl buffer required */
+#define	WLC_IOCTL_MAXLEN	8192
+
+#define DHD_IF_VIF	0x01	/* Virtual IF (Hidden from user) */
+
+/* optionally set by a module_param_string() */
+#define MOD_PARAM_PATHLEN	2048
+
+/* For supporting multiple interfaces */
+#define DHD_MAX_IFS	16
+#define DHD_DEL_IF	-0xe
+#define DHD_BAD_IF	-0xf
+
+enum cust_gpio_modes {
+	WLAN_RESET_ON,
+	WLAN_RESET_OFF,
+	WLAN_POWER_ON,
+	WLAN_POWER_OFF
+};
+
 /* The level of bus communication with the dongle */
 enum dhd_bus_state {
 	DHD_BUS_DOWN,		/* Not ready for frame transfers */
@@ -50,6 +202,316 @@ enum dhd_bus_state {
 	DHD_BUS_DATA		/* Ready for frame transfers */
 };
 
+/* Pattern matching filter. Specifies an offset within received packets to
+ * start matching, the pattern to match, the size of the pattern, and a bitmask
+ * that indicates which bits within the pattern should be matched.
+ */
+typedef struct wl_pkt_filter_pattern {
+	u32 offset;		/* Offset within received packet to start pattern matching.
+				 * Offset '0' is the first byte of the ethernet header.
+				 */
+	u32 size_bytes;	/* Size of the pattern.  Bitmask must be the same size. */
+	u8 mask_and_pattern[1];	/* Variable length mask and pattern data.  mask starts
+					 * at offset 0.  Pattern immediately follows mask.
+					 */
+} wl_pkt_filter_pattern_t;
+
+/* IOVAR "pkt_filter_add" parameter. Used to install packet filters. */
+typedef struct wl_pkt_filter {
+	u32 id;		/* Unique filter id, specified by app. */
+	u32 type;		/* Filter type (WL_PKT_FILTER_TYPE_xxx). */
+	u32 negate_match;	/* Negate the result of filter matches */
+	union {			/* Filter definitions */
+		wl_pkt_filter_pattern_t pattern;	/* Pattern matching filter */
+	} u;
+} wl_pkt_filter_t;
+
+/* IOVAR "pkt_filter_enable" parameter. */
+typedef struct wl_pkt_filter_enable {
+	u32 id;		/* Unique filter id */
+	u32 enable;		/* Enable/disable bool */
+} wl_pkt_filter_enable_t;
+
+/* BSS info structure
+ * Applications MUST CHECK ie_offset field and length field to access IEs and
+ * next bss_info structure in a vector (in wl_scan_results_t)
+ */
+typedef struct wl_bss_info {
+	u32 version;		/* version field */
+	u32 length;		/* byte length of data in this record,
+				 * starting at version and including IEs
+				 */
+	u8 BSSID[ETH_ALEN];
+	u16 beacon_period;	/* units are Kusec */
+	u16 capability;	/* Capability information */
+	u8 SSID_len;
+	u8 SSID[32];
+	struct {
+		uint count;	/* # rates in this set */
+		u8 rates[16];	/* rates in 500kbps units w/hi bit set if basic */
+	} rateset;		/* supported rates */
+	chanspec_t chanspec;	/* chanspec for bss */
+	u16 atim_window;	/* units are Kusec */
+	u8 dtim_period;	/* DTIM period */
+	s16 RSSI;		/* receive signal strength (in dBm) */
+	s8 phy_noise;		/* noise (in dBm) */
+
+	u8 n_cap;		/* BSS is 802.11N Capable */
+	u32 nbss_cap;	/* 802.11N BSS Capabilities (based on HT_CAP_*) */
+	u8 ctl_ch;		/* 802.11N BSS control channel number */
+	u32 reserved32[1];	/* Reserved for expansion of BSS properties */
+	u8 flags;		/* flags */
+	u8 reserved[3];	/* Reserved for expansion of BSS properties */
+	u8 basic_mcs[MCSSET_LEN];	/* 802.11N BSS required MCS set */
+
+	u16 ie_offset;	/* offset at which IEs start, from beginning */
+	u32 ie_length;	/* byte length of Information Elements */
+	s16 SNR;		/* average SNR of during frame reception */
+	/* Add new fields here */
+	/* variable length Information Elements */
+} wl_bss_info_t;
+
+typedef struct wlc_ssid {
+	u32 SSID_len;
+	unsigned char SSID[32];
+} wlc_ssid_t;
+
+typedef struct wl_scan_params {
+	wlc_ssid_t ssid;	/* default: {0, ""} */
+	u8 bssid[ETH_ALEN];	/* default: bcast */
+	s8 bss_type;		/* default: any,
+				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
+				 */
+	u8 scan_type;	/* flags, 0 use default */
+	s32 nprobes;		/* -1 use default, number of probes per channel */
+	s32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	s32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	s32 home_time;	/* -1 use default, dwell time for the home channel
+				 * between channel scans
+				 */
+	s32 channel_num;	/* count of channels and ssids that follow
+				 *
+				 * low half is count of channels in channel_list, 0
+				 * means default (use all available channels)
+				 *
+				 * high half is entries in wlc_ssid_t array that
+				 * follows channel_list, aligned for s32 (4 bytes)
+				 * meaning an odd channel count implies a 2-byte pad
+				 * between end of channel_list and first ssid
+				 *
+				 * if ssid count is zero, single ssid in the fixed
+				 * parameter portion is assumed, otherwise ssid in
+				 * the fixed portion is ignored
+				 */
+	u16 channel_list[1];	/* list of chanspecs */
+} wl_scan_params_t;
+
+/* incremental scan struct */
+typedef struct wl_iscan_params {
+	u32 version;
+	u16 action;
+	u16 scan_duration;
+	wl_scan_params_t params;
+} wl_iscan_params_t;
+
+/* 3 fields + size of wl_scan_params, not including variable length array */
+#define WL_ISCAN_PARAMS_FIXED_SIZE (offsetof(wl_iscan_params_t, params) + sizeof(wlc_ssid_t))
+
+typedef struct wl_scan_results {
+	u32 buflen;
+	u32 version;
+	u32 count;
+	wl_bss_info_t bss_info[1];
+} wl_scan_results_t;
+
+typedef struct wl_rateset_args {
+	u32 count;		/* # rates in this set */
+	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
+	u8 mcs[MCSSET_LEN];	/* supported mcs index bit map */
+} wl_rateset_args_t;
+
+/* u32 list */
+typedef struct wl_u32_list {
+	/* in - # of elements, out - # of entries */
+	u32 count;
+	/* variable length u32 list */
+	u32 element[1];
+} wl_u32_list_t;
+
+/* used for association with a specific BSSID and chanspec list */
+typedef struct wl_assoc_params {
+	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
+	s32 chanspec_num;	/* 0: all available channels,
+				 * otherwise count of chanspecs in chanspec_list
+				 */
+	chanspec_t chanspec_list[1];	/* list of chanspecs */
+} wl_assoc_params_t;
+#define WL_ASSOC_PARAMS_FIXED_SIZE 	(sizeof(wl_assoc_params_t) - sizeof(chanspec_t))
+
+/* used for reassociation/roam to a specific BSSID and channel */
+typedef wl_assoc_params_t wl_reassoc_params_t;
+#define WL_REASSOC_PARAMS_FIXED_SIZE	WL_ASSOC_PARAMS_FIXED_SIZE
+
+/* used for join with or without a specific bssid and channel list */
+typedef struct wl_join_params {
+	wlc_ssid_t ssid;
+	wl_assoc_params_t params;	/* optional field, but it must include the fixed portion
+					 * of the wl_assoc_params_t struct when it does present.
+					 */
+} wl_join_params_t;
+#define WL_JOIN_PARAMS_FIXED_SIZE 	(sizeof(wl_join_params_t) - sizeof(chanspec_t))
+
+/* size of wl_scan_results not including variable length array */
+#define WL_SCAN_RESULTS_FIXED_SIZE (sizeof(wl_scan_results_t) - sizeof(wl_bss_info_t))
+
+/* incremental scan results struct */
+typedef struct wl_iscan_results {
+	u32 status;
+	wl_scan_results_t results;
+} wl_iscan_results_t;
+
+/* size of wl_iscan_results not including variable length array */
+#define WL_ISCAN_RESULTS_FIXED_SIZE \
+	(WL_SCAN_RESULTS_FIXED_SIZE + offsetof(wl_iscan_results_t, results))
+
+typedef struct {
+	u32 duration;	/* millisecs spent sampling this channel */
+	u32 congest_ibss;	/* millisecs in our bss (presumably this traffic will */
+	/*  move if cur bss moves channels) */
+	u32 congest_obss;	/* traffic not in our bss */
+	u32 interference;	/* millisecs detecting a non 802.11 interferer. */
+	u32 timestamp;	/* second timestamp */
+} cca_congest_t;
+
+typedef struct {
+	chanspec_t chanspec;	/* Which channel? */
+	u8 num_secs;		/* How many secs worth of data */
+	cca_congest_t secs[1];	/* Data */
+} cca_congest_channel_req_t;
+
+typedef struct wl_country {
+	char country_abbrev[WLC_CNTRY_BUF_SZ];	/* nul-terminated country code used in
+						 * the Country IE
+						 */
+	s32 rev;		/* revision specifier for ccode
+				 * on set, -1 indicates unspecified.
+				 * on get, rev >= 0
+				 */
+	char ccode[WLC_CNTRY_BUF_SZ];	/* nul-terminated built-in country code.
+					 * variable length, but fixed size in
+					 * struct allows simple allocation for
+					 * expected country strings <= 3 chars.
+					 */
+} wl_country_t;
+
+typedef struct wl_channels_in_country {
+	u32 buflen;
+	u32 band;
+	char country_abbrev[WLC_CNTRY_BUF_SZ];
+	u32 count;
+	u32 channel[1];
+} wl_channels_in_country_t;
+
+typedef struct wl_country_list {
+	u32 buflen;
+	u32 band_set;
+	u32 band;
+	u32 count;
+	char country_abbrev[1];
+} wl_country_list_t;
+
+typedef struct wl_rm_req_elt {
+	s8 type;
+	s8 flags;
+	chanspec_t chanspec;
+	u32 token;		/* token for this measurement */
+	u32 tsf_h;		/* TSF high 32-bits of Measurement start time */
+	u32 tsf_l;		/* TSF low 32-bits */
+	u32 dur;		/* TUs */
+} wl_rm_req_elt_t;
+
+typedef struct wl_rm_req {
+	u32 token;		/* overall measurement set token */
+	u32 count;		/* number of measurement requests */
+	void *cb;		/* completion callback function: may be NULL */
+	void *cb_arg;		/* arg to completion callback function */
+	wl_rm_req_elt_t req[1];	/* variable length block of requests */
+} wl_rm_req_t;
+#define WL_RM_REQ_FIXED_LEN	offsetof(wl_rm_req_t, req)
+
+typedef struct wl_rm_rep_elt {
+	s8 type;
+	s8 flags;
+	chanspec_t chanspec;
+	u32 token;		/* token for this measurement */
+	u32 tsf_h;		/* TSF high 32-bits of Measurement start time */
+	u32 tsf_l;		/* TSF low 32-bits */
+	u32 dur;		/* TUs */
+	u32 len;		/* byte length of data block */
+	u8 data[1];		/* variable length data block */
+} wl_rm_rep_elt_t;
+#define WL_RM_REP_ELT_FIXED_LEN	24	/* length excluding data block */
+
+#define WL_RPI_REP_BIN_NUM 8
+typedef struct wl_rm_rpi_rep {
+	u8 rpi[WL_RPI_REP_BIN_NUM];
+	s8 rpi_max[WL_RPI_REP_BIN_NUM];
+} wl_rm_rpi_rep_t;
+
+typedef struct wl_rm_rep {
+	u32 token;		/* overall measurement set token */
+	u32 len;		/* length of measurement report block */
+	wl_rm_rep_elt_t rep[1];	/* variable length block of reports */
+} wl_rm_rep_t;
+#define WL_RM_REP_FIXED_LEN	8
+
+typedef struct wl_wsec_key {
+	u32 index;		/* key index */
+	u32 len;		/* key length */
+	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
+	u32 pad_1[18];
+	u32 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
+	u32 flags;		/* misc flags */
+	u32 pad_2[2];
+	int pad_3;
+	int iv_initialized;	/* has IV been initialized already? */
+	int pad_4;
+	/* Rx IV */
+	struct {
+		u32 hi;	/* upper 32 bits of IV */
+		u16 lo;	/* lower 16 bits of IV */
+	} rxiv;
+	u32 pad_5[2];
+	u8 ea[ETH_ALEN];	/* per station */
+} wl_wsec_key_t;
+
+/* Used to get specific STA parameters */
+typedef struct {
+	u32 val;
+	u8 ea[ETH_ALEN];
+} scb_val_t;
+
+/* channel encoding */
+typedef struct channel_info {
+	int hw_channel;
+	int target_channel;
+	int scan_channel;
+} channel_info_t;
+
+/* Linux network driver ioctl encoding */
+typedef struct wl_ioctl {
+	uint cmd;		/* common ioctl definition */
+	void *buf;		/* pointer to user buffer */
+	uint len;		/* length of user buffer */
+	u8 set;		/* get or set request (optional) */
+	uint used;		/* bytes read or written (optional) */
+	uint needed;		/* bytes needed (optional) */
+} wl_ioctl_t;
+
 /* Common structure for module and instance linkage */
 typedef struct dhd_pub {
 	/* Linkage ponters */
@@ -122,6 +584,20 @@ typedef struct dhd_pub {
 
 } dhd_pub_t;
 
+typedef struct dhd_if_event {
+	u8 ifidx;
+	u8 action;
+	u8 flags;
+	u8 bssidx;
+} dhd_if_event_t;
+
+typedef struct {
+	u32 limit;		/* Expiration time (usec) */
+	u32 increment;	/* Current expiration increment (usec) */
+	u32 elapsed;		/* Current elapsed time (usec) */
+	u32 tick;		/* O/S tick time (usec) */
+} dhd_timeout_t;
+
 #if defined(CONFIG_PM_SLEEP)
 extern atomic_t dhd_mmc_suspend;
 #define DHD_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
@@ -167,7 +643,69 @@ extern atomic_t dhd_mmc_suspend;
 	} while (0)
 
 #endif	/* defined(CONFIG_PM_SLEEP) */
-#define DHD_IF_VIF	0x01	/* Virtual IF (Hidden from user) */
+
+/*
+ * Insmod parameters for debug/test
+ */
+
+/* Watchdog timer interval */
+extern uint dhd_watchdog_ms;
+
+#if defined(DHD_DEBUG)
+/* Console output poll interval */
+extern uint dhd_console_ms;
+#endif				/* defined(DHD_DEBUG) */
+
+/* Use interrupts */
+extern uint dhd_intr;
+
+/* Use polling */
+extern uint dhd_poll;
+
+/* ARP offload agent mode */
+extern uint dhd_arp_mode;
+
+/* ARP offload enable */
+extern uint dhd_arp_enable;
+
+/* Pkt filte enable control */
+extern uint dhd_pkt_filter_enable;
+
+/*  Pkt filter init setup */
+extern uint dhd_pkt_filter_init;
+
+/* Pkt filter mode control */
+extern uint dhd_master_mode;
+
+/* Roaming mode control */
+extern uint dhd_roam;
+
+/* Roaming mode control */
+extern uint dhd_radio_up;
+
+/* Initial idletime ticks (may be -1 for immediate idle, 0 for no idle) */
+extern int dhd_idletime;
+#define DHD_IDLETIME_TICKS 1
+
+/* SDIO Drive Strength */
+extern uint dhd_sdiod_drive_strength;
+
+/* Override to force tx queueing all the time */
+extern uint dhd_force_tx_queueing;
+
+#ifdef SDTEST
+/* Echo packet generator (SDIO), pkts/s */
+extern uint dhd_pktgen;
+
+/* Echo packet len (0 => sawtooth, max 1800) */
+extern uint dhd_pktgen_len;
+#define MAX_PKTGEN_LEN 1800
+#endif
+
+extern char fw_path[MOD_PARAM_PATHLEN];
+extern char nv_path[MOD_PARAM_PATHLEN];
+
+extern u32 g_assert_type;
 
 static inline void MUTEX_LOCK_INIT(dhd_pub_t *dhdp)
 {
@@ -205,13 +743,6 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
 {
 }
 
-typedef struct dhd_if_event {
-	u8 ifidx;
-	u8 action;
-	u8 flags;
-	u8 bssidx;
-} dhd_if_event_t;
-
 /*
  * Exported from dhd OS modules (dhd_linux/dhd_ndis)
  */
@@ -286,13 +817,6 @@ extern void dhd_os_sdtxunlock(dhd_pub_t *pub);
 
 int setScheduler(struct task_struct *p, int policy, struct sched_param *param);
 
-typedef struct {
-	u32 limit;		/* Expiration time (usec) */
-	u32 increment;	/* Current expiration increment (usec) */
-	u32 elapsed;		/* Current elapsed time (usec) */
-	u32 tick;		/* O/S tick time (usec) */
-} dhd_timeout_t;
-
 extern void dhd_timeout_start(dhd_timeout_t *tmo, uint usec);
 extern int dhd_timeout_expired(dhd_timeout_t *tmo);
 
@@ -324,85 +848,9 @@ extern int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag);
 extern uint dhd_bus_status(dhd_pub_t *dhdp);
 extern int dhd_bus_start(dhd_pub_t *dhdp);
 
-enum cust_gpio_modes {
-	WLAN_RESET_ON,
-	WLAN_RESET_OFF,
-	WLAN_POWER_ON,
-	WLAN_POWER_OFF
-};
-/*
- * Insmod parameters for debug/test
- */
-
-/* Watchdog timer interval */
-extern uint dhd_watchdog_ms;
-
-#if defined(DHD_DEBUG)
-/* Console output poll interval */
-extern uint dhd_console_ms;
-#endif				/* defined(DHD_DEBUG) */
-
-/* Use interrupts */
-extern uint dhd_intr;
-
-/* Use polling */
-extern uint dhd_poll;
-
-/* ARP offload agent mode */
-extern uint dhd_arp_mode;
-
-/* ARP offload enable */
-extern uint dhd_arp_enable;
-
-/* Pkt filte enable control */
-extern uint dhd_pkt_filter_enable;
-
-/*  Pkt filter init setup */
-extern uint dhd_pkt_filter_init;
-
-/* Pkt filter mode control */
-extern uint dhd_master_mode;
-
-/* Roaming mode control */
-extern uint dhd_roam;
-
-/* Roaming mode control */
-extern uint dhd_radio_up;
-
-/* Initial idletime ticks (may be -1 for immediate idle, 0 for no idle) */
-extern int dhd_idletime;
-#define DHD_IDLETIME_TICKS 1
-
-/* SDIO Drive Strength */
-extern uint dhd_sdiod_drive_strength;
-
-/* Override to force tx queueing all the time */
-extern uint dhd_force_tx_queueing;
-
-#ifdef SDTEST
-/* Echo packet generator (SDIO), pkts/s */
-extern uint dhd_pktgen;
-
-/* Echo packet len (0 => sawtooth, max 1800) */
-extern uint dhd_pktgen_len;
-#define MAX_PKTGEN_LEN 1800
-#endif
-
-/* optionally set by a module_param_string() */
-#define MOD_PARAM_PATHLEN	2048
-extern char fw_path[MOD_PARAM_PATHLEN];
-extern char nv_path[MOD_PARAM_PATHLEN];
-
-/* For supporting multiple interfaces */
-#define DHD_MAX_IFS	16
-#define DHD_DEL_IF	-0xe
-#define DHD_BAD_IF	-0xf
-
 extern void dhd_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
 extern void dhd_wait_event_wakeup(dhd_pub_t *dhd);
 
-extern u32 g_assert_type;
-
 #ifdef BCMDBG
 #define ASSERT(exp) \
 	  do { if (!(exp)) osl_assert(#exp, __FILE__, __LINE__); } while (0)
@@ -411,4 +859,84 @@ extern void osl_assert(char *exp, char *file, int line);
 #define ASSERT(exp)	do {} while (0)
 #endif  /* defined(BCMDBG) */
 
+/* Linux network driver ioctl encoding */
+typedef struct dhd_ioctl {
+	uint cmd;		/* common ioctl definition */
+	void *buf;		/* pointer to user buffer */
+	uint len;		/* length of user buffer */
+	bool set;		/* get or set request (optional) */
+	uint used;		/* bytes read or written (optional) */
+	uint needed;		/* bytes needed (optional) */
+	uint driver;		/* to identify target driver */
+} dhd_ioctl_t;
+
+/* per-driver magic numbers */
+#define DHD_IOCTL_MAGIC		0x00444944
+
+/* bump this number if you change the ioctl interface */
+#define DHD_IOCTL_VERSION	1
+
+#define	DHD_IOCTL_MAXLEN	8192	/* max length ioctl buffer required */
+#define	DHD_IOCTL_SMLEN	256	/* "small" length ioctl buffer required */
+
+/* common ioctl definitions */
+#define DHD_GET_MAGIC				0
+#define DHD_GET_VERSION				1
+#define DHD_GET_VAR				2
+#define DHD_SET_VAR				3
+
+/* message levels */
+#define DHD_ERROR_VAL	0x0001
+#define DHD_TRACE_VAL	0x0002
+#define DHD_INFO_VAL	0x0004
+#define DHD_DATA_VAL	0x0008
+#define DHD_CTL_VAL	0x0010
+#define DHD_TIMER_VAL	0x0020
+#define DHD_HDRS_VAL	0x0040
+#define DHD_BYTES_VAL	0x0080
+#define DHD_INTR_VAL	0x0100
+#define DHD_LOG_VAL	0x0200
+#define DHD_GLOM_VAL	0x0400
+#define DHD_EVENT_VAL	0x0800
+#define DHD_BTA_VAL	0x1000
+#define DHD_ISCAN_VAL 0x2000
+
+#ifdef SDTEST
+/* For pktgen iovar */
+typedef struct dhd_pktgen {
+	uint version;		/* To allow structure change tracking */
+	uint freq;		/* Max ticks between tx/rx attempts */
+	uint count;		/* Test packets to send/rcv each attempt */
+	uint print;		/* Print counts every <print> attempts */
+	uint total;		/* Total packets (or bursts) */
+	uint minlen;		/* Minimum length of packets to send */
+	uint maxlen;		/* Maximum length of packets to send */
+	uint numsent;		/* Count of test packets sent */
+	uint numrcvd;		/* Count of test packets received */
+	uint numfail;		/* Count of test send failures */
+	uint mode;		/* Test mode (type of test packets) */
+	uint stop;		/* Stop after this many tx failures */
+} dhd_pktgen_t;
+
+/* Version in case structure changes */
+#define DHD_PKTGEN_VERSION 2
+
+/* Type of test packets to use */
+#define DHD_PKTGEN_ECHO		1	/* Send echo requests */
+#define DHD_PKTGEN_SEND		2	/* Send discard packets */
+#define DHD_PKTGEN_RXBURST	3	/* Request dongle send N packets */
+#define DHD_PKTGEN_RECV		4	/* Continuous rx from continuous
+					 tx dongle */
+#endif				/* SDTEST */
+
+/* Enter idle immediately (no timeout) */
+#define DHD_IDLE_IMMEDIATE	(-1)
+
+/* Values for idleclock iovar: other values are the sd_divisor to use
+	 when idle */
+#define DHD_IDLE_ACTIVE	0	/* Do not request any SD clock change
+				 when idle */
+#define DHD_IDLE_STOP   (-1)	/* Request SD clock be stopped
+				 (and use SD1 mode) */
+
 #endif				/* _dhd_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 0bfb93c..5aa5ee4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -24,7 +24,6 @@
 #include <dhd_proto.h>
 #include <dhd_dbg.h>
 #include <msgtrace.h>
-#include <wlioctl.h>
 
 int dhd_msg_level;
 char fw_path[MOD_PARAM_PATHLEN];
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index 1cf6c5d..abd41e3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -20,7 +20,6 @@
 #include <dngl_stats.h>
 #include <dhd.h>
 
-#include <wlioctl.h>
 #include <wl_iw.h>
 
 #define WL_ERROR(fmt, args...) printk(fmt, ##args)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 030d5ff..16b8942 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -18,7 +18,6 @@
 #define _dhd_proto_h_
 
 #include <dhdioctl.h>
-#include <wlioctl.h>
 
 #ifndef IOCTL_RESP_TIMEOUT
 #define IOCTL_RESP_TIMEOUT  2000	/* In milli second */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhdioctl.h b/drivers/staging/brcm80211/brcmfmac/dhdioctl.h
index f0ba535..db0b9e8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhdioctl.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhdioctl.h
@@ -17,84 +17,4 @@
 #ifndef _dhdioctl_h_
 #define	_dhdioctl_h_
 
-/* Linux network driver ioctl encoding */
-typedef struct dhd_ioctl {
-	uint cmd;		/* common ioctl definition */
-	void *buf;		/* pointer to user buffer */
-	uint len;		/* length of user buffer */
-	bool set;		/* get or set request (optional) */
-	uint used;		/* bytes read or written (optional) */
-	uint needed;		/* bytes needed (optional) */
-	uint driver;		/* to identify target driver */
-} dhd_ioctl_t;
-
-/* per-driver magic numbers */
-#define DHD_IOCTL_MAGIC		0x00444944
-
-/* bump this number if you change the ioctl interface */
-#define DHD_IOCTL_VERSION	1
-
-#define	DHD_IOCTL_MAXLEN	8192	/* max length ioctl buffer required */
-#define	DHD_IOCTL_SMLEN	256	/* "small" length ioctl buffer required */
-
-/* common ioctl definitions */
-#define DHD_GET_MAGIC				0
-#define DHD_GET_VERSION				1
-#define DHD_GET_VAR				2
-#define DHD_SET_VAR				3
-
-/* message levels */
-#define DHD_ERROR_VAL	0x0001
-#define DHD_TRACE_VAL	0x0002
-#define DHD_INFO_VAL	0x0004
-#define DHD_DATA_VAL	0x0008
-#define DHD_CTL_VAL	0x0010
-#define DHD_TIMER_VAL	0x0020
-#define DHD_HDRS_VAL	0x0040
-#define DHD_BYTES_VAL	0x0080
-#define DHD_INTR_VAL	0x0100
-#define DHD_LOG_VAL	0x0200
-#define DHD_GLOM_VAL	0x0400
-#define DHD_EVENT_VAL	0x0800
-#define DHD_BTA_VAL	0x1000
-#define DHD_ISCAN_VAL 0x2000
-
-#ifdef SDTEST
-/* For pktgen iovar */
-typedef struct dhd_pktgen {
-	uint version;		/* To allow structure change tracking */
-	uint freq;		/* Max ticks between tx/rx attempts */
-	uint count;		/* Test packets to send/rcv each attempt */
-	uint print;		/* Print counts every <print> attempts */
-	uint total;		/* Total packets (or bursts) */
-	uint minlen;		/* Minimum length of packets to send */
-	uint maxlen;		/* Maximum length of packets to send */
-	uint numsent;		/* Count of test packets sent */
-	uint numrcvd;		/* Count of test packets received */
-	uint numfail;		/* Count of test send failures */
-	uint mode;		/* Test mode (type of test packets) */
-	uint stop;		/* Stop after this many tx failures */
-} dhd_pktgen_t;
-
-/* Version in case structure changes */
-#define DHD_PKTGEN_VERSION 2
-
-/* Type of test packets to use */
-#define DHD_PKTGEN_ECHO		1	/* Send echo requests */
-#define DHD_PKTGEN_SEND		2	/* Send discard packets */
-#define DHD_PKTGEN_RXBURST	3	/* Request dongle send N packets */
-#define DHD_PKTGEN_RECV		4	/* Continuous rx from continuous
-					 tx dongle */
-#endif				/* SDTEST */
-
-/* Enter idle immediately (no timeout) */
-#define DHD_IDLE_IMMEDIATE	(-1)
-
-/* Values for idleclock iovar: other values are the sd_divisor to use
-	 when idle */
-#define DHD_IDLE_ACTIVE	0	/* Do not request any SD clock change
-				 when idle */
-#define DHD_IDLE_STOP   (-1)	/* Request SD clock be stopped
-				 (and use SD1 mode) */
-
 #endif				/* _dhdioctl_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 945e039..fa005d3 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -24,7 +24,6 @@
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <dhdioctl.h>
-#include <wlioctl.h>
 
 #include <linux/kthread.h>
 #include <linux/netdevice.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 996033c..4bd0392 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -20,7 +20,6 @@
 #include <linux/wireless.h>
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
-#include <wlioctl.h>
 
 struct wl_conf;
 struct wl_iface;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 929ceaf..b284b12 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -18,7 +18,6 @@
 #include <linux/semaphore.h>
 #include <bcmdefs.h>
 #include <linux/netdevice.h>
-#include <wlioctl.h>
 
 #include <bcmutils.h>
 
@@ -30,7 +29,6 @@
 #include <dhdioctl.h>
 #include <linux/ieee80211.h>
 typedef const struct si_pub si_t;
-#include <wlioctl.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
@@ -115,6 +113,24 @@ typedef struct iscan_info {
 } iscan_info_t;
 iscan_info_t *g_iscan;
 
+typedef enum sup_auth_status {
+	WLC_SUP_DISCONNECTED = 0,
+	WLC_SUP_CONNECTING,
+	WLC_SUP_IDREQUIRED,
+	WLC_SUP_AUTHENTICATING,
+	WLC_SUP_AUTHENTICATED,
+	WLC_SUP_KEYXCHANGE,
+	WLC_SUP_KEYED,
+	WLC_SUP_TIMEOUT,
+	WLC_SUP_LAST_BASIC_STATE,
+	WLC_SUP_KEYXCHANGE_WAIT_M1 = WLC_SUP_AUTHENTICATED,
+	WLC_SUP_KEYXCHANGE_PREP_M2 = WLC_SUP_KEYXCHANGE,
+	WLC_SUP_KEYXCHANGE_WAIT_M3 = WLC_SUP_LAST_BASIC_STATE,
+	WLC_SUP_KEYXCHANGE_PREP_M4,
+	WLC_SUP_KEYXCHANGE_WAIT_G1,
+	WLC_SUP_KEYXCHANGE_PREP_G2
+} sup_auth_status_t;
+
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 /* Global ASSERT type flag */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index fe06174..c92a8b5 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -19,8 +19,6 @@
 
 #include <linux/wireless.h>
 
-#include <wlioctl.h>
-
 #define WL_SCAN_PARAMS_SSID_MAX	10
 #define GET_SSID	"SSID="
 #define GET_CHANNEL	"CH="
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom_tbl.h b/drivers/staging/brcm80211/brcmsmac/bcmsrom_tbl.h
index f4b3e61..a41e62c 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom_tbl.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom_tbl.h
@@ -17,8 +17,6 @@
 #ifndef	_bcmsrom_tbl_h_
 #define	_bcmsrom_tbl_h_
 
-#include "wlioctl.h"
-
 typedef struct {
 	const char *name;
 	u32 revmask;
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index d91e418..cb434e5 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -17,14 +17,9 @@
 #ifndef	_D11_H
 #define	_D11_H
 
+#include <linux/ieee80211.h>
 #include <sbconfig.h>
 
-#ifndef WL_RSSI_ANT_MAX
-#define WL_RSSI_ANT_MAX		4	/* max possible rx antennas */
-#elif WL_RSSI_ANT_MAX != 4
-#error "WL_RSSI_ANT_MAX does not match"
-#endif
-
 /* cpp contortions to concatenate w/arg prescan */
 #ifndef	PAD
 #define	_PADLINE(line)	pad ## line
@@ -56,6 +51,12 @@
 #define	TX_DATA_FIFO		TX_AC_BE_FIFO
 #define	TX_CTL_FIFO		TX_AC_VO_FIFO
 
+#ifndef WL_RSSI_ANT_MAX
+#define WL_RSSI_ANT_MAX		4	/* max possible rx antennas */
+#elif WL_RSSI_ANT_MAX != 4
+#error "WL_RSSI_ANT_MAX does not match"
+#endif
+
 typedef volatile struct {
 	u32 intstatus;
 	u32 intmask;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index 1ef96c7..93e3db9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -14,14 +14,18 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+/*
+ * wlc_phy_hal.h:  functionality exported from the phy to higher layers
+ */
+
 #ifndef _wlc_phy_h_
 #define _wlc_phy_h_
 
-#include <wlioctl.h>
 #include <aiutils.h>
 #include <d11.h>
 #include <wlc_phy_shim.h>
 #include <net/mac80211.h>	/* struct wiphy */
+#include "bcmwifi.h"		/* chanspec_t */
 
 #define	IDCODE_VER_MASK		0x0000000f
 #define	IDCODE_VER_SHIFT	0
@@ -87,12 +91,20 @@
 
 #define WLC_TXPWR_DB_FACTOR	4
 
+/* a large TX Power as an init value to factor out of min() calculations,
+ * keep low enough to fit in an s8, units are .25 dBm
+ */
+#define WLC_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
+
 #define WLC_NUM_RATES_CCK           4
 #define WLC_NUM_RATES_OFDM          8
 #define WLC_NUM_RATES_MCS_1_STREAM  8
 #define WLC_NUM_RATES_MCS_2_STREAM  8
 #define WLC_NUM_RATES_MCS_3_STREAM  8
 #define WLC_NUM_RATES_MCS_4_STREAM  8
+
+#define	WLC_RSSI_INVALID	 0	/* invalid RSSI value */
+
 typedef struct txpwr_limits {
 	u8 cck[WLC_NUM_RATES_CCK];
 	u8 ofdm[WLC_NUM_RATES_OFDM];
@@ -115,6 +127,32 @@ typedef struct txpwr_limits {
 } txpwr_limits_t;
 
 typedef struct {
+	u32 flags;
+	chanspec_t chanspec;	/* txpwr report for this channel */
+	chanspec_t local_chanspec;	/* channel on which we are associated */
+	u8 local_max;	/* local max according to the AP */
+	u8 local_constraint;	/* local constraint according to the AP */
+	s8 antgain[2];	/* Ant gain for each band - from SROM */
+	u8 rf_cores;		/* count of RF Cores being reported */
+	u8 est_Pout[4];	/* Latest tx power out estimate per RF chain */
+	u8 est_Pout_act[4];	/* Latest tx power out estimate per RF chain
+				 * without adjustment
+				 */
+	u8 est_Pout_cck;	/* Latest CCK tx power out estimate */
+	u8 tx_power_max[4];	/* Maximum target power among all rates */
+	u8 tx_power_max_rate_ind[4];	/* Index of the rate with the max target power */
+	u8 user_limit[WL_TX_POWER_RATES];	/* User limit */
+	u8 reg_limit[WL_TX_POWER_RATES];	/* Regulatory power limit */
+	u8 board_limit[WL_TX_POWER_RATES];	/* Max power board can support (SROM) */
+	u8 target[WL_TX_POWER_RATES];	/* Latest target power */
+} tx_power_t;
+
+typedef struct tx_inst_power {
+	u8 txpwr_est_Pout[2];	/* Latest estimate for 2.4 and 5 Ghz */
+	u8 txpwr_est_Pout_gofdm;	/* Pwr estimate for 2.4 OFDM */
+} tx_inst_power_t;
+
+typedef struct {
 	u8 vec[MAXCHANNEL / NBBY];
 } chanvec_t;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index 5582de3..8cc6b1a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
@@ -19,7 +19,7 @@
 
 #include <linux/device.h>			/* dev_err() */
 
-/* wl_msg_level is a bit vector with defs in wlioctl.h */
+/* wl_msg_level is a bit vector with defs in bcmdefs.h */
 extern u32 wl_msg_level;
 
 #define BCMMSG(dev, fmt, args...)		\
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index f951f22..105f426 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -32,7 +32,6 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <pcicfg.h>
-#include <wlioctl.h>
 #include <sbhnddma.h>
 
 #include "phy/wlc_phy_int.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
index c878690..fafde6a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
@@ -17,6 +17,10 @@
 #ifndef _wl_mac80211_h_
 #define _wl_mac80211_h_
 
+/* softmac ioctl definitions */
+#define WLC_SET_SHORTSLOT_OVERRIDE		146
+
+
 /* BMAC Note: High-only driver is no longer working in softirq context as it needs to block and
  * sleep so perimeter lock has to be a semaphore instead of spinlock. This requires timers to be
  * submitted to workqueue instead of being on kernel timer
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index 3c4b2c0..3b04e02 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -19,7 +19,6 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <wlioctl.h>
 #include <sbhnddma.h>
 
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 75343ab..c83896b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -19,7 +19,6 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <wlioctl.h>
 #include <sbhnddma.h>
 #include <hnddma.h>
 #include <d11.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index 111ef32..efdc62a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -26,7 +26,6 @@
 #include <aiutils.h>
 #include <bcmdevs.h>
 #include <sbhnddma.h>
-#include <wlioctl.h>
 
 #include "d11.h"
 #include "wlc_rate.h"
@@ -39,9 +38,15 @@
 #include "wlc_channel.h"
 #include "wlc_main.h"
 #include "wl_export.h"
-#include "wlc_phy_shim.h"
 #include "wlc_antsel.h"
 
+#define ANT_SELCFG_AUTO		0x80	/* bit indicates antenna sel AUTO */
+#define ANT_SELCFG_MASK		0x33	/* antenna configuration mask */
+#define ANT_SELCFG_TX_UNICAST	0	/* unicast tx antenna configuration */
+#define ANT_SELCFG_RX_UNICAST	1	/* unicast rx antenna configuration */
+#define ANT_SELCFG_TX_DEF	2	/* default tx antenna configuration */
+#define ANT_SELCFG_RX_DEF	3	/* default rx antenna configuration */
+
 /* useful macros */
 #define WLC_ANTSEL_11N_0(ant)	((((ant) & ANT_SELCFG_MASK) >> 4) & 0xf)
 #define WLC_ANTSEL_11N_1(ant)	(((ant) & ANT_SELCFG_MASK) & 0xf)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 9ef7707..adc06fc 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -30,7 +30,6 @@
 #include <bcmotp.h>
 #include <bcmutils.h>
 #include <bcmnvram.h>
-#include <wlioctl.h>
 #include <sbconfig.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
@@ -45,7 +44,6 @@
 #include "wlc_scb.h"
 #include "wlc_pub.h"
 #include "wlc_key.h"
-#include "wlc_phy_shim.h"
 #include "phy/wlc_phy_hal.h"
 #include "wlc_channel.h"
 #include "wlc_main.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index a3a2bf9..9e29339 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -24,7 +24,6 @@
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include <sbhnddma.h>
-#include <wlioctl.h>
 
 #include "wlc_types.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_key.h b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
index cab10c7..f4bced5 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_key.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
@@ -17,6 +17,8 @@
 #ifndef _wlc_key_h_
 #define _wlc_key_h_
 
+#include <linux/if_ether.h>	/* for ETH_ALEN */
+
 struct scb;
 struct wlc_info;
 struct wlc_bsscfg;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index c1257d4..0837e8d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -27,7 +27,6 @@
 #include <aiutils.h>
 #include <pcicfg.h>
 #include <bcmsrom.h>
-#include <wlioctl.h>
 #include <sbhnddma.h>
 #include <hnddma.h>
 
@@ -45,14 +44,12 @@
 #include "wlc_main.h"
 #include "wlc_bmac.h"
 #include "wlc_phy_hal.h"
-#include "wlc_phy_shim.h"
 #include "wlc_antsel.h"
 #include "wlc_stf.h"
 #include "wlc_ampdu.h"
 #include "wl_export.h"
 #include "wlc_alloc.h"
 #include "wl_dbg.h"
-
 #include "wl_mac80211.h"
 
 /*
@@ -93,6 +90,30 @@
 
 #define	TBTT_ALIGN_LEEWAY_US	100	/* min leeway before first TBTT in us */
 
+/* Software feature flag defines used by wlfeatureflag */
+#define WL_SWFL_NOHWRADIO	0x0004
+#define WL_SWFL_FLOWCONTROL     0x0008	/* Enable backpressure to OS stack */
+#define WL_SWFL_WLBSSSORT	0x0010	/* Per-port supports sorting of BSS */
+
+/* n-mode support capability */
+/* 2x2 includes both 1x1 & 2x2 devices
+ * reserved #define 2 for future when we want to separate 1x1 & 2x2 and
+ * control it independently
+ */
+#define WL_11N_2x2			1
+#define WL_11N_3x3			3
+#define WL_11N_4x4			4
+
+/* define 11n feature disable flags */
+#define WLFEATURE_DISABLE_11N		0x00000001
+#define WLFEATURE_DISABLE_11N_STBC_TX	0x00000002
+#define WLFEATURE_DISABLE_11N_STBC_RX	0x00000004
+#define WLFEATURE_DISABLE_11N_SGI_TX	0x00000008
+#define WLFEATURE_DISABLE_11N_SGI_RX	0x00000010
+#define WLFEATURE_DISABLE_11N_AMPDU_TX	0x00000020
+#define WLFEATURE_DISABLE_11N_AMPDU_RX	0x00000040
+#define WLFEATURE_DISABLE_11N_GF	0x00000080
+
 /*
  * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s OS timer(soft
  * watchdog) it is not a wall clock and won't increment when driver is in "down" state
@@ -2428,7 +2449,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	struct scb *nextscb;
 	bool ta_ok;
 	uint band;
-	rw_reg_t *r;
 	struct wlc_bsscfg *bsscfg;
 	wlc_bss_info_t *current_bss;
 
@@ -2440,7 +2460,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	nextscb = NULL;
 	ta_ok = false;
 	band = 0;
-	r = NULL;
 
 	/* If the device is turned off, then it's not "removed" */
 	if (!wlc->pub->hw_off && DEVICEREMOVED(wlc)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index edbf3d2..3bbb774 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -290,7 +290,7 @@ struct wlcband {
 	wlc_phy_t *pi;		/* pointer to phy specific information */
 	bool abgphy_encore;
 
-	u8 gmode;		/* currently active gmode (see wlioctl.h) */
+	u8 gmode;		/* currently active gmode */
 
 	struct scb *hwrs_scb;	/* permanent scb for hw rateset */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index 16fea02..c33b61b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -30,7 +30,6 @@
 #include <bcmutils.h>
 #include <bcmwifi.h>
 #include <aiutils.h>
-#include <wlioctl.h>
 #include <sbconfig.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h
index c151a5d..124d3fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h
@@ -14,6 +14,10 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+/*
+ * wlc_phy_shim.h: stuff defined in wlc_phy_shim.c and included only by the phy
+ */
+
 #ifndef _wlc_phy_shim_h_
 #define _wlc_phy_shim_h_
 
@@ -51,6 +55,57 @@
 #define	ANT_RX_DIV_ENABLE		3	/* APHY bbConfig Enable RX Diversity */
 #define ANT_RX_DIV_DEF		ANT_RX_DIV_START_0	/* default antdiv setting */
 
+#define WL_ANT_RX_MAX		2	/* max 2 receive antennas */
+#define WL_ANT_HT_RX_MAX	3	/* max 3 receive antennas/cores */
+#define WL_ANT_IDX_1		0	/* antenna index 1 */
+#define WL_ANT_IDX_2		1	/* antenna index 2 */
+
+/* values for n_preamble_type */
+#define WLC_N_PREAMBLE_MIXEDMODE	0
+#define WLC_N_PREAMBLE_GF		1
+#define WLC_N_PREAMBLE_GF_BRCM          2
+
+#define WL_TX_POWER_RATES_LEGACY	45
+#define WL_TX_POWER_MCS20_FIRST	        12
+#define WL_TX_POWER_MCS20_NUM	        16
+#define WL_TX_POWER_MCS40_FIRST	        28
+#define WL_TX_POWER_MCS40_NUM	        17
+
+
+#define WL_TX_POWER_RATES	       101
+#define WL_TX_POWER_CCK_FIRST	       0
+#define WL_TX_POWER_CCK_NUM	       4
+#define WL_TX_POWER_OFDM_FIRST	       4	/* Index for first 20MHz OFDM SISO rate */
+#define WL_TX_POWER_OFDM20_CDD_FIRST   12	/* Index for first 20MHz OFDM CDD rate */
+#define WL_TX_POWER_OFDM40_SISO_FIRST  52	/* Index for first 40MHz OFDM SISO rate */
+#define WL_TX_POWER_OFDM40_CDD_FIRST   60	/* Index for first 40MHz OFDM CDD rate */
+#define WL_TX_POWER_OFDM_NUM	       8
+#define WL_TX_POWER_MCS20_SISO_FIRST   20	/* Index for first 20MHz MCS SISO rate */
+#define WL_TX_POWER_MCS20_CDD_FIRST    28	/* Index for first 20MHz MCS CDD rate */
+#define WL_TX_POWER_MCS20_STBC_FIRST   36	/* Index for first 20MHz MCS STBC rate */
+#define WL_TX_POWER_MCS20_SDM_FIRST    44	/* Index for first 20MHz MCS SDM rate */
+#define WL_TX_POWER_MCS40_SISO_FIRST   68	/* Index for first 40MHz MCS SISO rate */
+#define WL_TX_POWER_MCS40_CDD_FIRST    76	/* Index for first 40MHz MCS CDD rate */
+#define WL_TX_POWER_MCS40_STBC_FIRST   84	/* Index for first 40MHz MCS STBC rate */
+#define WL_TX_POWER_MCS40_SDM_FIRST    92	/* Index for first 40MHz MCS SDM rate */
+#define WL_TX_POWER_MCS_1_STREAM_NUM   8
+#define WL_TX_POWER_MCS_2_STREAM_NUM   8
+#define WL_TX_POWER_MCS_32	       100	/* Index for 40MHz rate MCS 32 */
+#define WL_TX_POWER_MCS_32_NUM	       1
+
+/* sslpnphy specifics */
+#define WL_TX_POWER_MCS20_SISO_FIRST_SSN   12	/* Index for first 20MHz MCS SISO rate */
+
+/* tx_power_t.flags bits */
+#define WL_TX_POWER_F_ENABLED	1
+#define WL_TX_POWER_F_HW	2
+#define WL_TX_POWER_F_MIMO	4
+#define WL_TX_POWER_F_SISO	8
+
+/* values to force tx/rx chain */
+#define WLC_N_TXRX_CHAIN0		0
+#define WLC_N_TXRX_CHAIN1		1
+
 /* Forward declarations */
 struct wlc_hw_info;
 typedef struct wlc_phy_shim_info wlc_phy_shim_info_t;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index b3a79ab..2bbf995 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -17,6 +17,9 @@
 #ifndef _wlc_pub_h_
 #define _wlc_pub_h_
 
+#include "proto/802.11.h"	/* for MCSSET_LEN */
+#include "bcmwifi.h"		/* for chanspec_t */
+
 #define	WLC_NUMRATES	16	/* max # of rates in a rateset */
 #define	MAXMULTILIST	32	/* max # multicast addresses */
 #define	D11_PHY_HDR_LEN	6	/* Phy header length - 6 bytes */
@@ -96,6 +99,12 @@
 #define AIDMAPSZ	(roundup(MAXSCB, NBBY)/NBBY)	/* aid bitmap size in bytes */
 #endif				/* AIDMAPSZ */
 
+#define MAX_STREAMS_SUPPORTED	4	/* max number of streams supported */
+
+#define	WL_SPURAVOID_OFF	0
+#define	WL_SPURAVOID_ON1	1
+#define	WL_SPURAVOID_ON2	2
+
 struct ieee80211_tx_queue_params;
 
 typedef struct wlc_tunables {
@@ -151,7 +160,7 @@ struct rsn_parms {
 	IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_GRN_FLD |\
 	IEEE80211_HT_CAP_MAX_AMSDU | IEEE80211_HT_CAP_DSSSCCK40)
 
-/* wlc internal bss_info, wl external one is in wlioctl.h */
+/* wlc internal bss_info */
 typedef struct wlc_bss_info {
 	u8 BSSID[ETH_ALEN];	/* network BSSID */
 	u16 flags;		/* flags for internal attributes */
@@ -489,6 +498,98 @@ extern const u8 wme_fifo2ac[];
 #define	WLC_PROT_N_PAM_OVR	15	/* n preamble override */
 #define	WLC_PROT_N_OBSS		16	/* non-HT OBSS present */
 
+/*
+ * 54g modes (basic bits may still be overridden)
+ *
+ * GMODE_LEGACY_B			Rateset: 1b, 2b, 5.5, 11
+ *					Preamble: Long
+ *					Shortslot: Off
+ * GMODE_AUTO				Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
+ *					Extended Rateset: 6, 9, 12, 48
+ *					Preamble: Long
+ *					Shortslot: Auto
+ * GMODE_ONLY				Rateset: 1b, 2b, 5.5b, 11b, 18, 24b, 36, 54
+ *					Extended Rateset: 6b, 9, 12b, 48
+ *					Preamble: Short required
+ *					Shortslot: Auto
+ * GMODE_B_DEFERRED			Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
+ *					Extended Rateset: 6, 9, 12, 48
+ *					Preamble: Long
+ *					Shortslot: On
+ * GMODE_PERFORMANCE			Rateset: 1b, 2b, 5.5b, 6b, 9, 11b, 12b, 18, 24b, 36, 48, 54
+ *					Preamble: Short required
+ *					Shortslot: On and required
+ * GMODE_LRS				Rateset: 1b, 2b, 5.5b, 11b
+ *					Extended Rateset: 6, 9, 12, 18, 24, 36, 48, 54
+ *					Preamble: Long
+ *					Shortslot: Auto
+ */
+#define GMODE_LEGACY_B		0
+#define GMODE_AUTO		1
+#define GMODE_ONLY		2
+#define GMODE_B_DEFERRED	3
+#define GMODE_PERFORMANCE	4
+#define GMODE_LRS		5
+#define GMODE_MAX		6
+
+/* values for PLCPHdr_override */
+#define WLC_PLCP_AUTO	-1
+#define WLC_PLCP_SHORT	0
+#define WLC_PLCP_LONG	1
+
+/* values for g_protection_override and n_protection_override */
+#define WLC_PROTECTION_AUTO		-1
+#define WLC_PROTECTION_OFF		0
+#define WLC_PROTECTION_ON		1
+#define WLC_PROTECTION_MMHDR_ONLY	2
+#define WLC_PROTECTION_CTS_ONLY		3
+
+/* values for g_protection_control and n_protection_control */
+#define WLC_PROTECTION_CTL_OFF		0
+#define WLC_PROTECTION_CTL_LOCAL	1
+#define WLC_PROTECTION_CTL_OVERLAP	2
+
+/* values for n_protection */
+#define WLC_N_PROTECTION_OFF		0
+#define WLC_N_PROTECTION_OPTIONAL	1
+#define WLC_N_PROTECTION_20IN40		2
+#define WLC_N_PROTECTION_MIXEDMODE	3
+
+/* values for band specific 40MHz capabilities */
+#define WLC_N_BW_20ALL			0
+#define WLC_N_BW_40ALL			1
+#define WLC_N_BW_20IN2G_40IN5G		2
+
+/* bitflags for SGI support (sgi_rx iovar) */
+#define WLC_N_SGI_20			0x01
+#define WLC_N_SGI_40			0x02
+
+/* defines used by the nrate iovar */
+#define NRATE_MCS_INUSE	0x00000080	/* MSC in use,indicates b0-6 holds an mcs */
+#define NRATE_RATE_MASK 0x0000007f	/* rate/mcs value */
+#define NRATE_STF_MASK	0x0000ff00	/* stf mode mask: siso, cdd, stbc, sdm */
+#define NRATE_STF_SHIFT	8	/* stf mode shift */
+#define NRATE_OVERRIDE	0x80000000	/* bit indicates override both rate & mode */
+#define NRATE_OVERRIDE_MCS_ONLY 0x40000000	/* bit indicate to override mcs only */
+#define NRATE_SGI_MASK  0x00800000	/* sgi mode */
+#define NRATE_SGI_SHIFT 23	/* sgi mode */
+#define NRATE_LDPC_CODING 0x00400000	/* bit indicates adv coding in use */
+#define NRATE_LDPC_SHIFT 22	/* ldpc shift */
+
+#define NRATE_STF_SISO	0	/* stf mode SISO */
+#define NRATE_STF_CDD	1	/* stf mode CDD */
+#define NRATE_STF_STBC	2	/* stf mode STBC */
+#define NRATE_STF_SDM	3	/* stf mode SDM */
+
+#define ANT_SELCFG_MAX		4	/* max number of antenna configurations */
+
+#define HIGHEST_SINGLE_STREAM_MCS	7	/* MCS values greater than this enable multiple streams */
+
+typedef struct {
+	u8 ant_config[ANT_SELCFG_MAX];	/* antenna configuration */
+	u8 num_antcfg;	/* number of available antenna configurations */
+} wlc_antselcfg_t;
+
 /* common functions for every port */
 extern void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 			bool piomode, void *regsva, uint bustype, void *btparam,
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 87b252d..6c9574a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -20,7 +20,6 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <wlioctl.h>
 #include <sbhnddma.h>
 
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_scb.h b/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
index f07a891..fd7767c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
@@ -17,6 +17,8 @@
 #ifndef _wlc_scb_h_
 #define _wlc_scb_h_
 
+#include <linux/if_ether.h>	/* for ETH_ALEN */
+
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
 /* structure to store per-tid state for the ampdu initiator */
 typedef struct scb_ampdu_tid_ini {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index 544d883..ca1b8aa 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -22,7 +22,6 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <wlioctl.h>
 #include <bcmwifi.h>
 #include <bcmnvram.h>
 #include <sbhnddma.h>
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 55631f3..6500547 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -147,4 +147,56 @@ typedef struct {
 struct wl_info;
 struct wlc_bsscfg;
 
+#define WL_NUMRATES		16	/* max # of rates in a rateset */
+typedef struct wl_rateset {
+	u32 count;		/* # rates in this set */
+	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
+} wl_rateset_t;
+
+#define WLC_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
+
+#define WLC_SET_CHANNEL				30
+#define WLC_SET_SRL				32
+#define WLC_SET_LRL				34
+
+#define WLC_SET_RATESET				72
+#define WLC_SET_BCNPRD				76
+#define WLC_GET_CURR_RATESET			114	/* current rateset */
+#define WLC_GET_PHYLIST				180
+
+/* Bit masks for radio disabled status - returned by WL_GET_RADIO */
+#define WL_RADIO_SW_DISABLE		(1<<0)
+#define WL_RADIO_HW_DISABLE		(1<<1)
+#define WL_RADIO_MPC_DISABLE		(1<<2)
+#define WL_RADIO_COUNTRY_DISABLE	(1<<3)	/* some countries don't support any channel */
+
+/* Override bit for WLC_SET_TXPWR.  if set, ignore other level limits */
+#define WL_TXPWR_OVERRIDE	(1U<<31)
+
+/* band types */
+#define	WLC_BAND_AUTO		0	/* auto-select */
+#define	WLC_BAND_5G		1	/* 5 Ghz */
+#define	WLC_BAND_2G		2	/* 2.4 Ghz */
+#define	WLC_BAND_ALL		3	/* all bands */
+
+/* Values for PM */
+#define PM_OFF	0
+#define PM_MAX	1
+
+/* Message levels */
+#define WL_ERROR_VAL		0x00000001
+#define WL_TRACE_VAL		0x00000002
+
+#define	NFIFO			6	/* # tx/rx fifopairs */
+
+#define PM_OFF	0
+#define PM_MAX	1
+#define PM_FAST 2
+
+/* band range returned by band_range iovar */
+#define WL_CHAN_FREQ_RANGE_2G      0
+#define WL_CHAN_FREQ_RANGE_5GL     1
+#define WL_CHAN_FREQ_RANGE_5GM     2
+#define WL_CHAN_FREQ_RANGE_5GH     3
+
 #endif				/* _bcmdefs_h_ */
diff --git a/drivers/staging/brcm80211/include/bcmwifi.h b/drivers/staging/brcm80211/include/bcmwifi.h
index a573ebf..f0dc6f8 100644
--- a/drivers/staging/brcm80211/include/bcmwifi.h
+++ b/drivers/staging/brcm80211/include/bcmwifi.h
@@ -17,6 +17,9 @@
 #ifndef	_bcmwifi_h_
 #define	_bcmwifi_h_
 
+#include <linux/if_ether.h>		/* for ETH_ALEN */
+#include <linux/ieee80211.h>		/* for WLAN_PMKID_LEN */
+
 /* A chanspec holds the channel number, band, bandwidth and control sideband */
 typedef u16 chanspec_t;
 
@@ -164,4 +167,59 @@ extern u8 bcm_chspec_ctlchan(chanspec_t chspec);
  */
 extern int bcm_mhz2channel(uint freq, uint start_factor);
 
+/* Enumerate crypto algorithms */
+#define	CRYPTO_ALGO_OFF			0
+#define	CRYPTO_ALGO_WEP1		1
+#define	CRYPTO_ALGO_TKIP		2
+#define	CRYPTO_ALGO_WEP128		3
+#define CRYPTO_ALGO_AES_CCM		4
+#define CRYPTO_ALGO_AES_RESERVED1	5
+#define CRYPTO_ALGO_AES_RESERVED2	6
+#define CRYPTO_ALGO_NALG		7
+
+/* wireless security bitvec */
+#define WEP_ENABLED		0x0001
+#define TKIP_ENABLED		0x0002
+#define AES_ENABLED		0x0004
+#define WSEC_SWFLAG		0x0008
+#define SES_OW_ENABLED		0x0040	/* to go into transition mode without setting wep */
+
+/* WPA authentication mode bitvec */
+#define WPA_AUTH_DISABLED	0x0000	/* Legacy (i.e., non-WPA) */
+#define WPA_AUTH_NONE		0x0001	/* none (IBSS) */
+#define WPA_AUTH_UNSPECIFIED	0x0002	/* over 802.1x */
+#define WPA_AUTH_PSK		0x0004	/* Pre-shared key */
+#define WPA_AUTH_RESERVED1	0x0008
+#define WPA_AUTH_RESERVED2	0x0010
+					/* #define WPA_AUTH_8021X 0x0020 *//* 802.1x, reserved */
+#define WPA2_AUTH_RESERVED1	0x0020
+#define WPA2_AUTH_UNSPECIFIED	0x0040	/* over 802.1x */
+#define WPA2_AUTH_PSK		0x0080	/* Pre-shared key */
+#define WPA2_AUTH_RESERVED3	0x0200
+#define WPA2_AUTH_RESERVED4	0x0400
+#define WPA2_AUTH_RESERVED5	0x0800
+
+/* pmkid */
+#define	MAXPMKID		16
+
+typedef struct _pmkid {
+	u8 BSSID[ETH_ALEN];
+	u8 PMKID[WLAN_PMKID_LEN];
+} pmkid_t;
+
+typedef struct _pmkid_list {
+	u32 npmkid;
+	pmkid_t pmkid[1];
+} pmkid_list_t;
+
+typedef struct _pmkid_cand {
+	u8 BSSID[ETH_ALEN];
+	u8 preauth;
+} pmkid_cand_t;
+
+typedef struct _pmkid_cand_list {
+	u32 npmkid_cand;
+	pmkid_cand_t pmkid_cand[1];
+} pmkid_cand_list_t;
+
 #endif				/* _bcmwifi_h_ */
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 2876bd9..281ca70 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -17,1349 +17,4 @@
 #ifndef _wlioctl_h_
 #define	_wlioctl_h_
 
-#include <linux/ieee80211.h>
-#ifdef BRCM_FULLMAC
-#include <proto/bcmeth.h>
-#endif
-#include <proto/bcmevent.h>
-#include <proto/802.11.h>
-#include <bcmwifi.h>
-
-#ifndef INTF_NAME_SIZ
-#define INTF_NAME_SIZ	16
-#endif
-
-#ifdef BRCM_FULLMAC
-
-#define	WL_BSS_INFO_VERSION	108	/* current ver of wl_bss_info struct */
-
-/* BSS info structure
- * Applications MUST CHECK ie_offset field and length field to access IEs and
- * next bss_info structure in a vector (in wl_scan_results_t)
- */
-typedef struct wl_bss_info {
-	u32 version;		/* version field */
-	u32 length;		/* byte length of data in this record,
-				 * starting at version and including IEs
-				 */
-	u8 BSSID[ETH_ALEN];
-	u16 beacon_period;	/* units are Kusec */
-	u16 capability;	/* Capability information */
-	u8 SSID_len;
-	u8 SSID[32];
-	struct {
-		uint count;	/* # rates in this set */
-		u8 rates[16];	/* rates in 500kbps units w/hi bit set if basic */
-	} rateset;		/* supported rates */
-	chanspec_t chanspec;	/* chanspec for bss */
-	u16 atim_window;	/* units are Kusec */
-	u8 dtim_period;	/* DTIM period */
-	s16 RSSI;		/* receive signal strength (in dBm) */
-	s8 phy_noise;		/* noise (in dBm) */
-
-	u8 n_cap;		/* BSS is 802.11N Capable */
-	u32 nbss_cap;	/* 802.11N BSS Capabilities (based on HT_CAP_*) */
-	u8 ctl_ch;		/* 802.11N BSS control channel number */
-	u32 reserved32[1];	/* Reserved for expansion of BSS properties */
-	u8 flags;		/* flags */
-	u8 reserved[3];	/* Reserved for expansion of BSS properties */
-	u8 basic_mcs[MCSSET_LEN];	/* 802.11N BSS required MCS set */
-
-	u16 ie_offset;	/* offset at which IEs start, from beginning */
-	u32 ie_length;	/* byte length of Information Elements */
-	s16 SNR;		/* average SNR of during frame reception */
-	/* Add new fields here */
-	/* variable length Information Elements */
-} wl_bss_info_t;
-#endif /* BRCM_FULLMAC */
-
-typedef struct wlc_ssid {
-	u32 SSID_len;
-	unsigned char SSID[32];
-} wlc_ssid_t;
-
-#ifdef BRCM_FULLMAC
-typedef struct chan_scandata {
-	u8 txpower;
-	u8 pad;
-	chanspec_t channel;	/* Channel num, bw, ctrl_sb and band */
-	u32 channel_mintime;
-	u32 channel_maxtime;
-} chan_scandata_t;
-
-typedef enum wl_scan_type {
-	EXTDSCAN_FOREGROUND_SCAN,
-	EXTDSCAN_BACKGROUND_SCAN,
-	EXTDSCAN_FORCEDBACKGROUND_SCAN
-} wl_scan_type_t;
-
-#define WLC_EXTDSCAN_MAX_SSID		5
-
-#define WL_BSS_FLAGS_FROM_BEACON	0x01	/* bss_info derived from beacon */
-#define WL_BSS_FLAGS_FROM_CACHE		0x02	/* bss_info collected from cache */
-#define WL_BSS_FLAGS_RSSI_ONCHANNEL     0x04	/* rssi info was received on channel (vs offchannel) */
-
-typedef struct wl_extdscan_params {
-	s8 nprobes;		/* 0, passive, otherwise active */
-	s8 split_scan;	/* split scan */
-	s8 band;		/* band */
-	s8 pad;
-	wlc_ssid_t ssid[WLC_EXTDSCAN_MAX_SSID];	/* ssid list */
-	u32 tx_rate;		/* in 500ksec units */
-	wl_scan_type_t scan_type;	/* enum */
-	s32 channel_num;
-	chan_scandata_t channel_list[1];	/* list of chandata structs */
-} wl_extdscan_params_t;
-
-#define WL_EXTDSCAN_PARAMS_FIXED_SIZE 	(sizeof(wl_extdscan_params_t) - sizeof(chan_scandata_t))
-
-#define WL_BSSTYPE_INFRA 1
-#define WL_BSSTYPE_INDEP 0
-#define WL_BSSTYPE_ANY   2
-
-/* Bitmask for scan_type */
-#define WL_SCANFLAGS_PASSIVE 0x01	/* force passive scan */
-#define WL_SCANFLAGS_RESERVED 0x02	/* Reserved */
-#define WL_SCANFLAGS_PROHIBITED 0x04	/* allow scanning prohibited channels */
-
-typedef struct wl_scan_params {
-	wlc_ssid_t ssid;	/* default: {0, ""} */
-	u8 bssid[ETH_ALEN];	/* default: bcast */
-	s8 bss_type;		/* default: any,
-				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
-				 */
-	u8 scan_type;	/* flags, 0 use default */
-	s32 nprobes;		/* -1 use default, number of probes per channel */
-	s32 active_time;	/* -1 use default, dwell time per channel for
-				 * active scanning
-				 */
-	s32 passive_time;	/* -1 use default, dwell time per channel
-				 * for passive scanning
-				 */
-	s32 home_time;	/* -1 use default, dwell time for the home channel
-				 * between channel scans
-				 */
-	s32 channel_num;	/* count of channels and ssids that follow
-				 *
-				 * low half is count of channels in channel_list, 0
-				 * means default (use all available channels)
-				 *
-				 * high half is entries in wlc_ssid_t array that
-				 * follows channel_list, aligned for s32 (4 bytes)
-				 * meaning an odd channel count implies a 2-byte pad
-				 * between end of channel_list and first ssid
-				 *
-				 * if ssid count is zero, single ssid in the fixed
-				 * parameter portion is assumed, otherwise ssid in
-				 * the fixed portion is ignored
-				 */
-	u16 channel_list[1];	/* list of chanspecs */
-} wl_scan_params_t;
-
-/* size of wl_scan_params not including variable length array */
-#define WL_SCAN_PARAMS_FIXED_SIZE 64
-
-/* masks for channel and ssid count */
-#define WL_SCAN_PARAMS_COUNT_MASK 0x0000ffff
-#define WL_SCAN_PARAMS_NSSID_SHIFT 16
-
-#define WL_SCAN_ACTION_START      1
-#define WL_SCAN_ACTION_CONTINUE   2
-#define WL_SCAN_ACTION_ABORT      3
-
-#define ISCAN_REQ_VERSION 1
-
-/* incremental scan struct */
-typedef struct wl_iscan_params {
-	u32 version;
-	u16 action;
-	u16 scan_duration;
-	wl_scan_params_t params;
-} wl_iscan_params_t;
-
-/* 3 fields + size of wl_scan_params, not including variable length array */
-#define WL_ISCAN_PARAMS_FIXED_SIZE (offsetof(wl_iscan_params_t, params) + sizeof(wlc_ssid_t))
-
-typedef struct wl_scan_results {
-	u32 buflen;
-	u32 version;
-	u32 count;
-	wl_bss_info_t bss_info[1];
-} wl_scan_results_t;
-
-/* size of wl_scan_results not including variable length array */
-#define WL_SCAN_RESULTS_FIXED_SIZE (sizeof(wl_scan_results_t) - sizeof(wl_bss_info_t))
-
-/* wl_iscan_results status values */
-#define WL_SCAN_RESULTS_SUCCESS	0
-#define WL_SCAN_RESULTS_PARTIAL	1
-#define WL_SCAN_RESULTS_PENDING	2
-#define WL_SCAN_RESULTS_ABORTED	3
-#define WL_SCAN_RESULTS_NO_MEM	4
-
-#define ESCAN_REQ_VERSION 1
-
-typedef struct wl_escan_params {
-	u32 version;
-	u16 action;
-	u16 sync_id;
-	wl_scan_params_t params;
-} wl_escan_params_t;
-
-#define WL_ESCAN_PARAMS_FIXED_SIZE (offsetof(wl_escan_params_t, params) + sizeof(wlc_ssid_t))
-
-typedef struct wl_escan_result {
-	u32 buflen;
-	u32 version;
-	u16 sync_id;
-	u16 bss_count;
-	wl_bss_info_t bss_info[1];
-} wl_escan_result_t;
-
-#define WL_ESCAN_RESULTS_FIXED_SIZE (sizeof(wl_escan_result_t) - sizeof(wl_bss_info_t))
-
-/* incremental scan results struct */
-typedef struct wl_iscan_results {
-	u32 status;
-	wl_scan_results_t results;
-} wl_iscan_results_t;
-
-/* size of wl_iscan_results not including variable length array */
-#define WL_ISCAN_RESULTS_FIXED_SIZE \
-	(WL_SCAN_RESULTS_FIXED_SIZE + offsetof(wl_iscan_results_t, results))
-
-typedef struct wl_probe_params {
-	wlc_ssid_t ssid;
-	u8 bssid[ETH_ALEN];
-	u8 mac[ETH_ALEN];
-} wl_probe_params_t;
-#endif /* BRCM_FULLMAC */
-
-#define WL_NUMRATES		16	/* max # of rates in a rateset */
-typedef struct wl_rateset {
-	u32 count;		/* # rates in this set */
-	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
-} wl_rateset_t;
-
-#ifdef BRCM_FULLMAC
-typedef struct wl_rateset_args {
-	u32 count;		/* # rates in this set */
-	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
-	u8 mcs[MCSSET_LEN];	/* supported mcs index bit map */
-} wl_rateset_args_t;
-
-/* u32 list */
-typedef struct wl_u32_list {
-	/* in - # of elements, out - # of entries */
-	u32 count;
-	/* variable length u32 list */
-	u32 element[1];
-} wl_u32_list_t;
-
-/* used for association with a specific BSSID and chanspec list */
-typedef struct wl_assoc_params {
-	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
-	u16 bssid_cnt;
-	s32 chanspec_num;	/* 0: all available channels,
-				 * otherwise count of chanspecs in chanspec_list
-				 */
-	chanspec_t chanspec_list[1];	/* list of chanspecs */
-} wl_assoc_params_t;
-#define WL_ASSOC_PARAMS_FIXED_SIZE 	(sizeof(wl_assoc_params_t) - sizeof(chanspec_t))
-
-/* used for reassociation/roam to a specific BSSID and channel */
-typedef wl_assoc_params_t wl_reassoc_params_t;
-#define WL_REASSOC_PARAMS_FIXED_SIZE	WL_ASSOC_PARAMS_FIXED_SIZE
-
-/* used for join with or without a specific bssid and channel list */
-typedef struct wl_join_params {
-	wlc_ssid_t ssid;
-	wl_assoc_params_t params;	/* optional field, but it must include the fixed portion
-					 * of the wl_assoc_params_t struct when it does present.
-					 */
-} wl_join_params_t;
-#define WL_JOIN_PARAMS_FIXED_SIZE 	(sizeof(wl_join_params_t) - sizeof(chanspec_t))
-
-#endif /* BRCM_FULLMAC */
-
-/* defines used by the nrate iovar */
-#define NRATE_MCS_INUSE	0x00000080	/* MSC in use,indicates b0-6 holds an mcs */
-#define NRATE_RATE_MASK 0x0000007f	/* rate/mcs value */
-#define NRATE_STF_MASK	0x0000ff00	/* stf mode mask: siso, cdd, stbc, sdm */
-#define NRATE_STF_SHIFT	8	/* stf mode shift */
-#define NRATE_OVERRIDE	0x80000000	/* bit indicates override both rate & mode */
-#define NRATE_OVERRIDE_MCS_ONLY 0x40000000	/* bit indicate to override mcs only */
-#define NRATE_SGI_MASK  0x00800000	/* sgi mode */
-#define NRATE_SGI_SHIFT 23	/* sgi mode */
-#define NRATE_LDPC_CODING 0x00400000	/* bit indicates adv coding in use */
-#define NRATE_LDPC_SHIFT 22	/* ldpc shift */
-
-#define NRATE_STF_SISO	0	/* stf mode SISO */
-#define NRATE_STF_CDD	1	/* stf mode CDD */
-#define NRATE_STF_STBC	2	/* stf mode STBC */
-#define NRATE_STF_SDM	3	/* stf mode SDM */
-
-#define ANTENNA_NUM_1	1	/* total number of antennas to be used */
-#define ANTENNA_NUM_2	2
-#define ANTENNA_NUM_3	3
-#define ANTENNA_NUM_4	4
-
-#define ANT_SELCFG_AUTO		0x80	/* bit indicates antenna sel AUTO */
-#define ANT_SELCFG_MASK		0x33	/* antenna configuration mask */
-#define ANT_SELCFG_MAX		4	/* max number of antenna configurations */
-#define ANT_SELCFG_TX_UNICAST	0	/* unicast tx antenna configuration */
-#define ANT_SELCFG_RX_UNICAST	1	/* unicast rx antenna configuration */
-#define ANT_SELCFG_TX_DEF	2	/* default tx antenna configuration */
-#define ANT_SELCFG_RX_DEF	3	/* default rx antenna configuration */
-
-#define MAX_STREAMS_SUPPORTED	4	/* max number of streams supported */
-
-typedef struct {
-	u8 ant_config[ANT_SELCFG_MAX];	/* antenna configuration */
-	u8 num_antcfg;	/* number of available antenna configurations */
-} wlc_antselcfg_t;
-
-#define HIGHEST_SINGLE_STREAM_MCS	7	/* MCS values greater than this enable multiple streams */
-
-#ifdef BRCM_FULLMAC
-#define MAX_CCA_CHANNELS 38	/* Max number of 20 Mhz wide channels */
-#define MAX_CCA_SECS     60	/* CCA keeps this many seconds history */
-
-#define IBSS_MED        15	/* Mediom in-bss congestion percentage */
-#define IBSS_HI         25	/* Hi in-bss congestion percentage */
-#define OBSS_MED        12
-#define OBSS_HI         25
-#define INTERFER_MED    5
-#define INTERFER_HI     10
-
-#define  CCA_FLAG_2G_ONLY		0x01	/* Return a channel from 2.4 Ghz band */
-#define  CCA_FLAG_5G_ONLY		0x02	/* Return a channel from 2.4 Ghz band */
-#define  CCA_FLAG_IGNORE_DURATION	0x04	/* Ignore dwell time for each channel */
-#define  CCA_FLAGS_PREFER_1_6_11	0x10
-#define  CCA_FLAG_IGNORE_INTERFER 	0x20	/* do not exlude channel based on interfer level */
-
-#define CCA_ERRNO_BAND 		1	/* After filtering for band pref, no choices left */
-#define CCA_ERRNO_DURATION	2	/* After filtering for duration, no choices left */
-#define CCA_ERRNO_PREF_CHAN	3	/* After filtering for chan pref, no choices left */
-#define CCA_ERRNO_INTERFER	4	/* After filtering for interference, no choices left */
-#define CCA_ERRNO_TOO_FEW	5	/* Only 1 channel was input */
-
-typedef struct {
-	u32 duration;	/* millisecs spent sampling this channel */
-	u32 congest_ibss;	/* millisecs in our bss (presumably this traffic will */
-	/*  move if cur bss moves channels) */
-	u32 congest_obss;	/* traffic not in our bss */
-	u32 interference;	/* millisecs detecting a non 802.11 interferer. */
-	u32 timestamp;	/* second timestamp */
-} cca_congest_t;
-
-typedef struct {
-	chanspec_t chanspec;	/* Which channel? */
-	u8 num_secs;		/* How many secs worth of data */
-	cca_congest_t secs[1];	/* Data */
-} cca_congest_channel_req_t;
-
-#endif /* BRCM_FULLMAC */
-
-#define WLC_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
-
-#ifdef BRCM_FULLMAC
-typedef struct wl_country {
-	char country_abbrev[WLC_CNTRY_BUF_SZ];	/* nul-terminated country code used in
-						 * the Country IE
-						 */
-	s32 rev;		/* revision specifier for ccode
-				 * on set, -1 indicates unspecified.
-				 * on get, rev >= 0
-				 */
-	char ccode[WLC_CNTRY_BUF_SZ];	/* nul-terminated built-in country code.
-					 * variable length, but fixed size in
-					 * struct allows simple allocation for
-					 * expected country strings <= 3 chars.
-					 */
-} wl_country_t;
-
-typedef struct wl_channels_in_country {
-	u32 buflen;
-	u32 band;
-	char country_abbrev[WLC_CNTRY_BUF_SZ];
-	u32 count;
-	u32 channel[1];
-} wl_channels_in_country_t;
-
-typedef struct wl_country_list {
-	u32 buflen;
-	u32 band_set;
-	u32 band;
-	u32 count;
-	char country_abbrev[1];
-} wl_country_list_t;
-
-#define WL_NUM_RPI_BINS		8
-#define WL_RM_TYPE_BASIC	1
-#define WL_RM_TYPE_CCA		2
-#define WL_RM_TYPE_RPI		3
-
-#define WL_RM_FLAG_PARALLEL	(1<<0)
-
-#define WL_RM_FLAG_LATE		(1<<1)
-#define WL_RM_FLAG_INCAPABLE	(1<<2)
-#define WL_RM_FLAG_REFUSED	(1<<3)
-
-typedef struct wl_rm_req_elt {
-	s8 type;
-	s8 flags;
-	chanspec_t chanspec;
-	u32 token;		/* token for this measurement */
-	u32 tsf_h;		/* TSF high 32-bits of Measurement start time */
-	u32 tsf_l;		/* TSF low 32-bits */
-	u32 dur;		/* TUs */
-} wl_rm_req_elt_t;
-
-typedef struct wl_rm_req {
-	u32 token;		/* overall measurement set token */
-	u32 count;		/* number of measurement requests */
-	void *cb;		/* completion callback function: may be NULL */
-	void *cb_arg;		/* arg to completion callback function */
-	wl_rm_req_elt_t req[1];	/* variable length block of requests */
-} wl_rm_req_t;
-#define WL_RM_REQ_FIXED_LEN	offsetof(wl_rm_req_t, req)
-
-typedef struct wl_rm_rep_elt {
-	s8 type;
-	s8 flags;
-	chanspec_t chanspec;
-	u32 token;		/* token for this measurement */
-	u32 tsf_h;		/* TSF high 32-bits of Measurement start time */
-	u32 tsf_l;		/* TSF low 32-bits */
-	u32 dur;		/* TUs */
-	u32 len;		/* byte length of data block */
-	u8 data[1];		/* variable length data block */
-} wl_rm_rep_elt_t;
-#define WL_RM_REP_ELT_FIXED_LEN	24	/* length excluding data block */
-
-#define WL_RPI_REP_BIN_NUM 8
-typedef struct wl_rm_rpi_rep {
-	u8 rpi[WL_RPI_REP_BIN_NUM];
-	s8 rpi_max[WL_RPI_REP_BIN_NUM];
-} wl_rm_rpi_rep_t;
-
-typedef struct wl_rm_rep {
-	u32 token;		/* overall measurement set token */
-	u32 len;		/* length of measurement report block */
-	wl_rm_rep_elt_t rep[1];	/* variable length block of reports */
-} wl_rm_rep_t;
-#define WL_RM_REP_FIXED_LEN	8
-#endif /* BRCM_FULLMAC */
-
-/* Enumerate crypto algorithms */
-#define	CRYPTO_ALGO_OFF			0
-#define	CRYPTO_ALGO_WEP1		1
-#define	CRYPTO_ALGO_TKIP		2
-#define	CRYPTO_ALGO_WEP128		3
-#define CRYPTO_ALGO_AES_CCM		4
-#define CRYPTO_ALGO_AES_RESERVED1	5
-#define CRYPTO_ALGO_AES_RESERVED2	6
-#define CRYPTO_ALGO_NALG		7
-
-#define WSEC_GEN_MIC_ERROR	0x0001
-#define WSEC_GEN_REPLAY		0x0002
-#define WSEC_GEN_ICV_ERROR	0x0004
-
-#define WL_SOFT_KEY	(1 << 0)	/* Indicates this key is using soft encrypt */
-#define WL_PRIMARY_KEY	(1 << 1)	/* Indicates this key is the primary (ie tx) key */
-#define WL_KF_RES_4	(1 << 4)	/* Reserved for backward compat */
-#define WL_KF_RES_5	(1 << 5)	/* Reserved for backward compat */
-#define WL_IBSS_PEER_GROUP_KEY	(1 << 6)	/* Indicates a group key for a IBSS PEER */
-
-typedef struct wl_wsec_key {
-	u32 index;		/* key index */
-	u32 len;		/* key length */
-	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
-	u32 pad_1[18];
-	u32 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
-	u32 flags;		/* misc flags */
-	u32 pad_2[2];
-	int pad_3;
-	int iv_initialized;	/* has IV been initialized already? */
-	int pad_4;
-	/* Rx IV */
-	struct {
-		u32 hi;	/* upper 32 bits of IV */
-		u16 lo;	/* lower 16 bits of IV */
-	} rxiv;
-	u32 pad_5[2];
-	u8 ea[ETH_ALEN];	/* per station */
-} wl_wsec_key_t;
-
-#define WSEC_MIN_PSK_LEN	8
-#define WSEC_MAX_PSK_LEN	64
-
-/* Flag for key material needing passhash'ing */
-#define WSEC_PASSPHRASE		(1<<0)
-
-/* receptacle for WLC_SET_WSEC_PMK parameter */
-typedef struct {
-	unsigned short key_len;		/* octets in key material */
-	unsigned short flags;		/* key handling qualification */
-	u8 key[WSEC_MAX_PSK_LEN];	/* PMK material */
-} wsec_pmk_t;
-
-/* wireless security bitvec */
-#define WEP_ENABLED		0x0001
-#define TKIP_ENABLED		0x0002
-#define AES_ENABLED		0x0004
-#define WSEC_SWFLAG		0x0008
-#define SES_OW_ENABLED		0x0040	/* to go into transition mode without setting wep */
-
-/* WPA authentication mode bitvec */
-#define WPA_AUTH_DISABLED	0x0000	/* Legacy (i.e., non-WPA) */
-#define WPA_AUTH_NONE		0x0001	/* none (IBSS) */
-#define WPA_AUTH_UNSPECIFIED	0x0002	/* over 802.1x */
-#define WPA_AUTH_PSK		0x0004	/* Pre-shared key */
-#define WPA_AUTH_RESERVED1	0x0008
-#define WPA_AUTH_RESERVED2	0x0010
-					/* #define WPA_AUTH_8021X 0x0020 *//* 802.1x, reserved */
-#define WPA2_AUTH_RESERVED1	0x0020
-#define WPA2_AUTH_UNSPECIFIED	0x0040	/* over 802.1x */
-#define WPA2_AUTH_PSK		0x0080	/* Pre-shared key */
-#define WPA2_AUTH_RESERVED3	0x0200
-#define WPA2_AUTH_RESERVED4	0x0400
-#define WPA2_AUTH_RESERVED5	0x0800
-
-/* pmkid */
-#define	MAXPMKID		16
-
-typedef struct _pmkid {
-	u8 BSSID[ETH_ALEN];
-	u8 PMKID[WLAN_PMKID_LEN];
-} pmkid_t;
-
-typedef struct _pmkid_list {
-	u32 npmkid;
-	pmkid_t pmkid[1];
-} pmkid_list_t;
-
-typedef struct _pmkid_cand {
-	u8 BSSID[ETH_ALEN];
-	u8 preauth;
-} pmkid_cand_t;
-
-typedef struct _pmkid_cand_list {
-	u32 npmkid_cand;
-	pmkid_cand_t pmkid_cand[1];
-} pmkid_cand_list_t;
-
-typedef struct wl_led_info {
-	u32 index;		/* led index */
-	u32 behavior;
-	u8 activehi;
-} wl_led_info_t;
-
-/* R_REG and W_REG struct passed through ioctl */
-typedef struct {
-	u32 byteoff;		/* byte offset of the field in d11regs_t */
-	u32 val;		/* read/write value of the field */
-	u32 size;		/* sizeof the field */
-	uint band;		/* band (optional) */
-} rw_reg_t;
-
-
-#ifdef BRCM_FULLMAC
-/* Used to get specific STA parameters */
-typedef struct {
-	u32 val;
-	u8 ea[ETH_ALEN];
-} scb_val_t;
-#endif /* BRCM_FULLMAC */
-
-/* channel encoding */
-typedef struct channel_info {
-	int hw_channel;
-	int target_channel;
-	int scan_channel;
-} channel_info_t;
-
-/* For ioctls that take a list of MAC addresses */
-struct maclist {
-	uint count;		/* number of MAC addresses */
-	u8 ea[1][ETH_ALEN];	/* variable length array of MAC addresses */
-};
-
-#ifdef BRCM_FULLMAC
-/* Linux network driver ioctl encoding */
-typedef struct wl_ioctl {
-	uint cmd;		/* common ioctl definition */
-	void *buf;		/* pointer to user buffer */
-	uint len;		/* length of user buffer */
-	u8 set;		/* get or set request (optional) */
-	uint used;		/* bytes read or written (optional) */
-	uint needed;		/* bytes needed (optional) */
-} wl_ioctl_t;
-#endif /* BRCM_FULLMAC */
-
-
-/*
- * Structure for passing hardware and software
- * revision info up from the driver.
- */
-typedef struct wlc_rev_info {
-	uint vendorid;		/* PCI vendor id */
-	uint deviceid;		/* device id of chip */
-	uint radiorev;		/* radio revision */
-	uint chiprev;		/* chip revision */
-	uint corerev;		/* core revision */
-	uint boardid;		/* board identifier (usu. PCI sub-device id) */
-	uint boardvendor;	/* board vendor (usu. PCI sub-vendor id) */
-	uint boardrev;		/* board revision */
-	uint driverrev;		/* driver version */
-	uint ucoderev;		/* microcode version */
-	uint bus;		/* bus type */
-	uint chipnum;		/* chip number */
-	uint phytype;		/* phy type */
-	uint phyrev;		/* phy revision */
-	uint anarev;		/* anacore rev */
-	uint chippkg;		/* chip package info */
-} wlc_rev_info_t;
-
-#define WL_REV_INFO_LEGACY_LENGTH	48
-
-#ifdef BRCM_FULLMAC
-#define	WLC_IOCTL_SMLEN			256	/* "small" length ioctl buffer required */
-#define WLC_IOCTL_MEDLEN		1536	/* "med" length ioctl buffer required */
-#define	WLC_IOCTL_MAXLEN	8192
-#endif
-
-/* common ioctl definitions */
-#define WLC_GET_MAGIC				0
-#define WLC_GET_VERSION				1
-#define WLC_UP					2
-#define WLC_DOWN				3
-#define WLC_GET_LOOP				4
-#define WLC_SET_LOOP				5
-#define WLC_DUMP				6
-#define WLC_GET_MSGLEVEL			7
-#define WLC_SET_MSGLEVEL			8
-#define WLC_GET_PROMISC				9
-#define WLC_SET_PROMISC				10
-#define WLC_OVERLAY_IOCTL			11
-#define WLC_GET_RATE				12
-						      /* #define WLC_SET_RATE				13 *//* no longer supported */
-#define WLC_GET_INSTANCE			14
-						      /* #define WLC_GET_FRAG				15 *//* no longer supported */
-						      /* #define WLC_SET_FRAG				16 *//* no longer supported */
-						      /* #define WLC_GET_RTS				17 *//* no longer supported */
-						      /* #define WLC_SET_RTS				18 *//* no longer supported */
-#define WLC_GET_INFRA				19
-#define WLC_SET_INFRA				20
-#define WLC_GET_AUTH				21
-#define WLC_SET_AUTH				22
-#define WLC_GET_BSSID				23
-#define WLC_SET_BSSID				24
-#define WLC_GET_SSID				25
-#define WLC_SET_SSID				26
-#define WLC_RESTART				27
-						      /* #define WLC_DUMP_SCB				28 *//* no longer supported */
-#define WLC_GET_CHANNEL				29
-#define WLC_SET_CHANNEL				30
-#define WLC_GET_SRL				31
-#define WLC_SET_SRL				32
-#define WLC_GET_LRL				33
-#define WLC_SET_LRL				34
-#define WLC_GET_PLCPHDR				35
-#define WLC_SET_PLCPHDR				36
-#define WLC_GET_RADIO				37
-#define WLC_SET_RADIO				38
-#define WLC_GET_PHYTYPE				39
-#define WLC_DUMP_RATE				40
-#define WLC_SET_RATE_PARAMS			41
-#define WLC_GET_FIXRATE				42
-#define WLC_SET_FIXRATE				43
-						      /* #define WLC_GET_WEP				42 *//* no longer supported */
-						      /* #define WLC_SET_WEP				43 *//* no longer supported */
-#define WLC_GET_KEY				44
-#define WLC_SET_KEY				45
-#define WLC_GET_REGULATORY			46
-#define WLC_SET_REGULATORY			47
-#define WLC_GET_PASSIVE_SCAN			48
-#define WLC_SET_PASSIVE_SCAN			49
-#define WLC_SCAN				50
-#define WLC_SCAN_RESULTS			51
-#define WLC_DISASSOC				52
-#define WLC_REASSOC				53
-#define WLC_GET_ROAM_TRIGGER			54
-#define WLC_SET_ROAM_TRIGGER			55
-#define WLC_GET_ROAM_DELTA			56
-#define WLC_SET_ROAM_DELTA			57
-#define WLC_GET_ROAM_SCAN_PERIOD		58
-#define WLC_SET_ROAM_SCAN_PERIOD		59
-#define WLC_EVM					60	/* diag */
-#define WLC_GET_TXANT				61
-#define WLC_SET_TXANT				62
-#define WLC_GET_ANTDIV				63
-#define WLC_SET_ANTDIV				64
-						      /* #define WLC_GET_TXPWR			65 *//* no longer supported */
-						      /* #define WLC_SET_TXPWR			66 *//* no longer supported */
-#define WLC_GET_CLOSED				67
-#define WLC_SET_CLOSED				68
-#define WLC_GET_MACLIST				69
-#define WLC_SET_MACLIST				70
-#define WLC_GET_RATESET				71
-#define WLC_SET_RATESET				72
-						      /* #define WLC_GET_LOCALE			73 *//* no longer supported */
-#define WLC_LONGTRAIN				74
-#define WLC_GET_BCNPRD				75
-#define WLC_SET_BCNPRD				76
-#define WLC_GET_DTIMPRD				77
-#define WLC_SET_DTIMPRD				78
-#define WLC_GET_SROM				79
-#define WLC_SET_SROM				80
-#define WLC_GET_WEP_RESTRICT			81
-#define WLC_SET_WEP_RESTRICT			82
-#define WLC_GET_COUNTRY				83
-#define WLC_SET_COUNTRY				84
-#define WLC_GET_PM				85
-#define WLC_SET_PM				86
-#define WLC_GET_WAKE				87
-#define WLC_SET_WAKE				88
-						      /* #define WLC_GET_D11CNTS			89 *//* -> "counters" iovar */
-#define WLC_GET_FORCELINK			90	/* ndis only */
-#define WLC_SET_FORCELINK			91	/* ndis only */
-#define WLC_FREQ_ACCURACY			92	/* diag */
-#define WLC_CARRIER_SUPPRESS			93	/* diag */
-#define WLC_GET_PHYREG				94
-#define WLC_SET_PHYREG				95
-#define WLC_GET_RADIOREG			96
-#define WLC_SET_RADIOREG			97
-#define WLC_GET_REVINFO				98
-#define WLC_GET_UCANTDIV			99
-#define WLC_SET_UCANTDIV			100
-#define WLC_R_REG				101
-#define WLC_W_REG				102
-/* #define WLC_DIAG_LOOPBACK			103	old tray diag */
-						       /* #define WLC_RESET_D11CNTS			104 *//* -> "reset_d11cnts" iovar */
-#define WLC_GET_MACMODE				105
-#define WLC_SET_MACMODE				106
-#define WLC_GET_MONITOR				107
-#define WLC_SET_MONITOR				108
-#define WLC_GET_GMODE				109
-#define WLC_SET_GMODE				110
-#define WLC_GET_LEGACY_ERP			111
-#define WLC_SET_LEGACY_ERP			112
-#define WLC_GET_RX_ANT				113
-#define WLC_GET_CURR_RATESET			114	/* current rateset */
-#define WLC_GET_SCANSUPPRESS			115
-#define WLC_SET_SCANSUPPRESS			116
-#define WLC_GET_AP				117
-#define WLC_SET_AP				118
-#define WLC_GET_EAP_RESTRICT			119
-#define WLC_SET_EAP_RESTRICT			120
-#define WLC_SCB_AUTHORIZE			121
-#define WLC_SCB_DEAUTHORIZE			122
-#define WLC_GET_WDSLIST				123
-#define WLC_SET_WDSLIST				124
-#define WLC_GET_ATIM				125
-#define WLC_SET_ATIM				126
-#define WLC_GET_RSSI				127
-#define WLC_GET_PHYANTDIV			128
-#define WLC_SET_PHYANTDIV			129
-#define WLC_AP_RX_ONLY				130
-#define WLC_GET_TX_PATH_PWR			131
-#define WLC_SET_TX_PATH_PWR			132
-#define WLC_GET_WSEC				133
-#define WLC_SET_WSEC				134
-#define WLC_GET_PHY_NOISE			135
-#define WLC_GET_BSS_INFO			136
-#define WLC_GET_PKTCNTS				137
-#define WLC_GET_LAZYWDS				138
-#define WLC_SET_LAZYWDS				139
-#define WLC_GET_BANDLIST			140
-#define WLC_GET_BAND				141
-#define WLC_SET_BAND				142
-#define WLC_SCB_DEAUTHENTICATE			143
-#define WLC_GET_SHORTSLOT			144
-#define WLC_GET_SHORTSLOT_OVERRIDE		145
-#define WLC_SET_SHORTSLOT_OVERRIDE		146
-#define WLC_GET_SHORTSLOT_RESTRICT		147
-#define WLC_SET_SHORTSLOT_RESTRICT		148
-#define WLC_GET_GMODE_PROTECTION		149
-#define WLC_GET_GMODE_PROTECTION_OVERRIDE	150
-#define WLC_SET_GMODE_PROTECTION_OVERRIDE	151
-#define WLC_UPGRADE				152
-						       /* #define WLC_GET_MRATE			153 *//* no longer supported */
-						       /* #define WLC_SET_MRATE			154 *//* no longer supported */
-#define WLC_GET_IGNORE_BCNS			155
-#define WLC_SET_IGNORE_BCNS			156
-#define WLC_GET_SCB_TIMEOUT			157
-#define WLC_SET_SCB_TIMEOUT			158
-#define WLC_GET_ASSOCLIST			159
-#define WLC_GET_CLK				160
-#define WLC_SET_CLK				161
-#define WLC_GET_UP				162
-#define WLC_OUT					163
-#define WLC_GET_WPA_AUTH			164
-#define WLC_SET_WPA_AUTH			165
-#define WLC_GET_UCFLAGS				166
-#define WLC_SET_UCFLAGS				167
-#define WLC_GET_PWRIDX				168
-#define WLC_SET_PWRIDX				169
-#define WLC_GET_TSSI				170
-#define WLC_GET_SUP_RATESET_OVERRIDE		171
-#define WLC_SET_SUP_RATESET_OVERRIDE		172
-						       /* #define WLC_SET_FAST_TIMER			173 *//* no longer supported */
-						       /* #define WLC_GET_FAST_TIMER			174 *//* no longer supported */
-						       /* #define WLC_SET_SLOW_TIMER			175 *//* no longer supported */
-						       /* #define WLC_GET_SLOW_TIMER			176 *//* no longer supported */
-						       /* #define WLC_DUMP_PHYREGS			177 *//* no longer supported */
-#define WLC_GET_PROTECTION_CONTROL		178
-#define WLC_SET_PROTECTION_CONTROL		179
-#define WLC_GET_PHYLIST				180
-#define WLC_ENCRYPT_STRENGTH			181	/* ndis only */
-#define WLC_DECRYPT_STATUS			182	/* ndis only */
-#define WLC_GET_KEY_SEQ				183
-#define WLC_GET_SCAN_CHANNEL_TIME		184
-#define WLC_SET_SCAN_CHANNEL_TIME		185
-#define WLC_GET_SCAN_UNASSOC_TIME		186
-#define WLC_SET_SCAN_UNASSOC_TIME		187
-#define WLC_GET_SCAN_HOME_TIME			188
-#define WLC_SET_SCAN_HOME_TIME			189
-#define WLC_GET_SCAN_NPROBES			190
-#define WLC_SET_SCAN_NPROBES			191
-#define WLC_GET_PRB_RESP_TIMEOUT		192
-#define WLC_SET_PRB_RESP_TIMEOUT		193
-#define WLC_GET_ATTEN				194
-#define WLC_SET_ATTEN				195
-#define WLC_GET_SHMEM				196	/* diag */
-#define WLC_SET_SHMEM				197	/* diag */
-						       /* #define WLC_GET_GMODE_PROTECTION_CTS		198 *//* no longer supported */
-						       /* #define WLC_SET_GMODE_PROTECTION_CTS		199 *//* no longer supported */
-#define WLC_SET_WSEC_TEST			200
-#define WLC_SCB_DEAUTHENTICATE_FOR_REASON	201
-#define WLC_TKIP_COUNTERMEASURES		202
-#define WLC_GET_PIOMODE				203
-#define WLC_SET_PIOMODE				204
-#define WLC_SET_ASSOC_PREFER			205
-#define WLC_GET_ASSOC_PREFER			206
-#define WLC_SET_ROAM_PREFER			207
-#define WLC_GET_ROAM_PREFER			208
-#define WLC_SET_LED				209
-#define WLC_GET_LED				210
-#define WLC_RESERVED6				211
-#define WLC_RESERVED7				212
-#define WLC_GET_CHANNEL_QA			213
-#define WLC_START_CHANNEL_QA			214
-#define WLC_GET_CHANNEL_SEL			215
-#define WLC_START_CHANNEL_SEL			216
-#define WLC_GET_VALID_CHANNELS			217
-#define WLC_GET_FAKEFRAG			218
-#define WLC_SET_FAKEFRAG			219
-#define WLC_GET_PWROUT_PERCENTAGE		220
-#define WLC_SET_PWROUT_PERCENTAGE		221
-#define WLC_SET_BAD_FRAME_PREEMPT		222
-#define WLC_GET_BAD_FRAME_PREEMPT		223
-#define WLC_SET_LEAP_LIST			224
-#define WLC_GET_LEAP_LIST			225
-#define WLC_GET_CWMIN				226
-#define WLC_SET_CWMIN				227
-#define WLC_GET_CWMAX				228
-#define WLC_SET_CWMAX				229
-#define WLC_GET_WET				230
-#define WLC_SET_WET				231
-#define WLC_GET_PUB				232
-						       /* #define WLC_SET_GLACIAL_TIMER		233 *//* no longer supported */
-						       /* #define WLC_GET_GLACIAL_TIMER		234 *//* no longer supported */
-#define WLC_GET_KEY_PRIMARY			235
-#define WLC_SET_KEY_PRIMARY			236
-						       /* #define WLC_DUMP_RADIOREGS			237 *//* no longer supported */
-#define WLC_RESERVED4				238
-#define WLC_RESERVED5				239
-#define WLC_UNSET_CALLBACK			240
-#define WLC_SET_CALLBACK			241
-#define WLC_GET_RADAR				242
-#define WLC_SET_RADAR				243
-#define WLC_SET_SPECT_MANAGMENT			244
-#define WLC_GET_SPECT_MANAGMENT			245
-#define WLC_WDS_GET_REMOTE_HWADDR		246	/* handled in wl_linux.c/wl_vx.c */
-#define WLC_WDS_GET_WPA_SUP			247
-#define WLC_SET_CS_SCAN_TIMER			248
-#define WLC_GET_CS_SCAN_TIMER			249
-#define WLC_MEASURE_REQUEST			250
-#define WLC_INIT				251
-#define WLC_SEND_QUIET				252
-#define WLC_KEEPALIVE			253
-#define WLC_SEND_PWR_CONSTRAINT			254
-#define WLC_UPGRADE_STATUS			255
-#define WLC_CURRENT_PWR				256
-#define WLC_GET_SCAN_PASSIVE_TIME		257
-#define WLC_SET_SCAN_PASSIVE_TIME		258
-#define WLC_LEGACY_LINK_BEHAVIOR		259
-#define WLC_GET_CHANNELS_IN_COUNTRY		260
-#define WLC_GET_COUNTRY_LIST			261
-#define WLC_GET_VAR				262	/* get value of named variable */
-#define WLC_SET_VAR				263	/* set named variable to value */
-#define WLC_NVRAM_GET				264	/* deprecated */
-#define WLC_NVRAM_SET				265
-#define WLC_NVRAM_DUMP				266
-#define WLC_REBOOT				267
-#define WLC_SET_WSEC_PMK			268
-#define WLC_GET_AUTH_MODE			269
-#define WLC_SET_AUTH_MODE			270
-#define WLC_GET_WAKEENTRY			271
-#define WLC_SET_WAKEENTRY			272
-#define WLC_NDCONFIG_ITEM			273	/* currently handled in wl_oid.c */
-#define WLC_NVOTPW				274
-#define WLC_OTPW				275
-#define WLC_IOV_BLOCK_GET			276
-#define WLC_IOV_MODULES_GET			277
-#define WLC_SOFT_RESET				278
-#define WLC_GET_ALLOW_MODE			279
-#define WLC_SET_ALLOW_MODE			280
-#define WLC_GET_DESIRED_BSSID			281
-#define WLC_SET_DESIRED_BSSID			282
-#define	WLC_DISASSOC_MYAP			283
-#define WLC_GET_RESERVED10			284
-#define WLC_GET_RESERVED11			285
-#define WLC_GET_RESERVED12			286
-#define WLC_GET_RESERVED13			287
-#define WLC_GET_RESERVED14			288
-#define WLC_SET_RESERVED15			289
-#define WLC_SET_RESERVED16			290
-#define WLC_GET_RESERVED17			291
-#define WLC_GET_RESERVED18			292
-#define WLC_GET_RESERVED19			293
-#define WLC_SET_RESERVED1A			294
-#define WLC_GET_RESERVED1B			295
-#define WLC_GET_RESERVED1C			296
-#define WLC_GET_RESERVED1D			297
-#define WLC_SET_RESERVED1E			298
-#define WLC_GET_RESERVED1F			299
-#define WLC_GET_RESERVED20			300
-#define WLC_GET_RESERVED21			301
-#define WLC_GET_RESERVED22			302
-#define WLC_GET_RESERVED23			303
-#define WLC_GET_RESERVED24			304
-#define WLC_SET_RESERVED25			305
-#define WLC_GET_RESERVED26			306
-#define WLC_NPHY_SAMPLE_COLLECT			307	/* Nphy sample collect mode */
-#define WLC_UM_PRIV				308	/* for usermode driver private ioctl */
-#define WLC_GET_CMD				309
-							/* #define WLC_LAST				310 *//* Never used - can be reused */
-#define WLC_RESERVED8				311
-#define WLC_RESERVED9				312
-#define WLC_RESERVED1				313
-#define WLC_RESERVED2				314
-#define WLC_RESERVED3				315
-#define WLC_LAST				316
-
-#ifndef EPICTRL_COOKIE
-#define EPICTRL_COOKIE		0xABADCEDE
-#endif
-
-#define WL_DECRYPT_STATUS_SUCCESS	1
-#define WL_DECRYPT_STATUS_FAILURE	2
-#define WL_DECRYPT_STATUS_UNKNOWN	3
-
-/* allows user-mode app to poll the status of USB image upgrade */
-#define WLC_UPGRADE_SUCCESS			0
-#define WLC_UPGRADE_PENDING			1
-
-/* WLC_GET_AUTH, WLC_SET_AUTH values */
-#define WL_AUTH_OPEN_SYSTEM		0	/* d11 open authentication */
-#define WL_AUTH_SHARED_KEY		1	/* d11 shared authentication */
-#define WL_AUTH_OPEN_SHARED		2	/* try open, then shared if open failed w/rc 13 */
-
-/* Bit masks for radio disabled status - returned by WL_GET_RADIO */
-#define WL_RADIO_SW_DISABLE		(1<<0)
-#define WL_RADIO_HW_DISABLE		(1<<1)
-#define WL_RADIO_MPC_DISABLE		(1<<2)
-#define WL_RADIO_COUNTRY_DISABLE	(1<<3)	/* some countries don't support any channel */
-
-#define	WL_SPURAVOID_OFF	0
-#define	WL_SPURAVOID_ON1	1
-#define	WL_SPURAVOID_ON2	2
-
-/* Override bit for WLC_SET_TXPWR.  if set, ignore other level limits */
-#define WL_TXPWR_OVERRIDE	(1U<<31)
-
-#define WL_PHY_PAVARS_LEN	6	/* Phy type, Band range, chain, a1, b0, b1 */
-
-typedef struct wl_po {
-	u16 phy_type;	/* Phy type */
-	u16 band;
-	u16 cckpo;
-	u32 ofdmpo;
-	u16 mcspo[8];
-} wl_po_t;
-
-/* a large TX Power as an init value to factor out of min() calculations,
- * keep low enough to fit in an s8, units are .25 dBm
- */
-#define WLC_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
-
-/* "diag" iovar argument and error code */
-#define WL_DIAG_INTERRUPT			1	/* d11 loopback interrupt test */
-#define WL_DIAG_LOOPBACK			2	/* d11 loopback data test */
-#define WL_DIAG_MEMORY				3	/* d11 memory test */
-#define WL_DIAG_LED				4	/* LED test */
-#define WL_DIAG_REG				5	/* d11/phy register test */
-#define WL_DIAG_SROM				6	/* srom read/crc test */
-#define WL_DIAG_DMA				7	/* DMA test */
-
-#define WL_DIAGERR_SUCCESS			0
-#define WL_DIAGERR_FAIL_TO_RUN			1	/* unable to run requested diag */
-#define WL_DIAGERR_NOT_SUPPORTED		2	/* diag requested is not supported */
-#define WL_DIAGERR_INTERRUPT_FAIL		3	/* loopback interrupt test failed */
-#define WL_DIAGERR_LOOPBACK_FAIL		4	/* loopback data test failed */
-#define WL_DIAGERR_SROM_FAIL			5	/* srom read failed */
-#define WL_DIAGERR_SROM_BADCRC			6	/* srom crc failed */
-#define WL_DIAGERR_REG_FAIL			7	/* d11/phy register test failed */
-#define WL_DIAGERR_MEMORY_FAIL			8	/* d11 memory test failed */
-#define WL_DIAGERR_NOMEM			9	/* diag test failed due to no memory */
-#define WL_DIAGERR_DMA_FAIL			10	/* DMA test failed */
-
-#define WL_DIAGERR_MEMORY_TIMEOUT		11	/* d11 memory test didn't finish in time */
-#define WL_DIAGERR_MEMORY_BADPATTERN		12	/* d11 memory test result in bad pattern */
-
-/* band types */
-#define	WLC_BAND_AUTO		0	/* auto-select */
-#define	WLC_BAND_5G		1	/* 5 Ghz */
-#define	WLC_BAND_2G		2	/* 2.4 Ghz */
-#define	WLC_BAND_ALL		3	/* all bands */
-
-/* band range returned by band_range iovar */
-#define WL_CHAN_FREQ_RANGE_2G      0
-#define WL_CHAN_FREQ_RANGE_5GL     1
-#define WL_CHAN_FREQ_RANGE_5GM     2
-#define WL_CHAN_FREQ_RANGE_5GH     3
-
-/* phy types (returned by WLC_GET_PHYTPE) */
-#define	WLC_PHY_TYPE_A		0
-#define	WLC_PHY_TYPE_B		1
-#define	WLC_PHY_TYPE_G		2
-#define	WLC_PHY_TYPE_N		4
-#define	WLC_PHY_TYPE_LP		5
-#define	WLC_PHY_TYPE_SSN	6
-#define	WLC_PHY_TYPE_HT		7
-#define	WLC_PHY_TYPE_LCN	8
-#define	WLC_PHY_TYPE_NULL	0xf
-
-/* MAC list modes */
-#define WLC_MACMODE_DISABLED	0	/* MAC list disabled */
-#define WLC_MACMODE_DENY	1	/* Deny specified (i.e. allow unspecified) */
-#define WLC_MACMODE_ALLOW	2	/* Allow specified (i.e. deny unspecified) */
-
-/*
- * 54g modes (basic bits may still be overridden)
- *
- * GMODE_LEGACY_B			Rateset: 1b, 2b, 5.5, 11
- *					Preamble: Long
- *					Shortslot: Off
- * GMODE_AUTO				Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
- *					Extended Rateset: 6, 9, 12, 48
- *					Preamble: Long
- *					Shortslot: Auto
- * GMODE_ONLY				Rateset: 1b, 2b, 5.5b, 11b, 18, 24b, 36, 54
- *					Extended Rateset: 6b, 9, 12b, 48
- *					Preamble: Short required
- *					Shortslot: Auto
- * GMODE_B_DEFERRED			Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
- *					Extended Rateset: 6, 9, 12, 48
- *					Preamble: Long
- *					Shortslot: On
- * GMODE_PERFORMANCE			Rateset: 1b, 2b, 5.5b, 6b, 9, 11b, 12b, 18, 24b, 36, 48, 54
- *					Preamble: Short required
- *					Shortslot: On and required
- * GMODE_LRS				Rateset: 1b, 2b, 5.5b, 11b
- *					Extended Rateset: 6, 9, 12, 18, 24, 36, 48, 54
- *					Preamble: Long
- *					Shortslot: Auto
- */
-#define GMODE_LEGACY_B		0
-#define GMODE_AUTO		1
-#define GMODE_ONLY		2
-#define GMODE_B_DEFERRED	3
-#define GMODE_PERFORMANCE	4
-#define GMODE_LRS		5
-#define GMODE_MAX		6
-
-/* values for PLCPHdr_override */
-#define WLC_PLCP_AUTO	-1
-#define WLC_PLCP_SHORT	0
-#define WLC_PLCP_LONG	1
-
-/* values for g_protection_override and n_protection_override */
-#define WLC_PROTECTION_AUTO		-1
-#define WLC_PROTECTION_OFF		0
-#define WLC_PROTECTION_ON		1
-#define WLC_PROTECTION_MMHDR_ONLY	2
-#define WLC_PROTECTION_CTS_ONLY		3
-
-/* values for g_protection_control and n_protection_control */
-#define WLC_PROTECTION_CTL_OFF		0
-#define WLC_PROTECTION_CTL_LOCAL	1
-#define WLC_PROTECTION_CTL_OVERLAP	2
-
-/* values for n_protection */
-#define WLC_N_PROTECTION_OFF		0
-#define WLC_N_PROTECTION_OPTIONAL	1
-#define WLC_N_PROTECTION_20IN40		2
-#define WLC_N_PROTECTION_MIXEDMODE	3
-
-/* values for n_preamble_type */
-#define WLC_N_PREAMBLE_MIXEDMODE	0
-#define WLC_N_PREAMBLE_GF		1
-#define WLC_N_PREAMBLE_GF_BRCM          2
-
-/* values for band specific 40MHz capabilities */
-#define WLC_N_BW_20ALL			0
-#define WLC_N_BW_40ALL			1
-#define WLC_N_BW_20IN2G_40IN5G		2
-
-/* values to force tx/rx chain */
-#define WLC_N_TXRX_CHAIN0		0
-#define WLC_N_TXRX_CHAIN1		1
-
-/* bitflags for SGI support (sgi_rx iovar) */
-#define WLC_N_SGI_20			0x01
-#define WLC_N_SGI_40			0x02
-
-/* Values for PM */
-#define PM_OFF	0
-#define PM_MAX	1
-
-/* interference mitigation options */
-#define	INTERFERE_OVRRIDE_OFF	-1	/* interference override off */
-#define	INTERFERE_NONE	0	/* off */
-#define	NON_WLAN	1	/* foreign/non 802.11 interference, no auto detect */
-#define	WLAN_MANUAL	2	/* ACI: no auto detection */
-#define	WLAN_AUTO	3	/* ACI: auto detect */
-#define	WLAN_AUTO_W_NOISE	4	/* ACI: auto - detect and non 802.11 interference */
-#define	AUTO_ACTIVE	(1 << 7)	/* Auto is currently active */
-
-#define WL_RSSI_ANT_VERSION	1	/* current version of wl_rssi_ant_t */
-#define WL_ANT_RX_MAX		2	/* max 2 receive antennas */
-#define WL_ANT_HT_RX_MAX	3	/* max 3 receive antennas/cores */
-#define WL_ANT_IDX_1		0	/* antenna index 1 */
-#define WL_ANT_IDX_2		1	/* antenna index 2 */
-
-#ifndef WL_RSSI_ANT_MAX
-#define WL_RSSI_ANT_MAX		4	/* max possible rx antennas */
-#elif WL_RSSI_ANT_MAX != 4
-#error "WL_RSSI_ANT_MAX does not match"
-#endif
-
-/* RSSI per antenna */
-typedef struct {
-	u32 version;		/* version field */
-	u32 count;		/* number of valid antenna rssi */
-	s8 rssi_ant[WL_RSSI_ANT_MAX];	/* rssi per antenna */
-} wl_rssi_ant_t;
-
-#define NUM_PWRCTRL_RATES 12
-
-typedef struct {
-	u8 txpwr_band_max[NUM_PWRCTRL_RATES];	/* User set target */
-	u8 txpwr_limit[NUM_PWRCTRL_RATES];	/* reg and local power limit */
-	u8 txpwr_local_max;	/* local max according to the AP */
-	u8 txpwr_local_constraint;	/* local constraint according to the AP */
-	u8 txpwr_chan_reg_max;	/* Regulatory max for this channel */
-	u8 txpwr_target[2][NUM_PWRCTRL_RATES];	/* Latest target for 2.4 and 5 Ghz */
-	u8 txpwr_est_Pout[2];	/* Latest estimate for 2.4 and 5 Ghz */
-	u8 txpwr_opo[NUM_PWRCTRL_RATES];	/* On G phy, OFDM power offset */
-	u8 txpwr_bphy_cck_max[NUM_PWRCTRL_RATES];	/* Max CCK power for this band (SROM) */
-	u8 txpwr_bphy_ofdm_max;	/* Max OFDM power for this band (SROM) */
-	u8 txpwr_aphy_max[NUM_PWRCTRL_RATES];	/* Max power for A band (SROM) */
-	s8 txpwr_antgain[2];	/* Ant gain for each band - from SROM */
-	u8 txpwr_est_Pout_gofdm;	/* Pwr estimate for 2.4 OFDM */
-} tx_power_legacy_t;
-
-#define WL_TX_POWER_RATES_LEGACY	45
-#define WL_TX_POWER_MCS20_FIRST	        12
-#define WL_TX_POWER_MCS20_NUM	        16
-#define WL_TX_POWER_MCS40_FIRST	        28
-#define WL_TX_POWER_MCS40_NUM	        17
-
-
-#define WL_TX_POWER_RATES	       101
-#define WL_TX_POWER_CCK_FIRST	       0
-#define WL_TX_POWER_CCK_NUM	       4
-#define WL_TX_POWER_OFDM_FIRST	       4	/* Index for first 20MHz OFDM SISO rate */
-#define WL_TX_POWER_OFDM20_CDD_FIRST   12	/* Index for first 20MHz OFDM CDD rate */
-#define WL_TX_POWER_OFDM40_SISO_FIRST  52	/* Index for first 40MHz OFDM SISO rate */
-#define WL_TX_POWER_OFDM40_CDD_FIRST   60	/* Index for first 40MHz OFDM CDD rate */
-#define WL_TX_POWER_OFDM_NUM	       8
-#define WL_TX_POWER_MCS20_SISO_FIRST   20	/* Index for first 20MHz MCS SISO rate */
-#define WL_TX_POWER_MCS20_CDD_FIRST    28	/* Index for first 20MHz MCS CDD rate */
-#define WL_TX_POWER_MCS20_STBC_FIRST   36	/* Index for first 20MHz MCS STBC rate */
-#define WL_TX_POWER_MCS20_SDM_FIRST    44	/* Index for first 20MHz MCS SDM rate */
-#define WL_TX_POWER_MCS40_SISO_FIRST   68	/* Index for first 40MHz MCS SISO rate */
-#define WL_TX_POWER_MCS40_CDD_FIRST    76	/* Index for first 40MHz MCS CDD rate */
-#define WL_TX_POWER_MCS40_STBC_FIRST   84	/* Index for first 40MHz MCS STBC rate */
-#define WL_TX_POWER_MCS40_SDM_FIRST    92	/* Index for first 40MHz MCS SDM rate */
-#define WL_TX_POWER_MCS_1_STREAM_NUM   8
-#define WL_TX_POWER_MCS_2_STREAM_NUM   8
-#define WL_TX_POWER_MCS_32	       100	/* Index for 40MHz rate MCS 32 */
-#define WL_TX_POWER_MCS_32_NUM	       1
-
-/* sslpnphy specifics */
-#define WL_TX_POWER_MCS20_SISO_FIRST_SSN   12	/* Index for first 20MHz MCS SISO rate */
-
-/* tx_power_t.flags bits */
-#define WL_TX_POWER_F_ENABLED	1
-#define WL_TX_POWER_F_HW	2
-#define WL_TX_POWER_F_MIMO	4
-#define WL_TX_POWER_F_SISO	8
-
-typedef struct {
-	u32 flags;
-	chanspec_t chanspec;	/* txpwr report for this channel */
-	chanspec_t local_chanspec;	/* channel on which we are associated */
-	u8 local_max;	/* local max according to the AP */
-	u8 local_constraint;	/* local constraint according to the AP */
-	s8 antgain[2];	/* Ant gain for each band - from SROM */
-	u8 rf_cores;		/* count of RF Cores being reported */
-	u8 est_Pout[4];	/* Latest tx power out estimate per RF chain */
-	u8 est_Pout_act[4];	/* Latest tx power out estimate per RF chain
-				 * without adjustment
-				 */
-	u8 est_Pout_cck;	/* Latest CCK tx power out estimate */
-	u8 tx_power_max[4];	/* Maximum target power among all rates */
-	u8 tx_power_max_rate_ind[4];	/* Index of the rate with the max target power */
-	u8 user_limit[WL_TX_POWER_RATES];	/* User limit */
-	u8 reg_limit[WL_TX_POWER_RATES];	/* Regulatory power limit */
-	u8 board_limit[WL_TX_POWER_RATES];	/* Max power board can support (SROM) */
-	u8 target[WL_TX_POWER_RATES];	/* Latest target power */
-} tx_power_t;
-
-typedef struct tx_inst_power {
-	u8 txpwr_est_Pout[2];	/* Latest estimate for 2.4 and 5 Ghz */
-	u8 txpwr_est_Pout_gofdm;	/* Pwr estimate for 2.4 OFDM */
-} tx_inst_power_t;
-
-/* Message levels */
-#define WL_ERROR_VAL		0x00000001
-#define WL_TRACE_VAL		0x00000002
-
-/* maximum channels returned by the get valid channels iovar */
-#define WL_NUMCHANNELS		64
-#define WL_NUMCHANSPECS		100
-
-struct tsinfo_arg {
-	u8 octets[3];
-};
-
-#define	NFIFO			6	/* # tx/rx fifopairs */
-
-struct wl_msglevel2 {
-	u32 low;
-	u32 high;
-};
-
-/* structure for per-tid ampdu control */
-struct ampdu_tid_control {
-	u8 tid;		/* tid */
-	u8 enable;		/* enable/disable */
-};
-
-/* structure for identifying ea/tid for sending addba/delba */
-struct ampdu_ea_tid {
-	u8 ea[ETH_ALEN];	/* Station address */
-	u8 tid;		/* tid */
-};
-/* structure for identifying retry/tid for retry_limit_tid/rr_retry_limit_tid */
-struct ampdu_retry_tid {
-	u8 tid;		/* tid */
-	u8 retry;		/* retry value */
-};
-
-
-/* Software feature flag defines used by wlfeatureflag */
-#define WL_SWFL_NOHWRADIO	0x0004
-#define WL_SWFL_FLOWCONTROL     0x0008	/* Enable backpressure to OS stack */
-#define WL_SWFL_WLBSSSORT	0x0010	/* Per-port supports sorting of BSS */
-
-#define WL_LIFETIME_MAX 0xFFFF	/* Max value in ms */
-
-
-/* Pattern matching filter. Specifies an offset within received packets to
- * start matching, the pattern to match, the size of the pattern, and a bitmask
- * that indicates which bits within the pattern should be matched.
- */
-typedef struct wl_pkt_filter_pattern {
-	u32 offset;		/* Offset within received packet to start pattern matching.
-				 * Offset '0' is the first byte of the ethernet header.
-				 */
-	u32 size_bytes;	/* Size of the pattern.  Bitmask must be the same size. */
-	u8 mask_and_pattern[1];	/* Variable length mask and pattern data.  mask starts
-					 * at offset 0.  Pattern immediately follows mask.
-					 */
-} wl_pkt_filter_pattern_t;
-
-/* IOVAR "pkt_filter_add" parameter. Used to install packet filters. */
-typedef struct wl_pkt_filter {
-	u32 id;		/* Unique filter id, specified by app. */
-	u32 type;		/* Filter type (WL_PKT_FILTER_TYPE_xxx). */
-	u32 negate_match;	/* Negate the result of filter matches */
-	union {			/* Filter definitions */
-		wl_pkt_filter_pattern_t pattern;	/* Pattern matching filter */
-	} u;
-} wl_pkt_filter_t;
-
-#define WL_PKT_FILTER_FIXED_LEN		  offsetof(wl_pkt_filter_t, u)
-#define WL_PKT_FILTER_PATTERN_FIXED_LEN	  offsetof(wl_pkt_filter_pattern_t, mask_and_pattern)
-
-/* IOVAR "pkt_filter_enable" parameter. */
-typedef struct wl_pkt_filter_enable {
-	u32 id;		/* Unique filter id */
-	u32 enable;		/* Enable/disable bool */
-} wl_pkt_filter_enable_t;
-
-
-#define	WLC_RSSI_INVALID	 0	/* invalid RSSI value */
-
-/* n-mode support capability */
-/* 2x2 includes both 1x1 & 2x2 devices
- * reserved #define 2 for future when we want to separate 1x1 & 2x2 and
- * control it independently
- */
-#define WL_11N_2x2			1
-#define WL_11N_3x3			3
-#define WL_11N_4x4			4
-
-/* define 11n feature disable flags */
-#define WLFEATURE_DISABLE_11N		0x00000001
-#define WLFEATURE_DISABLE_11N_STBC_TX	0x00000002
-#define WLFEATURE_DISABLE_11N_STBC_RX	0x00000004
-#define WLFEATURE_DISABLE_11N_SGI_TX	0x00000008
-#define WLFEATURE_DISABLE_11N_SGI_RX	0x00000010
-#define WLFEATURE_DISABLE_11N_AMPDU_TX	0x00000020
-#define WLFEATURE_DISABLE_11N_AMPDU_RX	0x00000040
-#define WLFEATURE_DISABLE_11N_GF	0x00000080
-
-#define WL_EVENTING_MASK_LEN	16
-
-#define TOE_TX_CSUM_OL		0x00000001
-#define TOE_RX_CSUM_OL		0x00000002
-
-#define PM_OFF	0
-#define PM_MAX	1
-#define PM_FAST 2
-
-typedef enum sup_auth_status {
-	WLC_SUP_DISCONNECTED = 0,
-	WLC_SUP_CONNECTING,
-	WLC_SUP_IDREQUIRED,
-	WLC_SUP_AUTHENTICATING,
-	WLC_SUP_AUTHENTICATED,
-	WLC_SUP_KEYXCHANGE,
-	WLC_SUP_KEYED,
-	WLC_SUP_TIMEOUT,
-	WLC_SUP_LAST_BASIC_STATE,
-	WLC_SUP_KEYXCHANGE_WAIT_M1 = WLC_SUP_AUTHENTICATED,
-	WLC_SUP_KEYXCHANGE_PREP_M2 = WLC_SUP_KEYXCHANGE,
-	WLC_SUP_KEYXCHANGE_WAIT_M3 = WLC_SUP_LAST_BASIC_STATE,
-	WLC_SUP_KEYXCHANGE_PREP_M4,
-	WLC_SUP_KEYXCHANGE_WAIT_G1,
-	WLC_SUP_KEYXCHANGE_PREP_G2
-} sup_auth_status_t;
 #endif				/* _wlioctl_h_ */
-- 
1.7.4.1


