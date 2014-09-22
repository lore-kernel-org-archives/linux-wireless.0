Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38484 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIVUyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 16:54:09 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath10k:  make firmware text debug messages more verbose.
Date: Mon, 22 Sep 2014 13:54:04 -0700
Message-Id: <1411419245-25799-1-git-send-email-greearb@candelatech.com> (sfid-20140922_225413_548048_F145ECC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

There are not many of these messages producted by the
firmware, but they are generally fairly useful, so print
them at info level.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cd60940..6be62ac 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2050,7 +2050,7 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
 	/* the last byte is always reserved for the null character */
 	buf[i] = '\0';
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug print '%s'\n", buf);
+	ath10k_info(ar, "wmi event debug print '%s'\n", buf);
 }
 
 static void ath10k_wmi_event_pdev_qvit(struct ath10k *ar, struct sk_buff *skb)
-- 
1.7.11.7

