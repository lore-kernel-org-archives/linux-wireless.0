Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11331 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZFQE1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 00:27:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 21:27:28 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/2] ath9k: Fix bogus RSSI report from Hardware during RX.
Date: Wed, 17 Jun 2009 09:57:08 +0530
Message-ID: <1245212828-7342-3-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1245212828-7342-2-git-send-email-senthilkumar@atheros.com>
References: <1245212828-7342-1-git-send-email-senthilkumar@atheros.com>
 <1245212828-7342-2-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware may report errorneous RSSI in some cases. Detect it and
don't use them for reporting the signal strength to the stack.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    5 +++--
 drivers/net/wireless/ath/ath9k/recv.c  |   21 +++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3939396..93245dd 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -300,8 +300,9 @@ struct ath_tx_control {
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
 
-#define ATH_RSSI_LPF_LEN           10
-#define RSSI_LPF_THRESHOLD         -20
+#define ATH_RSSI_LPF_LEN 		10
+#define RSSI_LPF_THRESHOLD		-20
+#define ATH9K_RSSI_BAD			0x80
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)
 #define ATH_EP_MUL(x, mul)         ((x) * (mul))
 #define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0f62795..889d0c9 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -147,6 +147,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 	struct ieee80211_hw *hw;
 	struct ieee80211_sta *sta;
 	struct ath_node *an;
+	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -236,17 +237,21 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 	sta = ieee80211_find_sta(sc->hw, hdr->addr2);
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
-		ATH_RSSI_LPF(an->last_rssi, ds->ds_rxstat.rs_rssi);
-		if (likely(an->last_rssi != ATH_RSSI_DUMMY_MARKER))
-			ds->ds_rxstat.rs_rssi = ATH_EP_RND(an->last_rssi,
-					ATH_RSSI_EP_MULTIPLIER);
-		if (ds->ds_rxstat.rs_rssi < 0)
-			ds->ds_rxstat.rs_rssi = 0;
-		else if (ds->ds_rxstat.rs_rssi > 127)
-			ds->ds_rxstat.rs_rssi = 127;
+		if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
+		   !ds->ds_rxstat.rs_moreaggr)
+			ATH_RSSI_LPF(an->last_rssi, ds->ds_rxstat.rs_rssi);
+		last_rssi = an->last_rssi;
 	}
 	rcu_read_unlock();
 
+	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+		ds->ds_rxstat.rs_rssi = ATH_EP_RND(last_rssi,
+					ATH_RSSI_EP_MULTIPLIER);
+	if (ds->ds_rxstat.rs_rssi < 0)
+		ds->ds_rxstat.rs_rssi = 0;
+	else if (ds->ds_rxstat.rs_rssi > 127)
+		ds->ds_rxstat.rs_rssi = 127;
+
 	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
-- 
1.6.0.4

