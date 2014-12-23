Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaLWHsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:00 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 05/22] wil6210: fix disconnect 1 STA in AP
Date: Tue, 23 Dec 2014 09:47:07 +0200
Message-Id: <1419320844-23989-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084818_737330_22120DD7)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disconnecting single STA in AP, it might be that STA
in question is already disconnected. In this case, need to do nothing.
Previously, it was mis-interpreted as "disconnect all"

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 42e1192..18a2eb5 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -188,18 +188,29 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 	struct wireless_dev *wdev = wil->wdev;
 
 	might_sleep();
-	if (bssid) {
+	wil_dbg_misc(wil, "%s(bssid=%pM, reason=%d, ev%s)\n", __func__, bssid,
+		     reason_code, from_event ? "+" : "-");
+
+	/* Cases are:
+	 * - disconnect single STA, still connected
+	 * - disconnect single STA, already disconnected
+	 * - disconnect all
+	 *
+	 * For "disconnect all", there are 2 options:
+	 * - bssid == NULL
+	 * - bssid is our MAC address
+	 */
+	if (bssid && memcmp(ndev->dev_addr, bssid, ETH_ALEN)) {
 		cid = wil_find_cid(wil, bssid);
-		wil_dbg_misc(wil, "%s(%pM, CID %d)\n", __func__, bssid, cid);
-	} else {
-		wil_dbg_misc(wil, "%s(all)\n", __func__);
-	}
-
-	if (cid >= 0) /* disconnect 1 peer */
-		wil_disconnect_cid(wil, cid, reason_code, from_event);
-	else /* disconnect all */
+		wil_dbg_misc(wil, "Disconnect %pM, CID=%d, reason=%d\n",
+			     bssid, cid, reason_code);
+		if (cid >= 0) /* disconnect 1 peer */
+			wil_disconnect_cid(wil, cid, reason_code, from_event);
+	} else { /* all */
+		wil_dbg_misc(wil, "Disconnect all\n");
 		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
 			wil_disconnect_cid(wil, cid, reason_code, from_event);
+	}
 
 	/* link state */
 	switch (wdev->iftype) {
-- 
2.1.0

