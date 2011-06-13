Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40421 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1FMWgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:36:53 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id A78D5EF652
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:51 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 81AB4402E
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:50 +0300 (EEST)
Subject: [PATCH v2 14/27] mac80211: rename ieee80211_if_ap to mac80211_if_ap
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:36:44 +0300
Message-ID: <20110613223644.10517.36742.stgit@localhost6.localdomain6> (sfid-20110614_005722_600137_A1B749DF)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    6 +++---
 net/mac80211/sta_info.c   |    8 ++++----
 net/mac80211/tx.c         |    8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 035905e..54d0751 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -213,7 +213,7 @@ struct beacon_data {
 	int dtim_period;
 };
 
-struct ieee80211_if_ap {
+struct mac80211_if_ap {
 	struct beacon_data __rcu *beacon;
 
 	struct list_head vlans;
@@ -587,13 +587,13 @@ struct ieee80211_sub_if_data {
 	 * corresponding AP in VLAN mode, NULL for
 	 * all others (might be needed later in IBSS)
 	 */
-	struct ieee80211_if_ap *bss;
+	struct mac80211_if_ap *bss;
 
 	/* bitmap of allowed (non-MCS) rate indexes for rate control */
 	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
 
 	union {
-		struct ieee80211_if_ap ap;
+		struct mac80211_if_ap ap;
 		struct ieee80211_if_wds wds;
 		struct ieee80211_if_vlan vlan;
 		struct ieee80211_if_managed mgd;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5f649aa..d148159 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -496,7 +496,7 @@ int sta_info_insert(struct sta_info *sta)
 	return err;
 }
 
-static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
+static inline void __bss_tim_set(struct mac80211_if_ap *bss, u16 aid)
 {
 	/*
 	 * This format has been mandated by the IEEE specifications,
@@ -505,7 +505,7 @@ static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
 	bss->tim[aid / 8] |= (1 << (aid % 8));
 }
 
-static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
+static inline void __bss_tim_clear(struct mac80211_if_ap *bss, u16 aid)
 {
 	/*
 	 * This format has been mandated by the IEEE specifications,
@@ -514,7 +514,7 @@ static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
 	bss->tim[aid / 8] &= ~(1 << (aid % 8));
 }
 
-static void __sta_info_set_tim_bit(struct ieee80211_if_ap *bss,
+static void __sta_info_set_tim_bit(struct mac80211_if_ap *bss,
 				   struct sta_info *sta)
 {
 	BUG_ON(!bss);
@@ -539,7 +539,7 @@ void sta_info_set_tim_bit(struct sta_info *sta)
 	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 }
 
-static void __sta_info_clear_tim_bit(struct ieee80211_if_ap *bss,
+static void __sta_info_clear_tim_bit(struct mac80211_if_ap *bss,
 				     struct sta_info *sta)
 {
 	BUG_ON(!bss);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 28811f4..fa682fe 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -331,7 +331,7 @@ static void purge_old_ps_buffers(struct mac80211_local *local)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		struct ieee80211_if_ap *ap;
+		struct mac80211_if_ap *ap;
 		if (sdata->vif.type != NL80211_IFTYPE_AP)
 			continue;
 		ap = &sdata->u.ap;
@@ -2098,7 +2098,7 @@ void ieee80211_tx_pending(unsigned long data)
 
 /* functions for drivers to get certain frames */
 
-static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
+static void ieee80211_beacon_add_tim(struct mac80211_if_ap *bss,
 				     struct sk_buff *skb,
 				     struct beacon_data *beacon)
 {
@@ -2170,7 +2170,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata = NULL;
-	struct ieee80211_if_ap *ap = NULL;
+	struct mac80211_if_ap *ap = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band = local->hw.conf.channel->band;
@@ -2486,7 +2486,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct mac80211_tx_data tx;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_ap *bss = NULL;
+	struct mac80211_if_ap *bss = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_tx_info *info;
 

