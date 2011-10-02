Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1730 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1JBRO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:14:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/20] staging: brcm80211: cleaning up tx rate control
 code in softmac
Date: Sun, 2 Oct 2011 10:14:28 -0700
Message-ID: <1317575685-3156-4-git-send-email-frankyl@broadcom.com> (sfid-20111002_191506_502175_14D5BE01)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Code was unnecessarily complex.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e6bd3cf..10f1de2 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -7066,7 +7066,6 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	struct ieee80211_rts *rts = NULL;
 	bool qos;
 	uint ac;
-	u32 rate_val[2];
 	bool hwtkmic = false;
 	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
 #define ANTCFG_NONE 0xFF
@@ -7077,7 +7076,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	struct ieee80211_tx_rate *txrate[2];
 	int k;
 	struct ieee80211_tx_info *tx_info;
-	bool is_mcs[2];
+	bool is_mcs;
 	u16 mimo_txbw;
 	u8 mimo_preamble_type;
 
@@ -7137,13 +7136,12 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		txrate[1] = txrate[0];
 
 	for (k = 0; k < hw->max_rates; k++) {
-		is_mcs[k] =
-		    txrate[k]->flags & IEEE80211_TX_RC_MCS ? true : false;
-		if (!is_mcs[k]) {
+		is_mcs = txrate[k]->flags & IEEE80211_TX_RC_MCS ? true : false;
+		if (!is_mcs) {
 			if ((txrate[k]->idx >= 0)
 			    && (txrate[k]->idx <
 				hw->wiphy->bands[tx_info->band]->n_bitrates)) {
-				rate_val[k] =
+				rspec[k] =
 				    hw->wiphy->bands[tx_info->band]->
 				    bitrates[txrate[k]->idx].hw_value;
 				short_preamble[k] =
@@ -7151,10 +7149,11 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				    flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ?
 				    true : false;
 			} else {
-				rate_val[k] = BRCM_RATE_1M;
+				rspec[k] = BRCM_RATE_1M;
 			}
 		} else {
-			rate_val[k] = txrate[k]->idx;
+			rspec[k] = mac80211_wlc_set_nrate(wlc, wlc->band,
+					NRATE_MCS_INUSE | txrate[k]->idx);
 		}
 
 		/*
@@ -7169,10 +7168,6 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		    txrate[k]->
 		    flags & IEEE80211_TX_RC_USE_CTS_PROTECT ? true : false;
 
-		if (is_mcs[k])
-			rate_val[k] |= NRATE_MCS_INUSE;
-
-		rspec[k] = mac80211_wlc_set_nrate(wlc, wlc->band, rate_val[k]);
 
 		/*
 		 * (1) RATE:
-- 
1.7.1


