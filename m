Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13244 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbaKMNt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 08:49:59 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v4 1/2] nl80211: Replace interface socket owner attribute with more generic one
Date: Thu, 13 Nov 2014 15:49:51 +0200
Message-Id: <1415886592-18253-2-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141113_145004_277851_96074746)
In-Reply-To: <1415886592-18253-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1415886592-18253-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace NL80211_ATTR_IFACE_SOCKET_OWNER attribute with more generic
NL80211_ATTR_SOCKET_OWNER that can be used with other commands
that interface creation.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 include/uapi/linux/nl80211.h | 7 ++++---
 net/wireless/nl80211.c       | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 442369f..185f9c7 100644
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
@@ -2030,6 +2030,7 @@ enum nl80211_attrs {
 /* source-level API compatibility */
 #define NL80211_ATTR_SCAN_GENERATION NL80211_ATTR_GENERATION
 #define	NL80211_ATTR_MESH_PARAMS NL80211_ATTR_MESH_CONFIG
+#define NL80211_ATTR_IFACE_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
 
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
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

