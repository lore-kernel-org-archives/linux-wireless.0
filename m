Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39044 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753340AbeDDDDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 23:03:03 -0400
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 1/3] mwifiex: make firmware mac address consistent with host configuration
Date: Wed, 4 Apr 2018 11:02:39 +0800
Message-ID: <1522810961-27521-1-git-send-email-huxm@marvell.com> (sfid-20180404_050307_701126_64C289D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For user configurated mac address, directly set to firmware with no change.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  4 +--
 drivers/net/wireless/marvell/mwifiex/main.c     | 38 ++++++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/main.h     |  3 +-
 3 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 3fc6f29..8b2aab1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -915,7 +915,7 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 	adapter->rx_locked = false;
 	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 
-	mwifiex_set_mac_address(priv, dev);
+	mwifiex_set_mac_address(priv, dev, false, NULL);
 
 	return 0;
 }
@@ -2959,7 +2959,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	priv->netdev = dev;
 
 	if (!adapter->mfg_mode) {
-		mwifiex_set_mac_address(priv, dev);
+		mwifiex_set_mac_address(priv, dev, false, NULL);
 
 		ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 				       HostCmd_ACT_GEN_SET, 0, NULL, true);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 20737f5..cd3fc4e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -957,28 +957,35 @@ struct sk_buff *
 }
 
 int mwifiex_set_mac_address(struct mwifiex_private *priv,
-			    struct net_device *dev)
+			    struct net_device *dev, bool external,
+			    u8 *new_mac)
 {
 	int ret;
 	u64 mac_addr, old_mac_addr;
 
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_ANY)
-		return -ENOTSUPP;
+	old_mac_addr = ether_addr_to_u64(priv->curr_addr);
 
-	mac_addr = ether_addr_to_u64(priv->curr_addr);
-	old_mac_addr = mac_addr;
+	if (external) {
+		mac_addr = ether_addr_to_u64(new_mac);
+	} else {
+		/* Internal mac address change */
+		if (priv->bss_type == MWIFIEX_BSS_TYPE_ANY)
+			return -ENOTSUPP;
 
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P)
-		mac_addr |= BIT_ULL(MWIFIEX_MAC_LOCAL_ADMIN_BIT);
+		mac_addr = old_mac_addr;
 
-	if (mwifiex_get_intf_num(priv->adapter, priv->bss_type) > 1) {
-		/* Set mac address based on bss_type/bss_num */
-		mac_addr ^= BIT_ULL(priv->bss_type + 8);
-		mac_addr += priv->bss_num;
-	}
+		if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P)
+			mac_addr |= BIT_ULL(MWIFIEX_MAC_LOCAL_ADMIN_BIT);
 
-	if (mac_addr == old_mac_addr)
-		goto done;
+		if (mwifiex_get_intf_num(priv->adapter, priv->bss_type) > 1) {
+			/* Set mac address based on bss_type/bss_num */
+			mac_addr ^= BIT_ULL(priv->bss_type + 8);
+			mac_addr += priv->bss_num;
+		}
+
+		if (mac_addr == old_mac_addr)
+			goto done;
+	}
 
 	u64_to_ether_addr(mac_addr, priv->curr_addr);
 
@@ -1006,8 +1013,7 @@ int mwifiex_set_mac_address(struct mwifiex_private *priv,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sockaddr *hw_addr = addr;
 
-	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
-	return mwifiex_set_mac_address(priv, dev);
+	return mwifiex_set_mac_address(priv, dev, true, hw_addr->sa_data);
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f607d0b..598e58b 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1692,7 +1692,8 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 				      struct sk_buff *event_skb);
 void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter);
 int mwifiex_set_mac_address(struct mwifiex_private *priv,
-			    struct net_device *dev);
+			    struct net_device *dev,
+			    bool external, u8 *new_mac);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
-- 
1.9.1
