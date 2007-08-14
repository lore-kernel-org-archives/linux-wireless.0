Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50347
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765529AbXHNRA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:57 -0400
Message-Id: <20070814165747.821518000@bu3sch.de>
References: <20070814165746.863593000@bu3sch.de>
Date: Tue, 14 Aug 2007 18:57:48 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [patch 2/7] ssb: include modalias in uevent for core
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/drivers/ssb/main.c
===================================================================
--- ssb-merge-new.orig/drivers/ssb/main.c	2007-08-11 01:57:31.000000000 +0200
+++ ssb-merge-new/drivers/ssb/main.c	2007-08-11 20:26:57.000000000 +0200
@@ -317,6 +317,24 @@ static int ssb_bus_match(struct device *
 	return 0;
 }
 
+static int ssb_device_uevent(struct device *dev, char **envp, int num_envp,
+			     char *buffer, int buffer_size)
+{
+	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
+	int ret, i = 0, length = 0;
+
+	if (!dev)
+		return -ENODEV;
+
+	ret = add_uevent_var(envp, num_envp, &i,
+			     buffer, buffer_size, &length,
+			     "MODALIAS=ssb:v%.4xid%.4xrev%.2x",
+			     ssb_dev->id.vendor, ssb_dev->id.coreid,
+			     ssb_dev->id.revision);
+	envp[i] = NULL;
+	return ret;
+}
+
 static struct bus_type ssb_bustype = {
 	.name		= "ssb",
 	.match		= ssb_bus_match,
@@ -325,6 +343,7 @@ static struct bus_type ssb_bustype = {
 	.shutdown	= ssb_device_shutdown,
 	.suspend	= ssb_device_suspend,
 	.resume		= ssb_device_resume,
+	.uevent		= ssb_device_uevent,
 };
 
 static void ssb_buses_lock(void)

-- 

