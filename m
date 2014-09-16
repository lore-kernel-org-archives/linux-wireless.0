Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60038 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbaIPANW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:22 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so4607271wgg.6
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:20 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 03/10] ath9k: add dynamic ACK timeout estimation
Date: Tue, 16 Sep 2014 02:13:09 +0200
Message-Id: <1410826396-15544-4-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021340_204267_047A41AF)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add dynamic ACK timeout estimation algorithm based on ACK frame RX timestamp,
TX frame timestamp and frame duration.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Tested-by: Philippe Duchein <wireless-dev@duchein.net>
---
 drivers/net/wireless/ath/ath.h          |   2 +
 drivers/net/wireless/ath/ath9k/ath9k.h  |   3 +
 drivers/net/wireless/ath/ath9k/dynack.c | 352 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dynack.h | 103 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.c     |   2 +
 drivers/net/wireless/ath/ath9k/hw.h     |   3 +
 6 files changed, 465 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index c1a4ade..a3b6e27 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -234,6 +234,7 @@ void ath_printk(const char *level, const struct ath_common *common,
  *	AR9462.
  * @ATH_DBG_DFS: radar datection
  * @ATH_DBG_WOW: Wake on Wireless
+ * @ATH_DBG_DYNACK: dynack handling
  * @ATH_DBG_ANY: enable all debugging
  *
  * The debug level is used to control the amount and type of debugging output
@@ -262,6 +263,7 @@ enum ATH_DEBUG {
 	ATH_DBG_DFS		= 0x00010000,
 	ATH_DBG_WOW		= 0x00020000,
 	ATH_DBG_CHAN_CTX	= 0x00040000,
+	ATH_DBG_DYNACK		= 0x00080000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index dd0f97f..8cd116e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -274,6 +274,9 @@ struct ath_node {
 	struct ath_rx_rate_stats rx_rate_stats;
 #endif
 	u8 key_idx[4];
+
+	u32 ackto;
+	struct list_head list;
 };
 
 struct ath_tx_control {
diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
new file mode 100644
index 0000000..ceca509
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -0,0 +1,352 @@
+/*
+ * Copyright (c) 2014, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+#include "hw.h"
+#include "dynack.h"
+
+#define COMPUTE_TO		(5 * HZ)
+#define LATEACK_DELAY		(10 * HZ)
+#define LATEACK_TO		256
+#define MAX_DELAY		300
+#define EWMA_LEVEL		96
+#define EWMA_DIV		128
+
+/**
+ * ath_dynack_ewma - EWMA (Exponentially Weighted Moving Average) calculation
+ *
+ */
+static inline u32 ath_dynack_ewma(u32 old, u32 new)
+{
+	return (new * (EWMA_DIV - EWMA_LEVEL) + old * EWMA_LEVEL) / EWMA_DIV;
+}
+
+/**
+ * ath_dynack_get_sifs - get sifs time based on phy used
+ * @ah: ath hw
+ * @phy: phy used
+ *
+ */
+static inline u32 ath_dynack_get_sifs(struct ath_hw *ah, int phy)
+{
+	u32 sifs = CCK_SIFS_TIME;
+
+	if (phy == WLAN_RC_PHY_OFDM) {
+		if (IS_CHAN_QUARTER_RATE(ah->curchan))
+			sifs = OFDM_SIFS_TIME_QUARTER;
+		else if (IS_CHAN_HALF_RATE(ah->curchan))
+			sifs = OFDM_SIFS_TIME_HALF;
+		else
+			sifs = OFDM_SIFS_TIME;
+	}
+	return sifs;
+}
+
+/**
+ * ath_dynack_bssidmask - filter out ACK frames based on BSSID mask
+ * @ah: ath hw
+ * @mac: receiver address
+ */
+static inline bool ath_dynack_bssidmask(struct ath_hw *ah, const u8 *mac)
+{
+	int i;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	for (i = 0; i < ETH_ALEN; i++) {
+		if ((common->macaddr[i] & common->bssidmask[i]) !=
+		    (mac[i] & common->bssidmask[i]))
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * ath_dynack_compute_ackto - compute ACK timeout as the maximum STA timeout
+ * @ah: ath hw
+ *
+ * should be called while holding qlock
+ */
+static void ath_dynack_compute_ackto(struct ath_hw *ah)
+{
+	struct ath_node *an;
+	u32 to = 0;
+	struct ath_dynack *da = &ah->dynack;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	list_for_each_entry(an, &da->nodes, list)
+		if (an->ackto > to)
+			to = an->ackto;
+
+	if (to && da->ackto != to) {
+		u32 slottime;
+
+		slottime = (to - 3) / 2;
+		da->ackto = to;
+		ath_dbg(common, DYNACK, "ACK timeout %u slottime %u\n",
+			da->ackto, slottime);
+		ath9k_hw_setslottime(ah, slottime);
+		ath9k_hw_set_ack_timeout(ah, da->ackto);
+		ath9k_hw_set_cts_timeout(ah, da->ackto);
+	}
+}
+
+/**
+ * ath_dynack_compute_to - compute STA ACK timeout
+ * @ah: ath hw
+ *
+ * should be called while holding qlock
+ */
+static void ath_dynack_compute_to(struct ath_hw *ah)
+{
+	u32 ackto, ack_ts;
+	u8 *dst, *src;
+	struct ieee80211_sta *sta;
+	struct ath_node *an;
+	struct ts_info *st_ts;
+	struct ath_dynack *da = &ah->dynack;
+
+	rcu_read_lock();
+
+	while (da->st_rbf.h_rb != da->st_rbf.t_rb &&
+	       da->ack_rbf.h_rb != da->ack_rbf.t_rb) {
+		ack_ts = da->ack_rbf.tstamp[da->ack_rbf.h_rb];
+		st_ts = &da->st_rbf.ts[da->st_rbf.h_rb];
+		dst = da->st_rbf.addr[da->st_rbf.h_rb].h_dest;
+		src = da->st_rbf.addr[da->st_rbf.h_rb].h_src;
+
+		ath_dbg(ath9k_hw_common(ah), DYNACK,
+			"ack_ts %u st_ts %u st_dur %u [%u-%u]\n",
+			ack_ts, st_ts->tstamp, st_ts->dur,
+			da->ack_rbf.h_rb, da->st_rbf.h_rb);
+
+		if (ack_ts > st_ts->tstamp + st_ts->dur) {
+			ackto = ack_ts - st_ts->tstamp - st_ts->dur;
+
+			if (ackto < MAX_DELAY) {
+				sta = ieee80211_find_sta_by_ifaddr(ah->hw, dst,
+								   src);
+				if (sta) {
+					an = (struct ath_node *)sta->drv_priv;
+					an->ackto = ath_dynack_ewma(an->ackto,
+								    ackto);
+					ath_dbg(ath9k_hw_common(ah), DYNACK,
+						"%pM to %u\n", dst, an->ackto);
+					if (time_is_before_jiffies(da->lto)) {
+						ath_dynack_compute_ackto(ah);
+						da->lto = jiffies + COMPUTE_TO;
+					}
+				}
+				INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
+			}
+			INCR(da->st_rbf.h_rb, ATH_DYN_BUF);
+		} else {
+			INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
+		}
+	}
+
+	rcu_read_unlock();
+}
+
+/**
+ * ath_dynack_sample_tx_ts - status timestamp sampling method
+ * @ah: ath hw
+ * @skb: socket buffer
+ * @ts: tx status info
+ *
+ */
+void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
+			     struct ath_tx_status *ts)
+{
+	u8 ridx;
+	struct ieee80211_hdr *hdr;
+	struct ath_dynack *da = &ah->dynack;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	if ((info->flags & IEEE80211_TX_CTL_NO_ACK) || !da->enabled)
+		return;
+
+	spin_lock_bh(&da->qlock);
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
+	/* late ACK */
+	if (ts->ts_status & ATH9K_TXERR_XRETRY) {
+		if (ieee80211_is_assoc_req(hdr->frame_control) ||
+		    ieee80211_is_assoc_resp(hdr->frame_control)) {
+			ath_dbg(common, DYNACK, "late ack\n");
+			ath9k_hw_setslottime(ah, (LATEACK_TO - 3) / 2);
+			ath9k_hw_set_ack_timeout(ah, LATEACK_TO);
+			ath9k_hw_set_cts_timeout(ah, LATEACK_TO);
+			da->lto = jiffies + LATEACK_DELAY;
+		}
+
+		spin_unlock_bh(&da->qlock);
+		return;
+	}
+
+	ridx = ts->ts_rateindex;
+
+	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
+	da->st_rbf.ts[da->st_rbf.t_rb].dur = ts->duration[ts->ts_rateindex];
+	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
+	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
+
+	if (!(info->status.rates[ridx].flags & IEEE80211_TX_RC_MCS)) {
+		u32 phy, sifs;
+		const struct ieee80211_rate *rate;
+		struct ieee80211_tx_rate *rates = info->status.rates;
+
+		rate = &common->sbands[info->band].bitrates[rates[ridx].idx];
+		if (info->band == IEEE80211_BAND_2GHZ &&
+		    !(rate->flags & IEEE80211_RATE_ERP_G))
+			phy = WLAN_RC_PHY_CCK;
+		else
+			phy = WLAN_RC_PHY_OFDM;
+
+		sifs = ath_dynack_get_sifs(ah, phy);
+		da->st_rbf.ts[da->st_rbf.t_rb].dur -= sifs;
+	}
+
+	ath_dbg(common, DYNACK, "{%pM} tx sample %u [dur %u][h %u-t %u]\n",
+		hdr->addr1, da->st_rbf.ts[da->st_rbf.t_rb].tstamp,
+		da->st_rbf.ts[da->st_rbf.t_rb].dur, da->st_rbf.h_rb,
+		(da->st_rbf.t_rb + 1) % ATH_DYN_BUF);
+
+	INCR(da->st_rbf.t_rb, ATH_DYN_BUF);
+	if (da->st_rbf.t_rb == da->st_rbf.h_rb)
+		INCR(da->st_rbf.h_rb, ATH_DYN_BUF);
+
+	ath_dynack_compute_to(ah);
+
+	spin_unlock_bh(&da->qlock);
+}
+EXPORT_SYMBOL(ath_dynack_sample_tx_ts);
+
+/**
+ * ath_dynack_sample_ack_ts - ACK timestamp sampling method
+ * @ah: ath hw
+ * @skb: socket buffer
+ * @ts: rx timestamp
+ *
+ */
+void ath_dynack_sample_ack_ts(struct ath_hw *ah, struct sk_buff *skb,
+			      u32 ts)
+{
+	struct ath_dynack *da = &ah->dynack;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ath_dynack_bssidmask(ah, hdr->addr1) || !da->enabled)
+		return;
+
+	spin_lock_bh(&da->qlock);
+	da->ack_rbf.tstamp[da->ack_rbf.t_rb] = ts;
+
+	ath_dbg(common, DYNACK, "rx sample %u [h %u-t %u]\n",
+		da->ack_rbf.tstamp[da->ack_rbf.t_rb],
+		da->ack_rbf.h_rb, (da->ack_rbf.t_rb + 1) % ATH_DYN_BUF);
+
+	INCR(da->ack_rbf.t_rb, ATH_DYN_BUF);
+	if (da->ack_rbf.t_rb == da->ack_rbf.h_rb)
+		INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
+
+	ath_dynack_compute_to(ah);
+
+	spin_unlock_bh(&da->qlock);
+}
+EXPORT_SYMBOL(ath_dynack_sample_ack_ts);
+
+/**
+ * ath_dynack_node_init - init ath_node related info
+ * @ah: ath hw
+ * @an: ath node
+ *
+ */
+void ath_dynack_node_init(struct ath_hw *ah, struct ath_node *an)
+{
+	/* ackto = slottime + sifs + air delay */
+	u32 ackto = ATH9K_SLOT_TIME_9 + 16 + 64;
+	struct ath_dynack *da = &ah->dynack;
+
+	an->ackto = ackto;
+
+	spin_lock(&da->qlock);
+	list_add_tail(&an->list, &da->nodes);
+	spin_unlock(&da->qlock);
+}
+EXPORT_SYMBOL(ath_dynack_node_init);
+
+/**
+ * ath_dynack_node_deinit - deinit ath_node related info
+ * @ah: ath hw
+ * @an: ath node
+ *
+ */
+void ath_dynack_node_deinit(struct ath_hw *ah, struct ath_node *an)
+{
+	struct ath_dynack *da = &ah->dynack;
+
+	spin_lock(&da->qlock);
+	list_del(&an->list);
+	spin_unlock(&da->qlock);
+}
+EXPORT_SYMBOL(ath_dynack_node_deinit);
+
+/**
+ * ath_dynack_reset - reset dynack processing
+ * @ah: ath hw
+ *
+ */
+void ath_dynack_reset(struct ath_hw *ah)
+{
+	/* ackto = slottime + sifs + air delay */
+	u32 ackto = ATH9K_SLOT_TIME_9 + 16 + 64;
+	struct ath_dynack *da = &ah->dynack;
+
+	da->lto = jiffies;
+	da->ackto = ackto;
+
+	da->st_rbf.t_rb = 0;
+	da->st_rbf.h_rb = 0;
+	da->ack_rbf.t_rb = 0;
+	da->ack_rbf.h_rb = 0;
+
+	/* init acktimeout */
+	ath9k_hw_setslottime(ah, (ackto - 3) / 2);
+	ath9k_hw_set_ack_timeout(ah, ackto);
+	ath9k_hw_set_cts_timeout(ah, ackto);
+}
+EXPORT_SYMBOL(ath_dynack_reset);
+
+/**
+ * ath_dynack_init - init dynack data structure
+ * @ah: ath hw
+ *
+ */
+void ath_dynack_init(struct ath_hw *ah)
+{
+	struct ath_dynack *da = &ah->dynack;
+
+	memset(da, 0, sizeof(struct ath_dynack));
+
+	spin_lock_init(&da->qlock);
+	INIT_LIST_HEAD(&da->nodes);
+
+	ah->hw->wiphy->features |= NL80211_FEATURE_ACKTO_ESTIMATION;
+}
+
diff --git a/drivers/net/wireless/ath/ath9k/dynack.h b/drivers/net/wireless/ath/ath9k/dynack.h
new file mode 100644
index 0000000..6d7bef9
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dynack.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright (c) 2014, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef DYNACK_H
+#define DYNACK_H
+
+#define ATH_DYN_BUF	64
+
+struct ath_hw;
+struct ath_node;
+
+/**
+ * struct ath_dyn_rxbuf - ACK frame ring buffer
+ * @h_rb: ring buffer head
+ * @t_rb: ring buffer tail
+ * @tstamp: ACK RX timestamp buffer
+ */
+struct ath_dyn_rxbuf {
+	u16 h_rb, t_rb;
+	u32 tstamp[ATH_DYN_BUF];
+};
+
+struct ts_info {
+	u32 tstamp;
+	u32 dur;
+};
+
+struct haddr_pair {
+	u8 h_dest[ETH_ALEN];
+	u8 h_src[ETH_ALEN];
+};
+
+/**
+ * struct ath_dyn_txbuf - tx frame ring buffer
+ * @h_rb: ring buffer head
+ * @t_rb: ring buffer tail
+ * @addr: dest/src address pair for a given TX frame
+ * @ts: TX frame timestamp buffer
+ */
+struct ath_dyn_txbuf {
+	u16 h_rb, t_rb;
+	struct haddr_pair addr[ATH_DYN_BUF];
+	struct ts_info ts[ATH_DYN_BUF];
+};
+
+/**
+ * struct ath_dynack - dynack processing info
+ * @enabled: enable dyn ack processing
+ * @ackto: current ACK timeout
+ * @lto: last ACK timeout computation
+ * @nodes: ath_node linked list
+ * @qlock: ts queue spinlock
+ * @ack_rbf: ACK ts ring buffer
+ * @st_rbf: status ts ring buffer
+ */
+struct ath_dynack {
+	bool enabled;
+	int ackto;
+	unsigned long lto;
+
+	struct list_head nodes;
+
+	/* protect timestamp queue access */
+	spinlock_t qlock;
+	struct ath_dyn_rxbuf ack_rbf;
+	struct ath_dyn_txbuf st_rbf;
+};
+
+#if defined(CONFIG_ATH9K_DYNACK)
+void ath_dynack_reset(struct ath_hw *ah);
+void ath_dynack_node_init(struct ath_hw *ah, struct ath_node *an);
+void ath_dynack_node_deinit(struct ath_hw *ah, struct ath_node *an);
+void ath_dynack_init(struct ath_hw *ah);
+void ath_dynack_sample_ack_ts(struct ath_hw *ah, struct sk_buff *skb, u32 ts);
+void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
+			     struct ath_tx_status *ts);
+#else
+static inline void ath_dynack_init(struct ath_hw *ah) {}
+static inline void ath_dynack_node_init(struct ath_hw *ah,
+					struct ath_node *an) {}
+static inline void ath_dynack_node_deinit(struct ath_hw *ah,
+					  struct ath_node *an) {}
+static inline void ath_dynack_sample_ack_ts(struct ath_hw *ah,
+					    struct sk_buff *skb, u32 ts) {}
+static inline void ath_dynack_sample_tx_ts(struct ath_hw *ah,
+					   struct sk_buff *skb,
+					   struct ath_tx_status *ts) {}
+#endif
+
+#endif /* DYNACK_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ce395e2..e71f824 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -647,6 +647,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 		return ret;
 	}
 
+	ath_dynack_init(ah);
+
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_init);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f36d971..b9eef33 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -29,6 +29,7 @@
 #include "reg.h"
 #include "phy.h"
 #include "btcoex.h"
+#include "dynack.h"
 
 #include "../regd.h"
 
@@ -924,6 +925,8 @@ struct ath_hw {
 	int (*external_reset)(void);
 
 	const struct firmware *eeprom_blob;
+
+	struct ath_dynack dynack;
 };
 
 struct ath_bus_ops {
-- 
1.9.1

