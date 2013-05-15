Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47319 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3EOEwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 00:52:18 -0400
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Sivanesan Rajapupathi <c_srajap@qti.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath6kl: Rename USB driver's suspend/resume/reset_resume
Date: Wed, 15 May 2013 10:22:10 +0530
Message-ID: <1368593530-3568-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130515_065227_536050_FC0137CB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Rename USB driver's suspend/resume/reset_resume callbacks
with 'pm' prefix. This is necessary to differentiate it from
cfg80211/hif suspend/resume/reset_resume callbacks.

Cc: Sivanesan Rajapupathi <c_srajap@qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 5fcd342..f3a7a27 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1144,7 +1144,7 @@ static void ath6kl_usb_remove(struct usb_interface *interface)
 
 #ifdef CONFIG_PM
 
-static int ath6kl_usb_suspend(struct usb_interface *interface,
+static int ath6kl_usb_pm_suspend(struct usb_interface *interface,
 			      pm_message_t message)
 {
 	struct ath6kl_usb *device;
@@ -1154,7 +1154,7 @@ static int ath6kl_usb_suspend(struct usb_interface *interface,
 	return 0;
 }
 
-static int ath6kl_usb_resume(struct usb_interface *interface)
+static int ath6kl_usb_pm_resume(struct usb_interface *interface)
 {
 	struct ath6kl_usb *device;
 	device = usb_get_intfdata(interface);
@@ -1167,7 +1167,7 @@ static int ath6kl_usb_resume(struct usb_interface *interface)
 	return 0;
 }
 
-static int ath6kl_usb_reset_resume(struct usb_interface *intf)
+static int ath6kl_usb_pm_reset_resume(struct usb_interface *intf)
 {
 	if (usb_get_intfdata(intf))
 		ath6kl_usb_remove(intf);
@@ -1176,9 +1176,9 @@ static int ath6kl_usb_reset_resume(struct usb_interface *intf)
 
 #else
 
-#define ath6kl_usb_suspend NULL
-#define ath6kl_usb_resume NULL
-#define ath6kl_usb_reset_resume NULL
+#define ath6kl_usb_pm_suspend NULL
+#define ath6kl_usb_pm_resume NULL
+#define ath6kl_usb_pm_reset_resume NULL
 
 #endif
 
@@ -1193,9 +1193,9 @@ MODULE_DEVICE_TABLE(usb, ath6kl_usb_ids);
 static struct usb_driver ath6kl_usb_driver = {
 	.name = "ath6kl_usb",
 	.probe = ath6kl_usb_probe,
-	.suspend = ath6kl_usb_suspend,
-	.resume = ath6kl_usb_resume,
-	.reset_resume = ath6kl_usb_reset_resume,
+	.suspend = ath6kl_usb_pm_suspend,
+	.resume = ath6kl_usb_pm_resume,
+	.reset_resume = ath6kl_usb_pm_reset_resume,
 	.disconnect = ath6kl_usb_remove,
 	.id_table = ath6kl_usb_ids,
 	.supports_autosuspend = true,
-- 
1.7.9.5

