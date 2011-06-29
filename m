Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4518 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080Ab1F2Xs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:59 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 041/119] staging: brcm80211: remove unused definitions
 from dhd.h
Date: Wed, 29 Jun 2011 16:47:05 -0700
Message-ID: <1309391303-22741-42-git-send-email-frankyl@broadcom.com> (sfid-20110630_015138_031438_347C8874)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The header file dhd.h contained a number of macro definitions that
are not used within the driver and have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h |   41 ------------------------------
 1 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 14713f5..9b27982 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -119,47 +119,12 @@ struct dhd_info;
 #define WL_SCAN_RESULTS_ABORTED	3
 #define WL_SCAN_RESULTS_NO_MEM	4
 
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
-#define  CCA_FLAG_IGNORE_INTERFER	0x20	/* do not exlude channel based on interfer level */
-
-#define CCA_ERRNO_BAND		1	/* After filtering for band pref, no choices left */
-#define CCA_ERRNO_DURATION	2	/* After filtering for duration, no choices left */
-#define CCA_ERRNO_PREF_CHAN	3	/* After filtering for chan pref, no choices left */
-#define CCA_ERRNO_INTERFER	4	/* After filtering for interference, no choices left */
-#define CCA_ERRNO_TOO_FEW	5	/* Only 1 channel was input */
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
 #define WL_SOFT_KEY	(1 << 0)	/* Indicates this key is using soft encrypt */
 #define WL_PRIMARY_KEY	(1 << 1)	/* Indicates this key is the primary (ie tx) key */
 #define WL_KF_RES_4	(1 << 4)	/* Reserved for backward compat */
 #define WL_KF_RES_5	(1 << 5)	/* Reserved for backward compat */
 #define WL_IBSS_PEER_GROUP_KEY	(1 << 6)	/* Indicates a group key for a IBSS PEER */
 
-#define DHD_IF_VIF	0x01	/* Virtual IF (Hidden from user) */
-
 /* optionally set by a module_param_string() */
 #define MOD_PARAM_PATHLEN	2048
 
@@ -171,7 +136,6 @@ struct dhd_info;
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
 
-#define BCM_EVENT_MSG_VERSION		1
 #define BCM_MSG_IFNAME_MAX		16
 
 #define WLC_EVENT_MSG_LINK		0x01
@@ -522,7 +486,6 @@ typedef struct wl_assoc_params {
 
 /* used for reassociation/roam to a specific BSSID and channel */
 typedef wl_assoc_params_t wl_reassoc_params_t;
-#define WL_REASSOC_PARAMS_FIXED_SIZE	WL_ASSOC_PARAMS_FIXED_SIZE
 
 /* used for join with or without a specific bssid and channel list */
 typedef struct wl_join_params {
@@ -531,7 +494,6 @@ typedef struct wl_join_params {
 					 * of the wl_assoc_params_t struct when it does present.
 					 */
 } wl_join_params_t;
-#define WL_JOIN_PARAMS_FIXED_SIZE	(sizeof(wl_join_params_t) - sizeof(chanspec_t))
 
 /* size of wl_scan_results not including variable length array */
 #define WL_SCAN_RESULTS_FIXED_SIZE (sizeof(wl_scan_results_t) - sizeof(wl_bss_info_t))
@@ -609,7 +571,6 @@ typedef struct wl_rm_req {
 	void *cb_arg;		/* arg to completion callback function */
 	wl_rm_req_elt_t req[1];	/* variable length block of requests */
 } wl_rm_req_t;
-#define WL_RM_REQ_FIXED_LEN	offsetof(wl_rm_req_t, req)
 
 typedef struct wl_rm_rep_elt {
 	s8 type;
@@ -622,7 +583,6 @@ typedef struct wl_rm_rep_elt {
 	u32 len;		/* byte length of data block */
 	u8 data[1];		/* variable length data block */
 } wl_rm_rep_elt_t;
-#define WL_RM_REP_ELT_FIXED_LEN	24	/* length excluding data block */
 
 #define WL_RPI_REP_BIN_NUM 8
 typedef struct wl_rm_rpi_rep {
@@ -635,7 +595,6 @@ typedef struct wl_rm_rep {
 	u32 len;		/* length of measurement report block */
 	wl_rm_rep_elt_t rep[1];	/* variable length block of reports */
 } wl_rm_rep_t;
-#define WL_RM_REP_FIXED_LEN	8
 
 typedef struct wl_wsec_key {
 	u32 index;		/* key index */
-- 
1.7.1


