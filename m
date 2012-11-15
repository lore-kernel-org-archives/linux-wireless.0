Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58927 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767913Ab2KOOIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:49 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 16/22] brcmsmac: Add brcms_dbg_int() debug macro
Date: Thu, 15 Nov 2012 08:08:06 -0600
Message-Id: <1352988492-21340-17-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150857_575802_D9124D91)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also convert relevant message to use this macro.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.h |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |   12 ++++++------
 drivers/net/wireless/brcm80211/include/defs.h   |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
index b979128..1114833 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
@@ -39,5 +39,6 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 #define brcms_dbg_mac80211(core, f, a...)	brcms_dbg(core, BRCM_DL_MAC80211, f, ##a)
 #define brcms_dbg_rx(core, f, a...)		brcms_dbg(core, BRCM_DL_RX, f, ##a)
 #define brcms_dbg_tx(core, f, a...)		brcms_dbg(core, BRCM_DL_TX, f, ##a)
+#define brcms_dbg_int(core, f, a...)		brcms_dbg(core, BRCM_DL_INT, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index d6df923..54fa177 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2343,8 +2343,8 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 		if (!intstatus)
 			continue;
 
-		BCMMSG(wlc_hw->wlc->wiphy, "wl%d: intstatus%d 0x%x\n",
-			unit, idx, intstatus);
+		brcms_dbg_int(core, "wl%d: intstatus%d 0x%x\n",
+			      unit, idx, intstatus);
 
 		if (intstatus & I_RO) {
 			brcms_err(core, "wl%d: fifo %d: receive fifo "
@@ -2541,8 +2541,8 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 	/* macintstatus includes a DMA interrupt summary bit */
 	macintstatus = bcma_read32(core, D11REGOFFS(macintstatus));
 
-	BCMMSG(wlc->wiphy, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
-		 macintstatus);
+	brcms_dbg_int(core, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
+		      macintstatus);
 
 	/* detect cardbus removed, in power down(suspend) and in reset */
 	if (brcms_deviceremoved(wlc))
@@ -7950,8 +7950,8 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	macintstatus = wlc->macintstatus;
 	wlc->macintstatus = 0;
 
-	BCMMSG(wlc->wiphy, "wl%d: macintstatus 0x%x\n",
-	       wlc_hw->unit, macintstatus);
+	brcms_dbg_int(core, "wl%d: macintstatus 0x%x\n",
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

