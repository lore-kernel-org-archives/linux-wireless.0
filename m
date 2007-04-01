Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:56722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbXDAOCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2007 10:02:38 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1294449uga
        for <linux-wireless@vger.kernel.org>; Sun, 01 Apr 2007 07:02:38 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Correctly enable the radio
Date: Sun, 1 Apr 2007 16:01:58 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704011601.58115.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DEVICE_ENABLED_RADIO_HW flag was accidently added,
this flag is only used (and set correctly) with the rfkill patch
applied to it.
WIthout the rfkill patch this will only prevent the radio to be
enabled for PCI devices.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index f8a9867..f296fda 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1228,8 +1228,7 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Don't enable the radio twice.
 	 * or if the hardware button has been disabled.
 	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
-	    !GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO_HW))
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return 0;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index bddbbf9..4fff8db 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1354,8 +1354,7 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Don't enable the radio twice,
 	 * or if the hardware button has been disabled.
 	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
-	    !GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO_HW))
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return 0;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index cea6bb1..38fae66 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -777,7 +777,7 @@ struct rt2x00_dev {
 	 */
 	unsigned int flags;
 #define DEVICE_ENABLED_RADIO		0x00000001
-#define DEVICE_ENABLED_RADIO_HW		0x00000002
+
 #define DEVICE_INITIALIZED		0x00000004
 #define DEVICE_INITIALIZED_HW		0x00000008
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 9cee93f..92a7c71 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1635,8 +1635,7 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Don't enable the radio twice.
 	 * or if the hardware button has been disabled.
 	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
-	    !GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO_HW))
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return 0;
 
 	/*
