Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbXK0NHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 08:07:24 -0500
Message-Id: <20071126225421.252275000@sipsolutions.net> (sfid-20071127_130731_648358_E8CEBC29)
References: <20071126225416.467939000@sipsolutions.net>
Date: Mon, 26 Nov 2007 23:54:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, Michael Wu <flamingice@sourmilk.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH (2.6.24) 2/3]  mac80211: support devices/drivers that
	cannot change MAC address
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwlwifi drivers do not allow changing the MAC address (because the
drivers ignore the MAC address mac80211 gives them). So far I haven't
been successful in making them not ignore it, so this adds mac80211
support for allowing them to disable MAC changing completely.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
---
 include/net/mac80211.h         |    4 ++++
 net/mac80211/ieee80211_iface.c |    7 +++++++
 2 files changed, 11 insertions(+)

--- linux-2.6.orig/include/net/mac80211.h	2007-11-26 23:41:22.279045140 +0100
+++ linux-2.6/include/net/mac80211.h	2007-11-26 23:41:26.219045031 +0100
@@ -662,12 +662,16 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED:
  *	Channels are already configured to the default regulatory domain
  *	specified in the device's EEPROM
+ *
+ * @IEEE80211_HW_NO_MAC_CHANGE_SUPPORT: hardware (or driver) does not
+ *	support changing MAC address away from the pre-programmed one
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
 	IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED	= 1<<3,
+	IEEE80211_HW_NO_MAC_CHANGE_SUPPORT		= 1<<4,
 };
 
 /**
--- linux-2.6.orig/net/mac80211/ieee80211_iface.c	2007-11-26 23:41:22.189044543 +0100
+++ linux-2.6/net/mac80211/ieee80211_iface.c	2007-11-26 23:43:56.529066679 +0100
@@ -38,6 +38,11 @@ static void ieee80211_if_sdata_deinit(st
 	}
 }
 
+static int ieee80211_no_change_mac(struct net_device *dev, void *p)
+{
+	return -EOPNOTSUPP;
+}
+
 /* Must be called with rtnl lock held. */
 int ieee80211_if_add(struct net_device *dev, const char *name,
 		     struct net_device **new_dev, int type)
@@ -63,6 +68,8 @@ int ieee80211_if_add(struct net_device *
 	ndev->mem_start = dev->mem_start;
 	ndev->mem_end = dev->mem_end;
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
+	if (local->hw.flags & IEEE80211_HW_NO_MAC_CHANGE_SUPPORT)
+		ndev->set_mac_address = ieee80211_no_change_mac;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
 	ndev->ieee80211_ptr = &sdata->wdev;

-- 

