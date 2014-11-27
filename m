Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53242 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaK0JXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 04:23:51 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so5884065wgg.22
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 01:23:49 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/7] ath10k: introduce wmi ops
Date: Thu, 27 Nov 2014 10:11:19 +0100
Message-Id: <1417079481-22255-6-git-send-email-michal.kazior@tieto.com> (sfid-20141127_102410_043647_E750F3F4)
In-Reply-To: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
References: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the 10.x fw branch support was introduced it
became apparent ath10k will need to be able to
deal with different fw ABIs eventually.

The patch creates an abstraction for dealing with
command and event structures across different ABIs
and mostly gets rid of the
ATH10K_FW_FEATURE_WMI_10X flag usage.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |   1 +
 drivers/net/wireless/ath/ath10k/core.h     |   1 +
 drivers/net/wireless/ath/ath10k/debug.c    |   1 +
 drivers/net/wireless/ath/ath10k/mac.c      |   2 +
 drivers/net/wireless/ath/ath10k/spectral.c |   1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h  | 820 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 888 +++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/wmi.h      |  67 +--
 8 files changed, 1345 insertions(+), 436 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-ops.h

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7762061..e8384e1 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -27,6 +27,7 @@
 #include "debug.h"
 #include "htt.h"
 #include "testmode.h"
