Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751546AbdAWWSx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:18:53 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Kirtika Ruchandani <kirtika.ruchandani@gmail.com>,
        Kirtika Ruchandani <kirtika@google.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 24 Jan 2017 00:03:43 +0200
Message-Id: <20170123220350.25305-19-luca@coelho.fi> (sfid-20170123_231856_241764_A38E9FF1)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 18/25] iwlwifi: pcie: trans: Remove unused 'shift_param'
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>

shift_param is defined and set in iwl_pcie_load_cpu_sections but not
used. Fix this to avoid -Wunused-but-set-variable warning.

The code using it turned into dead code with commit dcab8ecd5617
("iwlwifi: mvm: support ucode load for family_8000 B0 only") which
added a separate function iwl_pcie_load_given_ucode_8000 (then 8000b)
for IWL_DEVICE_FAMILY_8000. Commit 76f8c0e17edc ("iwlwifi: pcie:
remove dead code") removed the dead code but left shift_param as is.

iwlwifi/pcie/trans.c: In function ‘iwl_pcie_load_cpu_sections’:
iwlwifi/pcie/trans.c:871:6: warning: variable ‘shift_param’ set but not used [-Wunused-but-set-variable]

Fixes: dcab8ecd5617 ("iwlwifi: mvm: support ucode load for family_8000 B0 only")
Fixes: 76f8c0e17edc ("iwlwifi: pcie: remove dead code")
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
Cc: Sara Sharon <sara.sharon@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Liad Kaufman <liad.kaufman@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[removed some unnecessary braces]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bf0ecdcf7402..16790db650c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -868,17 +868,13 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 				      int cpu,
 				      int *first_ucode_section)
 {
-	int shift_param;
 	int i, ret = 0;
 	u32 last_read_idx = 0;
 
-	if (cpu == 1) {
-		shift_param = 0;
+	if (cpu == 1)
 		*first_ucode_section = 0;
-	} else {
-		shift_param = 16;
+	else
 		(*first_ucode_section)++;
-	}
 
 	for (i = *first_ucode_section; i < image->num_sec; i++) {
 		last_read_idx = i;
-- 
2.11.0
