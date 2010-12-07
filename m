Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:36139 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0LGFN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 00:13:58 -0500
Received: by gxk19 with SMTP id 19so7264653gxk.11
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 21:13:58 -0800 (PST)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Check for NULL sta in ath_tx_start
Date: Mon,  6 Dec 2010 21:13:49 -0800
Message-Id: <1291698829-22765-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It can be NULL according to docs, and logging showed it
to be NULL in practice.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 8b0b076... 5ddca08... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/xmit.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8b0b076..5ddca08 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1764,7 +1764,10 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	int frmlen = skb->len + FCS_LEN;
 	int q;
 
-	txctl->an = (struct ath_node *)sta->drv_priv;
+	/* NOTE:  sta can be NULL according to net/mac80211.h */
+	if (sta)
+		txctl->an = (struct ath_node *)sta->drv_priv;
+
 	if (info->control.hw_key)
 		frmlen += info->control.hw_key->icv_len;
 
-- 
1.7.2.3

