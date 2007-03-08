Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:9792 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbXCHVPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 16:15:07 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1088710uga
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2007 13:15:06 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/4] rt2x00: Remove ieee80211_netif_oper usage
Date: Thu, 8 Mar 2007 22:14:51 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703082214.52070.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the ieee80211_netif_oper usage from rt2x00.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index ff5d67a..f8a9867 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1278,7 +1278,6 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2400pci_enable_led(rt2x00dev);
 
 	ieee80211_start_queues(rt2x00dev->hw);
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_WAKE);
 
 	return 0;
 
@@ -1294,7 +1293,6 @@ static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
 
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_STOP);
 	ieee80211_stop_queues(rt2x00dev->hw);
 
 	/*
@@ -2418,8 +2416,6 @@ static int rt2400pci_probe(struct pci_dev *pci_dev,
 		goto exit_free_device;
 	}
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 
 exit_free_device:
@@ -2445,7 +2441,6 @@ static void rt2400pci_remove(struct pci_dev *pci_dev)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_netif_oper(hw, NETIF_DETACH);
 	ieee80211_unregister_hw(hw);
 
 	/*
@@ -2477,8 +2472,6 @@ static int rt2400pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 
 	NOTICE("Going to sleep.\n");
 
-	ieee80211_netif_oper(hw, NETIF_DETACH);
-
 	/*
 	 * Disable the radio.
 	 */
@@ -2539,8 +2532,6 @@ static int rt2400pci_resume(struct pci_dev *pci_dev)
 	if (status)
 		return status;
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 7a1d924..bddbbf9 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1404,7 +1404,6 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2500pci_enable_led(rt2x00dev);
 
 	ieee80211_start_queues(rt2x00dev->hw);
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_WAKE);
 
 	return 0;
 
@@ -1420,7 +1419,6 @@ static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
 
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_STOP);
 	ieee80211_stop_queues(rt2x00dev->hw);
 
 	/*
@@ -2715,8 +2713,6 @@ static int rt2500pci_probe(struct pci_dev *pci_dev,
 		goto exit_free_device;
 	}
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 
 exit_free_device:
@@ -2742,7 +2738,6 @@ static void rt2500pci_remove(struct pci_dev *pci_dev)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_netif_oper(hw, NETIF_DETACH);
 	ieee80211_unregister_hw(hw);
 
 	/*
@@ -2774,8 +2769,6 @@ static int rt2500pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 
 	NOTICE("Going to sleep.\n");
 
-	ieee80211_netif_oper(hw, NETIF_DETACH);
-
 	/*
 	 * Disable the radio.
 	 */
@@ -2836,8 +2829,6 @@ static int rt2500pci_resume(struct pci_dev *pci_dev)
 	if (status)
 		return status;
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 82d5d1b..187076d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1311,7 +1311,6 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_enable_led(rt2x00dev);
 
 	ieee80211_start_queues(rt2x00dev->hw);
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_WAKE);
 
 	return 0;
 
@@ -1328,7 +1327,6 @@ static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
 
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_STOP);
 	ieee80211_stop_queues(rt2x00dev->hw);
 
 	/*
@@ -2519,8 +2517,6 @@ static int rt2500usb_probe(struct usb_interface *usb_intf,
 		goto exit_free_device;
 	}
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 
 exit_free_device:
@@ -2540,7 +2536,6 @@ static void rt2500usb_disconnect(struct usb_interface *usb_intf)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_netif_oper(hw, NETIF_DETACH);
 	ieee80211_unregister_hw(hw);
 
 	/*
@@ -2572,8 +2567,6 @@ static int rt2500usb_suspend(struct usb_interface *usb_intf,
 
 	NOTICE("Going to sleep.\n");
 
-	ieee80211_netif_oper(hw, NETIF_DETACH);
-
 	/*
 	 * Disable the radio.
 	 */
@@ -2629,8 +2622,6 @@ static int rt2500usb_resume(struct usb_interface *usb_intf)
 	if (status)
 		return status;
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 2de9201..9cee93f 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1688,7 +1688,6 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt61pci_enable_led(rt2x00dev);
 
 	ieee80211_start_queues(rt2x00dev->hw);
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_WAKE);
 
 	return 0;
 
@@ -1704,7 +1703,6 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
 
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_STOP);
 	ieee80211_stop_queues(rt2x00dev->hw);
 
 	/*
@@ -3190,8 +3188,6 @@ static int rt61pci_probe(struct pci_dev *pci_dev,
 		goto exit_free_device;
 	}
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 
 exit_free_device:
@@ -3217,7 +3213,6 @@ static void rt61pci_remove(struct pci_dev *pci_dev)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_netif_oper(hw, NETIF_DETACH);
 	ieee80211_unregister_hw(hw);
 
 	/*
@@ -3249,8 +3244,6 @@ static int rt61pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 
 	NOTICE("Going to sleep.\n");
 
-	ieee80211_netif_oper(hw, NETIF_DETACH);
-
 	/*
 	 * Disable the radio.
 	 */
@@ -3311,8 +3304,6 @@ static int rt61pci_resume(struct pci_dev *pci_dev)
 	if (status)
 		return status;
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 5a187e6..9c9fbce 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1451,7 +1451,6 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt73usb_enable_led(rt2x00dev);
 
 	ieee80211_start_queues(rt2x00dev->hw);
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_WAKE);
 
 	return 0;
 
@@ -1468,7 +1467,6 @@ static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
 
-	ieee80211_netif_oper(rt2x00dev->hw, NETIF_STOP);
 	ieee80211_stop_queues(rt2x00dev->hw);
 
 	/*
@@ -2819,8 +2817,6 @@ static int rt73usb_probe(struct usb_interface *usb_intf,
 		goto exit_free_device;
 	}
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
-
 	return 0;
 
 exit_free_device:
@@ -2840,7 +2836,6 @@ static void rt73usb_disconnect(struct usb_interface *usb_intf)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_netif_oper(hw, NETIF_DETACH);
 	ieee80211_unregister_hw(hw);
 
 	/*
@@ -2871,8 +2866,6 @@ static int rt73usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 
 	NOTICE("Going to sleep.\n");
 
-	ieee80211_netif_oper(hw, NETIF_DETACH);
-
 	/*
 	 * Disable the radio.
 	 */
@@ -2928,7 +2921,6 @@ static int rt73usb_resume(struct usb_interface *usb_intf)
 	if (status)
 		return status;
 
-	ieee80211_netif_oper(hw, NETIF_ATTACH);
 	return 0;
 }
 #endif /* CONFIG_PM */
