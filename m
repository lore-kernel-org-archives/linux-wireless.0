Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:45728 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbYFHVhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:46 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1023035ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:45 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/10] rt2x00: Clear IEEE80211_TX_CTL_USE_RTS_CTS flag for RTS frame
Date: Sun, 8 Jun 2008 23:46:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082345.25904.IvDoorn@gmail.com> <200806082345.49841.IvDoorn@gmail.com>
In-Reply-To: <200806082345.49841.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082346.06848.IvDoorn@gmail.com> (sfid-20080608_233749_946933_B908A834)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 2106feb725364f592646a5b1790fcb9e25238601 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 7 Jun 2008 12:29:05 +0200
Subject: [PATCH] rt2x00: Clear IEEE80211_TX_CTL_USE_RTS_CTS flag for RTS frame

For RTS/CTS-to-self frames the IEEE80211_TX_CTL_USE_RTS_CTS flag
should be cleared for the tx_info flags.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 59f273b..c90992f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -64,6 +64,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	memcpy(skb->cb, frag_skb->cb, sizeof(skb->cb));
 	rts_info = IEEE80211_SKB_CB(skb);
 	rts_info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	rts_info->flags &= ~IEEE80211_TX_CTL_USE_RTS_CTS;
 	rts_info->flags &= ~IEEE80211_TX_CTL_USE_CTS_PROTECT;
 	rts_info->flags &= ~IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-- 
1.5.5.3

