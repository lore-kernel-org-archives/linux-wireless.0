Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:38049 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZAEWhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 17:37:33 -0500
Received: by wf-out-1314.google.com with SMTP id 27so7817872wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 14:37:32 -0800 (PST)
Message-ID: <49628bab.1f068e0a.7d36.fffff3f5@mx.google.com> (sfid-20090105_233738_313157_CB6041F5)
Date: Mon, 05 Jan 2009 14:37:31 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] libertas_tf: return NETDEV_TX_OK in TX op
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX op should return NETDEV_TX_OK or NETDEV_TX_BUSY.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index d1fc305..e7289e2 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -206,7 +206,7 @@ static int lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * there are no buffered multicast frames to send
 	 */
 	ieee80211_stop_queues(priv->hw);
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 static void lbtf_tx_work(struct work_struct *work)


