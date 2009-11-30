Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36733 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZK3ITC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 03:19:02 -0500
Subject: [PATCH v2 09/11] wl1251: implement WMM
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Nov 2009 10:18:33 +0200
Message-ID: <20091130081833.17360.92297.stgit@tikku>
In-Reply-To: <20091130081706.17360.48084.stgit@tikku>
References: <20091130081706.17360.48084.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Now that necessary commands for WMM are implemented, implement queue handling
for WMM. But WMM is not enabled yet, only one queue is used.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    2 +-
 drivers/net/wireless/wl12xx/wl1251_tx.c   |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 74770ad..563c84f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1306,7 +1306,7 @@ static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		goto out_sleep;
 
 	ret = wl1251_acx_tid_cfg(wl, wl1251_tx_get_queue(queue),
-				 CHANNEL_TYPE_DCF,
+				 CHANNEL_TYPE_EDCF,
 				 wl1251_tx_get_queue(queue),
 				 WL1251_ACX_PS_SCHEME_LEGACY,
 				 WL1251_ACX_ACK_POLICY_LEGACY);
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index f859706..faa23ef 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -167,8 +167,7 @@ static int wl1251_tx_fill_hdr(struct wl1251 *wl, struct sk_buff *skb,
 	tx_hdr->expiry_time = cpu_to_le32(1 << 16);
 	tx_hdr->id = id;
 
-	/* FIXME: how to get the correct queue id? */
-	tx_hdr->xmit_queue = 0;
+	tx_hdr->xmit_queue = wl1251_tx_get_queue(skb_get_queue_mapping(skb));
 
 	wl1251_tx_control(tx_hdr, control, fc);
 	wl1251_tx_frag_block_num(tx_hdr);
@@ -237,8 +236,9 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
 
 	wl1251_mem_write(wl, addr, skb->data, len);
 
-	wl1251_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
-		     tx_hdr->id, skb, tx_hdr->length, tx_hdr->rate);
+	wl1251_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x "
+		     "queue %d", tx_hdr->id, skb, tx_hdr->length,
+		     tx_hdr->rate, tx_hdr->xmit_queue);
 
 	return 0;
 }

