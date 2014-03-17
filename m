Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60718 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaCQJdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 05:33:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/3] ath9k: Add QCA953x WMAC platform support
Date: Mon, 17 Mar 2014 15:02:46 +0530
Message-Id: <1395048768-25245-1-git-send-email-sujith@msujith.org> (sfid-20140317_103346_379885_2E2B20C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c | 4 ++++
 drivers/net/wireless/ath/ath9k/hw.c  | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 2dff276..61a1fff 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -39,6 +39,10 @@ static const struct platform_device_id ath9k_platform_id_table[] = {
 		.name = "qca955x_wmac",
 		.driver_data = AR9300_DEVID_QCA955X,
 	},
+	{
+		.name = "qca953x_wmac",
+		.driver_data = AR9300_DEVID_AR953X,
+	},
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f9cd9d3..d91403f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3047,6 +3047,7 @@ static struct {
 	{ AR_SREV_VERSION_9462,         "9462" },
 	{ AR_SREV_VERSION_9550,         "9550" },
 	{ AR_SREV_VERSION_9565,         "9565" },
+	{ AR_SREV_VERSION_9531,         "9531" },
 };
 
 /* For devices with external radios */
-- 
1.9.0

