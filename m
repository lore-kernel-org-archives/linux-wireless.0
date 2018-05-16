Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35598 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbeEPOIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:44 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 08/10] wcn36xx: drain pending indicator messages on shutdown
Date: Wed, 16 May 2018 16:08:18 +0200
Message-Id: <20180516140820.1636-9-daniel@zonque.org> (sfid-20180516_160855_032048_C4DD73C6)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the interface is shut down, wcn36xx_smd_close() potentially races
against the queue worker. Make sure to cancel the work, and then free all
the remnants in hal_ind_queue manually.

This is again just a theoretical issue, not something that was triggered in
the wild.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index ea74f2b92df5..0a505b5e038b 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2513,5 +2513,11 @@ int wcn36xx_smd_open(struct wcn36xx *wcn)
 
 void wcn36xx_smd_close(struct wcn36xx *wcn)
 {
+	struct wcn36xx_hal_ind_msg *msg, *tmp;
+
+	cancel_work_sync(&wcn->hal_ind_work);
 	destroy_workqueue(wcn->hal_ind_wq);
+
+	list_for_each_entry_safe(msg, tmp, &wcn->hal_ind_queue, list)
+		kfree(msg);
 }
-- 
2.14.3
