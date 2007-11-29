Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759760AbXK2BgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 20:36:09 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/2] mac80211: set interface MAC address after driver's start() is called
Date: Thu, 29 Nov 2007 09:34:06 +0800
Message-Id: <1196300047-6201-1-git-send-email-yi.zhu@intel.com> (sfid-20071129_013615_457152_DDE3939F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch enables mac80211 to set interface MAC address after the
interface is UP. This is useful for wireless drivers load their firmware
in the mac80211 interface start() callback (called when interface UP).
Because for kernel built-in (vs. module) network drivers, they are
initialized in a very early stage (even before hard disk is ready). So
loading firmwares in the device pci_probe time is not a good idea. Some
devices for example iwlwifi cannot get MAC address without firmware being
loaded first.

It also sets mac80211 dev->validate_addr to NULL so that we don't need to
have a MAC address in the dev->open time.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/ieee80211.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 59350b8..e3ccaa0 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -218,6 +218,9 @@ static int ieee80211_open(struct net_device *dev)
 			return res;
 	}
 
+	if (is_zero_ether_addr(dev->dev_addr))
+		memcpy(dev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
+
 	switch (sdata->type) {
 	case IEEE80211_IF_TYPE_VLAN:
 		list_add(&sdata->u.vlan.list, &sdata->u.vlan.ap->u.ap.vlans);
@@ -428,6 +431,7 @@ void ieee80211_if_setup(struct net_device *dev)
 	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->set_multicast_list = ieee80211_set_multicast_list;
 	dev->change_mtu = ieee80211_change_mtu;
+	dev->validate_addr = NULL;
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
 	dev->destructor = ieee80211_if_free;
@@ -1007,6 +1011,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	sta_info_init(local);
 
 	mdev->hard_start_xmit = ieee80211_master_start_xmit;
+	mdev->validate_addr = NULL;
 	mdev->open = ieee80211_master_open;
 	mdev->stop = ieee80211_master_stop;
 	mdev->type = ARPHRD_IEEE80211;
-- 
1.5.3.6
