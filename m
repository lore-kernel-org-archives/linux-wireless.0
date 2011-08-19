Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40292 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1HSUMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 16:12:35 -0400
Received: by fxh19 with SMTP id 19so2150943fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 13:12:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH 3.1] bcma: add uevent to the bus, to autoload drivers
Date: Fri, 19 Aug 2011 22:14:47 +0200
Message-Id: <1313784887-29860-1-git-send-email-zajec5@gmail.com> (sfid-20110819_221240_371346_14CC48C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Rafał Miłecki <zajec5@gmail.com>
---
David: thanks for your help.

John: I believe (and David agrees) this should go as fix for 3.1.
Having (for example) b43 auto-loaded and interface created it a really
good tip for a user.
---
 drivers/bcma/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 873e2e4..73b7b1a 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -15,6 +15,7 @@ MODULE_LICENSE("GPL");
 static int bcma_bus_match(struct device *dev, struct device_driver *drv);
 static int bcma_device_probe(struct device *dev);
 static int bcma_device_remove(struct device *dev);
+static int bcma_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 
 static ssize_t manuf_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -49,6 +50,7 @@ static struct bus_type bcma_bus_type = {
 	.match		= bcma_bus_match,
 	.probe		= bcma_device_probe,
 	.remove		= bcma_device_remove,
+	.uevent		= bcma_device_uevent,
 	.dev_attrs	= bcma_device_attrs,
 };
 
@@ -227,6 +229,16 @@ static int bcma_device_remove(struct device *dev)
 	return 0;
 }
 
+static int bcma_device_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
+
+	return add_uevent_var(env,
+			      "MODALIAS=bcma:m%04Xid%04Xrev%02Xcl%02X",
+			      core->id.manuf, core->id.id,
+			      core->id.rev, core->id.class);
+}
+
 static int __init bcma_modinit(void)
 {
 	int err;
-- 
1.7.1

