Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx75.mail.ru ([94.100.176.90]:53413 "EHLO mx75.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZGaKsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 06:48:09 -0400
Subject: [RFC PATCH] rt2x00: FIF_PSPOLL filter flag support
From: Igor Perminov <igor.perminov@inbox.ru>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 31 Jul 2009 14:48:02 +0400
Message-Id: <1249037282.2143.15.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements FIF_PSPOLL filter flag support in rt2x00 drivers,
which has been introduced in mac80211 (see
http://marc.info/?l=linux-wireless&m=124897986330807&w=2).

Signed-off-by: Igor Perminov <igor.perminov@inbox.ru>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    9 ++++++++-
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00mac.c |   17 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    8 +++++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    8 +++++++-
 5 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9efb417..569e904 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -518,7 +518,7 @@ static void rt2800usb_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_RTS,
 			   !(filter_flags & FIF_CONTROL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL,
-			   !(filter_flags & FIF_CONTROL));
+			   !(filter_flags & FIF_PSPOLL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 1);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
@@ -2624,6 +2624,13 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * This device has multiple filters for control frames
+	 * and has a separate filter for PS Poll frames.
+	 */
+	__set_bit(DRIVER_HAS_MULTIPLE_CONTROL_FILTER, &rt2x00dev->flags);
+	__set_bit(DRIVER_HAS_PSPOLL_FILTER, &rt2x00dev->flags);
+
+	/*
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index cbec91e..b958e0d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -607,6 +607,12 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_L2PAD,
 
 	/*
+	 * Driver capabilities
+	 */
+	DRIVER_HAS_MULTIPLE_CONTROL_FILTER,
+	DRIVER_HAS_PSPOLL_FILTER,
+
+	/*
 	 * Driver features
 	 */
 	CONFIG_SUPPORT_HW_BUTTON,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e92c8f9..eba168d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -407,6 +407,7 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	    FIF_FCSFAIL |
 	    FIF_PLCPFAIL |
 	    FIF_CONTROL |
+	    FIF_PSPOLL |
 	    FIF_OTHER_BSS |
 	    FIF_PROMISC_IN_BSS;
 
@@ -422,6 +423,22 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 
 	/*
+	 * If the device has a single filter for all control frames,
+	 * FIF_CONTROL and FIF_PSPOLL flags imply each other.
+	 * And if the device has more than one filter for control frames
+	 * of different types, but has no a separate filter for PS Poll frames,
+	 * FIF_CONTROL flag implies FIF_PSPOLL.
+	 */
+	if (!test_bit(DRIVER_HAS_MULTIPLE_CONTROL_FILTER, &rt2x00dev->flags)) {
+		if (*total_flags & FIF_CONTROL ||
+			*total_flags & FIF_PSPOLL)
+			*total_flags |= FIF_CONTROL | FIF_PSPOLL;
+	} else if (!test_bit(DRIVER_HAS_PSPOLL_FILTER, &rt2x00dev->flags)) {
+		if (*total_flags & FIF_CONTROL)
+			*total_flags |= FIF_PSPOLL;
+	}
+
+	/*
 	 * Check if there is any work left for us.
 	 */
 	if (rt2x00dev->packet_filter == *total_flags)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fb95b8c..2f5a209 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -530,7 +530,7 @@ static void rt61pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
-			   !(filter_flags & FIF_CONTROL));
+			   !(filter_flags & (FIF_CONTROL | FIF_PSPOLL)));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
@@ -2619,6 +2619,12 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * This device has multiple filters for control frames,
+	 * but has no a separate filter for PS Poll frames.
+	 */
+	__set_bit(DRIVER_HAS_MULTIPLE_CONTROL_FILTER, &rt2x00dev->flags);
+
+	/*
 	 * This device requires firmware and DMA mapped skbs.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4f9b177..a89fcb7 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -493,7 +493,7 @@ static void rt73usb_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
-			   !(filter_flags & FIF_CONTROL));
+			   !(filter_flags & (FIF_CONTROL | FIF_PSPOLL)));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
@@ -2144,6 +2144,12 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * This device has multiple filters for control frames,
+	 * but has no a separate filter for PS Poll frames.
+	 */
+	__set_bit(DRIVER_HAS_MULTIPLE_CONTROL_FILTER, &rt2x00dev->flags);
+
+	/*
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);


