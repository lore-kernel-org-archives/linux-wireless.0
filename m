Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out-171.synserver.de ([212.40.185.171]:1075 "EHLO
	smtp-out-171.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbEPMaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 08:30:39 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] net: rfkill: Switch to PM ops
Date: Sat, 16 May 2015 14:23:55 +0200
Message-Id: <1431779035-5256-1-git-send-email-lars@metafoo.de> (sfid-20150516_143043_304177_66DC4C11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dev_pm_ops instead of the legacy suspend/resume callbacks for the
rfkill class suspend and resume operations.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 net/rfkill/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index fa7cd79..f12149a 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -794,7 +794,8 @@ void rfkill_resume_polling(struct rfkill *rfkill)
 }
 EXPORT_SYMBOL(rfkill_resume_polling);
 
-static int rfkill_suspend(struct device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int rfkill_suspend(struct device *dev)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
@@ -818,13 +819,18 @@ static int rfkill_resume(struct device *dev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(rfkill_pm_ops, rfkill_suspend, rfkill_resume);
+#define RFKILL_PM_OPS (&rfkill_pm_ops)
+#else
+#define RFKILL_PM_OPS NULL
+#endif
+
 static struct class rfkill_class = {
 	.name		= "rfkill",
 	.dev_release	= rfkill_release,
 	.dev_groups	= rfkill_dev_groups,
 	.dev_uevent	= rfkill_dev_uevent,
-	.suspend	= rfkill_suspend,
-	.resume		= rfkill_resume,
+	.pm		= RFKILL_PM_OPS,
 };
 
 bool rfkill_blocked(struct rfkill *rfkill)
-- 
1.8.0

