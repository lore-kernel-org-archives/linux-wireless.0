Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55219
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764752AbXHWW1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:04 -0400
Message-Id: <20070823222155.268828000@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
Date: Fri, 24 Aug 2007 00:21:56 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [patch 3/7] b43: allow disabling hardware encryption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

For debugging it seems useful to be able to turn off
hardware encryption. With the changes I made to mac80211
that is now simple.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-23 23:32:08.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-23 23:36:22.000000000 +0200
@@ -104,6 +104,10 @@ static int modparam_hwpctl;
 module_param_named(hwpctl, modparam_hwpctl, int, 0444);
 MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
 
+static int modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
@@ -2872,6 +2876,9 @@ static int b43_dev_set_key(struct ieee80
 	u8 index;
 	int err = -EINVAL;
 
+	if (modparam_nohwcrypt)
+		return -ENOSPC; /* User disabled HW-crypto */
+
 	if (!dev)
 		return -ENODEV;
 	switch (key->alg) {

-- 

