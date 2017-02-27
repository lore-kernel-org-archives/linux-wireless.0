Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32813 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdB0LsL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 06:48:11 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 2/3] cfg80211: Disallow moving out of operating DFS channel in non-ETSI
Date: Mon, 27 Feb 2017 17:04:34 +0530
Message-ID: <1488195275-29371-3-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20170227_124815_532752_1775AE7E)
In-Reply-To: <1488195275-29371-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1488195275-29371-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For non-ETSI regulatory domain, CAC result on DFS channel
may not be valid once moving out of that channel (as done
during remain-on-channel, scannning and off-channel tx).
Running CAC on an operating DFS channel after every off-channel
operation will only add complexity and disturb the current
link. Better do not allow any off-channel switch from a DFS
operating channel in non-ETSI domain.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 net/wireless/nl80211.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d516527..b15903b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6556,6 +6556,19 @@ static int nl80211_parse_random_mac(struct nlattr **attrs,
 	return 0;
 }
 
+static bool cfg80211_off_channel_oper_allowed(struct wireless_dev *wdev)
+{
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (!cfg80211_beaconing_iface_active(wdev))
+		return true;
+
+	if (!(wdev->chandef.chan->flags & IEEE80211_CHAN_RADAR))
+		return true;
+
+	return regulatory_pre_cac_allowed(wdev->wiphy);
+}
+
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -6681,6 +6694,25 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	request->n_channels = i;
 
+	wdev_lock(wdev);
+	if (!cfg80211_off_channel_oper_allowed(wdev)) {
+		struct ieee80211_channel *chan;
+
+		if (request->n_channels != 1) {
+			wdev_unlock(wdev);
+			err = -EBUSY;
+			goto out_free;
+		}
+
+		chan = request->channels[0];
+		if (chan->center_freq != wdev->chandef.chan->center_freq) {
+			wdev_unlock(wdev);
+			err = -EBUSY;
+			goto out_free;
+		}
+	}
+	wdev_unlock(wdev);
+
 	i = 0;
 	if (n_ssids) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
@@ -9103,6 +9135,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
 	struct cfg80211_chan_def chandef;
+	const struct cfg80211_chan_def *compat_chandef;
 	struct sk_buff *msg;
 	void *hdr;
 	u64 cookie;
@@ -9131,6 +9164,18 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	wdev_lock(wdev);
+	if (!cfg80211_off_channel_oper_allowed(wdev) &&
+	    !cfg80211_chandef_identical(&wdev->chandef, &chandef)) {
+		compat_chandef = cfg80211_chandef_compatible(&wdev->chandef,
+							     &chandef);
+		if (compat_chandef != &chandef) {
+			wdev_unlock(wdev);
+			return -EBUSY;
+		}
+	}
+	wdev_unlock(wdev);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
@@ -9306,6 +9351,13 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	if (!chandef.chan && params.offchan)
 		return -EINVAL;
 
+	wdev_lock(wdev);
+	if (params.offchan && !cfg80211_off_channel_oper_allowed(wdev)) {
+		wdev_unlock(wdev);
+		return -EBUSY;
+	}
+	wdev_unlock(wdev);
+
 	params.buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
 	params.len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
 
-- 
1.9.1
