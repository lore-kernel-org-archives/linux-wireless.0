Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59251 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753542AbbFLOBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 10:01:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: aspriel@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2015 17:00:42 +0300
Message-Id: <1434117644-3033-3-git-send-email-luca@coelho.fi> (sfid-20150612_160106_830286_C4405808)
In-Reply-To: <1434117644-3033-1-git-send-email-luca@coelho.fi>
References: <1434117644-3033-1-git-send-email-luca@coelho.fi>
Subject: [PATCH py80211 2/4] py80211: scan: add sched_scan start class
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add a class to start scheduled scans.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 lib/scan.py | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/lib/scan.py b/lib/scan.py
index 5ccae55..bfaf4da 100644
--- a/lib/scan.py
+++ b/lib/scan.py
@@ -123,6 +123,7 @@ class scan_start_base(scan_cmd_base):
 		self._flags = 0
 		self._ies = None
                 self._nl_cmd = None
+                self._interval = None
 
         def _add_scan_attrs(self):
 		if self._ssids:
@@ -144,6 +145,9 @@ class scan_start_base(scan_cmd_base):
 		if self._ies:
 			nl.nla_put(self._nl_msg._msg, nl80211.ATTR_IE, self._ies)
 
+                if self._interval != None:
+                        nl.nla_put_u32(self._nl_msg._msg, nl80211.ATTR_SCHED_SCAN_INTERVAL, self._interval)
+
 	def add_ssids(self, ssids):
 		if self._ssids == None:
 			self._ssids = ssids
@@ -183,3 +187,19 @@ class scan_request(scan_start_base):
 		if genlh.cmd in [ nl80211.CMD_SCAN_ABORTED, nl80211.CMD_NEW_SCAN_RESULTS ]:
 			self.scan_busy = False
 		return nl.NL_SKIP
+
+class sched_scan_start(scan_start_base):
+	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
+                super(sched_scan_start, self).__init__(ifidx, level)
+                self._nl_cmd = nl80211.CMD_START_SCHED_SCAN
+
+	def set_interval(self, interval):
+		self._interval = interval
+
+        def handle(self, msg, arg):
+		genlh = genl.genlmsg_hdr(nl.nlmsg_hdr(msg))
+
+                # A schedule scan is complete immediately when it gets started
+                if genlh.cmd in [ nl80211.CMD_START_SCHED_SCAN ]:
+                        self.scan_busy = False
+		return nl.NL_SKIP
-- 
2.1.4

