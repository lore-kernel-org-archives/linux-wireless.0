Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbeBKC4z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 21:56:55 -0500
From: Carl Huang <cjhuang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: fix use-after-free in ath10k_wmi_cmd_send_nowait
Date: Sun, 11 Feb 2018 10:56:45 +0800
Message-Id: <1518317805-5796-1-git-send-email-cjhuang@codeaurora.org> (sfid-20180211_035708_448984_E1F6E18B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The skb may be freed in tx completion context before
trace_ath10k_wmi_cmd is called. This can be easily captured
when KASAN(Kernel Address Sanitizer) is enabled. The fix is
to add a reference count to the skb and release it after
trace_ath10k_wmi_cmd is called.

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 58dc218..e63aedb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1742,8 +1743,10 @@ int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
 	cmd_hdr->cmd_id = __cpu_to_le32(cmd);
 
 	memset(skb_cb, 0, sizeof(*skb_cb));
+	skb_get(skb);
 	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
 	trace_ath10k_wmi_cmd(ar, cmd_id, skb->data, skb->len, ret);
+	dev_kfree_skb(skb);
 
 	if (ret)
 		goto err_pull;
-- 
2.7.4
