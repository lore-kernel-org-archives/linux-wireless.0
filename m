Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42165 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaFCQZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 12:25:22 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/4] ath10k:  save firmware debug log messages.
Date: Tue,  3 Jun 2014 09:25:17 -0700
Message-Id: <1401812719-25061-2-git-send-email-greearb@candelatech.com> (sfid-20140603_182534_496914_17CED818)
In-Reply-To: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

They may be dumped through the firmware dump debugfs
file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4b7782a..7637618 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1084,11 +1084,14 @@ static void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
 
 static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 {
+	u32 *m = (u32 *)(skb->data);
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
 		   skb->len);
 
 	trace_ath10k_wmi_dbglog(skb->data, skb->len);
 
+	ath10k_dbg_save_fw_dbg_buffer(ar, (u8 *)(&(m[1])), skb->len - 4);
+
 	return 0;
 }
 
-- 
1.7.11.7

