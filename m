Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759935AbZKFWw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:52:59 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/20] iwlwifi: allocate 128 bytes linear buffer for rx skb
Date: Fri,  6 Nov 2009 14:52:45 -0800
Message-Id: <1257547983-12590-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Allocate 128 bytes linear buffer for rx skb. The first 64 bytes is
reserved for mac80211 usage (for radiotap header expansion, etc).
The frame header starts from the second 64 bytes.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 562860b..7da1dab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -565,7 +565,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 		return;
 	}
 
-	skb = alloc_skb(IWL_LINK_HDR_MAX, GFP_ATOMIC);
+	skb = alloc_skb(IWL_LINK_HDR_MAX * 2, GFP_ATOMIC);
 	if (!skb) {
 		IWL_ERR(priv, "alloc_skb failed\n");
 		return;
@@ -576,6 +576,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				       (struct ieee80211_hdr *)rxb_addr(rxb),
 				       le32_to_cpu(rx_end->status), stats);
 
+	skb_reserve(skb, IWL_LINK_HDR_MAX);
 	skb_add_rx_frag(skb, 0, rxb->page,
 			(void *)rx_hdr->payload - (void *)pkt, len);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index e5339c9..d2dc7cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -937,12 +937,13 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
-	skb = alloc_skb(IWL_LINK_HDR_MAX, GFP_ATOMIC);
+	skb = alloc_skb(IWL_LINK_HDR_MAX * 2, GFP_ATOMIC);
 	if (!skb) {
 		IWL_ERR(priv, "alloc_skb failed\n");
 		return;
 	}
 
+	skb_reserve(skb, IWL_LINK_HDR_MAX);
 	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
 
 	/* mac80211 currently doesn't support paged SKB. Convert it to
-- 
1.5.6.3

