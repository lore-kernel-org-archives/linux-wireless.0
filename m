Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53795 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1437747AbdDZPLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 11:11:38 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 4/5] mac80211: add per-packet transmit power to rate tables
Date: Wed, 26 Apr 2017 17:11:38 +0200
Message-Id: <20170426151139.87304-4-nbd@nbd.name> (sfid-20170426_172635_875435_570EE903)
In-Reply-To: <20170426151139.87304-1-nbd@nbd.name>
References: <20170426151139.87304-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used to allow rate control to control per-packet tx power.
Since cb space is tight and minstrel/minstrel_ht uses
info->control.rates only for the sampling rate, the tx power field in
info->control refers to the first rate attempt entry only.

Transmit power for the selected best rate set is stored in struct
ieee80211_sta_rates.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Thomas Huehn <thomas.huehn@evernet-eg.de>
---
 include/net/mac80211.h             | 10 ++++++++--
 net/mac80211/rate.c                |  2 ++
 net/mac80211/rc80211_minstrel.c    |  9 +++++++++
 net/mac80211/rc80211_minstrel_ht.c |  8 ++++++++
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1b81f0c90068..d29702601333 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -901,7 +901,12 @@ struct ieee80211_tx_info {
 					u8 use_cts_prot:1;
 					u8 short_preamble:1;
 					u8 skip_table:1;
-					/* 2 bytes free */
+
+					/* txpower field refers to the first
+					 * entry of rates only (if present).
+					 */
+					s8 txpower;
+					/* 1 byte free */
 				};
 				/* only needed before rate control */
 				unsigned long jiffies;
@@ -1733,13 +1738,14 @@ enum ieee80211_sta_rx_bandwidth {
  * struct ieee80211_sta_rates - station rate selection table
  *
  * @rcu_head: RCU head used for freeing the table on update
- * @rate: transmit rates/flags to be used by default.
+ * @rate: transmit rates/power/flags to be used by default.
  *	Overriding entries per-packet is possible by using cb tx control.
  */
 struct ieee80211_sta_rates {
 	struct rcu_head rcu_head;
 	struct {
 		s8 idx;
+		s8 txpower;
 		u8 count;
 		u8 count_cts;
 		u8 count_rts;
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index b387c07b8b47..394e36570047 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -899,6 +899,8 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		info->control.rates[i].count = 0;
 	}
 
+	info->control.txpower = sdata->vif.bss_conf.txpower;
+
 	if (ieee80211_hw_check(&sdata->local->hw, HAS_RATE_CONTROL))
 		return;
 
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 9766c1cc4b0a..8b82a72b1f01 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -52,6 +52,7 @@
 #include <linux/ieee80211.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
+#include "sta_info.h"
 #include "rate.h"
 #include "rc80211_minstrel.h"
 
@@ -125,12 +126,20 @@ static void
 minstrel_update_rates(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 {
 	struct ieee80211_sta_rates *ratetbl;
+	struct sta_info *sta;
+	s8 txpower;
 	int i = 0;
 
+	sta = container_of(mi->sta, struct sta_info, sta);
+	txpower = sta->sdata->vif.bss_conf.txpower;
+
 	ratetbl = kzalloc(sizeof(*ratetbl), GFP_ATOMIC);
 	if (!ratetbl)
 		return;
 
+	for (i = 0; i < ARRAY_SIZE(ratetbl->rate); i++)
+		ratetbl->rate[i].txpower = txpower;
+
 	/* Start with max_tp_rate */
 	minstrel_set_rate(mi, ratetbl, i++, mi->max_tp_rate[0]);
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 4a5bdad9f303..c52c546cce57 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -921,12 +921,20 @@ static void
 minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct ieee80211_sta_rates *rates;
+	struct sta_info *sta;
+	s8 txpower;
 	int i = 0;
 
+	sta = container_of(mi->sta, struct sta_info, sta);
+	txpower = sta->sdata->vif.bss_conf.txpower;
+
 	rates = kzalloc(sizeof(*rates), GFP_ATOMIC);
 	if (!rates)
 		return;
 
+	for (i = 0; i < ARRAY_SIZE(rates->rate); i++)
+		rates->rate[i].txpower = txpower;
+
 	/* Start with max_tp_rate[0] */
 	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[0]);
 
-- 
2.11.0
