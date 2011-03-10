Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51123 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1CJBsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 20:48:22 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove redundant variable upld_len
Date: Wed,  9 Mar 2011 17:51:25 -0800
Message-Id: <1299721885-21709-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

adapter->upld_len was used together with mwifiex_buffer
to track the uploaded packet size. Now mwifiex uses sk_buff
instead of mwifiex_buffer so adapter->upld_len can be
removed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    1 -
 drivers/net/wireless/mwifiex/main.h |    1 -
 drivers/net/wireless/mwifiex/sdio.c |   15 ++++++---------
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index f06d69c..c4fe89d 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -303,7 +303,6 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->fw_release_number = 0;
 	adapter->fw_cap_info = 0;
 	memset(&adapter->upld_buf, 0, sizeof(adapter->upld_buf));
-	adapter->upld_len = 0;
 	adapter->event_cause = 0;
 	adapter->region_code = 0;
 	adapter->bcn_miss_time_out = DEFAULT_BCN_MISS_TIMEOUT;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d972512..b74a9e6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -547,7 +547,6 @@ struct mwifiex_adapter {
 	u8 int_status;
 	u32 event_cause;
 	struct sk_buff *event_skb;
-	u32 upld_len;
 	u8 upld_buf[MWIFIEX_UPLD_SIZE];
 	u8 data_sent;
 	u8 cmd_sent;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4ad1dfb..1f32560 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -620,10 +620,11 @@ static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
  * This function sends a data buffer to the card.
  */
 static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
-				     u32 *type, u32 *nb, u8 *buffer,
+				     u32 *type, u8 *buffer,
 				     u32 npayload, u32 ioport)
 {
 	int ret = 0;
+	u32 nb;
 
 	if (!buffer) {
 		dev_err(adapter->dev, "%s: buffer is NULL\n", __func__);
@@ -638,10 +639,10 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
-	*nb = le16_to_cpu(*(__le16 *) (buffer));
-	if (*nb > npayload) {
-		dev_err(adapter->dev, "%s: invalid packet, *nb=%d, npayload=%d\n",
-				__func__, *nb, npayload);
+	nb = le16_to_cpu(*(__le16 *) (buffer));
+	if (nb > npayload) {
+		dev_err(adapter->dev, "%s: invalid packet, nb=%d, npayload=%d\n",
+				__func__, nb, npayload);
 		return -1;
 	}
 
@@ -933,8 +934,6 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 			adapter->cmd_resp_received = true;
 			adapter->curr_cmd->resp_skb = skb;
 		}
-
-		adapter->upld_len = skb->len;
 		break;
 
 	case MWIFIEX_TYPE_EVENT:
@@ -1077,7 +1076,6 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 				skb_trim(skb_deaggr, pkt_len);
 
-				adapter->upld_len = pkt_len;
 				/* Process de-aggr packet */
 				mwifiex_decode_rx_packet(adapter, skb_deaggr,
 							 pkt_type);
@@ -1099,7 +1097,6 @@ rx_curr_single:
 			port, rx_len);
 
 		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
-					      (u32 *) &adapter->upld_len,
 					      skb->data, skb->len,
 					      adapter->ioport + port))
 			return -1;
-- 
1.7.0.2

