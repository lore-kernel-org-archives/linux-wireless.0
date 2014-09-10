Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:42562 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaIJPX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 11:23:26 -0400
Subject: [PATCH v4 1/2] ath10k: make ath10k_wmi_cmd_send() public
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Sep 2014 18:23:23 +0300
Message-ID: <20140910152323.12610.46916.stgit@potku.adurom.net> (sfid-20140910_172329_187518_E49DE911)
In-Reply-To: <20140910152136.12610.18499.stgit@potku.adurom.net>
References: <20140910152136.12610.18499.stgit@potku.adurom.net>
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
index e7edc89cfcd0..67af370012f9 100644
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
index bdb2e6cc0f4c..f8c1afbdb442 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4737,6 +4737,10 @@ int ath10k_wmi_wait_for_service_ready(struct ath10k *ar);
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
 
 int ath10k_wmi_connect(struct ath10k *ar);
+
+struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len);
+int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
+
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 				const struct wmi_channel_arg *);
 int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt);

