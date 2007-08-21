Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXHUQIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 12:08:24 -0400
Subject: [PATCH] b43: allow disabling hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 18:08:18 +0200
Message-Id: <1187712498.4218.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debugging it seems useful to be able to turn off
hardware encryption. With the changes I made to mac80211
that is now simple.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/b43/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-21 16:41:30.955923881 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-21 16:47:46.175923881 +0200
@@ -96,6 +96,10 @@ static int modparam_hwpctl;
 module_param_named(hwpctl, modparam_hwpctl, int, 0444);
 MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
 
+static int modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0644);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
@@ -2850,6 +2854,9 @@ static int b43_dev_set_key(struct ieee80
 	u8 index;
 	int err = -EINVAL;
 
+	if (modparam_nohwcrypt)
+		return -ENOSPC;
+
 	if (!dev)
 		return -ENODEV;
 	switch (key->alg) {


