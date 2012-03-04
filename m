Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab2CDUnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 071/101] iwlwifi: remove two unused arguments in testmode
Date: Sun,  4 Mar 2012 11:29:25 -0800
Message-Id: <1330889395-533-72-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214526_089967_FCD8C467)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The dump functions never access the incoming
attributes, so don't pass them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 5b06916..1d73209 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -713,7 +713,7 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
-static int iwl_testmode_trace_dump(struct ieee80211_hw *hw, struct nlattr **tb,
+static int iwl_testmode_trace_dump(struct ieee80211_hw *hw,
 				   struct sk_buff *skb,
 				   struct netlink_callback *cb)
 {
@@ -905,9 +905,9 @@ static int iwl_testmode_indirect_mem(struct ieee80211_hw *hw,
 	}
 }
 
-static int iwl_testmode_buffer_dump(struct ieee80211_hw *hw, struct nlattr **tb,
-				   struct sk_buff *skb,
-				   struct netlink_callback *cb)
+static int iwl_testmode_buffer_dump(struct ieee80211_hw *hw,
+				    struct sk_buff *skb,
+				    struct netlink_callback *cb)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int idx, length;
@@ -1067,11 +1067,11 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 	switch (cmd) {
 	case IWL_TM_CMD_APP2DEV_READ_TRACE:
 		IWL_DEBUG_INFO(priv, "uCode trace cmd to driver\n");
-		result = iwl_testmode_trace_dump(hw, tb, skb, cb);
+		result = iwl_testmode_trace_dump(hw, skb, cb);
 		break;
 	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP:
 		IWL_DEBUG_INFO(priv, "testmode sram dump cmd to driver\n");
-		result = iwl_testmode_buffer_dump(hw, tb, skb, cb);
+		result = iwl_testmode_buffer_dump(hw, skb, cb);
 		break;
 	default:
 		result = -EINVAL;
-- 
1.7.0.4

