Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36489 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbcITGq0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 02:46:26 -0400
Received: by mail-pf0-f194.google.com with SMTP id n24so493718pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 23:46:26 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de,
        Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/1] rsi: fix memory leak in debugfs entry and supported bands
Date: Tue, 20 Sep 2016 12:13:04 +0530
Message-Id: <1474353784-9552-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20160920_084630_708463_3BBB9B2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>

Signed-off-by: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..dc64532 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -194,6 +194,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 void rsi_mac80211_detach(struct rsi_hw *adapter)
 {
 	struct ieee80211_hw *hw = adapter->hw;
+	int i;
 
 	if (hw) {
 		ieee80211_stop_queues(hw);
@@ -201,7 +202,16 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
 		ieee80211_free_hw(hw);
 	}
 
+	for (i = 0; i < 2; i++) {
+		struct ieee80211_supported_band *sbands = &adapter->sbands[i];
+
+		kfree(sbands->channels);
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
