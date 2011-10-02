Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1697 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/20] staging: brcm80211: reduced softmac sparse
 warnings
Date: Sun, 2 Oct 2011 10:14:30 -0700
Message-ID: <1317575685-3156-6-git-send-email-frankyl@broadcom.com> (sfid-20111002_191519_758369_F00F8530)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

By declaring certain variables static. One unused array induced a warning,
array was deleted.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/channel.c       |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   48 ++++++++++----------
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    4 --
 4 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index a9defe2..02bb795 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -197,7 +197,7 @@ static const struct brcms_chanvec chanvec_none = {
 };
 
 /* All 2.4 GHz HW channels */
-const struct brcms_chanvec chanvec_all_2G = {
+static const struct brcms_chanvec chanvec_all_2G = {
 	{0xfe, 0x7f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -205,7 +205,7 @@ const struct brcms_chanvec chanvec_all_2G = {
 };
 
 /* All 5 GHz HW channels */
-const struct brcms_chanvec chanvec_all_5G = {
+static const struct brcms_chanvec chanvec_all_5G = {
 	{0x00, 0x00, 0x00, 0x00, 0x54, 0x55, 0x11, 0x11,
 	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,
 	 0x11, 0x11, 0x20, 0x22, 0x22, 0x00, 0x00, 0x11,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index f8bc42f..ac5a52a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -423,7 +423,7 @@ uint brcm_msg_level =
 #endif				/* BCMDBG */
 
 /* TX FIFO number to WME/802.1E Access Category */
-const u8 wme_fifo2ac[] = { AC_BK, AC_BE, AC_VI, AC_VO, AC_BE, AC_BE };
+static const u8 wme_fifo2ac[] = { AC_BK, AC_BE, AC_VI, AC_VO, AC_BE, AC_BE };
 
 /* WME/802.1E Access Category to TX FIFO number */
 static const u8 wme_ac2fifo[] = { 1, 0, 2, 3 };
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 93ac12f..4023af1 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -7762,7 +7762,7 @@ static const struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev8[] = {
 	 0x0424}
 };
 
-struct radio_regs regs_2055[] = {
+static struct radio_regs regs_2055[] = {
 	{0x02, 0x80, 0x80, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0x27, 0x27, 0, 0},
@@ -7991,7 +7991,7 @@ struct radio_regs regs_2055[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_SYN_2056[] = {
+static struct radio_regs regs_SYN_2056[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8176,7 +8176,7 @@ struct radio_regs regs_SYN_2056[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_TX_2056[] = {
+static struct radio_regs regs_TX_2056[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8325,7 +8325,7 @@ struct radio_regs regs_TX_2056[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_RX_2056[] = {
+static struct radio_regs regs_RX_2056[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8476,7 +8476,7 @@ struct radio_regs regs_RX_2056[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_SYN_2056_A1[] = {
+static struct radio_regs regs_SYN_2056_A1[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8661,7 +8661,7 @@ struct radio_regs regs_SYN_2056_A1[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_TX_2056_A1[] = {
+static struct radio_regs regs_TX_2056_A1[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8810,7 +8810,7 @@ struct radio_regs regs_TX_2056_A1[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_RX_2056_A1[] = {
+static struct radio_regs regs_RX_2056_A1[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8961,7 +8961,7 @@ struct radio_regs regs_RX_2056_A1[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_SYN_2056_rev5[] = {
+static struct radio_regs regs_SYN_2056_rev5[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9146,7 +9146,7 @@ struct radio_regs regs_SYN_2056_rev5[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_TX_2056_rev5[] = {
+static struct radio_regs regs_TX_2056_rev5[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9303,7 +9303,7 @@ struct radio_regs regs_TX_2056_rev5[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_RX_2056_rev5[] = {
+static struct radio_regs regs_RX_2056_rev5[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9454,7 +9454,7 @@ struct radio_regs regs_RX_2056_rev5[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_SYN_2056_rev6[] = {
+static struct radio_regs regs_SYN_2056_rev6[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9639,7 +9639,7 @@ struct radio_regs regs_SYN_2056_rev6[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_TX_2056_rev6[] = {
+static struct radio_regs regs_TX_2056_rev6[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9796,7 +9796,7 @@ struct radio_regs regs_TX_2056_rev6[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_RX_2056_rev6[] = {
+static struct radio_regs regs_RX_2056_rev6[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9947,7 +9947,7 @@ struct radio_regs regs_RX_2056_rev6[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-struct radio_regs regs_SYN_2056_rev7[] = {
+static struct radio_regs regs_SYN_2056_rev7[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10132,7 +10132,7 @@ struct radio_regs regs_SYN_2056_rev7[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_TX_2056_rev7[] = {
+static struct radio_regs regs_TX_2056_rev7[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10289,7 +10289,7 @@ struct radio_regs regs_TX_2056_rev7[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_RX_2056_rev7[] = {
+static struct radio_regs regs_RX_2056_rev7[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10440,7 +10440,7 @@ struct radio_regs regs_RX_2056_rev7[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_SYN_2056_rev8[] = {
+static struct radio_regs regs_SYN_2056_rev8[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10625,7 +10625,7 @@ struct radio_regs regs_SYN_2056_rev8[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_TX_2056_rev8[] = {
+static struct radio_regs regs_TX_2056_rev8[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10782,7 +10782,7 @@ struct radio_regs regs_TX_2056_rev8[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_RX_2056_rev8[] = {
+static struct radio_regs regs_RX_2056_rev8[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -11426,7 +11426,7 @@ static const struct radio_regs regs_RX_2056_rev11[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_20xx_regs regs_2057_rev4[] = {
+static struct radio_20xx_regs regs_2057_rev4[] = {
 	{0x00, 0x84, 0},
 	{0x01, 0, 0},
 	{0x02, 0x60, 0},
@@ -11816,7 +11816,7 @@ struct radio_20xx_regs regs_2057_rev4[] = {
 	{0xFFFF, 0, 0},
 };
 
-struct radio_20xx_regs regs_2057_rev5[] = {
+static struct radio_20xx_regs regs_2057_rev5[] = {
 	{0x00, 0, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
@@ -12148,7 +12148,7 @@ struct radio_20xx_regs regs_2057_rev5[] = {
 	{0xFFFF, 0, 0}
 };
 
-struct radio_20xx_regs regs_2057_rev5v1[] = {
+static struct radio_20xx_regs regs_2057_rev5v1[] = {
 	{0x00, 0x15, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
@@ -12480,7 +12480,7 @@ struct radio_20xx_regs regs_2057_rev5v1[] = {
 	{0xFFFF, 0, 0}
 };
 
-struct radio_20xx_regs regs_2057_rev7[] = {
+static struct radio_20xx_regs regs_2057_rev7[] = {
 	{0x00, 0, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
@@ -12896,7 +12896,7 @@ struct radio_20xx_regs regs_2057_rev7[] = {
 	{0xFFFF, 0, 0}
 };
 
-struct radio_20xx_regs regs_2057_rev8[] = {
+static struct radio_20xx_regs regs_2057_rev8[] = {
 	{0x00, 0x8, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 15c5ffc..622c01c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -1611,10 +1611,6 @@ const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
 
-static const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
-	sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
-	sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);
-
 const u32 dot11lcnphytbl_rx_gain_info_2G_rev2_sz =
 	sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2) /
 	sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2[0]);
-- 
1.7.1


