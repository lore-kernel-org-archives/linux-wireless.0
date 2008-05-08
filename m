Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:38036 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYEHMzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 08:55:23 -0400
Received: by mu-out-0910.google.com with SMTP id w8so593271mue.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 05:55:22 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: 015-mac80211-tx-info-skb-cb.patch
Date: Thu, 8 May 2008 15:03:40 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805081503.41025.IvDoorn@gmail.com> (sfid-20080508_145423_329164_3024D07A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

The following patch is intended to be ontop or integrated into your patch:
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/015-mac80211-tx-info-skb-cb.patch
This fixes a compilation error when mac80211 debug output is disabled.

Ivo
---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3b3592f..50edc9d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -223,10 +223,9 @@ static ieee80211_tx_result
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	struct sk_buff *skb = tx->skb;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-	struct ieee80211_tx_info *info = (void *)skb->cb;
+	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
 	u32 sta_flags;
 
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
