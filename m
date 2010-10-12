Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab0JLPzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 11:55:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/3] iwl3945: fix queue allocation
Date: Tue, 12 Oct 2010 08:53:55 -0700
Message-Id: <1286898835-31812-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286898835-31812-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286898835-31812-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit 6f98613258b966ffe0e6def18129b386514d10e0
Author: Jay Sternberg <jay.e.sternberg@intel.com>
Date:   Sat Sep 18 09:07:04 2010 -0700

    iwlagn: reduce redundant parameter definitions

broke 3945 because Jay accidentally removed the
num_of_queues parameter for 3945, so that we now
attempt to allocate a zero-sized queue array,
which leads to SLUB returning ZERO_SIZE_PTR (0x10)
which we then try to dereference thus crashing the
system. Restore the necessary num_of_queues param.

This fixes
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2254

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7d74ae5..176e525 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2753,6 +2753,7 @@ static const struct iwl_ops iwl3945_ops = {
 
 static struct iwl_base_params iwl3945_base_params = {
 	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
+	.num_of_queues = IWL39_NUM_QUEUES,
 	.pll_cfg_val = CSR39_ANA_PLL_CFG_VAL,
 	.set_l0s = false,
 	.use_bsm = true,
-- 
1.7.0.4

