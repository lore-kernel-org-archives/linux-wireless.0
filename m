Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZKTUFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 19/19 w-t only] iwlwifi: no need to set use_rts_for_ht for BG device
Date: Fri, 20 Nov 2009 12:05:10 -0800
Message-Id: <1258747510-21233-20-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The device configuration being changed here only affects devices that
cannot to N mode. Setting this HT only value is thus not needed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

This seems to be a merge problem introduced by iwlwifi's usage of the
iwl_cfg structure ... when these structures gets too long and they have too
many duplicate initializations there is trouble for correct patch merging.

The problem does not exist in wireless-next-2.6, but does in
wireless-testing. This patch is thus only for wireless-testing.

 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 325b244..59f2332 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -198,7 +198,6 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
 };
-- 
1.5.6.3

