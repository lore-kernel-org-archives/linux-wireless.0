Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30137 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbbHLJ5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 05:57:08 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: refactor phyerr event handlers
Date: Wed, 12 Aug 2015 15:26:35 +0530
Message-ID: <1439373396-10828-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150812_115713_194321_FC867901)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Existing phyerr event handlers directly uses phyerr header format
(ie, struct wmi_phyerr and struct wmi_phyerr_event) in the code
exactly on how firmware packs it. This is the problem in 10.4 fw
specific phyerr event handling where it uses different phyerror
header format. Before adding 10.4 specific handler, little bit of
refactor is done in existing phyerr handlers.

Two new abstracted structures (struct wmi_phyerr_ev_hdr_arg and
struct wmi_phyerr_ev_arg) are introduced to remove dependency of using
firmware specific header format in the code. So that firmware specific
phyerror handlers can populate values to abstracted structures and
the following code can use abstracted struct for further operation.

.pull_phyerr_hdr is added newly to pull common phyerr header info
like tsf, buf_len, number of phyerr packed. Existing .pull_phyerr
handler is changed and called to parse every sub phyerrs in the event.

Validated these refactoring on qca988x hw2.0 using fw 10.2.4 version.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/spectral.c |   9 +--
 drivers/net/wireless/ath/ath10k/spectral.h |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h  |  22 ++++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  |  17 ++--
 drivers/net/wireless/ath/ath10k/wmi.c      | 121 ++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/wmi.h      |  43 +++++++---
 6 files changed, 149 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index 8dcd424..e4219b1 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -57,7 +57,7 @@ static uint8_t get_max_exp(s8 max_index, u16 max_magnitude, size_t bin_len,
 }
 
 int ath10k_spectral_process_fft(struct ath10k *ar,
-				const struct wmi_phyerr *phyerr,
+				struct wmi_phyerr_ev_arg *phyerr,
 				const struct phyerr_fft_report *fftr,
 				size_t bin_len, u64 tsf)
 {
@@ -118,15 +118,14 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 	fft_sample->total_gain_db = __cpu_to_be16(total_gain_db);
 	fft_sample->base_pwr_db = __cpu_to_be16(base_pwr_db);
 
-	freq1 = __le16_to_cpu(phyerr->freq1);
-	freq2 = __le16_to_cpu(phyerr->freq2);
+	freq1 = phyerr->freq1;
+	freq2 = phyerr->freq2;
 	fft_sample->freq1 = __cpu_to_be16(freq1);
 	fft_sample->freq2 = __cpu_to_be16(freq2);
 
 	chain_idx = MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX);
 
-	fft_sample->noise = __cpu_to_be16(
-			__le16_to_cpu(phyerr->nf_chains[chain_idx]));
+	fft_sample->noise = __cpu_to_be16(phyerr->nf_chains[chain_idx]);
 
 	bins = (u8 *)fftr;
 	bins += sizeof(*fftr);
