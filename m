Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36262 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2FEXId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 11/18] brcmsmac: remove some unnessessacry casts and void pointer
Date: Wed,  6 Jun 2012 01:07:14 +0200
Message-Id: <1338937641-8519-12-git-send-email-hauke@hauke-m.de> (sfid-20120606_012943_364595_4CBFF0CB)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8cfa8bb..a07ff0a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4231,9 +4231,8 @@ static void brcms_c_radio_timer(void *arg)
 }
 
 /* common low-level watchdog code */
-static void brcms_b_watchdog(void *arg)
+static void brcms_b_watchdog(struct brcms_c_info *wlc)
 {
-	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 	struct brcms_hardware *wlc_hw = wlc->hw;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -4254,10 +4253,8 @@ static void brcms_b_watchdog(void *arg)
 }
 
 /* common watchdog code */
-static void brcms_c_watchdog(void *arg)
+static void brcms_c_watchdog(struct brcms_c_info *wlc)
 {
-	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
-
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	if (!wlc->pub->up)
@@ -4297,7 +4294,9 @@ static void brcms_c_watchdog(void *arg)
 
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

