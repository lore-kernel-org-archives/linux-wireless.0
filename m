Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760132AbZKFWxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 19/20] iwlwifi: Fix issue on file transfer stalled in HT mode
Date: Fri,  6 Nov 2009 14:53:02 -0800
Message-Id: <1257547983-12590-20-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Turn on RTS/CTS for HT to prevent uCode TX fifo underrun

This is fix for
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2103

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Jiajia Zheng <jiajia.zheng@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This is a serious problem that needs to be fixed also in 2.6.32 and 2.6.31.
This patch does depend on some other work that is not in these kernels
though so separate backported patches will be provided.

 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 1e387b9..8f82537 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -170,6 +170,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
 };
-- 
1.5.6.3

