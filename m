Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34791 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbbLGVFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 16:05:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>,
	Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH 1/4] nl80211: Use specific attributes in nl80211_parse_random_mac
Date: Mon,  7 Dec 2015 22:04:50 +0100
Message-Id: <1449522293-13710-2-git-send-email-johannes@sipsolutions.net> (sfid-20151207_220510_625372_A84DF51F)
In-Reply-To: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
References: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Instead of passing the whole attributes array, pass specific attributes
for the mac address and the mask.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 72de6989dd12..243c6cbc99ab 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5753,12 +5753,13 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
-static int nl80211_parse_random_mac(struct nlattr **attrs,
+static int nl80211_parse_random_mac(struct nlattr *mac_attr,
+				    struct nlattr *mac_mask_attr,
 				    u8 *mac_addr, u8 *mac_addr_mask)
 {
 	int i;
 
-	if (!attrs[NL80211_ATTR_MAC] && !attrs[NL80211_ATTR_MAC_MASK]) {
+	if (!mac_attr && !mac_mask_attr) {
 		eth_zero_addr(mac_addr);
 		eth_zero_addr(mac_addr_mask);
 		mac_addr[0] = 0x2;
@@ -5768,11 +5769,11 @@ static int nl80211_parse_random_mac(struct nlattr **attrs,
 	}
 
 	/* need both or none */
-	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_MAC_MASK])
+	if (!mac_attr || !mac_mask_attr)
 		return -EINVAL;
 
-	memcpy(mac_addr, nla_data(attrs[NL80211_ATTR_MAC]), ETH_ALEN);
-	memcpy(mac_addr_mask, nla_data(attrs[NL80211_ATTR_MAC_MASK]), ETH_ALEN);
+	memcpy(mac_addr, nla_data(mac_attr), ETH_ALEN);
+	memcpy(mac_addr_mask, nla_data(mac_mask_attr), ETH_ALEN);
 
 	/* don't allow or configure an mcast address */
 	if (!is_multicast_ether_addr(mac_addr_mask) ||
@@ -5980,9 +5981,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 				goto out_free;
 			}
 
-			err = nl80211_parse_random_mac(info->attrs,
-						       request->mac_addr,
-						       request->mac_addr_mask);
+			err = nl80211_parse_random_mac(
+				info->attrs[NL80211_ATTR_MAC],
+				info->attrs[NL80211_ATTR_MAC_MASK],
+				request->mac_addr, request->mac_addr_mask);
 			if (err)
 				goto out_free;
 		}
@@ -6416,8 +6418,9 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				goto out_free;
 			}
 
-			err = nl80211_parse_random_mac(attrs, request->mac_addr,
-						       request->mac_addr_mask);
+			err = nl80211_parse_random_mac(attrs[NL80211_ATTR_MAC],
+				attrs[NL80211_ATTR_MAC_MASK], request->mac_addr,
+				request->mac_addr_mask);
 			if (err)
 				goto out_free;
 		}
-- 
2.6.2

