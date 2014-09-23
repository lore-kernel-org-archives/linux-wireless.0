Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51137 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbaIWVSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 17:18:09 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 04/10] ath10k: make firmware text debug messages more verbose.
Date: Tue, 23 Sep 2014 14:17:19 -0700
Message-Id: <1411507045-18973-4-git-send-email-greearb@candelatech.com> (sfid-20140923_231827_675422_1E130404)
In-Reply-To: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

There are not many of these messages producted by the
firmware, but they are generally fairly useful, so print
them at info level.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Add and use a new debug-msg flag, change message
     preamble slightly.

 drivers/net/wireless/ath/ath10k/debug.h | 1 +
 drivers/net/wireless/ath/ath10k/wmi.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 39032e9..8c3b898 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -35,6 +35,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_BMI		= 0x00000400,
 	ATH10K_DBG_REGULATORY	= 0x00000800,
 	ATH10K_DBG_TESTMODE	= 0x00001000,
+	ATH10K_DBG_FW_MSG	= 0x00002000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index bfc1fb3..f1515c0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2070,7 +2070,7 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
 	/* the last byte is always reserved for the null character */
 	buf[i] = '\0';
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug print '%s'\n", buf);
+	ath10k_dbg(ar, ATH10K_DBG_FW_MSG, "wmi firmware message '%s'\n", buf);
 }
 
 static void ath10k_wmi_event_pdev_qvit(struct ath10k *ar, struct sk_buff *skb)
-- 
1.7.11.7

