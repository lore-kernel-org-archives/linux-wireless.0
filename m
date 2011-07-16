Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab1GPPcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-3.1] iwlagn: fix warning in testmode attribute table
Date: Sat, 16 Jul 2011 07:56:21 -0700
Message-Id: <1310828199-18000-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173214_895666_2D640852)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
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

