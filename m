Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:62595 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab0C3Vug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:50:36 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, <users@rt2x00.serialmonkey.com>,
	<linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 1/4] rt2x00: Disable auto wakeup before waking up device.
Date: Tue, 30 Mar 2010 23:50:23 +0200
Message-Id: <1269985826-17438-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In all drivers ensure that auto wakeup is disabled before waking up the device.
This is needed to prevent connection stability issues and problems in waking up
the device.

Based upon a patch from Ondrej Zary <linux@rainbow-software.org>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    4 ++++
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 ++++
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 ++++
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    6 +++---
 5 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index c22b040..08a4789 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -525,6 +525,10 @@ static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 1);
 		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
+	} else {
+		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
+		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 0);
+		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
 	}
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 52bbcf1..d084d70 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -573,6 +573,10 @@ static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 1);
 		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
+	} else {
+		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
+		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 0);
+		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
 	}
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index dbaa781..54d2716 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -648,6 +648,10 @@ static void rt2500usb_config_ps(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 1);
 		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
+	} else {
+		rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
+		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 0);
+		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
 	}
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 326fce7..68d0cfe 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1014,13 +1014,13 @@ static void rt2800_config_ps(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 	} else {
-		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
-
 		rt2800_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTO_LEAD_TIME, 0);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_TBCN_BEFORE_WAKE, 0);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTOWAKE, 0);
 		rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
+
+		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 47f3e4a..7ebe14b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -860,15 +860,15 @@ static void rt73usb_config_ps(struct rt2x00_dev *rt2x00dev,
 		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
 					    USB_MODE_SLEEP, REGISTER_TIMEOUT);
 	} else {
-		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
-					    USB_MODE_WAKEUP, REGISTER_TIMEOUT);
-
 		rt2x00usb_register_read(rt2x00dev, MAC_CSR11, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN, 0);
 		rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP, 0);
 		rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 0);
 		rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 0);
 		rt2x00usb_register_write(rt2x00dev, MAC_CSR11, reg);
+
+		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
+					    USB_MODE_WAKEUP, REGISTER_TIMEOUT);
 	}
 }
 
-- 
1.7.0.3

