Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767933Ab2KOOIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:23 -0500
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
Subject: [PATCH v2 04/22] brcmsmac: Remove unimplemented flow control functions
Date: Thu, 15 Nov 2012 08:07:54 -0600
Message-Id: <1352988492-21340-5-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150838_425444_9A9FA598)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Functions for flow control exist but remain unimplemented. Remove these
in advance of adding real flow control.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   31 ------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index e4ef457..135af9a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -35,12 +35,6 @@
 #include "main.h"
 #include "soc.h"
 
-/*
- * Indication for txflowcontrol that all priority bits in
- * TXQ_STOP_FOR_PRIOFC_MASK are to be considered.
- */
-#define ALLPRIO				-1
-
 /* watchdog timer, in unit of ms */
 #define TIMER_INTERVAL_WATCHDOG		1000
 /* radio monitor timer, in unit of ms */
@@ -3767,25 +3761,6 @@ static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
 	wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
 }
 
-static void
-brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
-			     struct brcms_txq_info *qi, bool on, int prio)
-{
-	/* transmit flowcontrol is not yet implemented */
-}
-
-static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
-{
-	struct brcms_txq_info *qi;
-
-	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
-		if (qi->stopped) {
-			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
-			qi->stopped = 0;
-		}
-	}
-}
-
 /* push sw hps and wake state through hardware */
 static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 {
@@ -5353,9 +5328,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 
 	wlc_phy_mute_upd(wlc->band->pi, false, PHY_MUTE_ALL);
 
-	/* clear txq flow control */
-	brcms_c_txflowcontrol_reset(wlc);
-
 	/* flush tx queues */
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next)
 		brcmu_pktq_flush(&qi->q, true, NULL, NULL);
@@ -8302,9 +8274,6 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	if (mute_tx)
 		brcms_b_mute(wlc->hw, true);
 
-	/* clear tx flow control */
-	brcms_c_txflowcontrol_reset(wlc);
-
 	/* enable the RF Disable Delay timer */
 	bcma_write32(core, D11REGOFFS(rfdisabledly), RFDISABLE_DEFAULT);
 
-- 
1.7.9.5

