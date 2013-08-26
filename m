Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:48238 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab3HZHS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 03:18:27 -0400
Received: by mail-la0-f41.google.com with SMTP id ec20so2149136lab.28
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 00:18:26 -0700 (PDT)
Date: Mon, 26 Aug 2013 09:18:06 +0200
From: Tobias Waldekranz <tobias@waldekranz.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mwifiex: add missing endian conversions
Message-ID: <20130826071806.GA3035@gmail.com> (sfid-20130826_091830_961968_C1173675)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes multiple locations where a little endian host is assumed during
ser/des of messages sent to/received from the chip.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c    | 2 +-
 drivers/net/wireless/mwifiex/main.h        | 2 +-
 drivers/net/wireless/mwifiex/sdio.c        | 6 +++---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index a78e065..b53c73c 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -69,7 +69,7 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 	memcpy(&tx_header->eth803_hdr, skb_src->data, dt_offset);
 
 	/* Copy SNAP header */
-	snap.snap_type = *(u16 *) ((u8 *)skb_src->data + dt_offset);
+	snap.snap_type = le16_to_cpu(*(__le16 *) ((u8 *)skb_src->data + dt_offset));
 	dt_offset += sizeof(u16);
 
 	memcpy(&tx_header->rfc1042_hdr, &snap, sizeof(struct rfc_1042_hdr));
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 4ef67fc..7797512 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1014,7 +1014,7 @@ mwifiex_netdev_get_priv(struct net_device *dev)
  */
 static inline bool mwifiex_is_skb_mgmt_frame(struct sk_buff *skb)
 {
-	return (*(u32 *)skb->data == PKT_TYPE_MGMT);
+	return (le32_to_cpu(*(__le32 *)skb->data) == PKT_TYPE_MGMT);
 }
 
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 139c958..27fdbe2 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -963,7 +963,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 
 	case MWIFIEX_TYPE_EVENT:
 		dev_dbg(adapter->dev, "info: --- Rx: Event ---\n");
-		adapter->event_cause = *(u32 *) skb->data;
+		adapter->event_cause = le32_to_cpu(*(__le32 *) skb->data);
 
 		if ((skb->len > 0) && (skb->len  < MAX_EVENT_SIZE))
 			memcpy(adapter->event_body,
@@ -1088,8 +1088,8 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		for (pind = 0; pind < card->mpa_rx.pkt_cnt; pind++) {
 
 			/* get curr PKT len & type */
-			pkt_len = *(u16 *) &curr_ptr[0];
-			pkt_type = *(u16 *) &curr_ptr[2];
+			pkt_len = le16_to_cpu(*(__le16 *) &curr_ptr[0]);
+			pkt_type = le16_to_cpu(*(__le16 *) &curr_ptr[2]);
 
 			/* copy pkt to deaggr buf */
 			skb_deaggr = card->mpa_rx.skb_arr[pind];
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 9f990e1..f12468a8 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -280,7 +280,7 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 
 	tlv_buf = ((u8 *)rate_cfg) +
 			sizeof(struct host_cmd_ds_tx_rate_cfg);
-	tlv_buf_len = *(u16 *) (tlv_buf + sizeof(u16));
+	tlv_buf_len = le16_to_cpu(*(__le16 *) (tlv_buf + sizeof(u16)));
 
 	while (tlv_buf && tlv_buf_len > 0) {
 		tlv = (*tlv_buf);
-- 
1.8.3

