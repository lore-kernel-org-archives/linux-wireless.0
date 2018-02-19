Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59764 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752917AbeBSMtD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:49:03 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:48:43 +0200
Message-Id: <20180219124847.27169-10-luca@coelho.fi> (sfid-20180219_134913_813942_D2E9C192)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 09/13] mac80211: Fix sending ADDBA response for an ongoing session
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

In case an ADDBA request is received while there is already
an ongoing BA sessions with the same parameters, i.e., update
flow, an ADBBA response with decline status was sent twice. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/agg-rx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a8b1616cec41..1f3188d03840 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -8,6 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
+ * Copyright (C) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -304,9 +305,6 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 			 * driver so reject the timeout update.
 			 */
 			status = WLAN_STATUS_REQUEST_DECLINED;
-			ieee80211_send_addba_resp(sta->sdata, sta->sta.addr,
-						  tid, dialog_token, status,
-						  1, buf_size, timeout);
 			goto end;
 		}
 
-- 
2.15.1
