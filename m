Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35608 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752253AbeEPOIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:46 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 09/10] wcn36xx: simplify wcn36xx_smd_open()
Date: Wed, 16 May 2018 16:08:19 +0200
Message-Id: <20180516140820.1636-10-daniel@zonque.org> (sfid-20180516_160855_606041_DA79FEF6)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop the extra warning about failed allocations, both the core and the
only caller of this function will warn loud enough in such cases.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 0a505b5e038b..43c8aa79fad4 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2494,21 +2494,15 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
 }
 int wcn36xx_smd_open(struct wcn36xx *wcn)
 {
-	int ret = 0;
 	wcn->hal_ind_wq = create_freezable_workqueue("wcn36xx_smd_ind");
-	if (!wcn->hal_ind_wq) {
-		wcn36xx_err("failed to allocate wq\n");
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!wcn->hal_ind_wq)
+		return -ENOMEM;
+
 	INIT_WORK(&wcn->hal_ind_work, wcn36xx_ind_smd_work);
 	INIT_LIST_HEAD(&wcn->hal_ind_queue);
 	spin_lock_init(&wcn->hal_ind_lock);
 
 	return 0;
-
-out:
-	return ret;
 }
 
 void wcn36xx_smd_close(struct wcn36xx *wcn)
-- 
2.14.3
