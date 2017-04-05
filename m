Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5508 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932932AbdDEL6c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:58:32 -0400
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 07/11] wil6210: fix check for sparrow D0 FW file
Date: Wed,  5 Apr 2017 14:58:10 +0300
Message-Id: <1491393494-11816-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170405_140159_293105_4C294B34)
In-Reply-To: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

Driver fails to load FW for sparrow D0 devices in some cases.
Fix this by returning correct value from wil_fw_verify_file_exists
when D0 FW file is not detected for any reason.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/fw_inc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index f4901587..e01acac 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -554,5 +554,7 @@ bool wil_fw_verify_file_exists(struct wil6210_priv *wil, const char *name)
 	rc = request_firmware(&fw, name, wil_to_dev(wil));
 	if (!rc)
 		release_firmware(fw);
-	return rc != -ENOENT;
+	else
+		wil_dbg_fw(wil, "<%s> not available: %d\n", name, rc);
+	return !rc;
 }
-- 
1.9.1
