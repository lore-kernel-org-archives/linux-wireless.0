Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37690 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaIDN4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 09:56:51 -0400
Subject: [PATCH v3 1/2] ath10k: make ath10k_wmi_cmd_send() public
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 04 Sep 2014 16:56:48 +0300
Message-ID: <20140904135648.26750.54412.stgit@potku.adurom.net> (sfid-20140904_155653_953104_5D5ED7F3)
In-Reply-To: <20140904135447.26750.52873.stgit@potku.adurom.net>
References: <20140904135447.26750.52873.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need this function to send wmi packets from testmode.c.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    5 ++---
 drivers/net/wireless/ath/ath10k/wmi.h |    4 ++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b13ccf6778c3..f80959419525 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -624,7 +624,7 @@ int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar)
 	return ret;
 }
 
-static struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len)
+struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len)
 {
 	struct sk_buff *skb;
 	u32 round_len = roundup(len, 4);
@@ -725,8 +725,7 @@ static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar)
 	wake_up(&ar->wmi.tx_credits_wq);
 }
 
-static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
-			       u32 cmd_id)
+int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 {
 	int ret = -EOPNOTSUPP;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e70836586756..8019a0f1edd1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4739,6 +4739,10 @@ int ath10k_wmi_wait_for_service_ready(struct ath10k *ar);
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
 
 int ath10k_wmi_connect(struct ath10k *ar);
+
+struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len);
+int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
+
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 				const struct wmi_channel_arg *);
 int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt);

