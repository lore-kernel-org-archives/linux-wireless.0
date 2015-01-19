Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48193 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbbASJAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 04:00:31 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so4047287wid.5
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 01:00:29 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: move wmm param storage to vif
Date: Mon, 19 Jan 2015 09:53:41 +0100
Message-Id: <1421657623-11706-1-git-send-email-michal.kazior@tieto.com> (sfid-20150119_100036_309256_4A4B9271)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 already requests WMM per vif but firmware
wasn't able to handle this until now. However new
wmi-tlv firmware for qca6174 is capable of this.

This prepares per-vif WMM param setup.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c     | 11 ++++++-----
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  4 ++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 32 +++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/wmi.c     | 14 +++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h     |  6 +++---
 6 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c5686122..238ec7e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -301,6 +301,7 @@ struct ath10k_vif {
 	bool use_cts_prot;
 	int num_legacy_stations;
 	int txpower;
+	struct wmi_wmm_params_all_arg wmm_params;
 };
 
 struct ath10k_vif_iter {
@@ -564,7 +565,6 @@ struct ath10k {
 	u8 cfg_tx_chainmask;
 	u8 cfg_rx_chainmask;
 
-	struct wmi_pdev_set_wmm_params_arg wmm_params;
 	struct completion install_key_done;
 
 	struct completion vdev_setup_done;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..a2a145b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4061,6 +4061,7 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 			  const struct ieee80211_tx_queue_params *params)
 {
 	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct wmi_wmm_params_arg *p = NULL;
 	int ret;
 
@@ -4068,16 +4069,16 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 
 	switch (ac) {
 	case IEEE80211_AC_VO:
-		p = &ar->wmm_params.ac_vo;
+		p = &arvif->wmm_params.ac_vo;
 		break;
 	case IEEE80211_AC_VI:
-		p = &ar->wmm_params.ac_vi;
+		p = &arvif->wmm_params.ac_vi;
 		break;
 	case IEEE80211_AC_BE:
-		p = &ar->wmm_params.ac_be;
+		p = &arvif->wmm_params.ac_be;
 		break;
 	case IEEE80211_AC_BK:
-		p = &ar->wmm_params.ac_bk;
+		p = &arvif->wmm_params.ac_bk;
 		break;
 	}
 
@@ -4098,7 +4099,7 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	p->txop = params->txop * 32;
 
 	/* FIXME: FW accepts wmm params per hw, not per vif */
-	ret = ath10k_wmi_pdev_set_wmm_params(ar, &ar->wmm_params);
+	ret = ath10k_wmi_pdev_set_wmm_params(ar, &arvif->wmm_params);
 	if (ret) {
 		ath10k_warn(ar, "failed to set wmm params: %d\n", ret);
 		goto exit;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 0dd49a7..4bb8cdd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -104,7 +104,7 @@ struct wmi_ops {
 					      const struct wmi_scan_chan_list_arg *arg);
 	struct sk_buff *(*gen_beacon_dma)(struct ath10k_vif *arvif);
 	struct sk_buff *(*gen_pdev_set_wmm)(struct ath10k *ar,
-					    const struct wmi_pdev_set_wmm_params_arg *arg);
+					    const struct wmi_wmm_params_all_arg *arg);
 	struct sk_buff *(*gen_request_stats)(struct ath10k *ar,
 					     enum wmi_stats_id stats_id);
 	struct sk_buff *(*gen_force_fw_hang)(struct ath10k *ar,
@@ -749,7 +749,7 @@ ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif)
 
 static inline int
 ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
-			       const struct wmi_pdev_set_wmm_params_arg *arg)
+			       const struct wmi_wmm_params_all_arg *arg)
 {
 	struct sk_buff *skb;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 6f34fc7..3e9725b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1406,6 +1406,21 @@ ath10k_wmi_tlv_op_gen_vdev_install_key(struct ath10k *ar,
 	return skb;
 }
 
+static void *ath10k_wmi_tlv_put_wmm(void *ptr,
+				    const struct wmi_wmm_params_arg *arg)
+{
+	struct wmi_wmm_params *wmm;
+	struct wmi_tlv *tlv;
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WMM_PARAMS);
+	tlv->len = __cpu_to_le16(sizeof(*wmm));
+	wmm = (void *)tlv->value;
+	ath10k_wmi_set_wmm_param(wmm, arg);
+
+	return ptr + sizeof(*tlv) + sizeof(*wmm);
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
 				  const u8 peer_addr[ETH_ALEN])
