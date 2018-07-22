Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:6993 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728342AbeGVIqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 04:46:18 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 19/20] wil6210: prevent FW download if HW is configured for secured boot
Date: Sun, 22 Jul 2018 10:47:44 +0300
Message-Id: <1532245665-15249-20-git-send-email-merez@codeaurora.org> (sfid-20180722_095039_006542_6B3C0C42)
In-Reply-To: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
References: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the driver doesn't support secured boot flow, hence
prevent FW download in case HW is configured for such a flow.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7ad22df..1d4ce8e 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1560,6 +1560,11 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	if (load_fw) {
 		char board_file[WIL_BOARD_FILE_MAX_NAMELEN];
 
+		if  (wil->secured_boot) {
+			wil_err(wil, "secured boot is not supported\n");
+			return -ENOTSUPP;
+		}
+
 		board_file[0] = '\0';
 		wil_get_board_file(wil, board_file, sizeof(board_file));
 		wil_info(wil, "Use firmware <%s> + board <%s>\n",
-- 
1.9.1
