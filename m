Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51235 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbaIRNcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:32:15 -0400
Received: by mail-wg0-f44.google.com with SMTP id b13so889049wgh.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:32:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/9] ath10k: clean up phyerr code
Date: Thu, 18 Sep 2014 15:21:25 +0200
Message-Id: <1411046487-19544-8-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153228_872432_C3A6D537)
In-Reply-To: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the phyerr structures more compact and easier
to understand. Also add constness.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/spectral.c | 34 ++++-------
 drivers/net/wireless/ath/ath10k/spectral.h |  8 +--
 drivers/net/wireless/ath/ath10k/wmi.c      | 90 +++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/wmi.h      | 83 +++------------------------
 4 files changed, 66 insertions(+), 149 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index 3e1454b..63ce61f 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -56,14 +56,14 @@ static uint8_t get_max_exp(s8 max_index, u16 max_magnitude, size_t bin_len,
 }
 
 int ath10k_spectral_process_fft(struct ath10k *ar,
-				struct wmi_single_phyerr_rx_event *event,
-				struct phyerr_fft_report *fftr,
+				const struct wmi_phyerr *phyerr,
+				const struct phyerr_fft_report *fftr,
 				size_t bin_len, u64 tsf)
 {
 	struct fft_sample_ath10k *fft_sample;
 	u8 buf[sizeof(*fft_sample) + SPECTRAL_ATH10K_MAX_NUM_BINS];
 	u16 freq1, freq2, total_gain_db, base_pwr_db, length, peak_mag;
-	u32 reg0, reg1, nf_list1, nf_list2;
+	u32 reg0, reg1;
 	u8 chain_idx, *bins;
 	int dc_pos;
 
@@ -82,7 +82,7 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 	/* TODO: there might be a reason why the hardware reports 20/40/80 MHz,
 	 * but the results/plots suggest that its actually 22/44/88 MHz.
 	 */
-	switch (event->hdr.chan_width_mhz) {
+	switch (phyerr->chan_width_mhz) {
 	case 20:
 		fft_sample->chan_width_mhz = 22;
 		break;
@@ -101,7 +101,7 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 		fft_sample->chan_width_mhz = 88;
 		break;
 	default:
-		fft_sample->chan_width_mhz = event->hdr.chan_width_mhz;
+		fft_sample->chan_width_mhz = phyerr->chan_width_mhz;
 	}
 
 	fft_sample->relpwr_db = MS(reg1, SEARCH_FFT_REPORT_REG1_RELPWR_DB);
@@ -110,36 +110,22 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 	peak_mag = MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG);
 	fft_sample->max_magnitude = __cpu_to_be16(peak_mag);
 	fft_sample->max_index = MS(reg0, SEARCH_FFT_REPORT_REG0_PEAK_SIDX);
-	fft_sample->rssi = event->hdr.rssi_combined;
+	fft_sample->rssi = phyerr->rssi_combined;
 
 	total_gain_db = MS(reg0, SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB);
 	base_pwr_db = MS(reg0, SEARCH_FFT_REPORT_REG0_BASE_PWR_DB);
 	fft_sample->total_gain_db = __cpu_to_be16(total_gain_db);
 	fft_sample->base_pwr_db = __cpu_to_be16(base_pwr_db);
 
-	freq1 = __le16_to_cpu(event->hdr.freq1);
-	freq2 = __le16_to_cpu(event->hdr.freq2);
+	freq1 = __le16_to_cpu(phyerr->freq1);
+	freq2 = __le16_to_cpu(phyerr->freq2);
 	fft_sample->freq1 = __cpu_to_be16(freq1);
 	fft_sample->freq2 = __cpu_to_be16(freq2);
 
-	nf_list1 = __le32_to_cpu(event->hdr.nf_list_1);
-	nf_list2 = __le32_to_cpu(event->hdr.nf_list_2);
 	chain_idx = MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX);
 
