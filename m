Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4088 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab2K1Uoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:38 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/11] brcmsmac: move PHY functions
Date: Wed, 28 Nov 2012 21:44:09 +0100
Message-ID: <1354135454-7035-7-git-send-email-arend@broadcom.com> (sfid-20121128_214447_984169_19468F8A)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Move functions in
preparation for 4313iPA changes

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  102 ++++++++++----------
 1 file changed, 52 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index abfd788..18d3764 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1860,41 +1860,6 @@ wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm, s16 filt_type)
 	return (filt_index != -1) ? 0 : -1;
 }
 
-void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
-{
-	u8 channel = CHSPEC_CHANNEL(chanspec);
-
-	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
-
-	wlc_lcnphy_set_chanspec_tweaks(pi, pi->radio_chanspec);
-
-	or_phy_reg(pi, 0x44a, 0x44);
-	write_phy_reg(pi, 0x44a, 0x80);
-
-	wlc_lcnphy_radio_2064_channel_tune_4313(pi, channel);
-	udelay(1000);
-
-	wlc_lcnphy_toggle_afe_pwdn(pi);
-
-	write_phy_reg(pi, 0x657, lcnphy_sfo_cfg[channel - 1].ptcentreTs20);
-	write_phy_reg(pi, 0x658, lcnphy_sfo_cfg[channel - 1].ptcentreFactor);
-
-	if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
-		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
-
-		wlc_lcnphy_load_tx_iir_filter(pi, false, 3);
-	} else {
-		mod_phy_reg(pi, 0x448, (0x3 << 8), (1) << 8);
-
-		wlc_lcnphy_load_tx_iir_filter(pi, false, 2);
-	}
-
-	wlc_lcnphy_load_tx_iir_filter(pi, true, 0);
-
-	mod_phy_reg(pi, 0x4eb, (0x7 << 3), (1) << 3);
-
-}
-
 static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi)
 {
 	u16 pa_gain;
@@ -1936,6 +1901,21 @@ static void wlc_lcnphy_set_tx_gain(struct brcms_phy *pi,
 	wlc_lcnphy_enable_tx_gain_override(pi);
 }
 
+static u8 wlc_lcnphy_get_bbmult(struct brcms_phy *pi)
+{
+	u16 m0m1;
+	struct phytbl_info tab;
+
+	tab.tbl_ptr = &m0m1;
+	tab.tbl_len = 1;
+	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
+	tab.tbl_offset = 87;
+	tab.tbl_width = 16;
+	wlc_lcnphy_read_table(pi, &tab);
+
+	return (u8) ((m0m1 & 0xff00) >> 8);
+}
+
 static void wlc_lcnphy_set_bbmult(struct brcms_phy *pi, u8 m0)
 {
 	u16 m0m1 = (u16) m0 << 8;
@@ -3075,21 +3055,6 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 		wlapi_enable_mac(pi->sh->physhim);
 }
 
-static u8 wlc_lcnphy_get_bbmult(struct brcms_phy *pi)
-{
-	u16 m0m1;
-	struct phytbl_info tab;
-
-	tab.tbl_ptr = &m0m1;
-	tab.tbl_len = 1;
-	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
-	tab.tbl_offset = 87;
-	tab.tbl_width = 16;
-	wlc_lcnphy_read_table(pi, &tab);
-
-	return (u8) ((m0m1 & 0xff00) >> 8);
-}
-
 static void wlc_lcnphy_set_pa_gain(struct brcms_phy *pi, u16 gain)
 {
 	mod_phy_reg(pi, 0x4fb,
@@ -4946,6 +4911,43 @@ void wlc_phy_txpower_recalc_target_lcnphy(struct brcms_phy *pi)
 	}
 }
 
+void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
+{
+	u8 channel = CHSPEC_CHANNEL(chanspec);
+
+	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *)pi, chanspec);
+
+	wlc_lcnphy_set_chanspec_tweaks(pi, pi->radio_chanspec);
+
+	or_phy_reg(pi, 0x44a, 0x44);
+	write_phy_reg(pi, 0x44a, 0x80);
+
+	wlc_lcnphy_radio_2064_channel_tune_4313(pi, channel);
+	udelay(1000);
+
+	wlc_lcnphy_toggle_afe_pwdn(pi);
+
+	write_phy_reg(pi, 0x657, lcnphy_sfo_cfg[channel - 1].ptcentreTs20);
+	write_phy_reg(pi, 0x658, lcnphy_sfo_cfg[channel - 1].ptcentreFactor);
+
+	if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
+		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
+
+		wlc_lcnphy_load_tx_iir_filter(pi, false, 3);
+	} else {
+		mod_phy_reg(pi, 0x448, (0x3 << 8), (1) << 8);
+
+		wlc_lcnphy_load_tx_iir_filter(pi, false, 2);
+	}
+
+	if (pi->sh->boardflags & BFL_FEM)
+		wlc_lcnphy_load_tx_iir_filter(pi, true, 0);
+	else
+		wlc_lcnphy_load_tx_iir_filter(pi, true, 3);
+
+	mod_phy_reg(pi, 0x4eb, (0x7 << 3), (1) << 3);
+}
+
 void wlc_phy_detach_lcnphy(struct brcms_phy *pi)
 {
 	kfree(pi->u.pi_lcnphy);
-- 
1.7.10.4


