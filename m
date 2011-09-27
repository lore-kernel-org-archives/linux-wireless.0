Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:45813 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1I0Laz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:30:55 -0400
Subject: [PATCH 1/4] ath6kl: add prefix parameter to ath6kl_dbg_dump()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Sep 2011 14:30:45 +0300
Message-ID: <20110927113045.11592.15974.stgit@localhost6.localdomain6> (sfid-20110927_133058_906812_F35F7C08)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes it easier to recognise longs dumps.

Obligatory screenshot using "rx" prefix:

ath6kl: ath6kl_rx
rx 00000000: 10 10 00 00 00 00 08 30 00 00 00 00 00 00 f9 0b  .......0........
rx 00000010: 2c 44 08 30 00 00 f9 0b 0c a4 02 00 00 00 73 d2  ,D.0..........s.
rx 00000020: 94 00 f9 0b 04 8c 01 00 02 00 07 02 02 00 f9 0b  ................

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |   14 ++++++++------
 drivers/net/wireless/ath/ath6kl/htc.c   |   27 ++++++++++++++-------------
 drivers/net/wireless/ath/ath6kl/txrx.c  |    6 ++++--
 drivers/net/wireless/ath/ath6kl/wmi.c   |    3 ++-
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 89bf8e1..3730e09 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -65,12 +65,14 @@ extern int ath6kl_printk(const char *level, const char *fmt, ...)
 	 })
 
 static inline void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
-				   const char *msg, const void *buf,
-				   size_t len)
+				   const char *msg, const char *prefix,
+				   const void *buf, size_t len)
 {
 	if (debug_mask & mask) {
-		ath6kl_dbg(mask, "%s\n", msg);
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);
+		if (msg)
+			ath6kl_dbg(mask, "%s\n", msg);
+
+		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
 	}
 }
 
@@ -90,8 +92,8 @@ static inline int ath6kl_dbg(enum ATH6K_DEBUG_MASK dbg_mask,
 }
 
 static inline void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
-				   const char *msg, const void *buf,
-				   size_t len)
+				   const char *msg, const char *prefix,
+				   const void *buf, size_t len)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index feed985..f88a7c9 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1192,9 +1192,9 @@ static void htc_ctrl_rx(struct htc_target *context, struct htc_packet *packets)
 			packets->act_len + HTC_HDR_LENGTH);
 
 		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES,
-			     "Unexpected ENDPOINT 0 Message",
-			     packets->buf - HTC_HDR_LENGTH,
-			     packets->act_len + HTC_HDR_LENGTH);
+				"Unexpected ENDPOINT 0 Message", "",
+				packets->buf - HTC_HDR_LENGTH,
+				packets->act_len + HTC_HDR_LENGTH);
 	}
 
 	htc_reclaim_rxbuf(context, packets, &context->endpoint[0]);
@@ -1328,7 +1328,7 @@ static int htc_parse_trailer(struct htc_target *target,
 			memcpy((u8 *)&next_lk_ahds[0], lk_ahd->lk_ahd, 4);
 
 			ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Next Look Ahead",
-					next_lk_ahds, 4);
+					"", next_lk_ahds, 4);
 
 			*n_lk_ahds = 1;
 		}
@@ -1347,7 +1347,7 @@ static int htc_parse_trailer(struct htc_target *target,
 				(struct htc_bundle_lkahd_rpt *) record_buf;
 
 			ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Bundle lk_ahd",
-					record_buf, record->len);
+					"", record_buf, record->len);
 
 			for (i = 0; i < len; i++) {
 				memcpy((u8 *)&next_lk_ahds[i],
@@ -1380,7 +1380,8 @@ static int htc_proc_trailer(struct htc_target *target,
 
 	ath6kl_dbg(ATH6KL_DBG_HTC_RECV, "+htc_proc_trailer (len:%d)\n", len);
 
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Recv Trailer", buf, len);
+	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Recv Trailer", "",
+			buf, len);
 
 	orig_buf = buf;
 	orig_len = len;
@@ -1418,7 +1419,7 @@ static int htc_proc_trailer(struct htc_target *target,
 
 	if (status)
 		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "BAD Recv Trailer",
-				orig_buf, orig_len);
+				"", orig_buf, orig_len);
 
 	return status;
 }
@@ -1435,8 +1436,8 @@ static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
 	if (n_lkahds != NULL)
 		*n_lkahds = 0;
 
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "HTC Recv PKT", packet->buf,
-			packet->act_len);
+	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "HTC Recv PKT", "htc ",
+			packet->buf, packet->act_len);
 
 	/*
 	 * NOTE: we cannot assume the alignment of buf, so we use the safe
@@ -1480,9 +1481,9 @@ static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
 		ath6kl_err("%s(): lk_ahd mismatch! (pPkt:0x%p flags:0x%X)\n",
 			   __func__, packet, packet->info.rx.rx_flags);
 		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Expected Message lk_ahd",
-				&packet->info.rx.exp_hdr, 4);
+				"", &packet->info.rx.exp_hdr, 4);
 		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "Current Frame Header",
-				(u8 *)&lk_ahd, sizeof(lk_ahd));
+				"", (u8 *)&lk_ahd, sizeof(lk_ahd));
 		status = -ENOMEM;
 		goto fail_rx;
 	}
@@ -1518,12 +1519,12 @@ static int ath6kl_htc_rx_process_hdr(struct htc_target *target,
 fail_rx:
 	if (status)
 		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "BAD HTC Recv PKT",
-				packet->buf,
+				"", packet->buf,
 				packet->act_len < 256 ? packet->act_len : 256);
 	else {
 		if (packet->act_len > 0)
 			ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES,
-					"HTC - Application Msg",
+					"HTC - Application Msg", "",
 					packet->buf, packet->act_len);
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 348c646..bc65781 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -322,7 +322,8 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	set_htc_pkt_info(&cookie->htc_pkt, cookie, skb->data, skb->len,
 			 eid, htc_tag);
 
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, skb->data, skb->len);
+	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "tx ",
+			skb->data, skb->len);
 
 	/*
 	 * HTC interface is asynchronous, if this fails, cleanup will
@@ -1050,7 +1051,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	skb_put(skb, packet->act_len + HTC_HDR_LENGTH);
 	skb_pull(skb, HTC_HDR_LENGTH);
 
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, skb->data, skb->len);
+	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "rx ",
+			skb->data, skb->len);
 
 	skb->dev = ar->net_dev;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 47fbb8e..785a8c7 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2850,7 +2850,8 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 	len = skb->len;
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: wmi id: %d\n", __func__, id);
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "msg payload ", datap, len);
+	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "msg payload ", "wmi rx ",
+			datap, len);
 
 	switch (id) {
 	case WMI_GET_BITRATE_CMDID:

