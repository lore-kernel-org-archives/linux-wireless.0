Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1708 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007Ab3HMUEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 10/13] brcmsmac: rework switch control table init
 including iPA BT-combo
Date: Tue, 13 Aug 2013 22:03:37 +0200
Message-ID: <1376424220-10765-11-git-send-email-arend@broadcom.com> (sfid-20130813_220909_057284_66B8D7B6)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the code path in lcnphy tbl_init() for switch control
table programming. This also takes the iPA BT-combo card into
account.

Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   31 ++++++++++----------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index e02729d..732371c 100644
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
-- 
1.7.10.4


