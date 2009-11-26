Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23645 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658AbZKZPJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:50 -0500
Subject: [PATCH 12/12] wl1251: enable WMM
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:09:45 +0200
Message-ID: <20091126150945.917.10816.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Everything is ready now and we can enable WMM in mac80211.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    2 ++
 drivers/net/wireless/wl12xx/wl1251_tx.h   |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index e1c4dd3..6aeffbe 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1382,6 +1382,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1251_band_2ghz;
 
+	wl->hw->queues = 4;
+
 	ret = wl1251_register_hw(wl);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.h b/drivers/net/wireless/wl12xx/wl1251_tx.h
index b7bead8..55856c6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.h
@@ -212,9 +212,6 @@ struct tx_result {
 
 static inline int wl1251_tx_get_queue(int queue)
 {
-	/* FIXME: use best effort until WMM is enabled */
-	return QOS_AC_BE;
-
 	switch (queue) {
 	case 0:
 		return QOS_AC_VO;