diff --git a/drivers/net/wireless/ath/ath10k/spectral.h b/drivers/net/wireless/ath/ath10k/spectral.h
index 042f5b3..89b0ad7 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.h
+++ b/drivers/net/wireless/ath/ath10k/spectral.h
@@ -47,7 +47,7 @@ enum ath10k_spectral_mode {
 #ifdef CONFIG_ATH10K_DEBUGFS
 
 int ath10k_spectral_process_fft(struct ath10k *ar,
-				const struct wmi_phyerr *phyerr,
+				struct wmi_phyerr_ev_arg *phyerr,
 				const struct phyerr_fft_report *fftr,
 				size_t bin_len, u64 tsf);
 int ath10k_spectral_start(struct ath10k *ar);
@@ -59,7 +59,7 @@ void ath10k_spectral_destroy(struct ath10k *ar);
 
 static inline int
 ath10k_spectral_process_fft(struct ath10k *ar,
-			    const struct wmi_phyerr *phyerr,
+			    struct wmi_phyerr_ev_arg *phyerr,
 			    const struct phyerr_fft_report *fftr,
 			    size_t bin_len, u64 tsf)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 47fe2e7..01629c9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -37,8 +37,10 @@ struct wmi_ops {
 			      struct wmi_peer_kick_ev_arg *arg);
 	int (*pull_swba)(struct ath10k *ar, struct sk_buff *skb,
 			 struct wmi_swba_ev_arg *arg);
-	int (*pull_phyerr)(struct ath10k *ar, struct sk_buff *skb,
-			   struct wmi_phyerr_ev_arg *arg);
+	int (*pull_phyerr_hdr)(struct ath10k *ar, struct sk_buff *skb,
+			       struct wmi_phyerr_hdr_arg *arg);
+	int (*pull_phyerr)(struct ath10k *ar, const void *phyerr_buf,
+			   int left_len, struct wmi_phyerr_ev_arg *arg);
 	int (*pull_svc_rdy)(struct ath10k *ar, struct sk_buff *skb,
 			    struct wmi_svc_rdy_ev_arg *arg);
 	int (*pull_rdy)(struct ath10k *ar, struct sk_buff *skb,
@@ -260,13 +262,23 @@ ath10k_wmi_pull_swba(struct ath10k *ar, struct sk_buff *skb,
 }
 
 static inline int
-ath10k_wmi_pull_phyerr(struct ath10k *ar, struct sk_buff *skb,
-		       struct wmi_phyerr_ev_arg *arg)
+ath10k_wmi_pull_phyerr_hdr(struct ath10k *ar, struct sk_buff *skb,
+			   struct wmi_phyerr_hdr_arg *arg)
+{
+	if (!ar->wmi.ops->pull_phyerr_hdr)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_phyerr_hdr(ar, skb, arg);
+}
+
+static inline int
+ath10k_wmi_pull_phyerr(struct ath10k *ar, const void *phyerr_buf,
+		       int left_len, struct wmi_phyerr_ev_arg *arg)
 {
 	if (!ar->wmi.ops->pull_phyerr)
 		return -EOPNOTSUPP;
 
-	return ar->wmi.ops->pull_phyerr(ar, skb, arg);
+	return ar->wmi.ops->pull_phyerr(ar, phyerr_buf, left_len, arg);
 }
 
 static inline int
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 567b797..64e2a70 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -838,9 +838,9 @@ static int ath10k_wmi_tlv_op_pull_swba_ev(struct ath10k *ar,
 	return 0;
 }
 
-static int ath10k_wmi_tlv_op_pull_phyerr_ev(struct ath10k *ar,
-					    struct sk_buff *skb,
-					    struct wmi_phyerr_ev_arg *arg)
+static int ath10k_wmi_tlv_op_pull_phyerr_ev_hdr(struct ath10k *ar,
+						struct sk_buff *skb,
+						struct wmi_phyerr_hdr_arg *arg)
 {
 	const void **tb;
 	const struct wmi_tlv_phyerr_ev *ev;
@@ -862,10 +862,10 @@ static int ath10k_wmi_tlv_op_pull_phyerr_ev(struct ath10k *ar,
 		return -EPROTO;
 	}
 
-	arg->num_phyerrs  = ev->num_phyerrs;
-	arg->tsf_l32 = ev->tsf_l32;
-	arg->tsf_u32 = ev->tsf_u32;
-	arg->buf_len = ev->buf_len;
+	arg->num_phyerrs  = __le32_to_cpu(ev->num_phyerrs);
+	arg->tsf_l32 = __le32_to_cpu(ev->tsf_l32);
+	arg->tsf_u32 = __le32_to_cpu(ev->tsf_u32);
+	arg->buf_len = __le32_to_cpu(ev->buf_len);
 	arg->phyerrs = phyerrs;
 
 	kfree(tb);
@@ -3402,7 +3402,8 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.pull_vdev_start = ath10k_wmi_tlv_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_tlv_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_tlv_op_pull_swba_ev,
-	.pull_phyerr = ath10k_wmi_tlv_op_pull_phyerr_ev,
+	.pull_phyerr_hdr = ath10k_wmi_tlv_op_pull_phyerr_ev_hdr,
+	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_svc_rdy = ath10k_wmi_tlv_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_tlv_op_pull_rdy_ev,
 	.pull_fw_stats = ath10k_wmi_tlv_op_pull_fw_stats,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e6d6b42..37dfa34 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3264,7 +3264,7 @@ void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar, struct sk_buff *skb)
 }
 
 static void ath10k_dfs_radar_report(struct ath10k *ar,
-				    const struct wmi_phyerr *phyerr,
+				    struct wmi_phyerr_ev_arg *phyerr,
 				    const struct phyerr_radar_report *rr,
 				    u64 tsf)
 {
@@ -3308,7 +3308,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 	}
 
 	/* report event to DFS pattern detector */
-	tsf32l = __le32_to_cpu(phyerr->tsf_timestamp);
+	tsf32l = phyerr->tsf_timestamp;
 	tsf64 = tsf & (~0xFFFFFFFFULL);
 	tsf64 |= tsf32l;
 
@@ -3353,7 +3353,7 @@ radar_detected:
 }
 
 static int ath10k_dfs_fft_report(struct ath10k *ar,
-				 const struct wmi_phyerr *phyerr,
+				 struct wmi_phyerr_ev_arg *phyerr,
 				 const struct phyerr_fft_report *fftr,
 				 u64 tsf)
 {
@@ -3391,7 +3391,7 @@ static int ath10k_dfs_fft_report(struct ath10k *ar,
 }
 
 void ath10k_wmi_event_dfs(struct ath10k *ar,
-			  const struct wmi_phyerr *phyerr,
+			  struct wmi_phyerr_ev_arg *phyerr,
 			  u64 tsf)
 {
 	int buf_len, tlv_len, res, i = 0;
@@ -3400,11 +3400,11 @@ void ath10k_wmi_event_dfs(struct ath10k *ar,
 	const struct phyerr_fft_report *fftr;
 	const u8 *tlv_buf;
 
-	buf_len = __le32_to_cpu(phyerr->buf_len);
+	buf_len = phyerr->buf_len;
 	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi event dfs err_code %d rssi %d tsfl 0x%X tsf64 0x%llX len %d\n",
 		   phyerr->phy_err_code, phyerr->rssi_combined,
-		   __le32_to_cpu(phyerr->tsf_timestamp), tsf, buf_len);
+		   phyerr->tsf_timestamp, tsf, buf_len);
 
 	/* Skip event if DFS disabled */
 	if (!config_enabled(CONFIG_ATH10K_DFS_CERTIFIED))
@@ -3456,7 +3456,7 @@ void ath10k_wmi_event_dfs(struct ath10k *ar,
 }
 
 void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
-				    const struct wmi_phyerr *phyerr,
+				    struct wmi_phyerr_ev_arg *phyerr,
 				    u64 tsf)
 {
 	int buf_len, tlv_len, res, i = 0;
@@ -3465,7 +3465,7 @@ void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 	const struct phyerr_fft_report *fftr;
 	size_t fftr_len;
 
-	buf_len = __le32_to_cpu(phyerr->buf_len);
+	buf_len = phyerr->buf_len;
 
 	while (i < buf_len) {
 		if (i + sizeof(*tlv) > buf_len) {
@@ -3509,65 +3509,110 @@ void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 	}
 }
 
-static int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar, struct sk_buff *skb,
-					struct wmi_phyerr_ev_arg *arg)
+static int ath10k_wmi_op_pull_phyerr_ev_hdr(struct ath10k *ar,
+					    struct sk_buff *skb,
+					    struct wmi_phyerr_hdr_arg *arg)
 {
 	struct wmi_phyerr_event *ev = (void *)skb->data;
 
 	if (skb->len < sizeof(*ev))
 		return -EPROTO;
 
-	arg->num_phyerrs = ev->num_phyerrs;
-	arg->tsf_l32 = ev->tsf_l32;
-	arg->tsf_u32 = ev->tsf_u32;
-	arg->buf_len = __cpu_to_le32(skb->len - sizeof(*ev));
+	arg->num_phyerrs = __le32_to_cpu(ev->num_phyerrs);
+	arg->tsf_l32 = __le32_to_cpu(ev->tsf_l32);
+	arg->tsf_u32 = __le32_to_cpu(ev->tsf_u32);
+	arg->buf_len = skb->len - sizeof(*ev);
 	arg->phyerrs = ev->phyerrs;
 
 	return 0;
 }
 
