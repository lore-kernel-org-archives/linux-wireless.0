Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:41851 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbYBYWYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:24:16 -0500
Received: by ug-out-1314.google.com with SMTP id z38so998790ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:24:15 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 3/6] rt2x00: Add link tuner safe RX toggle states
Date: Mon, 25 Feb 2008 23:21:15 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802252320.11809.IvDoorn@gmail.com>
In-Reply-To: <200802252320.11809.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802252321.15198.IvDoorn@gmail.com> (sfid-20080225_222419_122485_FB078840)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds 2 new states which both are used to toggle
the RX. These new states are required for usage
inside the link tuner thread, because the normal
RX toggling will stop the link tuner thread.
While it is possible that the link tuner thread itself
is the caller of the RX toggle (when using software
antenna diversity).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |    6 +++++-
 drivers/net/wireless/rt2x00/rt2500pci.c    |    6 +++++-
 drivers/net/wireless/rt2x00/rt2500usb.c    |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00reg.h    |    2 ++
 drivers/net/wireless/rt2x00/rt61pci.c      |    6 +++++-
 drivers/net/wireless/rt2x00/rt73usb.c      |    6 +++++-
 7 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b63bc66..460ef2f 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -953,8 +953,12 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2400pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt2400pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2400pci_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt2400pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index add8aff..ffcd996 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1106,8 +1106,12 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt2500pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2500pci_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt2500pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index d9643c5..9f59db9 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -996,8 +996,12 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt2500usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2500usb_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt2500usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 46888f9..a1d8e33 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -127,7 +127,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * else the changes will be ignored by the device.
 	 */
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF_LINK);
 
 	/*
 	 * Write new antenna setup to device and reset the link tuner.
@@ -141,7 +141,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->link.ant.active.tx = libconf.ant.tx;
 
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index add1f09..0325bed 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -85,6 +85,8 @@ enum dev_state {
 	STATE_RADIO_OFF,
 	STATE_RADIO_RX_ON,
 	STATE_RADIO_RX_OFF,
+	STATE_RADIO_RX_ON_LINK,
+	STATE_RADIO_RX_OFF_LINK,
 	STATE_RADIO_IRQ_ON,
 	STATE_RADIO_IRQ_OFF,
 };
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ca83d94..091fe39 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1458,8 +1458,12 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt61pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt61pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt61pci_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt61pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7d6ee97..6546b0d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1196,8 +1196,12 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt73usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt73usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt73usb_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt73usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
-- 
1.5.3.2

