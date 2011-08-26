Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4811 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/13] staging: brcm80211: removed unused phy logging
Date: Fri, 26 Aug 2011 15:19:38 +0200
Message-ID: <1314364780-9462-12-git-send-email-rvossen@broadcom.com> (sfid-20110826_152019_520618_86D7E008)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Macro's were not used so they were removed.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    4 ----
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    2 --
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |   16 ----------------
 3 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 9b787e6..01829db 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -105,8 +105,6 @@ MODULE_DEVICE_TABLE(pci, brcms_pci_id_table);
 #ifdef BCMDBG
 static int msglevel = 0xdeadbeef;
 module_param(msglevel, int, 0);
-static int phymsglevel = 0xdeadbeef;
-module_param(phymsglevel, int, 0);
 #endif				/* BCMDBG */
 
 #define HW_TO_WL(hw)	 (hw->priv)
@@ -1282,8 +1280,6 @@ static int __init brcms_module_init(void)
 #ifdef BCMDBG
 	if (msglevel != 0xdeadbeef)
 		brcm_msg_level = msglevel;
-	if (phymsglevel != 0xdeadbeef)
-		phyhal_msg_level = phymsglevel;
 #endif				/* BCMDBG */
 
 	error = pci_register_driver(&brcms_pci_driver);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 3d54a39..bd602de 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -27,8 +27,6 @@
 #include "phy_lcn.h"
 #include "phyreg_n.h"
 
-u32 phyhal_msg_level = PHYHAL_ERROR;
-
 struct chan_info_basic {
 	u16 chan;
 	u16 freq;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 7ec2ad2..a06e719 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -23,22 +23,6 @@
 
 #define	PHY_VERSION			{ 1, 82, 8, 0 }
 
-#define PHYHAL_ERROR	0x0001
-#define PHYHAL_TRACE	0x0002
-#define PHYHAL_INFORM	0x0004
-
-extern u32 phyhal_msg_level;
-
-#define PHY_INFORM_ON()		(phyhal_msg_level & PHYHAL_INFORM)
-#define PHY_THERMAL_ON()	(phyhal_msg_level & PHYHAL_THERMAL)
-#define PHY_CAL_ON()		(phyhal_msg_level & PHYHAL_CAL)
-
-#ifdef BOARD_TYPE
-#define BOARDTYPE(_type) BOARD_TYPE
-#else
-#define BOARDTYPE(_type) _type
-#endif
-
 #define LCNXN_BASEREV		16
 
 struct phy_shim_info;
-- 
1.7.4.1


