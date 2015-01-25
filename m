Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbbAYIx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:28 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 03/10] wil6210: ignore firmware failure to gracefully stop AP
Date: Sun, 25 Jan 2015 10:52:44 +0200
Message-Id: <1422175971-8075-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095337_010854_92A40E75)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

upon cfg80211_stop_ap, a graceful AP shutdown is requested from firmware
followed by firmware reset.
In case graceful request failed, error was returned to cfg80211.

The change is to return success in this scenario, because firmware
reset will anyhow shutdown the AP.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 553aa2e..6b7664d 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -773,7 +773,6 @@ out:
 static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 				struct net_device *ndev)
 {
-	int rc, rc1;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
@@ -783,14 +782,17 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 
 	mutex_lock(&wil->mutex);
 
-	rc = wmi_pcp_stop(wil);
+	wmi_pcp_stop(wil);
 
 	__wil_down(wil);
-	rc1 = __wil_up(wil);
+	__wil_up(wil);
 
 	mutex_unlock(&wil->mutex);
 
-	return min(rc, rc1);
+	/* some functions above might fail (e.g. __wil_up). Nevertheless, we
+	 * return success because AP has stopped
+	 */
+	return 0;
 }
 
 static int wil_cfg80211_del_station(struct wiphy *wiphy,
-- 
2.1.0

