Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1A3MYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:43 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:42 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/21] rt2x00: Remove STATE_RADIO_IRQ_OFF_ISR and STATE_RADIO_IRQ_ON_ISR
Date: Sun, 30 Jan 2011 13:20:52 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301320.06167.IvDoorn@gmail.com> <201101301320.29903.IvDoorn@gmail.com>
In-Reply-To: <201101301320.29903.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301320.53735.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Remove STATE_RADIO_IRQ_OFF_ISR and STATE_RADIO_IRQ_ON_ISR as they are
not used anymore.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    5 +----
 drivers/net/wireless/rt2x00/rt2500pci.c |    5 +----
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 --
 drivers/net/wireless/rt2x00/rt2800pci.c |    5 +----
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 --
 drivers/net/wireless/rt2x00/rt2x00reg.h |    2 --
 drivers/net/wireless/rt2x00/rt61pci.c   |    5 +----
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 --
 8 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b324917..5c88fdc 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -971,8 +971,7 @@ static int rt2400pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 static void rt2400pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_OFF) ||
-		   (state == STATE_RADIO_IRQ_OFF_ISR);
+	int mask = (state == STATE_RADIO_IRQ_OFF);
 	u32 reg;
 	unsigned long flags;
 
@@ -1087,9 +1086,7 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2400pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
-	case STATE_RADIO_IRQ_OFF_ISR:
 		rt2400pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 7daa483..3ef1fb4 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1126,8 +1126,7 @@ static int rt2500pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_OFF) ||
-		   (state == STATE_RADIO_IRQ_OFF_ISR);
+	int mask = (state == STATE_RADIO_IRQ_OFF);
 	u32 reg;
 	unsigned long flags;
 
@@ -1241,9 +1240,7 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
-	case STATE_RADIO_IRQ_OFF_ISR:
 		rt2500pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 157516e..01f385d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1054,9 +1054,7 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
-	case STATE_RADIO_IRQ_OFF_ISR:
 		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 31483c7..208ea5e 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -418,8 +418,7 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_ON) ||
-		   (state == STATE_RADIO_IRQ_ON_ISR);
+	int mask = (state == STATE_RADIO_IRQ_ON);
 	u32 reg;
 	unsigned long flags;
 
@@ -564,9 +563,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
 		break;
 	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
-	case STATE_RADIO_IRQ_OFF_ISR:
 		rt2800pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3ebe473..3d2a944 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -253,9 +253,7 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800usb_set_state(rt2x00dev, STATE_SLEEP);
 		break;
 	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
-	case STATE_RADIO_IRQ_OFF_ISR:
 		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index e8259ae..6f867ee 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -85,8 +85,6 @@ enum dev_state {
 	STATE_RADIO_OFF,
 	STATE_RADIO_IRQ_ON,
 	STATE_RADIO_IRQ_OFF,
-	STATE_RADIO_IRQ_ON_ISR,
-	STATE_RADIO_IRQ_OFF_ISR,
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 351055d..3afafab 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1717,8 +1717,7 @@ static int rt61pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_OFF) ||
-		   (state == STATE_RADIO_IRQ_OFF_ISR);
+	int mask = (state == STATE_RADIO_IRQ_OFF);
 	u32 reg;
 	unsigned long flags;
 
@@ -1852,9 +1851,7 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt61pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
-	case STATE_RADIO_IRQ_OFF_ISR:
 		rt61pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 330353e..aa9c61c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1428,9 +1428,7 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt73usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_IRQ_ON:
-	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
-	case STATE_RADIO_IRQ_OFF_ISR:
 		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
-- 
1.7.2.3

