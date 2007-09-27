Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbXI0Dey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: removing unnecessary memset in 4965 rate scale
Date: Thu, 27 Sep 2007 11:27:36 +0800
Message-Id: <11908636743625-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636732679-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes redundant memset in rate scale. In rs_alloc_sta,
kzalloc is used so the memset can be avoided. In rs_rate_init, it is
a bug fix since it overrides everything set in other handlers namely
add_debugfs.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index edcc542..86e650d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1776,10 +1776,9 @@ static void *rs_alloc_sta(void *priv, gfp_t gfp)
 
 	if (crl == NULL)
 		return NULL;
-
-	memset(crl, 0, sizeof(struct iwl_rate_scale_priv));
 	crl->lq.sta_id = 0xff;
 
+
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&(crl->lq_info[j].win[i]));
@@ -1796,9 +1795,6 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl_rate_scale_priv *crl = priv_sta;
 
-	memset(crl, 0, sizeof(struct iwl_rate_scale_priv));
-
-	crl->lq.sta_id = 0xff;
 	crl->flush_timer = 0;
 	sta->txrate = 3;
 	for (j = 0; j < LQ_SIZE; j++)
-- 
1.5.1
