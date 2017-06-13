Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34080 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753527AbdFMOwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:34 -0400
Received: by mail-pg0-f67.google.com with SMTP id v14so19233931pgn.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:34 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "pavani.muthyala" <pavani.muthyala@redpinesignals.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 15/20] rsi: separate function for data packet descriptor
Date: Tue, 13 Jun 2017 20:19:03 +0530
Message-Id: <1497365348-2305-16-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_170119_948801_9E2C49EA)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "pavani.muthyala" <pavani.muthyala@redpinesignals.com>

Data packet descriptor preparation code is moved a separate
function.

Signed-off-by: pavani.muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 41 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 20cb608..8fcbadc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -111,15 +111,8 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
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
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_hdr *wh = NULL;
@@ -129,7 +122,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_bss_conf *bss;
 	struct rsi_data_desc *data_desc;
 	struct xtended_desc *xtend_desc;
-	int status;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
 	u8 header_size = 0;
 	u8 vap_id = 0;
@@ -140,22 +132,19 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	bss = &info->control.vif->bss_conf;
 	tx_params = (struct skb_info *)info->driver_data;
 
-	if (!bss->assoc) {
-		status = -EINVAL;
-		goto err;
-	}
+	if (!bss->assoc)
+		return -EINVAL;
+
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
@@ -232,11 +221,23 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		data_desc->sta_id = vap_id;
 	}
 
+	return 0;
+}
+
+/* This function sends received data packet from driver to device */
+int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	int status;
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
