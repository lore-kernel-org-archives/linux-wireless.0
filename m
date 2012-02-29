Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57379 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2B2BZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 20:25:02 -0500
From: Etay Luz <eluz@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: add padding to firmware log records
Date: Tue, 28 Feb 2012 17:17:15 -0800
Message-ID: <1330478235-29294-1-git-send-email-eluz@qca.qualcomm.com> (sfid-20120229_022519_480892_E32D3982)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

firmware debug utility expects firmware log record size
to be 1500 bytes. This patch ensures that the
firmware record will be exactly 1500 bytes.

Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 drivers/net/wireless/ath/ath6kl/debug.c

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
old mode 100644
new mode 100755
index 3d0713d..8400284
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -277,7 +277,7 @@ void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
 	if (WARN_ON(len > ATH6KL_FWLOG_PAYLOAD_SIZE))
 		return;
 
-	slot_len = sizeof(*slot) + len;
+	slot_len = sizeof(*slot) + ATH6KL_FWLOG_PAYLOAD_SIZE;
 
 	skb = alloc_skb(slot_len, GFP_KERNEL);
 	if (!skb)
@@ -287,6 +287,9 @@ void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
 	slot->timestamp = cpu_to_le32(jiffies);
 	slot->length = cpu_to_le32(len);
 	memcpy(slot->payload, buf, len);
+	
+	/* Need to pad each record to fixed length ATH6KL_FWLOG_PAYLOAD_SIZE */
+	memset(slot->payload + len, 0, ATH6KL_FWLOG_PAYLOAD_SIZE - len);
 
 	spin_lock(&ar->debug.fwlog_queue.lock);
 
-- 
1.7.0.4

