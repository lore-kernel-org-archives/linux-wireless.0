Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab1BKUUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 15:20:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: handle bt defer work in 2000 series
Date: Fri, 11 Feb 2011 12:07:01 -0800
Message-Id: <1297454821-14904-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1297454821-14904-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1297454821-14904-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 2000 series, need to handle bt traffic changes when
receive notification from uCode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 3c5dd36..30483e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -265,7 +265,8 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
-	.setup_deferred_work = iwlagn_setup_deferred_work,
+	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
+	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
-- 
1.7.0.4

