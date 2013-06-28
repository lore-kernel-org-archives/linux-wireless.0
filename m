Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:45848 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3F1Ikg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 04:40:36 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/2] nl80211: enable HT overrides for ibss
Date: Fri, 28 Jun 2013 10:39:58 +0200
Message-Id: <1372408799-25651-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130628_104130_339289_C8388365)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h |    5 +++++
 net/wireless/nl80211.c |   13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b0730a..836b7e2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1592,6 +1592,9 @@ struct cfg80211_disassoc_request {
  *	user space. Otherwise, port is marked authorized by default.
  * @basic_rates: bitmap of basic rates to use when creating the IBSS
  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
+ * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
+ *   will be used in ht_capa.  Un-supported values will be ignored.
+ * @ht_capa_mask:  The bits of ht_capa which are to be used.
  */
 struct cfg80211_ibss_params {
 	u8 *ssid;
@@ -1605,6 +1608,8 @@ struct cfg80211_ibss_params {
 	bool privacy;
 	bool control_port;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	struct ieee80211_ht_cap ht_capa;
+	struct ieee80211_ht_cap ht_capa_mask;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7dc3343..d74230c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6344,6 +6344,19 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
+		memcpy(&ibss.ht_capa_mask,
+		       nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]),
+		       sizeof(ibss.ht_capa_mask));
+
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
+		if (!info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
+			return -EINVAL;
+		memcpy(&ibss.ht_capa,
+		       nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]),
+		       sizeof(ibss.ht_capa));
+	}
+
 	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
 	    !nl80211_parse_mcast_rate(rdev, ibss.mcast_rate,
 			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
-- 
1.7.10.4

