Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58484 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbcBHNZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 08:25:30 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] cfg80211: fix faulty variable initialization in ieee80211_amsdu_to_8023s
Date: Mon,  8 Feb 2016 14:25:26 +0100
Message-Id: <1454937926-74516-1-git-send-email-nbd@openwrt.org> (sfid-20160208_142536_304919_10A76282)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reuse_skb is set to true if the code decides to use the last segment.
Fixes a memory leak

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6e4eb35..9880c89 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -676,7 +676,7 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 	u8 *payload;
 	int offset = 0, remaining, err;
 	struct ethhdr eth;
-	bool reuse_skb = true;
+	bool reuse_skb = false;
 	bool last = false;
 
 	if (has_80211_header) {
-- 
2.2.2

