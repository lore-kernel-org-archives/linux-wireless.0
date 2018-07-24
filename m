Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:1826 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388567AbeGXIuF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:50:05 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Hamad Kadmany <hkadmany@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 13/19] wil6210: increase firmware ready timeout
Date: Tue, 24 Jul 2018 10:44:34 +0300
Message-Id: <1532418280-5849-14-git-send-email-merez@codeaurora.org> (sfid-20180724_094516_933316_9F26668F)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <hkadmany@codeaurora.org>

Firmware ready event may take longer than
current timeout in some scenarios, for example
with multiple RFs connected where each
requires an initial calibration.

Increase the timeout to support these scenarios.

Signed-off-by: Hamad Kadmany <hkadmany@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a949e91..7dcbd46 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1282,7 +1282,7 @@ static int wil_get_otp_info(struct wil6210_priv *wil)
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {
-- 
1.9.1
