Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56683 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaJVTXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:17 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 8/9] cfg80211: support configuring vif mac addr on create
Date: Wed, 22 Oct 2014 12:23:05 -0700
Message-Id: <1414005786-27572-8-git-send-email-greearb@candelatech.com> (sfid-20141022_212330_129020_0DAAC3FB)
In-Reply-To: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
References: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This is useful when creating virtual interfaces.
Keeps udev from mucking with things it shouldn't, since
the default MAC is never seen by udev when specified on
the cmd-line during creation.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/cfg80211.h       | 9 ++++++---
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 39d7996..f67948e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -319,9 +319,12 @@ struct ieee80211_supported_band {
 /**
  * struct vif_params - describes virtual interface parameters
  * @use_4addr: use 4-address frames
- * @macaddr: address to use for this virtual interface. This will only
- * 	be used for non-netdevice interfaces. If this parameter is set
- * 	to zero address the driver may determine the address as needed.
+ * @macaddr: address to use for this virtual interface.
+ *	If this parameter is set to zero address the driver may
+ *	determine the address as needed.
+ *	This feature is only fully supported by drivers that enable the
+ *	%NL80211_FEATURE_MAC_ON_CREATE flag.  Others may support creating
+ **	only p2p devices with specified MAC.
  */
 struct vif_params {
        int use_4addr;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index be1d5de..f7daae5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4056,6 +4056,9 @@ enum nl80211_ap_sme_features {
  *	TSPEC sessions (TID aka TSID 0-7) with the %NL80211_CMD_ADD_TX_TS
  *	command. Standard IEEE 802.11 TSPEC setup is not yet supported, it
  *	needs to be able to handle Block-Ack agreements and other things.
+ * @NL80211_FEATURE_MAC_ON_CREATE: Device supports configuring
+ *	the vif's MAC address upon creation.
+ *	See 'macaddr' field in the vif_params (cfg80211.h).
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4085,6 +4088,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_STATIC_SMPS			= 1 << 24,
 	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
 	NL80211_FEATURE_SUPPORTS_WMM_ADMISSION		= 1 << 26,
+	NL80211_FEATURE_MAC_ON_CREATE			= 1 << 27,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d98d4ea..5ecb46c 100644
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