+int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar,
+				 const void *phyerr_buf,
+				 int left_len,
+				 struct wmi_phyerr_ev_arg *arg)
+{
+	const struct wmi_phyerr *phyerr = phyerr_buf;
+	int i;
+
+	if (left_len < sizeof(*phyerr)) {
+		ath10k_warn(ar, "wrong phyerr event head len %d (need: >=%d)\n",
+			    left_len, sizeof(*phyerr));
+		return -EINVAL;
+	}
+
+	arg->tsf_timestamp = __le32_to_cpu(phyerr->tsf_timestamp);
+	arg->freq1 = __le16_to_cpu(phyerr->freq1);
+	arg->freq2 = __le16_to_cpu(phyerr->freq2);
+	arg->rssi_combined = phyerr->rssi_combined;
+	arg->chan_width_mhz = phyerr->chan_width_mhz;
+	arg->buf_len = __le32_to_cpu(phyerr->buf_len);
+	arg->buf = phyerr->buf;
+	arg->hdr_len = sizeof(*phyerr);
+
+	for (i = 0; i < 4; i++)
+		arg->nf_chains[i] = __le16_to_cpu(phyerr->nf_chains[i]);
+
+	switch (phyerr->phy_err_code) {
+	case PHY_ERROR_GEN_SPECTRAL_SCAN:
+		arg->phy_err_code = PHY_ERROR_SPECTRAL_SCAN;
+		break;
+	case PHY_ERROR_GEN_FALSE_RADAR_EXT:
+		arg->phy_err_code = PHY_ERROR_FALSE_RADAR_EXT;
+		break;
+	case PHY_ERROR_GEN_RADAR:
+		arg->phy_err_code = PHY_ERROR_RADAR;
+		break;
+	default:
+		arg->phy_err_code = PHY_ERROR_UNKNOWN;
+		break;
+	}
+
+	return 0;
+}
+
 void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_phyerr_ev_arg arg = {};
