Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2012 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab1I2We6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 24/25] staging: brcm80211: simple changes to softmac
 phy variables
Date: Thu, 29 Sep 2011 15:34:35 -0700
Message-ID: <1317335676-3424-25-git-send-email-frankyl@broadcom.com> (sfid-20110930_003523_271341_DE8233F9)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup resulting in less sparse warnings.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   14 -------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |   23 ----------------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    2 +-
 3 files changed, 1 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index f9702c0..f31ebe2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -111,20 +111,6 @@ static struct chan_info_basic chan_info_all[] = {
 	{216, 50800}
 };
 
-u16 ltrn_list[PHY_LTRN_LIST_LEN] = {
-	0x18f9, 0x0d01, 0x00e4, 0xdef4, 0x06f1, 0x0ffc,
-	0xfa27, 0x1dff, 0x10f0, 0x0918, 0xf20a, 0xe010,
-	0x1417, 0x1104, 0xf114, 0xf2fa, 0xf7db, 0xe2fc,
-	0xe1fb, 0x13ee, 0xff0d, 0xe91c, 0x171a, 0x0318,
-	0xda00, 0x03e8, 0x17e6, 0xe9e4, 0xfff3, 0x1312,
-	0xe105, 0xe204, 0xf725, 0xf206, 0xf1ec, 0x11fc,
-	0x14e9, 0xe0f0, 0xf2f6, 0x09e8, 0x1010, 0x1d01,
-	0xfad9, 0x0f04, 0x060f, 0xde0c, 0x001c, 0x0dff,
-	0x1807, 0xf61a, 0xe40e, 0x0f16, 0x05f9, 0x18ec,
-	0x0a1b, 0xff1e, 0x2600, 0xffe2, 0x0ae5, 0x1814,
-	0x0507, 0x0fea, 0xe4f2, 0xf6e6
-};
-
 const u8 ofdm_rate_lookup[] = {
 
 	BRCM_RATE_48M,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 8ce0159..1611521 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -247,9 +247,6 @@ enum phy_cal_mode {
 #define PUB_NOT_ASSOC(pi) \
 	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_NOT_ASSOC))
 
-#define PHY_LTRN_LIST_LEN	64
-extern u16 ltrn_list[PHY_LTRN_LIST_LEN];
-
 struct phy_table_info {
 	uint table;
 	int q;
@@ -922,26 +919,6 @@ struct lcnphy_radio_regs {
 	u8 do_init_g;
 };
 
-extern struct lcnphy_radio_regs lcnphy_radio_regs_2064[];
-extern struct lcnphy_radio_regs lcnphy_radio_regs_2066[];
-
-extern struct radio_regs regs_2055[], regs_SYN_2056[], regs_TX_2056[],
-			 regs_RX_2056[];
-extern struct radio_regs regs_SYN_2056_A1[], regs_TX_2056_A1[],
-			 regs_RX_2056_A1[];
-extern struct radio_regs regs_SYN_2056_rev5[], regs_TX_2056_rev5[],
-			 regs_RX_2056_rev5[];
-extern struct radio_regs regs_SYN_2056_rev6[], regs_TX_2056_rev6[],
-			 regs_RX_2056_rev6[];
-extern struct radio_regs regs_SYN_2056_rev7[], regs_TX_2056_rev7[],
-			 regs_RX_2056_rev7[];
-extern struct radio_regs regs_SYN_2056_rev8[], regs_TX_2056_rev8[],
-			 regs_RX_2056_rev8[];
-
-extern struct radio_20xx_regs regs_2057_rev4[], regs_2057_rev5[],
-			      regs_2057_rev5v1[];
-extern struct radio_20xx_regs regs_2057_rev7[], regs_2057_rev8[];
-
 extern char *phy_getvar(struct brcms_phy *pi, const char *name);
 extern int phy_getintvar(struct brcms_phy *pi, const char *name);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index fdcea56..bada928 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -575,7 +575,7 @@ static struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
 	{14, 2484, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 };
 
-struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
+static struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
 	{0x00, 0, 0, 0, 0},
 	{0x01, 0x64, 0x64, 0, 0},
 	{0x02, 0x20, 0x20, 0, 0},
-- 
1.7.1


