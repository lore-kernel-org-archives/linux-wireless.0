Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36409 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbFHLXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 07:23:34 -0400
Received: by wgbgq6 with SMTP id gq6so100695033wgb.3
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 04:23:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: prevent memory leak in wmi rx ops
Date: Mon,  8 Jun 2015 13:23:27 +0200
Message-Id: <1433762607-28854-1-git-send-email-michal.kazior@tieto.com> (sfid-20150608_132338_692609_DA09ED60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found during code review. This was pretty much
impossible to happen but better safe than sorry.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 3 ++-
 drivers/net/wireless/ath/ath10k/wmi.c     | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 563fde73623c..8fdba3865c96 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -402,7 +402,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
 
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
-		return;
+		goto out;
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
@@ -521,6 +521,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 
+out:
 	dev_kfree_skb(skb);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 77220b0f0e89..c2e86edfd66f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3222,7 +3222,7 @@ static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
 
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
-		return;
+		goto out;
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
@@ -3326,6 +3326,7 @@ static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 
+out:
 	dev_kfree_skb(skb);
 }
 
@@ -3339,7 +3340,7 @@ static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
 
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
-		return;
+		goto out;
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
@@ -3462,7 +3463,7 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
 
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
-		return;
+		goto out;
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
@@ -3570,6 +3571,7 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 
+out:
 	dev_kfree_skb(skb);
 }
 
-- 
2.1.4

