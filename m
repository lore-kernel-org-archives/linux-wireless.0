Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34207 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0BGIUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:20:52 -0500
Subject: [PATCH 01/10] adm821: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Michael Wu <flamingice@sourmilk.net>
Date: Sun, 07 Feb 2010 10:20:44 +0200
Message-ID: <20100207082044.31474.48583.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

Compile-tested only.

Cc: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/adm8211.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index e1f04bb..6508515 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -302,18 +302,6 @@ static int adm8211_get_stats(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static int adm8211_get_tx_stats(struct ieee80211_hw *dev,
-				struct ieee80211_tx_queue_stats *stats)
-{
-	struct adm8211_priv *priv = dev->priv;
-
-	stats[0].len = priv->cur_tx - priv->dirty_tx;
-	stats[0].limit = priv->tx_ring_size - 2;
-	stats[0].count = priv->dirty_tx;
-
-	return 0;
-}
-
 static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
@@ -1773,7 +1761,6 @@ static const struct ieee80211_ops adm8211_ops = {
 	.prepare_multicast	= adm8211_prepare_multicast,
 	.configure_filter	= adm8211_configure_filter,
 	.get_stats		= adm8211_get_stats,
-	.get_tx_stats		= adm8211_get_tx_stats,
 	.get_tsf		= adm8211_get_tsft
 };
 

