Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27007 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaLBJr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:47:27 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 04/10] wil6210: fix recovery after scan timeout
Date: Tue, 2 Dec 2014 11:46:32 +0200
Message-ID: <1417513598-18304-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141202_104734_748165_E4F1D491)
In-Reply-To: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scan timeout treated as indication for firmware error;
and should be handled in the same way.

Recovery state machine does not perform as designed because
its state is not updated in case of scan timeout.

Fix is to set recovery state machine into the proper state.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 151ff6b..3bef153 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -220,6 +220,7 @@ static void wil_scan_timer_fn(ulong x)
 
 	clear_bit(wil_status_fwready, &wil->status);
 	wil_err(wil, "Scan timeout detected, start fw error recovery\n");
+	wil->recovery_state = fw_recovery_pending;
 	schedule_work(&wil->fw_error_worker);
 }
 
-- 
2.1.0

