Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36123 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0IHS6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 14:58:13 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so343042ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 11:58:12 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/06] rt2x00: Check for specific changed flags when updating the erp config
Date: Wed, 8 Sep 2010 20:56:32 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201009082055.38033.IvDoorn@gmail.com> <201009082056.05708.IvDoorn@gmail.com>
In-Reply-To: <201009082056.05708.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009082056.33182.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Previously rt2x00 was always updating all erp related config variables
even though mac80211 might only have changed one. Hence, pass the
changed flags to the config_erp driver callback so that the driver
can limit the changes to the correct values.

This fixes an issue in AP mode where the beacon interval is not
initialized (and thus zero) but still sent to the hardware causing an
interrupt storm on rt2800pci hanging the system.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |  122 +++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2500pci.c    |  123 ++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |   34 +++++---
 drivers/net/wireless/rt2x00/rt2800lib.c    |   60 ++++++++------
 drivers/net/wireless/rt2x00/rt2800lib.h    |    3 +-
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 +-
 drivers/net/wireless/rt2x00/rt2x00config.c |    5 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    6 +-
 drivers/net/wireless/rt2x00/rt61pci.c      |   47 ++++++----
 drivers/net/wireless/rt2x00/rt73usb.c      |   47 ++++++----
 11 files changed, 264 insertions(+), 189 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 103c711..d49e830 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -321,7 +321,8 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
-				 struct rt2x00lib_erp *erp)
+				 struct rt2x00lib_erp *erp,
+				 u32 changed)
 {
 	int preamble_mask;
 	u32 reg;
@@ -329,59 +330,72 @@ static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * When short preamble is enabled, we should set bit 0x08
 	 */
-	preamble_mask = erp->short_preamble << 3;
-
-	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, 0x1ff);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, 0x13a);
-	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
-	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
-	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
-	rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 10));
-	rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR3, &reg);
-	rt2x00_set_field32(&reg, ARCSR3_SIGNAL, 0x01 | preamble_mask);
-	rt2x00_set_field32(&reg, ARCSR3_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 20));
-	rt2x00pci_register_write(rt2x00dev, ARCSR3, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR4, &reg);
-	rt2x00_set_field32(&reg, ARCSR4_SIGNAL, 0x02 | preamble_mask);
-	rt2x00_set_field32(&reg, ARCSR4_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 55));
-	rt2x00pci_register_write(rt2x00dev, ARCSR4, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR5, &reg);
-	rt2x00_set_field32(&reg, ARCSR5_SIGNAL, 0x03 | preamble_mask);
-	rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 110));
-	rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
-
-	rt2x00pci_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		preamble_mask = erp->short_preamble << 3;
+
+		rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
+		rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, 0x1ff);
+		rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, 0x13a);
+		rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
+		rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
+		rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
+		rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 10));
+		rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR3, &reg);
+		rt2x00_set_field32(&reg, ARCSR3_SIGNAL, 0x01 | preamble_mask);
+		rt2x00_set_field32(&reg, ARCSR3_SERVICE, 0x04);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 20));
+		rt2x00pci_register_write(rt2x00dev, ARCSR3, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR4, &reg);
+		rt2x00_set_field32(&reg, ARCSR4_SIGNAL, 0x02 | preamble_mask);
+		rt2x00_set_field32(&reg, ARCSR4_SERVICE, 0x04);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 55));
+		rt2x00pci_register_write(rt2x00dev, ARCSR4, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR5, &reg);
+		rt2x00_set_field32(&reg, ARCSR5_SIGNAL, 0x03 | preamble_mask);
+		rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 110));
+		rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
+	}
 
-	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
-	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
-	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		rt2x00pci_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
 
