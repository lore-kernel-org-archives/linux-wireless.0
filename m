Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZFHGOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 02:14:35 -0400
Subject: [PATCH v2] rfkill: remove input Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244420209.23850.111.camel@localhost.localdomain>
References: <1244396398.12956.12.camel@johannes.local>
	 <1244420209.23850.111.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 08:14:28 +0200
Message-Id: <1244441668.4188.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we added the ioctl, there's no need to ask
the user to configure this. We will keep it enabled
for now, and eventually swap the default to n. Also
let embedded users select it only if they need it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: Turn default back to N for embedded, and make the question itself
    depend on embedded.

 net/rfkill/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/rfkill/Kconfig	2009-06-07 21:26:29.000000000 +0200
+++ wireless-testing/net/rfkill/Kconfig	2009-06-08 08:11:15.000000000 +0200
@@ -18,7 +18,7 @@ config RFKILL_LEDS
 	default y
 
 config RFKILL_INPUT
-	bool "RF switch input support"
+	bool "RF switch input support" if EMBEDDED
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
 	default y if !EMBEDDED


