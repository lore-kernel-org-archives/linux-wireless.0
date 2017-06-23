Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36239 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdFWOKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:32 -0400
Received: by mail-pf0-f194.google.com with SMTP id y7so7541582pfd.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:32 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 05/17] rsi: Update peer notify command frame
Date: Fri, 23 Jun 2017 19:37:24 +0530
Message-Id: <1498226856-6305-6-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161038_400180_EEECF5F0)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
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
index c73007d..b1a90b5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -464,10 +464,11 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 	struct rsi_peer_notify *peer_notify;
 	u16 vap_id = 0;
 	int status;
+	u16 frame_len = sizeof(struct rsi_peer_notify);
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending sta notify frame\n", __func__);
 
-	skb = dev_alloc_skb(sizeof(struct rsi_peer_notify));
+	skb = dev_alloc_skb(frame_len);
 
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -475,7 +476,7 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, sizeof(struct rsi_peer_notify));
+	memset(skb->data, 0, frame_len);
 	peer_notify = (struct rsi_peer_notify *)skb->data;
 
 	peer_notify->command = cpu_to_le16(opmode << 1);
@@ -493,16 +494,16 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 
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
