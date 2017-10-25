Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35612 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdJYNO0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 09:14:26 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 07/12] wil6210: missing length check in wmi_set_ie
Date: Wed, 25 Oct 2017 16:14:02 +0300
Message-Id: <1508937247-11890-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171025_151430_526236_A912A077)
In-Reply-To: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add a length check in wmi_set_ie to detect unsigned integer
overflow.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 16aa624..dd25f63 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1616,8 +1616,14 @@ int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 	};
 	int rc;
 	u16 len = sizeof(struct wmi_set_appie_cmd) + ie_len;
-	struct wmi_set_appie_cmd *cmd = kzalloc(len, GFP_KERNEL);
+	struct wmi_set_appie_cmd *cmd;
 
+	if (len < ie_len) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	cmd = kzalloc(len, GFP_KERNEL);
 	if (!cmd) {
 		rc = -ENOMEM;
 		goto out;
-- 
1.9.1
