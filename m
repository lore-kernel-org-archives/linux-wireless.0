Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38724 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730428AbeG0O1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:27:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 16:05:42 +0300
Message-Id: <20180727130542.28530-1-luca@coelho.fi> (sfid-20180727_150551_128111_CF7302A0)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 14/16] iwlwifi: pcie: include tcp.h implicitly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If CONFIG_IPV6 is not enabled in the kernel, tcp.h is not included
implicitly from other header files, causing compilation errors.  To
solve that, explicitly include it in tx-gen2.c.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index e3ae7f91206b..64db540ad605 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -52,6 +52,7 @@
  *****************************************************************************/
 #include <linux/pm_runtime.h>
 #include <net/tso.h>
+#include <linux/tcp.h>
 
 #include "iwl-debug.h"
 #include "iwl-csr.h"
-- 
2.18.0