-	rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
-	rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL, erp->beacon_int * 16);
-	rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION, erp->beacon_int * 16);
-	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+		rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
+		rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
-	rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
-	rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
-	rt2x00pci_register_write(rt2x00dev, CSR18, reg);
+		rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
+		rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
+		rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
+		rt2x00pci_register_write(rt2x00dev, CSR18, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
-	rt2x00_set_field32(&reg, CSR19_DIFS, erp->difs);
-	rt2x00_set_field32(&reg, CSR19_EIFS, erp->eifs);
-	rt2x00pci_register_write(rt2x00dev, CSR19, reg);
+		rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
+		rt2x00_set_field32(&reg, CSR19_DIFS, erp->difs);
+		rt2x00_set_field32(&reg, CSR19_EIFS, erp->eifs);
+		rt2x00pci_register_write(rt2x00dev, CSR19, reg);
+	}
+
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
+		rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL,
+				   erp->beacon_int * 16);
+		rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION,
+				   erp->beacon_int * 16);
+		rt2x00pci_register_write(rt2x00dev, CSR12, reg);
+	}
 }
 
 static void rt2400pci_config_ant(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index ab05071..2214c32 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -327,7 +327,8 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
-				 struct rt2x00lib_erp *erp)
+				 struct rt2x00lib_erp *erp,
+				 u32 changed)
 {
 	int preamble_mask;
 	u32 reg;
@@ -335,59 +336,73 @@ static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * When short preamble is enabled, we should set bit 0x08
 	 */
-	preamble_mask = erp->short_preamble << 3;
-
-	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, 0x162);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, 0xa2);
-	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
-	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
-	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
-	rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 10));
-	rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR3, &reg);
-	rt2x00_set_field32(&reg, ARCSR3_SIGNAL, 0x01 | preamble_mask);
-	rt2x00_set_field32(&reg, ARCSR3_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 20));
-	rt2x00pci_register_write(rt2x00dev, ARCSR3, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR4, &reg);
-	rt2x00_set_field32(&reg, ARCSR4_SIGNAL, 0x02 | preamble_mask);
-	rt2x00_set_field32(&reg, ARCSR4_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 55));
-	rt2x00pci_register_write(rt2x00dev, ARCSR4, reg);
-
-	rt2x00pci_register_read(rt2x00dev, ARCSR5, &reg);
-	rt2x00_set_field32(&reg, ARCSR5_SIGNAL, 0x03 | preamble_mask);
-	rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 110));
-	rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
-
-	rt2x00pci_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		preamble_mask = erp->short_preamble << 3;
+
+		rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
+		rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, 0x162);
+		rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, 0xa2);
+		rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
+		rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
+		rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
+		rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 10));
+		rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR3, &reg);
+		rt2x00_set_field32(&reg, ARCSR3_SIGNAL, 0x01 | preamble_mask);
+		rt2x00_set_field32(&reg, ARCSR3_SERVICE, 0x04);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 20));
+		rt2x00pci_register_write(rt2x00dev, ARCSR3, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR4, &reg);
+		rt2x00_set_field32(&reg, ARCSR4_SIGNAL, 0x02 | preamble_mask);
+		rt2x00_set_field32(&reg, ARCSR4_SERVICE, 0x04);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 55));
+		rt2x00pci_register_write(rt2x00dev, ARCSR4, reg);
+
+		rt2x00pci_register_read(rt2x00dev, ARCSR5, &reg);
+		rt2x00_set_field32(&reg, ARCSR5_SIGNAL, 0x03 | preamble_mask);
+		rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
+		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
+				   GET_DURATION(ACK_SIZE, 110));
+		rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
+	}
 
-	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
-	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
-	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		rt2x00pci_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+		rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
+		rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
-	rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL, erp->beacon_int * 16);
-	rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION, erp->beacon_int * 16);
-	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
+		rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
+		rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
+		rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
+		rt2x00pci_register_write(rt2x00dev, CSR18, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
-	rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
-	rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
-	rt2x00pci_register_write(rt2x00dev, CSR18, reg);
+		rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
+		rt2x00_set_field32(&reg, CSR19_DIFS, erp->difs);
+		rt2x00_set_field32(&reg, CSR19_EIFS, erp->eifs);
+		rt2x00pci_register_write(rt2x00dev, CSR19, reg);
+	}
+
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
+		rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL,
+				   erp->beacon_int * 16);
+		rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION,
+				   erp->beacon_int * 16);
+		rt2x00pci_register_write(rt2x00dev, CSR12, reg);
+	}
 
