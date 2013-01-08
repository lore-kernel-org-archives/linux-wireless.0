Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44625 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3AHNEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:53 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 1/6] nl80211: check if channel can be used in join_ibss
Date: Tue,  8 Jan 2013 14:04:06 +0100
Message-Id: <1357650251-17425-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140509_128641_593D2DBE)
In-Reply-To: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IBSS should also consider interface combinations.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/wireless/nl80211.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9bd8340..62e98f5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5463,6 +5463,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ibss_params ibss;
 	struct wiphy *wiphy;
 	struct cfg80211_cached_keys *connkeys = NULL;
@@ -5524,6 +5525,15 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
 
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_use_chan(rdev, wdev, ibss.chandef.chan,
+				    ibss.channel_fixed ? CHAN_MODE_SHARED :
+							 CHAN_MODE_EXCLUSIVE);
+	mutex_unlock(&rdev->devlist_mtx);
+
+	if (err)
+		return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
 		u8 *rates =
 			nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
-- 
1.7.10.4

