Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52755 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1JYKKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:10:24 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 01/34] ath6kl: Pass ath6kl structure to ath6kl_init() instead of net_device
Date: Tue, 25 Oct 2011 15:39:57 +0530
Message-ID: <1319537430-12459-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121028_840131_89AEFACC)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ar is again taken from private area of net_device in ath6kl_init(), pass
ar directly.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d161862..34f8b78 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1461,9 +1461,8 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_init(struct net_device *dev)
+static int ath6kl_init(struct ath6kl *ar)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
 	int status = 0;
 	s32 timeleft;
 
@@ -1631,7 +1630,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (ret)
 		goto err_htc_cleanup;
 
-	ret = ath6kl_init(ar->net_dev);
+	ret = ath6kl_init(ar);
 	if (ret)
 		goto err_htc_cleanup;
 
-- 
1.7.0.4

