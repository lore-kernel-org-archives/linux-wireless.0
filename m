Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2161 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab1IBOA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:58 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/12] staging: brcm80211: cleaned up more softmac
 macro's
Date: Fri, 2 Sep 2011 16:00:35 +0200
Message-ID: <1314972039-27098-9-git-send-email-rvossen@broadcom.com> (sfid-20110902_160122_320286_3E7EEEDD)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/removed macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   18 ++++++++++
 drivers/staging/brcm80211/brcmsmac/main.h |    1 -
 drivers/staging/brcm80211/brcmsmac/otp.c  |    5 ++-
 drivers/staging/brcm80211/brcmsmac/otp.h  |    6 ---
 drivers/staging/brcm80211/brcmsmac/pmu.h  |   13 --------
 drivers/staging/brcm80211/brcmsmac/pub.h  |   49 -----------------------------
 6 files changed, 21 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 9e73b42..fff3ba9 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -267,6 +267,20 @@
 #define APHY_SLOT_TIME		9
 #define BPHY_SLOT_TIME		20
 
+#define	WL_SPURAVOID_OFF	0
+#define	WL_SPURAVOID_ON1	1
+#define	WL_SPURAVOID_ON2	2
+
+/*
+ * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
+ */
+#define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
+
+/* defaults for the HT (MIMO) bss */
+#define HT_CAP	(IEEE80211_HT_CAP_SM_PS |\
+	IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_GRN_FLD |\
+	IEEE80211_HT_CAP_MAX_AMSDU | IEEE80211_HT_CAP_DSSSCCK40)
+
 /*
  * The following table lists the buffer memory allocated to xmt fifos in HW.
  * the size is in units of 256bytes(one block), total size is HW dependent
@@ -361,6 +375,10 @@
 #define IS_MBAND_UNLOCKED(wlc) \
 	((wlc->pub->_nbands > 1) && !(wlc)->bandlocked)
 
+#define CHSPEC_WLC_BW(chanspec)	(CHSPEC_IS40(chanspec) ? BRCMS_40_MHZ : \
+				 CHSPEC_IS20(chanspec) ? BRCMS_20_MHZ : \
+							 BRCMS_10_MHZ)
+
 /* dup state between BMAC(struct brcms_hardware) and HIGH(struct brcms_c_info)
    driver */
 struct brcms_b_state {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index e8a854b..047c422 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -23,7 +23,6 @@
 #include "types.h"
 #include "d11.h"
 
-#define MA_WINDOW_SZ		8	/* moving average window size */
 #define	INVCHANNEL		255	/* invalid channel */
 
 /* max # brcms_c_module_register() calls */
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 1e0093c..05c78c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -64,6 +64,9 @@
 
 #define MAXNUMRDES		9	/* Maximum OTP redundancy entries */
 
+/* Fixed size subregions sizes in words */
+#define OTPGU_CI_SZ		2
+
 /* OTP function struct */
 struct otp_fn_s {
 	int (*size)(struct otpinfo *oi);
@@ -111,8 +114,6 @@ static struct otpinfo otpinfo;
  *
  */
 
-#define HWSW_RGN(rgn)		(((rgn) == OTP_HW_RGN) ? "h/w" : "s/w")
-
 /* OTP layout */
 /* CC revs 21, 24 and 27 OTP General Use Region word offset */
 #define REVA4_OTPGU_BASE	12
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.h b/drivers/staging/brcm80211/brcmsmac/otp.h
index 938100e..bf2f76f 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.h
+++ b/drivers/staging/brcm80211/brcmsmac/otp.h
@@ -30,12 +30,6 @@
 /* OTP Size */
 #define OTP_SZ_MAX		(6144/8)	/* maximum bytes in one CIS */
 
-/* Fixed size subregions sizes in words */
-#define OTPGU_CI_SZ		2
-
-/* OTP usage */
-#define OTP4325_FM_DISABLED_OFFSET	188
-
 struct otpinfo;
 
 /* Exported functions */
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.h b/drivers/staging/brcm80211/brcmsmac/pmu.h
index 0c7e48c..2917e6f 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.h
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.h
@@ -19,19 +19,6 @@
 #define _BRCM_PMU_H_
 
 #include "types.h"
-/*
- * LDO selections used in si_pmu_set_ldo_voltage
- */
-#define SET_LDO_VOLTAGE_LDO1	1
-#define SET_LDO_VOLTAGE_LDO2	2
-#define SET_LDO_VOLTAGE_LDO3	3
-#define SET_LDO_VOLTAGE_PAREF	4
-#define SET_LDO_VOLTAGE_CLDO_PWM	5
-#define SET_LDO_VOLTAGE_CLDO_BURST	6
-#define SET_LDO_VOLTAGE_CBUCK_PWM	7
-#define SET_LDO_VOLTAGE_CBUCK_BURST	8
-#define SET_LDO_VOLTAGE_LNLDO1	9
-#define SET_LDO_VOLTAGE_LNLDO2_SEL	10
 
 extern u16 si_pmu_fast_pwrup_delay(struct si_pub *sih);
 extern void si_pmu_sprom_enable(struct si_pub *sih, bool enable);
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 5bca2fb..ab2fb11 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -40,10 +40,6 @@
 #define BRCMS_20_MHZ	20	/* 20Mhz nphy channel bandwidth */
 #define BRCMS_40_MHZ	40	/* 40Mhz nphy channel bandwidth */
 
-#define CHSPEC_WLC_BW(chanspec)	(CHSPEC_IS40(chanspec) ? BRCMS_40_MHZ : \
-				 CHSPEC_IS20(chanspec) ? BRCMS_20_MHZ : \
-							 BRCMS_10_MHZ)
-
 #define	BRCMS_RSSI_MINVAL	-200	/* Low value, e.g. for forcing roam */
 #define	BRCMS_RSSI_NO_SIGNAL	-91	/* NDIS RSSI link quality cutoffs */
 #define	BRCMS_RSSI_VERY_LOW	-80	/* Very low quality cutoffs */
@@ -52,13 +48,6 @@
 #define	BRCMS_RSSI_VERY_GOOD	-58	/* Very good quality cutoffs */
 #define	BRCMS_RSSI_EXCELLENT	-57	/* Excellent quality cutoffs */
 
-/* macro to perform PHY -> D11 PHY TYPE, currently 1:1 */
-#define BRCMS_PHYTYPE(_x) (_x)
-
-#define MA_WINDOW_SZ		8	/* moving average window size */
-
-#define BRCMS_SNR_INVALID		0	/* invalid SNR value */
-
 /* a large TX Power as an init value to factor out of min() calculations,
  * keep low enough to fit in an s8, units are .25 dBm
  */
@@ -87,9 +76,6 @@
 /* driver's default tx antenna setting */
 #define ANT_TX_DEF		3
 
-/* use all available core for transmit */
-#define TXCORE_POLICY_ALL	0x1
-
 /* Tx Chain values */
 /* def bitmap of txchain */
 #define TXCHAIN_DEF		0x1
@@ -113,15 +99,9 @@
 #define ANTSWITCH_TYPE_3	3
 
 #define RXBUFSZ		PKTBUFSZ
-/* aid bitmap size in bytes */
-#define AIDMAPSZ	(roundup(MAXSCB, NBBY)/NBBY)
 
 #define MAX_STREAMS_SUPPORTED	4	/* max number of streams supported */
 
-#define	WL_SPURAVOID_OFF	0
-#define	WL_SPURAVOID_ON1	1
-#define	WL_SPURAVOID_ON2	2
-
 struct brcms_tunables {
 	int ntxd;	/* size of tx descriptor table */
 	int nrxd;	/* size of rx descriptor table */
@@ -158,24 +138,11 @@ struct rsn_parms {
 	u8 PAD[4];		/* padding for future growth */
 };
 
-/*
- * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
- */
-#define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
-
-#define RSN_FLAGS_SUPPORTED		0x1	/* Flag for rsn_params */
-#define RSN_FLAGS_PREAUTH		0x2	/* Flag for WPA2 rsn_params */
-
 /* All the HT-specific default advertised capabilities (including AMPDU)
  * should be grouped here at one place
  */
 #define AMPDU_DEF_MPDU_DENSITY	6	/* default mpdu density (110 ==> 4us) */
 
-/* defaults for the HT (MIMO) bss */
-#define HT_CAP	(IEEE80211_HT_CAP_SM_PS |\
-	IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_GRN_FLD |\
-	IEEE80211_HT_CAP_MAX_AMSDU | IEEE80211_HT_CAP_DSSSCCK40)
-
 /* wlc internal bss_info */
 struct brcms_bss_info {
 	u8 BSSID[ETH_ALEN];	/* network BSSID */
@@ -202,22 +169,6 @@ struct brcms_bss_info {
 	u8 wpacfg;		/* wpa config index */
 };
 
-/* IOVar flags for common error checks */
-#define IOVF_MFG	(1<<3)	/* flag for mfgtest iovars */
-#define IOVF_WHL	(1<<4)	/* value must be whole (0-max) */
-#define IOVF_NTRL	(1<<5)	/* value must be natural (1-max) */
-
-#define IOVF_SET_UP	(1<<6)	/* set requires driver be up */
-#define IOVF_SET_DOWN	(1<<7)	/* set requires driver be down */
-#define IOVF_SET_CLK	(1<<8)	/* set requires core clock */
-#define IOVF_SET_BAND	(1<<9)	/* set requires fixed band */
-
-#define IOVF_GET_UP	(1<<10)	/* get requires driver be up */
-#define IOVF_GET_DOWN	(1<<11)	/* get requires driver be down */
-#define IOVF_GET_CLK	(1<<12)	/* get requires core clock */
-#define IOVF_GET_BAND	(1<<13)	/* get requires fixed band */
-#define IOVF_OPEN_ALLOW	(1<<14)	/* set allowed iovar for opensrc */
-
 #define MAC80211_PROMISC_BCNS	(1 << 0)
 #define MAC80211_SCAN		(1 << 1)
 
-- 
1.7.4.1


