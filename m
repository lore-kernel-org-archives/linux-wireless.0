Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43854 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934967Ab3FTHRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 03:17:33 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix race in heart beat polling
Date: Thu, 20 Jun 2013 12:47:20 +0530
Message-ID: <1371712640-12834-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130620_091737_777223_042D6741)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Make sure to cancel heart beat timer before
freeing wmi to avoid potential NULL pointer
dereference.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6a67881..4f316bd 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1836,6 +1836,9 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 
 	clear_bit(WMI_READY, &ar->flag);
 
+	if (ar->fw_recovery.enable)
+		del_timer_sync(&ar->fw_recovery.hb_timer);
+
 	/*
 	 * After wmi_shudown all WMI events will be dropped. We
 	 * need to cleanup the buffers allocated in AP mode and
-- 
1.7.9.5

