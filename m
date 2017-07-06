Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34930 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbdGFOnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:43:07 -0400
Received: by mail-pf0-f193.google.com with SMTP id q85so562292pfq.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:43:06 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Subject: [v3 16/21] rsi: separate function for data packet descriptor
Date: Thu,  6 Jul 2017 20:07:19 +0530
Message-Id: <1499351844-2046-17-git-send-email-amitkarwar@gmail.com> (sfid-20170706_170042_507785_A61EAA7A)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>

Data packet descriptor preparation code is moved a separate
function.

Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 51 +++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index af7fe87..b0a7a15 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -108,25 +108,15 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	return 0;
 }
 
-/**
- * rsi_send_data_pkt() - This function sends the recieved data packet from
- *			 driver to device.
- * @common: Pointer to the driver private structure.
- * @skb: Pointer to the socket buffer structure.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
+/* This function prepares descriptor for given data packet */
+static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 {
-	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_hdr *wh = NULL;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_vif *vif = NULL;
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
 	struct rsi_data_desc *data_desc;
 	struct xtended_desc *xtend_desc;
-	int status;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
 	u8 header_size;
 	u8 vap_id = 0;
@@ -137,22 +127,16 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	bss = &info->control.vif->bss_conf;
 	tx_params = (struct skb_info *)info->driver_data;
 
-	if (!bss->assoc) {
-		status = -EINVAL;
-		goto err;
-	}
 	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
-		status = -ENOSPC;
-		goto err;
+		return -ENOSPC;
 	}
 	skb_push(skb, header_size);
 	dword_align_bytes = ((unsigned long)skb->data & 0x3f);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Not enough headroom\n", __func__);
-		status = -ENOSPC;
-		goto err;
+		return -ENOSPC;
 	}
 	skb_push(skb, dword_align_bytes);
 	header_size += dword_align_bytes;
@@ -164,7 +148,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 	seq_num = (le16_to_cpu(wh->seq_ctrl) >> 4);
-	vif = adapter->vifs[0];
 
 	data_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
 
@@ -227,11 +210,33 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		data_desc->sta_id = vap_id;
 	}
 
+	return 0;
+}
+
+/* This function sends received data packet from driver to device */
+int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_bss_conf *bss;
+	int status = -EIO;
+
+	info = IEEE80211_SKB_CB(skb);
+	bss = &info->control.vif->bss_conf;
+
+	if (!bss->assoc) {
+		status = -EINVAL;
+		goto err;
+	}
+
+	status = rsi_prepare_data_desc(common, skb);
+	if (status)
+		goto err;
+
 	status = adapter->host_intf_ops->write_pkt(common->priv, skb->data,
 						   skb->len);
 	if (status)
-		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n",
-			__func__);
+		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n", __func__);
 
 err:
 	++common->tx_stats.total_tx_pkt_freed[skb->priority];
-- 
2.7.4