-	const struct wmi_phyerr *phyerr;
+	struct wmi_phyerr_hdr_arg hdr_arg = {};
+	struct wmi_phyerr_ev_arg phyerr_arg = {};
+	const void *phyerr;
 	u32 count, i, buf_len, phy_err_code;
 	u64 tsf;
 	int left_len, ret;
 
 	ATH10K_DFS_STAT_INC(ar, phy_errors);
 
-	ret = ath10k_wmi_pull_phyerr(ar, skb, &arg);
+	ret = ath10k_wmi_pull_phyerr_hdr(ar, skb, &hdr_arg);
 	if (ret) {
-		ath10k_warn(ar, "failed to parse phyerr event: %d\n", ret);
+		ath10k_warn(ar, "failed to parse phyerr event hdr: %d\n", ret);
 		return;
 	}
 
-	left_len = __le32_to_cpu(arg.buf_len);
-
 	/* Check number of included events */
-	count = __le32_to_cpu(arg.num_phyerrs);
+	count = hdr_arg.num_phyerrs;
 
-	tsf = __le32_to_cpu(arg.tsf_u32);
+	left_len = hdr_arg.buf_len;
+
+	tsf = hdr_arg.tsf_u32;
 	tsf <<= 32;
-	tsf |= __le32_to_cpu(arg.tsf_l32);
+	tsf |= hdr_arg.tsf_l32;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event phyerr count %d tsf64 0x%llX\n",
 		   count, tsf);
 
