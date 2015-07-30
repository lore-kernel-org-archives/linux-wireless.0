Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24801 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbbG3Kyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:44 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 10/19] wil6210: treat "unhandled event" as warning instead of error
Date: Thu, 30 Jul 2015 13:51:58 +0300
Message-Id: <1438253527-3372-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_130716_418988_7998999A)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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
index 349f14a..fbcea83 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1340,7 +1340,7 @@ static void wmi_event_handle(struct wil6210_priv *wil,
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

