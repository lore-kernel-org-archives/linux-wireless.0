Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4059 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab1IMHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/17] staging: brcm80211: removed function
 brcms_c_wme_initparams_sta()
Date: Tue, 13 Sep 2011 09:49:47 +0200
Message-ID: <1315900197-7260-8-git-send-email-rvossen@broadcom.com> (sfid-20110913_095028_675047_57F3DB0D)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

since its variable assignment can be done in a more straightforward
manner.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   57 +++++++++--------------------
 drivers/staging/brcm80211/brcmsmac/main.h |   19 ----------
 2 files changed, 17 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 9921af2..7067a02 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -431,6 +431,12 @@ struct brcms_b_state {
 	u32 preamble_ovr;	/* preamble override */
 };
 
+struct edcf_acparam {
+	u8 ACI;
+	u8 ECW;
+	u16 TXOP;
+} __packed;
+
 const u8 prio2fifo[NUMPRIO] = {
 	TX_AC_BE_FIFO,		/* 0    BE      AC_BE   Best Effort */
 	TX_AC_BK_FIFO,		/* 1    BK      AC_BK   Background */
@@ -4124,34 +4130,6 @@ static void brcms_c_ht_update_ldpc(struct brcms_c_info *wlc, s8 val)
 	}
 }
 
-/*
- * Initialize a WME Parameter Info Element with default
- * STA parameters from WMM Spec, Table 12
- */
-void
-brcms_c_wme_initparams_sta(struct brcms_c_info *wlc, struct wme_param_ie *pe)
-{
-	static const struct wme_param_ie stadef = {
-		WME_OUI,
-		WME_TYPE,
-		WME_SUBTYPE_PARAM_IE,
-		WME_VER,
-		0,
-		0,
-		{
-		 {EDCF_AC_BE_ACI_STA, EDCF_AC_BE_ECW_STA,
-		  cpu_to_le16(EDCF_AC_BE_TXOP_STA)},
-		 {EDCF_AC_BK_ACI_STA, EDCF_AC_BK_ECW_STA,
-		  cpu_to_le16(EDCF_AC_BK_TXOP_STA)},
-		 {EDCF_AC_VI_ACI_STA, EDCF_AC_VI_ECW_STA,
-		  cpu_to_le16(EDCF_AC_VI_TXOP_STA)},
-		 {EDCF_AC_VO_ACI_STA, EDCF_AC_VO_ECW_STA,
-		  cpu_to_le16(EDCF_AC_VO_TXOP_STA)}
-		 }
-	};
-	memcpy(pe, &stadef, sizeof(*pe));
-}
-
 void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		       const struct ieee80211_tx_queue_params *params,
 		       bool suspend)
@@ -4222,18 +4200,19 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 {
 	u16 aci;
 	int i_ac;
-	struct edcf_acparam *edcf_acp;
-
 	struct ieee80211_tx_queue_params txq_pars;
 	struct ieee80211_tx_queue_params *params = &txq_pars;
-
-	/*
-	 * AP uses AC params from wme_param_ie_ap.
-	 * AP advertises AC params from wme_param_ie.
-	 * STA uses AC params from wme_param_ie.
-	 */
-
-	edcf_acp = (struct edcf_acparam *) &wlc->wme_param_ie.acparam[0];
+	static struct edcf_acparam default_edcf_acparams[] = {
+		 {EDCF_AC_BE_ACI_STA, EDCF_AC_BE_ECW_STA,
+		  cpu_to_le16(EDCF_AC_BE_TXOP_STA)},
+		 {EDCF_AC_BK_ACI_STA, EDCF_AC_BK_ECW_STA,
+		  cpu_to_le16(EDCF_AC_BK_TXOP_STA)},
+		 {EDCF_AC_VI_ACI_STA, EDCF_AC_VI_ECW_STA,
+		  cpu_to_le16(EDCF_AC_VI_TXOP_STA)},
+		 {EDCF_AC_VO_ACI_STA, EDCF_AC_VO_ECW_STA,
+		  cpu_to_le16(EDCF_AC_VO_TXOP_STA)}
+	}; /* ucode needs these parameters during its initialization */
+	struct edcf_acparam *edcf_acp = &default_edcf_acparams[0];
 
 	for (i_ac = 0; i_ac < AC_COUNT; i_ac++, edcf_acp++) {
 		/* find out which ac this set of params applies to */
@@ -5294,8 +5273,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->cfg->_idx = 0;
 	wlc->cfg->wlc = wlc;
 
-	brcms_c_wme_initparams_sta(wlc, &wlc->wme_param_ie);
-
 	wlc->mimoft = FT_HT;
 	wlc->ht_cap.cap_info = HT_CAP;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 0462250..aa0bf03 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -298,22 +298,6 @@ struct modulecb {
 
 };
 
-struct edcf_acparam {
-	u8 ACI;
-	u8 ECW;
-	u16 TXOP;
-} __packed;
-
-struct wme_param_ie {
-	u8 oui[3];
-	u8 type;
-	u8 subtype;
-	u8 version;
-	u8 qosinfo;
-	u8 rsvd;
-	struct edcf_acparam acparam[AC_COUNT];
-} __packed;
-
 struct brcms_hw_band {
 	int bandtype;		/* BRCM_BAND_2G, BRCM_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
@@ -463,8 +447,6 @@ struct brcms_txq_info {
  * WDarmed: watchdog timer is armed.
  * WDlast: last time wlc_watchdog() was called.
  * edcf_txop[AC_COUNT]: current txop for each ac.
- * wme_param_ie: on STA contains parameters in use locally, and on AP
- *		 contains parameters advertised
  * wme_retries: per-AC retry limits.
  * tx_prec_map: Precedence map based on HW FIFO space.
  * fifo2prec_map[NFIFO]: pointer to fifo2_prec map based on WME.
@@ -578,7 +560,6 @@ struct brcms_c_info {
 	/* WME */
 	u16 edcf_txop[AC_COUNT];
 
-	struct wme_param_ie wme_param_ie;
 	u16 wme_retries[AC_COUNT];
 	u16 tx_prec_map;
 	u16 fifo2prec_map[NFIFO];
-- 
1.7.4.1


