Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:49794 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYFKVWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:22:00 -0400
Received: by py-out-1112.google.com with SMTP id p76so1566332pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:21:59 -0700 (PDT)
Subject: [PATCHv2 01/11] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 14:21:56 -0700
Message-Id: <1213219316.5974.174.camel@brick> (sfid-20080611_232209_293877_698E4D13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few general categories:

1) ieee80211_has_* tests if particular fctl bits are set, the helpers are de
in the same order as the fctl defines:

A combined _has_a4 was also added to test when both FROMDS and TODS are set.

2) ieee80211_is_* is meant to test whether the frame control is of a certain
ftype - data, mgmt, ctl, and two special helpers _is_data_qos, _is_data_pres
which also test a subset of the stype space.

When testing for a particular stype applicable only to one ftype, functions
like ieee80211_is_ack have been added.  Note that the ftype is also being
checked in these helpers.  They have been added for all mgmt and ctl stypes
in the same order as the STYPE defines.

3) ieee80211_get_* is meant to take a struct ieee80211_hdr * and returns a
pointer to somewhere in the struct, see get_SA, get_DA, get_qos_ctl.

The intel wireless drivers had helpers that used this namespace, convert the
all to use the new helpers and remove the byteshifting as they were defined
in cpu-order rather than little-endian.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I think this series is ready for wireless-testing.

 drivers/net/wireless/iwlwifi/iwl-3945.c     |   36 ++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   17 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   28 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |  109 --------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   49 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   33 +--
 include/linux/ieee80211.h                   |  392 +++++++++++++++++++++++++--
 7 files changed, 455 insertions(+), 209 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0ba6889..63f2037 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -388,7 +388,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
 	u32 hundred = 0;
 	u32 dataframe = 0;
-	u16 fc;
+	__le16 fc;
 	u16 seq_ctl;
 	u16 channel;
 	u16 phy_flags;
@@ -407,7 +407,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 	u8 *data = IWL_RX_DATA(pkt);
 
 	/* MAC header */
-	fc = le16_to_cpu(header->frame_control);
+	fc = header->frame_control;
 	seq_ctl = le16_to_cpu(header->seq_ctrl);
 
 	/* metadata */
@@ -431,8 +431,8 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 
 	/* if data frame is to us and all is good,
 	 *   (optionally) print summary for only 1 out of every 100 */