+#include "wmi-ops.h"
 
 unsigned int ath10k_debug_mask;
 static bool uart_print;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5af9a24..837972c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -127,6 +127,7 @@ struct ath10k_wmi {
 	struct wmi_cmd_map *cmd;
 	struct wmi_vdev_param_map *vdev_param;
 	struct wmi_pdev_param_map *pdev_param;
+	const struct wmi_ops *ops;
 
 	u32 num_mem_chunks;
 	struct ath10k_mem_chunk mem_chunks[WMI_MAX_MEM_REQS];
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index a716758..c15b5774 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -23,6 +23,7 @@
 #include "core.h"
 #include "debug.h"
 #include "hif.h"
+#include "wmi-ops.h"
 
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e475cc4..2bc97f3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -27,6 +27,8 @@
 #include "htt.h"
 #include "txrx.h"
 #include "testmode.h"
+#include "wmi.h"
+#include "wmi-ops.h"
 
 /**********/
 /* Crypto */
diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index 63ce61f..d22addf 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -17,6 +17,7 @@
 #include <linux/relay.h>
 #include "core.h"
 #include "debug.h"
+#include "wmi-ops.h"
 
 static void send_fft_sample(struct ath10k *ar,
 			    const struct fft_sample_tlv *fft_sample_tlv)
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
new file mode 100644
index 0000000..f3b87a8
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -0,0 +1,820 @@
+/*
+ * Copyright (c) 2005-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _WMI_OPS_H_
+#define _WMI_OPS_H_
+
+struct ath10k;
+struct sk_buff;
+
+struct wmi_ops {
+	void (*rx)(struct ath10k *ar, struct sk_buff *skb);
+	void (*map_svc)(const __le32 *in, unsigned long *out, size_t len);
+
+	int (*pull_scan)(struct ath10k *ar, struct sk_buff *skb,
+			 struct wmi_scan_ev_arg *arg);
+	int (*pull_mgmt_rx)(struct ath10k *ar, struct sk_buff *skb,
+			    struct wmi_mgmt_rx_ev_arg *arg);
+	int (*pull_ch_info)(struct ath10k *ar, struct sk_buff *skb,
+			    struct wmi_ch_info_ev_arg *arg);
+	int (*pull_vdev_start)(struct ath10k *ar, struct sk_buff *skb,
+			       struct wmi_vdev_start_ev_arg *arg);
+	int (*pull_peer_kick)(struct ath10k *ar, struct sk_buff *skb,
+			      struct wmi_peer_kick_ev_arg *arg);
+	int (*pull_swba)(struct ath10k *ar, struct sk_buff *skb,
+			 struct wmi_swba_ev_arg *arg);
+	int (*pull_phyerr)(struct ath10k *ar, struct sk_buff *skb,
+			   struct wmi_phyerr_ev_arg *arg);
+	int (*pull_svc_rdy)(struct ath10k *ar, struct sk_buff *skb,
+			    struct wmi_svc_rdy_ev_arg *arg);
+	int (*pull_rdy)(struct ath10k *ar, struct sk_buff *skb,
+			struct wmi_rdy_ev_arg *arg);
+	int (*pull_fw_stats)(struct ath10k *ar, struct sk_buff *skb,
+			     struct ath10k_fw_stats *stats);
+
+	struct sk_buff *(*gen_pdev_suspend)(struct ath10k *ar, u32 suspend_opt);
+	struct sk_buff *(*gen_pdev_resume)(struct ath10k *ar);
+	struct sk_buff *(*gen_pdev_set_rd)(struct ath10k *ar, u16 rd, u16 rd2g,
+					   u16 rd5g, u16 ctl2g, u16 ctl5g,
+					   enum wmi_dfs_region dfs_reg);
+	struct sk_buff *(*gen_pdev_set_param)(struct ath10k *ar, u32 id,
+					      u32 value);
+	struct sk_buff *(*gen_init)(struct ath10k *ar);
+	struct sk_buff *(*gen_start_scan)(struct ath10k *ar,
+					  const struct wmi_start_scan_arg *arg);
+	struct sk_buff *(*gen_stop_scan)(struct ath10k *ar,
+					 const struct wmi_stop_scan_arg *arg);
+	struct sk_buff *(*gen_vdev_create)(struct ath10k *ar, u32 vdev_id,
+					   enum wmi_vdev_type type,
+					   enum wmi_vdev_subtype subtype,
+					   const u8 macaddr[ETH_ALEN]);
+	struct sk_buff *(*gen_vdev_delete)(struct ath10k *ar, u32 vdev_id);
+	struct sk_buff *(*gen_vdev_start)(struct ath10k *ar,
+					  const struct wmi_vdev_start_request_arg *arg,
+					  bool restart);
+	struct sk_buff *(*gen_vdev_stop)(struct ath10k *ar, u32 vdev_id);
+	struct sk_buff *(*gen_vdev_up)(struct ath10k *ar, u32 vdev_id, u32 aid,
+				       const u8 *bssid);
+	struct sk_buff *(*gen_vdev_down)(struct ath10k *ar, u32 vdev_id);
+	struct sk_buff *(*gen_vdev_set_param)(struct ath10k *ar, u32 vdev_id,
+					      u32 param_id, u32 param_value);
+	struct sk_buff *(*gen_vdev_install_key)(struct ath10k *ar,
+						const struct wmi_vdev_install_key_arg *arg);
+	struct sk_buff *(*gen_vdev_spectral_conf)(struct ath10k *ar,
+						  const struct wmi_vdev_spectral_conf_arg *arg);
+	struct sk_buff *(*gen_vdev_spectral_enable)(struct ath10k *ar, u32 vdev_id,
+						    u32 trigger, u32 enable);
+	struct sk_buff *(*gen_peer_create)(struct ath10k *ar, u32 vdev_id,
+					   const u8 peer_addr[ETH_ALEN]);
+	struct sk_buff *(*gen_peer_delete)(struct ath10k *ar, u32 vdev_id,
+					   const u8 peer_addr[ETH_ALEN]);
+	struct sk_buff *(*gen_peer_flush)(struct ath10k *ar, u32 vdev_id,
+					  const u8 peer_addr[ETH_ALEN],
+					  u32 tid_bitmap);
+	struct sk_buff *(*gen_peer_set_param)(struct ath10k *ar, u32 vdev_id,
+					      const u8 *peer_addr,
+					      enum wmi_peer_param param_id,
+					      u32 param_value);
+	struct sk_buff *(*gen_peer_assoc)(struct ath10k *ar,
+					  const struct wmi_peer_assoc_complete_arg *arg);
+	struct sk_buff *(*gen_set_psmode)(struct ath10k *ar, u32 vdev_id,
+					  enum wmi_sta_ps_mode psmode);
+	struct sk_buff *(*gen_set_sta_ps)(struct ath10k *ar, u32 vdev_id,
+					  enum wmi_sta_powersave_param param_id,
+					  u32 value);
+	struct sk_buff *(*gen_set_ap_ps)(struct ath10k *ar, u32 vdev_id,
+					 const u8 *mac,
+					 enum wmi_ap_ps_peer_param param_id,
+					 u32 value);
+	struct sk_buff *(*gen_scan_chan_list)(struct ath10k *ar,
+					      const struct wmi_scan_chan_list_arg *arg);
+	struct sk_buff *(*gen_beacon_dma)(struct ath10k_vif *arvif);
+	struct sk_buff *(*gen_pdev_set_wmm)(struct ath10k *ar,
+					    const struct wmi_pdev_set_wmm_params_arg *arg);
+	struct sk_buff *(*gen_request_stats)(struct ath10k *ar,
+					     enum wmi_stats_id stats_id);
+	struct sk_buff *(*gen_force_fw_hang)(struct ath10k *ar,
+					     enum wmi_force_fw_hang_type type,
+					     u32 delay_ms);
+	struct sk_buff *(*gen_mgmt_tx)(struct ath10k *ar, struct sk_buff *skb);
+	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u32 module_enable);
+	struct sk_buff *(*gen_pktlog_enable)(struct ath10k *ar, u32 filter);
+	struct sk_buff *(*gen_pktlog_disable)(struct ath10k *ar);
+};
+
+int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
+
+static inline int
+ath10k_wmi_rx(struct ath10k *ar, struct sk_buff *skb)
+{
+	if (WARN_ON_ONCE(!ar->wmi.ops->rx))
+		return -EOPNOTSUPP;
+
+	ar->wmi.ops->rx(ar, skb);
+	return 0;
+}
+
+static inline int
+ath10k_wmi_map_svc(struct ath10k *ar, const __le32 *in, unsigned long *out,
+		   size_t len)
+{
+	if (!ar->wmi.ops->map_svc)
+		return -EOPNOTSUPP;
+
+	ar->wmi.ops->map_svc(in, out, len);
+	return 0;
+}
+
+static inline int
+ath10k_wmi_pull_scan(struct ath10k *ar, struct sk_buff *skb,
+		     struct wmi_scan_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_scan)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_scan(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_mgmt_rx(struct ath10k *ar, struct sk_buff *skb,
+			struct wmi_mgmt_rx_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_mgmt_rx)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_mgmt_rx(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_ch_info(struct ath10k *ar, struct sk_buff *skb,
+			struct wmi_ch_info_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_ch_info)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_ch_info(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_vdev_start(struct ath10k *ar, struct sk_buff *skb,
+			   struct wmi_vdev_start_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_vdev_start)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_vdev_start(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_peer_kick(struct ath10k *ar, struct sk_buff *skb,
+			  struct wmi_peer_kick_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_peer_kick)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_peer_kick(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_swba(struct ath10k *ar, struct sk_buff *skb,
+		     struct wmi_swba_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_swba)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_swba(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_phyerr(struct ath10k *ar, struct sk_buff *skb,
+		       struct wmi_phyerr_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_phyerr)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_phyerr(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_svc_rdy(struct ath10k *ar, struct sk_buff *skb,
+			struct wmi_svc_rdy_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_svc_rdy)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_svc_rdy(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_rdy(struct ath10k *ar, struct sk_buff *skb,
+		    struct wmi_rdy_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_rdy)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_rdy(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
+			 struct ath10k_fw_stats *stats)
+{
+	if (!ar->wmi.ops->pull_fw_stats)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_fw_stats(ar, skb, stats);
+}
+
+static inline int
+ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(msdu);
+	struct sk_buff *skb;
+	int ret;
+
+	if (!ar->wmi.ops->gen_mgmt_tx)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_mgmt_tx(ar, msdu);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	ret = ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->mgmt_tx_cmdid);
+	if (ret)
+		return ret;
+
+	/* FIXME There's no ACK event for Management Tx. This probably
+	 * shouldn't be called here either. */
+	info->flags |= IEEE80211_TX_STAT_ACK;
+	ieee80211_tx_status_irqsafe(ar->hw, msdu);
+
+	return 0;
+}
+
+static inline int
+ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g, u16 rd5g,
+			      u16 ctl2g, u16 ctl5g,
+			      enum wmi_dfs_region dfs_reg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_set_rd)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_set_rd(ar, rd, rd2g, rd5g, ctl2g, ctl5g,
+					   dfs_reg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_regdomain_cmdid);
+}
+
+static inline int
+ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_suspend)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_suspend(ar, suspend_opt);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_suspend_cmdid);
+}
+
+static inline int
+ath10k_wmi_pdev_resume_target(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_resume)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_resume(ar);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_resume_cmdid);
+}
+
+static inline int
+ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_set_param)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_set_param(ar, id, value);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_set_param_cmdid);
+}
+
+static inline int
+ath10k_wmi_cmd_init(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_init)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_init(ar);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->init_cmdid);
+}
+
+static inline int
+ath10k_wmi_start_scan(struct ath10k *ar,
+		      const struct wmi_start_scan_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_start_scan)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_start_scan(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->start_scan_cmdid);
+}
+
+static inline int
+ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_stop_scan)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_stop_scan(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->stop_scan_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
+		       enum wmi_vdev_type type,
+		       enum wmi_vdev_subtype subtype,
+		       const u8 macaddr[ETH_ALEN])
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_create)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_create(ar, vdev_id, type, subtype, macaddr);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_create_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_delete)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_delete(ar, vdev_id);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_delete_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_start(struct ath10k *ar,
+		      const struct wmi_vdev_start_request_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_start)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_start(ar, arg, false);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->vdev_start_request_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_restart(struct ath10k *ar,
+			const struct wmi_vdev_start_request_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_start)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_start(ar, arg, true);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->vdev_restart_request_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_stop)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_stop(ar, vdev_id);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_stop_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_up)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_up(ar, vdev_id, aid, bssid);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_up_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_down)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_down(ar, vdev_id);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_down_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id, u32 param_id,
+			  u32 param_value)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_set_param)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_set_param(ar, vdev_id, param_id,
+					      param_value);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_set_param_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_install_key(struct ath10k *ar,
+			    const struct wmi_vdev_install_key_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_vdev_install_key)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_install_key(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->vdev_install_key_cmdid);
+}
+
+static inline int
+ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
+			      const struct wmi_vdev_spectral_conf_arg *arg)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	skb = ar->wmi.ops->gen_vdev_spectral_conf(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->vdev_spectral_scan_configure_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
+static inline int
+ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
+				u32 enable)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	skb = ar->wmi.ops->gen_vdev_spectral_enable(ar, vdev_id, trigger,
+						    enable);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->vdev_spectral_scan_enable_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
+static inline int
+ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
+		       const u8 peer_addr[ETH_ALEN])
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_peer_create)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_peer_create(ar, vdev_id, peer_addr);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_create_cmdid);
+}
+
+static inline int
+ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
+		       const u8 peer_addr[ETH_ALEN])
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_peer_delete)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_peer_delete(ar, vdev_id, peer_addr);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_delete_cmdid);
+}
+
+static inline int
+ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
+		      const u8 peer_addr[ETH_ALEN], u32 tid_bitmap)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_peer_flush)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_peer_flush(ar, vdev_id, peer_addr, tid_bitmap);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_flush_tids_cmdid);
+}
+
+static inline int
+ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id, const u8 *peer_addr,
+			  enum wmi_peer_param param_id, u32 param_value)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_peer_set_param)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_peer_set_param(ar, vdev_id, peer_addr, param_id,
+					      param_value);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_set_param_cmdid);
+}
+
+static inline int
+ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
+		      enum wmi_sta_ps_mode psmode)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_set_psmode)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_set_psmode(ar, vdev_id, psmode);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->sta_powersave_mode_cmdid);
+}
+
+static inline int
+ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
+			    enum wmi_sta_powersave_param param_id, u32 value)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_set_sta_ps)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_set_sta_ps(ar, vdev_id, param_id, value);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->sta_powersave_param_cmdid);
+}
+
+static inline int
+ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
+			   enum wmi_ap_ps_peer_param param_id, u32 value)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_set_ap_ps)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_set_ap_ps(ar, vdev_id, mac, param_id, value);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->ap_ps_peer_param_cmdid);
+}
+
+static inline int
+ath10k_wmi_scan_chan_list(struct ath10k *ar,
+			  const struct wmi_scan_chan_list_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_scan_chan_list)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_scan_chan_list(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->scan_chan_list_cmdid);
+}
+
+static inline int
+ath10k_wmi_peer_assoc(struct ath10k *ar,
+		      const struct wmi_peer_assoc_complete_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_peer_assoc)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_peer_assoc(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_assoc_cmdid);
+}
+
+static inline int
+ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	struct sk_buff *skb;
+	int ret;
+
+	if (!ar->wmi.ops->gen_beacon_dma)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_beacon_dma(arvif);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	ret = ath10k_wmi_cmd_send_nowait(ar, skb,
+					 ar->wmi.cmd->pdev_send_bcn_cmdid);
+	if (ret) {
+		dev_kfree_skb(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
+static inline int
+ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
+			       const struct wmi_pdev_set_wmm_params_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_set_wmm)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_set_wmm(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_wmm_params_cmdid);
+}
+
+static inline int
+ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_request_stats)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_request_stats(ar, stats_id);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->request_stats_cmdid);
+}
+
+static inline int
+ath10k_wmi_force_fw_hang(struct ath10k *ar,
+			 enum wmi_force_fw_hang_type type, u32 delay_ms)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_force_fw_hang)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_force_fw_hang(ar, type, delay_ms);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->force_fw_hang_cmdid);
+}
+
+static inline int
+ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_dbglog_cfg)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_dbglog_cfg(ar, module_enable);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->dbglog_cfg_cmdid);
+}
+
+static inline int
+ath10k_wmi_pdev_pktlog_enable(struct ath10k *ar, u32 filter)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pktlog_enable)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pktlog_enable(ar, filter);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_pktlog_enable_cmdid);
+}
+
+static inline int
+ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pktlog_disable)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pktlog_disable(ar);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_pktlog_disable_cmdid);
+}
+
+#endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4a9468e..0f3c410 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -24,6 +24,7 @@
 #include "wmi.h"
 #include "mac.h"
 #include "testmode.h"
