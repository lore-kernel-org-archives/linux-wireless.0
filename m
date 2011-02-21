Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55725 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:19:15 -0500
Received: by gyb11 with SMTP id 11so65408gyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:19:14 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52116.847107.354456@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:00 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 10/23] ath9k_htc: Use VIF from the packet's control data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

There is no need to use a locally stored reference.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 6ddcf93..04d8248 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -232,6 +232,7 @@ static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
 void ath9k_tx_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ieee80211_vif *vif;
 	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
@@ -243,12 +244,16 @@ void ath9k_tx_tasklet(unsigned long data)
 		hdr = (struct ieee80211_hdr *) skb->data;
 		fc = hdr->frame_control;
 		tx_info = IEEE80211_SKB_CB(skb);
+		vif = tx_info->control.vif;
 
 		memset(&tx_info->status, 0, sizeof(tx_info->status));
 
+		if (!vif)
+			goto send_mac80211;
+
 		rcu_read_lock();
 
-		sta = ieee80211_find_sta(priv->vif, hdr->addr1);
+		sta = ieee80211_find_sta(vif, hdr->addr1);
 		if (!sta) {
 			rcu_read_unlock();
 			ieee80211_tx_status(priv->hw, skb);
@@ -278,6 +283,7 @@ void ath9k_tx_tasklet(unsigned long data)
 
 		rcu_read_unlock();
 
+	send_mac80211:
 		/* Send status to mac80211 */
 		ieee80211_tx_status(priv->hw, skb);
 	}
-- 
1.7.4.1