-	rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
-	rt2x00_set_field32(&reg, CSR19_DIFS, erp->difs);
-	rt2x00_set_field32(&reg, CSR19_EIFS, erp->eifs);
-	rt2x00pci_register_write(rt2x00dev, CSR19, reg);
 }
 
 static void rt2500pci_config_ant(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index db64df4..6e94356 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -494,24 +494,34 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500usb_config_erp(struct rt2x00_dev *rt2x00dev,
-				 struct rt2x00lib_erp *erp)
+				 struct rt2x00lib_erp *erp,
+				 u32 changed)
 {
 	u16 reg;
 
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR10, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR10_AUTORESPOND_PREAMBLE,
-			   !!erp->short_preamble);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR10, reg);
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR10, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR10_AUTORESPOND_PREAMBLE,
+				   !!erp->short_preamble);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR10, reg);
+	}
 
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR11, erp->basic_rates);
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR11,
+					 erp->basic_rates);
 
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR18, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR18_INTERVAL, erp->beacon_int * 4);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR18, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR18_INTERVAL,
+				   erp->beacon_int * 4);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
+	}
 
-	rt2500usb_register_write(rt2x00dev, MAC_CSR10, erp->slot_time);
-	rt2500usb_register_write(rt2x00dev, MAC_CSR11, erp->sifs);
-	rt2500usb_register_write(rt2x00dev, MAC_CSR12, erp->eifs);
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		rt2500usb_register_write(rt2x00dev, MAC_CSR10, erp->slot_time);
+		rt2500usb_register_write(rt2x00dev, MAC_CSR11, erp->sifs);
+		rt2500usb_register_write(rt2x00dev, MAC_CSR12, erp->eifs);
+	}
 }
 
 static void rt2500usb_config_ant(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9cfb9b31..3bb6749 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1159,38 +1159,50 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 }
 EXPORT_SYMBOL_GPL(rt2800_config_intf);
 
-void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp)
+void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp,
+		       u32 changed)
 {
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY,
-			   !!erp->short_preamble);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE,
-			   !!erp->short_preamble);
-	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
+		rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY,
+				   !!erp->short_preamble);
+		rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE,
+				   !!erp->short_preamble);
+		rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
+	}
 
-	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL,
-			   erp->cts_protection ? 2 : 0);
-	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+		rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL,
+				   erp->cts_protection ? 2 : 0);
+		rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	}
 
-	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE,
-				 erp->basic_rates);
-	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE,
+					 erp->basic_rates);
+		rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
+	}
 
-	rt2800_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
-	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_SLOT_TIME, erp->slot_time);
-	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		rt2800_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
+		rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_SLOT_TIME,
+				   erp->slot_time);
+		rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
-	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
-	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
+		rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
+		rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
+	}
 
-	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
-			   erp->beacon_int * 16);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
+				   erp->beacon_int * 16);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2800_config_erp);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 986229c..600c5eb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -169,7 +169,8 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			  const unsigned int filter_flags);
 void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 			struct rt2x00intf_conf *conf, const unsigned int flags);
-void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp);
+void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp,
+		       u32 changed);
 void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant);
 void rt2800_config(struct rt2x00_dev *rt2x00dev,
 		   struct rt2x00lib_conf *libconf,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0ae942c..7832a59 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -596,7 +596,8 @@ struct rt2x00lib_ops {
 #define CONFIG_UPDATE_BSSID		( 1 << 3 )
 
 	void (*config_erp) (struct rt2x00_dev *rt2x00dev,
-			    struct rt2x00lib_erp *erp);
+			    struct rt2x00lib_erp *erp,
+			    u32 changed);
 	void (*config_ant) (struct rt2x00_dev *rt2x00dev,
 			    struct antenna_setup *ant);
 	void (*config) (struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index db09a64..4c7ff76 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -81,7 +81,8 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 
 void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 			  struct rt2x00_intf *intf,
-			  struct ieee80211_bss_conf *bss_conf)
+			  struct ieee80211_bss_conf *bss_conf,
+			  u32 changed)
 {
 	struct rt2x00lib_erp erp;
 
@@ -102,7 +103,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	/* Update global beacon interval time, this is needed for PS support */
 	rt2x00dev->beacon_int = bss_conf->beacon_int;
 
-	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
+	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp, changed);
 }
 
 static inline
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index dc5c657..70c85ac 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -86,7 +86,8 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 			   const u8 *mac, const u8 *bssid);
 void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 			  struct rt2x00_intf *intf,
