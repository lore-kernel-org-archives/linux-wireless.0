Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59254 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbbFLOBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 10:01:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: aspriel@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2015 17:00:43 +0300
Message-Id: <1434117644-3033-4-git-send-email-luca@coelho.fi> (sfid-20150612_160105_422872_905FBB57)
In-Reply-To: <1434117644-3033-1-git-send-email-luca@coelho.fi>
References: <1434117644-3033-1-git-send-email-luca@coelho.fi>
Subject: [PATCH py80211 3/4] py80211: add sched_scan stop class
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add a class to stop scheduled scans.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 lib/scan.py | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/lib/scan.py b/lib/scan.py
index bfaf4da..bfaf3d2 100644
--- a/lib/scan.py
+++ b/lib/scan.py
@@ -203,3 +203,18 @@ class sched_scan_start(scan_start_base):
                 if genlh.cmd in [ nl80211.CMD_START_SCHED_SCAN ]:
                         self.scan_busy = False
 		return nl.NL_SKIP
+
+class sched_scan_stop(scan_cmd_base):
+	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
+                super(sched_scan_stop, self).__init__(ifidx, level)
+                self._nl_cmd = nl80211.CMD_STOP_SCHED_SCAN
+
+        def send(self):
+                self._prepare_cmd()
+                self._send_and_wait()
+
+        def handle(self, msg, arg):
+		genlh = genl.genlmsg_hdr(nl.nlmsg_hdr(msg))
+                if genlh.cmd in [ nl80211.CMD_SCHED_SCAN_STOPPED ]:
+                        self.scan_busy = False
+		return nl.NL_SKIP
-- 
2.1.4

