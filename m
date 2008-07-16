Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:2241 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbYGPBoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:21 -0400
Received: by rv-out-0506.google.com with SMTP id k40so6244946rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:20 -0700 (PDT)
Subject: [PATCH 06/12] mac80211: wep.c replace magic numbers in IV/ICV
	removal
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:10 -0700
Message-Id: <1216172650.6610.54.camel@brick> (sfid-20080716_034424_240592_9A111163)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wep.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 872d2fc..e50b421 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -228,11 +228,10 @@ int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
 		return -1;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
-	if (skb->len < 8 + hdrlen)
+	if (skb->len < hdrlen + WEP_IV_LEN + WEP_ICV_LEN)
 		return -1;
 
-	len = skb->len - hdrlen - 8;
+	len = skb->len - hdrlen - WEP_IV_LEN - WEP_ICV_LEN;
 
 	keyidx = skb->data[hdrlen + 3] >> 6;
 
@@ -303,7 +302,7 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 	} else if (!(rx->status->flag & RX_FLAG_IV_STRIPPED)) {
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
-		skb_trim(rx->skb, rx->skb->len - 4);
+		skb_trim(rx->skb, rx->skb->len - WEP_ICV_LEN);
 	}
 
 	return RX_CONTINUE;
-- 
1.5.6.3.499.geae9


