Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4103 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbbGFHka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 03:40:30 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 10/13] wil6210: skip HW version check for chip debugging
Date: Mon,  6 Jul 2015 10:39:46 +0300
Message-Id: <1436168389-3676-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150706_100715_927857_EA8F5AA1)
In-Reply-To: <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When loading with debug_fw flag, do not bail out on
unknown chipId

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index cdc82cf..0d64e73 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -746,9 +746,6 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	if (wil->hw_version == HW_VER_UNKNOWN)
-		return -ENODEV;
-
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 	WARN_ON(test_bit(wil_status_napi_en, wil->status));
 
@@ -763,6 +760,9 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		return 0;
 	}
 
+	if (wil->hw_version == HW_VER_UNKNOWN)
+		return -ENODEV;
+
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 	wil_bcast_fini(wil);
-- 
2.1.4

