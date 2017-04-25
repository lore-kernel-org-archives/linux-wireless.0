Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54148 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954154AbdDYUXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:23 +0300
Message-Id: <20170425202243.7844-6-luca@coelho.fi> (sfid-20170425_222324_517064_06323309)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: mvm: handle possible BIOS bug
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

In iwl_mvm_sar_get_ewrd_table() In case of a BIOS bug, n_profiles
might be 0 thus we need to return an error value.  Found by Klocwork.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index b5c7dffafdc1..e6c9528eeeda 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1201,6 +1201,12 @@ static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
 	enabled = !!(wifi_pkg->package.elements[1].integer.value);
 	n_profiles = wifi_pkg->package.elements[2].integer.value;
 
+	/* in case of BIOS bug */
+	if (n_profiles <= 0) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
 	for (i = 0; i < n_profiles; i++) {
 		/* the tables start at element 3 */
 		static int pos = 3;
-- 
2.11.0
