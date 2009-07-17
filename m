Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47318 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964869AbZGQQaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/14] iwlwifi: fix rx signal quality reporting in dmesg
Date: Fri, 17 Jul 2009 09:30:15 -0700
Message-Id: <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Fix quality incorrectly reported as signal strength value.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 66fe365..fc7edd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1065,7 +1065,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
 #endif
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, qual %d, TSF %llu\n",
-		rx_status.signal, rx_status.noise, rx_status.signal,
+		rx_status.signal, rx_status.noise, rx_status.qual,
 		(unsigned long long)rx_status.mactime);
 
 	/*
-- 
1.5.6.3

