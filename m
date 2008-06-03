Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:2192 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYFCS0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:18 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644294nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:17 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/11] rt2x00: Cleanup/optimize set_state() function callback function
Date: Tue, 3 Jun 2008 20:30:05 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032028.03154.IvDoorn@gmail.com> <200806032028.21795.IvDoorn@gmail.com>
In-Reply-To: <200806032028.21795.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032030.05387.IvDoorn@gmail.com> (sfid-20080603_202624_739774_8500496D)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 36d1e3ea615aec2dbafa2493021cf3117cc8f57c Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 3 Jun 2008 18:58:56 +0200
Subject: [PATCH] rt2x00: Cleanup/optimize set_state() function callback function

* Reduce goto usage
* Mark if-statements which are true on hardware error unlikely()
* Cleanup debug messages

This makes the code look nicer and be better optimized since
the chance of hardware errors should be very small.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   56 ++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2500pci.c |   56 ++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2500usb.c |   44 +++++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++
 drivers/net/wireless/rt2x00/rt61pci.c   |   61 +++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   49 ++++++++++++++-----------
 6 files changed, 140 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1101610..94226b4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -792,25 +792,32 @@ static int rt2400pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static int rt2400pci_init_bbp(struct rt2x00_dev *rt2x00dev)
+static int rt2400pci_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
-	u16 eeprom;
-	u8 reg_id;
 	u8 value;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2400pci_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
-			goto continue_csr_init;
-		NOTICE(rt2x00dev, "Waiting for BBP register.\n");
+			return 0;
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
 	return -EACCES;
+}
+
+static int rt2400pci_init_bbp(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u16 eeprom;
+	u8 reg_id;
+	u8 value;
+
+	if (unlikely(rt2400pci_wait_bbp_ready(rt2x00dev)))
+		return -EACCES;
 
-continue_csr_init:
 	rt2400pci_bbp_write(rt2x00dev, 1, 0x00);
 	rt2400pci_bbp_write(rt2x00dev, 3, 0x27);
 	rt2400pci_bbp_write(rt2x00dev, 4, 0x08);
@@ -849,7 +856,8 @@ static void rt2400pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
 	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX,
-			   state == STATE_RADIO_RX_OFF);
+			   (state == STATE_RADIO_RX_OFF) ||
+			   (state == STATE_RADIO_RX_OFF_LINK));
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 }
 
@@ -886,17 +894,10 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all registers.
 	 */
-	if (rt2400pci_init_queues(rt2x00dev) ||
-	    rt2400pci_init_registers(rt2x00dev) ||
-	    rt2400pci_init_bbp(rt2x00dev)) {
-		ERROR(rt2x00dev, "Register initialization failed.\n");
+	if (unlikely(rt2400pci_init_queues(rt2x00dev) ||
+		     rt2400pci_init_registers(rt2x00dev) ||
+		     rt2400pci_init_bbp(rt2x00dev)))
 		return -EIO;
-	}
-
-	/*
-	 * Enable interrupts.
-	 */
-	rt2400pci_toggle_irq(rt2x00dev, STATE_RADIO_IRQ_ON);
 
 	return 0;
 }
@@ -918,11 +919,6 @@ static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
-
-	/*
-	 * Disable interrupts.
-	 */
-	rt2400pci_toggle_irq(rt2x00dev, STATE_RADIO_IRQ_OFF);
 }
 
 static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
@@ -957,10 +953,6 @@ static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
 		msleep(10);
 	}
 
-	NOTICE(rt2x00dev, "Device failed to enter state %d, "
-	       "current device state: bbp %d and rf %d.\n",
-	       state, bbp_state, rf_state);
-
 	return -EBUSY;
 }
 
@@ -978,11 +970,13 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
-		rt2400pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
-		break;
 	case STATE_RADIO_RX_OFF:
 	case STATE_RADIO_RX_OFF_LINK:
-		rt2400pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+		rt2400pci_toggle_rx(rt2x00dev, state);
+		break;
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		rt2400pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
@@ -995,6 +989,10 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	}
 
+	if (unlikely(retval))
+		ERROR(rt2x00dev, "Device failed to enter state %d (%d).\n",
+		      state, retval);
+
 	return retval;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0ac934a..c8cf8c1 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -935,25 +935,32 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static int rt2500pci_init_bbp(struct rt2x00_dev *rt2x00dev)
