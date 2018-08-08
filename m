Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbeHHM7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 08:59:40 -0400
From: Wen Gong <wgong@codeaurora.org>
To: ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] mac80211: Change sk_pacing_shift saved to ieee80211_hw
Date: Wed,  8 Aug 2018 18:40:01 +0800
Message-Id: <1533724802-30944-2-git-send-email-wgong@codeaurora.org> (sfid-20180808_124035_642380_12F9B437)
In-Reply-To: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the skb_pacing_shift adjustment, this change make it
configurable for other driver. If no other driver set it, then
mac8011 will use the default value.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
V2:
-add the description for tx_sk_pacing_shift
 include/net/mac80211.h | 5 +++++
 net/mac80211/main.c    | 2 ++
 net/mac80211/tx.c      | 2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55..9804d65 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2290,6 +2290,10 @@ enum ieee80211_hw_flags {
  *	supported by HW.
  * @max_nan_de_entries: maximum number of NAN DE functions supported by the
  *	device.
+ *
+ * @tx_sk_pacing_shift: The TCP stack allow more than a single ms of data
+ *	to be queued in the stack. The value is a bit-shift of 1 second, e.g. 8
+ *	is ~4ms of queued data. It only affects local TCP sockets.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2325,6 +2329,7 @@ struct ieee80211_hw {
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
 	u8 max_nan_de_entries;
+	u8 tx_sk_pacing_shift;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4fb2709..23490fa 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -594,6 +594,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	local->ops = ops;
 	local->use_chanctx = use_chanctx;
 
+	local->hw.tx_sk_pacing_shift = 8;
+
 	/* set up some defaults */
 	local->hw.queues = 1;
 	local->hw.max_rates = 1;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6a79d56..80855a8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3601,7 +3601,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		 * second, so 8 is ~4ms of queued data. Only affects local TCP
 		 * sockets.
 		 */
-		sk_pacing_shift_update(skb->sk, 8);
+		sk_pacing_shift_update(skb->sk, sdata->local->hw.tx_sk_pacing_shift);
 
 		fast_tx = rcu_dereference(sta->fast_tx);
 
-- 
1.9.1
