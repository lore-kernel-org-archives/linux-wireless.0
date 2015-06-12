Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59257 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753726AbbFLOBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 10:01:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: aspriel@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2015 17:00:44 +0300
Message-Id: <1434117644-3033-5-git-send-email-luca@coelho.fi> (sfid-20150612_160111_314639_D6AB4FC9)
In-Reply-To: <1434117644-3033-1-git-send-email-luca@coelho.fi>
References: <1434117644-3033-1-git-send-email-luca@coelho.fi>
Subject: [PATCH py80211 4/4] py80211: scan: add matchsets support for scheduled scans
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Modify the sched_scan_start class so that the caller can pass a list
of matches to be used in the scheduled scan request.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 lib/scan.py | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/lib/scan.py b/lib/scan.py
index bfaf3d2..b55d148 100644
--- a/lib/scan.py
+++ b/lib/scan.py
@@ -192,10 +192,34 @@ class sched_scan_start(scan_start_base):
 	def __init__(self, ifidx, level=nl.NL_CB_DEFAULT):
                 super(sched_scan_start, self).__init__(ifidx, level)
                 self._nl_cmd = nl80211.CMD_START_SCHED_SCAN
+                self._matches = None
 
 	def set_interval(self, interval):
 		self._interval = interval
 
+        def add_matches(self, matches):
+                self._matches = matches
+
+        def _add_matches_attrs(self):
+		if self._matches:
+			i = 0
+
+                        matchset = nl.nla_nest_start(self._nl_msg._msg, nl80211.ATTR_SCHED_SCAN_MATCH)
+			for match in self._matches:
+                                nest = nl.nla_nest_start(self._nl_msg._msg, i)
+                                if 'ssid' in match:
+                                        nl.nla_put(self._nl_msg._msg, nl80211.SCHED_SCAN_MATCH_ATTR_SSID, match['ssid'])
+				i += 1
+                                nl.nla_nest_end(self._nl_msg._msg, nest)
+
+                        nl.nla_nest_end(self._nl_msg._msg, matchset)
+
+        def send(self):
+                self._prepare_cmd()
+                self._add_scan_attrs()
+                self._add_matches_attrs()
+                self._send_and_wait()
+
         def handle(self, msg, arg):
 		genlh = genl.genlmsg_hdr(nl.nlmsg_hdr(msg))
 
-- 
2.1.4

