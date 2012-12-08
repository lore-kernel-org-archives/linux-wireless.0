Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61511 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab2LHOZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 09:25:03 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so560871bkw.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2012 06:25:01 -0800 (PST)
Subject: [PATCH] carl9170: fix copy and paste mishap in carl9170_handle_mpdu
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 8 Dec 2012 15:24:56 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201212081524.56550.chunkeey@googlemail.com> (sfid-20121208_152512_749101_D39524E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression which was introduced by:
"carl9170: split up carl9170_handle_mpdu"

Previously, the ieee80211_rx_status was kept on the
stack of carl9170_handle_mpdu. Now it's passed into
the function as a pointer parameter. Hence, the old
memcpy call needs to be fixed.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 876a773..4684dd9 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -684,7 +684,7 @@ static int carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len,
 	if (!skb)
 		return -ENOMEM;
 
-	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+	memcpy(IEEE80211_SKB_RXCB(skb), status, sizeof(*status));
 	ieee80211_rx(ar->hw, skb);
 	return 0;
 }
-- 
1.7.10.4

