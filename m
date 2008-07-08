Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:13203 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbYGHLhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 07:37:05 -0400
Received: by nf-out-0910.google.com with SMTP id d3so758741nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 04:37:03 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH] rt2x00: Disable synchronization during initialization
Date: Tue, 8 Jul 2008 13:45:20 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807081345.20404.IvDoorn@gmail.com> (sfid-20080708_133710_961756_FB49400D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As soon as init_registers() was called, the rt2400/rt2500
would start raising beacondone interrupts. Since this is highly
premature since no beacons were provided yet, we should
initialize the synchronization register to 0.

This will make all drivers initialize it to 0 regardless
if they are raising beacondone interrupts or not, since it only
makes sense to have it completely disabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   11 +++++++++++
 drivers/net/wireless/rt2x00/rt2500pci.c |   11 +++++++++++
 drivers/net/wireless/rt2x00/rt2500usb.c |    7 +++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    9 +++++++++
 drivers/net/wireless/rt2x00/rt73usb.c   |    9 +++++++++
 5 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index ee953ca..91cbd9e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -733,6 +733,17 @@ static int rt2400pci_init_registers(struct rt2x00_dev *rt2x00dev)
 			   (rt2x00dev->rx->data_size / 128));
 	rt2x00pci_register_write(rt2x00dev, CSR9, reg);
 
+	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+	rt2x00_set_field32(&reg, CSR14_TCFP, 0);
+	rt2x00_set_field32(&reg, CSR14_TATIMW, 0);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	rt2x00_set_field32(&reg, CSR14_CFP_COUNT_PRELOAD, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCM_PRELOAD, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
 	rt2x00pci_register_write(rt2x00dev, CNT3, 0x3f080000);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR0, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0423c25..0f2a0e2 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -831,6 +831,17 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, CSR11_CW_SELECT, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 
+	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+	rt2x00_set_field32(&reg, CSR14_TCFP, 0);
+	rt2x00_set_field32(&reg, CSR14_TATIMW, 0);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	rt2x00_set_field32(&reg, CSR14_CFP_COUNT_PRELOAD, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCM_PRELOAD, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
 	rt2x00pci_register_write(rt2x00dev, CNT3, 0);
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR8, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0dd1cb5..367db10 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -812,6 +812,13 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field16(&reg, TXRX_CSR8_BBP_ID1_VALID, 0);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR8, reg);
 
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR21, 0xe78f);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR9, 0xff1d);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index bbf1048..5a1330c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1198,6 +1198,15 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_54MBS, 42);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR8, reg);
 
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TIMESTAMP_COMPENSATE, 0);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR6, 0x00000fff);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3ef318e..25d8b66 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1016,6 +1016,15 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_54MBS, 42);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR8, reg);
 
+	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TIMESTAMP_COMPENSATE, 0);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+
 	rt73usb_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
 	rt73usb_register_read(rt2x00dev, MAC_CSR6, &reg);
-- 
1.5.6.1

