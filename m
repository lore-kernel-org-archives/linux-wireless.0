Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab1CQS7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:17 -0400
Received: by mail-iy0-f174.google.com with SMTP id 26so3126341iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:17 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 5/9] mwl8k: add internal API for managing AMPDU streams
Date: Thu, 17 Mar 2011 11:58:45 -0700
Message-Id: <1300388329-15380-5-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In particular, we can now add, start, lookup, and remove streams.

Based on work by Nishant Sarmukadam <nishants@marvell.com> and
Pradeep Nemavat <pnemavat@marvell.com>.

Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   81 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 53581ee..dcd4508 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -137,6 +137,13 @@ struct mwl8k_tx_queue {
 	struct sk_buff **skb;
 };
 
+enum {
+	AMPDU_NO_STREAM,
+	AMPDU_STREAM_NEW,
+	AMPDU_STREAM_IN_PROGRESS,
+	AMPDU_STREAM_ACTIVE,
+};
+
 struct mwl8k_ampdu_stream {
 	struct ieee80211_sta *sta;
 	u8 tid;
@@ -172,6 +179,8 @@ struct mwl8k_priv {
 
 	/* Ampdu stream information */
 	u8 num_ampdu_queues;
+	spinlock_t stream_lock;
+	struct mwl8k_ampdu_stream ampdu[MWL8K_MAX_AMPDU_QUEUES];
 
 	/* firmware access */
 	struct mutex fw_mutex;
@@ -1594,6 +1603,74 @@ static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 	txq->txd = NULL;
 }
 
+/* caller must hold priv->stream_lock when calling the stream functions */
+struct mwl8k_ampdu_stream *
+mwl8k_add_stream(struct ieee80211_hw *hw, struct ieee80211_sta *sta, u8 tid)
+{
+	struct mwl8k_ampdu_stream *stream;
+	struct mwl8k_priv *priv = hw->priv;
+	int i;
+
+	for (i = 0; i < priv->num_ampdu_queues; i++) {
+		stream = &priv->ampdu[i];
+		if (stream->state == AMPDU_NO_STREAM) {
+			stream->sta = sta;
+			stream->state = AMPDU_STREAM_NEW;
+			stream->tid = tid;
+			stream->idx = i;
+			stream->txq_idx = MWL8K_TX_WMM_QUEUES + i;
+			wiphy_debug(hw->wiphy, "Added a new stream for %pM %d",
+				    sta->addr, tid);
+			return stream;
+		}
+	}
+	return NULL;
+}
+
+static int
+mwl8k_start_stream(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
+{
+	int ret;
+
+	/* if the stream has already been started, don't start it again */
+	if (stream->state != AMPDU_STREAM_NEW)
+		return 0;
+	ret = ieee80211_start_tx_ba_session(stream->sta, stream->tid, 0);
+	if (ret)
+		wiphy_debug(hw->wiphy, "Failed to start stream for %pM %d: "
+			    "%d\n", stream->sta->addr, stream->tid, ret);
+	else
+		wiphy_debug(hw->wiphy, "Started stream for %pM %d\n",
+			    stream->sta->addr, stream->tid);
+	return ret;
+}
+
+static void
+mwl8k_remove_stream(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
+{
+	wiphy_debug(hw->wiphy, "Remove stream for %pM %d\n", stream->sta->addr,
+		    stream->tid);
+	memset(stream, 0, sizeof(*stream));
+}
+
+static struct mwl8k_ampdu_stream *
+mwl8k_lookup_stream(struct ieee80211_hw *hw, u8 *addr, u8 tid)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	int i;
+
+	for (i = 0 ; i < priv->num_ampdu_queues; i++) {
+		struct mwl8k_ampdu_stream *stream;
+		stream = &priv->ampdu[i];
+		if (stream->state == AMPDU_NO_STREAM)
+			continue;
+		if (!memcmp(stream->sta->addr, addr, ETH_ALEN) &&
+		    stream->tid == tid)
+			return stream;
+	}
+	return NULL;
+}
+
 static void
 mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 {
@@ -4854,6 +4931,8 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 		goto err_free_queues;
 	}
 
+	memset(priv->ampdu, 0, sizeof(priv->ampdu));
+
 	/*
 	 * Temporarily enable interrupts.  Initial firmware host
 	 * commands use interrupts and avoid polling.  Disable
@@ -5018,6 +5097,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	spin_lock_init(&priv->tx_lock);
 
+	spin_lock_init(&priv->stream_lock);
+
 	priv->tx_wait = NULL;
 
 	rc = mwl8k_probe_hw(hw);
-- 
1.7.1.1

