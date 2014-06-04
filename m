Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52920 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaFDSBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 14:01:52 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/4] ath10k:  save firmware debug log messages.
Date: Wed,  4 Jun 2014 11:01:40 -0700
Message-Id: <1401904902-5842-2-git-send-email-greearb@candelatech.com> (sfid-20140604_200158_149100_FED8ABF0)
In-Reply-To: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

They may be dumped through the firmware dump debugfs
file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4b7782a..40a1d8d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1089,6 +1089,12 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 
 	trace_ath10k_wmi_dbglog(skb->data, skb->len);
 
+	/* First 4 bytes are a messages-dropped-due-to-overflow counter,
+	 * and should not be recorded in the dbglog buffer, so we skip
+	 * them.
+	 */
+	ath10k_dbg_save_fw_dbg_buffer(ar, skb->data + 4, skb->len - 4);
+
 	return 0;
 }
 
-- 
1.7.11.7

