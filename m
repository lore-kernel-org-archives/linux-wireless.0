Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46354 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaJ1Oug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:50:36 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 1/5] wil6210: do not attempt FW recovery if interface is down
Date: Tue, 28 Oct 2014 16:50:06 +0200
Message-ID: <1414507810-23141-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141028_155039_435694_D48DCBD2)
In-Reply-To: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When interface is down, recovery flow should not be attempted.
Next ndo_open() will trigger target reset, that is FW recovery.

Doing recovery while interface is down cause internal "up", leaving
internal driver state in conflict with network stack. Then, when network
stack will call ndo_open(), kernel oops will be triggered.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6500caf..7900384 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -223,6 +223,11 @@ static void wil_fw_error_worker(struct work_struct *work)
 
 	wil_dbg_misc(wil, "fw error worker\n");
 
+	if (!netif_running(wil_to_ndev(wil))) {
+		wil_info(wil, "No recovery - interface is down\n");
+		return;
+	}
+
 	/* increment @recovery_count if less then WIL6210_FW_RECOVERY_TO
 	 * passed since last recovery attempt
 	 */
-- 
2.1.0

