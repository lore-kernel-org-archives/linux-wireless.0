Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14135 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1ISH7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 03:59:22 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath6kl: Indicate the roaming capability of the firmware
Date: Mon, 19 Sep 2011 13:29:16 +0530
Message-ID: <1316419156-3228-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20110919_095926_389970_ACA2842E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the rssi of the current AP drops, both wpa_supplicant and the
firmware may do a background scan to find a better AP and try to
associate. This might lead to a race condition where both may try
to connect to some AP based on their scan results.

Since the firmware is capable of handling roaming, let
wpa_supplicant know about this capability so that it will back off
from bgscan based roaming.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 1834e9a..9a418f1 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1489,6 +1489,8 @@ static int ath6kl_init(struct net_device *dev)
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
+	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
+
 	status = ath6kl_target_config_wlan_params(ar);
 	if (!status)
 		goto ath6kl_init_done;
-- 
1.7.1