+#include "wmi-ops.h"
 
 /* MAIN WMI cmd track */
 static struct wmi_cmd_map wmi_cmd_map = {
@@ -685,8 +686,8 @@ static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 
-static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
-				      u32 cmd_id)
+int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
+			       u32 cmd_id)
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	struct wmi_cmd_hdr *cmd_hdr;
@@ -792,24 +793,23 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	return ret;
 }
 
-int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
+static struct sk_buff *
+ath10k_wmi_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 {
-	int ret = 0;
 	struct wmi_mgmt_tx_cmd *cmd;
 	struct ieee80211_hdr *hdr;
-	struct sk_buff *wmi_skb;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct sk_buff *skb;
 	int len;
-	u32 buf_len = skb->len;
+	u32 buf_len = msdu->len;
 	u16 fc;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
+	hdr = (struct ieee80211_hdr *)msdu->data;
 	fc = le16_to_cpu(hdr->frame_control);
 
 	if (WARN_ON_ONCE(!ieee80211_is_mgmt(hdr->frame_control)))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
-	len = sizeof(cmd->hdr) + skb->len;
+	len = sizeof(cmd->hdr) + msdu->len;
 
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
@@ -821,36 +821,27 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 
 	len = round_up(len, 4);
 
-	wmi_skb = ath10k_wmi_alloc_skb(ar, len);
-	if (!wmi_skb)
-		return -ENOMEM;
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
 
-	cmd = (struct wmi_mgmt_tx_cmd *)wmi_skb->data;
+	cmd = (struct wmi_mgmt_tx_cmd *)skb->data;
 
-	cmd->hdr.vdev_id = __cpu_to_le32(ATH10K_SKB_CB(skb)->vdev_id);
+	cmd->hdr.vdev_id = __cpu_to_le32(ATH10K_SKB_CB(msdu)->vdev_id);
 	cmd->hdr.tx_rate = 0;
 	cmd->hdr.tx_power = 0;
 	cmd->hdr.buf_len = __cpu_to_le32(buf_len);
 
 	ether_addr_copy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr));
-	memcpy(cmd->buf, skb->data, skb->len);
+	memcpy(cmd->buf, msdu->data, msdu->len);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
-		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
+		   msdu, skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
 	trace_ath10k_tx_hdr(ar, skb->data, skb->len);
 	trace_ath10k_tx_payload(ar, skb->data, skb->len);
 
-	/* Send the management frame buffer to the target */
-	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
-	if (ret)
-		return ret;
-
-	/* TODO: report tx status to mac80211 - temporary just ACK */
-	info->flags |= IEEE80211_TX_STAT_ACK;
-	ieee80211_tx_status_irqsafe(ar->hw, skb);
-
-	return ret;
+	return skb;
 }
 
 static void ath10k_wmi_event_scan_started(struct ath10k *ar)
@@ -977,8 +968,8 @@ ath10k_wmi_event_scan_type_str(enum wmi_scan_event_type type,
 	}
 }
 
