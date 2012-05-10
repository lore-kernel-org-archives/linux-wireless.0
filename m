Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:48495 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab2EJRW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 13:22:59 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SSX4r-0005pp-Pl
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 19:22:57 +0200
Received: from localhost ([::1]:36023 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SSX4r-0004vq-Lp
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 19:22:57 +0200
Received: from [195.4.92.24] (port=51421 helo=14.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SSX2f-0003wj-Hu
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 19:20:41 +0200
Received: from [2002:4fde:713:2:5054:ff:feb8:40bd] (port=35528 helo=mail.maya.org)
	by 14.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SSX2f-0005NV-6Q
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 19:20:41 +0200
Message-Id: <201205101720.q4AHKTZp003261@mail.maya.org> (sfid-20120510_192308_310950_B694C668)
Date: Thu, 10 May 2012 19:20:27 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH][RFC/RFT] rt2800: Enable support for 802.11w (MFP)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for 802.11w for rt2800. This is achieved by
using the 802.11w implementation in mac80211.

To get this working, it is necessary that hw encryption of
rt2800pci / rt2800usb is disabled, because I don't know of any support
in hardware for 802.11w and therefore let mac80211 do the whole job.

The user can enable 802.11w support by disabling hw encryption by
setting module parameter nohwcrypt=1.

Tested with rt2860 and rt3572.

This is a workaround as long as there isn't hardware support implemented
in the driver.

Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>
---
diff -ru compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800pci.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800pci.c
--- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800pci.c	2012-04-26 22:10:30.000000000 +0200
+++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800pci.c	2012-05-10 19:06:51.813040835 +0200
@@ -52,7 +52,7 @@
  */
 static bool modparam_nohwcrypt = false;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
-MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption. Enable MFP (802.11w)");
 
 static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 {
@@ -1020,6 +1020,11 @@
 	__set_bit(REQUIRE_TASKLET_CONTEXT, &rt2x00dev->cap_flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
+	else {
+		INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
+		rt2x00dev->hw->flags |=
+		    IEEE80211_HW_MFP_CAPABLE;
+	}
 	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
 
diff -ru compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800usb.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800usb.c
--- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800usb.c	2012-04-26 22:10:30.000000000 +0200
+++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800usb.c	2012-05-10 19:08:06.642042805 +0200
@@ -47,7 +47,7 @@
  */
 static bool modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
-MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption. Enable MFP (802.11w).");
 
 /*
  * Queue handlers.
@@ -769,6 +769,11 @@
 	__set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
+	else {
+		INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
+		rt2x00dev->hw->flags |=
+		    IEEE80211_HW_MFP_CAPABLE;
+	}
 	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