-	switch (chain_idx) {
-	case 0:
-		fft_sample->noise = __cpu_to_be16(nf_list1 & 0xffffu);
-		break;
-	case 1:
-		fft_sample->noise = __cpu_to_be16((nf_list1 >> 16) & 0xffffu);
-		break;
-	case 2:
-		fft_sample->noise = __cpu_to_be16(nf_list2 & 0xffffu);
-		break;
-	case 3:
-		fft_sample->noise = __cpu_to_be16((nf_list2 >> 16) & 0xffffu);
-		break;
-	}
+	fft_sample->noise = __cpu_to_be16(
+			__le16_to_cpu(phyerr->nf_chains[chain_idx]));
 
 	bins = (u8 *)fftr;
 	bins += sizeof(*fftr);
diff --git a/drivers/net/wireless/ath/ath10k/spectral.h b/drivers/net/wireless/ath/ath10k/spectral.h
index ddc57c5..042f5b3 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.h
+++ b/drivers/net/wireless/ath/ath10k/spectral.h
@@ -47,8 +47,8 @@ enum ath10k_spectral_mode {
 #ifdef CONFIG_ATH10K_DEBUGFS
 
 int ath10k_spectral_process_fft(struct ath10k *ar,
-				struct wmi_single_phyerr_rx_event *event,
-				struct phyerr_fft_report *fftr,
+				const struct wmi_phyerr *phyerr,
+				const struct phyerr_fft_report *fftr,
 				size_t bin_len, u64 tsf);
 int ath10k_spectral_start(struct ath10k *ar);
 int ath10k_spectral_vif_stop(struct ath10k_vif *arvif);
@@ -59,8 +59,8 @@ void ath10k_spectral_destroy(struct ath10k *ar);
 
 static inline int
 ath10k_spectral_process_fft(struct ath10k *ar,
-			    struct wmi_single_phyerr_rx_event *event,
-			    struct phyerr_fft_report *fftr,
+			    const struct wmi_phyerr *phyerr,
+			    const struct phyerr_fft_report *fftr,
 			    size_t bin_len, u64 tsf)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index eab6b70..592e3af 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1715,8 +1715,8 @@ static void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar,
 }
 
 static void ath10k_dfs_radar_report(struct ath10k *ar,
-				    struct wmi_single_phyerr_rx_event *event,
-				    struct phyerr_radar_report *rr,
+				    const struct wmi_phyerr *phyerr,
+				    const struct phyerr_radar_report *rr,
 				    u64 tsf)
 {
 	u32 reg0, reg1, tsf32l;
@@ -1749,12 +1749,12 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 		return;
 
 	/* report event to DFS pattern detector */
-	tsf32l = __le32_to_cpu(event->hdr.tsf_timestamp);
+	tsf32l = __le32_to_cpu(phyerr->tsf_timestamp);
 	tsf64 = tsf & (~0xFFFFFFFFULL);
 	tsf64 |= tsf32l;
 
 	width = MS(reg1, RADAR_REPORT_REG1_PULSE_DUR);
-	rssi = event->hdr.rssi_combined;
+	rssi = phyerr->rssi_combined;
 
 	/* hardware store this as 8 bit signed value,
 	 * set to zero if negative number
@@ -1793,8 +1793,8 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 }
 
 static int ath10k_dfs_fft_report(struct ath10k *ar,
-				 struct wmi_single_phyerr_rx_event *event,
-				 struct phyerr_fft_report *fftr,
+				 const struct wmi_phyerr *phyerr,
+				 const struct phyerr_fft_report *fftr,
 				 u64 tsf)
 {
 	u32 reg0, reg1;
@@ -1802,7 +1802,7 @@ static int ath10k_dfs_fft_report(struct ath10k *ar,
 
 	reg0 = __le32_to_cpu(fftr->reg0);
 	reg1 = __le32_to_cpu(fftr->reg1);
-	rssi = event->hdr.rssi_combined;
+	rssi = phyerr->rssi_combined;
 
 	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi phyerr fft report total_gain_db %d base_pwr_db %d fft_chn_idx %d peak_sidx %d\n",
@@ -1831,20 +1831,20 @@ static int ath10k_dfs_fft_report(struct ath10k *ar,
 }
 
 static void ath10k_wmi_event_dfs(struct ath10k *ar,
-				 struct wmi_single_phyerr_rx_event *event,
+				 const struct wmi_phyerr *phyerr,
 				 u64 tsf)
 {
 	int buf_len, tlv_len, res, i = 0;
-	struct phyerr_tlv *tlv;
-	struct phyerr_radar_report *rr;
-	struct phyerr_fft_report *fftr;
-	u8 *tlv_buf;
+	const struct phyerr_tlv *tlv;
+	const struct phyerr_radar_report *rr;
+	const struct phyerr_fft_report *fftr;
+	const u8 *tlv_buf;
 
-	buf_len = __le32_to_cpu(event->hdr.buf_len);
+	buf_len = __le32_to_cpu(phyerr->buf_len);
 	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi event dfs err_code %d rssi %d tsfl 0x%X tsf64 0x%llX len %d\n",
-		   event->hdr.phy_err_code, event->hdr.rssi_combined,
-		   __le32_to_cpu(event->hdr.tsf_timestamp), tsf, buf_len);
+		   phyerr->phy_err_code, phyerr->rssi_combined,
+		   __le32_to_cpu(phyerr->tsf_timestamp), tsf, buf_len);
 
 	/* Skip event if DFS disabled */
 	if (!config_enabled(CONFIG_ATH10K_DFS_CERTIFIED))
@@ -1859,9 +1859,9 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 			return;
 		}
 
