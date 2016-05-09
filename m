Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49985 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbcEIXL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:27 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 08/21] ath10k: make firmware text debug messages more verbose.
Date: Mon,  9 May 2016 16:11:02 -0700
Message-Id: <1462835475-11079-9-git-send-email-greearb@candelatech.com> (sfid-20160510_012231_278932_BA0EF499)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
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
index 1758b4a..d9e4b77 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4050,7 +4050,7 @@ void ath10k_wmi_event_debug_print(struct ath10k *ar, struct sk_buff *skb)
 	/* the last byte is always reserved for the null character */
 	buf[i] = '\0';
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI_PRINT, "wmi print '%s'\n", buf);
+	ath10k_info(ar, "wmi print '%s'\n", buf);
 }
 
 void ath10k_wmi_event_pdev_qvit(struct ath10k *ar, struct sk_buff *skb)
-- 
2.4.3

