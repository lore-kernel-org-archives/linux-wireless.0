Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43138 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdLIAfN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 19:35:13 -0500
Received: by mail-pg0-f67.google.com with SMTP id b18so7899246pgv.10
        for <linux-wireless@vger.kernel.org>; Fri, 08 Dec 2017 16:35:12 -0800 (PST)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wcn36xx: Reduce spinlock in indication handler
Date: Fri,  8 Dec 2017 16:35:08 -0800
Message-Id: <20171209003508.3507-1-bjorn.andersson@linaro.org> (sfid-20171209_013534_899177_B37D1831)
In-Reply-To: <1512725730-19188-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The purpose of pushing indication on a list and handle these in a
separate worker is to allow the handlers to sleep. It does therefor not
make much sense to hold the queue spinlock through the entire indication
worker function.

By removing items from the queue early we don't need to hold the lock
throughout the indication worker, allowing the individual handlers to
sleep.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index fa88a2a460aa..52daae863aed 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2414,6 +2414,8 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
 	hal_ind_msg = list_first_entry(&wcn->hal_ind_queue,
 				       struct wcn36xx_hal_ind_msg,
 				       list);
+	list_del(wcn->hal_ind_queue.next);
+	spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
 
 	msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
 
@@ -2450,8 +2452,6 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
 			      msg_header->msg_type);
 	}
-	list_del(wcn->hal_ind_queue.next);
-	spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
 	kfree(hal_ind_msg);
 }
 int wcn36xx_smd_open(struct wcn36xx *wcn)
-- 
2.15.0
