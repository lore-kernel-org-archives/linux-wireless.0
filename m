Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58905 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2CDI4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:56:06 -0500
Received: by mail-we0-f174.google.com with SMTP id x9so1794100wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:56:05 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/11] wl12xx: print the tx packet len
Date: Sun,  4 Mar 2012 10:55:55 +0200
Message-Id: <1330851355-24459-12-git-send-email-eliad@wizery.com> (sfid-20120304_095630_336762_AF3B5E28)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the packet length to the tx debug print.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3c966f2..95a76a5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1459,7 +1459,8 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto out;
 	}
 
-	wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d", hlid, q);
+	wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d len %d",
+		     hlid, q, skb->len);
 	skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
 
 	wl->tx_queue_count[q]++;
-- 
1.7.6.401.g6a319

