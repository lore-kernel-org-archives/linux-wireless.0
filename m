Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZFGT5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 15:57:12 -0400
Subject: [PATCH] sony: fix rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 21:57:08 +0200
Message-Id: <1244404628.12956.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the rfkill conversion I added code to call
sony_nc_rfkill_set with the wrong argument, causing
a segfault Reinette reported. The compiler could not
catch that because the argument is, and needs to be,
void *.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/platform/x86/sony-laptop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/drivers/platform/x86/sony-laptop.c	2009-06-07 21:26:30.000000000 +0200
+++ wireless-testing/drivers/platform/x86/sony-laptop.c	2009-06-07 21:49:53.000000000 +0200
@@ -1135,8 +1135,7 @@ static void sony_nc_rfkill_update()
 
 		if (hwblock) {
 			if (rfkill_set_hw_state(sony_rfkill_devices[i], true))
-				sony_nc_rfkill_set(sony_rfkill_devices[i],
-						   true);
+				sony_nc_rfkill_set((void *)i, true);
 			continue;
 		}
 


