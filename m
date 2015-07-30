Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24801 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbbG3Kyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:43 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 07/19] wil6210: skip HW version check for chip debugging
Date: Thu, 30 Jul 2015 13:51:55 +0300
Message-Id: <1438253527-3372-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_130716_003844_1225ACCE)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When loading with debug_fw flag, do not bail out on
unknown chipId

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c77ae17..33a3e9b 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -738,9 +738,6 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	if (wil->hw_version == HW_VER_UNKNOWN)
-		return -ENODEV;
-
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 	WARN_ON(test_bit(wil_status_napi_en, wil->status));
 
@@ -755,6 +752,9 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
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

