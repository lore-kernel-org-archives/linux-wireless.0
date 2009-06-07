Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbZFGRj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 13:39:59 -0400
Subject: [PATCH] rfkill: remove input Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 19:39:58 +0200
Message-Id: <1244396398.12956.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we added the ioctl, there's no need to ask
the user to configure this. We will keept it enabled
for now, and eventually swap the default to n, maybe
let people configure it under EMBEDDED or so. In any
case, there's no need to bother users with this now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/rfkill/Kconfig	2009-06-07 19:37:34.000000000 +0200
+++ wireless-testing/net/rfkill/Kconfig	2009-06-07 19:37:41.000000000 +0200
@@ -18,7 +18,7 @@ config RFKILL_LEDS
 	default y
 
 config RFKILL_INPUT
-	bool "RF switch input support"
+	bool
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
-	default y if !EMBEDDED
+	default y


