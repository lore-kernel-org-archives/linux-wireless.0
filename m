Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60652 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3J3LpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:16 -0400
Received: by mail-ee0-f45.google.com with SMTP id e50so571778eek.32
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:15 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 06/12] ath10k: fix ath10k_ce_init() failpath
Date: Wed, 30 Oct 2013 12:42:20 +0100
Message-Id: <1383133346-8135-7-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124527_223021_8005E69B)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure to put target back to sleep. This was a
minor issue as it didn't really matter if we put
target back to sleep at this point. It just looked
wrong.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 7a49cde..657e8f2 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1077,7 +1077,7 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 	ce_state = ath10k_ce_init_state(ar, ce_id, attr);
 	if (!ce_state) {
 		ath10k_err("Failed to initialize CE state for ID: %d\n", ce_id);
-		return NULL;
+		goto out;
 	}
 
 	if (attr->src_nentries) {
@@ -1086,7 +1086,8 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 			ath10k_err("Failed to initialize CE src ring for ID: %d (%d)\n",
 				   ce_id, ret);
 			ath10k_ce_deinit(ce_state);
-			return NULL;
+			ce_state = NULL;
+			goto out;
 		}
 	}
 
@@ -1096,15 +1097,16 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 			ath10k_err("Failed to initialize CE dest ring for ID: %d (%d)\n",
 				   ce_id, ret);
 			ath10k_ce_deinit(ce_state);
-			return NULL;
+			ce_state = NULL;
+			goto out;
 		}
 	}
 
 	/* Enable CE error interrupts */
 	ath10k_ce_error_intr_enable(ar, ctrl_addr);
 
+out:
 	ath10k_pci_sleep(ar);
-
 	return ce_state;
 }
 
-- 
1.8.4.rc3

