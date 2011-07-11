Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2703 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab1GKSWR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 14:22:17 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-3.1] iwlagn: fix warning in testmode attribute table
Date: Mon, 11 Jul 2011 10:47:39 -0700
Message-Id: <1310406459-17571-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110711_202220_739336_42CF52B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the compile warning cause by [IWL_TM_ATTR_MAX - 1]

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index c00aa5a..b17a330 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -607,7 +607,7 @@ static int iwl_testmode_trace_dump(struct ieee80211_hw *hw, struct nlattr **tb,
  */
 int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
-	struct nlattr *tb[IWL_TM_ATTR_MAX - 1];
+	struct nlattr *tb[IWL_TM_ATTR_MAX];
 	struct iwl_priv *priv = hw->priv;
 	int result;
 
-- 
1.7.0.4

