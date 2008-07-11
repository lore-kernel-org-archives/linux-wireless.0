Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbYGKD4w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:56:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Guy Cohen <guy.cohen@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/14] iwlwifi: rs always set lq_sta->priv
Date: Fri, 11 Jul 2008 11:53:33 +0800
Message-Id: <1215748422-12672-6-git-send-email-yi.zhu@intel.com> (sfid-20080711_055655_990497_C8A7458E)
In-Reply-To: <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes printk NULL pointer exceptions in rs code.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index c7ebb3b..3ccb84a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2265,9 +2265,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
-#ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->drv = priv;
-#endif
 
 	rs_initialize_lq(priv, conf, sta);
 }
-- 
1.5.3.6

