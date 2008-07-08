Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:56675 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYGHUr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 16:47:28 -0400
Received: by yx-out-2324.google.com with SMTP id 8so687174yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 13:47:27 -0700 (PDT)
Subject: [PATCH 2/6] mac80211: wep.c replace magic numbers in IV/ICV removal
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 13:47:23 -0700
Message-Id: <1215550043.476.40.camel@brick> (sfid-20080708_224732_507328_A7650FE7)
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
1.5.6.1.322.ge904b


