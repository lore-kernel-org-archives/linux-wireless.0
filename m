Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34929 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdFWOK3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:29 -0400
Received: by mail-pf0-f194.google.com with SMTP id s66so7530509pfs.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:28 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 04/17] rsi: remove unnecessary check for 802.11 management packet
Date: Fri, 23 Jun 2017 19:37:23 +0530
Message-Id: <1498226856-6305-5-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161032_723126_249D912C)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
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
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 56 ++++++++++++++-------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 77cb36a..c73007d 100644
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
@@ -412,41 +411,32 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
 	struct sk_buff *skb;
 	char *buffer;
 
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
 
-		buffer = skb_put(skb, msg_len);
+	buffer = skb_put(skb, msg_len);
 
-		memcpy(buffer,
-		       (u8 *)(msg +  FRAME_DESC_SZ + pad_bytes),
-		       msg_len);
+	memcpy(buffer, (u8 *)(msg +  FRAME_DESC_SZ + pad_bytes), msg_len);
 
-		pkt_recv = buffer[0];
+	pkt_recv = buffer[0];
 
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
@@ -1647,8 +1637,10 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
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
