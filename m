Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:37159 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbcFCQwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 12:52:38 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC/RFT 3/5] ath9k: Add airstame stats to per-station debugfs
Date: Fri,  3 Jun 2016 18:51:42 +0200
Message-Id: <20160603165144.17356-4-toke@toke.dk> (sfid-20160603_185245_894133_98138BC6)
In-Reply-To: <20160603165144.17356-1-toke@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Uses the ts->duration + retry-chain information to account for time
spent transmitting to a station. Calculates the RX airtime from the rate
and packet length. Hopefully these figures are not too inaccurate.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |   3 +
 drivers/net/wireless/ath/ath9k/debug.h     |  21 +++++
 drivers/net/wireless/ath/ath9k/debug_sta.c | 125 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c      |   1 +
 drivers/net/wireless/ath/ath9k/xmit.c      |   6 +-
 5 files changed, 154 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index caeae10..3fbb0ad 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -264,6 +264,7 @@ struct ath_node {
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
+	struct ath_airtime_stats airtime_stats;
 #endif
 	u8 key_idx[4];
 
@@ -573,6 +574,8 @@ void ath_txq_schedule_all(struct ath_softc *sc);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
+u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
+		     int width, int half_gi, bool shortPreamble);
 void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
 void ath_assign_seq(struct ath_common *common, struct sk_buff *skb);
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index cd68c5f..4f78495 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -223,6 +223,11 @@ struct ath_rx_rate_stats {
 	} cck_stats[4];
 };
 
+struct ath_airtime_stats {
+	u32 rx_airtime;
+	u32 tx_airtime;
+};
+
 #define ANT_MAIN 0
 #define ANT_ALT  1
 
@@ -316,12 +321,28 @@ ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
 void ath_debug_rate_stats(struct ath_softc *sc,
 			  struct ath_rx_status *rs,
 			  struct sk_buff *skb);
+void ath_debug_tx_airtime(struct ath_softc *sc,
+		          struct ath_buf *bf,
+			  struct ath_tx_status *ts);
+void ath_debug_rx_airtime(struct ath_softc *sc,
+			  struct ath_rx_status *rs,
+			  struct sk_buff *skb);
 #else
 static inline void ath_debug_rate_stats(struct ath_softc *sc,
 					struct ath_rx_status *rs,
 					struct sk_buff *skb)
 {
 }
+static inline void ath_debug_tx_airtime(struct ath_softc *sc,
+					struct ath_buf *bf,
+					struct ath_tx_status *ts)
+{
+}
+static inline void ath_debug_rx_airtime(struct ath_softc *sc,
+					struct ath_rx_status *rs,
+					struct sk_buff *skb)
+{
+}
 #endif /* CONFIG_ATH9K_STATION_STATISTICS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index 0e7f6b5..56aba3a 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -245,6 +245,130 @@ static const struct file_operations fops_node_recv = {
 	.llseek = default_llseek,
 };
 
