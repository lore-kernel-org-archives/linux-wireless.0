Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48106 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbbBJLft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 06:35:49 -0500
Received: by mail-lb0-f180.google.com with SMTP id z12so14434758lbi.11
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2015 03:35:47 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v2] ath10k: fix wmm params per vdev
Date: Tue, 10 Feb 2015 12:38:15 +0100
Message-Id: <1423568295-28734-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20150210_123553_128833_AAE8196E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During wmm tests changing wmm parameters did not change anything.
This was because of mismatch in WMM params per vdev command.
WMM params per vdev uses different command structure than wmm params
per pdev command.

Patch concerns qca6174.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---

v2:
 * removed txop units modification

 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 15 +++++----------
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  6 ++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 71614ba..bdb3673 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1604,14 +1604,12 @@ ath10k_wmi_tlv_op_gen_vdev_wmm_conf(struct ath10k *ar, u32 vdev_id,
 				    const struct wmi_wmm_params_all_arg *arg)
 {
 	struct wmi_tlv_vdev_set_wmm_cmd *cmd;
-	struct wmi_wmm_params *wmm;
 	struct wmi_tlv *tlv;
 	struct sk_buff *skb;
 	size_t len;
 	void *ptr;
 
-	len = (sizeof(*tlv) + sizeof(*cmd)) +
-	      (4 * (sizeof(*tlv) + sizeof(*wmm)));
+	len = sizeof(*tlv) + sizeof(*cmd);
 	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
@@ -1623,13 +1621,10 @@ ath10k_wmi_tlv_op_gen_vdev_wmm_conf(struct ath10k *ar, u32 vdev_id,
 	cmd = (void *)tlv->value;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 
-	ptr += sizeof(*tlv);
-	ptr += sizeof(*cmd);
-
-	ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_be);
-	ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_bk);
-	ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_vi);
-	ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_vo);
+	ath10k_wmi_set_wmm_param(&cmd->vdev_wmm_params[0].params, &arg->ac_be);
+	ath10k_wmi_set_wmm_param(&cmd->vdev_wmm_params[1].params, &arg->ac_bk);
+	ath10k_wmi_set_wmm_param(&cmd->vdev_wmm_params[2].params, &arg->ac_vi);
+	ath10k_wmi_set_wmm_param(&cmd->vdev_wmm_params[3].params, &arg->ac_vo);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv vdev wmm conf\n");
 	return skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index de68fe7..c54de47 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1302,8 +1302,14 @@ struct wmi_tlv_pdev_set_wmm_cmd {
 	__le32 dg_type; /* no idea.. */
 } __packed;
 
+struct wmi_tlv_vdev_wmm_params {
+	__le32 dummy;
+	struct wmi_wmm_params params;
+} __packed;
+
 struct wmi_tlv_vdev_set_wmm_cmd {
 	__le32 vdev_id;
+	struct wmi_tlv_vdev_wmm_params vdev_wmm_params[4];
 } __packed;
 
 struct wmi_tlv_phyerr_ev {
-- 
2.1.4

