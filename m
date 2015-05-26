Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbbEZTSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/39] iwlwifi: mvm: Configure agg. queue before assigning it to STA
Date: Tue, 26 May 2015 22:17:27 +0300
Message-Id: <1432667872-18092-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211828_390501_E06E18C6)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

In order to imeplement the extended VI session feature for Miracast, the FW
requires to detect the VI queue. The detection of the VI queue is done when
it is assigned to a STA with ADD_STA command, so by this time the FW expects
the queue to be already configured (mapped to VI AC and aggregation enabled).
Previously, the queue configuration was done after STA modificaton which
broke the extended VI session feature and resulted in higher latencies.
Fix this by calling iwl_mvm_enable_agg_txq before station modification.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 1845b79..d68dc69 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -5,8 +5,8 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,8 +31,8 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1000,13 +1000,13 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
+	iwl_mvm_enable_agg_txq(mvm, queue, fifo, mvmsta->sta_id, tid,
+			       buf_size, ssn, wdg_timeout);
+
 	ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
 	if (ret)
 		return -EIO;
 
-	iwl_mvm_enable_agg_txq(mvm, queue, fifo, mvmsta->sta_id, tid,
-			       buf_size, ssn, wdg_timeout);
-
 	/*
 	 * Even though in theory the peer could have different
 	 * aggregation reorder buffer sizes for different sessions,
-- 
2.1.4

