Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56604 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbcFJMkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:40:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 10 Jun 2016 15:39:53 +0300
Message-Id: <1465562397-1402-1-git-send-email-luca@coelho.fi> (sfid-20160610_144054_441787_E681D917)
In-Reply-To: <1465562195.29614.5.camel@coelho.fi>
References: <1465562195.29614.5.camel@coelho.fi>
Subject: [PATCH 1/5] iwlwifi: mvm: increase scan timeout to 20 seconds
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The 16 seconds timeout we were using turned out to be too short.
Recalculations by system show that the total time in both bands should
be < 18.5 seconds, even in the slowest cases (e.g. DCM P2P with
DTIM=2).  Rounding it up to 20 seconds for a bit more safety.

Fixes: 728e825f81b1 ("iwlwifi: mvm: add a scan timeout for regular scans")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 6f609dd..e78fc56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1222,7 +1222,7 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 	return -EIO;
 }
 
-#define SCAN_TIMEOUT (16 * HZ)
+#define SCAN_TIMEOUT (20 * HZ)
 
 void iwl_mvm_scan_timeout(unsigned long data)
 {
-- 
2.8.1

