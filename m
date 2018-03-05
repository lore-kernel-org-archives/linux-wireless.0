Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:35333 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbeCEOs7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:48:59 -0500
Received: by mail-pl0-f68.google.com with SMTP id bb3-v6so9767866plb.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:48:59 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 03/10] rsi: move descriptor preparation to core
Date: Mon,  5 Mar 2018 20:06:53 +0530
Message-Id: <1520260620-4694-4-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154906_695320_11058355)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

To avoid synchronization issues in sending TX frames,
descriptors preparation is moved to core, instead of HAL.
This will avoid races during foreground scan because of mgmt
configurations.
Also xtended descriptor is moved from rsi_main.h to rsi_mgmt.h
as all descriptor information is in rsi_mgmt.h

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 11 +++++++++
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 43 +++++++++++++++++----------------
 drivers/net/wireless/rsi/rsi_hal.h      |  2 ++
 3 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 5dafd2e..f5d1756 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -413,6 +413,11 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	    (ieee80211_is_qos_nullfunc(wh->frame_control))) {
 		q_num = MGMT_SOFT_Q;
 		skb->priority = q_num;
+
+		if (rsi_prepare_mgmt_desc(common, skb)) {
+			rsi_dbg(ERR_ZONE, "Failed to prepare desc\n");
+			goto xmit_fail;
+		}
 	} else {
 		if (ieee80211_is_data_qos(wh->frame_control)) {
 			tid = (skb->data[24] & IEEE80211_QOS_TID);
@@ -433,6 +438,8 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			if (!rsta)
 				goto xmit_fail;
 			tx_params->sta_id = rsta->sta_id;
+		} else {
+			tx_params->sta_id = 0;
 		}
 
 		if (rsta) {
@@ -443,6 +450,10 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 							      tid, 0);
 			}
 		}
+		if (rsi_prepare_data_desc(common, skb)) {
+			rsi_dbg(ERR_ZONE, "Failed to prepare data desc\n");
+			goto xmit_fail;
+		}
 	}
 
 	if ((q_num < MGMT_SOFT_Q) &&
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 718f793..7e04daf 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -45,7 +45,7 @@ int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb)
 	return status;
 }
 
-static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
+int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_hdr *wh = NULL;
@@ -116,17 +116,6 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	if (conf_is_ht40(conf))
 		mgmt_desc->bbp_info = cpu_to_le16(FULL40M_ENABLE);
 
-	if (ieee80211_is_probe_req(wh->frame_control)) {
-		if (!bss->assoc) {
-			rsi_dbg(INFO_ZONE,
-				"%s: blocking mgmt queue\n", __func__);
-			mgmt_desc->misc_flags = RSI_DESC_REQUIRE_CFM_TO_HOST;
-			xtend_desc->confirm_frame_type = PROBEREQ_CONFIRM;
-			common->mgmt_q_block = true;
-			rsi_dbg(INFO_ZONE, "Mgmt queue blocked\n");
-		}
-	}
-
 	if (ieee80211_is_probe_resp(wh->frame_control)) {
 		mgmt_desc->misc_flags |= (RSI_ADD_DELTA_TSF_VAP_ID |
 					  RSI_FETCH_RETRY_CNT_FRM_HST);
@@ -152,7 +141,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 }
 
 /* This function prepares descriptor for given data packet */
-static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
+int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_vif *vif;
@@ -304,10 +293,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	    (!bss->assoc))
 		goto err;
 
-	status = rsi_prepare_data_desc(common, skb);
-	if (status)
-		goto err;
-
 	status = rsi_send_pkt_to_bus(common, skb);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n", __func__);
@@ -330,12 +315,18 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		      struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_bss_conf *bss;
+	struct ieee80211_hdr *wh;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
+	struct rsi_mgmt_desc *mgmt_desc;
+	struct rsi_xtended_desc *xtend_desc;
 	int status = -E2BIG;
+	u8 header_size;
 
 	info = IEEE80211_SKB_CB(skb);
 	tx_params = (struct skb_info *)info->driver_data;
+	header_size = tx_params->internal_hdr_size;
 
 	if (tx_params->flags & INTERNAL_MGMT_PKT) {
 		status = adapter->host_intf_ops->write_pkt(common->priv,
@@ -349,15 +340,25 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		return status;
 	}
 
-	if (FRAME_DESC_SZ > skb_headroom(skb))
-		goto err;
+	bss = &info->control.vif->bss_conf;
+	wh = (struct ieee80211_hdr *)&skb->data[header_size];
+	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
+	xtend_desc = (struct rsi_xtended_desc *)&skb->data[FRAME_DESC_SZ];
+
+	/* Indicate to firmware to give cfm for probe */
+	if (ieee80211_is_probe_req(wh->frame_control) && !bss->assoc) {
+		rsi_dbg(INFO_ZONE,
+			"%s: blocking mgmt queue\n", __func__);
+		mgmt_desc->misc_flags = RSI_DESC_REQUIRE_CFM_TO_HOST;
+		xtend_desc->confirm_frame_type = PROBEREQ_CONFIRM;
+		common->mgmt_q_block = true;
+		rsi_dbg(INFO_ZONE, "Mgmt queue blocked\n");
+	}
 
-	rsi_prepare_mgmt_desc(common, skb);
 	status = rsi_send_pkt_to_bus(common, skb);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
 
-err:
 	rsi_indicate_tx_status(common->priv, skb, status);
 	return status;
 }
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 786dccd..d6c2baa 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -167,6 +167,8 @@ struct rsi_bt_desc {
 } __packed;
 
 int rsi_hal_device_init(struct rsi_hw *adapter);
+int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb);
+int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb);
 int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_bt_pkt(struct rsi_common *common, struct sk_buff *skb);
-- 
2.7.4
