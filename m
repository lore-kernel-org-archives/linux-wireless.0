Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17116 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1HDN5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 09:57:00 -0400
From: <rmani@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Release the memory allocated for the firmware
Date: Thu, 4 Aug 2011 19:26:30 +0530
Message-ID: <1312466190-2394-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20110804_155702_702209_395B0299)
In-Reply-To: <1312466190-2394-1-git-send-email-rmani@qca.qualcomm.com>
References: <1312466190-2394-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

 Nowhere the firmware memory is freed, free it during
 the device destroy process.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e8ec617..99ff2f9 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1294,5 +1294,10 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 
 	wlan_node_table_cleanup(&ar->scan_table);
 
+	kfree(ar->fw_board);
+	kfree(ar->fw_otp);
+	kfree(ar->fw);
+	kfree(ar->fw_patch);
+
 	ath6kl_cfg80211_deinit(ar);
 }
-- 
1.7.4.1

