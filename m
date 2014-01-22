Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbaAVKfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/7] nl80211: make netlink attribute policies const
Date: Wed, 22 Jan 2014 11:34:54 +0100
Message-Id: <1390386898-14316-4-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113539_105548_78CE7CD2)
In-Reply-To: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
References: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason for netlink attribute policies to be
__read_mostly, they can just be const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0c2ef08..fdd4cae 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3950,8 +3950,8 @@ static struct net_device *get_vlan(struct genl_info *info,
 	return ERR_PTR(ret);
 }
 
-static struct nla_policy
-nl80211_sta_wme_policy[NL80211_STA_WME_MAX + 1] __read_mostly = {
+static const struct nla_policy
+nl80211_sta_wme_policy[NL80211_STA_WME_MAX + 1] = {
 	[NL80211_STA_WME_UAPSD_QUEUES] = { .type = NLA_U8 },
 	[NL80211_STA_WME_MAX_SP] = { .type = NLA_U8 },
 };
@@ -7843,8 +7843,8 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static struct nla_policy
-nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] __read_mostly = {
+static const struct nla_policy
+nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] = {
 	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
-- 
1.8.5.1

