Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:26090 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068Ab2LBRLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 12:11:19 -0500
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv2 1/2] cfg80211: allow user to specify short_preamble on ibss join
Date: Sun, 2 Dec 2012 18:10:17 +0100
Message-ID: <1354468218-30605-1-git-send-email-antonio@open-mesh.com> (sfid-20121202_181125_491171_150DCECE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Short preamble can be used to improve wireless performance
on devices different from lagacy-802.11. This patch
enabled the user to specify such capability on IBSS join.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

* fixed email address

 include/net/cfg80211.h | 1 +
 net/wireless/nl80211.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8e6a6b7..c93955c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1416,6 +1416,7 @@ struct cfg80211_ibss_params {
 	bool privacy;
 	bool control_port;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	bool use_short_preamble;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f45706a..e82c51a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5459,6 +5459,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	struct wiphy *wiphy;
 	struct cfg80211_cached_keys *connkeys = NULL;
 	int err;
+	bool sp;
 
 	memset(&ibss, 0, sizeof(ibss));
 
@@ -5554,6 +5555,9 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	ibss.control_port =
 		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT]);
 
+	sp = nla_get_flags(info->attr[NL80211_ATTR_BSS_SHORT_PREAMBLE]);
+	ibss.use_short_preamble = sp;
+
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 	if (err)
 		kfree(connkeys);
-- 
1.8.0

