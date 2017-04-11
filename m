Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50636 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752700AbdDKMiv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:31 +0300
Message-Id: <20170411123742.12214-15-luca@coelho.fi> (sfid-20170411_144104_524035_530CD72E)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: mvm: optimize reorder timeout frame releasing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently we release up to the last expired frame.
However, if there are consecutive frames after it - we can
optimize it further and release them as well - until the next
hole.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d79e9c2a2654..85f7c83995b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -462,6 +462,7 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 	int i;
 	u16 sn = 0, index = 0;
 	bool expired = false;
+	bool cont = false;
 
 	spin_lock(&buf->lock);
 
@@ -473,12 +474,21 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 	for (i = 0; i < buf->buf_size ; i++) {
 		index = (buf->head_sn + i) % buf->buf_size;
 
-		if (skb_queue_empty(&buf->entries[index]))
+		if (skb_queue_empty(&buf->entries[index])) {
+			/*
+			 * If there is a hole and the next frame didn't expire
+			 * we want to break and not advance SN
+			 */
+			cont = false;
 			continue;
-		if (!time_after(jiffies, buf->reorder_time[index] +
-				RX_REORDER_BUF_TIMEOUT_MQ))
+		}
+		if (!cont && !time_after(jiffies, buf->reorder_time[index] +
+					 RX_REORDER_BUF_TIMEOUT_MQ))
 			break;
+
 		expired = true;
+		/* continue until next hole after this expired frames */
+		cont = true;
 		sn = ieee80211_sn_add(buf->head_sn, i + 1);
 	}
 
-- 
2.11.0
