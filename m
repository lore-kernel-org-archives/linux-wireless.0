Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32944 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755973AbbFPHdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:33:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: aspriel@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 16 Jun 2015 10:32:38 +0300
Message-Id: <1434439958-9447-1-git-send-email-luca@coelho.fi> (sfid-20150616_093329_118019_B455080A)
Subject: [PATCH py80211] py80211: scan: fix call to _add_scan_attrs() in the sched_scan_start class
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We should not pass self explicitly when calling the superclass's
_add_scan_attrs() in the sched_scan_start class.  Fix it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 lib/scan.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scan.py b/lib/scan.py
index 32cb68b..3ce242e 100644
--- a/lib/scan.py
+++ b/lib/scan.py
@@ -191,7 +191,7 @@ class sched_scan_start(scan_start_base):
 		self._matches = None
 
 	def _add_scan_attrs(self):
-		super(sched_scan_start, self)._add_scan_attrs(self)
+		super(sched_scan_start, self)._add_scan_attrs()
 		if self._interval != None:
 			nl.nla_put_u32(self._nl_msg._msg, nl80211.ATTR_SCHED_SCAN_INTERVAL, self._interval)
 
-- 
2.1.4

