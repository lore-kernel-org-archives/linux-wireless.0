Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2890 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab1JUOQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:50 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 04/17] brcm80211: smac: removed MPC related variables
Date: Fri, 21 Oct 2011 16:16:22 +0200
Message-ID: <1319206595-17138-5-git-send-email-arend@broadcom.com> (sfid-20111021_161705_135859_256D9EF6)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Several member variables were never read.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 ++------
 drivers/net/wireless/brcm80211/brcmsmac/main.h |    6 ------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 4687983..e7d14e4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4303,10 +4303,6 @@ static void brcms_c_radio_timer(void *arg)
 		return;
 	}
 
-	/* cap mpc off count */
-	if (wlc->mpc_offcnt < BRCMS_MPC_MAX_DELAYCNT)
-		wlc->mpc_offcnt++;
-
 	brcms_c_radio_hwdisable_upd(wlc);
 	brcms_c_radio_upd(wlc);
 }
@@ -4488,7 +4484,7 @@ static void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->pub->bcmerror = 0;
 
 	/* initialize mpc delay */
-	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
+	wlc->mpc_delay_off = BRCMS_MPC_MIN_DELAYCNT;
 }
 
 static uint brcms_c_attach_module(struct brcms_c_info *wlc)
@@ -8447,7 +8443,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	W_REG(&wlc->regs->rfdisabledly, RFDISABLE_DEFAULT);
 
 	/* initialize mpc delay */
-	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
+	wlc->mpc_delay_off = BRCMS_MPC_MIN_DELAYCNT;
 
 	/*
 	 * Initialize WME parameters; if they haven't been set by some other
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 37c55fd..fc5852f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -427,10 +427,7 @@ struct brcms_txq_info {
  * bandinit_pending: track band init in auto band.
  * radio_monitor: radio timer is running.
  * going_down: down path intermediate variable.
- * mpc_dlycnt: # of watchdog cnt before turn disable radio.
- * mpc_offcnt: # of watchdog cnt that radio is disabled.
  * mpc_delay_off: delay radio disable by # of watchdog cnt.
- * prev_non_delay_mpc: prev state brcms_c_is_non_delay_mpc.
  * wdtimer: timer for watchdog routine.
  * radio_timer: timer for hw radio button monitor routine.
  * monitor: monitor (MPDU sniffing) mode.
@@ -521,10 +518,7 @@ struct brcms_c_info {
 	bool radio_monitor;
 	bool going_down;
 
-	u8 mpc_dlycnt;
-	u8 mpc_offcnt;
 	u8 mpc_delay_off;
-	u8 prev_non_delay_mpc;
 
 	struct brcms_timer *wdtimer;
 	struct brcms_timer *radio_timer;
-- 
1.7.4.1


