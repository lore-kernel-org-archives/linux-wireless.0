Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:64125 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934058AbaGPNaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 09:30:09 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so930278wes.6
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 06:30:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, svens@stackframe.org,
	vh.nguyen@actiasodielec.fr, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 2/2] ath10k: don't start monitor vdev for promisc
Date: Wed, 16 Jul 2014 15:21:13 +0200
Message-Id: <1405516873-26411-2-git-send-email-michal.kazior@tieto.com> (sfid-20140716_153018_177088_186CB060)
In-Reply-To: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com>
References: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k doesn't apply any extra rx filters so
there's no need to start monitor vdev for
promiscuous mode.

This fixes crashes with 4addr station interface
bridging and some very rare crashes of AP
interfaces with bridging as well.

Reported-by: Sven Schnelle <svens@stackframe.org>
Reported-by: Vu Hai NGUYEN <vh.nguyen@actiasodielec.fr>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 83a5fa9..d5cba97 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -432,7 +432,6 @@ struct ath10k {
 	struct cfg80211_chan_def chandef;
 
 	int free_vdev_map;
-	bool promisc;
 	bool monitor;
 	int monitor_vdev_id;
 	bool monitor_started;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2a1c710..f9ab878 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -688,7 +688,7 @@ static int ath10k_monitor_recalc(struct ath10k *ar)
 {
 	bool should_start;
 
-	should_start = ar->promisc || ar->monitor ||
+	should_start = ar->monitor ||
 		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 
 	ath10k_dbg(ATH10K_DBG_MAC,
@@ -2308,7 +2308,6 @@ void ath10k_halt(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
-	ar->promisc = false;
 	ar->monitor = false;
 
 	if (ar->monitor_started)
@@ -2917,7 +2916,6 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 				    u64 multicast)
 {
 	struct ath10k *ar = hw->priv;
-	int ret;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -2925,11 +2923,6 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 	ar->filter_flags = *total_flags;
 
-	ar->promisc = !!(ar->filter_flags & FIF_PROMISC_IN_BSS);
-	ret = ath10k_monitor_recalc(ar);
-	if (ret)
-		ath10k_warn("failed to recalc montior: %d\n", ret);
-
 	mutex_unlock(&ar->conf_mutex);
 }
 
-- 
1.8.5.3

