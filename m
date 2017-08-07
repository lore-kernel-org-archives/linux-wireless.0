Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34891 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdHGBgO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Aug 2017 21:36:14 -0400
Received: by mail-pf0-f195.google.com with SMTP id j68so7579056pfc.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Aug 2017 18:36:13 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [v2 PATCH] mwifiex: p2p: use separate device address
Date: Mon,  7 Aug 2017 01:36:06 +0000
Message-Id: <1502069766-25841-1-git-send-email-huxinming820@gmail.com> (sfid-20170807_033618_201017_6E366B0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Per below statement about p2p device address in WFA P2P
spec $2.4.3:

The P2P Device Address of a P2P Device shall be its globally
administered MAC address, or its globally administered MAC
address with the locally administered bit set.

This patch follow above statement, using a separate device
address for p2p interface

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v2: Use BIT_ULL to fix kbuild test robot reported issue
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  5 +++-
 drivers/net/wireless/marvell/mwifiex/main.c     | 40 ++++++++++++++++---------
 drivers/net/wireless/marvell/mwifiex/main.h     |  4 +++
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index d8ff823..c4382d0 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -927,6 +927,8 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 	adapter->rx_locked = false;
 	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 
+	mwifiex_set_mac_address(priv, dev);
+
 	return 0;
 }
 
@@ -2967,6 +2969,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	}
 
 	mwifiex_init_priv_params(priv, dev);
+	mwifiex_set_mac_address(priv, dev);
+
 	priv->netdev = dev;
 
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
@@ -2994,7 +2998,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	dev_net_set(dev, wiphy_net(wiphy));
 	dev->ieee80211_ptr = &priv->wdev;
 	dev->ieee80211_ptr->iftype = priv->bss_mode;
-	memcpy(dev->dev_addr, wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(dev, wiphy_dev(wiphy));
 
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index f2600b8..c6cc068 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -935,31 +935,44 @@ struct sk_buff *
 	return 0;
 }
 
-/*
- * CFG802.11 network device handler for setting MAC address.
- */
-static int
-mwifiex_set_mac_address(struct net_device *dev, void *addr)
+int mwifiex_set_mac_address(struct mwifiex_private *priv,
+			    struct net_device *dev)
 {
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct sockaddr *hw_addr = addr;
 	int ret;
+	u64 mac_addr;
 
-	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
+	if (priv->bss_type != MWIFIEX_BSS_TYPE_P2P)
+		goto done;
+
+	mac_addr = ether_addr_to_u64(priv->curr_addr);
+	mac_addr |= BIT_ULL(MWIFIEX_MAC_LOCAL_ADMIN_BIT);
+	u64_to_ether_addr(mac_addr, priv->curr_addr);
 
 	/* Send request to firmware */
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
 			       HostCmd_ACT_GEN_SET, 0, NULL, true);
 
-	if (!ret)
-		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
-	else
+	if (ret) {
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "set mac address failed: ret=%d\n", ret);
+		return ret;
+	}
 
+done:
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
+	return 0;
+}
 
-	return ret;
+/* CFG802.11 network device handler for setting MAC address.
+ */
+static int
+mwifiex_ndo_set_mac_address(struct net_device *dev, void *addr)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct sockaddr *hw_addr = addr;
+
+	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
+	return mwifiex_set_mac_address(priv, dev);
 }
 
 /*
@@ -1252,7 +1265,7 @@ static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 	.ndo_open = mwifiex_open,
 	.ndo_stop = mwifiex_close,
 	.ndo_start_xmit = mwifiex_hard_start_xmit,
-	.ndo_set_mac_address = mwifiex_set_mac_address,
+	.ndo_set_mac_address = mwifiex_ndo_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_tx_timeout = mwifiex_tx_timeout,
 	.ndo_get_stats = mwifiex_get_stats,
@@ -1296,7 +1309,6 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	priv->gen_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->num_tx_timeout = 0;
 	ether_addr_copy(priv->curr_addr, priv->adapter->perm_addr);
-	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
 	    GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f8cf307..84be38e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -165,6 +165,8 @@ enum {
 /* Address alignment */
 #define MWIFIEX_ALIGN_ADDR(p, a) (((long)(p) + (a) - 1) & ~((a) - 1))
 
+#define MWIFIEX_MAC_LOCAL_ADMIN_BIT		41
+
 /**
  *enum mwifiex_debug_level  -  marvell wifi debug level
  */
@@ -1672,6 +1674,8 @@ void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
 void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 				      struct sk_buff *event_skb);
 void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter);
+int mwifiex_set_mac_address(struct mwifiex_private *priv,
+			    struct net_device *dev);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
-- 
1.9.1
