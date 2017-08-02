Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35554 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752616AbdHBVBE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 17:01:04 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 4/9] wil6210: check no_fw_recovery in resume failure recovery
Date: Thu,  3 Aug 2017 00:00:44 +0300
Message-Id: <1501707649-9665-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170802_230107_832545_C80CE2A4)
In-Reply-To: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reset 11ad device on resume failure only if no_fw_recovery
is not set.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index ce1f384..4548829 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -85,7 +85,9 @@ static int wil_resume_keep_radio_on(struct wil6210_priv *wil)
 	/* Send WMI resume request to the device */
 	rc = wmi_resume(wil);
 	if (rc) {
-		wil_err(wil, "device failed to resume (%d), resetting\n", rc);
+		wil_err(wil, "device failed to resume (%d)\n", rc);
+		if (no_fw_recovery)
+			goto out;
 		rc = wil_down(wil);
 		if (rc) {
 			wil_err(wil, "wil_down failed (%d)\n", rc);
-- 
1.9.1
