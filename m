Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33533 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753456AbcJMMWY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 08:22:24 -0400
Received: by mail-pf0-f193.google.com with SMTP id i85so1585103pfa.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 05:21:18 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/3] rsi: Fix memory leak in module unload
Date: Thu, 13 Oct 2016 16:55:46 +0530
Message-Id: <1476357946-15460-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161013_142227_626584_042D229A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Observed crash when module is unloaded if CONFIG_RSI_DEBUGSFS is not set.
	Fix: Debugfs entry removal moved inside CONFIG_RSI_DEBUGSFS flag in
             function rsi_mac80211_detach()
Memory leak found and fixed for below structures in function rsi_mac80211_detach()
	* channel list for each supported band
	* rsi debugfs info

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..58779c0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -194,6 +194,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 void rsi_mac80211_detach(struct rsi_hw *adapter)
 {
 	struct ieee80211_hw *hw = adapter->hw;
+	enum nl80211_band band;
 
 	if (hw) {
 		ieee80211_stop_queues(hw);
@@ -201,7 +202,17 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
 		ieee80211_free_hw(hw);
 	}
 
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		struct ieee80211_supported_band *sband =
+					&adapter->sbands[band];
+
+		kfree(sband->channels);
+	}
+
+#ifdef CONFIG_RSI_DEBUGFS
 	rsi_remove_dbgfs(adapter);
+	kfree(adapter->dfsentry);
+#endif
 }
 EXPORT_SYMBOL_GPL(rsi_mac80211_detach);
 
-- 
2.4.11
