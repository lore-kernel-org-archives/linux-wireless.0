Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbZASX2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/15] iwlwifi: return NETDEV_TX_OK from _tx ops
Date: Mon, 19 Jan 2009 15:30:32 -0800
Message-Id: <1232407835-19451-13-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002834_198140_A90EF344)
In-Reply-To: <1232407835-19451-12-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-10-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-11-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

be consistent with mac80211 drivers and return correct return code.
NETDEV_TX_OK is 0, but we need to be consistent wrt formatting amongst
implementations

re: http://marc.info/?l=linux-wireless&m=123119327419865&w=2

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9d06d4d..f3f00ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2608,7 +2608,7 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MACDUMP("leave\n");
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 static int iwl_mac_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index fc1c5f8..f3a4ed9 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5663,7 +5663,7 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MAC80211("leave\n");
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
-- 
1.5.4.3

