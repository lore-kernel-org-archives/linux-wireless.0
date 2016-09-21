Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36676 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbcIUGCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 02:02:36 -0400
Received: by mail-pf0-f196.google.com with SMTP id n24so1905226pfb.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 23:02:35 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.j04cs@gmail.com
Subject: [PATCH] rsi: fix memory lean in module unload
Date: Wed, 21 Sep 2016 11:29:06 +0530
Message-Id: <1474437546-6590-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20160921_080239_797464_1D409726)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved debugfs entry removal under CONFIG_RSI_DEBUGFS flag
Added freeing of below structures
 * channels list in each supported band
 * rsi debugfs info

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..f4bbf15 100644
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
 
+	for (band = 0; band < 2; band++) {
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
