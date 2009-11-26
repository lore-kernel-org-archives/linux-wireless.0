Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23592 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575AbZKZPIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:08:53 -0500
Subject: [PATCH 03/12] wl1251: fix error handling in wl1251_op_config()
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:08:43 +0200
Message-ID: <20091126150843.917.6633.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Not all return values were checked and one exit from function didn't put
firmware sleep after the error.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index e9fb2ca..8ba6742 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -641,20 +641,25 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * through the bss_info_changed() hook.
 		 */
 		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+		if (ret < 0)
+			goto out_sleep;
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm disabled");
 
 		wl->psm_requested = false;
 
-		if (wl->psm)
+		if (wl->psm) {
 			ret = wl1251_ps_set_mode(wl, STATION_ACTIVE_MODE);
+			if (ret < 0)
+				goto out_sleep;
+		}
 	}
 
 	if (conf->power_level != wl->power_level) {
 		ret = wl1251_acx_tx_power(wl, conf->power_level);
 		if (ret < 0)
-			goto out;
+			goto out_sleep;
 
 		wl->power_level = conf->power_level;
 	}

