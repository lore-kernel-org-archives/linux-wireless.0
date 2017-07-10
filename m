Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34868 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754114AbdGJMpG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:45:06 -0400
Received: by mail-pg0-f67.google.com with SMTP id d193so12603682pgc.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:45:05 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 05/17] rsi: Update peer notify command frame
Date: Mon, 10 Jul 2017 18:10:36 +0530
Message-Id: <1499690448-9956-6-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144534_183989_F81C3697)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

TX command frame peer notify is updated to use common descriptor
structure. MPDU density value added to the frame.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 19 ++++++++++---------
 drivers/net/wireless/rsi/rsi_mgmt.h     |  4 +++-
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 3724dd4..fd9bcd7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -460,10 +460,11 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 	struct rsi_peer_notify *peer_notify;
 	u16 vap_id = 0;
 	int status;
+	u16 frame_len = sizeof(struct rsi_peer_notify);
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending sta notify frame\n", __func__);
 
-	skb = dev_alloc_skb(sizeof(struct rsi_peer_notify));
+	skb = dev_alloc_skb(frame_len);
 
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -471,7 +472,7 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, sizeof(struct rsi_peer_notify));
+	memset(skb->data, 0, frame_len);
 	peer_notify = (struct rsi_peer_notify *)skb->data;
 
 	peer_notify->command = cpu_to_le16(opmode << 1);
@@ -489,16 +490,16 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 
 	peer_notify->command |= cpu_to_le16((aid & 0xfff) << 4);
 	ether_addr_copy(peer_notify->mac_addr, bssid);
-
+	peer_notify->mpdu_density = cpu_to_le16(RSI_MPDU_DENSITY);
 	peer_notify->sta_flags = cpu_to_le32((qos_enable) ? 1 : 0);
 
-	peer_notify->desc_word[0] =
-		cpu_to_le16((sizeof(struct rsi_peer_notify) - FRAME_DESC_SZ) |
-			    (RSI_WIFI_MGMT_Q << 12));
-	peer_notify->desc_word[1] = cpu_to_le16(PEER_NOTIFY);
-	peer_notify->desc_word[7] |= cpu_to_le16(vap_id << 8);
+	rsi_set_len_qno(&peer_notify->desc.desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ),
+			RSI_WIFI_MGMT_Q);
+	peer_notify->desc.desc_dword0.frame_type = PEER_NOTIFY;
+	peer_notify->desc.desc_dword3.sta_id = vap_id;
 
-	skb_put(skb, sizeof(struct rsi_peer_notify));
+	skb_put(skb, frame_len);
 
 	status = rsi_send_internal_mgmt_frame(common, skb);
 
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 3b4bd85..d2fe9ee 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -165,6 +165,8 @@
 #define ALLOW_CONN_PEER_MGMT_WHILE_BUF_FULL BIT(5)
 #define DISALLOW_BROADCAST_DATA		BIT(6)
 
+#define RSI_MPDU_DENSITY		0x8
+
 enum opmode {
 	STA_OPMODE = 1,
 	AP_OPMODE = 2
@@ -270,7 +272,7 @@ struct rsi_boot_params {
 } __packed;
 
 struct rsi_peer_notify {
-	__le16 desc_word[8];
+	struct rsi_cmd_desc desc;
 	u8 mac_addr[6];
 	__le16 command;
 	__le16 mpdu_density;
-- 
2.7.4