-static int ath10k_wmi_pull_scan_ev(struct sk_buff *skb,
-				   struct wmi_scan_ev_arg *arg)
+static int ath10k_wmi_op_pull_scan_ev(struct ath10k *ar, struct sk_buff *skb,
+				      struct wmi_scan_ev_arg *arg)
 {
 	struct wmi_scan_event *ev = (void *)skb->data;
 
@@ -1007,7 +998,7 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 	u32 vdev_id;
 	int ret;
 
-	ret = ath10k_wmi_pull_scan_ev(skb, &arg);
+	ret = ath10k_wmi_pull_scan(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse scan event: %d\n", ret);
 		return ret;
@@ -1173,9 +1164,8 @@ static void ath10k_wmi_handle_wep_reauth(struct ath10k *ar,
 	}
 }
 
-static int ath10k_wmi_pull_mgmt_rx_ev(struct sk_buff *skb,
-				      struct wmi_mgmt_rx_ev_arg *arg,
-				      struct ath10k *ar)
+static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
+					 struct wmi_mgmt_rx_ev_arg *arg)
 {
 	struct wmi_mgmt_rx_event_v1 *ev_v1;
 	struct wmi_mgmt_rx_event_v2 *ev_v2;
@@ -1230,7 +1220,7 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	u16 fc;
 	int ret;
 
-	ret = ath10k_wmi_pull_mgmt_rx_ev(skb, &arg, ar);
+	ret = ath10k_wmi_pull_mgmt_rx(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse mgmt rx event: %d\n", ret);
 		return ret;
@@ -1350,8 +1340,8 @@ exit:
 	return idx;
 }
 
-static int ath10k_wmi_pull_ch_info_ev(struct sk_buff *skb,
-				      struct wmi_ch_info_ev_arg *arg)
+static int ath10k_wmi_op_pull_ch_info_ev(struct ath10k *ar, struct sk_buff *skb,
+					 struct wmi_ch_info_ev_arg *arg)
 {
 	struct wmi_chan_info_event *ev = (void *)skb->data;
 
@@ -1376,7 +1366,7 @@ static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 	u32 err_code, freq, cmd_flags, noise_floor, rx_clear_count, cycle_count;
 	int idx, ret;
 
-	ret = ath10k_wmi_pull_ch_info_ev(skb, &arg);
+	ret = ath10k_wmi_pull_ch_info(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse chan info event: %d\n", ret);
 		return;
@@ -1513,9 +1503,9 @@ static void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
 	dst->peer_tx_rate = __le32_to_cpu(src->peer_tx_rate);
 }
 
-static int ath10k_wmi_main_pull_fw_stats(struct ath10k *ar,
-					 struct sk_buff *skb,
-					 struct ath10k_fw_stats *stats)
+static int ath10k_wmi_main_op_pull_fw_stats(struct ath10k *ar,
+					    struct sk_buff *skb,
+					    struct ath10k_fw_stats *stats)
 {
 	const struct wmi_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
@@ -1565,9 +1555,9 @@ static int ath10k_wmi_main_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
-static int ath10k_wmi_10x_pull_fw_stats(struct ath10k *ar,
-					struct sk_buff *skb,
-					struct ath10k_fw_stats *stats)
+static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
+					   struct sk_buff *skb,
+					   struct ath10k_fw_stats *stats)
 {
 	const struct wmi_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
@@ -1628,15 +1618,6 @@ static int ath10k_wmi_10x_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
-int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
-			     struct ath10k_fw_stats *stats)
-{
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-		return ath10k_wmi_10x_pull_fw_stats(ar, skb, stats);
-	else
-		return ath10k_wmi_main_pull_fw_stats(ar, skb, stats);
-}
-
 static void ath10k_wmi_event_update_stats(struct ath10k *ar,
 					  struct sk_buff *skb)
 {
@@ -1644,8 +1625,9 @@ static void ath10k_wmi_event_update_stats(struct ath10k *ar,
 	ath10k_debug_fw_stats_process(ar, skb);
 }
 
-static int ath10k_wmi_pull_vdev_start_ev(struct sk_buff *skb,
-					 struct wmi_vdev_start_ev_arg *arg)
+static int
+ath10k_wmi_op_pull_vdev_start_ev(struct ath10k *ar, struct sk_buff *skb,
+				 struct wmi_vdev_start_ev_arg *arg)
 {
 	struct wmi_vdev_start_response_event *ev = (void *)skb->data;
 
@@ -1669,7 +1651,7 @@ static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_START_RESP_EVENTID\n");
 
-	ret = ath10k_wmi_pull_vdev_start_ev(skb, &arg);
+	ret = ath10k_wmi_pull_vdev_start(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse vdev start event: %d\n", ret);
 		return;
@@ -1688,8 +1670,9 @@ static void ath10k_wmi_event_vdev_stopped(struct ath10k *ar,
 	complete(&ar->vdev_setup_done);
 }
 
-static int ath10k_wmi_pull_peer_kick_ev(struct sk_buff *skb,
-					struct wmi_peer_kick_ev_arg *arg)
+static int
+ath10k_wmi_op_pull_peer_kick_ev(struct ath10k *ar, struct sk_buff *skb,
+				struct wmi_peer_kick_ev_arg *arg)
 {
 	struct wmi_peer_sta_kickout_event *ev = (void *)skb->data;
 
@@ -1709,7 +1692,7 @@ static void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar,
 	struct ieee80211_sta *sta;
 	int ret;
 
-	ret = ath10k_wmi_pull_peer_kick_ev(skb, &arg);
+	ret = ath10k_wmi_pull_peer_kick(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse peer kickout event: %d\n",
 			    ret);
@@ -1951,8 +1934,8 @@ cleanup:
 	kfree(old_data);
 }
 
-static int ath10k_wmi_pull_swba_ev(struct sk_buff *skb,
-				   struct wmi_swba_ev_arg *arg)
+static int ath10k_wmi_op_pull_swba_ev(struct ath10k *ar, struct sk_buff *skb,
+				      struct wmi_swba_ev_arg *arg)
 {
 	struct wmi_host_swba_event *ev = (void *)skb->data;
 	u32 map;
@@ -1994,7 +1977,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 	dma_addr_t paddr;
 	int ret, vdev_id = 0;
 
-	ret = ath10k_wmi_pull_swba_ev(skb, &arg);
+	ret = ath10k_wmi_pull_swba(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse swba event: %d\n", ret);
 		return;
@@ -2345,8 +2328,8 @@ ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 	}
 }
 
-static int ath10k_wmi_pull_phyerr_ev(struct sk_buff *skb,
-				     struct wmi_phyerr_ev_arg *arg)
+static int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar, struct sk_buff *skb,
+					struct wmi_phyerr_ev_arg *arg)
 {
 	struct wmi_phyerr_event *ev = (void *)skb->data;
 
@@ -2372,7 +2355,7 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 
 	ATH10K_DFS_STAT_INC(ar, phy_errors);
 
-	ret = ath10k_wmi_pull_phyerr_ev(skb, &arg);
+	ret = ath10k_wmi_pull_phyerr(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse phyerr event: %d\n", ret);
 		return;
@@ -2608,8 +2591,9 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	return 0;
 }
 
-static int ath10k_wmi_main_pull_svc_rdy_ev(struct sk_buff *skb,
-					   struct wmi_svc_rdy_ev_arg *arg)
+static int
+ath10k_wmi_main_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
+				   struct wmi_svc_rdy_ev_arg *arg)
 {
 	struct wmi_service_ready_event *ev;
 	size_t i, n;
@@ -2644,8 +2628,9 @@ static int ath10k_wmi_main_pull_svc_rdy_ev(struct sk_buff *skb,
 	return 0;
 }
 
-static int ath10k_wmi_10x_pull_svc_rdy_ev(struct sk_buff *skb,
-					  struct wmi_svc_rdy_ev_arg *arg)
+static int
+ath10k_wmi_10x_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
+				  struct wmi_svc_rdy_ev_arg *arg)
 {
 	struct wmi_10x_service_ready_event *ev;
 	int i, n;
@@ -2686,23 +2671,16 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
 	int ret;
 
-	memset(&ar->wmi.svc_map, 0, sizeof(ar->wmi.svc_map));
-
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
-		wmi_10x_svc_map(arg.service_map, ar->wmi.svc_map,
-				arg.service_map_len);
-	} else {
-		ret = ath10k_wmi_main_pull_svc_rdy_ev(skb, &arg);
-		wmi_main_svc_map(arg.service_map, ar->wmi.svc_map,
-				 arg.service_map_len);
-	}
-
+	ret = ath10k_wmi_pull_svc_rdy(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse service ready: %d\n", ret);
 		return;
 	}
 
+	memset(&ar->wmi.svc_map, 0, sizeof(ar->wmi.svc_map));
+	ath10k_wmi_map_svc(ar, arg.service_map, ar->wmi.svc_map,
+			   arg.service_map_len);
+
 	ar->hw_min_tx_power = __le32_to_cpu(arg.min_tx_power);
 	ar->hw_max_tx_power = __le32_to_cpu(arg.max_tx_power);
 	ar->ht_cap_info = __le32_to_cpu(arg.ht_cap);
@@ -2795,8 +2773,8 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
 	complete(&ar->wmi.service_ready);
 }
 
-static int ath10k_wmi_pull_rdy_ev(struct sk_buff *skb,
-				  struct wmi_rdy_ev_arg *arg)
+static int ath10k_wmi_op_pull_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
+				     struct wmi_rdy_ev_arg *arg)
 {
 	struct wmi_ready_event *ev = (void *)skb->data;
 
@@ -2817,7 +2795,7 @@ static int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 	struct wmi_rdy_ev_arg arg = {};
 	int ret;
 
-	ret = ath10k_wmi_pull_rdy_ev(skb, &arg);
+	ret = ath10k_wmi_pull_rdy(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse ready event: %d\n", ret);
 		return ret;
@@ -2835,7 +2813,7 @@ static int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_event_id id;
@@ -2951,7 +2929,7 @@ static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 
-static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10x_event_id id;
@@ -3075,7 +3053,7 @@ out:
 	dev_kfree_skb(skb);
 }
 
-static void ath10k_wmi_10_2_process_rx(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10_2_event_id id;
@@ -3194,14 +3172,11 @@ static void ath10k_wmi_10_2_process_rx(struct ath10k *ar, struct sk_buff *skb)
 
 static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
-			ath10k_wmi_10_2_process_rx(ar, skb);
-		else
-			ath10k_wmi_10x_process_rx(ar, skb);
-	} else {
-		ath10k_wmi_main_process_rx(ar, skb);
-	}
+	int ret;
+
+	ret = ath10k_wmi_rx(ar, skb);
+	if (ret)
+		ath10k_warn(ar, "failed to process wmi rx: %d\n", ret);
 }
 
 int ath10k_wmi_connect(struct ath10k *ar)
@@ -3232,16 +3207,17 @@ int ath10k_wmi_connect(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_wmi_main_pdev_set_regdomain(struct ath10k *ar, u16 rd,
-					      u16 rd2g, u16 rd5g, u16 ctl2g,
-					      u16 ctl5g)
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_set_rd(struct ath10k *ar, u16 rd, u16 rd2g, u16 rd5g,
+			      u16 ctl2g, u16 ctl5g,
+			      enum wmi_dfs_region dfs_reg)
 {
 	struct wmi_pdev_set_regdomain_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_pdev_set_regdomain_cmd *)skb->data;
 	cmd->reg_domain = __cpu_to_le32(rd);
@@ -3253,22 +3229,20 @@ static int ath10k_wmi_main_pdev_set_regdomain(struct ath10k *ar, u16 rd,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi pdev regdomain rd %x rd2g %x rd5g %x ctl2g %x ctl5g %x\n",
 		   rd, rd2g, rd5g, ctl2g, ctl5g);
-
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->pdev_set_regdomain_cmdid);
+	return skb;
 }
 
-static int ath10k_wmi_10x_pdev_set_regdomain(struct ath10k *ar, u16 rd,
-					     u16 rd2g, u16 rd5g,
-					     u16 ctl2g, u16 ctl5g,
-					     enum wmi_dfs_region dfs_reg)
+static struct sk_buff *
+ath10k_wmi_10x_op_gen_pdev_set_rd(struct ath10k *ar, u16 rd, u16 rd2g, u16
+				  rd5g, u16 ctl2g, u16 ctl5g,
+				  enum wmi_dfs_region dfs_reg)
 {
 	struct wmi_pdev_set_regdomain_cmd_10x *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_pdev_set_regdomain_cmd_10x *)skb->data;
 	cmd->reg_domain = __cpu_to_le32(rd);
@@ -3281,50 +3255,39 @@ static int ath10k_wmi_10x_pdev_set_regdomain(struct ath10k *ar, u16 rd,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi pdev regdomain rd %x rd2g %x rd5g %x ctl2g %x ctl5g %x dfs_region %x\n",
 		   rd, rd2g, rd5g, ctl2g, ctl5g, dfs_reg);
-
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->pdev_set_regdomain_cmdid);
-}
-
-int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
-				  u16 rd5g, u16 ctl2g, u16 ctl5g,
-				  enum wmi_dfs_region dfs_reg)
-{
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-		return ath10k_wmi_10x_pdev_set_regdomain(ar, rd, rd2g, rd5g,
-							ctl2g, ctl5g, dfs_reg);
-	else
-		return ath10k_wmi_main_pdev_set_regdomain(ar, rd, rd2g, rd5g,
-							 ctl2g, ctl5g);
+	return skb;
 }
 
-int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt)
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_suspend(struct ath10k *ar, u32 suspend_opt)
 {
 	struct wmi_pdev_suspend_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_pdev_suspend_cmd *)skb->data;
 	cmd->suspend_opt = __cpu_to_le32(suspend_opt);
 
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_suspend_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_resume(struct ath10k *ar)
 {
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, 0);
-	if (skb == NULL)
-		return -ENOMEM;
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
 
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_resume_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 {
 	struct wmi_pdev_set_param_cmd *cmd;
 	struct sk_buff *skb;
@@ -3332,12 +3295,12 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 	if (id == WMI_PDEV_PARAM_UNSUPPORTED) {
 		ath10k_warn(ar, "pdev param %d not supported by firmware\n",
 			    id);
-		return -EOPNOTSUPP;
+		return ERR_PTR(-EOPNOTSUPP);
 	}
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_pdev_set_param_cmd *)skb->data;
 	cmd->param_id    = __cpu_to_le32(id);
@@ -3345,7 +3308,7 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi pdev set param %d value %d\n",
 		   id, value);
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_set_param_cmdid);
+	return skb;
 }
 
 static void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
@@ -3370,7 +3333,7 @@ static void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
 	}
 }
 
