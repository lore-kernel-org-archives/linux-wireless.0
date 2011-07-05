Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1431 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/31] staging: brcm80211: remove checkpatch warnings
 'suspect code indent'
Date: Wed, 6 Jul 2011 00:02:43 +0200
Message-ID: <1309903378-29021-17-git-send-email-arend@broadcom.com> (sfid-20110706_000415_746581_55467A87)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver sources contained a couple of checkpatch warnings of the
given class. These have been cleaned up.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    3 +--
 drivers/staging/brcm80211/brcmsmac/bmac.c        |    4 ----
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    3 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |    5 +----
 4 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 17a6bf0..12c6ee3 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3605,8 +3605,7 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 
 	e->etype = event;
 	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
-	if (data) {
-	}
+
 	brcmf_lock_eq(cfg_priv);
 	list_add_tail(&e->eq_list, &cfg_priv->eq_list);
 	brcmf_unlock_eq(cfg_priv);
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 6f1203c..412611e 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -318,10 +318,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		brcms_c_update_beacon(wlc);
 	}
 
-	/* PMQ entry addition */
-	if (macintstatus & MI_PMQ) {
-	}
-
 	/* tx status */
 	if (macintstatus & MI_TFS) {
 		if (brcms_b_txstatus(wlc->hw, bounded, &fatal))
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 8850d6d..c4e9069 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -2249,8 +2249,7 @@ wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi, struct tx_power *power,
 
 		power->tx_power_max_rate_ind[0] = pi->tx_power_max_rate_ind;
 		power->tx_power_max_rate_ind[1] = pi->tx_power_max_rate_ind;
-	} else if (!pi->hwpwrctrl) {
-	} else if (pi->sh->up) {
+	} else if (pi->hwpwrctrl && pi->sh->up) {
 
 		wlc_phyreg_enter(ppi);
 		if (ISLCNPHY(pi)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index bc66c7f..151dc3c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -20996,10 +20996,8 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 		write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x01);
 
 		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		} else {
+		if (NREV_LT(pi->pubpi.phy_rev, 7))
 			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x05);
-		}
 
 		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
@@ -24578,7 +24576,6 @@ static void wlc_phy_calc_rx_iq_comp_nphy(struct brcms_phy *pi, u8 core_mask)
 		}
 
 		new_comp = old_comp;
-	} else if (cal_retry > 0) {
 	}
 
 	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &new_comp);
-- 
1.7.4.1


