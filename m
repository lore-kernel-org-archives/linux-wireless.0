Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab0DIUJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/12] iwlwifi: fix compile warnings when compiling without debug
Date: Fri,  9 Apr 2010 13:09:27 -0700
Message-Id: <1270843769-30017-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Fixes:
CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-rs.o
drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In function ‘rs_get_rate’:
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2419: warning: unused variable ‘priv’
CC [M]  drivers/net/wireless/iwlwifi/iwl-sta.o
drivers/net/wireless/iwlwifi/iwl-sta.c: In function ‘iwl_send_add_sta’:
drivers/net/wireless/iwlwifi/iwl-sta.c:197: warning: unused variable ‘sta_id’

drivers/net/wireless/iwlwifi/iwl-3945.c: In function ‘iwl3945_rx_reply_rx’:
drivers/net/wireless/iwlwifi/iwl-3945.c:601: warning: unused variable ‘rx_stats_noise_diff’
drivers/net/wireless/iwlwifi/iwl-3945.c:600: warning: unused variable ‘rx_stats_sig_avg’
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function ‘rs_get_rate’:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:650: warning: unused variable ‘priv’

Reported-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 9e411dc..80e9bbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -647,7 +647,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	unsigned long flags;
 	u16 rate_mask = sta ? sta->supp_rates[sband->band] : 0;
 	s8 max_rate_idx = -1;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct iwl_priv *priv __maybe_unused = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	IWL_DEBUG_RATE(priv, "enter\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ae5efc3..15de649 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -597,8 +597,8 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
-	u16 rx_stats_sig_avg = le16_to_cpu(rx_stats->sig_avg);
-	u16 rx_stats_noise_diff = le16_to_cpu(rx_stats->noise_diff);
+	u16 rx_stats_sig_avg __maybe_unused = le16_to_cpu(rx_stats->sig_avg);
+	u16 rx_stats_noise_diff __maybe_unused = le16_to_cpu(rx_stats->noise_diff);
 	u8 network_packet;
 
 	rx_status.flag = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 0c3c768..3c1cd41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2409,7 +2409,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_supported_band *sband = txrc->sband;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct iwl_priv *priv __maybe_unused = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	int rate_idx;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 6876f7c..9b4d527 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -194,7 +194,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		.flags = flags,
 		.data = data,
 	};
-	u8 sta_id = sta->sta.sta_id;
+	u8 sta_id __maybe_unused = sta->sta.sta_id;
 
 	IWL_DEBUG_INFO(priv, "Adding sta %u (%pM) %ssynchronously\n",
 		       sta_id, sta->sta.addr, flags & CMD_ASYNC ?  "a" : "");
-- 
1.6.3.3

