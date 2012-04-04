Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46380 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2DDWbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 18:31:46 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH v2 1/2] cfg80211: add channel switch notify event
Date: Wed, 4 Apr 2012 15:31:35 -0700
Message-ID: <1333578696-22636-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120405_003150_166112_4A787153)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware may decide to switch channels while already beaconing, e.g.
in response to a cfg80211 connect request on a different vif. Add this
event to notify userspace when an AP or GO interface has successfully
migrated to a new channel, so it can update its configuration
accordingly.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
v2: update wdev->channel (Johannes)
    enforce AP or GO interface type

 include/linux/nl80211.h |    7 +++++++
 include/net/cfg80211.h  |   10 ++++++++++
 net/wireless/mlme.c     |   27 +++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   32 ++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 ++++
 5 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e474f6e..49f2bbe 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -548,6 +548,11 @@
  * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
  *      No Acknowledgement Policy should be applied.
  *
+ * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
+ *	independently of the userspace SME, send this event indicating
+ *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
+ *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -689,6 +694,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_NOACK_MAP,
 
+	NL80211_CMD_CH_SWITCH_NOTIFY,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 69b7ad3..eadc897 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3340,6 +3340,16 @@ int cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 				 enum nl80211_channel_type channel_type);
 
 /*
+ * cfg80211_ch_switch_notify - notify userspace about netdev channel switch
+ * @dev: the device which switched channels
+ * @freq: new channel frequency (in MHz)
+ * @type: channel type
+ * @gfp: allocation flags
+ */
+void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
+			       enum nl80211_channel_type type, gfp_t gfp);
+
+/*
  * cfg80211_calculate_bitrate - calculate actual bitrate (in 100Kbps units)
  * @rate: given rate_info to calculate bitrate from
  *
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index f5a7ac3..4d45296 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -928,6 +928,33 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
 
+void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
+			       enum nl80211_channel_type type, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct ieee80211_channel *chan;
+
+	wdev_lock(wdev);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
+		goto out;
+
+	chan = rdev_freq_to_chan(rdev, freq, type);
+	if (WARN_ON(!chan))
+		goto out;
+
+	wdev->channel = chan;
+
+	nl80211_ch_switch_notify(rdev, dev, freq, type, gfp);
+out:
+	wdev_unlock(wdev);
+	return;
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_notify);
+
 bool cfg80211_rx_spurious_frame(struct net_device *dev,
 				const u8 *addr, gfp_t gfp)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4c1eb94..d5d489f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7890,6 +7890,38 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
+			      struct net_device *netdev, int freq,
+			      enum nl80211_channel_type type, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_CH_SWITCH_NOTIFY);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, type);
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
 void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 4ffe50d..01a1122 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -118,6 +118,10 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 				    struct net_device *netdev, int index,
 				    const u8 *bssid, bool preauth, gfp_t gfp);
 
+void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
+			      struct net_device *dev, int freq,
+			      enum nl80211_channel_type type, gfp_t gfp);
+
 bool nl80211_unexpected_frame(struct net_device *dev,
 			      const u8 *addr, gfp_t gfp);
 bool nl80211_unexpected_4addr_frame(struct net_device *dev,
-- 
1.7.4.1