-static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
+static struct sk_buff *ath10k_wmi_op_gen_init(struct ath10k *ar)
 {
 	struct wmi_init_cmd *cmd;
 	struct sk_buff *buf;
@@ -3433,7 +3396,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 
 	buf = ath10k_wmi_alloc_skb(ar, len);
 	if (!buf)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_init_cmd *)buf->data;
 
@@ -3441,10 +3404,10 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 	ath10k_wmi_put_host_mem_chunks(ar, &cmd->mem_chunks);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init\n");
-	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
+	return buf;
 }
 
-static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
+static struct sk_buff *ath10k_wmi_10_1_op_gen_init(struct ath10k *ar)
 {
 	struct wmi_init_cmd_10x *cmd;
 	struct sk_buff *buf;
@@ -3499,7 +3462,7 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 
 	buf = ath10k_wmi_alloc_skb(ar, len);
 	if (!buf)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_init_cmd_10x *)buf->data;
 
@@ -3507,10 +3470,10 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 	ath10k_wmi_put_host_mem_chunks(ar, &cmd->mem_chunks);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init 10x\n");
-	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
+	return buf;
 }
 
-static int ath10k_wmi_10_2_cmd_init(struct ath10k *ar)
+static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 {
 	struct wmi_init_cmd_10_2 *cmd;
 	struct sk_buff *buf;
@@ -3565,7 +3528,7 @@ static int ath10k_wmi_10_2_cmd_init(struct ath10k *ar)
 
 	buf = ath10k_wmi_alloc_skb(ar, len);
 	if (!buf)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
@@ -3573,23 +3536,7 @@ static int ath10k_wmi_10_2_cmd_init(struct ath10k *ar)
 	ath10k_wmi_put_host_mem_chunks(ar, &cmd->mem_chunks);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init 10.2\n");
-	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
-}
-
-int ath10k_wmi_cmd_init(struct ath10k *ar)
-{
-	int ret;
-
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
-			ret = ath10k_wmi_10_2_cmd_init(ar);
-		else
-			ret = ath10k_wmi_10x_cmd_init(ar);
-	} else {
-		ret = ath10k_wmi_main_cmd_init(ar);
-	}
-
-	return ret;
+	return buf;
 }
 
 static int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
@@ -3739,46 +3686,60 @@ ath10k_wmi_put_start_scan_tlvs(struct wmi_start_scan_tlvs *tlvs,
 	}
 }
 
-int ath10k_wmi_start_scan(struct ath10k *ar,
-			  const struct wmi_start_scan_arg *arg)
+static struct sk_buff *
+ath10k_wmi_op_gen_start_scan(struct ath10k *ar,
+			     const struct wmi_start_scan_arg *arg)
 {
+	struct wmi_start_scan_cmd *cmd;
 	struct sk_buff *skb;
 	size_t len;
 	int ret;
 
 	ret = ath10k_wmi_start_scan_verify(arg);
 	if (ret)
-		return ret;
-
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-		len = sizeof(struct wmi_10x_start_scan_cmd) +
-		      ath10k_wmi_start_scan_tlvs_len(arg);
-	else
-		len = sizeof(struct wmi_start_scan_cmd) +
-		      ath10k_wmi_start_scan_tlvs_len(arg);
+		return ERR_PTR(ret);
 
+	len = sizeof(*cmd) + ath10k_wmi_start_scan_tlvs_len(arg);
 	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
-		return -ENOMEM;
-
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		struct wmi_10x_start_scan_cmd *cmd;
+		return ERR_PTR(-ENOMEM);
 
-		cmd = (struct wmi_10x_start_scan_cmd *)skb->data;
-		ath10k_wmi_put_start_scan_common(&cmd->common, arg);
-		ath10k_wmi_put_start_scan_tlvs(&cmd->tlvs, arg);
-	} else {
-		struct wmi_start_scan_cmd *cmd;
+	cmd = (struct wmi_start_scan_cmd *)skb->data;
 
-		cmd = (struct wmi_start_scan_cmd *)skb->data;
-		cmd->burst_duration_ms = __cpu_to_le32(0);
+	ath10k_wmi_put_start_scan_common(&cmd->common, arg);
+	ath10k_wmi_put_start_scan_tlvs(&cmd->tlvs, arg);
 
-		ath10k_wmi_put_start_scan_common(&cmd->common, arg);
-		ath10k_wmi_put_start_scan_tlvs(&cmd->tlvs, arg);
-	}
+	cmd->burst_duration_ms = __cpu_to_le32(0);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi start scan\n");
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->start_scan_cmdid);
+	return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_10x_op_gen_start_scan(struct ath10k *ar,
+				 const struct wmi_start_scan_arg *arg)
+{
+	struct wmi_10x_start_scan_cmd *cmd;
+	struct sk_buff *skb;
+	size_t len;
+	int ret;
+
+	ret = ath10k_wmi_start_scan_verify(arg);
+	if (ret)
+		return ERR_PTR(ret);
+
+	len = sizeof(*cmd) + ath10k_wmi_start_scan_tlvs_len(arg);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_10x_start_scan_cmd *)skb->data;
+
+	ath10k_wmi_put_start_scan_common(&cmd->common, arg);
+	ath10k_wmi_put_start_scan_tlvs(&cmd->tlvs, arg);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi 10x start scan\n");
+	return skb;
 }
 
 void ath10k_wmi_start_scan_init(struct ath10k *ar,
@@ -3807,7 +3768,9 @@ void ath10k_wmi_start_scan_init(struct ath10k *ar,
 	arg->bssids[0].bssid = "\xFF\xFF\xFF\xFF\xFF\xFF";
 }
 
-int ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
+static struct sk_buff *
+ath10k_wmi_op_gen_stop_scan(struct ath10k *ar,
+			    const struct wmi_stop_scan_arg *arg)
 {
 	struct wmi_stop_scan_cmd *cmd;
 	struct sk_buff *skb;
@@ -3815,13 +3778,13 @@ int ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
 	u32 req_id;
 
 	if (arg->req_id > 0xFFF)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	if (arg->req_type == WMI_SCAN_STOP_ONE && arg->u.scan_id > 0xFFF)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	scan_id = arg->u.scan_id;
 	scan_id |= WMI_HOST_SCAN_REQ_ID_PREFIX;
@@ -3838,20 +3801,21 @@ int ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi stop scan reqid %d req_type %d vdev/scan_id %d\n",
 		   arg->req_id, arg->req_type, arg->u.scan_id);
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->stop_scan_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
-			   enum wmi_vdev_type type,
-			   enum wmi_vdev_subtype subtype,
-			   const u8 macaddr[ETH_ALEN])
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_create(struct ath10k *ar, u32 vdev_id,
+			      enum wmi_vdev_type type,
+			      enum wmi_vdev_subtype subtype,
+			      const u8 macaddr[ETH_ALEN])
 {
 	struct wmi_vdev_create_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_create_cmd *)skb->data;
 	cmd->vdev_id      = __cpu_to_le32(vdev_id);
@@ -3862,58 +3826,52 @@ int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "WMI vdev create: id %d type %d subtype %d macaddr %pM\n",
 		   vdev_id, type, subtype, macaddr);
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_create_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_delete(struct ath10k *ar, u32 vdev_id)
 {
 	struct wmi_vdev_delete_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_delete_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "WMI vdev delete id %d\n", vdev_id);
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_delete_cmdid);
+	return skb;
 }
 
-static int
-ath10k_wmi_vdev_start_restart(struct ath10k *ar,
-			      const struct wmi_vdev_start_request_arg *arg,
-			      u32 cmd_id)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_start(struct ath10k *ar,
+			     const struct wmi_vdev_start_request_arg *arg,
+			     bool restart)
 {
 	struct wmi_vdev_start_request_cmd *cmd;
 	struct sk_buff *skb;
 	const char *cmdname;
 	u32 flags = 0;
 
-	if (cmd_id != ar->wmi.cmd->vdev_start_request_cmdid &&
-	    cmd_id != ar->wmi.cmd->vdev_restart_request_cmdid)
-		return -EINVAL;
 	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
-	if (cmd_id == ar->wmi.cmd->vdev_start_request_cmdid)
-		cmdname = "start";
-	else if (cmd_id == ar->wmi.cmd->vdev_restart_request_cmdid)
+	if (restart)
 		cmdname = "restart";
 	else
-		return -EINVAL; /* should not happen, we already check cmd_id */
+		cmdname = "start";
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (arg->hidden_ssid)
 		flags |= WMI_VDEV_START_HIDDEN_SSID;
@@ -3942,50 +3900,36 @@ ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 		   flags, arg->channel.freq, arg->channel.mode,
 		   cmd->chan.flags, arg->channel.max_power);
 
-	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
-}
-
-int ath10k_wmi_vdev_start(struct ath10k *ar,
-			  const struct wmi_vdev_start_request_arg *arg)
-{
-	u32 cmd_id = ar->wmi.cmd->vdev_start_request_cmdid;
-
-	return ath10k_wmi_vdev_start_restart(ar, arg, cmd_id);
-}
-
-int ath10k_wmi_vdev_restart(struct ath10k *ar,
-			    const struct wmi_vdev_start_request_arg *arg)
-{
-	u32 cmd_id = ar->wmi.cmd->vdev_restart_request_cmdid;
-
-	return ath10k_wmi_vdev_start_restart(ar, arg, cmd_id);
+	return skb;
 }
 