-	phyerr = arg.phyerrs;
+	phyerr = hdr_arg.phyerrs;
 	for (i = 0; i < count; i++) {
-		/* Check if we can read event header */
-		if (left_len < sizeof(*phyerr)) {
-			ath10k_warn(ar, "single event (%d) wrong head len\n",
+		ret = ath10k_wmi_pull_phyerr(ar, phyerr, left_len, &phyerr_arg);
+		if (ret) {
+			ath10k_warn(ar, "failed to parse phyerr event (%d)\n",
 				    i);
 			return;
 		}
 
-		left_len -= sizeof(*phyerr);
-
-		buf_len = __le32_to_cpu(phyerr->buf_len);
-		phy_err_code = phyerr->phy_err_code;
+		left_len -= phyerr_arg.hdr_len;
+		buf_len = phyerr_arg.buf_len;
+		phy_err_code = phyerr_arg.phy_err_code;
 
 		if (left_len < buf_len) {
 			ath10k_warn(ar, "single event (%d) wrong buf len\n", i);
@@ -3578,20 +3623,20 @@ void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 
 		switch (phy_err_code) {
 		case PHY_ERROR_RADAR:
-			ath10k_wmi_event_dfs(ar, phyerr, tsf);
+			ath10k_wmi_event_dfs(ar, &phyerr_arg, tsf);
 			break;
 		case PHY_ERROR_SPECTRAL_SCAN:
-			ath10k_wmi_event_spectral_scan(ar, phyerr, tsf);
+			ath10k_wmi_event_spectral_scan(ar, &phyerr_arg, tsf);
 			break;
 		case PHY_ERROR_FALSE_RADAR_EXT:
-			ath10k_wmi_event_dfs(ar, phyerr, tsf);
-			ath10k_wmi_event_spectral_scan(ar, phyerr, tsf);
+			ath10k_wmi_event_dfs(ar, &phyerr_arg, tsf);
+			ath10k_wmi_event_spectral_scan(ar, &phyerr_arg, tsf);
 			break;
 		default:
 			break;
 		}
 
-		phyerr = (void *)phyerr + sizeof(*phyerr) + buf_len;
+		phyerr = phyerr + phyerr_arg.hdr_len + buf_len;
 	}
 }
 
@@ -6190,6 +6235,7 @@ static const struct wmi_ops wmi_ops = {
 	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr_hdr = ath10k_wmi_op_pull_phyerr_ev_hdr,
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
@@ -6261,6 +6307,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr_hdr = ath10k_wmi_op_pull_phyerr_ev_hdr,
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
@@ -6326,6 +6373,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr_hdr = ath10k_wmi_op_pull_phyerr_ev_hdr,
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
@@ -6387,6 +6435,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr_hdr = ath10k_wmi_op_pull_phyerr_ev_hdr,
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0d4efc9..0ed3cfe 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2973,9 +2973,16 @@ struct wmi_10_4_mgmt_rx_event {
 #define WMI_RX_STATUS_ERR_MIC			0x10
 #define WMI_RX_STATUS_ERR_KEY_CACHE_MISS	0x20
 
-#define PHY_ERROR_SPECTRAL_SCAN		0x26
-#define PHY_ERROR_FALSE_RADAR_EXT		0x24
-#define PHY_ERROR_RADAR				0x05
+#define PHY_ERROR_GEN_SPECTRAL_SCAN		0x26
+#define PHY_ERROR_GEN_FALSE_RADAR_EXT		0x24
+#define PHY_ERROR_GEN_RADAR			0x05
+
+enum phy_err_type {
+	PHY_ERROR_UNKNOWN,
+	PHY_ERROR_SPECTRAL_SCAN,
+	PHY_ERROR_FALSE_RADAR_EXT,
+	PHY_ERROR_RADAR
+};
 
 struct wmi_phyerr {
 	__le32 tsf_timestamp;
@@ -5783,11 +5790,24 @@ struct wmi_swba_ev_arg {
 };
 
 struct wmi_phyerr_ev_arg {
-	__le32 num_phyerrs;
-	__le32 tsf_l32;
-	__le32 tsf_u32;
-	__le32 buf_len;
-	const struct wmi_phyerr *phyerrs;
+	u32 tsf_timestamp;
+	u16 freq1;
+	u16 freq2;
+	u8 rssi_combined;
+	u8 chan_width_mhz;
+	u8 phy_err_code;
+	u16 nf_chains[4];
+	u32 buf_len;
+	const u8 *buf;
+	u8 hdr_len;
+};
+
+struct wmi_phyerr_hdr_arg {
+	u32 num_phyerrs;
+	u32 tsf_l32;
+	u32 tsf_u32;
+	u32 buf_len;
+	const void *phyerrs;
 };
 
 struct wmi_svc_rdy_ev_arg {
@@ -6059,9 +6079,9 @@ void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_dfs(struct ath10k *ar,
-			  const struct wmi_phyerr *phyerr, u64 tsf);
+			  struct wmi_phyerr_ev_arg *phyerr, u64 tsf);
 void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
-				    const struct wmi_phyerr *phyerr,
+				    struct wmi_phyerr_ev_arg *phyerr,
 				    u64 tsf);
 void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb);
@@ -6090,5 +6110,6 @@ void ath10k_wmi_event_vdev_standby_req(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb);
-
+int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar, const void *phyerr_buf,
+				 int left_len, struct wmi_phyerr_ev_arg *arg);
 #endif /* _WMI_H_ */
-- 
1.8.1.2

