Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45188 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaLANdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:33:53 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 3/9] wil6210: fix recovery after scan timeout
Date: Mon, 1 Dec 2014 15:33:17 +0200
Message-ID: <1417440803-26883-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143356_911776_5B1E84F8)
In-Reply-To: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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

