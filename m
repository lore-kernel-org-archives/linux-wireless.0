Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50749 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab0GVJZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 05:25:08 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 02:25:08 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: [PATCH 2/2] ath9k: Fix stop in tx date traffic after scan
Date: Thu, 22 Jul 2010 02:25:03 -0700
Message-ID: <1279790703-11521-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When moving off channel during background scanning, driver
can not clear IEEE80211_QUEUE_STOP_REASON_DRIVER which was
set earliar due to a shortage in tx buffer, this will lead
to a situation where no data frames will be passed down to
driver when the hw is put back into operating channel. This
patch make sure no txq is stopped after moving to operating
channel after scan. This issue is seen only when NM is used
and exposed by the following commit

Author: Felix Fietkau <nbd@openwrt.org>
Date:   Tue Jun 1 21:33:13 2010 +0200
ath9k: fix queue stop/start based on the number of pending frames

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---

This is not a clean fix for this issue, but best available
from driver. For a decent fix from driver, the following
changes in mac80211 may be required

1. Make ieee80211_wake_queue() callable when moving to off channel
also just to clear IEEE80211_QUEUE_STOP_REASON_DRIVER or

2. For drivers which does not support hw scan, add a way to
tell them if the hw is being configured into operating channel
(driver can detect this, but this would be a hack in driver)
so that the driver can wake up the stopped queues after the
hw is configured back to operating channel.

Johannes, if the above mac80211 changes make any sense, I'll send
a new set of patches to fix this problem.

---

 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    6 ++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |    2 +-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 998ae2c..d8d8804 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -692,4 +692,5 @@ bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
 
+void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq);
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6cf0410..7a0d633 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1491,6 +1491,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ath_hw *ah = sc->sc_ah;
 	bool disable_radio;
+	int i;
 
 	mutex_lock(&sc->mutex);
 
@@ -1605,6 +1606,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
 		}
+
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (ATH_TXQ_SETUP(sc, i))
+				ath_wake_mac80211_queue(sc, &sc->tx.txq[i]);
+		}
 	}
 
 skip_chan_change:
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 21aa5bd..5bfec95 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2067,7 +2067,7 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
-static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
+void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 {
 	int qnum;
 
-- 
1.7.0.4

