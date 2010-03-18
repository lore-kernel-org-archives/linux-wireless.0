Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33067 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0CRK1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:22 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 08/21] wl1271: enable WMM
Date: Thu, 18 Mar 2010 12:26:33 +0200
Message-Id: <1268908006-16992-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Everything is ready now and we can enable WMM in wl1271.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 ++
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index abf9f22..d21bfe2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2091,6 +2091,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	if (wl1271_11a_enabled())
 		wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
 
+	wl->hw->queues = 4;
+
 	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
 
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 8b9f6b4..5e6c27a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -125,9 +125,6 @@ struct wl1271_tx_hw_res_if {
 
 static inline int wl1271_tx_get_queue(int queue)
 {
-	/* FIXME: use best effort until WMM is enabled */
-	return CONF_TX_AC_BE;
-
 	switch (queue) {
 	case 0:
 		return CONF_TX_AC_VO;
-- 
1.6.3.3

