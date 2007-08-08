Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966AbXHHHiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 21/28] iwlwifi: remove WLAN_FC_GET_TYPE macros
Date: Wed,  8 Aug 2007 15:33:38 +0800
Message-Id: <11865584754153-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584733882-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use IEEE80211_FCTL_FTYPE directly. Also make some inline function unlined.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c    |    9 ++-
 drivers/net/wireless/iwl-4965.c    |   14 +++--
 drivers/net/wireless/iwl-base.c    |   78 ++++++++++++++++++++---
 drivers/net/wireless/iwl-helpers.h |  122 ++++++++----------------------------
 drivers/net/wireless/iwlwifi.h     |    1 +
 5 files changed, 111 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 6cec308..53fba5d 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -395,9 +395,10 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 		priv->last_rx_noise = stats.noise;
 	}
 
-	switch (WLAN_FC_GET_TYPE(le16_to_cpu(header->frame_control))) {
+	switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
-		switch (WLAN_FC_GET_STYPE(le16_to_cpu(header->frame_control))) {
+		switch (le16_to_cpu(header->frame_control) &
+			IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_PROBE_RESP:
 		case IEEE80211_STYPE_BEACON:{
 				/* If this is a beacon or probe response for
@@ -632,8 +633,8 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	if (priv->data_retry_limit != -1)
 		data_retry_limit = priv->data_retry_limit;
 
-	if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) {
-		switch (WLAN_FC_GET_STYPE(fc)) {
+	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
+		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_AUTH:
 		case IEEE80211_STYPE_DEAUTH:
 		case IEEE80211_STYPE_ASSOC_REQ:
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 76c0c98..631bd19 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2655,8 +2655,10 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	if (priv->data_retry_limit != -1)
 		data_retry_limit = priv->data_retry_limit;
 
-	if (WLAN_FC_GET_TYPE(hdr->frame_control) == IEEE80211_FTYPE_MGMT) {
-		switch (WLAN_FC_GET_STYPE(hdr->frame_control)) {
+	if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_FTYPE)
+			== IEEE80211_FTYPE_MGMT) {
+		switch (le16_to_cpu(hdr->frame_control) &
+			IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_AUTH:
 		case IEEE80211_STYPE_DEAUTH:
 		case IEEE80211_STYPE_ASSOC_REQ:
@@ -3233,7 +3235,7 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	unicast = !is_multicast_ether_addr(hdr->addr1);
 
 	fc = le16_to_cpu(hdr->frame_control);
-	if (WLAN_FC_GET_TYPE(fc) != IEEE80211_FTYPE_DATA)
+	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		is_data = 0;
 
 	memcpy(&cmd, &(out_cmd->cmd.tx), sizeof(struct iwl_tx_cmd));
@@ -3896,13 +3898,13 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	}
 
 	fc = le16_to_cpu(header->frame_control);
-	switch (WLAN_FC_GET_TYPE(fc)) {
+	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
 
 		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
 			iwl4965_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
 						header->addr2);
-		switch (WLAN_FC_GET_STYPE(fc)) {
+		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_PROBE_RESP:
 		case IEEE80211_STYPE_BEACON:
 			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA &&
@@ -3990,7 +3992,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 
 	case IEEE80211_FTYPE_CTL:
 #ifdef CONFIG_IWLWIFI_HT_AGG
-		switch (WLAN_FC_GET_STYPE(fc)) {
+		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_BACK_REQ:
 			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
 			iwl4965_handle_data_packet(priv, 0, include_phy,
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 7514928..efd4762 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -122,6 +122,68 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
+__le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
+{
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	int hdr_len = ieee80211_get_hdrlen(fc);
+
+	if ((fc & 0x00cc) == (IEEE80211_STYPE_QOS_DATA | IEEE80211_FTYPE_DATA))
+		return (__le16 *) ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
+	return NULL;
+}
+
+static const struct ieee80211_hw_mode *iwl_get_hw_mode(
+		struct iwl_priv *priv, int mode)
+{
+	int i;
+
+	for (i = 0; i < 3; i++)
+		if (priv->modes[i].mode == mode)
+			return &priv->modes[i];
+
+	return NULL;
+}
+
+static int iwl_is_empty_essid(const char *essid, int essid_len)
+{
+	/* Single white space is for Linksys APs */
+	if (essid_len == 1 && essid[0] == ' ')
+		return 1;
+
+	/* Otherwise, if the entire essid is 0, we assume it is hidden */
+	while (essid_len) {
+		essid_len--;
+		if (essid[essid_len] != '\0')
+			return 0;
+	}
+
+	return 1;
+}
+
+static const char *iwl_escape_essid(const char *essid, u8 essid_len)
+{
+	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
+	const char *s = essid;
+	char *d = escaped;
+
+	if (iwl_is_empty_essid(essid, essid_len)) {
+		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
+		return escaped;
+	}
+
+	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
+	while (essid_len--) {
+		if (*s == '\0') {
+			*d++ = '\\';
+			*d++ = '0';
+			s++;
+		} else
+			*d++ = *s++;
+	}
+	*d = '\0';
+	return escaped;
+}
+
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -2693,7 +2755,7 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(ctrl->flags & IEEE80211_TXCTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
-		if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT)
+		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 		if (ieee80211_is_probe_response(fc) &&
 		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
@@ -2726,9 +2788,9 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
 
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
-	if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) {
-		if (((WLAN_FC_GET_STYPE(fc)) == IEEE80211_STYPE_ASSOC_REQ) ||
-		    ((WLAN_FC_GET_STYPE(fc)) == IEEE80211_STYPE_REASSOC_REQ))
+	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
+		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ ||
+		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
 			cmd->cmd.tx.timeout.pm_frame_timeout =
 				cpu_to_le16(3);
 		else
@@ -2749,7 +2811,7 @@ static int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 
 	/* If this frame is broadcast or not data then use the broadcast
 	 * station id */
-	if ((WLAN_FC_GET_TYPE(fc) != IEEE80211_FTYPE_DATA) ||
+	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
 	    is_multicast_ether_addr(hdr->addr1))
 		return IWL_BROADCAST_ID;
 
@@ -2838,7 +2900,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 #endif
 
 	if (!iwl_is_associated(priv) &&
-	    (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA)) {
+	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
 		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
 		goto drop;
 	}
@@ -3232,8 +3294,8 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 {
 	u16 sc = le16_to_cpu(header->seq_ctrl);
-	u16 seq = WLAN_GET_SEQ_SEQ(sc);
-	u16 frag = WLAN_GET_SEQ_FRAG(sc);
+	u16 seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
+	u16 frag = sc & IEEE80211_SCTL_FRAG;
 	u16 *last_seq, *last_frag;
 	unsigned long *last_time;
 
diff --git a/drivers/net/wireless/iwl-helpers.h b/drivers/net/wireless/iwl-helpers.h
index 46084f2..6ac119f 100644
--- a/drivers/net/wireless/iwl-helpers.h
+++ b/drivers/net/wireless/iwl-helpers.h
@@ -145,139 +145,97 @@ static inline struct ieee80211_conf *ieee80211_get_hw_conf(
 	return &hw->conf;
 }
 
-static inline const struct ieee80211_hw_mode *iwl_get_hw_mode(
-	struct iwl_priv *priv, int mode)
-{
-	int i;
-
-	for (i = 0; i < 3; i++)
-		if (priv->modes[i].mode == mode)
-			return &priv->modes[i];
-
-	return NULL;
-}
-
-#define WLAN_FC_GET_TYPE(fc)    (((fc) & IEEE80211_FCTL_FTYPE))
-#define WLAN_FC_GET_STYPE(fc)   (((fc) & IEEE80211_FCTL_STYPE))
-#define WLAN_GET_SEQ_FRAG(seq)  ((seq) & 0x000f)
-#define WLAN_GET_SEQ_SEQ(seq)   ((seq) >> 4)
-
 #define QOS_CONTROL_LEN 2
 
-static inline __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
-{
-	u16 fc = le16_to_cpu(hdr->frame_control);
-	int hdr_len = ieee80211_get_hdrlen(fc);
-	if ( (fc & 0x00cc) == (IEEE80211_STYPE_QOS_DATA|IEEE80211_FTYPE_DATA))
-		return (__le16 *) ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
-	return NULL;
-}
-
 #define IEEE80211_STYPE_BACK_REQ	0x0080
 #define IEEE80211_STYPE_BACK		0x0090
 
 
 static inline int ieee80211_is_management(u16 fc)
 {
-	return WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT;
+	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT;
 }
 
 static inline int ieee80211_is_control(u16 fc)
 {
-	return WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_CTL;
+	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL;
 }
 
 static inline int ieee80211_is_data(u16 fc)
 {
-	return WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA;
+	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA;
 }
 
 static inline int ieee80211_is_back_request(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_CTL) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_BACK_REQ);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BACK_REQ);
 }
 
 static inline int ieee80211_is_probe_response(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_PROBE_RESP);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP);
 }
 
 static inline int ieee80211_is_probe_request(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_PROBE_REQ);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_REQ);
 }
 
 static inline int ieee80211_is_beacon(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_BEACON);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON);
 }
 
 static inline int ieee80211_is_atim(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_ATIM);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ATIM);
 }
 
 static inline int ieee80211_is_assoc_request(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_ASSOC_REQ);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
 }
 
 static inline int ieee80211_is_assoc_response(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_ASSOC_RESP);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_RESP);
 }
 
 static inline int ieee80211_is_auth(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_ASSOC_REQ);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
 }
 
 static inline int ieee80211_is_deauth(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_ASSOC_REQ);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
 }
 
 static inline int ieee80211_is_disassoc(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_ASSOC_REQ);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ);
 }
 
 static inline int ieee80211_is_reassoc_request(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_REASSOC_REQ);
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ);
 }
 
 static inline int ieee80211_is_reassoc_response(u16 fc)
 {
-	return (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) &&
-	       (WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_REASSOC_RESP);
-}
-
-static inline int iwl_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_RESP);
 }
 
 static inline int iwl_check_bits(unsigned long field, unsigned long mask)
@@ -285,30 +243,6 @@ static inline int iwl_check_bits(unsigned long field, unsigned long mask)
 	return ((field & mask) == mask) ? 1 : 0;
 }
 
-static inline const char *iwl_escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (iwl_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else
-			*d++ = *s++;
-	}
-	*d = '\0';
-	return escaped;
-}
-
 static inline unsigned long elapsed_jiffies(unsigned long start,
 					    unsigned long end)
 {
@@ -318,8 +252,6 @@ static inline unsigned long elapsed_jiffies(unsigned long start,
 	return end + (MAX_JIFFY_OFFSET - start);
 }
 
-
-
 static inline int snprint_line(char *buf, size_t count,
 			       const u8 *data, u32 len, u32 ofs)
 {
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index 5b826bf..1279a2b 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -639,6 +639,7 @@ extern int iwl_send_statistics_request(struct iwl_priv *priv);
 extern void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
+extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
 
 extern const u8 BROADCAST_ADDR[ETH_ALEN];
 
-- 
1.5.2