+static int rt2500pci_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
-	u16 eeprom;
-	u8 reg_id;
 	u8 value;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2500pci_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
-			goto continue_csr_init;
-		NOTICE(rt2x00dev, "Waiting for BBP register.\n");
+			return 0;
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
 	return -EACCES;
+}
+
+static int rt2500pci_init_bbp(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u16 eeprom;
+	u8 reg_id;
+	u8 value;
+
+	if (unlikely(rt2500pci_wait_bbp_ready(rt2x00dev)))
+		return -EACCES;
 
-continue_csr_init:
 	rt2500pci_bbp_write(rt2x00dev, 3, 0x02);
 	rt2500pci_bbp_write(rt2x00dev, 4, 0x19);
 	rt2500pci_bbp_write(rt2x00dev, 14, 0x1c);
@@ -1008,7 +1015,8 @@ static void rt2500pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
 	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX,
-			   state == STATE_RADIO_RX_OFF);
+			   (state == STATE_RADIO_RX_OFF) ||
+			   (state == STATE_RADIO_RX_OFF_LINK));
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 }
 
@@ -1045,17 +1053,10 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all registers.
 	 */
-	if (rt2500pci_init_queues(rt2x00dev) ||
-	    rt2500pci_init_registers(rt2x00dev) ||
-	    rt2500pci_init_bbp(rt2x00dev)) {
-		ERROR(rt2x00dev, "Register initialization failed.\n");
+	if (unlikely(rt2500pci_init_queues(rt2x00dev) ||
+		     rt2500pci_init_registers(rt2x00dev) ||
+		     rt2500pci_init_bbp(rt2x00dev)))
 		return -EIO;
-	}
-
-	/*
-	 * Enable interrupts.
-	 */
-	rt2500pci_toggle_irq(rt2x00dev, STATE_RADIO_IRQ_ON);
 
 	return 0;
 }
@@ -1077,11 +1078,6 @@ static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
-
-	/*
-	 * Disable interrupts.
-	 */
-	rt2500pci_toggle_irq(rt2x00dev, STATE_RADIO_IRQ_OFF);
 }
 
 static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
@@ -1116,10 +1112,6 @@ static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
 		msleep(10);
 	}
 
-	NOTICE(rt2x00dev, "Device failed to enter state %d, "
-	       "current device state: bbp %d and rf %d.\n",
-	       state, bbp_state, rf_state);
-
 	return -EBUSY;
 }
 
@@ -1137,11 +1129,13 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
-		rt2500pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
-		break;
 	case STATE_RADIO_RX_OFF:
 	case STATE_RADIO_RX_OFF_LINK:
-		rt2500pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+		rt2500pci_toggle_rx(rt2x00dev, state);
+		break;
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		rt2500pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
@@ -1154,6 +1148,10 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	}
 
+	if (unlikely(retval))
+		ERROR(rt2x00dev, "Device failed to enter state %d (%d).\n",
+		      state, retval);
+
 	return retval;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0027f4b..0d51b74 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -858,25 +858,32 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static int rt2500usb_init_bbp(struct rt2x00_dev *rt2x00dev)
+static int rt2500usb_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
-	u16 eeprom;
 	u8 value;
-	u8 reg_id;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2500usb_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
-			goto continue_csr_init;
-		NOTICE(rt2x00dev, "Waiting for BBP register.\n");
+			return 0;
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
 	return -EACCES;
+}
+
+static int rt2500usb_init_bbp(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u16 eeprom;
+	u8 value;
+	u8 reg_id;
+
+	if (unlikely(rt2500usb_wait_bbp_ready(rt2x00dev)))
+		return -EACCES;
 
-continue_csr_init:
 	rt2500usb_bbp_write(rt2x00dev, 3, 0x02);
 	rt2500usb_bbp_write(rt2x00dev, 4, 0x19);
 	rt2500usb_bbp_write(rt2x00dev, 14, 0x1c);
@@ -932,7 +939,8 @@ static void rt2500usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX,
-			   state == STATE_RADIO_RX_OFF);
+			   (state == STATE_RADIO_RX_OFF) ||
+			   (state == STATE_RADIO_RX_OFF_LINK));
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
 }
 
