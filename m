Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2289 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/15] brcm80211: smac: indicate severe problems to
 Mac80211
Date: Tue, 18 Oct 2011 14:03:04 +0200
Message-ID: <1318939391-19495-9-git-send-email-arend@broadcom.com> (sfid-20111018_140339_929937_90B9BD45)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

In case the hardware crashes, a reinitialization internal to the driver
was performed. Since Mac80211 must be in the know of such an event as
well, ieee80211_restart_hw() is now called.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    8 ++++++++
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   14 +++-----------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 538b504..7a24a83 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1334,6 +1334,14 @@ uint brcms_reset(struct brcms_info *wl)
 	return 0;
 }
 
+void brcms_fatal_error(struct brcms_info *wl)
+{
+	wiphy_err(wl->wlc->wiphy, "wl%d: fatal error, reinitializing\n",
+		  wl->wlc->pub->unit);
+	brcms_reset(wl);
+	ieee80211_restart_hw(wl->pub->ieee_hw);
+}
+
 /*
  * These are interrupt on/off entry points. Disable interrupts
  * during interrupt state transition.
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
index 177f0e4..5c279c0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
@@ -104,5 +104,6 @@ extern bool brcms_del_timer(struct brcms_timer *timer);
 extern void brcms_msleep(struct brcms_info *wl, uint ms);
 extern void brcms_dpc(unsigned long data);
 extern void brcms_timer(struct brcms_timer *t);
+extern void brcms_fatal_error(struct brcms_info *wl);
 
 #endif				/* _BRCM_MAC80211_IF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 84f32b6..2e1a20b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2301,13 +2301,6 @@ void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw, u8 antsel_type)
 	wlc_phy_antsel_type_set(wlc_hw->band->pi, antsel_type);
 }
 
-static void brcms_c_fatal_error(struct brcms_c_info *wlc)
-{
-	wiphy_err(wlc->wiphy, "wl%d: fatal error, reinitializing\n",
-		  wlc->pub->unit);
-	brcms_init(wlc->wl);
-}
-
 static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 {
 	bool fatal = false;
@@ -2363,7 +2356,7 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 		}
 
 		if (fatal) {
-			brcms_c_fatal_error(wlc_hw->wlc);	/* big hammer */
+			brcms_fatal_error(wlc_hw->wlc->wl); /* big hammer */
 			break;
 		} else
 			W_REG(&regs->intctrlregs[idx].intstatus,
@@ -8397,8 +8390,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
 					__func__, wlc_hw->sih->chip,
 					wlc_hw->sih->chiprev);
-		/* big hammer */
-		brcms_init(wlc->wl);
+		brcms_fatal_error(wlc_hw->wlc->wl);
 	}
 
 	/* gptimer timeout */
@@ -8419,7 +8411,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	return wlc->macintstatus != 0;
 
  fatal:
-	brcms_init(wlc->wl);
+	brcms_fatal_error(wlc_hw->wlc->wl);
 	return wlc->macintstatus != 0;
 }
 
-- 
1.7.4.1