+void ath_debug_tx_airtime(struct ath_softc *sc,
+		          struct ath_buf *bf,
+		          struct ath_tx_status *ts)
+{
+	struct ath_node *an;
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	struct ath_airtime_stats *astats;
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_tx_rate rates[4];
+	struct ieee80211_sta *sta;
+	int i;
+
+	skb = bf->bf_mpdu;
+	if(!skb)
+		return;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	memcpy(rates, bf->rates, sizeof(rates));
+
+	rcu_read_lock();
+
+	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
+	if(!sta)
+		goto exit;
+
+
+	an = (struct ath_node *) sta->drv_priv;
+	astats = &an->airtime_stats;
+
+	astats->tx_airtime += ts->duration * (ts->ts_longretry + 1);
+
+	for(i=0; i < ts->ts_rateindex; i++)
+		astats->tx_airtime += ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc, i) * rates[i].count;
+
+
+
+exit:
+	rcu_read_unlock();
+}
+
+void ath_debug_rx_airtime(struct ath_softc *sc,
+			  struct ath_rx_status *rs,
+			  struct sk_buff *skb)
+{
+	struct ath_airtime_stats *astats;
+	struct ath_node *an;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_sta *sta;
+	struct ieee80211_rx_status *rxs;
+	const struct ieee80211_rate *rate;
+	bool is_sgi, is_40, is_sp;
+	int phy;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	rcu_read_lock();
+
+	sta = ieee80211_find_sta_by_ifaddr(sc->hw, hdr->addr2, NULL);
+	if (!sta)
+		goto exit;
+	an = (struct ath_node *) sta->drv_priv;
+	rxs = IEEE80211_SKB_RXCB(skb);
+	astats = &an->airtime_stats;
+
+	is_sgi = !!(rxs->flag & RX_FLAG_SHORT_GI);
+	is_40 = !!(rxs->flag & RX_FLAG_40MHZ);
+	is_sp = !!(rxs->flag & RX_FLAG_SHORTPRE);
+
+	if (!!(rxs->flag & RX_FLAG_HT)) {
+		/* MCS rates */
+
+		astats->rx_airtime += ath_pkt_duration(sc, rxs->rate_idx, rs->rs_datalen,
+						is_40, is_sgi, is_sp);
+		goto exit;
+	}
+
+	phy = IS_CCK_RATE(rs->rs_rate) ? WLAN_RC_PHY_CCK : WLAN_RC_PHY_OFDM;
+	rate = &common->sbands[rxs->band].bitrates[rxs->rate_idx];
+	astats->rx_airtime += ath9k_hw_computetxtime(ah, phy, rate->bitrate * 100,
+						rs->rs_datalen, rxs->rate_idx, is_sp);
+
+
+exit:
+	rcu_read_unlock();
+}
+
+
+static ssize_t read_airtime(struct file *file, char __user *user_buf,
+			size_t count, loff_t *ppos)
+{
+	struct ath_node *an = file->private_data;
+	struct ath_airtime_stats *astats;
+	u32 len = 0, size = 128;
+	char *buf;
+	size_t retval;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	astats = &an->airtime_stats;
+
+	len += scnprintf(buf + len, size - len, "RX: %u us\n", astats->rx_airtime);
+	len += scnprintf(buf + len, size - len, "TX: %u us\n", astats->tx_airtime);
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+
+static const struct file_operations fops_airtime = {
+	.read = read_airtime,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+
 void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
@@ -254,4 +378,5 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	debugfs_create_file("node_aggr", S_IRUGO, dir, an, &fops_node_aggr);
 	debugfs_create_file("node_recv", S_IRUGO, dir, an, &fops_node_recv);
+	debugfs_create_file("airtime", S_IRUGO, dir, an, &fops_airtime);
 }
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 32160fc..7eb8980 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1137,6 +1137,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		ath9k_antenna_check(sc, &rs);
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 		ath_debug_rate_stats(sc, &rs, skb);
+		ath_debug_rx_airtime(sc, &rs, skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		if (ieee80211_is_ack(hdr->frame_control))
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cdc8684..07d32e7 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -739,6 +739,8 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	ts->duration = ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc,
 					     ts->ts_rateindex);
+	ath_debug_tx_airtime(sc, bf, ts);
+
 	if (!bf_isampdu(bf)) {
 		if (!flush) {
 			info = IEEE80211_SKB_CB(bf->bf_mpdu);
@@ -1090,8 +1093,8 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq *txq,
  * width  - 0 for 20 MHz, 1 for 40 MHz
  * half_gi - to use 4us v/s 3.6 us for symbol time
  */
-static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
-			    int width, int half_gi, bool shortPreamble)
+u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
+		     int width, int half_gi, bool shortPreamble)
 {
 	u32 nbits, nsymbits, duration, nsymbols;
 	int streams;
-- 
2.7.4