-	if (to_us && (fc & ~IEEE80211_FCTL_PROTECTED) ==
-	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
+	if (to_us && (fc & ~cpu_to_le16(IEEE80211_FCTL_PROTECTED)) ==
+	    cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
 		dataframe = 1;
 		if (!group100)
 			print_summary = 1;	/* print each frame */
@@ -455,13 +455,13 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 
 		if (hundred)
 			title = "100Frames";
-		else if (fc & IEEE80211_FCTL_RETRY)
+		else if (ieee80211_has_retry(fc))
 			title = "Retry";
-		else if (ieee80211_is_assoc_response(fc))
+		else if (ieee80211_is_assoc_resp(fc))
 			title = "AscRsp";
-		else if (ieee80211_is_reassoc_response(fc))
+		else if (ieee80211_is_reassoc_resp(fc))
 			title = "RasRsp";
-		else if (ieee80211_is_probe_response(fc)) {
+		else if (ieee80211_is_probe_resp(fc)) {
 			title = "PrbRsp";
 			print_dump = 1;	/* dump frame contents */
 		} else if (ieee80211_is_beacon(fc)) {
@@ -490,14 +490,14 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 		if (dataframe)
 			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
 				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
-				     title, fc, header->addr1[5],
+				     title, le16_to_cpu(fc), header->addr1[5],
 				     length, rssi, channel, rate);
 		else {
 			/* src/dst addresses assume managed mode */
 			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
 				     "src=0x%02x, rssi=%u, tim=%lu usec, "
 				     "phy=0x%02x, chnl=%d\n",
-				     title, fc, header->addr1[5],
+				     title, le16_to_cpu(fc), header->addr1[5],
 				     header->addr3[5], rssi,
 				     tsf_low - priv->scan_start_tsf,
 				     phy_flags, channel);
@@ -971,7 +971,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 	u8 rts_retry_limit;
 	u8 data_retry_limit;
 	__le32 tx_flags;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 
 	rate = iwl3945_rates[rate_index].plcp;
 	tx_flags = cmd->cmd.tx.tx_flags;
@@ -996,7 +996,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 	else
 		rts_retry_limit = 7;
 
-	if (ieee80211_is_probe_response(fc)) {
+	if (ieee80211_is_probe_resp(fc)) {
 		data_retry_limit = 3;
 		if (data_retry_limit < rts_retry_limit)
 			rts_retry_limit = data_retry_limit;
@@ -1006,12 +1006,12 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 	if (priv->data_retry_limit != -1)
 		data_retry_limit = priv->data_retry_limit;
 
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_AUTH:
-		case IEEE80211_STYPE_DEAUTH:
-		case IEEE80211_STYPE_ASSOC_REQ:
-		case IEEE80211_STYPE_REASSOC_REQ:
+	if (ieee80211_is_mgmt(fc)) {
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_AUTH):
+		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
 			if (tx_flags & TX_CMD_FLG_RTS_MSK) {
 				tx_flags &= ~TX_CMD_FLG_RTS_MSK;
 				tx_flags |= TX_CMD_FLG_CTS_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index d8f2b4d..716b2a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -289,11 +289,11 @@ static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data,
 	u32 time_diff;
 	s32 index;
 	struct iwl4965_traffic_load *tl = NULL;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u8 tid;
 
-	if (ieee80211_is_qos_data(fc)) {
-		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+	if (ieee80211_is_data_qos(fc)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
 	} else
 		return;
@@ -804,7 +804,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	struct iwl4965_scale_tbl_info tbl_type;
 	struct iwl4965_scale_tbl_info *curr_tbl, *search_tbl;
 	u8 active_index = 0;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	s32 tpt = 0;
 
 	IWL_DEBUG_RATE_LIMIT("get frame ack response, update rate scale window\n");
@@ -1678,7 +1678,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	int high_tpt = IWL_INVALID_VALUE;
 	u32 fail_count;
 	s8 scale_action = 0;
-	u16 fc, rate_mask;
+	__le16 fc;
+	u16 rate_mask;
 	u8 update_lq = 0;
 	struct iwl4965_lq_sta *lq_sta;
 	struct iwl4965_scale_tbl_info *tbl, *tbl1;
@@ -1695,7 +1696,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
 
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
 		/* Send management frames and broadcast/multicast data using
 		 * lowest rate. */
@@ -2136,7 +2137,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
-	u16 fc;
+	__le16 fc;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl4965_lq_sta *lq_sta;
 
@@ -2148,7 +2149,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !sta->rate_ctrl_priv) {
 		sel->rate_idx = rate_lowest_index(local, sband, sta);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index aee7014..ee5d2b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2552,7 +2552,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
 	u32 hundred = 0;
 	u32 dataframe = 0;
-	u16 fc;
+	__le16 fc;
 	u16 seq_ctl;
 	u16 channel;
 	u16 phy_flags;
@@ -2575,7 +2575,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 		return;
 
 	/* MAC header */
-	fc = le16_to_cpu(header->frame_control);
+	fc = header->frame_control;
 	seq_ctl = le16_to_cpu(header->seq_ctrl);
 
 	/* metadata */
@@ -2600,8 +2600,8 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 
 	/* if data frame is to us and all is good,
 	 *   (optionally) print summary for only 1 out of every 100 */
-	if (to_us && (fc & ~IEEE80211_FCTL_PROTECTED) ==
-	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
+	if (to_us && (fc & ~cpu_to_le16(IEEE80211_FCTL_PROTECTED)) ==
+	    cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
 		dataframe = 1;
 		if (!group100)
 			print_summary = 1;	/* print each frame */
@@ -2625,13 +2625,13 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 
 		if (hundred)
 			title = "100Frames";
-		else if (fc & IEEE80211_FCTL_RETRY)
+		else if (ieee80211_has_retry(fc))
 			title = "Retry";
-		else if (ieee80211_is_assoc_response(fc))
+		else if (ieee80211_is_assoc_resp(fc))
 			title = "AscRsp";
-		else if (ieee80211_is_reassoc_response(fc))
+		else if (ieee80211_is_reassoc_resp(fc))
 			title = "RasRsp";
-		else if (ieee80211_is_probe_response(fc)) {
+		else if (ieee80211_is_probe_resp(fc)) {
 			title = "PrbRsp";
 			print_dump = 1;	/* dump frame contents */
 		} else if (ieee80211_is_beacon(fc)) {
@@ -2660,14 +2660,14 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 		if (dataframe)
 			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
 				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
-				     title, fc, header->addr1[5],
+				     title, le16_to_cpu(fc), header->addr1[5],
 				     length, rssi, channel, bitrate);
 		else {
 			/* src/dst addresses assume managed mode */
 			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
 				     "src=0x%02x, rssi=%u, tim=%lu usec, "
 				     "phy=0x%02x, chnl=%d\n",
-				     title, fc, header->addr1[5],
+				     title, le16_to_cpu(fc), header->addr1[5],
 				     header->addr3[5], rssi,
 				     tsf_low - priv->scan_start_tsf,
 				     phy_flags, channel);
@@ -3406,7 +3406,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	u32  status = le32_to_cpu(tx_resp->status);
 #ifdef CONFIG_IWL4965_HT
 	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
-	u16 fc;
+	__le16 fc;
 	struct ieee80211_hdr *hdr;
 	u8 *qc = NULL;
 #endif
@@ -3424,9 +3424,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 #ifdef CONFIG_IWL4965_HT
 	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
-	fc = le16_to_cpu(hdr->frame_control);
-	if (ieee80211_is_qos_data(fc)) {
-		qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+	fc = hdr->frame_control;
+	if (ieee80211_is_data_qos(fc)) {
+		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index dedefa0..43f5022 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -147,115 +147,6 @@ static inline struct ieee80211_conf *ieee80211_get_hw_conf(
 	return &hw->conf;
 }
 
-#define QOS_CONTROL_LEN 2
-
-
-static inline int ieee80211_is_management(u16 fc)
-{
-	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT;
-}
-
-static inline int ieee80211_is_control(u16 fc)
-{
-	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL;
-}
-
-static inline int ieee80211_is_data(u16 fc)
-{
-	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA;
-}
-
-static inline int ieee80211_is_back_request(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BACK_REQ);
-}
-
-static inline int ieee80211_is_probe_response(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP);
-}
-
-static inline int ieee80211_is_probe_request(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_REQ);
-}
-
-static inline int ieee80211_is_beacon(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON);
-}
-
-static inline int ieee80211_is_atim(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ATIM);
-}
-
-static inline int ieee80211_is_assoc_request(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
-}
-
-static inline int ieee80211_is_assoc_response(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_RESP);
-}
-
-static inline int ieee80211_is_auth(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
-}
-
-static inline int ieee80211_is_deauth(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
-}
-
-static inline int ieee80211_is_disassoc(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
-}
-
-static inline int ieee80211_is_reassoc_request(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ);
-}
-
-static inline int ieee80211_is_reassoc_response(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_RESP);
-}
-
-static inline int ieee80211_is_qos_data(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_QOS_DATA);
-}
-/**
- * ieee80211_get_qos_ctrl - get pointer to the QoS control field
- *
- * This function returns the pointer to 802.11 header QoS field (2 bytes)
- * This function doesn't check whether hdr is a QoS hdr, use with care
- * @hdr: struct ieee80211_hdr *hdr
- * @hdr_len: header length
- */
-
-static inline u8 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr, int hdr_len)
-{
-	return  ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
-}
-
 static inline int iwl_check_bits(unsigned long field, unsigned long mask)
 {
 	return ((field & mask) == mask) ? 1 : 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index cfe6f4b..3850cb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -574,15 +574,15 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
 {
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	__le32 tx_flags = tx_cmd->tx_flags;
 
 	tx_cmd->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
-		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
+		if (ieee80211_is_mgmt(fc))
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-		if (ieee80211_is_probe_response(fc) &&
+		if (ieee80211_is_probe_resp(fc) &&
 		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
 			tx_flags |= TX_CMD_FLG_TSF_MSK;
 	} else {
@@ -590,7 +590,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	if (ieee80211_is_back_request(fc))
+	if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
 

@@ -598,8 +598,8 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 	if (ieee80211_get_morefrag(hdr))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
-	if (ieee80211_is_qos_data(fc)) {
-		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+	if (ieee80211_is_data_qos(fc)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
@@ -618,9 +618,8 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
 
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
-		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ ||
-		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
+	if (ieee80211_is_mgmt(fc)) {
+		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
 			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
 			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(2);
@@ -639,7 +638,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 			      struct iwl_tx_cmd *tx_cmd,
 			      struct ieee80211_tx_info *info,
-			      u16 fc, int sta_id,
+			      __le16 fc, int sta_id,
 			      int is_hcca)
 {
 	u8 rts_retry_limit = 0;
@@ -660,7 +659,7 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 		rate_flags |= RATE_MCS_CCK_MSK;
 

-	if (ieee80211_is_probe_response(fc)) {
+	if (ieee80211_is_probe_resp(fc)) {
 		data_retry_limit = 3;
 		if (data_retry_limit < rts_retry_limit)
 			rts_retry_limit = data_retry_limit;
@@ -675,11 +674,11 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
 	} else {
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_AUTH:
-		case IEEE80211_STYPE_DEAUTH:
-		case IEEE80211_STYPE_ASSOC_REQ:
-		case IEEE80211_STYPE_REASSOC_REQ:
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_AUTH):
+		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
 			if (tx_cmd->tx_flags & TX_CMD_FLG_RTS_MSK) {
 				tx_cmd->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
 				tx_cmd->tx_flags |= TX_CMD_FLG_CTS_MSK;
@@ -776,7 +775,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u16 seq_number = 0;
 	u8 id, hdr_len, unicast;
 	u8 sta_id;
-	u16 fc;
+	__le16 fc;
 	u8 wait_write_ptr = 0;
 	u8 tid = 0;
 	u8 *qc = NULL;
@@ -803,19 +802,19 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	unicast = !is_multicast_ether_addr(hdr->addr1);
 	id = 0;
 
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
-	else if (ieee80211_is_assoc_request(fc))
+	else if (ieee80211_is_assoc_req(fc))
 		IWL_DEBUG_TX("Sending ASSOC frame\n");
-	else if (ieee80211_is_reassoc_request(fc))
+	else if (ieee80211_is_reassoc_req(fc))
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif
 
 	/* drop all data frame if we are not associated */
-	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	if (ieee80211_is_data(fc) &&
 	   (!iwl_is_associated(priv) ||
 	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
 	    !priv->assoc_station_added)) {
@@ -825,7 +824,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	hdr_len = ieee80211_get_hdrlen(fc);
+	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(fc));
 
 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl_get_sta_id(priv, hdr);
@@ -839,8 +838,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX("station Id %d\n", sta_id);
 
-	if (ieee80211_is_qos_data(fc)) {
-		qc = ieee80211_get_qos_ctrl(hdr, hdr_len);
+	if (ieee80211_is_data_qos(fc)) {
+		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
@@ -945,7 +944,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
 
-	iwl_update_tx_stats(priv, fc, len);
+	iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 		offsetof(struct iwl_tx_cmd, scratch);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 72279e0..265d65a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2431,15 +2431,15 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
 {
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	__le32 tx_flags = cmd->cmd.tx.tx_flags;
 
 	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
-		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
+		if (ieee80211_is_mgmt(fc))
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-		if (ieee80211_is_probe_response(fc) &&
+		if (ieee80211_is_probe_resp(fc) &&
 		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
 			tx_flags |= TX_CMD_FLG_TSF_MSK;
 	} else {
@@ -2451,8 +2451,8 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 	if (ieee80211_get_morefrag(hdr))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
-	if (ieee80211_is_qos_data(fc)) {
-		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+	if (ieee80211_is_data_qos(fc)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		cmd->cmd.tx.tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
@@ -2471,9 +2471,8 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
 
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
-		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ ||
-		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
+	if (ieee80211_is_mgmt(fc)) {
+		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
 			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
 			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
@@ -2564,7 +2563,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	u8 sta_id;
 	u8 tid = 0;
 	u16 seq_number = 0;
-	u16 fc;
+	__le16 fc;
 	u8 wait_write_ptr = 0;
 	u8 *qc = NULL;
 	unsigned long flags;
@@ -2589,28 +2588,28 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	unicast = !is_multicast_ether_addr(hdr->addr1);
 	id = 0;
 
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
 
 #ifdef CONFIG_IWL3945_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
-	else if (ieee80211_is_assoc_request(fc))
+	else if (ieee80211_is_assoc_req(fc))
 		IWL_DEBUG_TX("Sending ASSOC frame\n");
-	else if (ieee80211_is_reassoc_request(fc))
+	else if (ieee80211_is_reassoc_req(fc))
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif
 
 	/* drop all data frame if we are not associated */
 	if ((!iwl3945_is_associated(priv) ||
 	     ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id)) &&
-	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
+	    ieee80211_is_data(fc)) {
 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	hdr_len = ieee80211_get_hdrlen(fc);
+	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(fc));
 
 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl3945_get_sta_id(priv, hdr);
@@ -2624,8 +2623,8 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_RATE("station Id %d\n", sta_id);
 
-	if (ieee80211_is_qos_data(fc)) {
-		qc = ieee80211_get_qos_ctrl(hdr, hdr_len);
+	if (ieee80211_is_data_qos(fc)) {
+		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
@@ -2746,7 +2745,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 			   sizeof(out_cmd->cmd.tx));
 
 	iwl3945_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
-			   ieee80211_get_hdrlen(fc));
+			   ieee80211_get_hdrlen(le16_to_cpu(fc)));
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9300f37..1711a00 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -98,6 +98,7 @@
 
 #define IEEE80211_MAX_SSID_LEN		32
 #define IEEE80211_MAX_MESH_ID_LEN	32
+#define IEEE80211_QOS_CTL_LEN		2
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -109,6 +110,355 @@ struct ieee80211_hdr {
 	u8 addr4[6];
 } __attribute__ ((packed));
 
+/**
+ * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_tods(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_TODS)) != 0;
+}
+
+/**
+ * ieee80211_has_fromds - check if IEEE80211_FCTL_FROMDS is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_fromds(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FROMDS)) != 0;
+}
+
+/**
+ * ieee80211_has_a4 - check if IEEE80211_FCTL_TODS and IEEE80211_FCTL_FROMDS are set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_a4(__le16 fc)
+{
+	__le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
+	return (fc & tmp) == tmp;
+}
+
+/**
+ * ieee80211_has_morefrags - check if IEEE80211_FCTL_MOREFRAGS is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_morefrags(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) != 0;
+}
+
+/**
+ * ieee80211_has_retry - check if IEEE80211_FCTL_RETRY is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_retry(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_RETRY)) != 0;
+}
+
+/**
+ * ieee80211_has_pm - check if IEEE80211_FCTL_PM is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_pm(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_PM)) != 0;
+}
+
+/**
+ * ieee80211_has_moredata - check if IEEE80211_FCTL_MOREDATA is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_moredata(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_MOREDATA)) != 0;
+}
+
+/**
+ * ieee80211_has_protected - check if IEEE80211_FCTL_PROTECTED is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_protected(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_PROTECTED)) != 0;
+}
+
+/**
+ * ieee80211_has_order - check if IEEE80211_FCTL_ORDER is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_order(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_ORDER)) != 0;
+}
+
+/**
+ * ieee80211_is_mgmt - check if type is IEEE80211_FTYPE_MGMT
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_mgmt(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT);
+}
+
+/**
+ * ieee80211_is_ctl - check if type is IEEE80211_FTYPE_CTL
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_ctl(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL);
+}
+
+/**
+ * ieee80211_is_data - check if type is IEEE80211_FTYPE_DATA
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_data(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA);
+}
+
+/**
+ * ieee80211_is_data_qos - check if type is IEEE80211_FTYPE_DATA and IEEE80211_STYPE_QOS_DATA is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_data_qos(__le16 fc)
+{
+	/*
+	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just need
+	 * to check the one bit
+	 */
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_QOS_DATA)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
+}
+
+/**
+ * ieee80211_is_data_present - check if type is IEEE80211_FTYPE_DATA and has data
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_data_present(__le16 fc)
+{
+	/*
+	 * mask with 0x40 and test that that bit is clear to only return true
+	 * for the data-containing substypes.
+	 */
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | 0x40)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA);
+}
+
+/**
+ * ieee80211_is_assoc_req - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_ASSOC_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_assoc_req(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ASSOC_REQ);
+}
+
+/**
+ * ieee80211_is_assoc_resp - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_ASSOC_RESP
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_assoc_resp(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ASSOC_RESP);
+}
+
+/**
+ * ieee80211_is_reassoc_req - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_REASSOC_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_reassoc_req(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_REASSOC_REQ);
+}
+
+/**
+ * ieee80211_is_reassoc_resp - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_REASSOC_RESP
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_reassoc_resp(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_REASSOC_RESP);
+}
+
+/**
+ * ieee80211_is_probe_req - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_PROBE_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_probe_req(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ);
+}
+
+/**
+ * ieee80211_is_probe_resp - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_PROBE_RESP
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_probe_resp(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP);
+}
+
+/**
+ * ieee80211_is_beacon - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_BEACON
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_beacon(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
+}
+
+/**
+ * ieee80211_is_atim - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_ATIM
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_atim(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ATIM);
+}
+
+/**
+ * ieee80211_is_disassoc - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_DISASSOC
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_disassoc(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_DISASSOC);
+}
+
+/**
+ * ieee80211_is_auth - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_AUTH
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_auth(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH);
+}
+
+/**
+ * ieee80211_is_deauth - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_DEAUTH
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_deauth(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_DEAUTH);
+}
+
+/**
+ * ieee80211_is_action - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_ACTION
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_action(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION);
+}
+
+/**
+ * ieee80211_is_back_req - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_BACK_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_back_req(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_BACK_REQ);
+}
+
+/**
+ * ieee80211_is_back - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_BACK
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_back(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_BACK);
+}
+
+/**
+ * ieee80211_is_pspoll - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_PSPOLL
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_pspoll(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
+}
+
+/**
+ * ieee80211_is_rts - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_RTS
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_rts(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
+}
+
+/**
+ * ieee80211_is_cts - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_CTS
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_cts(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
+}
+
+/**
+ * ieee80211_is_ack - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_ACK
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_ack(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_ACK);
+}
+
+/**
+ * ieee80211_is_cfend - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_CFEND
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_cfend(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CFEND);
+}
+
+/**
+ * ieee80211_is_cfendack - check if IEEE80211_FTYPE_CTL && IEEE80211_STYPE_CFENDACK
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_cfendack(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CFENDACK);
+}
+
+/**
+ * ieee80211_is_nullfunc - check if FTYPE=IEEE80211_FTYPE_DATA and STYPE=IEEE80211_STYPE_NULLFUNC
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_nullfunc(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC);
+}
 
 struct ieee80211s_hdr {
 	u8 flags;
@@ -552,48 +902,54 @@ enum ieee80211_back_parties {
 #define WLAN_MAX_KEY_LEN		32
 
 /**
+ * ieee80211_get_qos_ctl - get pointer to qos control bytes
+ * @hdr: the frame
+ *
+ * The qos ctrl bytes come after the frame_control, duration, seq_num
+ * and 3 or 4 addresses of length ETH_ALEN.
+ * 3 addr: 2 + 2 + 2 + 3*6 = 24
+ * 4 addr: 2 + 2 + 2 + 4*6 = 30
+ */
+static inline u8 *ieee80211_get_qos_ctl(struct ieee80211_hdr *hdr)
+{
+	if (ieee80211_has_a4(hdr->frame_control))
+		return (u8 *)hdr + 30;
+	else
+		return (u8 *)hdr + 24;
+}
+
+/**
  * ieee80211_get_SA - get pointer to SA
+ * @hdr: the frame
  *
  * Given an 802.11 frame, this function returns the offset
  * to the source address (SA). It does not verify that the
  * header is long enough to contain the address, and the
  * header must be long enough to contain the frame control
  * field.
- *
- * @hdr: the frame
  */
 static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
 {
-	__le16 fc = hdr->frame_control;
-	fc &= cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-
-	switch (fc) {
-	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
-		return hdr->addr3;
-	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS):
+	if (ieee80211_has_a4(hdr->frame_control))
 		return hdr->addr4;
-	default:
-		return hdr->addr2;
-	}
+	if (ieee80211_has_fromds(hdr->frame_control))
+		return hdr->addr3;
+	return hdr->addr2;
 }
 
 /**
  * ieee80211_get_DA - get pointer to DA
+ * @hdr: the frame
  *
  * Given an 802.11 frame, this function returns the offset
  * to the destination address (DA). It does not verify that
  * the header is long enough to contain the address, and the
  * header must be long enough to contain the frame control
  * field.
- *
- * @hdr: the frame
  */
 static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 {
-	__le16 fc = hdr->frame_control;
-	fc &= cpu_to_le16(IEEE80211_FCTL_TODS);
-
-	if (fc)
+	if (ieee80211_has_tods(hdr->frame_control))
 		return hdr->addr3;
 	else
 		return hdr->addr1;
-- 
1.5.6.rc2.261.ga8fbe


