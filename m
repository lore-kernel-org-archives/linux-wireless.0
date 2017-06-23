Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32893 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdFWOK6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:58 -0400
Received: by mail-pg0-f65.google.com with SMTP id u62so6285977pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:53 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 11/17] rsi: set_key enhancements
Date: Fri, 23 Jun 2017 19:37:30 +0530
Message-Id: <1498226856-6305-12-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161102_718299_FEF0DCBE)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Broadcast bit to be set for broadcast and multicast packets.
For remove_key, tx and rx mic need not be filled.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 9d74495..538a962 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -727,38 +727,40 @@ int rsi_hal_load_key(struct rsi_common *common,
 	memset(skb->data, 0, frame_len);
 	set_key = (struct rsi_set_key *)skb->data;
 
+	if (key_type == RSI_GROUP_KEY)
+		key_descriptor = RSI_KEY_TYPE_BROADCAST;
 	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
 	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
-		key_len += 1;
+		key_id = 0;
 		key_descriptor |= RSI_WEP_KEY;
 		if (key_len >= 13)
 			key_descriptor |= RSI_WEP_KEY_104;
 	} else if (cipher != KEY_TYPE_CLEAR) {
 		key_descriptor |= RSI_CIPHER_WPA;
-		if (key_type == RSI_PAIRWISE_KEY)
-			key_id = 0;
 		if (cipher == WLAN_CIPHER_SUITE_TKIP)
 			key_descriptor |= RSI_CIPHER_TKIP;
 	}
-	key_descriptor |= (key_type | RSI_PROTECT_DATA_FRAMES | (key_id << 14));
+	key_descriptor |= RSI_PROTECT_DATA_FRAMES;
+	key_descriptor |= ((key_id << RSI_KEY_ID_OFFSET) & RSI_KEY_ID_MASK);
 
 	rsi_set_len_qno(&set_key->desc_dword0.len_qno,
 			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
 	set_key->desc_dword0.frame_type = SET_KEY_REQ;
 	set_key->key_desc = cpu_to_le16(key_descriptor);
 
-	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
-	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
-		memcpy(&set_key->key[key_id][1],
-		       data,
-		       key_len * 2);
+	if (data) {
+		if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
+		    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
+			memcpy(&set_key->key[key_id][1], data, key_len * 2);
+		} else {
+			memcpy(&set_key->key[0][0], data, key_len);
+		}
+		memcpy(set_key->tx_mic_key, &data[16], 8);
+		memcpy(set_key->rx_mic_key, &data[24], 8);
 	} else {
-		memcpy(&set_key->key[0][0], data, key_len);
+		memset(&set_key[FRAME_DESC_SZ], 0, frame_len - FRAME_DESC_SZ);
 	}
 
-	memcpy(set_key->tx_mic_key, &data[16], 8);
-	memcpy(set_key->rx_mic_key, &data[24], 8);
-
 	skb_put(skb, frame_len);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
-- 
2.7.4
