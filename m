Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2286 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/15] brcm80211: smac: remove obsolete srom variables
 from n-phy
Date: Tue, 18 Oct 2011 14:03:05 +0200
Message-ID: <1318939391-19495-10-git-send-email-arend@broadcom.com> (sfid-20111018_140345_705728_46FCE367)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The n-phy requested some srom variables that are no longer needed
and consequently not present in the srom revision 8 and higher that
this driver support. This code has been removed from the n-phy.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    5 ---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   37 +------------------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   32 -----------------
 3 files changed, 2 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
index bea8524..5f9478b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
@@ -774,11 +774,6 @@ struct brcms_phy {
 	s16 nphy_noise_win[PHY_CORE_MAX][PHY_NOISE_WINDOW_SZ];
 	u8 nphy_noise_index;
 
-	u8 nphy_txpid2g[PHY_CORE_NUM_2];
-	u8 nphy_txpid5g[PHY_CORE_NUM_2];
-	u8 nphy_txpid5gl[PHY_CORE_NUM_2];
-	u8 nphy_txpid5gh[PHY_CORE_NUM_2];
-
 	bool nphy_gain_boost;
 	bool nphy_elna_gain_config;
 	u16 old_bphy_test;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index db612f8..ec9b566 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -14418,12 +14418,6 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 		switch (band_num) {
 		case 0:
 
-			pi->nphy_txpid2g[PHY_CORE_0] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID2GA0);
-			pi->nphy_txpid2g[PHY_CORE_1] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID2GA1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
 				(s8) wlapi_getintvar(shim,
 						     BRCMS_SROM_MAXP2GA0);
@@ -14487,12 +14481,6 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 			break;
 		case 1:
 
-			pi->nphy_txpid5g[PHY_CORE_0] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID5GA0);
-			pi->nphy_txpid5g[PHY_CORE_1] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID5GA1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
 				(s8) wlapi_getintvar(shim, BRCMS_SROM_MAXP5GA0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
@@ -14552,12 +14540,6 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 			break;
 		case 2:
 
-			pi->nphy_txpid5gl[0] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID5GLA0);
-			pi->nphy_txpid5gl[1] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID5GLA1);
 			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
 				(s8) wlapi_getintvar(shim,
 						     BRCMS_SROM_MAXP5GLA0);
@@ -14616,12 +14598,6 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 			break;
 		case 3:
 
-			pi->nphy_txpid5gh[0] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID5GHA0);
-			pi->nphy_txpid5gh[1] =
-				(u8) wlapi_getintvar(shim,
-						     BRCMS_SROM_TXPID5GHA1);
 			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
 				(s8) wlapi_getintvar(shim,
 						     BRCMS_SROM_MAXP5GHA0);
@@ -27995,20 +27971,11 @@ void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
 		switch (chan_freq_range) {
 		case WL_CHAN_FREQ_RANGE_2G:
-			txpi[0] = pi->nphy_txpid2g[0];
-			txpi[1] = pi->nphy_txpid2g[1];
-			break;
 		case WL_CHAN_FREQ_RANGE_5GL:
-			txpi[0] = pi->nphy_txpid5gl[0];
-			txpi[1] = pi->nphy_txpid5gl[1];
-			break;
 		case WL_CHAN_FREQ_RANGE_5GM:
-			txpi[0] = pi->nphy_txpid5g[0];
-			txpi[1] = pi->nphy_txpid5g[1];
-			break;
 		case WL_CHAN_FREQ_RANGE_5GH:
-			txpi[0] = pi->nphy_txpid5gh[0];
-			txpi[1] = pi->nphy_txpid5gh[1];
+			txpi[0] = 0;
+			txpi[1] = 0;
 			break;
 		default:
 			txpi[0] = txpi[1] = 91;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 37bb2dc..d20116a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -170,22 +170,6 @@ enum brcms_srom_id {
 	BRCMS_SROM_TSSIPOS2G,
 	BRCMS_SROM_TSSIPOS5G,
 	BRCMS_SROM_TXCHAIN,
-	BRCMS_SROM_TXPID2GA0,
-	BRCMS_SROM_TXPID2GA1,
-	BRCMS_SROM_TXPID2GA2,
-	BRCMS_SROM_TXPID2GA3,
-	BRCMS_SROM_TXPID5GA0,
-	BRCMS_SROM_TXPID5GA1,
-	BRCMS_SROM_TXPID5GA2,
-	BRCMS_SROM_TXPID5GA3,
-	BRCMS_SROM_TXPID5GHA0,
-	BRCMS_SROM_TXPID5GHA1,
-	BRCMS_SROM_TXPID5GHA2,
-	BRCMS_SROM_TXPID5GHA3,
-	BRCMS_SROM_TXPID5GLA0,
-	BRCMS_SROM_TXPID5GLA1,
-	BRCMS_SROM_TXPID5GLA2,
-	BRCMS_SROM_TXPID5GLA3,
 	/*
 	 * per-path identifiers (see srom.c)
 	 */
@@ -225,10 +209,6 @@ enum brcms_srom_id {
 	BRCMS_SROM_PA2GW2A1,
 	BRCMS_SROM_PA2GW2A2,
 	BRCMS_SROM_PA2GW2A3,
-	BRCMS_SROM_PA2GW3A0,
-	BRCMS_SROM_PA2GW3A1,
-	BRCMS_SROM_PA2GW3A2,
-	BRCMS_SROM_PA2GW3A3,
 	BRCMS_SROM_PA5GHW0A0,
 	BRCMS_SROM_PA5GHW0A1,
 	BRCMS_SROM_PA5GHW0A2,
@@ -241,10 +221,6 @@ enum brcms_srom_id {
 	BRCMS_SROM_PA5GHW2A1,
 	BRCMS_SROM_PA5GHW2A2,
 	BRCMS_SROM_PA5GHW2A3,
-	BRCMS_SROM_PA5GHW3A0,
-	BRCMS_SROM_PA5GHW3A1,
-	BRCMS_SROM_PA5GHW3A2,
-	BRCMS_SROM_PA5GHW3A3,
 	BRCMS_SROM_PA5GLW0A0,
 	BRCMS_SROM_PA5GLW0A1,
 	BRCMS_SROM_PA5GLW0A2,
@@ -257,10 +233,6 @@ enum brcms_srom_id {
 	BRCMS_SROM_PA5GLW2A1,
 	BRCMS_SROM_PA5GLW2A2,
 	BRCMS_SROM_PA5GLW2A3,
-	BRCMS_SROM_PA5GLW3A0,
-	BRCMS_SROM_PA5GLW3A1,
-	BRCMS_SROM_PA5GLW3A2,
-	BRCMS_SROM_PA5GLW3A3,
 	BRCMS_SROM_PA5GW0A0,
 	BRCMS_SROM_PA5GW0A1,
 	BRCMS_SROM_PA5GW0A2,
@@ -273,10 +245,6 @@ enum brcms_srom_id {
 	BRCMS_SROM_PA5GW2A1,
 	BRCMS_SROM_PA5GW2A2,
 	BRCMS_SROM_PA5GW2A3,
-	BRCMS_SROM_PA5GW3A0,
-	BRCMS_SROM_PA5GW3A1,
-	BRCMS_SROM_PA5GW3A2,
-	BRCMS_SROM_PA5GW3A3,
 };
 
 #define	BRCMS_NUMRATES	16	/* max # of rates in a rateset */
-- 
1.7.4.1


