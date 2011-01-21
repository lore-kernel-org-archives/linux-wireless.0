Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AUDBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:01:11 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so1249489iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:01:11 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63177.228707.769008@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:30:25 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 09/33] ath9k_htc: Use VIF from the packet's control data
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
1.7.3.5

