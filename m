Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53871 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab2F3NRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 11/18] brcmsmac: remove some unnessessacry casts and void pointer
Date: Sat, 30 Jun 2012 15:16:14 +0200
Message-Id: <1341062181-28071-12-git-send-email-hauke@hauke-m.de> (sfid-20120630_151756_559125_46B52D23)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 478b374..8bad8b6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4218,9 +4218,8 @@ static void brcms_c_radio_timer(void *arg)
 }
 
 /* common low-level watchdog code */
-static void brcms_b_watchdog(void *arg)
+static void brcms_b_watchdog(struct brcms_c_info *wlc)
 {
-	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 	struct brcms_hardware *wlc_hw = wlc->hw;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -4241,10 +4240,8 @@ static void brcms_b_watchdog(void *arg)
 }
 
 /* common watchdog code */
-static void brcms_c_watchdog(void *arg)
+static void brcms_c_watchdog(struct brcms_c_info *wlc)
 {
-	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
-
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	if (!wlc->pub->up)
@@ -4284,7 +4281,9 @@ static void brcms_c_watchdog(void *arg)
 
 static void brcms_c_watchdog_by_timer(void *arg)
 {
-	brcms_c_watchdog(arg);
+	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
+
+	brcms_c_watchdog(wlc);
 }
 
 static bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
-- 
1.7.9.5