-		tlv = (struct phyerr_tlv *)&event->bufp[i];
+		tlv = (struct phyerr_tlv *)&phyerr->buf[i];
 		tlv_len = __le16_to_cpu(tlv->len);
-		tlv_buf = &event->bufp[i + sizeof(*tlv)];
+		tlv_buf = &phyerr->buf[i + sizeof(*tlv)];
 		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 			   "wmi event dfs tlv_len %d tlv_tag 0x%02X tlv_sig 0x%02X\n",
 			   tlv_len, tlv->tag, tlv->sig);
@@ -1875,7 +1875,7 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 			}
 
 			rr = (struct phyerr_radar_report *)tlv_buf;
-			ath10k_dfs_radar_report(ar, event, rr, tsf);
+			ath10k_dfs_radar_report(ar, phyerr, rr, tsf);
 			break;
 		case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
 			if (i + sizeof(*tlv) + sizeof(*fftr) > buf_len) {
@@ -1885,7 +1885,7 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 			}
 
 			fftr = (struct phyerr_fft_report *)tlv_buf;
-			res = ath10k_dfs_fft_report(ar, event, fftr, tsf);
+			res = ath10k_dfs_fft_report(ar, phyerr, fftr, tsf);
 			if (res)
 				return;
 			break;
@@ -1897,16 +1897,16 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 
 static void
 ath10k_wmi_event_spectral_scan(struct ath10k *ar,
-			       struct wmi_single_phyerr_rx_event *event,
+			       const struct wmi_phyerr *phyerr,
 			       u64 tsf)
 {
 	int buf_len, tlv_len, res, i = 0;
 	struct phyerr_tlv *tlv;
-	u8 *tlv_buf;
-	struct phyerr_fft_report *fftr;
+	const void *tlv_buf;
+	const struct phyerr_fft_report *fftr;
 	size_t fftr_len;
 
-	buf_len = __le32_to_cpu(event->hdr.buf_len);
+	buf_len = __le32_to_cpu(phyerr->buf_len);
 
 	while (i < buf_len) {
 		if (i + sizeof(*tlv) > buf_len) {
@@ -1915,9 +1915,9 @@ ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 			return;
 		}
 
-		tlv = (struct phyerr_tlv *)&event->bufp[i];
+		tlv = (struct phyerr_tlv *)&phyerr->buf[i];
 		tlv_len = __le16_to_cpu(tlv->len);
-		tlv_buf = &event->bufp[i + sizeof(*tlv)];
+		tlv_buf = &phyerr->buf[i + sizeof(*tlv)];
 
 		if (i + sizeof(*tlv) + tlv_len > buf_len) {
 			ath10k_warn(ar, "failed to parse phyerr tlv payload at byte %d\n",
@@ -1934,8 +1934,8 @@ ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 			}
 
 			fftr_len = tlv_len - sizeof(*fftr);
-			fftr = (struct phyerr_fft_report *)tlv_buf;
-			res = ath10k_spectral_process_fft(ar, event,
+			fftr = tlv_buf;
+			res = ath10k_spectral_process_fft(ar, phyerr,
 							  fftr, fftr_len,
 							  tsf);
 			if (res < 0) {
@@ -1952,8 +1952,8 @@ ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 
 static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_comb_phyerr_rx_event *comb_event;
-	struct wmi_single_phyerr_rx_event *event;
+	const struct wmi_phyerr_event *ev;
+	const struct wmi_phyerr *phyerr;
 	u32 count, i, buf_len, phy_err_code;
 	u64 tsf;
 	int left_len = skb->len;
@@ -1961,38 +1961,38 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 	ATH10K_DFS_STAT_INC(ar, phy_errors);
 
 	/* Check if combined event available */
-	if (left_len < sizeof(*comb_event)) {
+	if (left_len < sizeof(*ev)) {
 		ath10k_warn(ar, "wmi phyerr combined event wrong len\n");
 		return;
 	}
 
-	left_len -= sizeof(*comb_event);
+	left_len -= sizeof(*ev);
 
 	/* Check number of included events */
-	comb_event = (struct wmi_comb_phyerr_rx_event *)skb->data;
-	count = __le32_to_cpu(comb_event->hdr.num_phyerr_events);
+	ev = (const struct wmi_phyerr_event *)skb->data;
+	count = __le32_to_cpu(ev->num_phyerrs);
 
-	tsf = __le32_to_cpu(comb_event->hdr.tsf_u32);
+	tsf = __le32_to_cpu(ev->tsf_u32);
 	tsf <<= 32;
-	tsf |= __le32_to_cpu(comb_event->hdr.tsf_l32);
+	tsf |= __le32_to_cpu(ev->tsf_l32);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event phyerr count %d tsf64 0x%llX\n",
 		   count, tsf);
 
-	event = (struct wmi_single_phyerr_rx_event *)comb_event->bufp;
+	phyerr = ev->phyerrs;
 	for (i = 0; i < count; i++) {
 		/* Check if we can read event header */
-		if (left_len < sizeof(*event)) {
+		if (left_len < sizeof(*phyerr)) {
 			ath10k_warn(ar, "single event (%d) wrong head len\n",
 				    i);
 			return;
 		}
 
-		left_len -= sizeof(*event);
+		left_len -= sizeof(*phyerr);
 
-		buf_len = __le32_to_cpu(event->hdr.buf_len);
-		phy_err_code = event->hdr.phy_err_code;
+		buf_len = __le32_to_cpu(phyerr->buf_len);
+		phy_err_code = phyerr->phy_err_code;
 
 		if (left_len < buf_len) {
 			ath10k_warn(ar, "single event (%d) wrong buf len\n", i);
@@ -2003,20 +2003,20 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 
 		switch (phy_err_code) {
 		case PHY_ERROR_RADAR:
-			ath10k_wmi_event_dfs(ar, event, tsf);
+			ath10k_wmi_event_dfs(ar, phyerr, tsf);
 			break;
 		case PHY_ERROR_SPECTRAL_SCAN:
-			ath10k_wmi_event_spectral_scan(ar, event, tsf);
+			ath10k_wmi_event_spectral_scan(ar, phyerr, tsf);
 			break;
 		case PHY_ERROR_FALSE_RADAR_EXT:
-			ath10k_wmi_event_dfs(ar, event, tsf);
-			ath10k_wmi_event_spectral_scan(ar, event, tsf);
+			ath10k_wmi_event_dfs(ar, phyerr, tsf);
+			ath10k_wmi_event_spectral_scan(ar, phyerr, tsf);
 			break;
 		default:
 			break;
 		}
 
-		event += sizeof(*event) + buf_len;
+		phyerr = (void *)phyerr + sizeof(*phyerr) + buf_len;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ebdf154..a041567 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2295,94 +2295,25 @@ struct wmi_mgmt_rx_event_v2 {
 #define PHY_ERROR_FALSE_RADAR_EXT		0x24
 #define PHY_ERROR_RADAR				0x05
 
-struct wmi_single_phyerr_rx_hdr {
-	/* TSF timestamp */
+struct wmi_phyerr {
 	__le32 tsf_timestamp;
-
-	/*
-	 * Current freq1, freq2
-	 *
-	 * [7:0]:    freq1[lo]
-	 * [15:8] :   freq1[hi]
-	 * [23:16]:   freq2[lo]
-	 * [31:24]:   freq2[hi]
-	 */
 	__le16 freq1;
 	__le16 freq2;
-
-	/*
-	 * Combined RSSI over all chains and channel width for this PHY error
-	 *
-	 * [7:0]: RSSI combined
-	 * [15:8]: Channel width (MHz)
-	 * [23:16]: PHY error code
-	 * [24:16]: reserved (future use)
-	 */
 	u8 rssi_combined;
 	u8 chan_width_mhz;
 	u8 phy_err_code;
 	u8 rsvd0;
-
-	/*
-	 * RSSI on chain 0 through 3
-	 *
-	 * This is formatted the same as the PPDU_START RX descriptor
-	 * field:
-	 *
-	 * [7:0]:   pri20
-	 * [15:8]:  sec20
-	 * [23:16]: sec40
-	 * [31:24]: sec80
-	 */
-
-	__le32 rssi_chain0;
-	__le32 rssi_chain1;
-	__le32 rssi_chain2;
-	__le32 rssi_chain3;
-
-	/*
-	 * Last calibrated NF value for chain 0 through 3
-	 *
-	 * nf_list_1:
-	 *
-	 * + [15:0] - chain 0
-	 * + [31:16] - chain 1
-	 *
-	 * nf_list_2:
-	 *
-	 * + [15:0] - chain 2
-	 * + [31:16] - chain 3
-	 */
-	__le32 nf_list_1;
-	__le32 nf_list_2;
-
-	/* Length of the frame */
+	__le32 rssi_chains[4];
+	__le16 nf_chains[4];
 	__le32 buf_len;
+	u8 buf[0];
 } __packed;
 
-struct wmi_single_phyerr_rx_event {
-	/* Phy error event header */
-	struct wmi_single_phyerr_rx_hdr hdr;
-	/* frame buffer */
-	u8 bufp[0];
-} __packed;
-
-struct wmi_comb_phyerr_rx_hdr {
-	/* Phy error phy error count */
-	__le32 num_phyerr_events;
+struct wmi_phyerr_event {
+	__le32 num_phyerrs;
 	__le32 tsf_l32;
 	__le32 tsf_u32;
-} __packed;
-
-struct wmi_comb_phyerr_rx_event {
-	/* Phy error phy error count */
-	struct wmi_comb_phyerr_rx_hdr hdr;
-	/*
-	 * frame buffer - contains multiple payloads in the order:
-	 *                    header - payload, header - payload...
-	 *  (The header is of type: wmi_single_phyerr_rx_hdr)
-	 */
-	u8 bufp[0];
+	struct wmi_phyerr phyerrs[0];
 } __packed;
 
 #define PHYERR_TLV_SIG				0xBB
-- 
1.8.5.3

