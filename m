Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3834 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYGBPQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 11:16:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] hostap_cs: correct poor NULL checks in suspend/resume routines
Date: Wed,  2 Jul 2008 11:08:23 -0400
Message-Id: <1215011303-21589-1-git-send-email-linville@tuxdriver.com> (sfid-20080702_171658_489876_9FEFB595)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This corrects this kernel.org bug:

	http://bugzilla.kernel.org/show_bug.cgi?id=9701

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Not too sure if that is the appropriate error code.  Comments?

 drivers/net/wireless/hostap/hostap_cs.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 80039a0..3b4e55c 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -777,8 +777,10 @@ static int hostap_cs_suspend(struct pcmcia_device *link)
 	int dev_open = 0;
 	struct hostap_interface *iface = NULL;
 
-	if (dev)
-		iface = netdev_priv(dev);
+	if (!dev)
+		return -ENODEV;
+
+	iface = netdev_priv(dev);
 
 	PDEBUG(DEBUG_EXTRA, "%s: CS_EVENT_PM_SUSPEND\n", dev_info);
 	if (iface && iface->local)
@@ -798,8 +800,10 @@ static int hostap_cs_resume(struct pcmcia_device *link)
 	int dev_open = 0;
 	struct hostap_interface *iface = NULL;
 
-	if (dev)
-		iface = netdev_priv(dev);
+	if (!dev)
+		return -ENODEV;
+
+	iface = netdev_priv(dev);
 
 	PDEBUG(DEBUG_EXTRA, "%s: CS_EVENT_PM_RESUME\n", dev_info);
 
-- 
1.5.5.1

