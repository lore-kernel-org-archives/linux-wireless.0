Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1388 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/31] staging: brcm80211: replaced typedef tx_power_t
 by struct brcms_tx_power
Date: Wed, 6 Jul 2011 00:02:41 +0200
Message-ID: <1309903378-29021-15-git-send-email-arend@broadcom.com> (sfid-20110706_000414_199327_B4429FDA)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>


Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    4 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.c         |    2 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |    1 -
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 43a1dc5..8850d6d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -2179,7 +2179,7 @@ static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi)
 }
 
 void
-wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi, tx_power_t *power,
+wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi, struct tx_power *power,
 			    uint channel)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
@@ -2187,7 +2187,7 @@ wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi, tx_power_t *power,
 	u8 min_pwr, max_pwr;
 
 #if WL_TX_POWER_RATES != TXP_NUM_RATES
-#error "tx_power_t struct out of sync with this fn"
+#error "struct tx_power out of sync with this fn"
 #endif
 
 	if (ISNPHY(pi)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index a2df6b4..e327a57 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -270,7 +270,7 @@ extern void wlc_phy_mute_upd(struct brcms_phy_pub *ppi, bool val, mbool flags);
 extern void wlc_phy_antsel_type_set(struct brcms_phy_pub *ppi, u8 antsel_type);
 
 extern void wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi,
-					tx_power_t *power, uint channel);
+					struct tx_power *power, uint channel);
 
 extern void wlc_phy_initcal_enable(struct brcms_phy_pub *pih, bool initcal);
 extern bool wlc_phy_test_ison(struct brcms_phy_pub *ppi);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index a4550ed..0a29b67 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -98,7 +98,7 @@
 /* sslpnphy specifics */
 #define WL_TX_POWER_MCS20_SISO_FIRST_SSN   12	/* Index for first 20MHz MCS SISO rate */
 
-/* tx_power_t.flags bits */
+/* struct tx_power::flags bits */
 #define WL_TX_POWER_F_ENABLED	1
 #define WL_TX_POWER_F_HW	2
 #define WL_TX_POWER_F_MIMO	4
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 3d5979b..b51ca7a 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -97,7 +97,7 @@ void
 brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
 			    chanspec_t chanspec)
 {
-	tx_power_t power;
+	struct tx_power power;
 	u8 siso_mcs_id, cdd_mcs_id, stbc_mcs_id;
 
 	/* Clear previous settings */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 9e9fe56..7ab4263 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -383,7 +383,6 @@ typedef volatile struct dma32diag dma32diag_t;
 typedef volatile struct dma64regs dma64regs_t;
 typedef struct brcms_rateset wlc_rateset_t;
 typedef u32 ratespec_t;
-typedef struct tx_power tx_power_t;
 typedef struct chanvec chanvec_t;
 typedef s32 fixed;
 typedef struct _cs32 cs32;
-- 
1.7.4.1


