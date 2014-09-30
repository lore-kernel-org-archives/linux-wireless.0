Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34664 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaI3Sn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 14:43:28 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless:  support configuring vdev mac addr on create.
Date: Tue, 30 Sep 2014 11:43:25 -0700
Message-Id: <1412102605-3638-1-git-send-email-greearb@candelatech.com> (sfid-20140930_204332_117701_B2D3ABE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This is useful when creating virtual-stations, and probably
APs and other devices as well.  Keeps udev from mucking with
things it shouldn't, since the default MAC is never seen
by udev when specified on the cmd-line during creation.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/cfg80211.h       | 6 +++---
 include/uapi/linux/nl80211.h | 3 +++
 net/mac80211/iface.c         | 5 ++++-
 net/mac80211/main.c          | 1 +
 net/wireless/nl80211.c       | 2 +-
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1641e6..de9a67f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -319,9 +319,9 @@ struct ieee80211_supported_band {
 /**
  * struct vif_params - describes virtual interface parameters
  * @use_4addr: use 4-address frames
- * @macaddr: address to use for this virtual interface. This will only
- * 	be used for non-netdevice interfaces. If this parameter is set
- * 	to zero address the driver may determine the address as needed.
+ * @macaddr: address to use for this virtual interface.
+ * 	If this parameter is set to zero address the driver may
+ *	determine the address as needed.
  */
 struct vif_params {
        int use_4addr;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4b28dc0..fd14703 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4042,6 +4042,8 @@ enum nl80211_ap_sme_features {
  *	multiplexing powersave, ie. can turn off all but one chain
  *	and then wake the rest up as required after, for example,
  *	rts/cts handshake.
+ * @NL80211_FEATURE_MAC_ON_CREATE: Device supports configuring
+ *	the vdev's MAC address upon creation.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4070,6 +4072,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 23,
 	NL80211_FEATURE_STATIC_SMPS			= 1 << 24,
 	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
+	NL80211_FEATURE_MAC_ON_CREATE			= 1 << 26,
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 878bfca..ba5d0d5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1715,7 +1715,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		}
 
 		ieee80211_assign_perm_addr(local, ndev->perm_addr, type);
-		memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
+		if (params && !is_zero_ether_addr(params->macaddr))
+			memcpy(ndev->dev_addr, params->macaddr, ETH_ALEN);
+		else
+			memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
 		SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 
 		/* don't use IEEE80211_DEV_TO_SUB_IF -- it checks too much */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8106770..eb7bdd1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -550,6 +550,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_VIF_TXPOWER |
+			   NL80211_FEATURE_MAC_ON_CREATE |
 			   NL80211_FEATURE_USERSPACE_MPM;
 
 	if (!ops->hw_scan)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8a010bd..cf79707 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2605,7 +2605,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	    !(rdev->wiphy.interface_modes & (1 << type)))
 		return -EOPNOTSUPP;
 
-	if (type == NL80211_IFTYPE_P2P_DEVICE && info->attrs[NL80211_ATTR_MAC]) {
+	if (info->attrs[NL80211_ATTR_MAC]) {
 		nla_memcpy(params.macaddr, info->attrs[NL80211_ATTR_MAC],
 			   ETH_ALEN);
 		if (!is_valid_ether_addr(params.macaddr))
-- 
1.7.11.7

