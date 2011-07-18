Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4202 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab1GROaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/19] staging: brcm80211: resolved checkpatch warnings
 in LCN phy
Date: Mon, 18 Jul 2011 16:29:48 +0200
Message-ID: <1310999405-10062-3-git-send-email-arend@broadcom.com> (sfid-20110718_163032_631101_C6BC6B06)
In-Reply-To: <1310999405-10062-1-git-send-email-arend@broadcom.com>
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Refactored code to not exceed the 80 char limit.

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   46 ++++++++--------------
 1 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index a109866..3d140eb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4342,39 +4342,25 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 	}
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
+		const struct phytbl_info *tb;
+		int l;
+
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			for (idx = 0;
-			     idx < dot11lcnphytbl_rx_gain_info_2G_rev2_sz;
-			     idx++)
-				if (pi->sh->boardflags & BFL_EXTLNA)
-					wlc_lcnphy_write_table(
-						pi,
-						&
-						dot11lcnphytbl_rx_gain_info_extlna_2G_rev2
-						[idx]);
-				else
-					wlc_lcnphy_write_table(
-						pi,
-						&
-						dot11lcnphytbl_rx_gain_info_2G_rev2
-						[idx]);
+			l = dot11lcnphytbl_rx_gain_info_2G_rev2_sz;
+			if (pi->sh->boardflags & BFL_EXTLNA)
+				tb = dot11lcnphytbl_rx_gain_info_extlna_2G_rev2;
+			else
+				tb = dot11lcnphytbl_rx_gain_info_2G_rev2;
 		} else {
-			for (idx = 0;
-			     idx < dot11lcnphytbl_rx_gain_info_5G_rev2_sz;
-			     idx++)
-				if (pi->sh->boardflags & BFL_EXTLNA_5GHz)
-					wlc_lcnphy_write_table(
-						pi,
-						&
-						dot11lcnphytbl_rx_gain_info_extlna_5G_rev2
-						[idx]);
-				else
-					wlc_lcnphy_write_table(
-						pi,
-						&
-						dot11lcnphytbl_rx_gain_info_5G_rev2
-						[idx]);
+			l = dot11lcnphytbl_rx_gain_info_5G_rev2_sz;
+			if (pi->sh->boardflags & BFL_EXTLNA_5GHz)
+				tb = dot11lcnphytbl_rx_gain_info_extlna_5G_rev2;
+			else
+				tb = dot11lcnphytbl_rx_gain_info_5G_rev2;
 		}
+
+		for (idx = 0; idx < l; idx++)
+			wlc_lcnphy_write_table(pi, &tb[idx]);
 	}
 
 	if ((pi->sh->boardflags & BFL_FEM)
-- 
1.7.4.1


