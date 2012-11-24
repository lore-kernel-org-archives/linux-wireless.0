Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36562 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab2KXW0E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 17:26:04 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wim@iguana.be,
	linux-watchdog@vger.kernel.org, castet.matthieu@free.fr,
	biblbroks@sezampro.rs, m@bues.ch, zajec5@gmail.com,
	linux-mips@linux-mips.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 13/15] ssb: extif: add check for max value in watchdog
Date: Sat, 24 Nov 2012 23:24:13 +0100
Message-Id: <1353795855-22236-14-git-send-email-hauke@hauke-m.de> (sfid-20121124_233122_514589_4EC5CE61)
In-Reply-To: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
References: <1353795855-22236-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent the watchdog register ion the extif core to be set to a too
high value.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_extif.c           |    5 +++--
 include/linux/ssb/ssb_driver_extif.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_extif.c b/drivers/ssb/driver_extif.c
index dc47f30..0aa4c2a 100644
--- a/drivers/ssb/driver_extif.c
+++ b/drivers/ssb/driver_extif.c
@@ -112,9 +112,10 @@ void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
 	*m = extif_read32(extif, SSB_EXTIF_CLOCK_SB);
 }
 
-void ssb_extif_watchdog_timer_set(struct ssb_extif *extif,
-				  u32 ticks)
+void ssb_extif_watchdog_timer_set(struct ssb_extif *extif, u32 ticks)
 {
+	if (ticks > SSB_EXTIF_WATCHDOG_MAX_TIMER)
+		ticks = SSB_EXTIF_WATCHDOG_MAX_TIMER;
 	extif_write32(extif, SSB_EXTIF_WATCHDOG, ticks);
 }
 
diff --git a/include/linux/ssb/ssb_driver_extif.h b/include/linux/ssb/ssb_driver_extif.h
index 91161f0..34072f5 100644
--- a/include/linux/ssb/ssb_driver_extif.h
+++ b/include/linux/ssb/ssb_driver_extif.h
@@ -152,6 +152,7 @@
 /* watchdog */
 #define SSB_EXTIF_WATCHDOG_CLK		48000000	/* Hz */
 
+#define SSB_EXTIF_WATCHDOG_MAX_TIMER	((1 << 28) - 1)
 
 
 #ifdef CONFIG_SSB_DRIVER_EXTIF
-- 
1.7.10.4

