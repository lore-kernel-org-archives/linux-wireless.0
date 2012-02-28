Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20061 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab2B1Oub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 09:50:31 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V3 2/5] ath6kl: Initialize netdev hw_features for every interface
Date: Tue, 28 Feb 2012 20:20:20 +0530
Message-ID: <1330440623-5649-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120228_155034_459053_79D42DB3)
In-Reply-To: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move netdev->hw_features setting from ath6kl_core_init() to
init_netdev() so that it is done for every interface.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c |    2 --
 drivers/net/wireless/ath/ath6kl/main.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index d078aed..d5c06c0 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -156,8 +156,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	set_bit(FIRST_BOOT, &ar->flag);
 
-	ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
-
 	ret = ath6kl_init_hw_start(ar);
 	if (ret) {
 		ath6kl_err("Failed to start hardware: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0d6e352..f804cf1 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1212,5 +1212,7 @@ void init_netdev(struct net_device *dev)
 				sizeof(struct wmi_data_hdr) + HTC_HDR_LENGTH
 				+ WMI_MAX_TX_META_SZ + ATH6KL_HTC_ALIGN_BYTES;
 
+	dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+
 	return;
 }
-- 
1.7.0.4

