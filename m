Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3269 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYDAWEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 18:04:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] wireless: fix various printk warnings on ia64 (and others)
Date: Tue,  1 Apr 2008 17:40:03 -0400
Message-Id: <1207086003-1036-1-git-send-email-linville@tuxdriver.com> (sfid-20080401_230436_988564_4C7BCA5E)
In-Reply-To: <20080328003310.e7e119f5.akpm@linux-foundation.org>
References: <20080328003310.e7e119f5.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath5k/base.c: In function `ath5k_check_ibss_tsf':
drivers/net/wireless/ath5k/base.c:1740: warning: long long unsigned int format, u64 arg (arg 5)
drivers/net/wireless/ath5k/base.c:1740: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/wireless/ath5k/base.c:1740: warning: long long int format, u64 arg (arg 7)
drivers/net/wireless/ath5k/base.c:1740: warning: long long unsigned int format, u64 arg (arg 8)
drivers/net/wireless/ath5k/base.c:1757: warning: long long unsigned int format, u64 arg (arg 5)
drivers/net/wireless/ath5k/base.c:1757: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/wireless/iwlwifi/iwl4965-base.c: In function `iwl4965_tx_status_reply_tx':
drivers/net/wireless/iwlwifi/iwl4965-base.c:3105: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/wireless/iwlwifi/iwl-4965.c: In function `iwl4965_rx_reply_rx':
drivers/net/wireless/iwlwifi/iwl-4965.c:3978: warning: long long unsigned int format, u64 arg (arg 7)

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath5k/base.c           |    9 ++++++---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index b5c0a0d..8862d24 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1739,8 +1739,10 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 
 		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
 			"beacon %llx mactime %llx (diff %lld) tsf now %llx\n",
-			bc_tstamp, rxs->mactime,
-			(rxs->mactime - bc_tstamp), tsf);
+			(unsigned long long)bc_tstamp,
+			(unsigned long long)rxs->mactime,
+			(unsigned long long)(rxs->mactime - bc_tstamp),
+			(unsigned long long)tsf);
 
 		/*
 		 * Sometimes the HW will give us a wrong tstamp in the rx
@@ -1756,7 +1758,8 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 		if (bc_tstamp > rxs->mactime) {
 			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
 				"fixing mactime from %llx to %llx\n",
-				rxs->mactime, tsf);
+				(unsigned long long)rxs->mactime,
+				(unsigned long long)tsf);
 			rxs->mactime = tsf;
 		}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 51a1449..89d600c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3971,7 +3971,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
 			      rx_status.ssi, rx_status.noise, rx_status.signal,
-			      rx_status.mactime);
+			      (unsigned long long)rx_status.mactime);
 
 	network_packet = iwl4965_is_network_packet(priv, header);
 	if (network_packet) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e98695f..8d49ff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3119,7 +3119,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
-				   agg->bitmap);
+				   (unsigned long long)agg->bitmap);
 
 		if (bitmap)
 			agg->wait_for_ba = 1;
-- 
1.5.3.3

