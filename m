Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34332 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbcFVMZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 08:25:35 -0400
Received: by mail-pf0-f195.google.com with SMTP id 66so4002589pfy.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 05:25:03 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: Use macro instead of number
Date: Wed, 22 Jun 2016 20:23:03 +0900
Message-Id: <1466594583-23663-1-git-send-email-masashi.honma@gmail.com> (sfid-20160622_142622_775844_A920D1DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use IEEE80211_MIN_ACTION_SIZE macro for robust management frame check.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7c0771a..8326a91 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2465,7 +2465,7 @@ static inline bool _ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
  */
 static inline bool ieee80211_is_robust_mgmt_frame(struct sk_buff *skb)
 {
-	if (skb->len < 25)
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE)
 		return false;
 	return _ieee80211_is_robust_mgmt_frame((void *)skb->data);
 }
-- 
2.5.0

