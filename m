Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13219 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab0FNSYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwlwifi: cancel run time calibration work when going down
Date: Mon, 14 Jun 2010 11:24:49 -0700
Message-Id: <1276539892-12471-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
References: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Cancel scheduled run time calibration work when interface is going
down.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ce88bc0..4ade9a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3641,6 +3641,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->scan_check);
 	cancel_work_sync(&priv->start_internal_scan);
 	cancel_delayed_work(&priv->alive_start);
+	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
-- 
1.7.0.4