-int ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_stop(struct ath10k *ar, u32 vdev_id)
 {
 	struct wmi_vdev_stop_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_stop_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi vdev stop id 0x%x\n", vdev_id);
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_stop_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid,
+			  const u8 *bssid)
 {
 	struct wmi_vdev_up_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_up_cmd *)skb->data;
 	cmd->vdev_id       = __cpu_to_le32(vdev_id);
@@ -3995,30 +3939,30 @@ int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi mgmt vdev up id 0x%x assoc id %d bssid %pM\n",
 		   vdev_id, aid, bssid);
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_up_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_down(struct ath10k *ar, u32 vdev_id)
 {
 	struct wmi_vdev_down_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_down_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi mgmt vdev down id 0x%x\n", vdev_id);
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_down_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
-			      u32 param_id, u32 param_value)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_set_param(struct ath10k *ar, u32 vdev_id,
+				 u32 param_id, u32 param_value)
 {
 	struct wmi_vdev_set_param_cmd *cmd;
 	struct sk_buff *skb;
@@ -4027,12 +3971,12 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "vdev param %d not supported by firmware\n",
 			    param_id);
-		return -EOPNOTSUPP;
+		return ERR_PTR(-EOPNOTSUPP);
 	}
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_set_param_cmd *)skb->data;
 	cmd->vdev_id     = __cpu_to_le32(vdev_id);
@@ -4042,24 +3986,24 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev id 0x%x set param %d value %d\n",
 		   vdev_id, param_id, param_value);
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_set_param_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_install_key(struct ath10k *ar,
-				const struct wmi_vdev_install_key_arg *arg)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_install_key(struct ath10k *ar,
+				   const struct wmi_vdev_install_key_arg *arg)
 {
 	struct wmi_vdev_install_key_cmd *cmd;
 	struct sk_buff *skb;
 
 	if (arg->key_cipher == WMI_CIPHER_NONE && arg->key_data != NULL)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	if (arg->key_cipher != WMI_CIPHER_NONE && arg->key_data == NULL)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd) + arg->key_len);
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_install_key_cmd *)skb->data;
 	cmd->vdev_id       = __cpu_to_le32(arg->vdev_id);
@@ -4078,20 +4022,19 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev install key idx %d cipher %d len %d\n",
 		   arg->key_idx, arg->key_cipher, arg->key_len);
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->vdev_install_key_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
-				  const struct wmi_vdev_spectral_conf_arg *arg)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_spectral_conf(struct ath10k *ar,
+				     const struct wmi_vdev_spectral_conf_arg *arg)
 {
 	struct wmi_vdev_spectral_conf_cmd *cmd;
 	struct sk_buff *skb;
-	u32 cmdid;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_spectral_conf_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(arg->vdev_id);
@@ -4114,39 +4057,38 @@ int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
 	cmd->scan_dbm_adj = __cpu_to_le32(arg->scan_dbm_adj);
 	cmd->scan_chn_mask = __cpu_to_le32(arg->scan_chn_mask);
 
-	cmdid = ar->wmi.cmd->vdev_spectral_scan_configure_cmdid;
-	return ath10k_wmi_cmd_send(ar, skb, cmdid);
+	return skb;
 }
 
-int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
-				    u32 enable)
+static struct sk_buff *
+ath10k_wmi_op_gen_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id,
+				       u32 trigger, u32 enable)
 {
 	struct wmi_vdev_spectral_enable_cmd *cmd;
 	struct sk_buff *skb;
-	u32 cmdid;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_vdev_spectral_enable_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 	cmd->trigger_cmd = __cpu_to_le32(trigger);
 	cmd->enable_cmd = __cpu_to_le32(enable);
 
-	cmdid = ar->wmi.cmd->vdev_spectral_scan_enable_cmdid;
-	return ath10k_wmi_cmd_send(ar, skb, cmdid);
+	return skb;
 }
 
-int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
-			   const u8 peer_addr[ETH_ALEN])
+static struct sk_buff *
+ath10k_wmi_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
+			      const u8 peer_addr[ETH_ALEN])
 {
 	struct wmi_peer_create_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_peer_create_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
@@ -4155,18 +4097,19 @@ int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer create vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_create_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
-			   const u8 peer_addr[ETH_ALEN])
+static struct sk_buff *
+ath10k_wmi_op_gen_peer_delete(struct ath10k *ar, u32 vdev_id,
+			      const u8 peer_addr[ETH_ALEN])
 {
 	struct wmi_peer_delete_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_peer_delete_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
@@ -4175,18 +4118,19 @@ int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer delete vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_delete_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
-			  const u8 peer_addr[ETH_ALEN], u32 tid_bitmap)
+static struct sk_buff *
+ath10k_wmi_op_gen_peer_flush(struct ath10k *ar, u32 vdev_id,
+			     const u8 peer_addr[ETH_ALEN], u32 tid_bitmap)
 {
 	struct wmi_peer_flush_tids_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_peer_flush_tids_cmd *)skb->data;
 	cmd->vdev_id         = __cpu_to_le32(vdev_id);
@@ -4196,19 +4140,21 @@ int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer flush vdev_id %d peer_addr %pM tids %08x\n",
 		   vdev_id, peer_addr, tid_bitmap);
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_flush_tids_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
-			      const u8 *peer_addr, enum wmi_peer_param param_id,
-			      u32 param_value)
+static struct sk_buff *
+ath10k_wmi_op_gen_peer_set_param(struct ath10k *ar, u32 vdev_id,
+				 const u8 *peer_addr,
+				 enum wmi_peer_param param_id,
+				 u32 param_value)
 {
 	struct wmi_peer_set_param_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_peer_set_param_cmd *)skb->data;
 	cmd->vdev_id     = __cpu_to_le32(vdev_id);
@@ -4219,19 +4165,19 @@ int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev %d peer 0x%pM set param %d value %d\n",
 		   vdev_id, peer_addr, param_id, param_value);
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_set_param_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
-			  enum wmi_sta_ps_mode psmode)
+static struct sk_buff *
+ath10k_wmi_op_gen_set_psmode(struct ath10k *ar, u32 vdev_id,
+			     enum wmi_sta_ps_mode psmode)
 {
 	struct wmi_sta_powersave_mode_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_sta_powersave_mode_cmd *)skb->data;
 	cmd->vdev_id     = __cpu_to_le32(vdev_id);
@@ -4240,21 +4186,20 @@ int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi set powersave id 0x%x mode %d\n",
 		   vdev_id, psmode);
-
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->sta_powersave_mode_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
-				enum wmi_sta_powersave_param param_id,
-				u32 value)
+static struct sk_buff *
+ath10k_wmi_op_gen_set_sta_ps(struct ath10k *ar, u32 vdev_id,
+			     enum wmi_sta_powersave_param param_id,
+			     u32 value)
 {
 	struct wmi_sta_powersave_param_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_sta_powersave_param_cmd *)skb->data;
 	cmd->vdev_id     = __cpu_to_le32(vdev_id);
@@ -4264,22 +4209,22 @@ int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi sta ps param vdev_id 0x%x param %d value %d\n",
 		   vdev_id, param_id, value);
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->sta_powersave_param_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
-			       enum wmi_ap_ps_peer_param param_id, u32 value)
+static struct sk_buff *
+ath10k_wmi_op_gen_set_ap_ps(struct ath10k *ar, u32 vdev_id, const u8 *mac,
+			    enum wmi_ap_ps_peer_param param_id, u32 value)
 {
 	struct wmi_ap_ps_peer_cmd *cmd;
 	struct sk_buff *skb;
 
 	if (!mac)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_ap_ps_peer_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
@@ -4290,13 +4235,12 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi ap ps param vdev_id 0x%X param %d value %d mac_addr %pM\n",
 		   vdev_id, param_id, value, mac);
-
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->ap_ps_peer_param_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_scan_chan_list(struct ath10k *ar,
-			      const struct wmi_scan_chan_list_arg *arg)
+static struct sk_buff *
+ath10k_wmi_op_gen_scan_chan_list(struct ath10k *ar,
+				 const struct wmi_scan_chan_list_arg *arg)
 {
 	struct wmi_scan_chan_list_cmd *cmd;
 	struct sk_buff *skb;
@@ -4309,7 +4253,7 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 
 	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	cmd = (struct wmi_scan_chan_list_cmd *)skb->data;
 	cmd->num_scan_chans = __cpu_to_le32(arg->n_channels);
@@ -4321,7 +4265,7 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 		ath10k_wmi_put_wmi_channel(ci, ch);
 	}
 
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->scan_chan_list_cmdid);
+	return skb;
 }
 
 static void
@@ -4402,12 +4346,9 @@ ath10k_wmi_peer_assoc_fill_10_2(struct ath10k *ar, void *buf,
 	cmd->info0 = __cpu_to_le32(info0);
 }
 
