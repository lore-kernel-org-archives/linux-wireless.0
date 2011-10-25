Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1JYOEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:04:13 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 01/31] ath6kl: Pass ath6kl structure to ath6kl_init() instead of net_device
Date: Tue, 25 Oct 2011 19:33:56 +0530
Message-ID: <1319551466-29070-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160417_465823_C2CCD9C1)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
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
index 1700423..5fd1693 100644
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