-			  struct ieee80211_bss_conf *conf);
+			  struct ieee80211_bss_conf *conf,
+			  u32 changed);
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 			      struct antenna_setup ant);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 235e037..7862a84 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -669,8 +669,10 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
-	if (changes & ~(BSS_CHANGED_ASSOC | BSS_CHANGED_HT))
-		rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
+	if (changes & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_ERP_PREAMBLE |
+		       BSS_CHANGED_ERP_SLOT | BSS_CHANGED_BASIC_RATES |
+		       BSS_CHANGED_BEACON_INT))
+		rt2x00lib_config_erp(rt2x00dev, intf, bss_conf, changes);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3a77599..042cfbe 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -594,7 +594,8 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
-			       struct rt2x00lib_erp *erp)
+			       struct rt2x00lib_erp *erp,
+			       u32 changed)
 {
 	u32 reg;
 
@@ -603,28 +604,36 @@ static void rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
-			   !!erp->short_preamble);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
+		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
+				   !!erp->short_preamble);
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
+	}
 
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR5, erp->basic_rates);
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR5,
+					 erp->basic_rates);
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
-			   erp->beacon_int * 16);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
+				   erp->beacon_int * 16);
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+	}
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
+		rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
+		rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR8, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS, erp->sifs);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
-	rt2x00_set_field32(&reg, MAC_CSR8_EIFS, erp->eifs);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR8, reg);
+		rt2x00pci_register_read(rt2x00dev, MAC_CSR8, &reg);
+		rt2x00_set_field32(&reg, MAC_CSR8_SIFS, erp->sifs);
+		rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
+		rt2x00_set_field32(&reg, MAC_CSR8_EIFS, erp->eifs);
+		rt2x00pci_register_write(rt2x00dev, MAC_CSR8, reg);
+	}
 }
 
 static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 87fb220..e22f01c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -545,7 +545,8 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
-			       struct rt2x00lib_erp *erp)
+			       struct rt2x00lib_erp *erp,
+			       u32 changed)
 {
 	u32 reg;
 
@@ -554,28 +555,36 @@ static void rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR4, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
-			   !!erp->short_preamble);
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR4, reg);
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR4, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
+		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
+				   !!erp->short_preamble);
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR4, reg);
+	}
 
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR5, erp->basic_rates);
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR5,
+					 erp->basic_rates);
 
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
-			   erp->beacon_int * 16);
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
+				   erp->beacon_int * 16);
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+	}
 
-	rt2x00usb_register_read(rt2x00dev, MAC_CSR9, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
-	rt2x00usb_register_write(rt2x00dev, MAC_CSR9, reg);
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		rt2x00usb_register_read(rt2x00dev, MAC_CSR9, &reg);
+		rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
+		rt2x00usb_register_write(rt2x00dev, MAC_CSR9, reg);
 
-	rt2x00usb_register_read(rt2x00dev, MAC_CSR8, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS, erp->sifs);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
-	rt2x00_set_field32(&reg, MAC_CSR8_EIFS, erp->eifs);
-	rt2x00usb_register_write(rt2x00dev, MAC_CSR8, reg);
+		rt2x00usb_register_read(rt2x00dev, MAC_CSR8, &reg);
+		rt2x00_set_field32(&reg, MAC_CSR8_SIFS, erp->sifs);
+		rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
+		rt2x00_set_field32(&reg, MAC_CSR8_EIFS, erp->eifs);
+		rt2x00usb_register_write(rt2x00dev, MAC_CSR8, reg);
+	}
 }
 
 static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
-- 
1.7.2.2

