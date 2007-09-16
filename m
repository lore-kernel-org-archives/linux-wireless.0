Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXIPMIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:36 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:35 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/24] rt2x00: Add better CONFIG_PM checks
Date: Sun, 16 Sep 2007 14:19:34 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.36297.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put rt2x00lib suspend/resume handlers inside CONFIG_PM defines,
also declare rt2x00{pci,usb}_suspend/resume NULL when CONFIG_PM
is not not defined. This safes macro checks inside the drivers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 --
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 --
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 --
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 ++
 drivers/net/wireless/rt2x00/rt2x00pci.h |    3 +++
 drivers/net/wireless/rt2x00/rt2x00usb.h |    3 +++
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 --
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 --
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 28236dc..38e2188 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1671,10 +1671,8 @@ static struct pci_driver rt2400pci_driver = {
 	.id_table	= rt2400pci_device_table,
 	.probe		= rt2x00pci_probe,
 	.remove		= __devexit_p(rt2x00pci_remove),
-#ifdef CONFIG_PM
 	.suspend	= rt2x00pci_suspend,
 	.resume		= rt2x00pci_resume,
-#endif /* CONFIG_PM */
 };
 
 static int __init rt2400pci_init(void)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index fc28631..f6115c6 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1982,10 +1982,8 @@ static struct pci_driver rt2500pci_driver = {
 	.id_table	= rt2500pci_device_table,
 	.probe		= rt2x00pci_probe,
 	.remove		= __devexit_p(rt2x00pci_remove),
-#ifdef CONFIG_PM
 	.suspend	= rt2x00pci_suspend,
 	.resume		= rt2x00pci_resume,
-#endif /* CONFIG_PM */
 };
 
 static int __init rt2500pci_init(void)
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 5bdf64f..847bd7f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1819,10 +1819,8 @@ static struct usb_driver rt2500usb_driver = {
 	.id_table	= rt2500usb_device_table,
 	.probe		= rt2x00usb_probe,
 	.disconnect	= rt2x00usb_disconnect,
-#ifdef CONFIG_PM
 	.suspend	= rt2x00usb_suspend,
 	.resume		= rt2x00usb_resume,
-#endif /* CONFIG_PM */
 };
 
 static int __init rt2500usb_init(void)
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b5f408c..c18875b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -797,7 +797,9 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue,
  */
 int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev);
+#ifdef CONFIG_PM
 int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state);
 int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev);
+#endif /* CONFIG_PM */
 
 #endif /* RT2X00_H */
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6992727..c0bdf63 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1106,6 +1106,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 /*
  * Device state handlers
  */
+#ifdef CONFIG_PM
 int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 {
 	int retval;
@@ -1184,6 +1185,7 @@ exit:
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_resume);
+#endif /* CONFIG_PM */
 
 /*
  * rt2x00lib module information.
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 0a8b680..82adeac 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -119,6 +119,9 @@ void rt2x00pci_remove(struct pci_dev *pci_dev);
 #ifdef CONFIG_PM
 int rt2x00pci_suspend(struct pci_dev *pci_dev, pm_message_t state);
 int rt2x00pci_resume(struct pci_dev *pci_dev);
+#else
+#define rt2x00pci_suspend	NULL
+#define rt2x00pci_resume	NULL
 #endif /* CONFIG_PM */
 
 #endif /* RT2X00PCI_H */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index f3be092..d4113e5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -172,6 +172,9 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf);
 #ifdef CONFIG_PM
 int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state);
 int rt2x00usb_resume(struct usb_interface *usb_intf);
+#else
+#define rt2x00usb_suspend	NULL
+#define rt2x00usb_resume	NULL
 #endif /* CONFIG_PM */
 
 #endif /* RT2X00USB_H */
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6baa651..730bed5 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2585,10 +2585,8 @@ static struct pci_driver rt61pci_driver = {
 	.id_table	= rt61pci_device_table,
 	.probe		= rt2x00pci_probe,
 	.remove		= __devexit_p(rt2x00pci_remove),
-#ifdef CONFIG_PM
 	.suspend	= rt2x00pci_suspend,
 	.resume		= rt2x00pci_resume,
-#endif /* CONFIG_PM */
 };
 
 static int __init rt61pci_init(void)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f7017a8..b047c7c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2106,10 +2106,8 @@ static struct usb_driver rt73usb_driver = {
 	.id_table	= rt73usb_device_table,
 	.probe		= rt2x00usb_probe,
 	.disconnect	= rt2x00usb_disconnect,
-#ifdef CONFIG_PM
 	.suspend	= rt2x00usb_suspend,
 	.resume		= rt2x00usb_resume,
-#endif /* CONFIG_PM */
 };
 
 static int __init rt73usb_init(void)
-- 
1.5.3
