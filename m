Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54734 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752633AbcIOSLp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:11 +0300
Message-Id: <20160915181131.32213-5-luca@coelho.fi> (sfid-20160915_201152_904279_3C663F47)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: mvm: remove dump of locked registers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Firmware may lock those registers for access. This results
in 9000 devices with a bus stall and an endless loop of 0x5a5a5a.
Don't dump those registers.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 1abcabb..bebb148 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -440,14 +440,12 @@ static const struct iwl_prph_range iwl_prph_dump_addr_comm[] = {
 	{ .start = 0x00a04560, .end = 0x00a0457c },
 	{ .start = 0x00a04590, .end = 0x00a04598 },
 	{ .start = 0x00a045c0, .end = 0x00a045f4 },
-	{ .start = 0x00a44000, .end = 0x00a7bf80 },
 };
 
 static const struct iwl_prph_range iwl_prph_dump_addr_9000[] = {
 	{ .start = 0x00a05c00, .end = 0x00a05c18 },
 	{ .start = 0x00a05400, .end = 0x00a056e8 },
 	{ .start = 0x00a08000, .end = 0x00a098bc },
-	{ .start = 0x00adfc00, .end = 0x00adfd1c },
 	{ .start = 0x00a02400, .end = 0x00a02758 },
 };
 
-- 
2.9.3
