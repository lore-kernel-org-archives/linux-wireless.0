Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36360 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbcKIFuy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 00:50:54 -0500
Received: by mail-pf0-f194.google.com with SMTP id n85so22252461pfi.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2016 21:50:54 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Tue, 8 Nov 2016 21:50:48 -0800
To: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Eran Harary <eran.harary@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Eyal Shapira <eyal@wizery.com>,
        Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH v2 3/3] iwlwifi: pcie: trans: Remove unused 'shift_param'
Message-ID: <20161109055048.GA27520@google.com> (sfid-20161109_065059_019575_CBE6729A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

shift_param is defined and set in iwl_pcie_load_cpu_sections
but not used. Fix this to avoid -Wunused-but-set-variable
warning.
The code using it turned into dead code with commit dcab8ecd5617
which added a separate function iwl_pcie_load_given_ucode_8000
(then 8000b) for IWL_DEVICE_FAMILY_8000. Commit 76f8c0e17edc
removed the dead code but left shift_param as is.

iwlwifi/pcie/trans.c: In function ‘iwl_pcie_load_cpu_sections’:
iwlwifi/pcie/trans.c:871:6: warning: variable ‘shift_param’ set but not used [-Wunused-but-set-variable]

Fixes: dcab8ecd5617 (iwlwifi: mvm: support ucode load for family_8000 B0 only)
Fixes: 76f8c0e17edc (iwlwifi: pcie: remove dead code)

Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
Cc: Sara Sharon <sara.sharon@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Eran Harary <eran.harary@intel.com>
Cc: Liad Kaufman <liad.kaufman@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ae95533..1b27a39 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -868,15 +868,12 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 				      int cpu,
 				      int *first_ucode_section)
 {
-	int shift_param;
 	int i, ret = 0;
 	u32 last_read_idx = 0;
 
 	if (cpu == 1) {
-		shift_param = 0;
 		*first_ucode_section = 0;
 	} else {
-		shift_param = 16;
 		(*first_ucode_section)++;
 	}
 
-- 
2.8.0.rc3.226.g39d4020
