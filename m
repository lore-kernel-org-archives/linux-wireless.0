Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38201 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbbA3JsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:48:22 -0500
Received: by mail-wi0-f169.google.com with SMTP id h11so1750648wiw.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 01:48:21 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/4] ath10k: change request stats command prototype
Date: Fri, 30 Jan 2015 10:47:22 +0100
Message-Id: <1422611244-20767-3-git-send-email-michal.kazior@tieto.com> (sfid-20150130_104828_519509_FDDCCC30)
In-Reply-To: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
References: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The expected parameter is not a single value but a
mask of values.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 7 +++----
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 5 ++---
 drivers/net/wireless/ath/ath10k/wmi.c     | 7 ++++---
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 058f88b..ec8e156 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -107,8 +107,7 @@ struct wmi_ops {
 	struct sk_buff *(*gen_beacon_dma)(struct ath10k_vif *arvif);
 	struct sk_buff *(*gen_pdev_set_wmm)(struct ath10k *ar,
 					    const struct wmi_wmm_params_all_arg *arg);
-	struct sk_buff *(*gen_request_stats)(struct ath10k *ar,
-					     enum wmi_stats_id stats_id);
+	struct sk_buff *(*gen_request_stats)(struct ath10k *ar, u32 stats_mask);
 	struct sk_buff *(*gen_force_fw_hang)(struct ath10k *ar,
 					     enum wmi_force_fw_hang_type type,
 					     u32 delay_ms);
@@ -809,14 +808,14 @@ ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 }
 
 static inline int
-ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
+ath10k_wmi_request_stats(struct ath10k *ar, u32 stats_mask)
 {
 	struct sk_buff *skb;
 
 	if (!ar->wmi.ops->gen_request_stats)
 		return -EOPNOTSUPP;
 
-	skb = ar->wmi.ops->gen_request_stats(ar, stats_id);
+	skb = ar->wmi.ops->gen_request_stats(ar, stats_mask);
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index be32db9..8264f2e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2078,8 +2078,7 @@ ath10k_wmi_tlv_op_gen_pdev_set_wmm(struct ath10k *ar,
 }
 
 static struct sk_buff *
-ath10k_wmi_tlv_op_gen_request_stats(struct ath10k *ar,
-				    enum wmi_stats_id stats_id)
+ath10k_wmi_tlv_op_gen_request_stats(struct ath10k *ar, u32 stats_mask)
 {
 	struct wmi_request_stats_cmd *cmd;
 	struct wmi_tlv *tlv;
@@ -2093,7 +2092,7 @@ ath10k_wmi_tlv_op_gen_request_stats(struct ath10k *ar,
 	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_REQUEST_STATS_CMD);
 	tlv->len = __cpu_to_le16(sizeof(*cmd));
 	cmd = (void *)tlv->value;
-	cmd->stats_id = __cpu_to_le32(stats_id);
+	cmd->stats_id = __cpu_to_le32(stats_mask);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv request stats\n");
 	return skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ce6f0c7..27e0c18 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4923,7 +4923,7 @@ ath10k_wmi_op_gen_pdev_set_wmm(struct ath10k *ar,
 }
 
 static struct sk_buff *
-ath10k_wmi_op_gen_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
+ath10k_wmi_op_gen_request_stats(struct ath10k *ar, u32 stats_mask)
 {
 	struct wmi_request_stats_cmd *cmd;
 	struct sk_buff *skb;
@@ -4933,9 +4933,10 @@ ath10k_wmi_op_gen_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
 		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_request_stats_cmd *)skb->data;
-	cmd->stats_id = __cpu_to_le32(stats_id);
+	cmd->stats_id = __cpu_to_le32(stats_mask);
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi request stats %d\n", (int)stats_id);
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi request stats 0x%08x\n",
+		   stats_mask);
 	return skb;
 }
 
-- 
1.8.5.3

