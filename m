Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZFOO21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 10:28:27 -0400
Subject: [PATCH] dell-laptop: fix rfkill conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 16:26:47 +0200
Message-Id: <1245076007.23912.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A polarity error snuck into the rfkill rewrite's dell-laptop
conversion, fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Oliver Hartkopp <oliver@hartkopp.net>
---
 drivers/platform/x86/dell-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/platform/x86/dell-laptop.c	2009-06-15 14:23:25.000000000 +0200
+++ wireless-testing/drivers/platform/x86/dell-laptop.c	2009-06-15 14:23:35.000000000 +0200
@@ -177,7 +177,7 @@ dell_send_request(struct calling_interfa
 static int dell_rfkill_set(void *data, bool blocked)
 {
 	struct calling_interface_buffer buffer;
-	int disable = blocked ? 0 : 1;
+	int disable = blocked ? 1 : 0;
 	unsigned long radio = (unsigned long)data;
 
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));


