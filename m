Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32976 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeC2OPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 10:15:25 -0400
Received: by mail-pf0-f196.google.com with SMTP id f15so3320839pfn.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2018 07:15:25 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 1/4] rsi: move xtend_desc structure from rsi_main.h to rsi_mgmt.h
Date: Thu, 29 Mar 2018 19:32:26 +0530
Message-Id: <1522332149-5100-2-git-send-email-amitkarwar@gmail.com> (sfid-20180329_161529_348561_8A873BDC)
In-Reply-To: <1522332149-5100-1-git-send-email-amitkarwar@gmail.com>
References: <1522332149-5100-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

All descriptor structures are in rsi_mgmt.h except this
extended descriptor structure. Hence moving it to rsi_mgmt.h
and also renaming to rsi_xtend_desc.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 12 ++++++------
 drivers/net/wireless/rsi/rsi_main.h    |  6 ------
 drivers/net/wireless/rsi/rsi_mgmt.h    |  6 ++++++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index de608ae..ce6a86d 100644
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
@@ -158,7 +158,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
 	struct rsi_data_desc *data_desc;
-	struct xtended_desc *xtend_desc;
+	struct rsi_xtended_desc *xtend_desc;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
 	u8 header_size;
 	u8 vap_id = 0;
@@ -170,7 +170,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	bss = &vif->bss_conf;
 	tx_params = (struct skb_info *)info->driver_data;
 
-	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
+	header_size = FRAME_DESC_SZ + sizeof(struct rsi_xtended_desc);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
 		return -ENOSPC;
@@ -188,7 +188,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	data_desc = (struct rsi_data_desc *)skb->data;
 	memset(data_desc, 0, header_size);
 
-	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
+	xtend_desc = (struct rsi_xtended_desc *)&skb->data[FRAME_DESC_SZ];
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 	seq_num = IEEE80211_SEQ_TO_SN(le16_to_cpu(wh->seq_ctrl));
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index ef4fa32..b81cdbf 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -190,12 +190,6 @@ struct cqm_info {
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
index cf6567a..6726e84 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -301,6 +301,12 @@ struct rsi_mac_frame {
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
