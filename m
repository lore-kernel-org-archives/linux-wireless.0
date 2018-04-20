Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40606 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754536AbeDTKtf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:49:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 20 Apr 2018 13:49:19 +0300
Message-Id: <20180420104926.8816-3-luca@coelho.fi> (sfid-20180420_125011_827054_7CCBD552)
In-Reply-To: <20180420104926.8816-1-luca@coelho.fi>
References: <20180420104926.8816-1-luca@coelho.fi>
Subject: [PATCH 2/9] mac80211: use timeout from the AddBA response instead of the request
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

2016 spec, section 10.24.2 specifies that the block ack
timeout in the ADD BA request is advisory.

That means we should check the value in the response and
act upon it (same as buffer size).

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/agg-tx.c | 4 ++++
 net/mac80211/tx.c     | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 595c662a61e8..ac4295296514 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -8,6 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -970,6 +971,9 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
+		tid_tx->timeout =
+			le16_to_cpu(mgmt->u.action.u.addba_resp.timeout);
+
 		if (tid_tx->timeout) {
 			mod_timer(&tid_tx->session_timer,
 				  TU_TO_EXP_TIME(tid_tx->timeout));
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 535de3161a78..05a265cd573d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1135,7 +1136,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 	}
 
 	/* reset session timer */
-	if (reset_agg_timer && tid_tx->timeout)
+	if (reset_agg_timer)
 		tid_tx->last_tx = jiffies;
 
 	return queued;
-- 
2.17.0
