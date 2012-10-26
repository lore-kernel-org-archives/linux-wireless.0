Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316Ab2JZOYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:17 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 12/18] brcmsmac: Add INT debug macro
Date: Fri, 26 Oct 2012 09:23:27 -0500
Message-Id: <1351261413-20821-13-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162423_212547_EAAA922E)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also convert relevant message to use this macro.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/brcms_debug.h  |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   12 ++++++------
 drivers/net/wireless/brcm80211/include/defs.h      |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
index 2b3ca0d..16f7304 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
@@ -39,5 +39,6 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 #define BRCMS_DBG_MAC80211(core, f, a...)	BRCMS_DBG(core, BRCM_DL_MAC80211, f, ##a)
 #define BRCMS_DBG_RX(core, f, a...)		BRCMS_DBG(core, BRCM_DL_RX, f, ##a)
 #define BRCMS_DBG_TX(core, f, a...)		BRCMS_DBG(core, BRCM_DL_TX, f, ##a)
+#define BRCMS_DBG_INT(core, f, a...)		BRCMS_DBG(core, BRCM_DL_INT, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index d6a7076..ba64b38 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2349,8 +2349,8 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 		if (!intstatus)
 			continue;
 
-		BCMMSG(wlc_hw->wlc->wiphy, "wl%d: intstatus%d 0x%x\n",
-			unit, idx, intstatus);
+		BRCMS_DBG_INT(core, "wl%d: intstatus%d 0x%x\n",
+			      unit, idx, intstatus);
 
 		if (intstatus & I_RO) {
 			BRCMS_ERR(core, "wl%d: fifo %d: receive fifo "
@@ -2547,8 +2547,8 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 	/* macintstatus includes a DMA interrupt summary bit */
 	macintstatus = bcma_read32(core, D11REGOFFS(macintstatus));
 
-	BCMMSG(wlc->wiphy, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
-		 macintstatus);
+	BRCMS_DBG_INT(core, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
+		      macintstatus);
 
 	/* detect cardbus removed, in power down(suspend) and in reset */
 	if (brcms_deviceremoved(wlc))
@@ -7956,8 +7956,8 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	macintstatus = wlc->macintstatus;
 	wlc->macintstatus = 0;
 
-	BCMMSG(wlc->wiphy, "wl%d: macintstatus 0x%x\n",
-	       wlc_hw->unit, macintstatus);
+	BRCMS_DBG_INT(core, "wl%d: macintstatus 0x%x\n",
+		      wlc_hw->unit, macintstatus);
 
 	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
 
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index 9206d2c..12dd33f 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -83,6 +83,7 @@
 #define BRCM_DL_MAC80211	0x00000002
 #define BRCM_DL_RX		0x00000004
 #define BRCM_DL_TX		0x00000008
+#define BRCM_DL_INT		0x00000010
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5

