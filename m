Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58506 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaAGMJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:09:07 -0500
Date: Tue, 7 Jan 2014 13:09:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 07/13] wl1251: disable power saving in monitor mode
Message-ID: <20140107120906.GG10836@amd.pavel.ucw.cz> (sfid-20140107_130911_216509_8D5A50BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Gnedt <david.gnedt@davizone.at>

Force power saving off while monitor interface is present.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/wireless/ti/wl1251/main.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index ee318c8..1223bc6 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -570,6 +570,11 @@ static int wl1251_build_qos_null_data(struct wl1251 *wl)
 				       sizeof(template));
 }
 
+static bool wl1251_can_do_pm(struct ieee80211_conf *conf, struct wl1251 *wl)
+{
+	return (conf->flags & IEEE80211_CONF_PS) && !wl->monitor_present;
+}
+
 static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wl1251 *wl = hw->priv;
@@ -617,7 +622,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out_sleep;
 	}
 
-	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
+	if (wl1251_can_do_pm(conf, wl) && !wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm enabled");
 
 		wl->psm_requested = true;
@@ -633,8 +638,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			goto out_sleep;
-	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   wl->psm_requested) {
+	} else if (!wl1251_can_do_pm(conf, wl) && wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm disabled");
 
 		wl->psm_requested = false;