@@ -1766,24 +1781,9 @@ ath10k_wmi_tlv_op_gen_beacon_dma(struct ath10k_vif *arvif)
 	return skb;
 }
 
-static void *ath10k_wmi_tlv_put_wmm(void *ptr,
-				    const struct wmi_wmm_params_arg *arg)
-{
-	struct wmi_wmm_params *wmm;
-	struct wmi_tlv *tlv;
-
-	tlv = ptr;
-	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WMM_PARAMS);
-	tlv->len = __cpu_to_le16(sizeof(*wmm));
-	wmm = (void *)tlv->value;
-	ath10k_wmi_pdev_set_wmm_param(wmm, arg);
-
-	return ptr + sizeof(*tlv) + sizeof(*wmm);
-}
-
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_pdev_set_wmm(struct ath10k *ar,
-				   const struct wmi_pdev_set_wmm_params_arg *arg)
+				   const struct wmi_wmm_params_all_arg *arg)
 {
 	struct wmi_tlv_pdev_set_wmm_cmd *cmd;
 	struct wmi_wmm_params *wmm;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5fe17e8..105d561 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4717,8 +4717,8 @@ ath10k_wmi_op_gen_beacon_dma(struct ath10k_vif *arvif)
 	return skb;
 }
 
-void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
-				   const struct wmi_wmm_params_arg *arg)
+void ath10k_wmi_set_wmm_param(struct wmi_wmm_params *params,
+			      const struct wmi_wmm_params_arg *arg)
 {
 	params->cwmin  = __cpu_to_le32(arg->cwmin);
 	params->cwmax  = __cpu_to_le32(arg->cwmax);
@@ -4730,7 +4730,7 @@ void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
 
 static struct sk_buff *
 ath10k_wmi_op_gen_pdev_set_wmm(struct ath10k *ar,
-			       const struct wmi_pdev_set_wmm_params_arg *arg)
+			       const struct wmi_wmm_params_all_arg *arg)
 {
 	struct wmi_pdev_set_wmm_params *cmd;
 	struct sk_buff *skb;
@@ -4740,10 +4740,10 @@ ath10k_wmi_op_gen_pdev_set_wmm(struct ath10k *ar,
 		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_pdev_set_wmm_params *)skb->data;
-	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_be, &arg->ac_be);
-	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_bk, &arg->ac_bk);
-	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_vi, &arg->ac_vi);
-	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_vo, &arg->ac_vo);
+	ath10k_wmi_set_wmm_param(&cmd->ac_be, &arg->ac_be);
+	ath10k_wmi_set_wmm_param(&cmd->ac_bk, &arg->ac_bk);
+	ath10k_wmi_set_wmm_param(&cmd->ac_vi, &arg->ac_vi);
+	ath10k_wmi_set_wmm_param(&cmd->ac_vo, &arg->ac_vo);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi pdev set wmm params\n");
 	return skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bd7f29a..ab89359 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2939,7 +2939,7 @@ struct wmi_wmm_params_arg {
 	u32 no_ack;
 };
 
-struct wmi_pdev_set_wmm_params_arg {
+struct wmi_wmm_params_all_arg {
 	struct wmi_wmm_params_arg ac_be;
 	struct wmi_wmm_params_arg ac_bk;
 	struct wmi_wmm_params_arg ac_vi;
@@ -4780,8 +4780,8 @@ void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
 				    struct wmi_host_mem_chunks *chunks);
 void ath10k_wmi_put_start_scan_common(struct wmi_start_scan_common *cmn,
 				      const struct wmi_start_scan_arg *arg);
-void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
-				   const struct wmi_wmm_params_arg *arg);
+void ath10k_wmi_set_wmm_param(struct wmi_wmm_params *params,
+			      const struct wmi_wmm_params_arg *arg);
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 				const struct wmi_channel_arg *arg);
 int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg);
-- 
1.8.5.3

