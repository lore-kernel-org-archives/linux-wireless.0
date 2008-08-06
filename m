Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:33222 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYHFPDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 11:03:02 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1150714nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 08:03:01 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Add module parameter to disable HW crypto
Date: Wed, 6 Aug 2008 17:27:31 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808061727.32096.IvDoorn@gmail.com> (sfid-20080806_170309_878399_01725CE3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a module parameter to rt61 and rt73 to disable
HW crypto. The option should only be checked when
determining if the SUPPORT_HW_CRYPTO flag should
be set or not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   10 +++++++++-
 drivers/net/wireless/rt2x00/rt73usb.c |   10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0fcc456..23cf93d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -38,6 +38,13 @@
 #include "rt61pci.h"
 
 /*
+ * Allow hardware encryption to be disabled.
+ */
+static int modparam_nohwcrypt = 0;
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+
+/*
  * Register access.
  * BBP and RF register require indirect register access,
  * and use the CSR registers PHY_CSR3 and PHY_CSR4 to achieve this.
@@ -2617,7 +2624,8 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
-	__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
+	if (!modparam_nohwcrypt)
+		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4f2eb90..f58fd05 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -37,6 +37,13 @@
 #include "rt73usb.h"
 
 /*
+ * Allow hardware encryption to be disabled.
+ */
+static int modparam_nohwcrypt = 0;
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+
+/*
  * Register access.
  * All access to the CSR registers will go through the methods
  * rt73usb_register_read and rt73usb_register_write.
@@ -2211,7 +2218,8 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
-	__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
+	if (!modparam_nohwcrypt)
+		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.5.6.1

