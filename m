Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:34711 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3EHIbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 04:31:41 -0400
From: <Wei.Yang@windriver.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <wei.wyang@windriver.com>
Subject: [PATCH] mac80211: refine ieee80211_rx() context requirement
Date: Wed, 8 May 2013 16:31:31 +0800
Message-ID: <1368001892-18068-1-git-send-email-Wei.Yang@windriver.com> (sfid-20130508_103150_402420_A683AFAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yang <Wei.Yang@windriver.com>

In case of RT kernel, the return value of softirq_count() always
equal to 0, we need to use in_serving_softirq to decide whether
the current context is in softirq context.

Signed-off-by: Wei Yang <Wei.Yang@windriver.com>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c6844ad..80fac46 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3226,7 +3226,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	WARN_ON_ONCE(softirq_count() == 0);
+	WARN_ON_ONCE(!in_serving_softirq());
 
 	if (WARN_ON(status->band >= IEEE80211_NUM_BANDS))
 		goto drop;
-- 
1.7.9.5

