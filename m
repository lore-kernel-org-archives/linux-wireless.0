Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4075 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbbGFHk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 03:40:29 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 09/13] wil6210: use wil_fw_error_recovery()
Date: Mon,  6 Jul 2015 10:39:45 +0300
Message-Id: <1436168389-3676-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150706_094045_852650_F0C25ADC)
In-Reply-To: <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use function wil_fw_error_recovery() instead of inline equivalent code

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4740edb..cdc82cf 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -271,8 +271,7 @@ static void wil_scan_timer_fn(ulong x)
 
 	clear_bit(wil_status_fwready, wil->status);
 	wil_err(wil, "Scan timeout detected, start fw error recovery\n");
-	wil->recovery_state = fw_recovery_pending;
-	schedule_work(&wil->fw_error_worker);
+	wil_fw_error_recovery(wil);
 }
 
 static int wil_wait_for_recovery(struct wil6210_priv *wil)
-- 
2.1.4

