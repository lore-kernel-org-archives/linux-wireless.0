Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56819 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZIJSby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 14:31:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Force-wake queues on init
Date: Thu, 10 Sep 2009 20:31:46 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Message-Id: <200909102031.47103.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Force wake the mac80211 queues on init.
Under rare circumstances they may be stopped, if a DMA error or
something else causes a device reset while a queue was stopped.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-10 20:13:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-10 20:26:43.000000000 +0200
@@ -4326,6 +4326,8 @@ static int b43_wireless_core_init(struct
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 
+	ieee80211_wake_queues(dev->wl->hw);
+
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
 out:

-- 
Greetings, Michael.
