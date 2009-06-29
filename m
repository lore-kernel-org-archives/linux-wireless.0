Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbZF2Ixy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 04:53:54 -0400
Subject: [PATCH 2.6.31] hp-wmi: fix rfkill bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Frans Pop <elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 10:53:53 +0200
Message-Id: <1246265633.7775.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the third (I think) polarity error I accidentally
introduced in the rfkill rewrite to make wireless work
again on (certain?) HP laptops.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
---
 drivers/platform/x86/hp-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/platform/x86/hp-wmi.c	2009-06-29 10:51:45.000000000 +0200
+++ wireless-testing/drivers/platform/x86/hp-wmi.c	2009-06-29 10:51:55.000000000 +0200
@@ -157,7 +157,7 @@ static int hp_wmi_dock_state(void)
 static int hp_wmi_set_block(void *data, bool blocked)
 {
 	unsigned long b = (unsigned long) data;
-	int query = BIT(b + 8) | ((!!blocked) << b);
+	int query = BIT(b + 8) | ((!blocked) << b);
 
 	return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, query);
 }


