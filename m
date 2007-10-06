Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbXJFMEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:00 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:03:59 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/16] rt2x00: Don't use changed_flags inside configure_packet_filter
Date: Sat, 6 Oct 2007 14:13:38 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061413.39573.IvDoorn@gmail.com> (sfid-20071006_130405_688953_37808E65)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We shouldn't use changed_flags when configuring the packet filter,
we work directly with the total_flags which is safe enough since
we already check if something has changed after we applied our
packet filtering flag rules.
Also make sure that when the packet filter is scheduled, the
rt2x00dev->interface.filter is cleared to make sure the drivers
will update the packet filter instead of failing at the check:
*total_flags == rt2x00dev->interface.filter

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 --
 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 ++++++++++---
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    4 ++--
 7 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 84f807d..ee62daa 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1495,8 +1495,8 @@ static void rt2400pci_configure_filter(struct ieee80211_hw *hw,
 	 * - Some filters are set based on interface type.
 	 */
 	*total_flags |= FIF_ALLMULTI;
-	if (changed_flags & FIF_OTHER_BSS ||
-	    changed_flags & FIF_PROMISC_IN_BSS)
+	if (*total_flags & FIF_OTHER_BSS ||
+	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		*total_flags |= FIF_PROMISC_IN_BSS;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 87a0988..1137c26 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1827,8 +1827,8 @@ static void rt2500pci_configure_filter(struct ieee80211_hw *hw,
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
-	if (changed_flags & FIF_OTHER_BSS ||
-	    changed_flags & FIF_PROMISC_IN_BSS)
+	if (*total_flags & FIF_OTHER_BSS ||
+	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		*total_flags |= FIF_PROMISC_IN_BSS;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index e24ffe6..e7530ae 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1600,8 +1600,8 @@ static void rt2500usb_configure_filter(struct ieee80211_hw *hw,
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
-	if (changed_flags & FIF_OTHER_BSS ||
-	    changed_flags & FIF_PROMISC_IN_BSS)
+	if (*total_flags & FIF_OTHER_BSS ||
+	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		*total_flags |= FIF_PROMISC_IN_BSS;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 82dfcd9..9bb5fb9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -410,8 +410,6 @@ struct rt2x00lib_ops {
 	 */
 	void (*config_mac_addr) (struct rt2x00_dev *rt2x00dev, __le32 *mac);
 	void (*config_bssid) (struct rt2x00_dev *rt2x00dev, __le32 *bssid);
-	void (*config_packet_filter) (struct rt2x00_dev *rt2x00dev,
-				      const unsigned int filter);
 	void (*config_type) (struct rt2x00_dev *rt2x00dev, const int type);
 	void (*config) (struct rt2x00_dev *rt2x00dev, const unsigned int flags,
 			struct ieee80211_conf *conf);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f254753..1e07c39 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -276,11 +276,18 @@ static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, filter_work);
+	unsigned int filter = rt2x00dev->interface.filter;
+
+	/*
+	 * Since we had stored the filter inside interface.filter,
+	 * we should now clear that field. Otherwise the driver will
+	 * assume nothing has changed (*total_flags will be compared
+	 * to interface.filter to determine if any action is required).
+	 */
+	rt2x00dev->interface.filter = 0;
 
 	rt2x00dev->ops->hw->configure_filter(rt2x00dev->hw,
-					     rt2x00dev->interface.filter,
-					     &rt2x00dev->interface.filter,
-					     0, NULL);
+					     filter, &filter, 0, NULL);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2157764..5ae09e3 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2387,8 +2387,8 @@ static void rt61pci_configure_filter(struct ieee80211_hw *hw,
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
-	if (changed_flags & FIF_OTHER_BSS ||
-	    changed_flags & FIF_PROMISC_IN_BSS)
+	if (*total_flags & FIF_OTHER_BSS ||
+	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		*total_flags |= FIF_PROMISC_IN_BSS;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b81ba3d..f48e5fb 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1854,8 +1854,8 @@ static void rt73usb_configure_filter(struct ieee80211_hw *hw,
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
-	if (changed_flags & FIF_OTHER_BSS ||
-	    changed_flags & FIF_PROMISC_IN_BSS)
+	if (*total_flags & FIF_OTHER_BSS ||
+	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
 	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		*total_flags |= FIF_PROMISC_IN_BSS;
-- 
1.5.3.4

