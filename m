Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42308 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751525AbdHEIpZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:35 +0300
Message-Id: <20170805084438.12550-8-luca@coelho.fi> (sfid-20170805_104546_235849_2036BECA)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 07/10] mac80211: add api to start ba session timer expired flow
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

Some drivers handle rx buffer reordering internally (and by extension
handle also the rx ba session timer internally), but do not ofload the
addba/delba negotiation.
Add an api for these drivers to properly tear-down the ba session,
including sending a delba.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 15 +++++++++++++++
 net/mac80211/agg-rx.c  | 22 +++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b2b5419467cc..64f5abb02030 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5499,6 +5499,21 @@ static inline void ieee80211_stop_rx_ba_session_offl(struct ieee80211_vif *vif,
 	ieee80211_manage_rx_ba_offl(vif, addr, tid + IEEE80211_NUM_TIDS);
 }
 
+/**
+ * ieee80211_rx_ba_timer_expired - stop a Rx BA session due to timeout
+ *
+ * Some device drivers do not offload AddBa/DelBa negotiation, but handle rx
+ * buffer reording internally, and therefore also handle the session timer.
+ *
+ * Trigger the timeout flow, which sends a DelBa.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
+ * @addr: station mac address
+ * @tid: the rx tid
+ */
+void ieee80211_rx_ba_timer_expired(struct ieee80211_vif *vif,
+				   const u8 *addr, unsigned int bit);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 8708cbe8af5b..34599bd38991 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -7,7 +7,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015-2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -466,3 +466,23 @@ void ieee80211_manage_rx_ba_offl(struct ieee80211_vif *vif,
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_manage_rx_ba_offl);
+
+void ieee80211_rx_ba_timer_expired(struct ieee80211_vif *vif,
+				   const u8 *addr, unsigned int bit)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	sta = sta_info_get_bss(sdata, addr);
+	if (!sta)
+		goto unlock;
+
+	set_bit(bit, sta->ampdu_mlme.tid_rx_timer_expired);
+	ieee80211_queue_work(&local->hw, &sta->ampdu_mlme.work);
+
+ unlock:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_rx_ba_timer_expired);
-- 
2.13.2
