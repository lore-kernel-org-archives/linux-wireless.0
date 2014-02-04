Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60908 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaBDJ2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 04:28:36 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0LqzEB-1VXgiv37ZL-00eZid for
 <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 10:28:34 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 06/13] ath9k_htc: use ath9k_cmn_process_rssi
Date: Tue,  4 Feb 2014 10:27:43 +0100
Message-Id: <1391506070-8636-7-git-send-email-linux@rempel-privat.de> (sfid-20140204_102839_476297_4590588E)
In-Reply-To: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
References: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h          |  1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 21 ++-------------------
 drivers/net/wireless/ath/ath9k/mac.h          |  9 +++------
 5 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 58da346..c75493f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -275,7 +275,6 @@ struct ath9k_htc_rxbuf {
 };
 
 struct ath9k_htc_rx {
-	int last_rssi; /* FIXME: per-STA */
 	struct list_head rxbuf;
 	spinlock_t rxbuflock;
 };
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index f4e1de2..9db8aef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -607,6 +607,7 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
+	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 608d739..228549a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1457,6 +1457,7 @@ static void ath9k_htc_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 	if ((vif->type == NL80211_IFTYPE_STATION) && bss_conf->assoc) {
 		common->curaid = bss_conf->aid;
+		common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a3f2201..fcf7f5a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -927,7 +927,6 @@ void ath9k_host_rx_init(struct ath9k_htc_priv *priv)
 	ath9k_hw_rxena(priv->ah);
 	ath9k_htc_opmode_init(priv);
 	ath9k_hw_startpcureceive(priv->ah, test_bit(OP_SCANNING, &priv->op_flags));
-	priv->rx.last_rssi = ATH_RSSI_DUMMY_MARKER;
 }
 
 static void ath9k_process_rate(struct ieee80211_hw *hw,
@@ -1011,7 +1010,6 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
 	int hdrlen, padsize;
-	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
@@ -1104,24 +1102,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
 			   rxbuf->rxstatus.rs_flags);
 
-	if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
-	    !rxbuf->rxstatus.rs_moreaggr)
-		ATH_RSSI_LPF(priv->rx.last_rssi,
-			     rxbuf->rxstatus.rs_rssi);
 
-	last_rssi = priv->rx.last_rssi;
-
-	if (ath_is_mybeacon(common, hdr)) {
-		s8 rssi = rxbuf->rxstatus.rs_rssi;
-
-		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-			rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
-
-		if (rssi < 0)
-			rssi = 0;
-
-		priv->ah->stats.avgbrssi = rssi;
-	}
+	rx_stats.is_mybeacon = ath_is_mybeacon(common, hdr);
+	ath9k_cmn_process_rssi(common, hw, &rx_stats, rx_status);
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
 	rx_status->band = hw->conf.chandef.chan->band;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 1027137..89df634 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -155,12 +155,8 @@ struct ath_htc_rx_status {
 	u8 rs_status;
 	u8 rs_phyerr;
 	int8_t rs_rssi;
-	int8_t rs_rssi_ctl0;
-	int8_t rs_rssi_ctl1;
-	int8_t rs_rssi_ctl2;
-	int8_t rs_rssi_ext0;
-	int8_t rs_rssi_ext1;
-	int8_t rs_rssi_ext2;
+	int8_t rs_rssi_ctl[3];
+	int8_t rs_rssi_ext[3];
 	u8 rs_keyix;
 	u8 rs_rate;
 	u8 rs_antenna;
@@ -170,6 +166,7 @@ struct ath_htc_rx_status {
 	u8 rs_num_delims;
 	u8 rs_flags;
 	u8 rs_dummy;
+	/* FIXME: evm* never used? */
 	__be32 evm0;
 	__be32 evm1;
 	__be32 evm2;
-- 
1.9.rc1

