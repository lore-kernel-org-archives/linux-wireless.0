Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12843 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab2JLMKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 08:10:53 -0400
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix a mismatch in power management debug message
Date: Fri, 12 Oct 2012 17:40:41 +0530
Message-ID: <1350043841-2080-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121012_141056_518743_C4E6C28E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Power Save Enabled : REC_POWER - conserve power
without sacrificing performance.
Power Save Disabled : MAX_PERF_POWER - maximum
performance at the expense of power.
Hence fix the debug message.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d6e6c2d..1e62776 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1452,10 +1452,10 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 		return -EIO;
 
 	if (pmgmt) {
-		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: max perf\n", __func__);
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: rec power\n", __func__);
 		mode.pwr_mode = REC_POWER;
 	} else {
-		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: rec power\n", __func__);
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: max perf\n", __func__);
 		mode.pwr_mode = MAX_PERF_POWER;
 	}
 
-- 
1.7.0.4

