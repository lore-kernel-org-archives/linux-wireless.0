Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41070 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1JAJ2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 05:28:15 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Enable force foreground scan in connected state
Date: Sat, 1 Oct 2011 14:55:07 +0530
Message-ID: <1317461107-5611-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111001_112820_660387_1CEEB355)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was disabled beacause there was a network stall
issue when scan is issued. This issue does not happen
with the new firmware, enable it back.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 8d9fbd4..c50697d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -639,6 +639,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	s8 n_channels = 0;
 	u16 *channels = NULL;
 	int ret = 0;
+	u32 force_fg_scan = 0;
 
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
@@ -700,7 +701,10 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			channels[i] = request->channels[i]->center_freq;
 	}
 
-	ret = ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
+	if (test_bit(CONNECTED, &ar->flag))
+		force_fg_scan = 1;
+
+	ret = ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, force_fg_scan,
 				       false, 0, 0, n_channels, channels);
 	if (ret)
 		ath6kl_err("wmi_startscan_cmd failed\n");
-- 
1.7.0.4

