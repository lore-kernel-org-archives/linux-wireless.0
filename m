Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866AbYGABXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 21:23:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH-2.6.26 2/2] iwlwifi: drop skb silently for Tx request in monitor mode
Date: Tue,  1 Jul 2008 09:20:34 +0800
Message-Id: <1214875234-23567-3-git-send-email-yi.zhu@intel.com> (sfid-20080701_032337_943385_9049B203)
In-Reply-To: <1214875234-23567-2-git-send-email-yi.zhu@intel.com>
References: <1214875234-23567-1-git-send-email-yi.zhu@intel.com>
 <1214875234-23567-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the problem to keep mac80211 resubmitting SKBs
when Tx request cannot be met in monitor mode.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 13925b6..2c7f054 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6684,7 +6684,8 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
 		IWL_DEBUG_MAC80211("leave - monitor\n");
-		return -1;
+		dev_kfree_skb_any(skb);
+		return 0;
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 883b42f..101eb56 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6234,7 +6234,8 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
 		IWL_DEBUG_MAC80211("leave - monitor\n");
-		return -1;
+		dev_kfree_skb_any(skb);
+		return 0;
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-- 
1.5.3.6

