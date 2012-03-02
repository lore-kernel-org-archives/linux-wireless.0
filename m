Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4377 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2CBV4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:13 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 6/7] brcm80211: smac: remove firmware requests from
 init_module syscall
Date: Fri, 2 Mar 2012 22:55:50 +0100
Message-ID: <1330725351-3803-7-git-send-email-arend@broadcom.com> (sfid-20120302_225620_823700_A356A5EA)
In-Reply-To: <1330725351-3803-1-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As indicated in [1] on netdev mailing list drivers should not block
on the init_module() syscall. This patch defers the actual driver
registration to a workqueue so the init_module() syscall can complete
without delay.

[1] http://article.gmane.org/gmane.linux.network/217729/

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   31 ++++++++++++-------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index fec0f10..569ab8a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1169,25 +1169,31 @@ static struct bcma_driver brcms_bcma_driver = {
 /**
  * This is the main entry point for the brcmsmac driver.
  *
- * This function determines if a device pointed to by pdev is a WL device,
- * and if so, performs a brcms_attach() on it.
- *
+ * This function is scheduled upon module initialization and
+ * does the driver registration, which result in brcms_bcma_probe()
+ * call resulting in the driver bringup.
  */
-static int __init brcms_module_init(void)
+static void brcms_driver_init(struct work_struct *work)
 {
-	int error = -ENODEV;
+	int error;
 
+	error = bcma_driver_register(&brcms_bcma_driver);
+	if (error)
+		pr_err("%s: register returned %d\n", __func__, error);
+}
+
+static DECLARE_WORK(brcms_driver_work, brcms_driver_init);
+
+static int __init brcms_module_init(void)
+{
 #ifdef DEBUG
 	if (msglevel != 0xdeadbeef)
 		brcm_msg_level = msglevel;
-#endif				/* DEBUG */
-
-	error = bcma_driver_register(&brcms_bcma_driver);
-	pr_err("%s: register returned %d\n", __func__, error);
-	if (!error)
-		return 0;
+#endif
+	if (!schedule_work(&brcms_driver_work))
+		return -EBUSY;
 
-	return error;
+	return 0;
 }
 
 /**
@@ -1199,6 +1205,7 @@ static int __init brcms_module_init(void)
  */
 static void __exit brcms_module_exit(void)
 {
+	cancel_work_sync(&brcms_driver_work);
 	bcma_driver_unregister(&brcms_bcma_driver);
 }
 
-- 
1.7.5.4


