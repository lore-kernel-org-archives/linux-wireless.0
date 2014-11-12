Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43455 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaKLLgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 06:36:41 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] nl80211: Replace interface socket owner attribute with more generic one
Date: Wed, 12 Nov 2014 13:36:36 +0200
Message-Id: <1415792197-23080-2-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141112_123645_909643_6A7A6F1B)
In-Reply-To: <1415792197-23080-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1415792197-23080-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace NL80211_ATTR_IFACE_SOCKET_OWNER attribute with more generic
NL80211_ATTR_SOCKET_OWNER that can be used with other commands
that interface creation.
---
 include/uapi/linux/nl80211.h | 8 +++++---
 net/wireless/nl80211.c       | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 442369f..c410284 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1637,9 +1637,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_PEER_CAPABILITY: flags for TDLS peer capabilities, u32.
  *	As specified in the &enum nl80211_tdls_peer_capability.
  *
- * @NL80211_ATTR_IFACE_SOCKET_OWNER: flag attribute, if set during interface
+ * @NL80211_ATTR_SOCKET_OWNER: Flag attribute, if set during interface
  *	creation then the new interface will be owned by the netlink socket
- *	that created it and will be destroyed when the socket is closed
+ *	that created it and will be destroyed when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
@@ -2004,7 +2004,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TDLS_PEER_CAPABILITY,
 
-	NL80211_ATTR_IFACE_SOCKET_OWNER,
+	NL80211_ATTR_SOCKET_OWNER,
 
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
 	NL80211_ATTR_MAX_CSA_COUNTERS,
@@ -2056,6 +2056,8 @@ enum nl80211_attrs {
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
 #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
+#define NL80211_ATTR_IFACE_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
+#define NL80211_ATTR_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0a8361..df447c0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -388,7 +388,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MAC_HINT] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
-	[NL80211_ATTR_IFACE_SOCKET_OWNER] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SOCKET_OWNER] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CSA_C_OFFSETS_TX] = { .type = NLA_BINARY },
 	[NL80211_ATTR_USE_RRM] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TSID] = { .type = NLA_U8 },
@@ -2646,7 +2646,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(wdev);
 	}
 
-	if (info->attrs[NL80211_ATTR_IFACE_SOCKET_OWNER])
+	if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
 		wdev->owner_nlportid = info->snd_portid;
 
 	switch (type) {
-- 
1.8.3.1

