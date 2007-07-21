Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:64476 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758316AbXGUU7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:59:16 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: monitor all packets
Message-Id: <20070721205918.3DEA37B409F@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:59:17 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

While in monitor mode the zd1211rw received only a limited
set of packets. This patch forwards now all packets the device
receives. Notify that while monitoring no FCS checks are done; so
strange packets might appear in the network sniffer of your
choice.

ATTENTION: Support for multiple interfaces on a single ZD1211
device is currently broken. So this code works only on the first
interface.

Here is an example to put the device in monitor mode.

iwconfig wlan0 mode monitor
ifconfig wlan0 up
iwconfig wlan0 channel 10

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.h |    5 --
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c  |   47 ++++++++++++++++-----
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.h  |    2 +-
 3 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
index a53ba52..1ab15a0 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
@@ -850,11 +850,6 @@ static inline int zd_chip_get_basic_rates(struct zd_chip *chip, u16 *cr_rates)
 
 int zd_chip_set_basic_rates(struct zd_chip *chip, u16 cr_rates);
 
-static inline int zd_chip_set_rx_filter(struct zd_chip *chip, u32 filter)
-{
-	return zd_iowrite32(chip, CR_RX_FILTER, filter);
-}
-
 int zd_chip_lock_phy_regs(struct zd_chip *chip);
 int zd_chip_unlock_phy_regs(struct zd_chip *chip);
 
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index b7fa301..1c16f66 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -170,13 +170,31 @@ void zd_mac_clear(struct zd_mac *mac)
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-static int reset_mode(struct zd_mac *mac)
+static int set_rx_filter(struct zd_mac *mac)
 {
-	u32 filter = mac->mode == IEEE80211_IF_TYPE_MNTR ? ~0 : STA_RX_FILTER;
+	u32 filter = mac->type == IEEE80211_IF_TYPE_MNTR ? ~0 : STA_RX_FILTER;
 
 	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
+static int set_sniffer(struct zd_mac *mac)
+{
+	return zd_iowrite32(&mac->chip, CR_SNIFFER_ON,
+		mac->type == IEEE80211_IF_TYPE_MNTR ? 1 : 0);
+	return 0;
+}
+
+static int set_mc_hash(struct zd_mac *mac)
+{
+	struct zd_mc_hash hash;
+
+	zd_mc_clear(&hash);
+	if (mac->type == IEEE80211_IF_TYPE_MNTR)
+		zd_mc_add_all(&hash);
+
+	return zd_chip_set_multicast_hash(&mac->chip, &hash);
+}
+
 static int zd_mac_open(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
@@ -200,7 +218,13 @@ static int zd_mac_open(struct ieee80211_hw *hw)
 	r = zd_chip_set_basic_rates(chip, CR_RATES_80211B | CR_RATES_80211G);
 	if (r < 0)
 		goto disable_int;
-	r = reset_mode(mac);
+	r = set_rx_filter(mac);
+	if (r)
+		goto disable_int;
+	r = set_sniffer(mac);
+	if (r)
+		goto disable_int;
+	r = set_mc_hash(mac);
 	if (r)
 		goto disable_int;
 	r = zd_chip_switch_radio_on(chip);
@@ -660,9 +684,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 	length -= ZD_PLCP_HEADER_SIZE + sizeof(struct rx_status);
 	buffer += ZD_PLCP_HEADER_SIZE;
 
-	if (length == (10 /* IEEE80211_1ADDR_LEN */ + FCS_LEN) &&
-	    filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
-	    mac->mode != IEEE80211_IF_TYPE_MNTR)
+	if (filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
+	    mac->type != IEEE80211_IF_TYPE_MNTR)
 		return 0;
 
 	skb = dev_alloc_skb(length);
@@ -680,13 +703,13 @@ static int zd_mac_add_interface(struct ieee80211_hw *hw,
 	struct zd_mac *mac = zd_hw_mac(hw);
 
 	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
-	if (mac->mode != IEEE80211_IF_TYPE_MGMT)
+	if (mac->type != IEEE80211_IF_TYPE_MGMT)
 		return -1;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_STA:
-		mac->mode = conf->type;
+		mac->type = conf->type;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -701,7 +724,7 @@ static void zd_mac_remove_interface(struct ieee80211_hw *hw,
 				    struct ieee80211_if_init_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	mac->mode = IEEE80211_IF_TYPE_MGMT;
+	mac->type = IEEE80211_IF_TYPE_MGMT;
 }
 
 static int zd_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
@@ -741,7 +764,9 @@ static void zd_mac_set_multicast_list(struct ieee80211_hw *hw,
 	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
 
-	if (dev_flags & (IFF_PROMISC|IFF_ALLMULTI)) {
+	if ((dev_flags & (IFF_PROMISC|IFF_ALLMULTI)) ||
+            mac->type == IEEE80211_IF_TYPE_MNTR)
+	{
 		zd_mc_add_all(&hash);
 	} else {
 		struct dev_mc_list *mc = NULL;
@@ -789,7 +814,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	spin_lock_init(&mac->lock);
 	mac->hw = hw;
 
-	mac->mode = IEEE80211_IF_TYPE_MGMT;
+	mac->type = IEEE80211_IF_TYPE_MGMT;
 	mac->hwaddr = hw->wiphy->perm_addr;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
index 6702f85..4255b10 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
@@ -151,7 +151,7 @@ struct zd_mac {
 	struct zd_mc_hash multicast_hash;
 	u8 regdomain;
 	u8 default_regdomain;
-	int mode;
+	int type;
 	int associated;
 	u8 *hwaddr;
 	struct sk_buff_head ack_wait_queue;
-- 
1.5.2.2

