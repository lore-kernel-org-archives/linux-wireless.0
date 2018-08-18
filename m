Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42134 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726452AbeHRLez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:34:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:43 +0300
Message-Id: <20180818082750.28717-10-luca@coelho.fi> (sfid-20180818_102816_763715_86F9BDE7)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 09/16] iwlwifi: add required include to iwl-fh.h
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Some variables are used in iwl-fh.h, but their type's definition
isn't included. This may break compilation when using the file
without including the necessary dependencies first.

Add the required include to iwl-fh.h.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index df0e9ffff706..4f7254303853 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -68,6 +68,8 @@
 #include <linux/types.h>
 #include <linux/bitfield.h>
 
+#include "iwl-trans.h"
+
 /****************************/
 /* Flow Handler Definitions */
 /****************************/
-- 
2.18.0
