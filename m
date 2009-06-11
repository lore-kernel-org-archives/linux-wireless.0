Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761852AbZFKKHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 06:07:41 -0400
Subject: [PATCH 2.6.31] sony: fix rfkill code again
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 12:08:15 +0200
Message-Id: <1244714895.4706.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the hard state changes, we shouldn't set the soft
state to blocked as well -- we have no such indication
from the device in that case so leave it untouched.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=13458.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
---
Thanks Reinette!

 drivers/platform/x86/sony-laptop.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/platform/x86/sony-laptop.c	2009-06-11 11:00:44.000000000 +0200
+++ wireless-testing/drivers/platform/x86/sony-laptop.c	2009-06-11 12:05:52.000000000 +0200
@@ -1133,8 +1133,9 @@ static void sony_nc_rfkill_update()
 			continue;
 
 		if (hwblock) {
-			if (rfkill_set_hw_state(sony_rfkill_devices[i], true))
-				sony_nc_rfkill_set((void *)i, true);
+			if (rfkill_set_hw_state(sony_rfkill_devices[i], true)) {
+				/* we already know we're blocked */
+			}
 			continue;
 		}
 


