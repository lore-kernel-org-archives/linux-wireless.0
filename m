Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55960 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935782AbcISHbf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:31:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:19 +0300
Message-Id: <20160919073028.22065-16-luca@coelho.fi> (sfid-20160919_093139_089074_7931B9D9)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: don't export trace points that are used in iwlwifi only
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This can save a few bytes

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
index 1d9dd153..50510fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
@@ -33,9 +33,6 @@
 #define CREATE_TRACE_POINTS
 #include "iwl-devtrace.h"
 
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite8);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ioread32);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_cont_event);
-- 
2.9.3
