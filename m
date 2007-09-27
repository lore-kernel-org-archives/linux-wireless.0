Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbXI0De5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:57 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: limit printouts on hot path
Date: Thu, 27 Sep 2007 11:27:39 +0800
Message-Id: <11908636781043-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636772860-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
 <11908636743625-git-send-email-yi.zhu@intel.com>
 <11908636753775-git-send-email-yi.zhu@intel.com>
 <11908636772860-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch change printouts on TX path to the net_ratelimit version.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index e3a0cca..b9d7ad8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -622,7 +622,7 @@ static void rs_tx_status(void *priv_rate,
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	s32 tpt = 0;
 
-	IWL_DEBUG_RATE("get frame ack response, update rate scale window\n");
+	IWL_DEBUG_RATE_LIMIT("get frame ack response, update rate scale window\n");
 
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
 		return;
@@ -1717,7 +1717,7 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl_rate_scale_priv *lq;
 
-	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
+	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
 	memset(extra, 0, sizeof(*extra));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b704fe7..b41addf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -184,7 +184,7 @@ u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *addr)
 			goto out;
 		}
 
-	IWL_DEBUG_ASSOC("can not find STA %s total %d\n",
+	IWL_DEBUG_ASSOC_LIMIT("can not find STA " MAC_FMT " total %d\n",
 			print_mac(mac, addr), priv->num_stations);
 
  out:
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index abd344c..72318d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -136,8 +136,11 @@ static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 #define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
 #define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
 #define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
 #define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
 #define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
+	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
 #define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
 #define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
-- 
1.5.1
