Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47834 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0KZW31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 17:29:27 -0500
Received: by fxm15 with SMTP id 15so1036785fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 14:29:26 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH for-2.6.37] carl9170: fix carl9170_tx_prepare typo
Date: Fri, 26 Nov 2010 23:29:23 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011262329.23314.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit: "carl9170: revamp carl9170_tx_prepare"
introduced a peculiar bug that would only show
up if the the module parameter noht is set to 1.

Then all outbound voice, video and background
frames would each invoke a (bogus) RTS/CTS
handshake.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index aee5c9d..6cc58e0 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -867,7 +867,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 	mac_tmp = cpu_to_le16(AR9170_TX_MAC_HW_DURATION |
 			      AR9170_TX_MAC_BACKOFF);
-	mac_tmp |= cpu_to_le16((hw_queue << AR9170_TX_MAC_QOS_S) &&
+	mac_tmp |= cpu_to_le16((hw_queue << AR9170_TX_MAC_QOS_S) &
 			       AR9170_TX_MAC_QOS);
 
 	no_ack = !!(info->flags & IEEE80211_TX_CTL_NO_ACK);
