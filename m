Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47173 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab1C3DHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 23:07:06 -0400
Received: by ywj3 with SMTP id 3so354559ywj.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 20:07:05 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com
Subject: [PATCH v5 08/10] nl80211: New notification to discover mesh peer candidates.
Date: Tue, 29 Mar 2011 19:06:05 -0700
Message-Id: <1301450767-27045-9-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Notify userspace when a beacon/presp is received from a suitable mesh
peer candidate for whom no sta information exists.  Userspace can then
decide to create a sta info for the candidate.  If userspace is not
ready to authenticate the peer right away, it can create the sta info
with the authenticated flag unset and set it later.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h |   12 ++++++++++++
 include/net/cfg80211.h  |   29 +++++++++++++++++++++++++++++
 net/wireless/core.h     |    5 +++++
 net/wireless/mesh.c     |   14 ++++++++++++++
 net/wireless/nl80211.c  |   38 ++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 ++++
 6 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ca4b546..2c0bb8d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -410,6 +410,16 @@
  *	notification. This event is used to indicate that an unprotected
  *	disassociation frame was dropped when MFP is in use.
  *
+ * @NL80211_CMD_NEW_PEER_CANDIDATE: Notification on the reception of a
+ *      beacon or probe response from a compatible mesh peer.  This is only
+ *      sent while no station information (sta_info) exists for the new peer
+ *      candidate and when @NL80211_MESH_SETUP_USERSPACE_AUTH is set.  On
+ *      reception of this notification, userspace may decide to create a new
+ *      station (@NL80211_CMD_NEW_STATION).  To stop this notification from
+ *      reoccurring, the userspace authentication daemon may want to create the
+ *      new station with the AUTHENTICATED flag unset and maybe change it later
+ *      depending on the authentication result.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -522,6 +532,8 @@ enum nl80211_commands {
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
+	NL80211_CMD_NEW_PEER_CANDIDATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2334985..e4453c2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2451,6 +2451,35 @@ void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp);
 
 /**
+ * cfg80211_notify_new_candidate - notify cfg80211 of a new mesh peer candidate
+ *
+ * @dev: network device
+ * @macaddr: the MAC address of the new candidate
+ * @ie: information elements advertised by the peer candidate
+ * @ie_len: lenght of the information elements buffer
+ * @gfp: allocation flags
+ *
+ * This function notifies cfg80211 that the mesh peer candidate has been
+ * detected, most likely via a beacon or, less likely, via a probe response.
+ * cfg80211 then sends a notification to userspace.
+ */
+void cfg80211_notify_new_peer_candidate(struct net_device *dev,
+		const u8 *macaddr, const u8 *ie, u8 ie_len, gfp_t gfp);
+
+/**
+ * __cfg80211_notify_new_candidate - see cfg80211_notify_new_candidate
+ *
+ * @dev: network device
+ * @macaddr: the MAC address of the new candidate
+ * @ie: information elements advertised by the peer candidate
+ * @ie_len: lenght of the information elements buffer
+ *
+ * Like cfg80211_notify_new_candidate(), but doesn't take the wdev lock.
+ */
+void __cfg80211_notify_new_peer_candidate(struct net_device *dev,
+		const u8 *macaddr, const u8 *ie, u8 ie_len);
+
+/**
  * DOC: RFkill integration
  *
  * RFkill integration in cfg80211 is almost invisible to drivers,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 26a0a08..994058f 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -243,6 +243,11 @@ struct cfg80211_event {
 		struct {
 			u8 bssid[ETH_ALEN];
 		} ij;
+		struct {
+			u8 macaddr[ETH_ALEN];
+			const u8 *ie;
+			size_t ie_len;
+		} nc;
 	};
 };
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index c51e3c5..ab036b5 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -1,5 +1,6 @@
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include "nl80211.h"
 #include "core.h"
 
 /* Default values, timeouts in ms */
@@ -106,6 +107,19 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
+void cfg80211_notify_new_peer_candidate(struct net_device *dev,
+		const u8 *macaddr, const u8* ie, u8 ie_len, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_MESH_POINT))
+		return;
+
+	nl80211_send_new_peer_candidate(wiphy_to_dev(wdev->wiphy), dev,
+			macaddr, ie, ie_len, gfp);
+}
+EXPORT_SYMBOL(cfg80211_notify_new_peer_candidate);
+
 static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5854366..7ee6197 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5796,6 +5796,44 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
+		struct net_device *netdev,
+		const u8 *macaddr, const u8* ie, u8 ie_len,
+		gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NEW_PEER_CANDIDATE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, macaddr);
+	if (ie_len && ie)
+		NLA_PUT(msg, NL80211_ATTR_IE, ie_len , ie);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *addr,
 				 enum nl80211_key_type key_type, int key_id,
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e3f7fa8..b7710b5 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -50,6 +50,10 @@ void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
 			       const u8 *ie, size_t ie_len, bool from_ap);
 
+void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev,
+				     const u8 *macaddr, const u8* ie, u8 ie_len,
+				     gfp_t gfp);
 void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,
-- 
1.7.4.1

