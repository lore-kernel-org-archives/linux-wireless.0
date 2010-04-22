Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45217 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab0DVJ2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 05:28:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 02:28:44 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19408.5810.511895.284103@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 14:58:18 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k_htc: Fix WMI command race
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My patch "ath9k_htc: Handle WMI timeouts properly" introduced
a race condition in WMI command processing. The last issued command
should be stored _before_ issuing a WMI command. Not doing this
would result in the WMI event IRQ dropping correct command responses
as invalid.

Fix this race by storing the command id correctly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index c688545..e23172c 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -305,14 +305,14 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	wmi->cmd_rsp_buf = rsp_buf;
 	wmi->cmd_rsp_len = rsp_len;
 
-	ret = ath9k_wmi_cmd_issue(wmi, skb, cmd_id, cmd_len);
-	if (ret)
-		goto out;
-
 	spin_lock_irqsave(&wmi->wmi_lock, flags);
 	wmi->last_cmd_id = cmd_id;
 	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
+	ret = ath9k_wmi_cmd_issue(wmi, skb, cmd_id, cmd_len);
+	if (ret)
+		goto out;
+
 	time_left = wait_for_completion_timeout(&wmi->cmd_wait, timeout);
 	if (!time_left) {
 		ath_print(common, ATH_DBG_WMI,
-- 
1.7.0.5

