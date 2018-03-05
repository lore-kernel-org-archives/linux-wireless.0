Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36655 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbeCEOs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:48:56 -0500
Received: by mail-pg0-f65.google.com with SMTP id i14so6904706pgv.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:48:55 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 02/10] rsi: move xtend_desc structure from rsi_main.h to rsi_mgmt.h
Date: Mon,  5 Mar 2018 20:06:52 +0530
Message-Id: <1520260620-4694-3-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154908_970766_C454DE05)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

All descriptor structures are in rsi_mgmt.h except this
extended descriptor structure. Hence moving it to rsi_mgmt.h
and also renaming to rsi_xtend_desc.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 12 ++++++------
 drivers/net/wireless/rsi/rsi_main.h    |  6 ------
 drivers/net/wireless/rsi/rsi_mgmt.h    |  6 ++++++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 20c2f6b..718f793 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -55,7 +55,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_mgmt_desc *mgmt_desc;
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss = NULL;
-	struct xtended_desc *xtend_desc = NULL;
+	struct rsi_xtended_desc *xtend_desc = NULL;
 	u8 header_size;
 	u32 dword_align_bytes = 0;
 
@@ -69,7 +69,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	vif = tx_params->vif;
 
 	/* Update header size */
-	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
+	header_size = FRAME_DESC_SZ + sizeof(struct rsi_xtended_desc);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Failed to add extended descriptor\n",
@@ -92,7 +92,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 
 	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
-	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
+	xtend_desc = (struct rsi_xtended_desc *)&skb->data[FRAME_DESC_SZ];
 
 	rsi_set_len_qno(&mgmt_desc->len_qno, (skb->len - FRAME_DESC_SZ),
 			RSI_WIFI_MGMT_Q);
@@ -161,7 +161,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
 	struct rsi_data_desc *data_desc;
-	struct xtended_desc *xtend_desc;
+	struct rsi_xtended_desc *xtend_desc;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
 	u8 header_size;
 	u8 vap_id = 0;
@@ -173,7 +173,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	bss = &vif->bss_conf;
 	tx_params = (struct skb_info *)info->driver_data;
 
-	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
+	header_size = FRAME_DESC_SZ + sizeof(struct rsi_xtended_desc);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
 		return -ENOSPC;
@@ -191,7 +191,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	data_desc = (struct rsi_data_desc *)skb->data;
 	memset(data_desc, 0, header_size);
 
-	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
+	xtend_desc = (struct rsi_xtended_desc *)&skb->data[FRAME_DESC_SZ];
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 	seq_num = IEEE80211_SEQ_TO_SN(le16_to_cpu(wh->seq_ctrl));
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 3dd08f5..abc4f29 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -212,12 +212,6 @@ struct cqm_info {
 	u32 rssi_hyst;
 };
 
-struct xtended_desc {
-	u8 confirm_frame_type;
-	u8 retry_cnt;
-	u16 reserved;
-};
-
 enum rsi_dfs_regions {
 	RSI_REGION_FCC = 0,
 	RSI_REGION_ETSI,
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index b7f63c9..2513fb8 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -307,6 +307,12 @@ struct rsi_mac_frame {
 #define ENCAP_MGMT_PKT			BIT(7)
 #define DESC_IMMEDIATE_WAKEUP		BIT(15)
 
+struct rsi_xtended_desc {
+	u8 confirm_frame_type;
+	u8 retry_cnt;
+	u16 reserved;
+};
+
 struct rsi_cmd_desc_dword0 {
 	__le16 len_qno;
 	u8 frame_type;
-- 
2.7.4
