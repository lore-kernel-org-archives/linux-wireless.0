Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4822 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161163Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 26/83] staging: brcm80211: emptied include/802.11.h
Date: Wed, 1 Jun 2011 13:45:11 +0200
Message-ID: <1306928768-7501-26-git-send-email-rvossen@broadcom.com> (sfid-20110601_134640_986208_E0B07905)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Removed unused definitions. Moved other definitions to less
generic locations.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    3 +
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |    3 +
 drivers/staging/brcm80211/brcmfmac/wl_iw.c       |    4 +
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c    |    3 +
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |   64 ++++++++++++
 drivers/staging/brcm80211/brcmsmac/wlc_main.h    |   30 ++++++
 drivers/staging/brcm80211/include/bcmwifi.h      |   17 +++
 drivers/staging/brcm80211/include/proto/802.11.h |  120 ----------------------
 8 files changed, 124 insertions(+), 120 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 6156062..9583f57 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -188,6 +188,9 @@ struct dhd_info;
 #define DHD_DEL_IF	-0xe
 #define DHD_BAD_IF	-0xf
 
+#define DOT11_BSSTYPE_ANY			2
+#define DOT11_MAX_DEFAULT_KEYS	4
+
 enum cust_gpio_modes {
 	WLAN_RESET_ON,
 	WLAN_RESET_OFF,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 5aa5ee4..b7f4e63 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -25,6 +25,9 @@
 #include <dhd_dbg.h>
 #include <msgtrace.h>
 
+#define BRCM_OUI		"\x00\x10\x18"
+#define DOT11_OUI_LEN			3
+
 int dhd_msg_level;
 char fw_path[MOD_PARAM_PATHLEN];
 char nv_path[MOD_PARAM_PATHLEN];
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index b5cb897..2cc9bc7 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -32,6 +32,10 @@ typedef const struct si_pub si_t;
 #include <dngl_stats.h>
 #include <dhd.h>
 
+#define WPA_OUI			"\x00\x50\xF2"
+#define DOT11_MNG_RSN_ID			48
+#define DOT11_MNG_WPA_ID			221
+
 #define WL_ERROR(fmt, args...)	printk(fmt, ##args)
 #define WL_TRACE(fmt, args...)	no_printk(fmt, ##args)
 #define WL_INFORM(fmt, args...)	no_printk(fmt, ##args)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 128c27b..ab4ef6c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -75,6 +75,9 @@
 		(void *)&(wlc_hw->regs->fifo64regs[fifonum].dmaxmt) : \
 		(void *)&(wlc_hw->regs->fifo64regs[fifonum].dmarcv))
 
+#define APHY_SLOT_TIME		9
+#define BPHY_SLOT_TIME		20
+
 /*
  * The following table lists the buffer memory allocated to xmt fifos in HW.
  * the size is in units of 256bytes(one block), total size is HW dependent
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 026d200..c50f335 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -114,6 +114,70 @@
 #define WLFEATURE_DISABLE_11N_AMPDU_RX	0x00000040
 #define WLFEATURE_DISABLE_11N_GF	0x00000080
 
+#define EDCF_ACI_MASK                0x60
+#define EDCF_ACI_SHIFT               5
+#define EDCF_ECWMIN_MASK             0x0f
+#define EDCF_ECWMAX_SHIFT            4
+#define EDCF_AIFSN_MASK              0x0f
+#define EDCF_AIFSN_MAX               15
+#define EDCF_ECWMAX_MASK             0xf0
+
+#define EDCF_AC_BE_TXOP_STA          0x0000
+#define EDCF_AC_BK_TXOP_STA          0x0000
+#define EDCF_AC_VO_ACI_STA           0x62
+#define EDCF_AC_VO_ECW_STA           0x32
+#define EDCF_AC_VI_ACI_STA           0x42
+#define EDCF_AC_VI_ECW_STA           0x43
+#define EDCF_AC_BK_ECW_STA           0xA4
+#define EDCF_AC_VI_TXOP_STA          0x005e
+#define EDCF_AC_VO_TXOP_STA          0x002f
+#define EDCF_AC_BE_ACI_STA           0x03
+#define EDCF_AC_BE_ECW_STA           0xA4
+#define EDCF_AC_BK_ACI_STA           0x27
+#define EDCF_AC_VO_TXOP_AP           0x002f
+
+#define EDCF_TXOP2USEC(txop)         ((txop) << 5)
+#define EDCF_ECW2CW(exp)             ((1 << (exp)) - 1)
+
+#define APHY_SYMBOL_TIME	4
+#define APHY_PREAMBLE_TIME	16
+#define APHY_SIGNAL_TIME	4
+#define APHY_SIFS_TIME		16
+#define APHY_SERVICE_NBITS	16
+#define APHY_TAIL_NBITS		6
+#define BPHY_SIFS_TIME		10
+#define BPHY_PLCP_SHORT_TIME	96
+
+#define PREN_PREAMBLE		24
+#define PREN_MM_EXT		12
+#define PREN_PREAMBLE_EXT	4
+
+#define DOT11_MAC_HDR_LEN		24
+#define	DOT11_ACK_LEN		10
+#define DOT11_BA_LEN		4
+#define DOT11_OFDM_SIGNAL_EXTENSION	6
+#define DOT11_MIN_FRAG_LEN		256
+#define	DOT11_RTS_LEN		16
+#define	DOT11_CTS_LEN		10
+#define DOT11_BA_BITMAP_LEN		128
+#define DOT11_MIN_BEACON_PERIOD		1
+#define DOT11_MAX_BEACON_PERIOD		0xFFFF
+#define	DOT11_MAXNUMFRAGS	16
+#define DOT11_MAX_FRAG_LEN		2346
+
+#define BPHY_PLCP_TIME		192
+#define RIFS_11N_TIME		2
+
+#define WME_VER			1
+#define WME_SUBTYPE_PARAM_IE	1
+#define WME_TYPE		2
+#define WME_OUI			"\x00\x50\xf2"
+
+#define AC_BE			0
+#define AC_BK			1
+#define AC_VI			2
+#define AC_VO			3
+
 /*
  * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s OS timer(soft
  * watchdog) it is not a wall clock and won't increment when driver is in "down" state
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index d4ae29b..d066339 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -23,6 +23,16 @@
 #define	MAXCOREREV		28	/* max # supported core revisions (0 .. MAXCOREREV - 1) */
 #define WLC_MAXMODULES		22	/* max #  wlc_module_register() calls */
 
