Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4129 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbbGFHkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 03:40:36 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 13/13] wil6210: treat "unhandled event" as warning instead of error
Date: Mon,  6 Jul 2015 10:39:49 +0300
Message-Id: <1436168389-3676-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150706_094043_946223_6464E893)
In-Reply-To: <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

FW is allowed to generate WMI events that are not handled by this driver.
Treat such case as warning instead of error.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d3f75de..2cee5c7 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1362,7 +1362,7 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 		/* search for handler */
 		if (!wmi_evt_call_handler(wil, id, evt_data,
 					  len - sizeof(*wmi))) {
-			wil_err(wil, "Unhandled event 0x%04x\n", id);
+			wil_info(wil, "Unhandled event 0x%04x\n", id);
 		}
 	} else {
 		wil_err(wil, "Unknown event type\n");
-- 
2.1.4

