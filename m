Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24410 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdALNPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:20 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 06/13] wil6210: missing reinit_completion in wmi_call
Date: Thu, 12 Jan 2017 15:05:58 +0200
Message-Id: <1484226365-10433-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141533_592382_257C6409)
In-Reply-To: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

The code in wmi_call uses the wil->wmi_call completion
structure to wait for a reply.
In some scenarios, complete was called twice on the
completion structure. This happened mainly with a disconnect
event which can arrive both unsolicited and as a reply to
a disconnect request. In this case the completion structure
was left marked as "done" and the next wmi_call returned
immediately with a corrupted reply buffer. This caused
unexpected results including crashes.
Fix this by adding the missing call to reinit_completion.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0137ac5..d30b3fc 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -957,6 +957,7 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 	wil->reply_id = reply_id;
 	wil->reply_buf = reply;
 	wil->reply_size = reply_size;
+	reinit_completion(&wil->wmi_call);
 	spin_unlock(&wil->wmi_ev_lock);
 
 	rc = __wmi_send(wil, cmdid, buf, len);
-- 
1.9.1
