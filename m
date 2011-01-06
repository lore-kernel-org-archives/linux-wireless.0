Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35918 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1AFWsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 17:48:00 -0500
Received: by fxm20 with SMTP id 20so16482909fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 14:47:59 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: fix sequence no. accounting off-by-one error
Date: Thu, 6 Jan 2011 23:47:52 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101062347.53191.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P54_HDR_FLAG_DATA_OUT_SEQNR is meant to tell the
firmware that "the frame's sequence number has
already been set by the application."

Whereas IEEE80211_TX_CTL_ASSIGN_SEQ is set for
frames which lack a valid sequence number and
either the driver or firmware has to assign one.

Yup, it's the exact opposite!

Cc: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Patch looks fairly harmless, so what can possibly go wrong ;)
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 76b2318..f618b96 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -618,7 +618,7 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 	else
 		*burst_possible = false;
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
 	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
