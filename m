Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbXI0Dev (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: Fix typo in rate sacling algorithm
Date: Thu, 27 Sep 2007 11:27:34 +0800
Message-Id: <11908636712746-git-send-email-yi.zhu@intel.com>
In-Reply-To: <119086367088-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes tiny typo in 4965 rate sacling algorithm

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index bc5e67b..edcc542 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1672,7 +1672,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	tbl->antenna_type = ANT_AUX;
 	rs_get_tbl_info_from_mcs(&mcs_rate, priv->phymode, tbl, &rate_idx);
 	if (!rs_is_ant_connected(priv->valid_antenna, tbl->antenna_type))
-	    rs_toggle_antenna(&mcs_rate, tbl),
+	    rs_toggle_antenna(&mcs_rate, tbl);
 
 	rs_mcs_from_tbl(&mcs_rate, tbl, rate_idx, use_green);
 	tbl->current_rate.rate_n_flags = mcs_rate.rate_n_flags;
-- 
1.5.1
