Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:45076 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZHHV4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:56:14 -0400
Received: by mail-ew0-f211.google.com with SMTP id 7so1937881ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 14:56:15 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 7/7] [PATCH] rt2x00: FIF_PSPOLL filter flag support
Date: Sat, 8 Aug 2009 23:55:55 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Igor Perminov <igor.perminov@inbox.ru>
References: <200908082353.04274.IvDoorn@gmail.com> <200908082354.51745.IvDoorn@gmail.com> <200908082355.19233.IvDoorn@gmail.com>
In-Reply-To: <200908082355.19233.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908082355.56192.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Perminov <igor.perminov@inbox.ru>

This patch implements FIF_PSPOLL filter flag support in rt2x00 drivers,
which has been introduced in mac80211 (see
http://marc.info/?l=linux-wireless&m=124897986330807&w=2).

Signed-off-by: Igor Perminov <igor.perminov@inbox.ru>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    9 ++++++++-
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c |   17 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    8 +++++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    8 +++++++-
 5 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9efb417..2de0389 100644
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
+	__set_bit(DRIVER_SUPPORT_CONTROL_FILTERS, &rt2x00dev->flags);
+	__set_bit(DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL, &rt2x00dev->flags);
+
+	/*
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 806ef60..99e8959 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -624,6 +624,8 @@ enum rt2x00_flags {
 	 */
 	CONFIG_SUPPORT_HW_BUTTON,
 	CONFIG_SUPPORT_HW_CRYPTO,
+	DRIVER_SUPPORT_CONTROL_FILTERS,
+	DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL,
 
 	/*
 	 * Driver configuration
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 74451f9..cb7b6d4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -392,6 +392,7 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	    FIF_FCSFAIL |
 	    FIF_PLCPFAIL |
 	    FIF_CONTROL |
+	    FIF_PSPOLL |
 	    FIF_OTHER_BSS |
 	    FIF_PROMISC_IN_BSS;
 
@@ -407,6 +408,22 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 
 	/*
+	 * If the device has a single filter for all control frames,
+	 * FIF_CONTROL and FIF_PSPOLL flags imply each other.
+	 * And if the device has more than one filter for control frames
+	 * of different types, but has no a separate filter for PS Poll frames,
+	 * FIF_CONTROL flag implies FIF_PSPOLL.
+	 */
+	if (!test_bit(DRIVER_SUPPORT_CONTROL_FILTERS, &rt2x00dev->flags)) {
+		if (*total_flags & FIF_CONTROL || *total_flags & FIF_PSPOLL)
+			*total_flags |= FIF_CONTROL | FIF_PSPOLL;
+	}
+	if (!test_bit(DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL, &rt2x00dev->flags)) {
+		if (*total_flags & FIF_CONTROL)
+			*total_flags |= FIF_PSPOLL;
+	}
+
+	/*
 	 * Check if there is any work left for us.
 	 */
 	if (rt2x00dev->packet_filter == *total_flags)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index e20dd74..3447997 100644
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
@@ -2624,6 +2624,12 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * This device has multiple filters for control frames,
+	 * but has no a separate filter for PS Poll frames.
+	 */
+	__set_bit(DRIVER_SUPPORT_CONTROL_FILTERS, &rt2x00dev->flags);
+
+	/*
 	 * This device requires firmware and DMA mapped skbs.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4f9b177..4b9955b 100644
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
+	__set_bit(DRIVER_SUPPORT_CONTROL_FILTERS, &rt2x00dev->flags);
+
+	/*
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
-- 
1.6.3.3

