Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:54101 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbBFNjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 08:39:07 -0500
Received: by mail-we0-f176.google.com with SMTP id p10so2206487wes.7
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 05:39:05 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath10k: fix wmm params per vdev
Date: Fri,  6 Feb 2015 14:41:22 +0100
Message-Id: <1423230082-2396-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20150206_143911_532217_847370C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During wmm tests changing wmm parameters did not change anything.
This was because of mismatch in WMM params per vdev command.
WMM params per vdev uses different command structure than wmm params
per pdev command. Also txop for per vdev settings has the
same units as provided by mac80211.

Patch concerns qca6174.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 17 ++++++++---------
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 15 +++++----------
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  6 ++++++
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d6d2f0f..4c4f4df 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4161,13 +4161,7 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	p->cwmin = params->cw_min;
 	p->cwmax = params->cw_max;
 	p->aifs = params->aifs;
-
-	/*
-	 * The channel time duration programmed in the HW is in absolute
-	 * microseconds, while mac80211 gives the txop in units of
-	 * 32 microseconds.
-	 */
-	p->txop = params->txop * 32;
+	p->txop = params->txop;
 
 	if (ar->wmi.ops->gen_vdev_wmm_conf) {
 		ret = ath10k_wmi_vdev_wmm_conf(ar, arvif->vdev_id,
@@ -4178,9 +4172,14 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 			goto exit;
 		}
 	} else {
-		/* This won't work well with multi-interface cases but it's
-		 * better than nothing.
+		/* When wmm params per vdev are not supported by firmware
+		 * use per pdev params what won't work well with multi-interface
+		 * cases but it's better than nothing. This require channel time
+		 * duration programmed in the HW to be in absolute microseconds,
+		 * while mac80211 gives the txop in units of 32 microseconds.
 		 */
+		p->txop = p->txop * 32;
+
 		ret = ath10k_wmi_pdev_set_wmm_params(ar, &arvif->wmm_params);
 		if (ret) {
 			ath10k_warn(ar, "failed to set wmm params: %d\n", ret);
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

