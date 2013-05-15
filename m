Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41445 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3EOEwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 00:52:32 -0400
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Sivanesan Rajapupathi <c_srajap@qti.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath6kl: Fix a suspend/resume crash in AR6004 USB
Date: Wed, 15 May 2013 10:22:24 +0530
Message-ID: <1368593544-3612-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130515_065235_098924_77529BF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

cfg80211 suspend/resume callbacks are not yet implemented
for AR6004 USB. Introduce dummy handlers for these to avoid
NULL pointer dereference.

Cc: Sivanesan Rajapupathi <c_srajap@qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index f3a7a27..6eea296 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1053,6 +1053,22 @@ static void ath6kl_usb_cleanup_scatter(struct ath6kl *ar)
 	return;
 }
 
+static int ath6kl_usb_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+{
+	/*
+	 * cfg80211 suspend/WOW currently not supported for USB.
+	 */
+	return 0;
+}
+
+static int ath6kl_usb_resume(struct ath6kl *ar)
+{
+	/*
+	 * cfg80211 resume currently not supported for USB.
+	 */
+	return 0;
+}
+
 static const struct ath6kl_hif_ops ath6kl_usb_ops = {
 	.diag_read32 = ath6kl_usb_diag_read32,
 	.diag_write32 = ath6kl_usb_diag_write32,
@@ -1066,6 +1082,8 @@ static const struct ath6kl_hif_ops ath6kl_usb_ops = {
 	.pipe_map_service = ath6kl_usb_map_service_pipe,
 	.pipe_get_free_queue_number = ath6kl_usb_get_free_queue_number,
 	.cleanup_scatter = ath6kl_usb_cleanup_scatter,
+	.suspend = ath6kl_usb_suspend,
+	.resume = ath6kl_usb_resume,
 };
 
 /* ath6kl usb driver registered functions */
-- 
1.7.9.5

