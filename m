Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4876 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758891Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 25/83] staging: brcm80211: removed unused stuff from
 proto/802.11.h
Date: Wed, 1 Jun 2011 13:45:10 +0200
Message-ID: <1306928768-7501-25-git-send-email-rvossen@broadcom.com> (sfid-20110601_134819_436535_9EE80812)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    2 -
 drivers/staging/brcm80211/brcmsmac/d11.h          |   17 ++
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c  |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c      |    2 -
 drivers/staging/brcm80211/include/proto/802.11.h  |  200 +++++++-------------
 drivers/staging/brcm80211/util/bcmutils.c         |    1 -
 9 files changed, 87 insertions(+), 140 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9c5cfa7..0034dcd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -138,8 +138,6 @@ typedef struct {
 #include <sbsdpcmdev.h>
 #include <bcmsdpcm.h>
 
-#include <proto/802.11.h>
-
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <dhd_bus.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index cb434e5..e022224 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -1771,4 +1771,21 @@ typedef struct macstat {
 #define SHM_BYT_CNT	0x2	/* IHR location */
 #define MAX_BYT_CNT	0x600	/* Maximum frame len */
 
+typedef struct d11cnt {
+	u32 txfrag;
+	u32 txmulti;
+	u32 txfail;
+	u32 txretry;
+	u32 txretrie;
+	u32 rxdup;
+	u32 txrts;
+	u32 txnocts;
+	u32 txnoack;
+	u32 rxfrag;
+	u32 rxmulti;
+	u32 rxcrc;
+	u32 txfrmsnt;
+	u32 rxundec;
+} d11cnt_t;
+
 #endif				/* _D11_H */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index f58272a..3d9f791 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -25,8 +25,6 @@
 #include <linux/sched.h>
 #include <linux/firmware.h>
 #include <net/mac80211.h>
-
-#include <proto/802.11.h>
 #include <bcmdefs.h>
 #include <bcmwifi.h>
 #include <bcmutils.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index e2e5653..128c27b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -21,7 +21,6 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
-#include <proto/802.11.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmwifi.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index 3a80706..c6f9694 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include <proto/802.11.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 4b84cc1..53dcf24 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <proto/802.11.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index cd051d9..a08db2e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -17,8 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <proto/802.11.h>
-
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index 374125d..2f32b6c 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -17,53 +17,23 @@
 #ifndef _802_11_H_
 #define _802_11_H_
 
-#include <linux/if_ether.h>
-
-#define DOT11_A3_HDR_LEN		24
-#define DOT11_A4_HDR_LEN		30
-#define DOT11_MAC_HDR_LEN		DOT11_A3_HDR_LEN
-#define DOT11_ICV_AES_LEN		8
-#define DOT11_QOS_LEN			2
-
-#define DOT11_IV_MAX_LEN		8
-
+#define MCSSET_LEN	16
+#define DOT11_BSSTYPE_ANY			2
+#define DOT11_MAX_DEFAULT_KEYS	4
+#define WPA_OUI			"\x00\x50\xF2"
+#define BRCM_OUI		"\x00\x10\x18"
+#define DOT11_MNG_RSN_ID			48
+#define DOT11_MNG_WPA_ID			221
 #define DOT11_DEFAULT_RTS_LEN		2347
-
-#define DOT11_MIN_FRAG_LEN		256
-#define DOT11_MAX_FRAG_LEN		2346
 #define DOT11_DEFAULT_FRAG_LEN		2346
-
-#define DOT11_MIN_BEACON_PERIOD		1
-#define DOT11_MAX_BEACON_PERIOD		0xFFFF
-
-#define DOT11_MIN_DTIM_PERIOD		1
-#define DOT11_MAX_DTIM_PERIOD		0xFF
-
 #define DOT11_OUI_LEN			3
 
-#define	DOT11_RTS_LEN		16
-#define	DOT11_CTS_LEN		10
-#define	DOT11_ACK_LEN		10
-
-#define DOT11_BA_BITMAP_LEN		128
-#define DOT11_BA_LEN		4
-
-#define WME_OUI			"\x00\x50\xf2"
-#define WME_VER			1
-#define WME_TYPE		2
-#define WME_SUBTYPE_PARAM_IE	1
-
-#define AC_BE			0
-#define AC_BK			1
-#define AC_VI			2
-#define AC_VO			3
 #define AC_COUNT		4
 
-typedef u8 ac_bitmap_t;
-
-#define AC_BITMAP_ALL		0xf
 #define AC_BITMAP_TST(ab, ac)	(((ab) & (1 << (ac))) != 0)
 
+typedef u8 ac_bitmap_t;
+
 struct edcf_acparam {
 	u8 ACI;
 	u8 ECW;
@@ -81,120 +51,90 @@ struct wme_param_ie {
 	edcf_acparam_t acparam[AC_COUNT];
 } __attribute__((packed));
 typedef struct wme_param_ie wme_param_ie_t;
-#define WME_PARAM_IE_LEN            24
-
-#define EDCF_AIFSN_MIN               1
-#define EDCF_AIFSN_MAX               15
-#define EDCF_AIFSN_MASK              0x0f
-#define EDCF_ACM_MASK                0x10
-#define EDCF_ACI_MASK                0x60
-#define EDCF_ACI_SHIFT               5
-
-#define EDCF_ECW2CW(exp)             ((1 << (exp)) - 1)
-#define EDCF_ECWMIN_MASK             0x0f
-#define EDCF_ECWMAX_MASK             0xf0
-#define EDCF_ECWMAX_SHIFT            4
-
-#define EDCF_TXOP2USEC(txop)         ((txop) << 5)
-
-#define EDCF_AC_BE_ACI_STA           0x03
-#define EDCF_AC_BE_ECW_STA           0xA4
-#define EDCF_AC_BE_TXOP_STA          0x0000
-#define EDCF_AC_BK_ACI_STA           0x27
-#define EDCF_AC_BK_ECW_STA           0xA4
-#define EDCF_AC_BK_TXOP_STA          0x0000
-#define EDCF_AC_VI_ACI_STA           0x42
-#define EDCF_AC_VI_ECW_STA           0x43
-#define EDCF_AC_VI_TXOP_STA          0x005e
-#define EDCF_AC_VO_ACI_STA           0x62
-#define EDCF_AC_VO_ECW_STA           0x32
-#define EDCF_AC_VO_TXOP_STA          0x002f
 
-#define EDCF_AC_VO_TXOP_AP           0x002f
+#define DOT11_MAC_HDR_LEN		24
+#define	DOT11_ACK_LEN		10
+#define DOT11_ICV_AES_LEN		8
+#define DOT11_A4_HDR_LEN		30
+#define DOT11_QOS_LEN			2
+#define DOT11_IV_MAX_LEN		8
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
 
 #define SEQNUM_SHIFT		4
+#define AMPDU_DELIMITER_LEN	4
 #define SEQNUM_MAX		0x1000
-#define FRAGNUM_MASK		0xF
-
-#define DOT11_MNG_RSN_ID			48
-#define DOT11_MNG_WPA_ID			221
-#define DOT11_MNG_VS_ID				221
-
-#define DOT11_BSSTYPE_INFRASTRUCTURE		0
-#define DOT11_BSSTYPE_ANY			2
-#define DOT11_SCANTYPE_ACTIVE			0
 
-#define PREN_PREAMBLE		24
-#define PREN_MM_EXT		12
-#define PREN_PREAMBLE_EXT	4
+#define APHY_SLOT_TIME		9
+#define BPHY_SLOT_TIME		20
+#define	APHY_CWMIN		15
+#define PHY_CWMAX		1023
 
-#define RIFS_11N_TIME		2
+#define EDCF_AIFSN_MIN               1
+#define BPHY_PLCP_TIME		192
 
-#define APHY_SLOT_TIME		9
-#define APHY_SIFS_TIME		16
+#define APHY_SYMBOL_TIME	4
 #define APHY_PREAMBLE_TIME	16
 #define APHY_SIGNAL_TIME	4
-#define APHY_SYMBOL_TIME	4
+#define APHY_SIFS_TIME		16
 #define APHY_SERVICE_NBITS	16
 #define APHY_TAIL_NBITS		6
-#define	APHY_CWMIN		15
-
-#define BPHY_SLOT_TIME		20
 #define BPHY_SIFS_TIME		10
-#define BPHY_PLCP_TIME		192
 #define BPHY_PLCP_SHORT_TIME	96
 
-#define DOT11_OFDM_SIGNAL_EXTENSION	6
-
-#define PHY_CWMAX		1023
-
-#define	DOT11_MAXNUMFRAGS	16
-
-typedef struct d11cnt {
-	u32 txfrag;
-	u32 txmulti;
-	u32 txfail;
-	u32 txretry;
-	u32 txretrie;
-	u32 rxdup;
-	u32 txrts;
-	u32 txnocts;
-	u32 txnoack;
-	u32 rxfrag;
-	u32 rxmulti;
-	u32 rxcrc;
-	u32 txfrmsnt;
-	u32 rxundec;
-} d11cnt_t;
+#define PREN_PREAMBLE		24
+#define PREN_MM_EXT		12
+#define PREN_PREAMBLE_EXT	4
 
-#define MCSSET_LEN	16
+#define FRAGNUM_MASK		0xF
 
-#define HT_CAP_IE_LEN		26
+#define RIFS_11N_TIME		2
 
 #define HT_CAP_RX_STBC_NO		0x0
-#define HT_CAP_RX_STBC_ONE_STREAM	0x1
-
-#define AMPDU_MAX_MPDU_DENSITY	IEEE80211_HT_MPDU_DENSITY_16
-
-#define AMPDU_DELIMITER_LEN	4
 
-#define DOT11N_TXBURST		0x0008
-
-#define WPA_VERSION		1
-#define WPA_OUI			"\x00\x50\xF2"
+#define EDCF_ACI_MASK                0x60
+#define EDCF_ACI_SHIFT               5
+#define EDCF_ECWMIN_MASK             0x0f
+#define EDCF_ECWMAX_SHIFT            4
+#define EDCF_AIFSN_MASK              0x0f
+#define EDCF_AIFSN_MAX               15
+#define EDCF_ECWMAX_MASK             0xf0
 
-#define WFA_OUI			"\x00\x50\xF2"
-#define WFA_OUI_LEN	3
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
 
-#define WFA_OUI_TYPE_WPA	1
+#define EDCF_TXOP2USEC(txop)         ((txop) << 5)
+#define EDCF_ECW2CW(exp)             ((1 << (exp)) - 1)
 
-#define RSN_AKM_NONE		0
-#define RSN_AKM_UNSPECIFIED	1
-#define RSN_AKM_PSK		2
+#define WME_VER			1
+#define WME_SUBTYPE_PARAM_IE	1
+#define WME_TYPE		2
+#define WME_OUI			"\x00\x50\xf2"
 
-#define DOT11_MAX_DEFAULT_KEYS	4
-#define DOT11_WPA_KEY_RSC_LEN   8
+#define AC_BE			0
+#define AC_BK			1
+#define AC_VI			2
+#define AC_VO			3
 
-#define BRCM_OUI		"\x00\x10\x18"
+#define HT_CAP_RX_STBC_ONE_STREAM	0x1
 
 #endif				/* _802_11_H_ */
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 1c8b6c6..63843bc 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -26,7 +26,6 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <bcmdevs.h>
-#include <proto/802.11.h>
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver utilities.");
-- 
1.7.4.1


