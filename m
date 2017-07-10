Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36439 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdGJMoh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:44:37 -0400
Received: by mail-pf0-f196.google.com with SMTP id z6so14394028pfk.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:44:32 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 04/17] rsi: remove unnecessary check for 802.11 management packet
Date: Mon, 10 Jul 2017 18:10:35 +0530
Message-Id: <1499690448-9956-5-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144442_500217_BDD0EE85)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

The function rsi_mgmt_pkt_to_core() is for passing the 802.11
management frames to mac80211. So, it is unnecessary to check
again for the frame type 802.11 management in this function.
It can be checked before passing to this function.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 54 +++++++++++++++------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 65d2dd6..3724dd4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -401,8 +401,7 @@ static int rsi_load_radio_caps(struct rsi_common *common)
  */
 static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
 				u8 *msg,
-				s32 msg_len,
-				u8 type)
+				s32 msg_len)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_tx_info *info;
@@ -410,37 +409,30 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
 	u8 pad_bytes = msg[4];
 	struct sk_buff *skb;
 
-	if (type == RX_DOT11_MGMT) {
-		if (!adapter->sc_nvifs)
-			return -ENOLINK;
+	if (!adapter->sc_nvifs)
+		return -ENOLINK;
 
-		msg_len -= pad_bytes;
-		if (msg_len <= 0) {
-			rsi_dbg(MGMT_RX_ZONE,
-				"%s: Invalid rx msg of len = %d\n",
-				__func__, msg_len);
-			return -EINVAL;
-		}
+	msg_len -= pad_bytes;
+	if (msg_len <= 0) {
+		rsi_dbg(MGMT_RX_ZONE,
+			"%s: Invalid rx msg of len = %d\n",
+			__func__, msg_len);
+		return -EINVAL;
+	}
 
-		skb = dev_alloc_skb(msg_len);
-		if (!skb) {
-			rsi_dbg(ERR_ZONE, "%s: Failed to allocate skb\n",
-				__func__);
-			return -ENOMEM;
-		}
+	skb = dev_alloc_skb(msg_len);
+	if (!skb)
+		return -ENOMEM;
 
-		skb_put_data(skb,
-			     (u8 *)(msg + FRAME_DESC_SZ + pad_bytes),
-			     msg_len);
+	skb_put_data(skb,
+		     (u8 *)(msg + FRAME_DESC_SZ + pad_bytes),
+		     msg_len);
 
-		info = IEEE80211_SKB_CB(skb);
-		rx_params = (struct skb_info *)info->driver_data;
-		rx_params->rssi = rsi_get_rssi(msg);
-		rx_params->channel = rsi_get_channel(msg);
-		rsi_indicate_pkt_to_os(common, skb);
-	} else {
-		rsi_dbg(MGMT_TX_ZONE, "%s: Internal Packet\n", __func__);
-	}
+	info = IEEE80211_SKB_CB(skb);
+	rx_params = (struct skb_info *)info->driver_data;
+	rx_params->rssi = rsi_get_rssi(msg);
+	rx_params->channel = rsi_get_channel(msg);
+	rsi_indicate_pkt_to_os(common, skb);
 
 	return 0;
 }
@@ -1641,8 +1633,10 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
 				__func__);
 		}
+	} else if (msg_type == RX_DOT11_MGMT) {
+		return rsi_mgmt_pkt_to_core(common, msg, msg_len);
 	} else {
-		return rsi_mgmt_pkt_to_core(common, msg, msg_len, msg_type);
+		rsi_dbg(INFO_ZONE, "Received packet type: 0x%x\n", msg_type);
 	}
 	return 0;
 }
-- 
2.7.4
