Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:49360 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab2EJHXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:23:08 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SSNiL-0006cH-N2
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 09:23:05 +0200
Received: from localhost ([::1]:49385 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SSNiL-0003VT-JK
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 09:23:05 +0200
Received: from [195.4.92.27] (port=44772 helo=17.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SSNfS-00021F-Bu
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 09:20:06 +0200
Received: from [2002:4fde:1bf:2:5054:ff:feb8:40bd] (port=46884 helo=mail.maya.org)
	by 17.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SSNfR-0003mE-GZ
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 09:20:05 +0200
Message-Id: <201205100719.q4A7JwVl003140@mail.maya.org> (sfid-20120510_092312_902246_F52D3B41)
Date: Thu, 10 May 2012 09:19:56 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH][RFC/RFT] rt2800: Implement selectable support for 802.11w
 (MFP)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for 802.11w for rt2800. This is achieved by
using the 802.11w implementation in mac80211.

To get this working, it is necessary to disable hw encryption of
rt2800pci / rt2800usb, because I don't know of any support in hardware
for 802.11w and therefore let mac80211 do the whole job.

The user can enable 802.11w with the new mod parameter enablemfp.
Enabling MFP disables hw encryption.

802.11w is deactivated per default.

Tested with rt2860 and rt3572.

This is a workaround as long as there isn't hardware support implemented
in the driver.

Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>
---
diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c
--- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c	2012-04-26 22:10:30.000000000 +0200
+++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c	2012-05-09 11:37:48.463278177 +0200
@@ -4519,6 +4519,15 @@
 	    IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
+	/* 
+	 * Enable support for 802.11w in mac80211. hwencryption must be disabled
+	 */
+	if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags) && rt2x00dev->mfprequested) {
+		INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
+		rt2x00dev->hw->flags |=
+			IEEE80211_HW_MFP_CAPABLE;
+	}
+
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
 	 * unless we are capable of sending the buffered frames out after the
diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800pci.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800pci.c
--- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800pci.c	2012-04-26 22:10:30.000000000 +0200
+++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800pci.c	2012-05-09 13:29:47.159979903 +0200
@@ -54,6 +54,13 @@
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
+/*
+ * Enable support for 802.11w / MFP
+ */
+static bool modparam_enablemfp = false;
+module_param_named(enablemfp, modparam_enablemfp, bool, S_IRUGO);
+MODULE_PARM_DESC(enablemfp, "Enable 802.11w / MFP support. Hardware encryption gets disabled.");
+
 static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 {
 	unsigned int i;
@@ -989,6 +996,8 @@
 	if (retval)
 		return retval;
 
+	rt2x00dev->mfprequested = modparam_enablemfp ? 1 : 0;
+
 	/*
 	 * Initialize hw specifications.
 	 */
@@ -1018,8 +1027,14 @@
 	__set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_TASKLET_CONTEXT, &rt2x00dev->cap_flags);
-	if (!modparam_nohwcrypt)
+
+	if (!modparam_nohwcrypt && !modparam_enablemfp) {
+		INFO(rt2x00dev, "hw encryption enabled.\n");
 		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
+		}
+	else
+		INFO(rt2x00dev, "hw encryption disabled. See modparams nohwcrypt or enablemfp.\n");
+
 	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
 
diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800usb.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800usb.c
--- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800usb.c	2012-04-26 22:10:30.000000000 +0200
+++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800usb.c	2012-05-09 13:38:26.633954818 +0200
@@ -50,6 +50,13 @@
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 /*
+ * Allow support for 802.11w / MFP to be enabled
+ */
+static bool modparam_enablemfp = false;
+module_param_named(enablemfp, modparam_enablemfp, bool, S_IRUGO);
+MODULE_PARM_DESC(enablemfp, "Enable 802.11w / MFP support. Hardware encryption gets disabled.");
+
+/*
  * Queue handlers.
  */
 static void rt2800usb_start_queue(struct data_queue *queue)
@@ -748,6 +755,8 @@
 	if (retval)
 		return retval;
 
+	rt2x00dev->mfprequested = modparam_enablemfp ? 1 : 0;
+
 	/*
 	 * Initialize hw specifications.
 	 */
@@ -767,8 +776,14 @@
 	 */
 	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
-	if (!modparam_nohwcrypt)
+
+	if (!modparam_nohwcrypt && !modparam_enablemfp) {
+		INFO(rt2x00dev, "hw encryption enabled.\n");
 		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
+	}
+	else
+		INFO(rt2x00dev, "hw encryption disabled. See modparams nohwcrypt or enablemfp.\n");
+
 	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2x00.h compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2x00.h
--- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2x00.h	2012-04-26 22:10:30.000000000 +0200
+++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2x00.h	2012-05-09 11:10:56.733118518 +0200
@@ -821,6 +821,11 @@
 	struct hw_mode_spec spec;
 
 	/*
+	 * 802.11w (MFP) support requested by module parameter
+	 */
+	u8 mfprequested;
+
+	/*
 	 * This is the default TX/RX antenna setup as indicated
 	 * by the device's EEPROM.
 	 */
