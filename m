Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32057 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2C1NUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 09:20:50 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Store scan request info in-advance before sending SCAN request
Date: Wed, 28 Mar 2012 18:50:35 +0530
Message-ID: <1332940835-14933-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120328_152104_318900_44867F36)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

In current code, Scan request info is recorded in vif->scan_req
after sending SCAN request to the firmware in ath6kl_cfg80211_scan().

In some corner cases, firmware sends SCAN_COMPLETE event immediately
when it receives SCAN request, which internally executes scan
complete event handler ath6kl_cfg80211_scan_complete_event() first.
So, Scan completion handler will a get a chance to executed even
before storing scan request info in ath6kl_cfg80211_scan().

Scan completion handler never report SCAN_COMPLETE event to
cfg80211 if scan request info(vif->scan_req) is NULL. This leads
to scan failure issue ("Device or resource busy error") during
next SCAN request from the user space. This patch ensures that scan
request info is stored before sending SCAN request.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index df95e0d..dd07ae5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -941,6 +941,8 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	if (test_bit(CONNECTED, &vif->flags))
 		force_fg_scan = 1;
 
+	vif->scan_req = request;
+
 	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
 		     ar->fw_capabilities)) {
 		/*
@@ -963,10 +965,10 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 						ATH6KL_FG_SCAN_INTERVAL,
 						n_channels, channels);
 	}
-	if (ret)
+	if (ret) {
 		ath6kl_err("wmi_startscan_cmd failed\n");
-	else
-		vif->scan_req = request;
+		vif->scan_req = NULL;
+	}
 
 	kfree(channels);
 
-- 
1.7.1

