Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60837 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab3J1GVC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 02:21:02 -0400
Received: by mail-ee0-f51.google.com with SMTP id d41so3200361eek.10
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 23:21:00 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: plug memory leak on beacon tx
Date: Mon, 28 Oct 2013 07:18:14 +0100
Message-Id: <1382941094-3291-3-git-send-email-michal.kazior@tieto.com> (sfid-20131028_072110_809630_6A382BAB)
In-Reply-To: <1382941094-3291-1-git-send-email-michal.kazior@tieto.com>
References: <1382941094-3291-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If beacon tx command failed the wmi command buffer
was not freed. This led to OOM in the long run.
This became aparent when stress testing
multi-BSSID.

Reported-By: Tomasz Skapski <tomasz.skapski@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8db9db2..f79f17c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3092,6 +3092,7 @@ int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
 {
 	struct wmi_bcn_tx_cmd *cmd;
 	struct sk_buff *skb;
+	int ret;
 
 	skb = ath10k_wmi_alloc_skb(sizeof(*cmd) + arg->bcn_len);
 	if (!skb)
@@ -3104,7 +3105,11 @@ int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
 	cmd->hdr.bcn_len  = __cpu_to_le32(arg->bcn_len);
 	memcpy(cmd->bcn, arg->bcn, arg->bcn_len);
 
-	return ath10k_wmi_cmd_send_nowait(ar, skb, ar->wmi.cmd->bcn_tx_cmdid);
+	ret = ath10k_wmi_cmd_send_nowait(ar, skb, ar->wmi.cmd->bcn_tx_cmdid);
+	if (ret)
+		dev_kfree_skb(skb);
+
+	return ret;
 }
 
 static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
-- 
1.8.4.rc3

