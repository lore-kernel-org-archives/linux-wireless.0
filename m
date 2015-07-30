Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64261 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbbG3Kyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:43 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 06/19] wil6210: use wil_fw_error_recovery()
Date: Thu, 30 Jul 2015 13:51:54 +0300
Message-Id: <1438253527-3372-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125451_175044_507F7AAE)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use function wil_fw_error_recovery() instead of inline equivalent code

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index ae0df35..c77ae17 100644
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

