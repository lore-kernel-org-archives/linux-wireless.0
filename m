Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbZFCISH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 04:18:07 -0400
Subject: [PATCH] rfkill: document /dev/rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 10:17:59 +0200
Message-Id: <1244017079.10665.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some blurb about /dev/rfkill to the documentation and
fix the "transmiter" spelling error.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/rfkill.txt |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- wireless-testing.orig/Documentation/rfkill.txt	2009-06-03 10:14:56.000000000 +0200
+++ wireless-testing/Documentation/rfkill.txt	2009-06-03 10:16:41.000000000 +0200
@@ -113,7 +113,7 @@ The following sysfs entries exist for ev
 		0: RFKILL_STATE_SOFT_BLOCKED
 			transmitter is turned off by software
 		1: RFKILL_STATE_UNBLOCKED
-			transmiter is (potentially) active
+			transmitter is (potentially) active
 		2: RFKILL_STATE_HARD_BLOCKED
 			transmitter is forced off by something outside of
 			the driver's control.
@@ -128,3 +128,9 @@ RFKILL_TYPE
 
 The contents of these variables corresponds to the "name", "state" and
 "type" sysfs files explained above.
+
+An alternative userspace interface exists as a misc device /dev/rfkill,
+which allows userspace to obtain and set the state of rfkill devices and
+sets of devices. It also notifies userspace about device addition and
+removal. The API is a simple read/write API that is defined in
+linux/rfkill.h.


