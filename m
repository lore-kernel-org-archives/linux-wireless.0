Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0JMWsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:48:54 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id o9DMmrVm019360
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:53 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpaz29.hot.corp.google.com with ESMTP id o9DMmq8q012845
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:53 -0700
From: Paul Stewart <pstew@google.com>
Date: Wed, 13 Oct 2010 15:21:27 -0700
Subject: [PATCH 6/6] Work proc for bitrate changes
To: linux-wireless@vger.kernel.org
Message-Id: <20101013224851.E3E5B2093C@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Paul Stewart <pstew@google.com>

---
 net/mac80211/main.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5162303..e617b17 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -339,6 +339,16 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 	mutex_unlock(&local->iflist_mtx);
 }
 
+static void ieee80211_rate_notify_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, rate_notify);
+
+	mutex_lock(&local->iflist_mtx);
+	ieee80211_cqm_bitrate_notify(local);
+	mutex_unlock(&local->iflist_mtx);
+}
+
 #ifdef CONFIG_INET
 static int ieee80211_ifa_changed(struct notifier_block *nb,
 				 unsigned long data, void *arg)
@@ -565,6 +575,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
 	INIT_WORK(&local->recalc_smps, ieee80211_recalc_smps_work);
+	INIT_WORK(&local->rate_notify, ieee80211_rate_notify_work);
 	local->smps_mode = IEEE80211_SMPS_OFF;
 
 	INIT_WORK(&local->dynamic_ps_enable_work,
-- 
1.7.1

