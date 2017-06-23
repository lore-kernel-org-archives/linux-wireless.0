Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32863 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdFWOKt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:49 -0400
Received: by mail-pg0-f65.google.com with SMTP id u62so6285797pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:49 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 10/17] rsi: update set_key command frame
Date: Fri, 23 Jun 2017 19:37:29 +0530
Message-Id: <1498226856-6305-11-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161053_333652_56EF5811)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

TX command frame set_key is modified to use common descriptor
structure.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 26 +++++++++++++-------------
 drivers/net/wireless/rsi/rsi_mgmt.h     | 16 +++++++++++++++-
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 9fdf7b12..9d74495 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -713,39 +713,39 @@ int rsi_hal_load_key(struct rsi_common *common,
 	struct sk_buff *skb = NULL;
 	struct rsi_set_key *set_key;
 	u16 key_descriptor = 0;
+	u16 frame_len = sizeof(struct rsi_set_key);
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending load key frame\n", __func__);
 
-	skb = dev_alloc_skb(sizeof(struct rsi_set_key));
+	skb = dev_alloc_skb(frame_len);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
 			__func__);
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, sizeof(struct rsi_set_key));
+	memset(skb->data, 0, frame_len);
 	set_key = (struct rsi_set_key *)skb->data;
 
 	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
 	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
 		key_len += 1;
-		key_descriptor |= BIT(2);
+		key_descriptor |= RSI_WEP_KEY;
 		if (key_len >= 13)
-			key_descriptor |= BIT(3);
+			key_descriptor |= RSI_WEP_KEY_104;
 	} else if (cipher != KEY_TYPE_CLEAR) {
-		key_descriptor |= BIT(4);
+		key_descriptor |= RSI_CIPHER_WPA;
 		if (key_type == RSI_PAIRWISE_KEY)
 			key_id = 0;
 		if (cipher == WLAN_CIPHER_SUITE_TKIP)
-			key_descriptor |= BIT(5);
+			key_descriptor |= RSI_CIPHER_TKIP;
 	}
-	key_descriptor |= (key_type | BIT(13) | (key_id << 14));
+	key_descriptor |= (key_type | RSI_PROTECT_DATA_FRAMES | (key_id << 14));
 
-	set_key->desc_word[0] = cpu_to_le16((sizeof(struct rsi_set_key) -
-					    FRAME_DESC_SZ) |
-					    (RSI_WIFI_MGMT_Q << 12));
-	set_key->desc_word[1] = cpu_to_le16(SET_KEY_REQ);
-	set_key->desc_word[4] = cpu_to_le16(key_descriptor);
+	rsi_set_len_qno(&set_key->desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
+	set_key->desc_dword0.frame_type = SET_KEY_REQ;
+	set_key->key_desc = cpu_to_le16(key_descriptor);
 
 	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
 	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
@@ -759,7 +759,7 @@ int rsi_hal_load_key(struct rsi_common *common,
 	memcpy(set_key->tx_mic_key, &data[16], 8);
 	memcpy(set_key->rx_mic_key, &data[24], 8);
 
-	skb_put(skb, sizeof(struct rsi_set_key));
+	skb_put(skb, frame_len);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index fcde44e..5df64d3 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -348,8 +348,22 @@ struct rsi_vap_caps {
 	__le16 beacon_miss_threshold;
 } __packed;
 
+/* Key descriptor flags */
+#define RSI_KEY_TYPE_BROADCAST	BIT(1)
+#define RSI_WEP_KEY		BIT(2)
+#define RSI_WEP_KEY_104		BIT(3)
+#define RSI_CIPHER_WPA		BIT(4)
+#define RSI_CIPHER_TKIP		BIT(5)
+#define RSI_PROTECT_DATA_FRAMES	BIT(13)
+#define RSI_KEY_ID_MASK		0xC0
+#define RSI_KEY_ID_OFFSET	14
 struct rsi_set_key {
-	__le16 desc_word[8];
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	struct rsi_cmd_desc_dword1 desc_dword1;
+	__le16 key_desc;
+	__le32 bpn;
+	u8 sta_id;
+	u8 vap_id;
 	u8 key[4][32];
 	u8 tx_mic_key[8];
 	u8 rx_mic_key[8];
-- 
2.7.4
