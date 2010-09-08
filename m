Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab0IHX0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:26:03 -0400
Received: by mail-pz0-f46.google.com with SMTP id 34so248716pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:26:03 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 7/9] libertas_tf: Add tx feedback to libertas_tf_sdio
Date: Wed,  8 Sep 2010 16:25:27 -0700
Message-Id: <1283988329-44549-8-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds tx-feedback to libertas_tf_sdio so that mac80211 rate
adaptation and other bookkeeping tasks function properly.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/deb_defs.h |    5 ++
 drivers/net/wireless/libertas_tf/if_sdio.c  |   42 +++++++++++------
 drivers/net/wireless/libertas_tf/main.c     |   65 ++++++++++++++++----------
 3 files changed, 72 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/deb_defs.h b/drivers/net/wireless/libertas_tf/deb_defs.h
index 99a7478..8e86e11 100644
--- a/drivers/net/wireless/libertas_tf/deb_defs.h
+++ b/drivers/net/wireless/libertas_tf/deb_defs.h
@@ -43,6 +43,9 @@
 #define LBTF_DEB_HEX	0x00200000
 #define LBTF_DEB_SDIO	0x00400000
 #define LBTF_DEB_MACOPS	0x00800000
+#define LBTF_DEB_STATS	0x01000000
+#define LBTF_DEB_INT    0x02000000
+#define LBTF_DEB_SCRATCH 0x04000000
 
 extern unsigned int lbtf_debug;
 
@@ -87,6 +90,8 @@ do { if ((lbtf_debug & (grp)) == (grp)) \
 #define lbtf_deb_thread(fmt, args...)    LBTF_DEB_LL(LBTF_DEB_THREAD, " thread", fmt, ##args)
 #define lbtf_deb_sdio(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_SDIO, " sdio", fmt, ##args)
 #define lbtf_deb_macops(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_MACOPS, " thread", fmt, ##args)
+#define lbtf_deb_stats(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_STATS, " statistics", fmt, ##args)
+#define lbtf_deb_int(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_INT, " int", fmt, ##args)
 
 #ifdef DEBUG
 static inline void lbtf_deb_hex(unsigned int grp, const char *prompt, u8 *buf, int len)
diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
index 189b820..5074f8b 100644
--- a/drivers/net/wireless/libertas_tf/if_sdio.c
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -148,7 +148,7 @@ static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
 	int ret;
 	u16 scratch;
 
-	lbtf_deb_enter(LBTF_DEB_SDIO);
+	lbtf_deb_enter(LBTF_DEB_SCRATCH);
 
 	scratch = sdio_readb(card->func, card->scratch_reg, &ret);
 	if (!ret)
@@ -161,7 +161,7 @@ static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
 	if (ret)
 		return 0xffff;
 
-	lbtf_deb_leave_args(LBTF_DEB_SDIO, "scratch %x", scratch);
+	lbtf_deb_leave_args(LBTF_DEB_SCRATCH, "scratch %x", scratch);
 	return scratch;
 }
 
