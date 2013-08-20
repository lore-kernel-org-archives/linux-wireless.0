Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1379 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab3HTOBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 10:01:00 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/12] brcmsmac: rework switch control table init
 including iPA BT-combo
Date: Tue, 20 Aug 2013 16:00:43 +0200
Message-ID: <1377007246-9957-10-git-send-email-arend@broadcom.com> (sfid-20130820_160148_296633_A71BB773)
In-Reply-To: <1377007246-9957-1-git-send-email-arend@broadcom.com>
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the code path in lcnphy tbl_init() for switch control
table programming. This also takes the iPA BT-combo card into
account.

Tested-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   31 +++++----
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |   72 ++++++++++++++++++++
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |    1 +
 3 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index caced82..08bcae4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4573,6 +4573,7 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 	uint idx;
 	u8 phybw40;
 	struct phytbl_info tab;
+	const struct phytbl_info *tb;
 	u32 val;
 
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
@@ -4619,7 +4620,6 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 	}
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		const struct phytbl_info *tb;
 		int l;
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
@@ -4640,21 +4640,22 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 			wlc_lcnphy_write_table(pi, &tb[idx]);
 	}
 
-	if ((pi->sh->boardflags & BFL_FEM)
-	    && !(pi->sh->boardflags & BFL_FEM_BT))
-		wlc_lcnphy_write_table(pi, &dot11lcn_sw_ctrl_tbl_info_4313_epa);
-	else if (pi->sh->boardflags & BFL_FEM_BT) {
-		if (pi->sh->boardrev < 0x1250)
-			wlc_lcnphy_write_table(
-				pi,
-				&dot11lcn_sw_ctrl_tbl_info_4313_bt_epa);
+	if (pi->sh->boardflags & BFL_FEM) {
+		if (pi->sh->boardflags & BFL_FEM_BT) {
+			if (pi->sh->boardrev < 0x1250)
+				tb = &dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
+			else
+				tb = &dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250;
+		} else {
+			tb = &dot11lcn_sw_ctrl_tbl_info_4313_epa;
+		}
+	} else {
+		if (pi->sh->boardflags & BFL_FEM_BT)
+			tb = &dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa;
 		else
-			wlc_lcnphy_write_table(
-				pi,
-				&dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250);
-	} else
-		wlc_lcnphy_write_table(pi, &dot11lcn_sw_ctrl_tbl_info_4313);
-
+			tb = &dot11lcn_sw_ctrl_tbl_info_4313;
+	}
+	wlc_lcnphy_write_table(pi, tb);
 	wlc_lcnphy_load_rfpower(pi);
 
 	wlc_lcnphy_clear_papd_comptable(pi);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
index efd5a58..d7fa312 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -2044,6 +2044,73 @@ static const u16 dot11lcn_sw_ctrl_tbl_4313_rev0[] = {
 	0x0005,
 };
 
+static const u16 dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo[] = {
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+};
+
 static const u16 dot11lcn_sw_ctrl_tbl_rev0[] = {
 	0x0004,
 	0x0004,
@@ -2808,6 +2875,11 @@ const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313 = {
 	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_rev0), 15, 0, 16
 };
 
+const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa = {
+	&dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo,
+	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo), 15, 0, 16
+};
+
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0,
 	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_epa_rev0), 15, 0, 16
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
index 5f75e16..489422a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
@@ -20,6 +20,7 @@
 extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[];
 extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev0;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa_combo;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
-- 
1.7.10.4


