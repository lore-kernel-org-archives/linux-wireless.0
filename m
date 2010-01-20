Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0ATLHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 06:07:46 -0500
Subject: [PATCH] cfg80211: export multiple MAC addresses in sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 12:02:33 +0100
Message-ID: <1263985353.2819.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a device has multiple MAC addresses, userspace will
need to know about that. Similarly, if it allows the
MAC addresses to vary by a bitmask.

If a driver exports multiple addresses, it is assumed
that it will be able to deal with that many different
addresses, which need not necessarily match the ones
programmed into the device; if a mask is set then the
device should deal addresses within that mask based
on an arbitrary "base address".

To test it all and show how it is used, add support
to hwsim even though it can't actually deal with
addresses different from the default.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    8 +++++++-
 include/net/cfg80211.h                |   22 +++++++++++++++++++++-
 net/wireless/core.c                   |   12 ++++++++++++
 net/wireless/sysfs.c                  |   20 ++++++++++++++++++++
 4 files changed, 60 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-01-20 12:01:36.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-01-20 12:01:38.000000000 +0100
@@ -1195,6 +1195,10 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION	= BIT(6),
 };
 
+struct mac_address {
+	u8 addr[ETH_ALEN];
+};
+
 /**
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
@@ -1213,12 +1217,28 @@ enum wiphy_flags {
  *	-1 = fragmentation disabled, only odd values >= 256 used
  * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
  * @net: the network namespace this wiphy currently lives in
+ * @perm_addr: permanent MAC address of this device
+ * @addr_mask: If the device supports multiple MAC addresses by masking,
+ *	set this to a mask with variable bits set to 1, e.g. if the last
+ *	four bits are variable then set it to 00:...:00:0f. The actual
+ *	variable bits shall be determined by the interfaces added, with
+ *	interfaces not matching the mask being rejected to be brought up.
+ * @n_addresses: number of addresses in @addresses.
+ * @addresses: If the device has more than one address, set this pointer
+ *	to a list of addresses (6 bytes each). The first one will be used
+ *	by default for perm_addr. In this case, the mask should be set to
+ *	all-zeroes. In this case it is assumed that the device can handle
+ *	the same number of arbitrary MAC addresses.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
 
-	/* permanent MAC address */
+	/* permanent MAC address(es) */
 	u8 perm_addr[ETH_ALEN];
+	u8 addr_mask[ETH_ALEN];
+
+	u16 n_addresses;
+	struct mac_address *addresses;
 
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
--- wireless-testing.orig/net/wireless/core.c	2010-01-20 12:01:35.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2010-01-20 12:01:38.000000000 +0100
@@ -413,6 +413,18 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
+	if (WARN_ON(wiphy->addresses && !wiphy->n_addresses))
+		return -EINVAL;
+
+	if (WARN_ON(wiphy->addresses &&
+		    !is_zero_ether_addr(wiphy->perm_addr) &&
+		    memcmp(wiphy->perm_addr, wiphy->addresses[0].addr,
+		    	   ETH_ALEN)))
+		return -EINVAL;
+
+	if (wiphy->addresses)
+		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
+
 	/* sanity check ifmodes */
 	WARN_ON(!ifmodes);
 	ifmodes &= ((1 << __NL80211_IFTYPE_AFTER_LAST) - 1) & ~1;
--- wireless-testing.orig/net/wireless/sysfs.c	2010-01-20 12:01:33.000000000 +0100
+++ wireless-testing/net/wireless/sysfs.c	2010-01-20 12:01:38.000000000 +0100
@@ -33,10 +33,30 @@ static ssize_t name ## _show(struct devi
 
 SHOW_FMT(index, "%d", wiphy_idx);
 SHOW_FMT(macaddress, "%pM", wiphy.perm_addr);
+SHOW_FMT(address_mask, "%pM", wiphy.addr_mask);
+
+static ssize_t addresses_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct wiphy *wiphy = &dev_to_rdev(dev)->wiphy;
+	char *start = buf;
+	int i;
+
+	if (!wiphy->addresses)
+		return sprintf(buf, "%pM\n", wiphy->perm_addr);
+
+	for (i = 0; i < wiphy->n_addresses; i++)
+		buf += sprintf(buf, "%pM\n", &wiphy->addresses[i].addr);
+
+	return buf - start;
+}
 
 static struct device_attribute ieee80211_dev_attrs[] = {
 	__ATTR_RO(index),
 	__ATTR_RO(macaddress),
+	__ATTR_RO(address_mask),
+	__ATTR_RO(addresses),
 	{}
 };
 
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-01-20 12:01:36.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-01-20 12:01:38.000000000 +0100
@@ -281,6 +281,8 @@ struct mac80211_hwsim_data {
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
 
+	struct mac_address addresses[2];
+
 	struct ieee80211_channel *channel;
 	unsigned long beacon_int; /* in jiffies unit */
 	unsigned int rx_filter;
@@ -1154,7 +1156,11 @@ static int __init init_mac80211_hwsim(vo
 		SET_IEEE80211_DEV(hw, data->dev);
 		addr[3] = i >> 8;
 		addr[4] = i;
-		SET_IEEE80211_PERM_ADDR(hw, addr);
+		memcpy(data->addresses[0].addr, addr, ETH_ALEN);
+		memcpy(data->addresses[1].addr, addr, ETH_ALEN);
+		data->addresses[1].addr[0] |= 0x40;
+		hw->wiphy->n_addresses = 2;
+		hw->wiphy->addresses = data->addresses;
 
 		hw->channel_change_time = 1;
 		hw->queues = 4;