+#define SEQNUM_SHIFT		4
+#define AMPDU_DELIMITER_LEN	4
+#define SEQNUM_MAX		0x1000
+
+#define	APHY_CWMIN		15
+#define PHY_CWMAX		1023
+
+#define EDCF_AIFSN_MIN               1
+#define FRAGNUM_MASK		0xF
+
 #define WLC_BITSCNT(x)	bcm_bitcount((u8 *)&(x), sizeof(u8))
 
 /* Maximum wait time for a MAC suspend */
@@ -35,6 +45,8 @@
 /* transmit buffer max headroom for protocol headers */
 #define TXOFF (D11_TXH_LEN + D11_PHY_HDR_LEN)
 
+#define AC_COUNT		4
+
 /* For managing scan result lists */
 struct wlc_bss_list {
 	uint count;
@@ -342,6 +354,24 @@ struct dumpcb_s {
 	struct dumpcb_s *next;
 };
 
+struct edcf_acparam {
+	u8 ACI;
+	u8 ECW;
+	u16 TXOP;
+} __attribute__((packed));
+typedef struct edcf_acparam edcf_acparam_t;
+
+struct wme_param_ie {
+	u8 oui[3];
+	u8 type;
+	u8 subtype;
+	u8 version;
+	u8 qosinfo;
+	u8 rsvd;
+	edcf_acparam_t acparam[AC_COUNT];
+} __attribute__((packed));
+typedef struct wme_param_ie wme_param_ie_t;
+
 /* virtual interface */
 struct wlc_if {
 	struct wlc_if *next;
diff --git a/drivers/staging/brcm80211/include/bcmwifi.h b/drivers/staging/brcm80211/include/bcmwifi.h
index f0dc6f8..60f404c 100644
--- a/drivers/staging/brcm80211/include/bcmwifi.h
+++ b/drivers/staging/brcm80211/include/bcmwifi.h
@@ -131,6 +131,10 @@ typedef u16 chanspec_t;
 
 #define WLC_2G_25MHZ_OFFSET		5	/* 2.4GHz band channel offset */
 
+#define MCSSET_LEN	16
+
+#define AC_BITMAP_TST(ab, ac)	(((ab) & (1 << (ac))) != 0)
+
 /*
  * Verify the chanspec is using a legal set of parameters, i.e. that the
  * chanspec specified a band, bw, ctl_sb and channel and that the
@@ -202,6 +206,17 @@ extern int bcm_mhz2channel(uint freq, uint start_factor);
 /* pmkid */
 #define	MAXPMKID		16
 
+#define DOT11_DEFAULT_RTS_LEN		2347
+#define DOT11_DEFAULT_FRAG_LEN		2346
+
+#define DOT11_ICV_AES_LEN		8
+#define DOT11_QOS_LEN			2
+#define DOT11_IV_MAX_LEN		8
+#define DOT11_A4_HDR_LEN		30
+
+#define HT_CAP_RX_STBC_NO		0x0
+#define HT_CAP_RX_STBC_ONE_STREAM	0x1
+
 typedef struct _pmkid {
 	u8 BSSID[ETH_ALEN];
 	u8 PMKID[WLAN_PMKID_LEN];
@@ -222,4 +237,6 @@ typedef struct _pmkid_cand_list {
 	pmkid_cand_t pmkid_cand[1];
 } pmkid_cand_list_t;
 
+typedef u8 ac_bitmap_t;
+
 #endif				/* _bcmwifi_h_ */
diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index 2f32b6c..048dae5 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -17,124 +17,4 @@
 #ifndef _802_11_H_
 #define _802_11_H_
 
-#define MCSSET_LEN	16
-#define DOT11_BSSTYPE_ANY			2
-#define DOT11_MAX_DEFAULT_KEYS	4
-#define WPA_OUI			"\x00\x50\xF2"
-#define BRCM_OUI		"\x00\x10\x18"
-#define DOT11_MNG_RSN_ID			48
-#define DOT11_MNG_WPA_ID			221
-#define DOT11_DEFAULT_RTS_LEN		2347
-#define DOT11_DEFAULT_FRAG_LEN		2346
-#define DOT11_OUI_LEN			3
-
-#define AC_COUNT		4
-
-#define AC_BITMAP_TST(ab, ac)	(((ab) & (1 << (ac))) != 0)
-
-typedef u8 ac_bitmap_t;
-
-struct edcf_acparam {
-	u8 ACI;
-	u8 ECW;
-	u16 TXOP;
-} __attribute__((packed));
-typedef struct edcf_acparam edcf_acparam_t;
-
-struct wme_param_ie {
-	u8 oui[3];
-	u8 type;
-	u8 subtype;
-	u8 version;
-	u8 qosinfo;
-	u8 rsvd;
-	edcf_acparam_t acparam[AC_COUNT];
-} __attribute__((packed));
-typedef struct wme_param_ie wme_param_ie_t;
-
-#define DOT11_MAC_HDR_LEN		24
-#define	DOT11_ACK_LEN		10
-#define DOT11_ICV_AES_LEN		8
-#define DOT11_A4_HDR_LEN		30
-#define DOT11_QOS_LEN			2
-#define DOT11_IV_MAX_LEN		8
-#define DOT11_BA_LEN		4
-#define DOT11_OFDM_SIGNAL_EXTENSION	6
-#define DOT11_MIN_FRAG_LEN		256
-#define	DOT11_RTS_LEN		16
-#define	DOT11_CTS_LEN		10
-#define DOT11_BA_BITMAP_LEN		128
-#define DOT11_MIN_BEACON_PERIOD		1
-#define DOT11_MAX_BEACON_PERIOD		0xFFFF
-#define	DOT11_MAXNUMFRAGS	16
-#define DOT11_MAX_FRAG_LEN		2346
-
-#define SEQNUM_SHIFT		4
-#define AMPDU_DELIMITER_LEN	4
-#define SEQNUM_MAX		0x1000
-
-#define APHY_SLOT_TIME		9
-#define BPHY_SLOT_TIME		20
-#define	APHY_CWMIN		15
-#define PHY_CWMAX		1023
-
-#define EDCF_AIFSN_MIN               1
-#define BPHY_PLCP_TIME		192
-
-#define APHY_SYMBOL_TIME	4
-#define APHY_PREAMBLE_TIME	16
-#define APHY_SIGNAL_TIME	4
-#define APHY_SIFS_TIME		16
-#define APHY_SERVICE_NBITS	16
-#define APHY_TAIL_NBITS		6
-#define BPHY_SIFS_TIME		10
-#define BPHY_PLCP_SHORT_TIME	96
-
-#define PREN_PREAMBLE		24
-#define PREN_MM_EXT		12
-#define PREN_PREAMBLE_EXT	4
-
-#define FRAGNUM_MASK		0xF
-
-#define RIFS_11N_TIME		2
-
-#define HT_CAP_RX_STBC_NO		0x0
-
-#define EDCF_ACI_MASK                0x60
-#define EDCF_ACI_SHIFT               5
-#define EDCF_ECWMIN_MASK             0x0f
-#define EDCF_ECWMAX_SHIFT            4
-#define EDCF_AIFSN_MASK              0x0f
-#define EDCF_AIFSN_MAX               15
-#define EDCF_ECWMAX_MASK             0xf0
-
-#define EDCF_AC_BE_TXOP_STA          0x0000
-#define EDCF_AC_BK_TXOP_STA          0x0000
-#define EDCF_AC_VO_ACI_STA           0x62
-#define EDCF_AC_VO_ECW_STA           0x32
-#define EDCF_AC_VI_ACI_STA           0x42
-#define EDCF_AC_VI_ECW_STA           0x43
-#define EDCF_AC_BK_ECW_STA           0xA4
-#define EDCF_AC_VI_TXOP_STA          0x005e
-#define EDCF_AC_VO_TXOP_STA          0x002f
-#define EDCF_AC_BE_ACI_STA           0x03
-#define EDCF_AC_BE_ECW_STA           0xA4
-#define EDCF_AC_BK_ACI_STA           0x27
-#define EDCF_AC_VO_TXOP_AP           0x002f
-
-#define EDCF_TXOP2USEC(txop)         ((txop) << 5)
-#define EDCF_ECW2CW(exp)             ((1 << (exp)) - 1)
-
-#define WME_VER			1
-#define WME_SUBTYPE_PARAM_IE	1
-#define WME_TYPE		2
-#define WME_OUI			"\x00\x50\xf2"
-
-#define AC_BE			0
-#define AC_BK			1
-#define AC_VI			2
-#define AC_VO			3
-
-#define HT_CAP_RX_STBC_ONE_STREAM	0x1
-
 #endif				/* _802_11_H_ */
-- 
1.7.4.1


