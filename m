Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58632 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122AbXCAOgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 09:36:21 -0500
Subject: [PATCH] schedule wext/rtnl for removal
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 15:35:55 +0100
Message-Id: <1172759755.11911.63.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since wext is being replaced as fast as we can (it'll probably stick
around for legacy drivers though) and the wext/netlink stuff was never
really used, this schedules it for removal.

The removal schedule is tight but there are no users of the code, the
main user of the wext user interface are the wireless-tools, they only
have an alpha version using the netlink interface and even that is
incomplete.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- linux-2.6.orig/Documentation/feature-removal-schedule.txt	2007-03-01 15:25:31.714246483 +0100
+++ linux-2.6/Documentation/feature-removal-schedule.txt	2007-03-01 15:32:23.904246483 +0100
@@ -304,3 +304,15 @@ Why:	The code says it was obsolete when 
 Who:	Richard Purdie <rpurdie@rpsys.net>
 
 ---------------------------
+
+What:	Wireless extensions over netlink (CONFIG_NET_WIRELESS_RTNETLINK)
+When:	with the merge of wireless-dev, 2.6.22 or later
+Why:	The option/code is
+	 * not enabled on most kernels
+	 * not required by any userspace tools (except an experimental one,
+	   and even there only for some parts, others use ioctl)
+	 * pointless since wext is no longer evolving and the ioctl
+	   interface needs to be kept
+Who:	Johannes Berg <johannes@sipsolutions.net>
+
+---------------------------


