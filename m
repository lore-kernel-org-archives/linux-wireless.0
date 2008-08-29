Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39739 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbYH2W6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 18:58:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH v3] cfg80211: keep track of supported interface modes
Date: Fri, 29 Aug 2008 15:58:03 -0700
Message-ID: <1220050683-11846-1-git-send-email-lrodriguez@atheros.com> (sfid-20080830_005813_863873_512EC553)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is obviously good for userspace to know up front which
interface modes a given piece of hardware might support (even
if adding such an interface might fail later because of
concurrency issues), so let's make cfg80211 aware of that.
For good measure, disallow adding interfaces in all other
modes so drivers don't forget to announce support for one mode
when they add it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

This v3 patch incorporates the ACK'd version of the changes by Ivo.
It also applies *before* the new regulatory infrastructure patches.

 drivers/net/wireless/adm8211.c              |    1 +
 drivers/net/wireless/at76_usb.c             |    2 ++
 drivers/net/wireless/ath5k/base.c           |    5 +++++
 drivers/net/wireless/ath9k/main.c           |    5 +++++
 drivers/net/wireless/b43/main.c             |    7 +++++++
 drivers/net/wireless/b43legacy/main.c       |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 ++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++++
 drivers/net/wireless/mac80211_hwsim.c       |    3 +++
 drivers/net/wireless/p54/p54common.c        |    3 +++
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    5 +++++
 drivers/net/wireless/rtl8187_dev.c          |    2 ++
 drivers/net/wireless/zd1211rw/zd_mac.c      |    5 +++++
 include/linux/nl80211.h                     |    6 ++++++
 include/net/wireless.h                      |    3 +++
 net/mac80211/main.c                         |    7 +++++++
 net/wireless/core.c                         |    9 ++++++++-
 net/wireless/nl80211.c                      |   22 ++++++++++++++++++++--
 18 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 3333d45..c6a55cd 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1884,6 +1884,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
 	/* dev->flags = IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
 	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	dev->channel_change_time = 1000;
 	dev->max_signal = 100;    /* FIXME: find better value */
diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 29ebdd2..7533fb2 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -2547,6 +2547,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 		priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 				  IEEE80211_HW_SIGNAL_UNSPEC;
 
+	priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index bcec74e..d645ad3 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -485,6 +485,11 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
+
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	hw->extra_tx_headroom = 2;
 	hw->channel_change_time = 5000;
 	sc = hw->priv;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index dc45eef..39a4a70 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1482,6 +1482,11 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM;
 
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 63bafc2..2d915c1 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4569,6 +4569,13 @@ static int b43_wireless_init(struct ssb_device *dev)
 		    IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_WDS) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	hw->queues = b43_modparam_qos ? 4 : 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1cb77db..68f63f5 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3704,6 +3704,11 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_WDS) |
+		BIT(NL80211_IFTYPE_ADHOC);
 	hw->queues = 1; /* FIXME: hardware has more queues */
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fbf75a6..0a511ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -819,6 +819,10 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 	/* queues to support 11n aggregation */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a622fc3..cee3045 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7888,6 +7888,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 732429d..6ba50f0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -447,6 +447,9 @@ static int __init init_mac80211_hwsim(void)
 
 		hw->channel_change_time = 1;
 		hw->queues = 4;
+		hw->wiphy->interface_modes =
+			BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_AP);
 		hw->ampdu_queues = 1;
 
 		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 17e06bb..6da98e6 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1072,6 +1072,9 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		     IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_UNSPEC;
+
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_signal = 127;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 369b0b2..2f3bfc6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1052,6 +1052,11 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->vif_data_size = sizeof(struct rt2x00_intf);
 
+	rt2x00dev->hw->wiphy->interface_modes =
+	    BIT(NL80211_IFTYPE_AP) |
+	    BIT(NL80211_IFTYPE_STATION) |
+	    BIT(NL80211_IFTYPE_ADHOC);
+
 	/*
 	 * Let the driver probe the device to detect the capabilities.
 	 */
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 060a265..8a42bfa 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -1184,6 +1184,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 		dev->max_signal = 65;
 	}
 
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+
 	if ((id->driver_info == DEVICE_RTL8187) && priv->is_rtl8187b)
 		printk(KERN_INFO "rtl8187: inconsistency between id with OEM"
 		       " info!\n");
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 4d7b98b..e019102 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -937,6 +937,11 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_SIGNAL_DB;
 
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	hw->max_signal = 100;
 	hw->queues = 1;
 	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0c1147d..5e51f4e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -210,6 +210,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_HT_CAPABILITY: HT Capability information element (from
  *	association request when used with NL80211_CMD_NEW_STATION)
  *
+ * @NL80211_ATTR_SUPPORTED_IFTYPES: nested attribute containing all
+ *	supported interface types, each a flag attribute with the number
+ *	of the interface mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -259,6 +263,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HT_CAPABILITY,
 
+	NL80211_ATTR_SUPPORTED_IFTYPES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 9324f8d..1dc8ec3 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -185,6 +185,9 @@ struct wiphy {
 	/* permanent MAC address */
 	u8 perm_addr[ETH_ALEN];
 
+	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
+	u16 interface_modes;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 638b75f..396cfb2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1675,6 +1675,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 	}
 
+	/* if low-level driver supports AP, we also support VLAN */
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP))
+		local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+
+	/* mac80211 always supports monitor */
+	local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		return result;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f1da0b9..7e995ac 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1,7 +1,7 @@
 /*
  * This is the linux wireless configuration interface.
  *
- * Copyright 2006, 2007		Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2008		Johannes Berg <johannes@sipsolutions.net>
  */
 
 #include <linux/if.h>
@@ -259,6 +259,13 @@ int wiphy_register(struct wiphy *wiphy)
 	struct ieee80211_supported_band *sband;
 	bool have_band = false;
 	int i;
+	u16 ifmodes = wiphy->interface_modes;
+
+	/* sanity check ifmodes */
+	WARN_ON(!ifmodes);
+	ifmodes &= ((1 << __NL80211_IFTYPE_AFTER_LAST) - 1) & ~1;
+	if (WARN_ON(ifmodes != wiphy->interface_modes))
+		wiphy->interface_modes = ifmodes;
 
 	/* sanity check supported bands/channels */
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4d6c02a..77880ba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -113,10 +113,12 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_rates, *nl_rate;
+	struct nlattr *nl_modes;
 	enum ieee80211_band band;
 	struct ieee80211_channel *chan;
 	struct ieee80211_rate *rate;
 	int i;
+	u16 ifmodes = dev->wiphy.interface_modes;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
@@ -125,6 +127,20 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
 
+	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
+	if (!nl_modes)
+		goto nla_put_failure;
+
+	i = 0;
+	while (ifmodes) {
+		if (ifmodes & 1)
+			NLA_PUT_FLAG(msg, i);
+		ifmodes >>= 1;
+		i++;
+	}
+
+	nla_nest_end(msg, nl_modes);
+
 	nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 	if (!nl_bands)
 		goto nla_put_failure;
@@ -415,7 +431,8 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 	ifindex = dev->ifindex;
 	dev_put(dev);
 
-	if (!drv->ops->change_virtual_intf) {
+	if (!drv->ops->change_virtual_intf ||
+	    !(drv->wiphy.interface_modes & (1 << type))) {
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -462,7 +479,8 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(drv))
 		return PTR_ERR(drv);
 
-	if (!drv->ops->add_virtual_intf) {
+	if (!drv->ops->add_virtual_intf ||
+	    !(drv->wiphy.interface_modes & (1 << type))) {
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
-- 
1.5.6.4

