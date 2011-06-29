Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1915 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183Ab1F2XtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 085/119] staging: brcm80211: remove unused definitions
 from dhd.h
Date: Wed, 29 Jun 2011 16:47:49 -0700
Message-ID: <1309391303-22741-86-git-send-email-frankyl@broadcom.com> (sfid-20110630_015228_203965_EB1F4B57)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several defintions from dhd.h are not used in the fullmac driver
and have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h |  112 ------------------------------
 1 files changed, 0 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index b2db6b9..2ebf015 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -308,13 +308,6 @@ typedef struct brcmf_event {
 #define BRCMF_E_LINK_ASSOC_REC			3
 #define BRCMF_E_LINK_BSSCFG_DIS			4
 
-enum cust_gpio_modes {
-	WLAN_RESET_ON,
-	WLAN_RESET_OFF,
-	WLAN_POWER_ON,
-	WLAN_POWER_OFF
-};
-
 /* The level of bus communication with the dongle */
 enum dhd_bus_state {
 	DHD_BUS_DOWN,		/* Not ready for frame transfers */
@@ -448,20 +441,6 @@ typedef struct wl_scan_results {
 	wl_bss_info_t bss_info[1];
 } wl_scan_results_t;
 
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
 /* used for association with a specific BSSID and chanspec list */
 typedef struct wl_assoc_params {
 	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
@@ -472,9 +451,6 @@ typedef struct wl_assoc_params {
 } wl_assoc_params_t;
 #define WL_ASSOC_PARAMS_FIXED_SIZE	(sizeof(wl_assoc_params_t) - sizeof(chanspec_t))
 
-/* used for reassociation/roam to a specific BSSID and channel */
-typedef wl_assoc_params_t wl_reassoc_params_t;
-
 /* used for join with or without a specific bssid and channel list */
 typedef struct wl_join_params {
 	wlc_ssid_t ssid;
@@ -496,94 +472,6 @@ typedef struct wl_iscan_results {
 #define WL_ISCAN_RESULTS_FIXED_SIZE \
 	(WL_SCAN_RESULTS_FIXED_SIZE + offsetof(wl_iscan_results_t, results))
 
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
-
 typedef struct wl_wsec_key {
 	u32 index;		/* key index */
 	u32 len;		/* key length */
-- 
1.7.1


