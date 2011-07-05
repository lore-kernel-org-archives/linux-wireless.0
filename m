Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1476 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 28/31] staging: brcm80211: remove external definitions
 from phy_lcn.c
Date: Wed, 6 Jul 2011 00:02:55 +0200
Message-ID: <1309903378-29021-29-git-send-email-arend@broadcom.com> (sfid-20110706_000355_347306_3B0D43D2)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The source file phy_lcn.c had several external definitions flagged
by checkpatch.pl script. The patch fixes those.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |   10 ++--------
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.h    |    2 ++
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 8e98d8f..41ac681 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -535,12 +535,6 @@ static const s8 lcnphy_gain_index_offset_for_rssi[] = {
 	-2
 };
 
-extern const u8 spur_tbl_rev0[];
-extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev1;
-extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev1[];
-extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
-extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250;
-
 struct chan_info_2064_lcnphy {
 	uint chan;
 	uint freq;
@@ -991,7 +985,7 @@ static bool wlc_lcnphy_rx_iq_est(struct brcms_phy *pi, u16 num_samps,
 static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps);
 static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi);
 static void wlc_lcnphy_afe_clk_init(struct brcms_phy *pi, u8 mode);
-extern void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi);
+static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi);
 static void wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi,
 						    u8 channel);
 
@@ -2275,7 +2269,7 @@ static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 	udelay(999);
 }
 
-void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (struct brcms_phy_pub *ppi)
+static void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (struct brcms_phy_pub *ppi)
 {
 	struct lcnphy_txgains tx_gains;
 	u8 bbmult;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
index 644389f..5f75e16 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
@@ -22,6 +22,8 @@ extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev0;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa_combo;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250;
 
 extern const struct phytbl_info dot11lcnphytbl_info_rev0[];
 extern const u32 dot11lcnphytbl_info_sz_rev0;
-- 
1.7.4.1