@@ -941,11 +949,9 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all registers.
 	 */
-	if (rt2500usb_init_registers(rt2x00dev) ||
-	    rt2500usb_init_bbp(rt2x00dev)) {
-		ERROR(rt2x00dev, "Register initialization failed.\n");
+	if (unlikely(rt2500usb_init_registers(rt2x00dev) ||
+		     rt2500usb_init_bbp(rt2x00dev)))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -998,10 +1004,6 @@ static int rt2500usb_set_state(struct rt2x00_dev *rt2x00dev,
 		msleep(30);
 	}
 
-	NOTICE(rt2x00dev, "Device failed to enter state %d, "
-	       "current device state: bbp %d and rf %d.\n",
-	       state, bbp_state, rf_state);
-
 	return -EBUSY;
 }
 
@@ -1019,11 +1021,13 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
-		rt2500usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
-		break;
 	case STATE_RADIO_RX_OFF:
 	case STATE_RADIO_RX_OFF_LINK:
-		rt2500usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+		rt2500usb_toggle_rx(rt2x00dev, state);
+		break;
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
@@ -1036,6 +1040,10 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	}
 
+	if (unlikely(retval))
+		ERROR(rt2x00dev, "Device failed to enter state %d (%d).\n",
+		      state, retval);
+
 	return retval;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index dc5ab90..48f4aec 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -112,6 +112,8 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	if (status)
 		return status;
 
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_IRQ_ON);
+
 	rt2x00leds_led_radio(rt2x00dev, true);
 	rt2x00led_led_activity(rt2x00dev, true);
 
@@ -157,6 +159,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Disable radio.
 	 */
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_OFF);
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_IRQ_OFF);
 	rt2x00led_led_activity(rt2x00dev, false);
 	rt2x00leds_led_radio(rt2x00dev, false);
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f03d21d..aa9ef66 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1281,25 +1281,32 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static int rt61pci_init_bbp(struct rt2x00_dev *rt2x00dev)
+static int rt61pci_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
-	u16 eeprom;
-	u8 reg_id;
 	u8 value;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt61pci_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
-			goto continue_csr_init;
-		NOTICE(rt2x00dev, "Waiting for BBP register.\n");
+			return 0;
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
 	return -EACCES;
+}
+
+static int rt61pci_init_bbp(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u16 eeprom;
+	u8 reg_id;
+	u8 value;
+
+	if (unlikely(rt61pci_wait_bbp_ready(rt2x00dev)))
+		return -EACCES;
 
-continue_csr_init:
 	rt61pci_bbp_write(rt2x00dev, 3, 0x00);
 	rt61pci_bbp_write(rt2x00dev, 15, 0x30);
 	rt61pci_bbp_write(rt2x00dev, 21, 0xc8);
@@ -1348,7 +1355,8 @@ static void rt61pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX,
-			   state == STATE_RADIO_RX_OFF);
+			   (state == STATE_RADIO_RX_OFF) ||
+			   (state == STATE_RADIO_RX_OFF_LINK));
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
@@ -1400,17 +1408,10 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all registers.
 	 */
-	if (rt61pci_init_queues(rt2x00dev) ||
-	    rt61pci_init_registers(rt2x00dev) ||
-	    rt61pci_init_bbp(rt2x00dev)) {
-		ERROR(rt2x00dev, "Register initialization failed.\n");
+	if (unlikely(rt61pci_init_queues(rt2x00dev) ||
+		     rt61pci_init_registers(rt2x00dev) ||
+		     rt61pci_init_bbp(rt2x00dev)))
 		return -EIO;
-	}
-
-	/*
-	 * Enable interrupts.
-	 */
-	rt61pci_toggle_irq(rt2x00dev, STATE_RADIO_IRQ_ON);
 
 	/*
 	 * Enable RX.
@@ -1442,11 +1443,6 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, 1);
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, 1);
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
-
-	/*
-	 * Disable interrupts.
-	 */
-	rt61pci_toggle_irq(rt2x00dev, STATE_RADIO_IRQ_OFF);
 }
 
 static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
