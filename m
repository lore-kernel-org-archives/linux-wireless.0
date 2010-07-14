Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0GNB10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 21:27:26 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] ath9k_htc: implement mac80211 flush op
Date: Tue, 13 Jul 2010 21:27:24 -0400
Message-Id: <1279070845-29442-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
References: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the mac80211 flush callback to let mac80211
flush the hardware queues when it deems appropriate.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e38ca66..fc234a7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1803,6 +1803,29 @@ static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->mutex);
 }
 
+static void ath9k_htc_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	u8 cmd_rsp;
+	int ret;
+
+	mutex_lock(&priv->mutex);
+
+	if (priv->op_flags & OP_INVALID)
+		goto err;
+
+	ath9k_htc_ps_wakeup(priv);
+
+	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
+	if (drop)
+		skb_queue_purge(&priv->tx_queue);
+
+	ath9k_htc_ps_restore(priv);
+
+err:
+	mutex_unlock(&priv->mutex);
+}
+
 struct ieee80211_ops ath9k_htc_ops = {
 	.tx                 = ath9k_htc_tx,
 	.start              = ath9k_htc_start,
@@ -1825,4 +1848,5 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.set_rts_threshold  = ath9k_htc_set_rts_threshold,
 	.rfkill_poll        = ath9k_htc_rfkill_poll_state,
 	.set_coverage_class = ath9k_htc_set_coverage_class,
+	.flush		    = ath9k_htc_flush,
 };
-- 
1.7.0.4

