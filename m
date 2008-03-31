Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:25598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbYCaNZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 09:25:13 -0400
Received: by ug-out-1314.google.com with SMTP id z38so438266ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 06:25:11 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH] rt2x00: TO_DS filter depends on intf_ap_count
Date: Mon, 31 Mar 2008 15:24:53 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	Bas Hulsken <bhulsken@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803311524.53768.IvDoorn@gmail.com> (sfid-20080331_142518_095494_5A9DE8A1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TO_DS filter does not only depend on the FIF_PROMISC_IN_BSS flag
provided by mac80211, but also on the intf_ap_count count.
This makes sense, since when Master mode is active, we should all frames
that are send to the active AP (the device itself).

This means that when an interface is added we should force the
packet filter to be updated during the next mac80211 call of
configure_filter() to make sure the intf_ap_count field is checked.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2500pci.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    7 +++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
 6 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a6e9c89..9abdfb8 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -290,7 +290,8 @@ static void rt2400pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
 	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
+			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1bdb873..54c9a75 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -291,7 +291,8 @@ static void rt2500pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
 	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
+			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST,
 			   !(filter_flags & FIF_ALLMULTI));
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f5c18f0..28fdf19 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -337,7 +337,8 @@ static void rt2500usb_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
+			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST,
 			   !(filter_flags & FIF_ALLMULTI));
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index a0adf5a..dc70e7a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -253,6 +253,13 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 */
 	rt2x00lib_config_intf(rt2x00dev, intf, conf->type, intf->mac, NULL);
 
+	/*
+	 * Some filters depend on the current working mode. We can force
+	 * an update during the next configure_filter() run by mac80211 by
+	 * resetting the current packet_filter state.
+	 */
+	rt2x00dev->packet_filter = 0;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0d2e6f7..c5c6251 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -342,7 +342,8 @@ static void rt61pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
+			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
 			   !(filter_flags & FIF_ALLMULTI));
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b3c8462..796cf29 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -354,7 +354,8 @@ static void rt73usb_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
-			   !(filter_flags & FIF_PROMISC_IN_BSS));
+			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
+			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
 			   !(filter_flags & FIF_ALLMULTI));
-- 
1.5.4.5

