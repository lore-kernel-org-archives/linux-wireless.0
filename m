Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50844 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZH0VAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:24 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 03/13] wl1271: Security sequence number handling for TX (for WPA)
Date: Thu, 27 Aug 2009 23:59:57 +0300
Message-Id: <1251406807-31495-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add security sequence number handling to the driver TX data path needed
by WPA.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    5 +++++
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   11 +++++++++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c |   13 +++++++++++--
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   11 +++++++++++
 5 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 55818f9..e575dcc 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -337,6 +337,11 @@ struct wl1271 {
 	/* Pending TX frames */
 	struct sk_buff *tx_frames[16];
 
+	/* Security sequence number counters */
+	u8 tx_security_last_seq;
+	u16 tx_security_seq_16;
+	u32 tx_security_seq_32;
+
 	/* FW Rx counter */
 	u32 rx_counter;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 2a4351f..1ee1b2b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -228,6 +228,10 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type, u8 dtim_interval,
 
 	join->ctrl |= wl->session_counter << WL1271_JOIN_CMD_TX_SESSION_OFFSET;
 
+	/* reset TX security counters */
+	wl->tx_security_last_seq = 0;
+	wl->tx_security_seq_16 = 0;
+	wl->tx_security_seq_32 = 0;
 
 	ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
 	if (ret < 0) {
@@ -759,7 +763,8 @@ out:
 }
 
 int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
-		       u8 key_size, const u8 *key, const u8 *addr)
+		       u8 key_size, const u8 *key, const u8 *addr,
+		       u32 tx_seq_32, u16 tx_seq_16)
 {
 	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
@@ -777,12 +782,14 @@ int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 	cmd->key_size = key_size;
 	cmd->key_type = key_type;
 
+	cmd->ac_seq_num16[0] = tx_seq_16;
+	cmd->ac_seq_num32[0] = tx_seq_32;
+
 	/* we have only one SSID profile */
 	cmd->ssid_profile = 0;
 
 	cmd->id = id;
 
-	/* FIXME: this is from wl1251, needs to be checked */
 	if (key_type == KEY_TKIP) {
 		/*
 		 * We get the key in the following form:
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 951a844..7c4d3aa 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -49,7 +49,8 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
 int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len);
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
 int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
-		       u8 key_size, const u8 *key, const u8 *addr);
+		       u8 key_size, const u8 *key, const u8 *addr,
+		       u32 tx_seq_32, u16 tx_seq_16);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d9169b4..7faa65f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -592,6 +592,9 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_blocks_available = 0;
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
+	wl->tx_security_last_seq = 0;
+	wl->tx_security_seq_16 = 0;
+	wl->tx_security_seq_32 = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	for (i = 0; i < NUM_TX_QUEUES; i++)
@@ -824,6 +827,8 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct wl1271 *wl = hw->priv;
 	const u8 *addr;
 	int ret;
+	u32 tx_seq_32 = 0;
+	u16 tx_seq_16 = 0;
 	u8 key_type;
 
 	static const u8 bcast_addr[ETH_ALEN] =
@@ -862,11 +867,15 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key_type = KEY_TKIP;
 
 		key_conf->hw_key_idx = key_conf->keyidx;
+		tx_seq_32 = wl->tx_security_seq_32;
+		tx_seq_16 = wl->tx_security_seq_16;
 		break;
 	case ALG_CCMP:
 		key_type = KEY_AES;
 
 		key_conf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		tx_seq_32 = wl->tx_security_seq_32;
+		tx_seq_16 = wl->tx_security_seq_16;
 		break;
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->alg);
@@ -880,7 +889,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = wl1271_cmd_set_key(wl, KEY_ADD_OR_REPLACE,
 					 key_conf->keyidx, key_type,
 					 key_conf->keylen, key_conf->key,
-					 addr);
+					 addr, tx_seq_32, tx_seq_16);
 		if (ret < 0) {
 			wl1271_error("Could not add or replace key");
 			goto out_sleep;
@@ -891,7 +900,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = wl1271_cmd_set_key(wl, KEY_REMOVE,
 					 key_conf->keyidx, key_type,
 					 key_conf->keylen, key_conf->key,
-					 addr);
+					 addr, 0, 0);
 		if (ret < 0) {
 			wl1271_error("Could not remove key");
 			goto out_sleep;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 0c19688..162f026 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -258,6 +258,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
 	u32 header_len;
+	u16 seq;
 	int id = result->id;
 
 	/* check for id legality */
@@ -284,6 +285,16 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	/* info->status.retry_count = result->ack_failures; */
 	wl->stats.retry_count += result->ack_failures;
 
+	/* update security sequence number */
+	seq = wl->tx_security_seq_16 +
+		(result->lsb_security_sequence_number -
+		 wl->tx_security_last_seq);
+	wl->tx_security_last_seq = result->lsb_security_sequence_number;
+
+	if (seq < wl->tx_security_seq_16)
+		wl->tx_security_seq_32++;
+	wl->tx_security_seq_16 = seq;
+
 	/* get header len */
 	if (info->control.hw_key &&
 	    info->control.hw_key->alg == ALG_TKIP)
-- 
1.5.6.5