-int ath10k_wmi_peer_assoc(struct ath10k *ar,
-			  const struct wmi_peer_assoc_complete_arg *arg)
+static int
+ath10k_wmi_peer_assoc_check_arg(const struct wmi_peer_assoc_complete_arg *arg)
 {
-	struct sk_buff *skb;
-	int len;
-
 	if (arg->peer_mpdu_density > 16)
 		return -EINVAL;
 	if (arg->peer_legacy_rates.num_rates > MAX_SUPPORTED_RATES)
@@ -4415,49 +4356,98 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 	if (arg->peer_ht_rates.num_rates > MAX_SUPPORTED_RATES)
 		return -EINVAL;
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
-			len = sizeof(struct wmi_10_2_peer_assoc_complete_cmd);
-		else
-			len = sizeof(struct wmi_10_1_peer_assoc_complete_cmd);
-	} else {
-		len = sizeof(struct wmi_main_peer_assoc_complete_cmd);
-	}
+	return 0;
+}
+
+static struct sk_buff *
+ath10k_wmi_op_gen_peer_assoc(struct ath10k *ar,
+			     const struct wmi_peer_assoc_complete_arg *arg)
+{
+	size_t len = sizeof(struct wmi_main_peer_assoc_complete_cmd);
+	struct sk_buff *skb;
+	int ret;
+
+	ret = ath10k_wmi_peer_assoc_check_arg(arg);
+	if (ret)
+		return ERR_PTR(ret);
 
 	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
-			ath10k_wmi_peer_assoc_fill_10_2(ar, skb->data, arg);
-		else
-			ath10k_wmi_peer_assoc_fill_10_1(ar, skb->data, arg);
-	} else {
-		ath10k_wmi_peer_assoc_fill_main(ar, skb->data, arg);
-	}
+	ath10k_wmi_peer_assoc_fill_main(ar, skb->data, arg);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi peer assoc vdev %d addr %pM (%s)\n",
+		   arg->vdev_id, arg->addr,
+		   arg->peer_reassoc ? "reassociate" : "new");
+	return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_10_1_op_gen_peer_assoc(struct ath10k *ar,
+				  const struct wmi_peer_assoc_complete_arg *arg)
+{
+	size_t len = sizeof(struct wmi_10_1_peer_assoc_complete_cmd);
+	struct sk_buff *skb;
+	int ret;
+
+	ret = ath10k_wmi_peer_assoc_check_arg(arg);
+	if (ret)
+		return ERR_PTR(ret);
+
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ath10k_wmi_peer_assoc_fill_10_1(ar, skb->data, arg);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi peer assoc vdev %d addr %pM (%s)\n",
+		   arg->vdev_id, arg->addr,
+		   arg->peer_reassoc ? "reassociate" : "new");
+	return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_10_2_op_gen_peer_assoc(struct ath10k *ar,
+				  const struct wmi_peer_assoc_complete_arg *arg)
+{
+	size_t len = sizeof(struct wmi_10_2_peer_assoc_complete_cmd);
+	struct sk_buff *skb;
+	int ret;
+
+	ret = ath10k_wmi_peer_assoc_check_arg(arg);
+	if (ret)
+		return ERR_PTR(ret);
+
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ath10k_wmi_peer_assoc_fill_10_2(ar, skb->data, arg);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer assoc vdev %d addr %pM (%s)\n",
 		   arg->vdev_id, arg->addr,
 		   arg->peer_reassoc ? "reassociate" : "new");
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_assoc_cmdid);
+	return skb;
 }
 
 /* This function assumes the beacon is already DMA mapped */
-int ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif)
+static struct sk_buff *
+ath10k_wmi_op_gen_beacon_dma(struct ath10k_vif *arvif)
 {
+	struct ath10k *ar = arvif->ar;
 	struct wmi_bcn_tx_ref_cmd *cmd;
 	struct sk_buff *skb;
 	struct sk_buff *beacon = arvif->beacon;
-	struct ath10k *ar = arvif->ar;
 	struct ieee80211_hdr *hdr;
-	int ret;
 	u16 fc;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	hdr = (struct ieee80211_hdr *)beacon->data;
 	fc = le16_to_cpu(hdr->frame_control);
@@ -4477,13 +4467,7 @@ int ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif)
 	if (ATH10K_SKB_CB(beacon)->bcn.deliver_cab)
 		cmd->flags |= __cpu_to_le32(WMI_BCN_TX_REF_FLAG_DELIVER_CAB);
 
-	ret = ath10k_wmi_cmd_send_nowait(ar, skb,
-					 ar->wmi.cmd->pdev_send_bcn_cmdid);
-
-	if (ret)
-		dev_kfree_skb(skb);
-
-	return ret;
+	return skb;
 }
 
 static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
@@ -4497,15 +4481,16 @@ static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
 	params->no_ack = __cpu_to_le32(arg->no_ack);
 }
 
-int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
-				   const struct wmi_pdev_set_wmm_params_arg *arg)
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_set_wmm(struct ath10k *ar,
+			       const struct wmi_pdev_set_wmm_params_arg *arg)
 {
 	struct wmi_pdev_set_wmm_params *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_pdev_set_wmm_params *)skb->data;
 	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_be, &arg->ac_be);
@@ -4514,35 +4499,36 @@ int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_vo, &arg->ac_vo);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi pdev set wmm params\n");
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->pdev_set_wmm_params_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
+static struct sk_buff *
+ath10k_wmi_op_gen_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
 {
 	struct wmi_request_stats_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_request_stats_cmd *)skb->data;
 	cmd->stats_id = __cpu_to_le32(stats_id);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi request stats %d\n", (int)stats_id);
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->request_stats_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_force_fw_hang(struct ath10k *ar,
-			     enum wmi_force_fw_hang_type type, u32 delay_ms)
+static struct sk_buff *
+ath10k_wmi_op_gen_force_fw_hang(struct ath10k *ar,
+				enum wmi_force_fw_hang_type type, u32 delay_ms)
 {
 	struct wmi_force_fw_hang_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_force_fw_hang_cmd *)skb->data;
 	cmd->type = __cpu_to_le32(type);
@@ -4550,10 +4536,11 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi force fw hang %d delay %d\n",
 		   type, delay_ms);
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->force_fw_hang_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
+static struct sk_buff *
+ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable)
 {
 	struct wmi_dbglog_cfg_cmd *cmd;
 	struct sk_buff *skb;
@@ -4561,7 +4548,7 @@ int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cmd = (struct wmi_dbglog_cfg_cmd *)skb->data;
 
@@ -4586,50 +4573,208 @@ int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
 		   __le32_to_cpu(cmd->module_valid),
 		   __le32_to_cpu(cmd->config_enable),
 		   __le32_to_cpu(cmd->config_valid));
-
-	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->dbglog_cfg_cmdid);
+	return skb;
 }
 
-int ath10k_wmi_pdev_pktlog_enable(struct ath10k *ar, u32 ev_bitmap)
+static struct sk_buff *
+ath10k_wmi_op_gen_pktlog_enable(struct ath10k *ar, u32 ev_bitmap)
 {
 	struct wmi_pdev_pktlog_enable_cmd *cmd;
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	ev_bitmap &= ATH10K_PKTLOG_ANY;
-	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi enable pktlog filter:%x\n", ev_bitmap);
 
 	cmd = (struct wmi_pdev_pktlog_enable_cmd *)skb->data;
 	cmd->ev_bitmap = __cpu_to_le32(ev_bitmap);
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->pdev_pktlog_enable_cmdid);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi enable pktlog filter 0x%08x\n",
+		   ev_bitmap);
+	return skb;
 }
 
-int ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar)
+static struct sk_buff *
+ath10k_wmi_op_gen_pktlog_disable(struct ath10k *ar)
 {
 	struct sk_buff *skb;
 
 	skb = ath10k_wmi_alloc_skb(ar, 0);
 	if (!skb)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi disable pktlog\n");
-
-	return ath10k_wmi_cmd_send(ar, skb,
-				   ar->wmi.cmd->pdev_pktlog_disable_cmdid);
+	return skb;
 }
 
