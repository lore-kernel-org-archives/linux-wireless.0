Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43225 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0KTPTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 10:19:13 -0500
Received: by fxm13 with SMTP id 13so1513242fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 07:19:12 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: fix init-self regression
Date: Sat, 20 Nov 2010 16:53:26 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011201653.26634.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit: "carl9170: tx path review" introduced a regression.

gcc (with -Winit-self):
tx.c:1264: warning: ‘super’ is used uninitialized in this function

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
for wireless-next/wireless-testing.git
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 688eede..aee5c9d 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1261,7 +1261,7 @@ static void carl9170_tx(struct ar9170 *ar)
 static bool carl9170_tx_ampdu_queue(struct ar9170 *ar,
 	struct ieee80211_sta *sta, struct sk_buff *skb)
 {
-	struct _carl9170_tx_superframe *super = (void *) super;
+	struct _carl9170_tx_superframe *super = (void *) skb->data;
 	struct carl9170_sta_info *sta_info;
 	struct carl9170_sta_tid *agg;
 	struct sk_buff *iter;
