Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:28092 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbYAFWjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:39:54 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071048ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:39:53 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/12] rt2x00: Only set the TBCN flag when the interface is configured to send beacons.
Date: Sun, 6 Jan 2008 23:38:58 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062338.58811.IvDoorn@gmail.com> (sfid-20080106_224010_517953_BA928B59)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These flags used to be fixed to one in rt2500pci_config_type, which
caused the beacon timer interrupt to fire. This would lead to
rt2x00lib_beacondone adding work which called
rt2x00lib_beacondone_scheduled which called ieee80211_beacon_get which
printed an error about not having any beacon data.

With this patch, these interrupts are only generated when the interface
is configured to send beacons.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 ++-
 drivers/net/wireless/rt2x00/rt61pci.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index c9a234f..9eed9e9 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -280,7 +280,7 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	 */
 	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
+	rt2x00_set_field32(&reg, CSR14_TBCN, (tsf_sync == TSF_SYNC_BEACON));
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, tsf_sync);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a623454..8b2f54b 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -284,7 +284,7 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	 */
 	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
+	rt2x00_set_field32(&reg, CSR14_TBCN, (tsf_sync == TSF_SYNC_BEACON));
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, tsf_sync);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 2ba8eda..27d34dd 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -327,7 +327,8 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
-	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN,
+			   (tsf_sync == TSF_SYNC_BEACON));
 	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
 	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, tsf_sync);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 13c8086..f5b3378 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -317,7 +317,8 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	 */
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE,
+			  (tsf_sync == TSF_SYNC_BEACON));
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, tsf_sync);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 8093a4d..9393415 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -327,7 +327,8 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	 */
 	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE,
+			   (tsf_sync == TSF_SYNC_BEACON));
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, tsf_sync);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
-- 
1.5.3.7