+static const struct wmi_ops wmi_ops = {
+	.rx = ath10k_wmi_op_rx,
+	.map_svc = wmi_main_svc_map,
+
+	.pull_scan = ath10k_wmi_op_pull_scan_ev,
+	.pull_mgmt_rx = ath10k_wmi_op_pull_mgmt_rx_ev,
+	.pull_ch_info = ath10k_wmi_op_pull_ch_info_ev,
+	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
+	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
+	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
+	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
+	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+	.pull_fw_stats = ath10k_wmi_main_op_pull_fw_stats,
+
+	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
+	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
+	.gen_pdev_set_rd = ath10k_wmi_op_gen_pdev_set_rd,
+	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
+	.gen_init = ath10k_wmi_op_gen_init,
+	.gen_start_scan = ath10k_wmi_op_gen_start_scan,
+	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
+	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
+	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
+	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
+	.gen_vdev_stop = ath10k_wmi_op_gen_vdev_stop,
+	.gen_vdev_up = ath10k_wmi_op_gen_vdev_up,
+	.gen_vdev_down = ath10k_wmi_op_gen_vdev_down,
+	.gen_vdev_set_param = ath10k_wmi_op_gen_vdev_set_param,
+	.gen_vdev_install_key = ath10k_wmi_op_gen_vdev_install_key,
+	.gen_vdev_spectral_conf = ath10k_wmi_op_gen_vdev_spectral_conf,
+	.gen_vdev_spectral_enable = ath10k_wmi_op_gen_vdev_spectral_enable,
+	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
+	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
+	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
+	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
+	.gen_peer_assoc = ath10k_wmi_op_gen_peer_assoc,
+	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
+	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
+	.gen_set_ap_ps = ath10k_wmi_op_gen_set_ap_ps,
+	.gen_scan_chan_list = ath10k_wmi_op_gen_scan_chan_list,
+	.gen_beacon_dma = ath10k_wmi_op_gen_beacon_dma,
+	.gen_pdev_set_wmm = ath10k_wmi_op_gen_pdev_set_wmm,
+	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
+	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
+	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
+	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
+	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
+	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+};
+
+static const struct wmi_ops wmi_10_1_ops = {
+	.rx = ath10k_wmi_10_1_op_rx,
+	.map_svc = wmi_10x_svc_map,
+	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
+	.pull_fw_stats = ath10k_wmi_10x_op_pull_fw_stats,
+	.gen_init = ath10k_wmi_10_1_op_gen_init,
+	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
+	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
+	.gen_peer_assoc = ath10k_wmi_10_1_op_gen_peer_assoc,
+
+	/* shared with main branch */
+	.pull_scan = ath10k_wmi_op_pull_scan_ev,
+	.pull_mgmt_rx = ath10k_wmi_op_pull_mgmt_rx_ev,
+	.pull_ch_info = ath10k_wmi_op_pull_ch_info_ev,
+	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
+	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
+	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
+	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+
+	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
+	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
+	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
+	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
+	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
+	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
+	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
+	.gen_vdev_stop = ath10k_wmi_op_gen_vdev_stop,
+	.gen_vdev_up = ath10k_wmi_op_gen_vdev_up,
+	.gen_vdev_down = ath10k_wmi_op_gen_vdev_down,
+	.gen_vdev_set_param = ath10k_wmi_op_gen_vdev_set_param,
+	.gen_vdev_install_key = ath10k_wmi_op_gen_vdev_install_key,
+	.gen_vdev_spectral_conf = ath10k_wmi_op_gen_vdev_spectral_conf,
+	.gen_vdev_spectral_enable = ath10k_wmi_op_gen_vdev_spectral_enable,
+	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
+	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
+	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
+	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
+	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
+	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
+	.gen_set_ap_ps = ath10k_wmi_op_gen_set_ap_ps,
+	.gen_scan_chan_list = ath10k_wmi_op_gen_scan_chan_list,
+	.gen_beacon_dma = ath10k_wmi_op_gen_beacon_dma,
+	.gen_pdev_set_wmm = ath10k_wmi_op_gen_pdev_set_wmm,
+	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
+	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
+	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
+	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
+	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
+	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+};
+
+static const struct wmi_ops wmi_10_2_ops = {
+	.rx = ath10k_wmi_10_2_op_rx,
+	.gen_init = ath10k_wmi_10_2_op_gen_init,
+	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
+
+	/* shared with 10.1 */
+	.map_svc = wmi_10x_svc_map,
+	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
+	.pull_fw_stats = ath10k_wmi_10x_op_pull_fw_stats,
+	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
+	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
+
+	.pull_scan = ath10k_wmi_op_pull_scan_ev,
+	.pull_mgmt_rx = ath10k_wmi_op_pull_mgmt_rx_ev,
+	.pull_ch_info = ath10k_wmi_op_pull_ch_info_ev,
+	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
+	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
+	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
+	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+
+	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
+	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
+	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
+	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
+	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
+	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
+	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
+	.gen_vdev_stop = ath10k_wmi_op_gen_vdev_stop,
+	.gen_vdev_up = ath10k_wmi_op_gen_vdev_up,
+	.gen_vdev_down = ath10k_wmi_op_gen_vdev_down,
+	.gen_vdev_set_param = ath10k_wmi_op_gen_vdev_set_param,
+	.gen_vdev_install_key = ath10k_wmi_op_gen_vdev_install_key,
+	.gen_vdev_spectral_conf = ath10k_wmi_op_gen_vdev_spectral_conf,
+	.gen_vdev_spectral_enable = ath10k_wmi_op_gen_vdev_spectral_enable,
+	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
+	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
+	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
+	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
+	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
+	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
+	.gen_set_ap_ps = ath10k_wmi_op_gen_set_ap_ps,
+	.gen_scan_chan_list = ath10k_wmi_op_gen_scan_chan_list,
+	.gen_beacon_dma = ath10k_wmi_op_gen_beacon_dma,
+	.gen_pdev_set_wmm = ath10k_wmi_op_gen_pdev_set_wmm,
+	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
+	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
+	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
+	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
+	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
+	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+};
+
 int ath10k_wmi_attach(struct ath10k *ar)
 {
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
+		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features)) {
 			ar->wmi.cmd = &wmi_10_2_cmd_map;
-		else
+			ar->wmi.ops = &wmi_10_2_ops;
+		} else {
 			ar->wmi.cmd = &wmi_10x_cmd_map;
+			ar->wmi.ops = &wmi_10_1_ops;
+		}
 
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
@@ -4637,6 +4782,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.cmd = &wmi_cmd_map;
 		ar->wmi.vdev_param = &wmi_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_pdev_param_map;
+		ar->wmi.ops = &wmi_ops;
 	}
 
 	init_completion(&ar->wmi.service_ready);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0952bc2..b8308f6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4644,7 +4644,6 @@ struct wmi_rdy_ev_arg {
 
 struct ath10k;
 struct ath10k_vif;
-struct ath10k_fw_stats;
 
 int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
@@ -4655,70 +4654,8 @@ int ath10k_wmi_connect(struct ath10k *ar);
 
 struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len);
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
-
-int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt);
-int ath10k_wmi_pdev_resume_target(struct ath10k *ar);
-int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
-				  u16 rd5g, u16 ctl2g, u16 ctl5g,
-				  enum wmi_dfs_region dfs_reg);
-int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value);
-int ath10k_wmi_cmd_init(struct ath10k *ar);
-int ath10k_wmi_start_scan(struct ath10k *ar, const struct wmi_start_scan_arg *);
+int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
+			       u32 cmd_id);
 void ath10k_wmi_start_scan_init(struct ath10k *ar, struct wmi_start_scan_arg *);
-int ath10k_wmi_stop_scan(struct ath10k *ar,
-			 const struct wmi_stop_scan_arg *arg);
-int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
-			   enum wmi_vdev_type type,
-			   enum wmi_vdev_subtype subtype,
-			   const u8 macaddr[ETH_ALEN]);
-int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id);
-int ath10k_wmi_vdev_start(struct ath10k *ar,
-			  const struct wmi_vdev_start_request_arg *);
-int ath10k_wmi_vdev_restart(struct ath10k *ar,
-			    const struct wmi_vdev_start_request_arg *);
-int ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id);
-int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid,
-		       const u8 *bssid);
-int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id);
-int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
-			      u32 param_id, u32 param_value);
-int ath10k_wmi_vdev_install_key(struct ath10k *ar,
-				const struct wmi_vdev_install_key_arg *arg);
-int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
-				  const struct wmi_vdev_spectral_conf_arg *arg);
-int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
-				    u32 enable);
-int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
-			   const u8 peer_addr[ETH_ALEN]);
-int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
-			   const u8 peer_addr[ETH_ALEN]);
-int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
-			  const u8 peer_addr[ETH_ALEN], u32 tid_bitmap);
-int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
-			      const u8 *peer_addr,
-			      enum wmi_peer_param param_id, u32 param_value);
-int ath10k_wmi_peer_assoc(struct ath10k *ar,
-			  const struct wmi_peer_assoc_complete_arg *arg);
-int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
-			  enum wmi_sta_ps_mode psmode);
-int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
-				enum wmi_sta_powersave_param param_id,
-				u32 value);
-int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
-			       enum wmi_ap_ps_peer_param param_id, u32 value);
-int ath10k_wmi_scan_chan_list(struct ath10k *ar,
-			      const struct wmi_scan_chan_list_arg *arg);
-int ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif);
-int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
-				   const struct wmi_pdev_set_wmm_params_arg *arg);
-int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
-int ath10k_wmi_force_fw_hang(struct ath10k *ar,
-			     enum wmi_force_fw_hang_type type, u32 delay_ms);
-int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb);
-int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable);
-int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
-			     struct ath10k_fw_stats *stats);
-int ath10k_wmi_pdev_pktlog_enable(struct ath10k *ar, u32 ev_list);
-int ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar);
 
 #endif /* _WMI_H_ */
-- 
1.8.5.3