@@ -232,7 +232,7 @@ static int if_sdio_handle_data(struct if_sdio_card *card,
 	struct sk_buff *skb;
 	char *data;
 
-	lbtf_deb_enter(LBTF_DEB_SDIO);
+	lbtf_deb_enter(LBTF_DEB_INT);
 
 	if (size > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
 		lbtf_deb_sdio("response packet too large (%d bytes)\n",
@@ -258,7 +258,7 @@ static int if_sdio_handle_data(struct if_sdio_card *card,
 	ret = 0;
 
 out:
-	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	lbtf_deb_leave_args(LBTF_DEB_INT, "ret %d", ret);
 
 	return ret;
 }
@@ -291,7 +291,21 @@ static int if_sdio_handle_event(struct if_sdio_card *card,
 		event |= buffer[0] << 0;
 	}
 
-	lbtf_deb_sdio("**EVENT** 0x%X\n", event);
+	lbtf_deb_stats("**EVENT** 0x%X\n", event);
+
+	if (event & 0xffff0000) {
+			u16 tmp;
+			u8 retrycnt;
+			u8 failure;
+
+			tmp = event >> 16;
+			retrycnt = tmp & 0x00ff;
+			failure = (tmp & 0xff00) >> 8;
+			lbtf_deb_stats("Got feedback event. retry: %d, failure: %d", retrycnt, failure);
+			lbtf_send_tx_feedback(card->priv, retrycnt, failure);
+		} else if (event == LBTF_EVENT_BCN_SENT)
+			lbtf_bcn_sent(card->priv);
+
 	ret = 0;
 
 out:
@@ -326,7 +340,7 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 	int ret;
 	u16 size, type, chunk;
 
-	lbtf_deb_enter(LBTF_DEB_SDIO);
+	lbtf_deb_enter(LBTF_DEB_INT);
 
 
 	size = if_sdio_read_rx_len(card, &ret);
@@ -358,7 +372,7 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 	chunk = card->buffer[0] | (card->buffer[1] << 8);
 	type = card->buffer[2] | (card->buffer[3] << 8);
 
-	lbtf_deb_sdio("packet of type %d and size %d bytes\n",
+	lbtf_deb_int("packet of type %d and size %d bytes\n",
 		(int)type, (int)chunk);
 
 	if (chunk > size) {
@@ -400,7 +414,7 @@ out:
 	if (ret)
 		pr_err("problem fetching packet from firmware\n");
 
-	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	lbtf_deb_leave_args(LBTF_DEB_INT, "ret %d", ret);
 
 	return ret;
 }
@@ -1063,25 +1077,23 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	struct if_sdio_card *card;
 	u8 cause;
 
-	lbtf_deb_enter(LBTF_DEB_SDIO);
+	lbtf_deb_enter(LBTF_DEB_INT);
 
 	card = sdio_get_drvdata(func);
 
 	cause = sdio_readb(card->func, IF_SDIO_H_INT_STATUS, &ret);
-	lbtf_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
-	lbtf_deb_sdio("interrupt ret: 0x%X\n", ret);
+	lbtf_deb_int("interrupt: 0x%X\n", (unsigned)cause);
+	lbtf_deb_int("interrupt ret: 0x%X\n", ret);
 	if (ret)
 		goto out;
 
-//	lbtf_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
-
 	sdio_writeb(card->func, ~cause, IF_SDIO_H_INT_STATUS, &ret);
 	if (ret)
 		goto out;
 
 	/*
 	 * Ignore the define name, this really means the card has
-	 * successfully received the command.
+	 * successfully received the command or packet.
 	 */
 	if (cause & IF_SDIO_H_INT_DNLD)
 		if (card->priv)
@@ -1096,7 +1108,7 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	ret = 0;
 
 out:
-	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	lbtf_deb_leave_args(LBTF_DEB_INT, "ret %d", ret);
 }
 
 static int if_sdio_probe(struct sdio_func *func,
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index b797787..cc2217c 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -296,12 +296,14 @@ static void lbtf_tx_work(struct work_struct *work)
 	/* Activate per-packet rate selection */
 	txpd->tx_control |= cpu_to_le32(MRVL_PER_PACKET_RATE |
 			     ieee80211_get_tx_rate(priv->hw, info)->hw_value);
+	lbtf_deb_tx("tx_control: %x", txpd->tx_control );
 
 	/* copy destination address from 802.11 header */
 	memcpy(txpd->tx_dest_addr_high, skb->data + sizeof(struct txpd) + 4,
 		ETH_ALEN);
 	txpd->tx_packet_length = cpu_to_le16(len);
 	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
+
 	lbtf_deb_hex(LBTF_DEB_TX, "TX Data ", skb->data, min_t(unsigned int, skb->len, 100));
 
 	WARN_ON(priv->tx_skb);
@@ -729,10 +731,18 @@ EXPORT_SYMBOL_GPL(lbtf_add_card);
 
 int lbtf_remove_card(struct lbtf_private *priv)
 {
+	struct sk_buff *skb = NULL;
 	struct ieee80211_hw *hw = priv->hw;
 
 	lbtf_deb_enter(LBTF_DEB_MAIN);
 
+	ieee80211_stop_queues(priv->hw);
+
+	while (!skb_queue_empty(&priv->tx_skb_buf)) {
+		skb = skb_dequeue(&priv->tx_skb_buf);
+		dev_kfree_skb_any(skb);
+	}
+
 	priv->surpriseremoved = 1;
 	del_timer(&priv->command_timer);
 	lbtf_free_adapter(priv);
@@ -747,24 +757,37 @@ EXPORT_SYMBOL_GPL(lbtf_remove_card);
 
 void lbtf_send_tx_feedback(struct lbtf_private *priv, u8 retrycnt, u8 fail)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(priv->tx_skb);
+	struct ieee80211_tx_info *info;
+	lbtf_deb_enter(LBTF_DEB_MAIN);
 
-	ieee80211_tx_info_clear_status(info);
-	/*
-	 * Commented out, otherwise we never go beyond 1Mbit/s using mac80211
-	 * default pid rc algorithm.
-	 *
-	 * info->status.retry_count = MRVL_DEFAULT_RETRIES - retrycnt;
-	 */
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) && !fail)
-		info->flags |= IEEE80211_TX_STAT_ACK;
-	skb_pull(priv->tx_skb, sizeof(struct txpd));
-	ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb);
-	priv->tx_skb = NULL;
-	if (!priv->skb_to_tx && skb_queue_empty(&priv->bc_ps_buf))
-		ieee80211_wake_queues(priv->hw);
-	else
-		queue_work(lbtf_wq, &priv->tx_work);
+	if(priv->tx_skb == 0) {
+		lbtf_deb_stats("tx_skb is null");
+	} else {
+
+		lbtf_deb_stats("tx_skb is ok");
+
+		info = IEEE80211_SKB_CB(priv->tx_skb);
+		ieee80211_tx_info_clear_status(info);
+		/*
+		 * Commented out, otherwise we never go beyond 1Mbit/s using mac80211
+		 * default pid rc algorithm.
+		 *
+		 * info->status.retry_count = MRVL_DEFAULT_RETRIES - retrycnt;
+		 */
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) && !fail) {
+			info->flags |= IEEE80211_TX_STAT_ACK;
+		}
+		skb_pull(priv->tx_skb, sizeof(struct txpd));
+		ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb);
+	}
+
+		priv->tx_skb = NULL;
+		if (!priv->skb_to_tx && skb_queue_empty(&priv->bc_ps_buf))
+			ieee80211_wake_queues(priv->hw);
+		else
+			queue_work(lbtf_wq, &priv->tx_work);
+
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 EXPORT_SYMBOL_GPL(lbtf_send_tx_feedback);
 
@@ -782,19 +805,11 @@ void lbtf_host_to_card_done(struct lbtf_private *priv )
 #endif
 
 	if (priv->tx_skb) {
-		ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb);
-		priv->tx_skb = NULL;
 		lbtf_deb_main("Got done on packet.");
 	} else {
 		lbtf_deb_main("Got done on command.");
 	}
 
-	if (!priv->skb_to_tx && skb_queue_empty(&priv->bc_ps_buf)) {
-		ieee80211_wake_queues(priv->hw);
-	} else {
-		queue_work(lbtf_wq, &priv->tx_work);
-	}
-
 	lbtf_deb_leave(LBTF_DEB_THREAD);
 }
 EXPORT_SYMBOL_GPL(lbtf_host_to_card_done);
-- 
1.7.0

