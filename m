Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:37076 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753070AbeDQNX6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 09:23:58 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v2 2/5] wcn36xx: cancel pending scan request when interface goes down
Date: Tue, 17 Apr 2018 15:23:34 +0200
Message-Id: <20180417132337.31720-3-daniel@zonque.org> (sfid-20180417_152402_642654_B8E73BFB)
In-Reply-To: <20180417132337.31720-1-daniel@zonque.org>
References: <20180417132337.31720-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the network interface goes down while a scan request is still
pending that can't be stopped due to firmware hickups, wcn->scan_req
remains set, even though the hardware is deinitialized. This results
in -EBUSY for all scan requests after the interface was brought up
again.

Fix this by explicitly completing pending scan requests in
wcn36xx_stop().

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 749aef3e2b85..08b6939d3f57 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -353,6 +353,19 @@ static void wcn36xx_stop(struct ieee80211_hw *hw)
 
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac stop\n");
 
+	cancel_work_sync(&wcn->scan_work);
+
+	mutex_lock(&wcn->scan_lock);
+	if (wcn->scan_req) {
+		struct cfg80211_scan_info scan_info = {
+			.aborted = true,
+		};
+
+		ieee80211_scan_completed(wcn->hw, &scan_info);
+	}
+	wcn->scan_req = NULL;
+	mutex_unlock(&wcn->scan_lock);
+
 	wcn36xx_debugfs_exit(wcn);
 	wcn36xx_smd_stop(wcn);
 	wcn36xx_dxe_deinit(wcn);
-- 
2.14.3
