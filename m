Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3964 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/15] brcm80211: smac: remove redundant assignments
 from txpwrctrl_pwr_setup_nphy
Date: Thu, 9 Feb 2012 21:08:57 +0100
Message-ID: <1328818149-4826-4-git-send-email-arend@broadcom.com> (sfid-20120209_210933_143953_D943DFD5)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function wlc_phy_txpwrctrl_pwr_setup_nphy() does assign a local
variable target_pwr_qtrdbm in several code paths, but in the end all
code paths are coming to an assignment of that variable which does
override all previous. So those early and redundant assignments have
been removed.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   21 +-------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index c27ec7a..9595ecd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -17824,8 +17824,6 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 	if (pi->sh->sromrev < 4) {
 		idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
 		idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
-		target_pwr_qtrdbm[0] = 13 * 4;
-		target_pwr_qtrdbm[1] = 13 * 4;
 		a1[0] = -424;
 		a1[1] = -424;
 		b0[0] = 5612;
@@ -17839,10 +17837,6 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 		case WL_CHAN_FREQ_RANGE_2G:
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_2g;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_2g;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_b0;
@@ -17853,10 +17847,6 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 		case WL_CHAN_FREQ_RANGE_5GL:
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_5gl;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_5gl;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0;
@@ -17867,10 +17857,6 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 		case WL_CHAN_FREQ_RANGE_5GM:
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_5gm;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_5gm;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_b0;
@@ -17881,10 +17867,6 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 		case WL_CHAN_FREQ_RANGE_5GH:
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_5gh;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_5gh;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0;
@@ -17895,8 +17877,6 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 		default:
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
-			target_pwr_qtrdbm[0] = 13 * 4;
-			target_pwr_qtrdbm[1] = 13 * 4;
 			a1[0] = -424;
 			a1[1] = -424;
 			b0[0] = 5612;
@@ -17907,6 +17887,7 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 		}
 	}
 
+	/* use the provided transmit power */
 	target_pwr_qtrdbm[0] = (s8) pi->tx_power_max;
 	target_pwr_qtrdbm[1] = (s8) pi->tx_power_max;
 
-- 
1.7.5.4


