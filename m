Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:39937 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1A3STf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:19:35 -0500
Message-ID: <4D45A79E.7040801@davizone.at>
Date: Sun, 30 Jan 2011 19:02:06 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 15/18] wl1251: disable power saving in monitor mode
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Force power saving off while monitor interface is present.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/wl1251/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index d6ae6d5..edafa98 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -616,7 +616,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out_sleep;
 	}
 
-	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
+	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested &&
+	    !wl->monitor_present) {
 		wl1251_debug(DEBUG_PSM, "psm enabled");
 
 		wl->psm_requested = true;
@@ -632,8 +633,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			goto out_sleep;
-	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   wl->psm_requested) {
+	} else if ((!(conf->flags & IEEE80211_CONF_PS) || wl->monitor_present)
+		   && wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm disabled");
 
 		wl->psm_requested = false;
-- 
1.7.0.4


