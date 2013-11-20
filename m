Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56870 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab3KTSkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 13:40:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.13] cfg80211: ignore supported rates for nonexistant bands on scan
Date: Wed, 20 Nov 2013 19:40:41 +0100
Message-Id: <1384972841-34929-1-git-send-email-nbd@openwrt.org> (sfid-20131120_194054_550906_33972D59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes wpa_supplicant p2p_find on 5GHz-only devices

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a7f4e79..b94ab6f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5330,6 +5330,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 				err = -EINVAL;
 				goto out_free;
 			}
+
+			if (!wiphy->bands[band])
+				continue;
+
 			err = ieee80211_get_ratemask(wiphy->bands[band],
 						     nla_data(attr),
 						     nla_len(attr),
-- 
1.8.3.4 (Apple Git-47)

