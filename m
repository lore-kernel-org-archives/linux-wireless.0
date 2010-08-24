Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63568 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab0HXUyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 16:54:10 -0400
Received: by bwz11 with SMTP id 11so72486bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Aug 2010 13:54:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: fix tx feedback status flag check
Date: Tue, 24 Aug 2010 22:54:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael =?iso-8859-1?q?B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008242254.05559.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael reported that p54* never really entered power
save mode, even tough it was enabled.

It turned out that upon a power save mode change the
firmware will set a special flag onto the last outgoing
frame tx status (which in this case is almost always the
designated PSM nullfunc frame). This flag confused the
driver; It erroneously reported transmission failures
to the stack, which then generated the next nullfunc.
and so on...

Cc: <stable@kernel.org>
Reported-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 34447d1..1dc0dbf 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -446,7 +446,7 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-	     (!payload->status))
+	     !(payload->status & P54_TX_FAILED))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 	if (payload->status & P54_TX_PSM_CANCELLED)
 		info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
