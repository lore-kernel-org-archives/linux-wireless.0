Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6474 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbYAaGKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:10:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/5] iwlwifi: fix sparse warning in iwl 3945
Date: Wed, 30 Jan 2008 22:05:12 -0800
Message-Id: <1201759516-28963-2-git-send-email-reinette.chatre@intel.com> (sfid-20080131_061036_457494_70B7314D)
In-Reply-To: <1201759516-28963-1-git-send-email-reinette.chatre@intel.com>
References: <1201759516-28963-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes a sparse warning over iwl3945_add_radiotap function by
turning it static

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1bc05c3..50d927b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -238,9 +238,10 @@ void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_b
 	priv->last_statistics_time = jiffies;
 }
 
-void iwl3945_add_radiotap(struct iwl3945_priv *priv, struct sk_buff *skb,
-			  struct iwl3945_rx_frame_hdr *rx_hdr,
-			  struct ieee80211_rx_status *stats)
+static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
+				 struct sk_buff *skb,
+				 struct iwl3945_rx_frame_hdr *rx_hdr,
+				 struct ieee80211_rx_status *stats)
 {
 	/* First cache any information we need before we overwrite
 	 * the information provided in the skb from the hardware */
-- 
1.5.3.4

