Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:62359 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974Ab3BARML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 12:12:11 -0500
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] {cfg,nl}80211: tx_mgmt: use current bss channel if omitted.
Date: Fri,  1 Feb 2013 18:11:23 +0100
Message-Id: <1359738683-13499-1-git-send-email-cavallar@lri.fr> (sfid-20130201_181217_207633_5F6FA706)
In-Reply-To: <510A7D40.2030206@lri.fr>
References: <510A7D40.2030206@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow not specifying the channel when transmitting a management frame.
This allows user space code to not track the current channel.  This is
especially useful in IBSS mode, because userspace is not informed when
the channel changes because of a merge and requesting the current
channel before using it can introduce races.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
 net/wireless/mlme.c    |   14 ++++++++++++++
 net/wireless/nl80211.c |   13 ++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 461e692..8dc3f46 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -757,6 +757,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 {
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
+	enum cfg80211_chan_mode chan_mode;
 
 	if (!wdev->wiphy->mgmt_stypes)
 		return -EOPNOTSUPP;
@@ -836,10 +837,23 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			err = -EOPNOTSUPP;
 			break;
 		}
+		if (!err && chan == NULL) {
+			cfg80211_get_chan_state(wdev, &chan, &chan_mode);
+			if (!chan)
+				err = -ENOTCONN;
+		}
 		wdev_unlock(wdev);
 
 		if (err)
 			return err;
+	} else {
+		if (chan == NULL) {
+			wdev_lock(wdev);
+			cfg80211_get_chan_state(wdev, &chan, &chan_mode);
+			wdev_unlock(wdev);
+			if (!chan)
+				return -ENOTCONN;
+		}
 	}
 
 	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev)))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5978ab..f22c35e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6564,9 +6564,16 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
-	if (err)
-		return err;
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		err = nl80211_parse_chandef(rdev, info, &chandef);
+		if (err)
+			return err;
+	} else {
+		if (offchan)
+			return -EINVAL;
+		chandef.chan = NULL;
+	}
 
 	if (!dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-- 
1.7.10.4