@@ -1454,7 +1450,6 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	u32 reg;
 	unsigned int i;
 	char put_to_sleep;
-	char current_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1470,16 +1465,12 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00pci_register_read(rt2x00dev, MAC_CSR12, &reg);
-		current_state =
-		    rt2x00_get_field32(reg, MAC_CSR12_BBP_CURRENT_STATE);
-		if (current_state == !put_to_sleep)
+		state = rt2x00_get_field32(reg, MAC_CSR12_BBP_CURRENT_STATE);
+		if (state == !put_to_sleep)
 			return 0;
 		msleep(10);
 	}
 
-	NOTICE(rt2x00dev, "Device failed to enter state %d, "
-	       "current device state %d.\n", !put_to_sleep, current_state);
-
 	return -EBUSY;
 }
 
@@ -1497,11 +1488,13 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
-		rt61pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
-		break;
 	case STATE_RADIO_RX_OFF:
 	case STATE_RADIO_RX_OFF_LINK:
-		rt61pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+		rt61pci_toggle_rx(rt2x00dev, state);
+		break;
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		rt61pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
@@ -1514,6 +1507,10 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	}
 
+	if (unlikely(retval))
+		ERROR(rt2x00dev, "Device failed to enter state %d (%d).\n",
+		      state, retval);
+
 	return retval;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 779fa5b..db1fc13 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1095,25 +1095,32 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static int rt73usb_init_bbp(struct rt2x00_dev *rt2x00dev)
+static int rt73usb_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
-	u16 eeprom;
-	u8 reg_id;
 	u8 value;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt73usb_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
-			goto continue_csr_init;
-		NOTICE(rt2x00dev, "Waiting for BBP register.\n");
+			return 0;
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
 	return -EACCES;
+}
+
+static int rt73usb_init_bbp(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u16 eeprom;
+	u8 reg_id;
+	u8 value;
+
+	if (unlikely(rt73usb_wait_bbp_ready(rt2x00dev)))
+		return -EACCES;
 
-continue_csr_init:
 	rt73usb_bbp_write(rt2x00dev, 3, 0x80);
 	rt73usb_bbp_write(rt2x00dev, 15, 0x30);
 	rt73usb_bbp_write(rt2x00dev, 21, 0xc8);
@@ -1163,7 +1170,8 @@ static void rt73usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX,
-			   state == STATE_RADIO_RX_OFF);
+			   (state == STATE_RADIO_RX_OFF) ||
+			   (state == STATE_RADIO_RX_OFF_LINK));
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
@@ -1172,11 +1180,9 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all registers.
 	 */
-	if (rt73usb_init_registers(rt2x00dev) ||
-	    rt73usb_init_bbp(rt2x00dev)) {
-		ERROR(rt2x00dev, "Register initialization failed.\n");
+	if (unlikely(rt73usb_init_registers(rt2x00dev) ||
+		     rt73usb_init_bbp(rt2x00dev)))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -1198,7 +1204,6 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	u32 reg;
 	unsigned int i;
 	char put_to_sleep;
-	char current_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1214,16 +1219,12 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt73usb_register_read(rt2x00dev, MAC_CSR12, &reg);
-		current_state =
-		    rt2x00_get_field32(reg, MAC_CSR12_BBP_CURRENT_STATE);
-		if (current_state == !put_to_sleep)
+		state = rt2x00_get_field32(reg, MAC_CSR12_BBP_CURRENT_STATE);
+		if (state == !put_to_sleep)
 			return 0;
 		msleep(10);
 	}
 
-	NOTICE(rt2x00dev, "Device failed to enter state %d, "
-	       "current device state %d.\n", !put_to_sleep, current_state);
-
 	return -EBUSY;
 }
 
@@ -1241,11 +1242,13 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
-		rt73usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
-		break;
 	case STATE_RADIO_RX_OFF:
 	case STATE_RADIO_RX_OFF_LINK:
-		rt73usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+		rt73usb_toggle_rx(rt2x00dev, state);
+		break;
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
@@ -1258,6 +1261,10 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	}
 
+	if (unlikely(retval))
+		ERROR(rt2x00dev, "Device failed to enter state %d (%d).\n",
+		      state, retval);
+
 	return retval;
 }
 
-- 
1.5.5.3

