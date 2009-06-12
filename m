Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64146 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbZFLLSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:18:22 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 33/33] wl1251: change psm enabled/disabled info to debug
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:53 +0300
Message-ID: <20090612111753.8877.30538.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

With shorter CAM timeouts, the logs get flooded with "psm enabled" and "psm
disabled traces.  This patch changes it from wl1251_info to wl1251_debug, so
they are only shown if DEBUF_PSM is enabled.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 11e1903..cf5e054 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -542,7 +542,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out_sleep;
 
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
-		wl1251_info("psm enabled");
+		wl1251_debug(DEBUG_PSM, "psm enabled");
 
 		wl->psm_requested = true;
 
@@ -554,7 +554,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   wl->psm_requested) {
-		wl1251_info("psm disabled");
+		wl1251_debug(DEBUG_PSM, "psm disabled");
 
 		wl->psm_requested = false;
 

