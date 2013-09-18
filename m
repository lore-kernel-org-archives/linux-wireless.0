Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58934 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3IRNXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 09:23:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.12] ath9k: add txq locking for ath_tx_aggr_start
Date: Wed, 18 Sep 2013 15:23:41 +0200
Message-Id: <1379510621-9612-1-git-send-email-nbd@openwrt.org> (sfid-20130918_152356_013576_C9F4607C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevents race conditions when un-aggregated frames are pending in the
driver.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9b3736e..5ac713d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1390,11 +1390,15 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn)
 {
 	struct ath_atx_tid *txtid;
+	struct ath_txq *txq;
 	struct ath_node *an;
 	u8 density;
 
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
+	txq = txtid->ac->txq;
+
+	ath_txq_lock(sc, txq);
 
 	/* update ampdu factor/density, they may have changed. This may happen
 	 * in HT IBSS when a beacon with HT-info is received after the station
@@ -1418,6 +1422,8 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	memset(txtid->tx_buf, 0, sizeof(txtid->tx_buf));
 	txtid->baw_head = txtid->baw_tail = 0;
 
+	ath_txq_unlock_complete(sc, txq);
+
 	return 0;
 }
 
-- 
1.8.0.2

