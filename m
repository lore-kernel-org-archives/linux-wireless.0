Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45506 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2DJXC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 19:02:56 -0400
Received: by mail-ob0-f174.google.com with SMTP id tb18so402680obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 16:02:56 -0700 (PDT)
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH] brcm80211: replace open-coded ARRAY_SIZE with the macro
Date: Tue, 10 Apr 2012 17:02:34 -0600
Message-Id: <1334098954-7556-2-git-send-email-jim.cromie@gmail.com> (sfid-20120411_010300_809100_7E5A9722)
In-Reply-To: <1334098954-7556-1-git-send-email-jim.cromie@gmail.com>
References: <1334098954-7556-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |    3 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   41 +++++--------------
 2 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index ce8562a..0fce56235 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -207,8 +207,7 @@ static const iqcal_gain_params_lcnphy *tbl_iqcal_gainparams_lcnphy[1] = {
 };
 
 static const u16 iqcal_gainparams_numgains_lcnphy[1] = {
-	sizeof(tbl_iqcal_gainparams_lcnphy_2G) /
-	sizeof(*tbl_iqcal_gainparams_lcnphy_2G),
+	ARRAY_SIZE(tbl_iqcal_gainparams_lcnphy_2G),
 };
 
 static const struct lcnphy_sfo_cfg lcnphy_sfo_cfg[] = {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 3909574..812b6e3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -16353,11 +16353,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
 					       rfseq_rx2tx_events_rev3_ipa,
 					       rfseq_rx2tx_dlys_rev3_ipa,
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa) /
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa
-						[0]));
+					       ARRAY_SIZE(rfseq_rx2tx_events_rev3_ipa));
 
 		mod_phy_reg(pi, 0x299, (0x3 << 14), (0x1 << 14));
 		mod_phy_reg(pi, 0x29d, (0x3 << 14), (0x1 << 14));
@@ -16858,18 +16854,13 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX,
 				       rfseq_tx2rx_events_rev3,
 				       rfseq_tx2rx_dlys_rev3,
-				       sizeof(rfseq_tx2rx_events_rev3) /
-				       sizeof(rfseq_tx2rx_events_rev3[0]));
+				       ARRAY_SIZE(rfseq_tx2rx_events_rev3));
 
 		if (PHY_IPA(pi))
 			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
 					       rfseq_rx2tx_events_rev3_ipa,
 					       rfseq_rx2tx_dlys_rev3_ipa,
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa) /
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa
-						[0]));
+					       ARRAY_SIZE(rfseq_rx2tx_events_rev3_ipa));
 
 		if ((pi->sh->hw_phyrxchain != 0x3) &&
 		    (pi->sh->hw_phyrxchain != pi->sh->hw_phytxchain)) {
@@ -16885,8 +16876,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				pi, NPHY_RFSEQ_RX2TX,
 				rfseq_rx2tx_events_rev3,
 				rfseq_rx2tx_dlys_rev3,
-				sizeof(rfseq_rx2tx_events_rev3)	/
-				sizeof(rfseq_rx2tx_events_rev3[0]));
+				ARRAY_SIZE(rfseq_rx2tx_events_rev3));
 		}
 
 		if (CHSPEC_IS2G(pi->radio_chanspec))
@@ -17209,13 +17199,11 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 
 		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX, rfseq_rx2tx_events,
 				       rfseq_rx2tx_dlys,
-				       sizeof(rfseq_rx2tx_events) /
-				       sizeof(rfseq_rx2tx_events[0]));
+				       ARRAY_SIZE(rfseq_rx2tx_events));
 
 		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX, rfseq_tx2rx_events,
 				       rfseq_tx2rx_dlys,
-				       sizeof(rfseq_tx2rx_events) /
-				       sizeof(rfseq_tx2rx_events[0]));
+				       ARRAY_SIZE(rfseq_tx2rx_events));
 
 		wlc_phy_workarounds_nphy_gainctrl(pi);
 
@@ -19357,8 +19345,7 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 			}
 
 			if (isAdjustNoiseVar) {
-				numTonesAdjust = sizeof(nphy_adj_tone_id_buf) /
-						sizeof(nphy_adj_tone_id_buf[0]);
+				numTonesAdjust = ARRAY_SIZE(nphy_adj_tone_id_buf);
 
 				wlc_phy_adjust_min_noisevar_nphy(
 					pi,
@@ -25204,32 +25191,26 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 
 				phy_a15 = pad_gain_codes_used_2057rev5;
 				phy_a13 =
-					sizeof(pad_gain_codes_used_2057rev5) /
-					sizeof(pad_gain_codes_used_2057rev5
-						[0]) - 1;
+					ARRAY_SIZE(pad_gain_codes_used_2057rev5) - 1;
 
 			} else if ((pi->pubpi.radiorev == 7)
 				   || (pi->pubpi.radiorev == 8)) {
 
 				phy_a15 = pad_gain_codes_used_2057rev7;
 				phy_a13 =
-					sizeof(pad_gain_codes_used_2057rev7) /
-					sizeof(pad_gain_codes_used_2057rev7
-						[0]) - 1;
+					ARRAY_SIZE(pad_gain_codes_used_2057rev7) - 1;
 
 			} else {
 
 				phy_a15 = pad_all_gain_codes_2057;
-				phy_a13 = sizeof(pad_all_gain_codes_2057) /
-					  sizeof(pad_all_gain_codes_2057[0]) -
+				phy_a13 = ARRAY_SIZE(pad_all_gain_codes_2057) -
 					  1;
 			}
 
 		} else {
 
 			phy_a15 = pga_all_gain_codes_2057;
-			phy_a13 = sizeof(pga_all_gain_codes_2057) /
-				  sizeof(pga_all_gain_codes_2057[0]) - 1;
+			phy_a13 = ARRAY_SIZE(pga_all_gain_codes_2057) - 1;
 		}
 
 		phy_a14 = 0;
-- 
1.7.8.1

