Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:18491 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754749Ab2LJKW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 05:22:58 -0500
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 1/2] cfg80211: add the new IBSS_STA event
Date: Mon, 10 Dec 2012 11:21:56 +0100
Message-ID: <1355134917-17705-1-git-send-email-antonio@open-mesh.com> (sfid-20121210_112309_351424_D3F2EFAB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In IBSS mode it could be the case that a station being added
is not ready for starting higher level routines (e.g. key
exchange when IBSS/RSN is enabled). In particular, this can
happen when we are waiting for the AUTH response message.

This IBSS_STA event is triggered after the NEW_STA one and
only when the upper layer is allowed to assume that the new
peer is ready

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

This patchset fixes an incorrect state handling in the IBSS/RSN
"cooperation" between kernel and userspace.
It would probably be more appropriate to create a much general
event signaling mechanism (e.g. trigger an event each time a
station changes its internal state), but at the moment it is
much more important to fix the issue. Re-engineering can be
done later and with a proper idea.

I'm not sending this to mac80211 because I don't think it would
make it for this kernel release.

Cheers,


 include/net/cfg80211.h       |  8 ++++++++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/mlme.c          |  9 +++++++++
 net/wireless/nl80211.c       | 33 +++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |  3 +++
 5 files changed, 55 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8e6a6b7..3266c03 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3497,6 +3497,14 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 		      struct station_info *sinfo, gfp_t gfp);
 
 /**
+ * cfg80211_ibss_sta - notify userspace that the ibss station is ready
+ * @dev: the netdev
+ * @mac_addr: the station's address
+ * @gfp: allocation flags
+ */
+void cfg80211_ibss_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp);
+
+/**
  * cfg80211_del_sta - notify userspace about deletion of a station
  *
  * @dev: the netdev
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e3e19f8..7e0911e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -736,6 +736,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MCAST_RATE,
 
+	NL80211_CMD_IBSS_STATION,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 5e8123e..f9493fc 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -612,6 +612,15 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 }
 EXPORT_SYMBOL(cfg80211_new_sta);
 
+void cfg80211_ibss_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_ibss_sta_event(rdev, dev, mac_addr, gfp);
+}
+EXPORT_SYMBOL(cfg80211_ibss_sta);
+
 void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f45706a..2d27911 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8564,6 +8564,39 @@ void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
 				nl80211_mlme_mcgrp.id, gfp);
 }
 
+void nl80211_send_ibss_sta_event(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, const u8 *mac_addr,
+				 gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_IBSS_STATION);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
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
+
 void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
 				struct net_device *dev, const u8 *mac_addr,
 				gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 2acba84..429f5d6 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -85,6 +85,9 @@ void nl80211_send_remain_on_channel_cancel(
 void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
 			    struct net_device *dev, const u8 *mac_addr,
 			    struct station_info *sinfo, gfp_t gfp);
+void nl80211_send_ibss_sta_event(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, const u8 *mac_addr,
+				 gfp_t gfp);
 void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
 				struct net_device *dev, const u8 *mac_addr,
 				gfp_t gfp);
-- 
1.8.0

