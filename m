Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2487 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3HUJqE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 05:46:04 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Joe Perches" <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 12/12] brcmsmac: add support for BCM4313 iPA variant
Date: Wed, 21 Aug 2013 11:45:47 +0200
Message-ID: <1377078347-4170-1-git-send-email-arend@broadcom.com> (sfid-20130821_114612_262399_37C25F72)
In-Reply-To: <1377007246-9957-13-git-send-email-arend@broadcom.com>
References: <1377007246-9957-13-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch completes the changes needed for supporting the
iPA variant cards of the BCM4313 wireless chipset.

Tested-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Added 'static const' qualifier to address comment from Joe Perches.

This patch replaces the previous patch with
Message-ID: <1377007246-9957-13-git-send-email-arend@broadcom.com>

Regards,
Arend
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   73 ++++++++++++++------
 1 file changed, 53 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 8fb1048..b2d6d6d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1826,6 +1826,19 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 		write_radio_reg(pi, RADIO_2064_REG038, 3);
 		write_radio_reg(pi, RADIO_2064_REG091, 7);
 	}
+
+	if (!(pi->sh->boardflags & BFL_FEM)) {
+		static const u8 reg038[14] = {
+			0xd, 0xe, 0xd, 0xd, 0xd, 0xc, 0xa,
+			0xb, 0xb, 0x3, 0x3, 0x2, 0x0, 0x0
+		};
+
+		write_radio_reg(pi, RADIO_2064_REG02A, 0xf);
+		write_radio_reg(pi, RADIO_2064_REG091, 0x3);
+		write_radio_reg(pi, RADIO_2064_REG038, 0x3);
+
+		write_radio_reg(pi, RADIO_2064_REG038, reg038[channel - 1]);
+	}
 }
 
 static int
@@ -2123,7 +2136,16 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
 	u32 rfseq, ind;
+	enum lcnphy_tssi_mode mode;
+	u8 tssi_sel;
 
+	if (pi->sh->boardflags & BFL_FEM) {
+		tssi_sel = 0x1;
+		mode = LCNPHY_TSSI_EXT;
+	} else {
+		tssi_sel = 0xe;
+		mode = LCNPHY_TSSI_POST_PA;
+	}
 	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
 	tab.tbl_width = 32;
 	tab.tbl_ptr = &ind;
@@ -2144,7 +2166,7 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 
 	mod_phy_reg(pi, 0x503, (0x1 << 4), (1) << 4);
 
-	wlc_lcnphy_set_tssi_mux(pi, LCNPHY_TSSI_EXT);
+	wlc_lcnphy_set_tssi_mux(pi, mode);
 	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0) << 14);
 
 	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (1) << 15);
@@ -2180,9 +2202,10 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 	mod_phy_reg(pi, 0x49a, (0x1ff << 0), (0xff) << 0);
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		mod_radio_reg(pi, RADIO_2064_REG028, 0xf, 0xe);
+		mod_radio_reg(pi, RADIO_2064_REG028, 0xf, tssi_sel);
 		mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
 	} else {
+		mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, tssi_sel << 1);
 		mod_radio_reg(pi, RADIO_2064_REG03A, 0x1, 1);
 		mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 1 << 3);
 	}
@@ -4358,8 +4381,11 @@ wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
 	tab.tbl_len = 1;
 	tab.tbl_ptr = &val;
 
+	/* fixed gm_gain value for iPA */
+	gm_gain = 15;
 	for (j = 0; j < 128; j++) {
-		gm_gain = gain_table[j].gm;
+		if (pi->sh->boardflags & BFL_FEM)
+			gm_gain = gain_table[j].gm;
 		val = (((u32) pa_gain << 24) |
 		       (gain_table[j].pad << 16) |
 		       (gain_table[j].pga << 8) | gm_gain);
@@ -4570,7 +4596,10 @@ static void wlc_radio_2064_init(struct brcms_phy *pi)
 
 	write_phy_reg(pi, 0x4ea, 0x4688);
 
-	mod_phy_reg(pi, 0x4eb, (0x7 << 0), 2 << 0);
+	if (pi->sh->boardflags & BFL_FEM)
+		mod_phy_reg(pi, 0x4eb, (0x7 << 0), 2 << 0);
+	else
+		mod_phy_reg(pi, 0x4eb, (0x7 << 0), 3 << 0);
 
 	mod_phy_reg(pi, 0x4eb, (0x7 << 6), 0 << 6);
 
@@ -4581,6 +4610,13 @@ static void wlc_radio_2064_init(struct brcms_phy *pi)
 	wlc_lcnphy_rcal(pi);
 
 	wlc_lcnphy_rc_cal(pi);
+
+	if (!(pi->sh->boardflags & BFL_FEM)) {
+		write_radio_reg(pi, RADIO_2064_REG032, 0x6f);
+		write_radio_reg(pi, RADIO_2064_REG033, 0x19);
+		write_radio_reg(pi, RADIO_2064_REG039, 0xe);
+	}
+
 }
 
 static void wlc_lcnphy_radio_init(struct brcms_phy *pi)
@@ -4611,22 +4647,20 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 		wlc_lcnphy_write_table(pi, &tab);
 	}
 
-	tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
-	tab.tbl_width = 16;
-	tab.tbl_ptr = &val;
-	tab.tbl_len = 1;
-
-	val = 114;
-	tab.tbl_offset = 0;
-	wlc_lcnphy_write_table(pi, &tab);
+	if (!(pi->sh->boardflags & BFL_FEM)) {
+		tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
+		tab.tbl_width = 16;
+		tab.tbl_ptr = &val;
+		tab.tbl_len = 1;
 
-	val = 130;
-	tab.tbl_offset = 1;
-	wlc_lcnphy_write_table(pi, &tab);
+		val = 150;
+		tab.tbl_offset = 0;
+		wlc_lcnphy_write_table(pi, &tab);
 
-	val = 6;
-	tab.tbl_offset = 8;
-	wlc_lcnphy_write_table(pi, &tab);
+		val = 220;
+		tab.tbl_offset = 1;
+		wlc_lcnphy_write_table(pi, &tab);
+	}
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		if (pi->sh->boardflags & BFL_FEM)
@@ -5059,8 +5093,7 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 	if (!wlc_phy_txpwr_srom_read_lcnphy(pi))
 		return false;
 
-	if ((pi->sh->boardflags & BFL_FEM) &&
-	    (LCNREV_IS(pi->pubpi.phy_rev, 1))) {
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
 		if (pi_lcn->lcnphy_tempsense_option == 3) {
 			pi->hwpwrctrl = true;
 			pi->hwpwrctrl_capable = true;
-- 
1.7.10.4


