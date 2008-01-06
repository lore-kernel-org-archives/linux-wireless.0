Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYAFWmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:42:50 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:42:49 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/12] rt2x00: Move packet filter flags
Date: Sun, 6 Jan 2008 23:40:49 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062340.49634.IvDoorn@gmail.com> (sfid-20080106_224255_128069_B5294D8F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The packet filter flags don't belong in the interface structure
because they are device based instead of interface based.
So move the filter fields out of struct interface and into rt2x00_dev.

Additionally we shouldn't change the filter based on the working
mode, if such a thing is needed than mac80211 should have done that.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    8 ++------
 drivers/net/wireless/rt2x00/rt2500pci.c |    8 ++------
 drivers/net/wireless/rt2x00/rt2500usb.c |    8 ++------
 drivers/net/wireless/rt2x00/rt2x00.h    |   12 +++++++-----
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    8 ++------
 drivers/net/wireless/rt2x00/rt73usb.c   |    8 ++------
 7 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 9eed9e9..b042eb5 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1422,7 +1422,6 @@ static void rt2400pci_configure_filter(struct ieee80211_hw *hw,
 				       struct dev_addr_list *mc_list)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -1441,21 +1440,18 @@ static void rt2400pci_configure_filter(struct ieee80211_hw *hw,
 	 * Apply some rules to the filters:
 	 * - Some filters imply different filters to be set.
 	 * - Some things we can't filter out at all.
-	 * - Some filters are set based on interface type.
 	 */
 	*total_flags |= FIF_ALLMULTI;
 	if (*total_flags & FIF_OTHER_BSS ||
 	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		*total_flags |= FIF_PROMISC_IN_BSS;
 
 	/*
 	 * Check if there is any work left for us.
 	 */
-	if (intf->filter == *total_flags)
+	if (rt2x00dev->packet_filter == *total_flags)
 		return;
-	intf->filter = *total_flags;
+	rt2x00dev->packet_filter = *total_flags;
 
 	/*
 	 * Start configuration steps.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 8b2f54b..c92163d 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1751,7 +1751,6 @@ static void rt2500pci_configure_filter(struct ieee80211_hw *hw,
 				       struct dev_addr_list *mc_list)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -1770,22 +1769,19 @@ static void rt2500pci_configure_filter(struct ieee80211_hw *hw,
 	 * Apply some rules to the filters:
 	 * - Some filters imply different filters to be set.
 	 * - Some things we can't filter out at all.
-	 * - Some filters are set based on interface type.
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
 	if (*total_flags & FIF_OTHER_BSS ||
 	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		*total_flags |= FIF_PROMISC_IN_BSS;
 
 	/*
 	 * Check if there is any work left for us.
 	 */
-	if (intf->filter == *total_flags)
+	if (rt2x00dev->packet_filter == *total_flags)
 		return;
-	intf->filter = *total_flags;
+	rt2x00dev->packet_filter = *total_flags;
 
 	/*
 	 * Start configuration steps.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 27d34dd..576f0f8 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1611,7 +1611,6 @@ static void rt2500usb_configure_filter(struct ieee80211_hw *hw,
 				       struct dev_addr_list *mc_list)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
 	u16 reg;
 
 	/*
@@ -1630,22 +1629,19 @@ static void rt2500usb_configure_filter(struct ieee80211_hw *hw,
 	 * Apply some rules to the filters:
 	 * - Some filters imply different filters to be set.
 	 * - Some things we can't filter out at all.
-	 * - Some filters are set based on interface type.
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
 	if (*total_flags & FIF_OTHER_BSS ||
 	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		*total_flags |= FIF_PROMISC_IN_BSS;
 
 	/*
 	 * Check if there is any work left for us.
 	 */
-	if (intf->filter == *total_flags)
+	if (rt2x00dev->packet_filter == *total_flags)
 		return;
-	intf->filter = *total_flags;
+	rt2x00dev->packet_filter = *total_flags;
 
 	/*
 	 * When in atomic context, reschedule and let rt2x00lib
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index af0bf4b..0dc880c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -388,11 +388,6 @@ struct interface {
 	 * BBSID of the AP to associate with.
 	 */
 	u8 bssid[ETH_ALEN];
-
-	/*
-	 * Store the packet filter mode for the current interface.
-	 */
-	unsigned int filter;
 };
 
 static inline int is_interface_present(struct interface *intf)
@@ -676,6 +671,13 @@ struct rt2x00_dev {
 	struct mutex usb_cache_mutex;
 
 	/*
+	 * Current packet filter configuration for the device.
+	 * This contains all currently active FIF_* flags send
+	 * to us by mac80211 during configure_filter().
+	 */
+	unsigned int packet_filter;
+
+	/*
 	 * Interface configuration.
 	 */
 	struct interface interface;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index cea2bd9..911060d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -417,7 +417,7 @@ static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, filter_work);
-	unsigned int filter = rt2x00dev->interface.filter;
+	unsigned int filter = rt2x00dev->packet_filter;
 
 	/*
 	 * Since we had stored the filter inside interface.filter,
@@ -425,7 +425,7 @@ static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
 	 * assume nothing has changed (*total_flags will be compared
 	 * to interface.filter to determine if any action is required).
 	 */
-	rt2x00dev->interface.filter = 0;
+	rt2x00dev->packet_filter = 0;
 
 	rt2x00dev->ops->hw->configure_filter(rt2x00dev->hw,
 					     filter, &filter, 0, NULL);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3bfc5af..34bd90b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2311,7 +2311,6 @@ static void rt61pci_configure_filter(struct ieee80211_hw *hw,
 				     struct dev_addr_list *mc_list)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -2330,22 +2329,19 @@ static void rt61pci_configure_filter(struct ieee80211_hw *hw,
 	 * Apply some rules to the filters:
 	 * - Some filters imply different filters to be set.
 	 * - Some things we can't filter out at all.
-	 * - Some filters are set based on interface type.
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
 	if (*total_flags & FIF_OTHER_BSS ||
 	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		*total_flags |= FIF_PROMISC_IN_BSS;
 
 	/*
 	 * Check if there is any work left for us.
 	 */
-	if (intf->filter == *total_flags)
+	if (rt2x00dev->packet_filter == *total_flags)
 		return;
-	intf->filter = *total_flags;
+	rt2x00dev->packet_filter = *total_flags;
 
 	/*
 	 * Start configuration steps.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9393415..f2d1810 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1846,7 +1846,6 @@ static void rt73usb_configure_filter(struct ieee80211_hw *hw,
 				     struct dev_addr_list *mc_list)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -1865,22 +1864,19 @@ static void rt73usb_configure_filter(struct ieee80211_hw *hw,
 	 * Apply some rules to the filters:
 	 * - Some filters imply different filters to be set.
 	 * - Some things we can't filter out at all.
-	 * - Some filters are set based on interface type.
 	 */
 	if (mc_count)
 		*total_flags |= FIF_ALLMULTI;
 	if (*total_flags & FIF_OTHER_BSS ||
 	    *total_flags & FIF_PROMISC_IN_BSS)
 		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		*total_flags |= FIF_PROMISC_IN_BSS;
 
 	/*
 	 * Check if there is any work left for us.
 	 */
-	if (intf->filter == *total_flags)
+	if (rt2x00dev->packet_filter == *total_flags)
 		return;
-	intf->filter = *total_flags;
+	rt2x00dev->packet_filter = *total_flags;
 
 	/*
 	 * When in atomic context, reschedule and let rt2x00lib
-- 
1.5.3.7

