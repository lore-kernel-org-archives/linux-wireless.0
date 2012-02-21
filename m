Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3610 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab2BUMON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 07:14:13 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless@vger.kernel.org
cc: "Arend van Spriel" <arend@broadcom.com>,
	"Kay Sievers" <kay.sievers@vrfy.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: [RFC v2] brcm80211: smac: remove firmware requests from
 init_module syscall
Date: Tue, 21 Feb 2012 13:13:08 +0100
Message-ID: <1329826388-4045-1-git-send-email-arend@broadcom.com> (sfid-20120221_131416_952761_094E70D3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As indicated in [1] on netdev mailing list drivers should not block
on the init_module() syscall. This patch defers the actual driver
registration to a workqueue so the init_module() syscall can complete
without delay.

[1] http://article.gmane.org/gmane.linux.network/217729/

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
I sent this earlier, but it did not end up on the wireless list as my MTA
was not properly configured. So here is the patch I came up with to avoid
udev blocking on init_module(). It is pretty straightforward, but maybe I
am overlooking things here. So feel free to comment.

Gr. AvS
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index fec0f10..712a8ba 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1173,21 +1173,27 @@ static struct bcma_driver brcms_bcma_driver = {
  * and if so, performs a brcms_attach() on it.
  *
  */
-static int __init brcms_module_init(void)
+static void brcms_driver_init(struct work_struct *work)
 {
-	int error = -ENODEV;
+	int error;
+
+	error = bcma_driver_register(&brcms_bcma_driver);
+	if (error)
+		pr_err("%s: register returned %d\n", __func__, error);
+}
 
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


