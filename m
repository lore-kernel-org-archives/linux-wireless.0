Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32658 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbYF3J1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 29/33] iwlwifi: drop skb silently for Tx request in monitor mode
Date: Mon, 30 Jun 2008 17:23:29 +0800
Message-Id: <1214817813-17639-30-git-send-email-yi.zhu@intel.com> (sfid-20080630_113813_454594_52EC7F26)
In-Reply-To: <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
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
index 4f0a18a..2744b0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6695,7 +6695,8 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
 		IWL_DEBUG_MAC80211("leave - monitor\n");
-		return -1;
+		dev_kfree_skb_any(skb);
+		return 0;
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ba0f289..60b7a64 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2682,7 +2682,8 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
 		IWL_DEBUG_MAC80211("leave - monitor\n");
-		return -1;
+		dev_kfree_skb_any(skb);
+		return 0;
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-- 
1.5.3.6

