Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36192 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbcE3CwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 22:52:18 -0400
Date: Sun, 29 May 2016 19:52:11 -0700
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ruchandani.tina@gmail.com,
	netdev@vger.kernel.org, Julian.Calaby@gmail.com
Subject: [PATCH v2 03/10] nl80211: Prefer ether_addr_copy
Message-ID: <49c03996365360077fe7317d108072c30354b555.1464576022.git.kirtika.ruchandani@gmail.com> (sfid-20160530_045222_062337_150E0865)
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch,pl to prefer ether_addr_copy
over memcpy.

Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
---
 net/wireless/nl80211.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cd422bd..34b8fbe 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3194,7 +3194,7 @@ static struct cfg80211_acl_data *parse_acl_data(struct wiphy *wiphy,
 		return ERR_PTR(-ENOMEM);

 	nla_for_each_nested(attr, info->attrs[NL80211_ATTR_MAC_ADDRS], tmp) {
-		memcpy(acl->mac_addrs[i].addr, nla_data(attr), ETH_ALEN);
+		ether_addr_copy(acl->mac_addrs[i].addr, nla_data(attr));
 		i++;
 	}

@@ -5892,8 +5892,8 @@ static int nl80211_parse_random_mac(struct nlattr **attrs,
 	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_MAC_MASK])
 		return -EINVAL;

-	memcpy(mac_addr, nla_data(attrs[NL80211_ATTR_MAC]), ETH_ALEN);
-	memcpy(mac_addr_mask, nla_data(attrs[NL80211_ATTR_MAC_MASK]), ETH_ALEN);
+	ether_addr_copy(mac_addr, nla_data(attrs[NL80211_ATTR_MAC]));
+	ether_addr_copy(mac_addr_mask, nla_data(attrs[NL80211_ATTR_MAC_MASK]));

 	/* don't allow or configure an mcast address */
 	if (!is_multicast_ether_addr(mac_addr_mask) ||
@@ -9405,8 +9405,7 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 		return -ENOMEM;
 	cfg->src = nla_get_in_addr(tb[NL80211_WOWLAN_TCP_SRC_IPV4]);
 	cfg->dst = nla_get_in_addr(tb[NL80211_WOWLAN_TCP_DST_IPV4]);
-	memcpy(cfg->dst_mac, nla_data(tb[NL80211_WOWLAN_TCP_DST_MAC]),
-	       ETH_ALEN);
+	ether_addr_copy(cfg->dst_mac, nla_data(tb[NL80211_WOWLAN_TCP_DST_MAC]));
 	if (tb[NL80211_WOWLAN_TCP_SRC_PORT])
 		port = nla_get_u16(tb[NL80211_WOWLAN_TCP_SRC_PORT]);
 	else
--
2.8.0.rc3.226.g39d4020

